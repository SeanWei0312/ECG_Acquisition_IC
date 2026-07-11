v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -300 {}
N 80 -780 80 -760 {lab=B}
N 300 -1100 320 -1100 {lab=B}
N 300 -1140 320 -1140 {lab=INP}
N 300 -1060 320 -1060 {lab=INN}
N 360 -780 360 -760 {lab=VCM}
N 360 -640 360 -620 {lab=VDIFF}
N 200 -640 200 -620 {lab=AGND}
N 400 -1040 400 -1020 {lab=AGND}
N 80 -700 80 -680 {lab=AGND}
N 360 -700 360 -680 {lab=AGND}
N 600 -1060 600 -1040 {lab=AGND}
N 360 -560 360 -540 {lab=AGND}
N 620 -780 620 -760 {lab=INP}
N 620 -640 620 -620 {lab=INN}
N 620 -700 620 -680 {lab=VCM}
N 620 -560 620 -540 {lab=VCM}
N 560 -750 580 -750 {lab=VDIFF}
N 560 -710 580 -710 {lab=AGND}
N 560 -610 580 -610 {lab=VDIFF}
N 560 -570 580 -570 {lab=AGND}
N 480 -1140 500 -1140 {lab=OUTP}
N 480 -1100 500 -1100 {lab=CMFB}
N 480 -1060 500 -1060 {lab=OUTN}
N 600 -1140 600 -1120 {lab=OUTP}
N 700 -1060 700 -1040 {lab=AGND}
N 700 -1140 700 -1120 {lab=OUTN}
N 80 -920 80 -900 {lab=CMFB}
N 80 -840 80 -820 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 400 -1160 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -730 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 200 -730 0 0 {name=VAVDD    value="dc \{AVDD_SET\} ac 0"      savecurrent=true}
C {vdd.sym} 200 -760 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -700 0 0 {name=l5 lab=0}
C {capa.sym} 600 -1090 0 0 {name=CLP
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 360 -730 0 0 {name=VVCM     value="dc \{VCM_SET\} ac 0"       savecurrent=false}
C {vsource.sym} 360 -590 0 0 {name=VDIFF    value="dc \{VOSDC\} ac 1"         savecurrent=false}
C {lab_wire.sym} 80 -780 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 300 -1100 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 360 -780 0 0 {name=p3 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 300 -1140 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 360 -640 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 300 -1060 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 600 -1140 0 1 {name=p7 sig_type=std_logic lab=OUTP}
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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_diff_tf.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_diff_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_offset.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_icmr.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_cm_diff_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_psrrp_diff_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_psrrn_diff_ac.txt

let avdd_run = 3.3
let vcm_run  = avdd_run/2
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
let op_vinp  = v(inp) - v(agnd)
let op_vinn  = v(inn) - v(agnd)
let op_voutp = v(outp) - v(agnd)
let op_voutn = v(outn) - v(agnd)
let op_ibias = 40e-6
let op_idd   = -vavdd#branch
let op_cmfb  = v(cmfb) - v(agnd)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_op.txt op_vdd op_vinp op_vinn op_voutp op_voutn op_ibias op_idd op_cmfb

* DC TF by low-frequency AC point
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 1
alter @VDIFF[ACPHASE] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac lin 1 1 1

let tf_vod = v(outp) - v(outn)
let ad_dc = mag(tf_vod)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_diff_tf.txt ad_dc

* Differential AC
ac dec 200 1 1G

let ad_vod  = v(outp) - v(outn)
let ad_real = real(ad_vod)
let ad_imag = imag(ad_vod)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_diff_ac.txt ad_real ad_imag

* Offset sweep
alter @VVCM[DC] = $&vcm_run
alter @VDIFF[ACMAG] = 0

dc VDIFF -0.02 0.02 0.00001

let off_vinp  = v(inp) - v(agnd)
let off_vinn  = v(inn) - v(agnd)
let off_voutp = v(outp) - v(agnd)
let off_voutn = v(outn) - v(agnd)
let off_idd   = -vavdd#branch
let off_cmfb  = v(cmfb) - v(agnd)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_offset.txt off_vinp off_vinn off_voutp off_voutn off_idd off_cmfb

* ICMR sweep
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

dc VVCM 0 $&avdd_run 0.01 VDIFF -0.2 0.2 0.001

let icmr_vcm   = v(vcm) - v(agnd)
let icmr_vdiff = v(vdiff) - v(agnd)
let icmr_vinp  = v(inp) - v(agnd)
let icmr_vinn  = v(inn) - v(agnd)
let icmr_voutp = v(outp) - v(agnd)
let icmr_voutn = v(outn) - v(agnd)
let icmr_idd   = -vavdd#branch
let icmr_cmfb  = v(cmfb) - v(agnd)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_icmr.txt icmr_vcm icmr_vdiff icmr_vinp icmr_vinn icmr_voutp icmr_voutn icmr_idd icmr_cmfb

* CM to differential AC
alter @VVCM[DC] = $&vcm_run
alter @VDIFF[DC] = $&vos_run
alter @VVCM[ACMAG] = 1
alter @VVCM[ACPHASE] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G

let acm_vod  = v(outp) - v(outn)
let acm_real = real(acm_vod)
let acm_imag = imag(acm_vod)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_cm_diff_ac.txt acm_real acm_imag

* PSRR+ differential
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 1
alter @VAVDD[ACPHASE] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G

let psrrp_vod  = v(outp) - v(outn)
let psrrp_real = real(psrrp_vod)
let psrrp_imag = imag(psrrp_vod)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_psrrp_diff_ac.txt psrrp_real psrrp_imag

* PSRR- differential
alter @VVCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 1
alter @VAVSS[ACPHASE] = 0

ac dec 200 1 1G

let psrrn_vod  = v(outp) - v(outn)
let psrrn_real = real(psrrn_vod)
let psrrn_imag = imag(psrrn_vod)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_psrrn_diff_ac.txt psrrn_real psrrn_imag

.endc
"}
C {devices/code_shown.sym} 80 -380 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}
.param VOSDC=0
.param CMFB_GAIN=50

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(CMFB)=\{VCM_SET\} v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
"}
C {vsource.sym} 200 -590 0 0 {name=VAVSS    value="dc \{AVSS_SET\} ac 0"      savecurrent=true}
C {gnd.sym} 200 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -1020 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -540 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -680 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -680 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 600 -1040 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -590 0 0 {name=EINN     value=-0.5}
C {vcvs.sym} 620 -730 0 0 {name=EINP     value=0.5}
C {lab_wire.sym} 620 -780 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -640 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -680 2 0 {name=p16 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 620 -540 2 0 {name=p17 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 560 -570 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -710 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -610 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -750 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDC/FDC.sym} 240 -960 0 0 {name=xSEOTA1}
C {capa.sym} 700 -1090 0 0 {name=CLN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 700 -1040 2 1 {name=CLN2 sig_type=std_logic lab=AGND}
C {vsource.sym} 80 -870 0 0 {name=BCMFB
value="v=\{VCM_SET + CMFB_GAIN*(VCM_SET - 0.5*(v(OUTP,AGND)+v(OUTN,AGND)))\}"}
C {lab_wire.sym} 80 -820 2 0 {name=p23 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -920 0 0 {name=p24 sig_type=std_logic lab=CMFB}
C {lab_wire.sym} 500 -1140 0 1 {name=p22 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 700 -1140 0 1 {name=p25 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 500 -1060 0 1 {name=p26 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 500 -1100 0 1 {name=p27 sig_type=std_logic lab=CMFB}
