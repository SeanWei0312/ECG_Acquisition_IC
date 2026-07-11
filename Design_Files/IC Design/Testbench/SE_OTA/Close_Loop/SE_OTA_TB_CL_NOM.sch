v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 400 -580 420 -580 {lab=B}
N 400 -620 420 -620 {lab=INP}
N 580 -580 660 -580 {lab=OUT}
N 620 -580 620 -460 {lab=OUT}
N 400 -460 620 -460 {lab=OUT}
N 400 -540 400 -460 {lab=OUT}
N 400 -540 420 -540 {lab=OUT}
N 280 -580 280 -560 {lab=B}
N 280 -720 280 -700 {lab=INP}
N 100 -580 100 -560 {lab=AGND}
N 280 -500 280 -480 {lab=AGND}
N 280 -640 280 -620 {lab=AGND}
N 500 -520 500 -500 {lab=AGND}
N 660 -520 660 -500 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 500 -640 0 0 {name=l2 lab=AVDD}
C {capa.sym} 660 -550 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 400 -580 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 400 -620 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 660 -580 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -420 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 710 -810 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_dc.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_tran.txt

let avdd_run = 3.3

* CL DC
dc VIN 0 $&avdd_run 0.001

let cl_vin   = v(inp) - v(agnd)
let cl_vout  = v(out) - v(agnd)
let cl_ibias = 40e-6
let cl_idd   = -vavdd#branch
let cl_iout  = 0

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_dc.txt cl_vin cl_vout cl_ibias cl_idd cl_iout

* CL TRAN
alter @VIN[PULSE] = [ 1.0 2.0 1u 1n 1n 10u 20u 0 ]

tran 1n 30u

let tr_vin   = v(inp) - v(agnd)
let tr_vout  = v(out) - v(agnd)
let tr_idd   = -vavdd#branch
let tr_iout  = 10e-12*deriv(tr_vout)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_tran.txt tr_vin tr_vout tr_idd tr_iout

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 340 -440 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -320 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(OUT)=\{VCM_SET\}
"}
C {isource.sym} 280 -530 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 100 -670 0 0 {name=VAVDD   value="dc \{AVDD_SET\} ac 0"      savecurrent=true}
C {vdd.sym} 100 -700 0 0 {name=l9 lab=AVDD}
C {gnd.sym} 100 -640 0 0 {name=l10 lab=0}
C {vsource.sym} 280 -670 0 0 {name=VIN     value="dc \{VCM_SET\} ac 0"       savecurrent=false}
C {lab_wire.sym} 280 -580 0 0 {name=p5 sig_type=std_logic lab=B}
C {lab_wire.sym} 280 -720 0 0 {name=p6 sig_type=std_logic lab=INP}
C {vsource.sym} 100 -530 0 0 {name=VAVSS   value="dc \{AVSS_SET\} ac 0"      savecurrent=true}
C {gnd.sym} 100 -500 0 0 {name=l11 lab=0}
C {lab_wire.sym} 100 -580 0 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 280 -620 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 280 -480 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 500 -500 2 0 {name=p1 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 660 -500 2 0 {name=p3 sig_type=std_logic lab=AGND}
