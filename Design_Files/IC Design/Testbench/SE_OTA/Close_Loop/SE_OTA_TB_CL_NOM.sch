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
N 660 -520 660 -500 {lab=AGND}
N 500 -500 500 -480 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 500 -660 0 0 {name=l2 lab=AVDD}
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
.temp 27
.param VDD_SET=3.3
"}
C {devices/code_shown.sym} 720 -1450 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_dc.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_tran.txt

* OP
op

let vdd = v(AVDD)-v(AGND)
let vin = v(INP)-v(AGND)
let vout = v(OUT)-v(AGND)
let vin_diff = v(INP)-v(OUT)
let idd = -vavdd#branch
let ibias = 40u + 0*v(AVDD)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_op.txt vdd vin vout vin_diff v(B) idd ibias

* DC
op
let avdd_run = v(AVDD)-v(AGND)
let vin_low = 0
let vin_high = avdd_run

dc VIN $&vin_low $&vin_high 0.001

let cl_vin = v(INP)-v(AGND)
let cl_vout = v(OUT)-v(AGND)
let cl_err = cl_vout-cl_vin
let cl_vin_diff = v(INP)-v(OUT)
let cl_idd = -vavdd#branch
let cl_ibias = 40u + 0*v(AVDD)
let cl_iout = 10e-12*deriv(cl_vout)

setscale cl_vin

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_dc.txt cl_vout cl_err cl_vin_diff cl_idd cl_ibias cl_iout

* Tran
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

alter @VIN[PULSE] = [ 1.0 2.0 1u 10n 10n 10u 20u 0 ]

tran 0.5n 30u

let tr_vin = v(INP)-v(AGND)
let tr_vout = v(OUT)-v(AGND)
let tr_err = tr_vout-tr_vin
let tr_vin_diff = v(INP)-v(OUT)
let tr_idd = -vavdd#branch
let tr_iout = 10e-12*deriv(tr_vout)

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cl_tran.txt tr_vin tr_vout tr_err tr_vin_diff tr_idd tr_iout

quit
.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 340 -440 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -270 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(INP)=\{VCM_SET\}
.nodeset v(OUT)=\{VCM_SET\}
.nodeset v(B)=1.65
"}
C {isource.sym} 280 -530 2 1 {name=IBIAS value="dc 40u"}
C {vsource.sym} 100 -670 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {vdd.sym} 100 -700 0 0 {name=l9 lab=AVDD}
C {gnd.sym} 100 -640 0 0 {name=l10 lab=0}
C {vsource.sym} 280 -670 0 0 {name=VIN   value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 280 -580 0 0 {name=p5 sig_type=std_logic lab=B}
C {lab_wire.sym} 280 -720 0 0 {name=p6 sig_type=std_logic lab=INP}
C {vsource.sym} 100 -530 0 0 {name=VAVSS value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 100 -500 0 0 {name=l11 lab=0}
C {lab_wire.sym} 100 -580 0 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 280 -620 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 280 -480 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 500 -480 2 0 {name=p1 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 660 -500 2 0 {name=p3 sig_type=std_logic lab=AGND}
