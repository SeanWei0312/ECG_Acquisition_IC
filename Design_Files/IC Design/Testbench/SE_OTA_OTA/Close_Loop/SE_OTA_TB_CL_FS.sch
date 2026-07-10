v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 -580 180 -560 {lab=B}
N 400 -580 420 -580 {lab=B}
N 400 -620 420 -620 {lab=INP}
N 580 -580 660 -580 {lab=OUT}
N 280 -580 280 -560 {lab=INP}
N 620 -580 620 -460 {lab=OUT}
N 400 -460 620 -460 {lab=OUT}
N 400 -540 400 -460 {lab=OUT}
N 400 -540 420 -540 {lab=OUT}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 500 -640 0 0 {name=l2 lab=AVDD}
C {gnd.sym} 500 -520 0 0 {name=l3 lab=AGND}
C {isource.sym} 180 -530 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 20 -530 0 0 {name=VADD    value="dc \{AVDD_SET\} ac 0"    savecurrent=true}
C {vdd.sym} 20 -560 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 20 -500 0 0 {name=l5 lab=AGND}
C {gnd.sym} 180 -500 0 0 {name=l6 lab=AGND}
C {capa.sym} 660 -550 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 660 -520 0 0 {name=l7 lab=AGND}
C {vsource.sym} 280 -530 0 0 {name=VP      value="dc \{IP\} ac 0"          savecurrent=false}
C {gnd.sym} 280 -500 0 0 {name=l8 lab=AGND}
C {lab_wire.sym} 180 -580 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 400 -580 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 280 -580 0 0 {name=p3 sig_type=std_logic lab=INP}
C {lab_wire.sym} 400 -620 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 660 -580 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -420 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice fs
"}
C {devices/code_shown.sym} 710 -830 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_singlescale

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA

let avdd_run = 3.3
let vcm_run  = avdd_run/2

* OP
alter @VP[DC] = $&vcm_run
alter @VP[ACMAG] = 0
alter @VADD[ACMAG] = 0
alter @VAGND[ACMAG] = 0

op
let cl_avdd  = v(AVDD)
let cl_inp   = v(INP)
let cl_out   = v(OUT)
let cl_b     = v(B)
let cl_idd   = -vadd#branch
let cl_ibias = 40e-6
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/FS.cl_op.txt cl_avdd cl_inp cl_out cl_b cl_idd cl_ibias

* Swing
dc VP 0 $&avdd_run 0.001
let sw_inp = v(INP)
let sw_out = v(OUT)
let sw_idd = -vadd#branch
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/FS.cl_swing.txt sw_inp sw_out sw_idd

* Slew
alter @VP[PULSE] = [ 1.0 2.0 1u 1n 1n 10u 20u 0 ]

tran 1n 30u
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/FS.cl_slew.txt v(INP) v(OUT)

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 340 -440 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -320 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}
.param IP=\{VCM_SET\}

.temp \{TEMP_SET\}

VAGND AGND 0 dc 0 ac 0

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(OUT)=\{VCM_SET\}
"}
