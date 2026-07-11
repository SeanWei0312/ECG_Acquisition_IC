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
N 360 -780 360 -760 {lab=VCM}
N 360 -640 360 -620 {lab=VDIFF}
N 200 -640 200 -620 {lab=AGND}
N 580 -900 580 -880 {lab=AGND}
N 80 -700 80 -680 {lab=AGND}
N 360 -700 360 -680 {lab=AGND}
N 740 -900 740 -880 {lab=AGND}
N 360 -560 360 -540 {lab=AGND}
N 620 -780 620 -760 {lab=INP}
N 620 -640 620 -620 {lab=INN}
N 620 -700 620 -680 {lab=VCM}
N 620 -560 620 -540 {lab=VCM}
N 560 -750 580 -750 {lab=VDIFF}
N 560 -710 580 -710 {lab=AGND}
N 560 -610 580 -610 {lab=VDIFF}
N 560 -570 580 -570 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 580 -1020 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -730 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 200 -730 0 0 {name=VAVDD   value="dc \{AVDD_SET\} ac 0"      savecurrent=true}
C {vdd.sym} 200 -760 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -700 0 0 {name=l5 lab=0}
C {capa.sym} 740 -930 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 360 -730 0 0 {name=VVCM    value="dc \{VCM_SET\} ac 0"       savecurrent=false}
C {vsource.sym} 360 -590 0 0 {name=VDIFF   value="dc \{VOSDC\} ac 1"         savecurrent=false}
C {lab_wire.sym} 80 -780 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 480 -960 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 360 -780 0 0 {name=p3 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 480 -1000 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 360 -640 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 480 -920 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 740 -960 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -480 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 800 -2710 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_vtc.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_icmr.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cm_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.psrrp_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.psrrn_ac.txt

let avdd_run = 3.3
let vss_run  = 0
let vcm_run  = avdd_run/2

* set this from offset
let vos_run  = 0

* OP
alter @VVCM[DC] = $&vcm_run
alter @VDIFF[DC] = $&vos_run
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

op

let op_vdd   = v(avdd) - v(agnd)
let op_vss   = v(agnd)
let op_vcm   = v(vcm) - v(agnd)
let op_vos   = v(vdiff) - v(agnd)
let op_vinp  = v(inp) - v(agnd)
let op_vinn  = v(inn) - v(agnd)
let op_vout  = v(out) - v(agnd)
let op_ibias = 40e-6
let op_idd   = -vavdd#branch
let op_iout  = 0

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.op.txt op_vdd op_vss op_vcm op_vos op_vinp op_vinn op_vout op_ibias op_idd op_iout

* OL VTC
alter @VVCM[DC] = $&vcm_run
alter @VDIFF[ACMAG] = 0

dc VDIFF -0.2 0.2 0.001

let vtc_vdiff = v(vdiff) - v(agnd)
let vtc_vinp  = v(inp) - v(agnd)
let vtc_vinn  = v(inn) - v(agnd)
let vtc_vout  = v(out) - v(agnd)
let vtc_ibias = 40e-6
let vtc_idd   = -vavdd#branch
let vtc_iout  = 0

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_vtc.txt vtc_vdiff vtc_vinp vtc_vinn vtc_vout vtc_ibias vtc_idd vtc_iout

* OL AC
alter @VVCM[DC] = $&vcm_run
alter @VDIFF[DC] = $&vos_run
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 1
alter @VDIFF[ACPHASE] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G

let ol_out = v(out) - v(agnd)
let ad_real = real(ol_out)
let ad_imag = imag(ol_out)
let ad_mag  = mag(ol_out)
let ad_db   = db(ol_out)
let ad_ph   = ph(ol_out)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_ac.txt ad_real ad_imag ad_mag ad_db ad_ph

* ICMR DC
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

dc VVCM 0 $&avdd_run 0.01 VDIFF -0.2 0.2 0.001

let icmr_vcm   = v(vcm) - v(agnd)
let icmr_vdiff = v(vdiff) - v(agnd)
let icmr_vout  = v(out) - v(agnd)
let icmr_ibias = 40e-6
let icmr_idd   = -vavdd#branch
let icmr_iout  = 0

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.ol_icmr.txt icmr_vcm icmr_vdiff icmr_vout icmr_ibias icmr_idd icmr_iout

* CM AC
alter @VVCM[DC] = $&vcm_run
alter @VDIFF[DC] = $&vos_run
alter @VVCM[ACMAG] = 1
alter @VVCM[ACPHASE] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G

let cm_out  = v(out) - v(agnd)
let acm_real = real(cm_out)
let acm_imag = imag(cm_out)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.cm_ac.txt acm_real acm_imag

* PSRR+
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 1
alter @VAVDD[ACPHASE] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G

let psrrp_out  = v(out) - v(agnd)
let psrrp_real = real(psrrp_out)
let psrrp_imag = imag(psrrp_out)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.psrrp_ac.txt psrrp_real psrrp_imag

* PSRR-
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 1
alter @VAVSS[ACPHASE] = 0

ac dec 200 1 1G

let psrrn_out  = v(out) - v(agnd)
let psrrn_real = real(psrrn_out)
let psrrn_imag = imag(psrrn_out)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.Result_txt/NOM.psrrn_ac.txt psrrn_real psrrn_imag

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 420 -820 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -380 0 0 {name=SETUP only_toplevel=true
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
C {vsource.sym} 200 -590 0 0 {name=VAVSS   value="dc \{AVSS_SET\} ac 0"      savecurrent=true}
C {gnd.sym} 200 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -880 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -540 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -680 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -680 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -880 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -590 0 0 {name=EINN    value=-0.5}
C {vcvs.sym} 620 -730 0 0 {name=EINP    value=0.5}
C {lab_wire.sym} 620 -780 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -640 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -680 2 0 {name=p16 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 620 -540 2 0 {name=p17 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 560 -570 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -710 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -610 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -750 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
