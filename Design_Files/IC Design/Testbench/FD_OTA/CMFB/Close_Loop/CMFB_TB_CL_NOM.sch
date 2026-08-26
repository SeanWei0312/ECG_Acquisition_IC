v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 460 -1580 480 -1580 {lab=B}
N 460 -1620 480 -1620 {lab=VOUTCM}
N 640 -1580 720 -1580 {lab=CMFB_OUT}
N 460 -1540 480 -1540 {lab=CMFB_REF}
N 280 -1180 280 -1160 {lab=B}
N 100 -1480 100 -1460 {lab=CMFB_REF}
N 100 -1180 100 -1160 {lab=AGND}
N 280 -1100 280 -1080 {lab=AGND}
N 100 -1400 100 -1380 {lab=AGND}
N 560 -1520 560 -1500 {lab=AGND}
N 720 -1520 720 -1500 {lab=AGND}
N 440 -1180 440 -1160 {lab=CMFBBIAS}
N 440 -1100 440 -1080 {lab=AGND}
N 440 -1240 440 -1220 {lab=AGND}
N 440 -1320 440 -1300 {lab=VOUTBIAS}
N 760 -1170 760 -1150 {lab=VOUTCM}
N 760 -1090 760 -1070 {lab=VOUTBIAS}
N 700 -1140 720 -1140 {lab=CMFB_OUT}
N 700 -1100 720 -1100 {lab=CMFBBIAS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 560 -1640 0 0 {name=l2 lab=AVDD}
C {capa.sym} 720 -1550 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 460 -1580 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 460 -1540 0 0 {name=p4 sig_type=std_logic lab=CMFB_REF}
C {lab_wire.sym} 720 -1580 0 1 {name=p7 sig_type=std_logic lab=CMFB_OUT}
C {devices/code_shown.sym} 80 -950 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=0
"}
C {devices/code_shown.sym} 640 -950 0 0 {name=NGSPICE only_toplevel=true
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

quit
.endc
"}
C {devices/code_shown.sym} 80 -620 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27

.param VCM_REF_DC=\{AVDD_SET/2\}
.param VOUT_CM_BIAS=\{AVDD_SET/2\}
.param CMFB_OUT_BIAS=2.4833

.param PLANT_GAIN=500

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
C {isource.sym} 280 -1130 2 1 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 100 -1270 0 0 {name=VAVDD             value="dc \{AVDD_SET\} ac 0"                savecurrent=true}
C {vdd.sym} 100 -1300 0 0 {name=l9 lab=AVDD}
C {gnd.sym} 100 -1240 0 0 {name=l10 lab=0}
C {vsource.sym} 100 -1430 0 0 {name=VREF
value="dc \{VCM_REF_DC\} pwl(0 \{VCM_LOW\} \{LOW_HOLD\} \{VCM_LOW\} \{LOW_RETURN\} \{VCM_REF_DC\} \{HIGH_START\} \{VCM_REF_DC\} \{HIGH_RISE\} \{VCM_HIGH\} \{HIGH_HOLD\} \{VCM_HIGH\} \{HIGH_RETURN\} \{VCM_REF_DC\} \{TRAN_STOP\} \{VCM_REF_DC\}) ac 0"
savecurrent=falsePERIOD\}) ac 0" savecurrent=falsePERIOD\}) ac 0" savecurrent=false}
C {lab_wire.sym} 280 -1180 0 0 {name=p5 sig_type=std_logic lab=B}
C {lab_wire.sym} 100 -1480 0 0 {name=p6 sig_type=std_logic lab=CMFB_REF}
C {vsource.sym} 100 -1130 0 0 {name=VAVSS             value="dc \{AVSS_SET\} ac 0"                savecurrent=true}
C {gnd.sym} 100 -1100 0 0 {name=l11 lab=0}
C {lab_wire.sym} 100 -1180 0 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 100 -1380 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 280 -1080 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -1500 2 0 {name=p1 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 720 -1500 2 0 {name=p3 sig_type=std_logic lab=AGND}
C {vsource.sym} 440 -1270 0 0 {name=VOUTBIAS          value="dc \{VOUT_CM_BIAS\} ac 0"            savecurrent=false}
C {vsource.sym} 440 -1130 0 0 {name=VCMFBOUTBIAS      value="dc \{CMFB_OUT_BIAS\} ac 0"           savecurrent=false}
C {lab_wire.sym} 440 -1180 0 0 {name=p8 sig_type=std_logic lab=CMFBBIAS}
C {lab_wire.sym} 440 -1320 0 0 {name=p10 sig_type=std_logic lab=VOUTBIAS}
C {lab_wire.sym} 440 -1220 2 0 {name=p13 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 440 -1080 2 0 {name=p14 sig_type=std_logic lab=AGND}
C {vcvs.sym} 760 -1120 0 0 {name=EPLANT         value=\{PLANT_GAIN\}}
C {lab_wire.sym} 460 -1620 0 0 {name=p15 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 760 -1170 0 0 {name=p16 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 760 -1070 2 0 {name=p17 sig_type=std_logic lab=VOUTBIAS}
C {lab_wire.sym} 700 -1140 0 0 {name=p18 sig_type=std_logic lab=CMFB_OUT}
C {lab_wire.sym} 700 -1100 0 0 {name=p19 sig_type=std_logic lab=CMFBBIAS}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/CMFB/CMFB.sym} 340 -1420 0 0 {name=xCMFB1}
