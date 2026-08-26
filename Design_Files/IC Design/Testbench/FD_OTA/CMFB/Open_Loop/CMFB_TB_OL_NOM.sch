v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -300 {}
N 100 -1040 100 -1020 {lab=B}
N 480 -1240 500 -1240 {lab=B}
N 480 -1280 500 -1280 {lab=CMFB_IN}
N 480 -1200 500 -1200 {lab=CMFB_REF}
N 660 -1240 740 -1240 {lab=CMFB_OUT}
N 380 -1040 380 -1020 {lab=VCM}
N 380 -900 380 -880 {lab=VDIFF}
N 220 -900 220 -880 {lab=AGND}
N 580 -1180 580 -1160 {lab=AGND}
N 100 -960 100 -940 {lab=AGND}
N 380 -960 380 -940 {lab=AGND}
N 740 -1180 740 -1160 {lab=AGND}
N 380 -820 380 -800 {lab=AGND}
N 560 -1040 560 -1020 {lab=VOUTBIAS}
N 560 -900 560 -880 {lab=CMFBBIAS}
N 560 -960 560 -940 {lab=AGND}
N 560 -820 560 -800 {lab=AGND}
N 840 -1040 840 -1020 {lab=CMFB_REF}
N 840 -960 840 -940 {lab=VCM}
N 840 -900 840 -880 {lab=CMFB_IN}
N 840 -820 840 -800 {lab=VCM}
N 780 -1010 800 -1010 {lab=VDIFF}
N 780 -970 800 -970 {lab=AGND}
N 780 -870 800 -870 {lab=VDIFF}
N 780 -830 800 -830 {lab=AGND}
N 100 -900 100 -880 {lab=VOUTCM}
N 100 -820 100 -800 {lab=VOUTBIAS}
N 40 -870 60 -870 {lab=CMFB_OUT}
N 40 -830 60 -830 {lab=CMFBBIAS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 580 -1300 0 0 {name=l2 lab=AVDD}
C {isource.sym} 100 -990 2 1 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 220 -990 0 0 {name=VAVDD             value="dc \{AVDD_SET\} ac 0"               savecurrent=true}
C {vdd.sym} 220 -1020 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 220 -960 0 0 {name=l5 lab=0}
C {capa.sym} 740 -1210 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 380 -990 0 0 {name=VVCM              value="dc \{VCM_SET\} ac 0"                savecurrent=false}
C {vsource.sym} 380 -850 0 0 {name=VDIFF             value="dc 0 ac 1"                        savecurrent=false}
C {lab_wire.sym} 100 -1040 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 480 -1240 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 380 -1040 0 0 {name=p3 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 480 -1280 0 0 {name=p4 sig_type=std_logic lab=CMFB_IN}
C {lab_wire.sym} 380 -900 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 480 -1200 0 0 {name=p6 sig_type=std_logic lab=CMFB_REF}
C {lab_wire.sym} 740 -1240 0 1 {name=p7 sig_type=std_logic lab=CMFB_OUT}
C {devices/code_shown.sym} 80 -670 0 0 {name=MODELS
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
C {devices/code_shown.sym} 840 -670 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.ol_ac.txt

let avdd_run = 3.3
let vcm_run  = avdd_run/2

alter @VAVDD[DC] = $&avdd_run
alter @VVCM[DC]  = $&vcm_run
alter @VDIFF[DC] = 0

alter @VVCM[ACMAG]   = 0
alter @VDIFF[ACMAG]  = 1
alter @VDIFF[ACPHASE] = 0
alter @VAVDD[ACMAG]  = 0
alter @VAVSS[ACMAG]  = 0

* Open-loop AC
ac dec 200 1 100G

let error_ac = v(cmfb_ref)-v(cmfb_in)
let loop_ac  = v(voutcm)/error_ac

let loop_real = real(loop_ac)
let loop_imag = imag(loop_ac)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.ol_ac.txt loop_real loop_imag

quit
.endc
"}
C {devices/code_shown.sym} 80 -380 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27

.param VCM_SET=\{AVDD_SET/2\}
.param VOUT_CM_BIAS=\{AVDD_SET/2\}
.param CMFB_OUT_BIAS=2.4833

.param PLANT_GAIN=500

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(CMFB_OUT)=\{CMFB_OUT_BIAS\} v(VOUTCM)=\{VOUT_CM_BIAS\}
"}
C {vsource.sym} 220 -850 0 0 {name=VAVSS             value="dc \{AVSS_SET\} ac 0"               savecurrent=true}
C {gnd.sym} 220 -820 0 0 {name=l11 lab=0}
C {lab_wire.sym} 220 -900 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -1160 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 380 -800 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 380 -940 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 100 -940 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -1160 2 0 {name=p13 sig_type=std_logic lab=AGND}
C {vsource.sym} 560 -990 0 0 {name=VOUTBIAS          value="dc \{VOUT_CM_BIAS\} ac 0"           savecurrent=false}
C {vsource.sym} 560 -850 0 0 {name=VCMFBOUTBIAS      value="dc \{CMFB_OUT_BIAS\} ac 0"          savecurrent=false}
C {lab_wire.sym} 560 -1040 0 0 {name=p22 sig_type=std_logic lab=VOUTBIAS}
C {lab_wire.sym} 560 -900 0 0 {name=p23 sig_type=std_logic lab=CMFBBIAS}
C {lab_wire.sym} 560 -800 2 0 {name=p24 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -940 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {vcvs.sym} 840 -990 0 0 {name=EREF              value=0.5}
C {vcvs.sym} 840 -850 0 0 {name=EIN               value=-0.5}
C {vcvs.sym} 100 -850 0 0 {name=EPLANT            value=\{PLANT_GAIN\}}
C {lab_wire.sym} 840 -1040 0 0 {name=p14 sig_type=std_logic lab=CMFB_REF}
C {lab_wire.sym} 780 -1010 0 0 {name=p15 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 780 -970 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 780 -870 0 0 {name=p17 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 780 -830 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 840 -940 2 0 {name=p19 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 840 -800 2 0 {name=p20 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 840 -900 0 0 {name=p21 sig_type=std_logic lab=CMFB_IN}
C {lab_wire.sym} 100 -900 0 0 {name=p26 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 40 -870 0 0 {name=p27 sig_type=std_logic lab=CMFB_OUT}
C {lab_wire.sym} 40 -830 0 0 {name=p28 sig_type=std_logic lab=CMFBBIAS}
C {lab_wire.sym} 100 -800 2 0 {name=p29 sig_type=std_logic lab=VOUTBIAS}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/CMFB/CMFB.sym} 360 -1080 0 0 {name=xCMFB1}
