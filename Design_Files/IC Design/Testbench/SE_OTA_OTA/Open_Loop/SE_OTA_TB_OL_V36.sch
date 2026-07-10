v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 -640 180 -620 {lab=B}
N 500 -640 520 -640 {lab=B}
N 500 -680 520 -680 {lab=INP}
N 500 -600 520 -600 {lab=INN}
N 680 -640 760 -640 {lab=OUT}
N 280 -640 280 -620 {lab=INP}
N 380 -640 380 -620 {lab=INN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 600 -700 0 0 {name=l2 lab=AVDD}
C {gnd.sym} 600 -580 0 0 {name=l3 lab=AGND}
C {isource.sym} 180 -590 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 20 -590 0 0 {name=VADD    value="dc \{AVDD_SET\} ac 0"    savecurrent=true}
C {vdd.sym} 20 -620 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 20 -560 0 0 {name=l5 lab=AGND}
C {gnd.sym} 180 -560 0 0 {name=l6 lab=AGND}
C {capa.sym} 760 -610 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 760 -580 0 0 {name=l7 lab=AGND}
C {vsource.sym} 280 -590 0 0 {name=VP      value="dc \{IP\} ac 0"          savecurrent=false}
C {gnd.sym} 280 -560 0 0 {name=l8 lab=AGND}
C {vsource.sym} 380 -590 0 0 {name=VN      value="dc \{IN\} ac 0"          savecurrent=false}
C {gnd.sym} 380 -560 0 0 {name=l9 lab=AGND}
C {lab_wire.sym} 180 -640 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 500 -640 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 280 -640 0 0 {name=p3 sig_type=std_logic lab=INP}
C {lab_wire.sym} 500 -680 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 380 -640 0 0 {name=p5 sig_type=std_logic lab=INN}
C {lab_wire.sym} 500 -600 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 760 -640 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -480 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 800 -1700 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_singlescale

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA

let avdd_run = 3.6
let vcm_run  = avdd_run/2
let off_lo   = vcm_run - 0.05
let off_hi   = vcm_run + 0.05
let off_step = 10u

* OP
op
let op_avdd  = v(AVDD)
let op_inp   = v(INP)
let op_inn   = v(INN)
let op_out   = v(OUT)
let op_b     = v(B)
let op_idd   = -vadd#branch
let op_ibias = 40e-6
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/V36.ol_op.txt op_avdd op_inp op_inn op_out op_b op_idd op_ibias

* Offset
dc VP $&off_lo $&off_hi $&off_step
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/V36.ol_offset.txt v(INP) v(INN) v(OUT)

* Diff AC
alter @VP[DC] = $&vcm_run
alter @VN[DC] = $&vcm_run
alter @VP[ACMAG] = 0.5
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 0.5
alter @VN[ACPHASE] = 180
alter @VADD[ACMAG] = 0
alter @VAGND[ACMAG] = 0

ac dec 200 1 1G
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/V36.ol_ac_diff.txt db(v(OUT,AGND)) ph(v(OUT,AGND)) mag(v(OUT,AGND))

* CMRR
alter @VP[ACMAG] = 1
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 1
alter @VN[ACPHASE] = 0
alter @VADD[ACMAG] = 0
alter @VAGND[ACMAG] = 0

ac dec 200 1 1G
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/V36.ol_ac_cm.txt db(v(OUT,AGND)) mag(v(OUT,AGND))

* PSRR+
alter @VP[ACMAG] = 0
alter @VN[ACMAG] = 0
alter @VADD[ACMAG] = 1
alter @VADD[ACPHASE] = 0
alter @VAGND[ACMAG] = 0

ac dec 200 1 1G
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/V36.ol_ac_psrrp.txt db(v(OUT,AGND)) mag(v(OUT,AGND))

* PSRR-
alter @VP[ACMAG] = 0
alter @VN[ACMAG] = 0
alter @VADD[ACMAG] = 0
alter @VAGND[ACMAG] = 1
alter @VAGND[ACPHASE] = 0

ac dec 200 1 1G
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/V36.ol_ac_psrrn.txt db(v(OUT,AGND)) mag(v(OUT,AGND))

* Noise total only
alter @VADD[ACMAG] = 0
alter @VAGND[ACMAG] = 0
alter @VP[ACMAG] = 1
alter @VN[ACMAG] = 0

noise v(OUT,AGND) VP dec 100 0.05 150
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/V36.ol_noise_total.txt inoise_total onoise_total

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 440 -500 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -380 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.6
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}
.param IP=\{VCM_SET\}
.param IN=\{VCM_SET\}

.temp \{TEMP_SET\}

VAGND AGND 0 dc 0 ac 0

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(OUT)=\{VCM_SET\}
"}
