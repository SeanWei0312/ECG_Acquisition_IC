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
N 200 -610 200 -590 {lab=AGND}
N 580 -860 580 -840 {lab=AGND}
N 80 -670 80 -650 {lab=AGND}
N 740 -880 740 -860 {lab=AGND}
N 360 -740 360 -720 {lab=INP}
N 360 -600 360 -580 {lab=INN}
N 360 -660 360 -640 {lab=AGND}
N 360 -520 360 -500 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 580 -1020 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -700 2 1 {name=IBIAS value="dc 40u"}
C {vsource.sym} 200 -700 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0"   savecurrent=true}
C {vdd.sym} 200 -730 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -670 0 0 {name=l5 lab=0}
C {capa.sym} 740 -910 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 80 -750 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 480 -940 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 480 -980 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 480 -900 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 740 -940 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -450 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.temp 27
.param VDD_SET=3.3
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 420 -800 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -270 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(INP)=\{VCM_SET\} v(INN)=\{VCM_SET\}
.nodeset v(OUT)=\{VCM_SET\}
.nodeset v(B)=1.65
"}
C {vsource.sym} 200 -560 0 0 {name=VAVSS value="dc 0 ac 0"           savecurrent=true}
C {gnd.sym} 200 -530 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -610 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -840 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -650 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -860 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {devices/code_shown.sym} 810 -690 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_noise.txt

alter @VP[ACMAG] = 0.5
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 0.5
alter @VN[ACPHASE] = 180
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

op

noise v(OUT) VP dec 100 0.01 160
setplot noise1
setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_noise.txt onoise_spectrum

quit
.endc
"}
C {vsource.sym} 360 -690 0 0 {name=VP    value="dc \{VCM_SET\} ac 0.5" savecurrent=false}
C {vsource.sym} 360 -550 0 0 {name=VN    value="dc \{VCM_SET\} ac 0.5" savecurrent=false}
C {lab_wire.sym} 360 -740 0 0 {name=p14 sig_type=std_logic lab=INP
}
C {lab_wire.sym} 360 -600 0 0 {name=p15 sig_type=std_logic lab=INN
}
C {lab_wire.sym} 360 -500 2 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -640 2 0 {name=p17 sig_type=std_logic lab=AGND}
