v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 -580 180 -560 {lab=B}
N 500 -580 520 -580 {lab=B}
N 500 -620 520 -620 {lab=INP}
N 500 -540 520 -540 {lab=INN}
N 680 -580 760 -580 {lab=OUT}
N 280 -580 280 -560 {lab=INP}
N 380 -580 380 -560 {lab=INN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 600 -640 0 0 {name=l2 lab=AVDD}
C {gnd.sym} 600 -520 0 0 {name=l3 lab=AGND}
C {isource.sym} 180 -530 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 80 -530 0 0 {name=VADD    value="dc 3.3 ac 0"       savecurrent=true}
C {vdd.sym} 80 -560 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 80 -500 0 0 {name=l5 lab=AGND}
C {gnd.sym} 180 -500 0 0 {name=l6 lab=AGND}
C {capa.sym} 760 -550 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 760 -520 0 0 {name=l7 lab=AGND}
C {vsource.sym} 280 -530 0 0 {name=VP      value="dc \{IP\} ac 0"      savecurrent=false}
C {gnd.sym} 280 -500 0 0 {name=l8 lab=AGND}
C {vsource.sym} 380 -530 0 0 {name=VN      value="dc \{IN\} ac 0"      savecurrent=false}
C {gnd.sym} 380 -500 0 0 {name=l9 lab=AGND}
C {lab_wire.sym} 180 -580 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 500 -580 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 280 -580 0 0 {name=p3 sig_type=std_logic lab=INP}
C {lab_wire.sym} 500 -620 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 380 -580 0 0 {name=p5 sig_type=std_logic lab=INN}
C {lab_wire.sym} 500 -540 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 760 -580 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -420 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 830 -1230 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_singlescale

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA

* =========================================================
* SE_OTA_TB_OL
* Save TXT only
* =========================================================

* OP: Vin,cm, Vout,DC, B
op
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/ol_op.txt v(INP) v(INN) v(OUT) v(B)

* Input offset sweep
dc VP 1.60 1.70 0.00001
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/ol_offset.txt v(INP) v(INN) v(OUT)

* Differential AC gain
alter @VP[DC] = 1.65
alter @VN[DC] = 1.65
alter @VP[ACMAG] = 0.5
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 0.5
alter @VN[ACPHASE] = 180
alter @VADD[ACMAG] = 0

ac dec 200 1 1G
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/ol_ac_diff.txt db(v(OUT)) ph(v(OUT)) mag(v(OUT))

* CMRR
alter @VP[ACMAG] = 1
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 1
alter @VN[ACPHASE] = 0
alter @VADD[ACMAG] = 0

ac dec 200 1 1G
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/ol_ac_cm.txt db(v(OUT)) mag(v(OUT))

* PSRR+
alter @VP[ACMAG] = 0
alter @VN[ACMAG] = 0
alter @VADD[ACMAG] = 1
alter @VADD[ACPHASE] = 0

ac dec 200 1 1G
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/ol_ac_psrr.txt db(v(OUT)) mag(v(OUT))

* Noise total only
* Saves integrated noise from 0.05 Hz to 150 Hz
alter @VADD[ACMAG] = 0
alter @VP[ACMAG] = 1
alter @VN[ACMAG] = 0

noise v(OUT) VP dec 100 0.05 150
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/ol_noise_total.txt inoise_total onoise_total

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 440 -440 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -320 0 0 {name=SETUP only_toplevel=true
value="
.param IP=1.65
.param IN=1.65

VAGND AGND 0 0

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(OUT)=1.65
"}
