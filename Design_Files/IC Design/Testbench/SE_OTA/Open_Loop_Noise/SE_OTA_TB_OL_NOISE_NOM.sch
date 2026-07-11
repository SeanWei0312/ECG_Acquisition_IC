v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -270 {}
N 80 -750 80 -730 {lab=B}
N 480 -940 500 -940 {lab=B}
N 480 -980 500 -980 {lab=INP}
N 480 -900 500 -900 {lab=INN}
N 660 -940 740 -940 {lab=OUT}
N 360 -750 360 -730 {lab=VCM}
N 360 -610 360 -590 {lab=VDIFF}
N 200 -610 200 -590 {lab=AGND}
N 580 -880 580 -860 {lab=AGND}
N 80 -670 80 -650 {lab=AGND}
N 360 -670 360 -650 {lab=AGND}
N 740 -880 740 -860 {lab=AGND}
N 360 -530 360 -510 {lab=AGND}
N 620 -750 620 -730 {lab=INP}
N 620 -610 620 -590 {lab=INN}
N 620 -670 620 -650 {lab=VCM}
N 620 -530 620 -510 {lab=VCM}
N 560 -720 580 -720 {lab=VDIFF}
N 560 -680 580 -680 {lab=AGND}
N 560 -580 580 -580 {lab=VDIFF}
N 560 -540 580 -540 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 580 -1000 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -700 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 200 -700 0 0 {name=VAVDD   value="dc \{AVDD_SET\} ac 0"      savecurrent=true}
C {vdd.sym} 200 -730 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -670 0 0 {name=l5 lab=0}
C {capa.sym} 740 -910 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 360 -700 0 0 {name=VVCM    value="dc \{VCM_SET\} ac 0"       savecurrent=false}
C {vsource.sym} 360 -560 0 0 {name=VDIFF   value="dc \{VOSDC\} ac 1"         savecurrent=false}
C {lab_wire.sym} 80 -750 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 480 -940 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 360 -750 0 0 {name=p3 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 480 -980 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 360 -610 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 480 -900 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 740 -940 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -450 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 420 -800 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -350 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}
.param VOSDC=0

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(OUT)=\{VCM_SET\}
"}
C {vsource.sym} 200 -560 0 0 {name=VAVSS   value="dc \{AVSS_SET\} ac 0"      savecurrent=true}
C {gnd.sym} 200 -530 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -610 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -860 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -510 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -650 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -650 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -860 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -560 0 0 {name=EINN    value=-0.5}
C {vcvs.sym} 620 -700 0 0 {name=EINP    value=0.5}
C {lab_wire.sym} 620 -750 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -610 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -650 2 0 {name=p16 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 620 -510 2 0 {name=p17 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 560 -540 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -680 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -580 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -720 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
C {devices/code_shown.sym} 800 -890 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale
unset sqrnoise

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.noise_spectrum.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.noise_total.txt

* set this from offset
let vos_run = 0

alter @VDIFF[DC] = $&vos_run
alter @VDIFF[ACMAG] = 1
alter @VVCM[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

* Noise
noise v(out) VDIFF dec 100 0.05 150

setplot noise1
let in_noise  = inoise_spectrum
let out_noise = onoise_spectrum

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.noise_spectrum.txt in_noise out_noise

setplot noise2
let fmin = 0.05
let fmax = 150
let in_total  = inoise_total
let out_total = onoise_total

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.noise_total.txt fmin fmax in_total out_total

.endc
"}
