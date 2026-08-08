v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -300 {}
N 80 -780 80 -760 {lab=B}
N 480 -960 500 -960 {lab=B}
N 480 -1000 500 -1000 {lab=INP}
N 480 -920 500 -920 {lab=INN}
N 660 -960 740 -960 {lab=OUT}
N 360 -780 360 -760 {lab=VINCM}
N 360 -640 360 -620 {lab=VDIFF}
N 200 -640 200 -620 {lab=AGND}
N 80 -700 80 -680 {lab=AGND}
N 360 -700 360 -680 {lab=AGND}
N 740 -900 740 -880 {lab=AGND}
N 360 -560 360 -540 {lab=AGND}
N 620 -780 620 -760 {lab=INP}
N 620 -640 620 -620 {lab=INN}
N 620 -700 620 -680 {lab=VINCM}
N 620 -560 620 -540 {lab=VINCM}
N 560 -750 580 -750 {lab=VDIFF}
N 560 -710 580 -710 {lab=AGND}
N 560 -610 580 -610 {lab=VDIFF}
N 560 -570 580 -570 {lab=AGND}
N 580 -880 580 -860 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 580 -1040 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -730 2 1 {name=IBIAS value="dc 40u"}
C {vsource.sym} 200 -730 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {vdd.sym} 200 -760 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -700 0 0 {name=l5 lab=0}
C {capa.sym} 740 -930 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 360 -730 0 0 {name=VCM   value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 360 -590 0 0 {name=VDIFF value="dc 0 ac 0"         savecurrent=false}
C {lab_wire.sym} 80 -780 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 480 -960 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 360 -780 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 480 -1000 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 360 -640 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 480 -920 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 740 -960 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -480 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.temp 27
.param VDD_SET=3.3
"}
C {devices/code_shown.sym} 800 -2420 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_diff_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_cm_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_psrrp_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_psrrn_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_vtc.txt

* OP
op

let vdd = v(AVDD)-v(AGND)
let vinp = v(INP)-v(AGND)
let vinn = v(INN)-v(AGND)
let vout = v(OUT)-v(AGND)
let idd = -vavdd#branch
let ibias = 40u + 0*v(AVDD)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_op.txt vdd vinp vinn vout v(B) idd ibias

* Diff AC
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 1
alter @VDIFF[ACPHASE] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 0.01 100G

let vin_diff = v(INP)-v(INN)
let vout = v(OUT)-v(AGND)
let vin_diff_real = real(vin_diff)
let vin_diff_imag = imag(vin_diff)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_diff_ac.txt vin_diff_real vin_diff_imag vout_real vout_imag

* CM AC
alter @VCM[ACMAG] = 1
alter @VCM[ACPHASE] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 0.01 100G

let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let vout = v(OUT)-v(AGND)
let vin_cm_real = real(vin_cm)
let vin_cm_imag = imag(vin_cm)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_cm_ac.txt vin_cm_real vin_cm_imag vout_real vout_imag

* PSRR+
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 1
alter @VAVDD[ACPHASE] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 0.01 100G

let vavdd_ac = v(AVDD)-v(AGND)
let vout = v(OUT)-v(AGND)
let vavdd_real = real(vavdd_ac)
let vavdd_imag = imag(vavdd_ac)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_psrrp_ac.txt vavdd_real vavdd_imag vout_real vout_imag

* PSRR-
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 1
alter @VAVSS[ACPHASE] = 0

ac dec 200 0.01 100G

let vagnd_ac = v(AGND)
let vout = v(OUT)-v(AGND)
let vagnd_real = real(vagnd_ac)
let vagnd_imag = imag(vagnd_ac)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_psrrn_ac.txt vagnd_real vagnd_imag vout_real vout_imag

* VTC
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

dc VDIFF -20m 20m 1u

let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff = v(INP)-v(INN)
let vout = v(OUT)-v(AGND)
let idd = -vavdd#branch

setscale vin_diff

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_vtc.txt vin_cm v(INP) v(INN) vout idd

* op
* show m : id vgs vds vth vdsat gm gds
quit
.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 420 -820 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -330 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(INP)=\{VCM_SET\} v(INN)=\{VCM_SET\}
.nodeset v(OUT)=\{VCM_SET\}
.nodeset v(B)=1.65
"}
C {vsource.sym} 200 -590 0 0 {name=VAVSS value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 200 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -860 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -540 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -680 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -680 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -880 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -590 0 0 {name=EINN value=-0.5}
C {vcvs.sym} 620 -730 0 0 {name=EINP value=0.5}
C {lab_wire.sym} 620 -780 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -640 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -680 2 0 {name=p16 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 620 -540 2 0 {name=p17 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 560 -570 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -710 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -610 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -750 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
