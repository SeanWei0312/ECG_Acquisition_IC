v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 460 -1280 480 -1280 {lab=B}
N 460 -1320 480 -1320 {lab=VOUTCM}
N 640 -1280 720 -1280 {lab=CMFB_OUT}
N 460 -1240 480 -1240 {lab=CMFB_REF}
N 280 -880 280 -860 {lab=B}
N 100 -1180 100 -1160 {lab=CMFB_REF}
N 100 -880 100 -860 {lab=AGND}
N 280 -800 280 -780 {lab=AGND}
N 100 -1100 100 -1080 {lab=AGND}
N 560 -1220 560 -1200 {lab=AGND}
N 720 -1220 720 -1200 {lab=AGND}
N 440 -880 440 -860 {lab=CMFBBIAS}
N 440 -800 440 -780 {lab=AGND}
N 440 -940 440 -920 {lab=AGND}
N 440 -1020 440 -1000 {lab=VOUTBIAS}
N 760 -870 760 -850 {lab=VOUTCM}
N 760 -790 760 -770 {lab=VOUTBIAS}
N 700 -840 720 -840 {lab=CMFB_OUT}
N 700 -800 720 -800 {lab=CMFBBIAS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 560 -1340 0 0 {name=l2 lab=AVDD}
C {capa.sym} 720 -1250 0 0 {name=CL
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 460 -1280 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 460 -1240 0 0 {name=p4 sig_type=std_logic lab=CMFB_REF}
C {lab_wire.sym} 720 -1280 0 1 {name=p7 sig_type=std_logic lab=CMFB_OUT}
C {devices/code_shown.sym} 80 -720 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 1540 -1330 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.cl_op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.cl_dc.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.cl_tran.txt

let avdd_run = 3.3
let vcm_run  = avdd_run/2

alter @VAVDD[DC] = $&avdd_run
alter @VREF[DC]  = $&vcm_run

alter @VREF[ACMAG]  = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

* Operating point
op

let op_vdd     = v(avdd)-v(agnd)
let op_ref     = v(cmfb_ref)-v(agnd)
let op_voutcm  = v(voutcm)-v(agnd)
let op_vcmfb   = v(cmfb_out)-v(agnd)
let op_error   = op_voutcm-op_ref

let op_ibias   = 40e-6
let op_idd     = -vavdd#branch
let op_power   = op_vdd*op_idd

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.cl_op.txt op_vdd op_ref op_voutcm op_vcmfb op_error op_ibias op_idd op_power

* Closed-loop DC
dc VREF 0 3.3 0.01

let cl_ref     = v(cmfb_ref)-v(agnd)
let cl_voutcm  = v(voutcm)-v(agnd)
let cl_ideal   = cl_ref
let cl_vcmfb   = v(cmfb_out)-v(agnd)
let cl_error   = cl_voutcm-cl_ref

setscale cl_ref

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.cl_dc.txt cl_voutcm cl_ideal cl_vcmfb cl_error

reset
save all

* Closed-loop transient
tran 1n 10u

let tr_ref     = v(cmfb_ref)-v(agnd)
let tr_voutcm  = v(voutcm)-v(agnd)
let tr_vcmfb   = v(cmfb_out)-v(agnd)
let tr_error   = tr_voutcm-tr_ref

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.cl_tran.txt tr_ref tr_voutcm tr_vcmfb tr_error

.endc
"}
C {devices/code_shown.sym} 80 -620 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27

.param VCM_REF_DC=\{AVDD_SET/2\}
.param VOUT_CM_BIAS=\{AVDD_SET/2\}
.param CMFB_OUT_BIAS=2.4981

.param PLANT_GAIN=1

.param VCM_LOW=1.55
.param VCM_HIGH=1.75

.param LOW_HOLD=1u
.param LOW_RETURN=1.01u

.param HIGH_START=4u
.param HIGH_RISE=4.01u
.param HIGH_HOLD=6u
.param HIGH_RETURN=6.01u

.param TRAN_STOP=10u

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(CMFB_OUT)=\{CMFB_OUT_BIAS\} v(VOUTCM)=\{VCM_REF_DC\}
"}
C {isource.sym} 280 -830 2 1 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 100 -970 0 0 {name=VAVDD             value="dc \{AVDD_SET\} ac 0"                savecurrent=true}
C {vdd.sym} 100 -1000 0 0 {name=l9 lab=AVDD}
C {gnd.sym} 100 -940 0 0 {name=l10 lab=0}
C {vsource.sym} 100 -1130 0 0 {name=VREF
value="dc \{VCM_REF_DC\} pwl(0 \{VCM_LOW\} \{LOW_HOLD\} \{VCM_LOW\} \{LOW_RETURN\} \{VCM_REF_DC\} \{HIGH_START\} \{VCM_REF_DC\} \{HIGH_RISE\} \{VCM_HIGH\} \{HIGH_HOLD\} \{VCM_HIGH\} \{HIGH_RETURN\} \{VCM_REF_DC\} \{TRAN_STOP\} \{VCM_REF_DC\}) ac 0"
savecurrent=falsePERIOD\}) ac 0" savecurrent=falsePERIOD\}) ac 0" savecurrent=false}
C {lab_wire.sym} 280 -880 0 0 {name=p5 sig_type=std_logic lab=B}
C {lab_wire.sym} 100 -1180 0 0 {name=p6 sig_type=std_logic lab=CMFB_REF}
C {vsource.sym} 100 -830 0 0 {name=VAVSS             value="dc \{AVSS_SET\} ac 0"                savecurrent=true}
C {gnd.sym} 100 -800 0 0 {name=l11 lab=0}
C {lab_wire.sym} 100 -880 0 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 100 -1080 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 280 -780 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -1200 2 0 {name=p1 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 720 -1200 2 0 {name=p3 sig_type=std_logic lab=AGND}
C {vsource.sym} 440 -970 0 0 {name=VOUTBIAS          value="dc \{VOUT_CM_BIAS\} ac 0"            savecurrent=false}
C {vsource.sym} 440 -830 0 0 {name=VCMFBOUTBIAS      value="dc \{CMFB_OUT_BIAS\} ac 0"           savecurrent=false}
C {lab_wire.sym} 440 -880 0 0 {name=p8 sig_type=std_logic lab=CMFBBIAS}
C {lab_wire.sym} 440 -1020 0 0 {name=p10 sig_type=std_logic lab=VOUTBIAS}
C {lab_wire.sym} 440 -920 2 0 {name=p13 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 440 -780 2 0 {name=p14 sig_type=std_logic lab=AGND}
C {vcvs.sym} 760 -820 0 0 {name=EPLANT         value=\{PLANT_GAIN\}}
C {lab_wire.sym} 460 -1320 0 0 {name=p15 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 760 -870 0 0 {name=p16 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 760 -770 2 0 {name=p17 sig_type=std_logic lab=VOUTBIAS}
C {lab_wire.sym} 700 -840 0 0 {name=p18 sig_type=std_logic lab=CMFB_OUT}
C {lab_wire.sym} 700 -800 0 0 {name=p19 sig_type=std_logic lab=CMFBBIAS}
