v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -360 {}
N 360 -840 360 -820 {lab=B}
N 280 -1040 300 -1040 {lab=B}
N 280 -1080 300 -1080 {lab=INP}
N 280 -1000 300 -1000 {lab=INN}
N 200 -840 200 -820 {lab=VCM}
N 200 -700 200 -680 {lab=VDIFF}
N 40 -700 40 -680 {lab=AGND}
N 350 -940 350 -920 {lab=AGND}
N 360 -760 360 -740 {lab=AGND}
N 200 -760 200 -740 {lab=AGND}
N 580 -1000 580 -980 {lab=AGND}
N 200 -620 200 -600 {lab=AGND}
N 620 -840 620 -820 {lab=INP}
N 620 -700 620 -680 {lab=INN}
N 620 -760 620 -740 {lab=VCM}
N 620 -620 620 -600 {lab=VCM}
N 560 -810 580 -810 {lab=VDIFF}
N 560 -770 580 -770 {lab=AGND}
N 560 -670 580 -670 {lab=VDIFF}
N 560 -630 580 -630 {lab=AGND}
N 460 -1120 480 -1120 {lab=OUTP}
N 380 -940 380 -920 {lab=CMFB}
N 460 -960 480 -960 {lab=OUTN}
N 580 -1080 580 -1060 {lab=OUTP}
N 680 -1000 680 -980 {lab=AGND}
N 680 -1080 680 -1060 {lab=OUTN}
N 360 -700 360 -680 {lab=CMFBBIAS}
N 360 -620 360 -600 {lab=AGND}
N 800 -840 800 -820 {lab=OPH}
N 800 -700 800 -680 {lab=VOUTCM}
N 800 -760 800 -740 {lab=AGND}
N 800 -620 800 -600 {lab=OPH}
N 740 -810 760 -810 {lab=OUTP}
N 740 -770 760 -770 {lab=AGND}
N 740 -670 760 -670 {lab=OUTN}
N 740 -630 760 -630 {lab=AGND}
N 980 -840 980 -820 {lab=CMERR}
N 980 -760 980 -740 {lab=AGND}
N 920 -810 940 -810 {lab=VCM}
N 920 -770 940 -770 {lab=VOUTCM}
N 980 -700 980 -680 {lab=CMFB}
N 980 -620 980 -600 {lab=CMFBBIAS}
N 920 -670 940 -670 {lab=CMERR}
N 920 -630 940 -630 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 350 -1140 0 0 {name=l2 lab=AVDD}
C {isource.sym} 360 -790 2 1 {name=IBIAS       value="dc 40u"}
C {vsource.sym} 40 -790 0 0 {name=VAVDD       value="dc \{AVDD_SET\} ac 0"       savecurrent=true}
C {vdd.sym} 40 -820 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 40 -760 0 0 {name=l5 lab=0}
C {capa.sym} 580 -1030 0 0 {name=CLP
m=1
value=40p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 200 -790 0 0 {name=VVCM        value="dc \{VCM_SET\} ac 0"        savecurrent=false}
C {vsource.sym} 200 -650 0 0 {name=VDIFF       value="dc \{VOSDC\} ac 1"          savecurrent=false}
C {lab_wire.sym} 360 -840 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 280 -1040 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 200 -840 0 0 {name=p3 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 280 -1080 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 200 -700 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 280 -1000 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 580 -1080 0 1 {name=p7 sig_type=std_logic lab=OUTP}
C {devices/code_shown.sym} 80 -540 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 1120 -2650 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_diff_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_offset.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_noise.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_noise_integrated.txt

let avdd_run = 3.3
let vcm_run  = avdd_run/2
let vos_run  = 0

* OP
alter @VAVDD[DC] = $&avdd_run
alter @VVCM[DC]  = $&vcm_run
alter @VDIFF[DC] = $&vos_run

alter @VVCM[ACMAG]  = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

op

let op_vdd     = v(avdd)-v(agnd)
let op_vinp    = v(inp)-v(agnd)
let op_vinn    = v(inn)-v(agnd)
let op_vid     = op_vinp-op_vinn

let op_voutp   = v(outp)-v(agnd)
let op_voutn   = v(outn)-v(agnd)
let op_voutcm  = (op_voutp+op_voutn)/2
let op_vod     = op_voutp-op_voutn

let op_ibias   = 40e-6
let op_idd     = -vavdd#branch
let op_power   = -(v(avdd)*vavdd#branch+v(agnd)*vavss#branch)
let op_cmfb    = v(cmfb)-v(agnd)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_op.txt op_vdd op_vinp op_vinn op_vid op_voutp op_voutn op_voutcm op_vod op_ibias op_idd op_power op_cmfb


* Differential AC
alter @VVCM[DC]  = $&vcm_run
alter @VDIFF[DC] = $&vos_run

alter @VVCM[ACMAG]   = 0
alter @VDIFF[ACMAG]  = 1
alter @VDIFF[ACPHASE] = 0
alter @VAVDD[ACMAG]  = 0
alter @VAVSS[ACMAG]  = 0

ac dec 200 1 1G

let vid_ac  = v(inp)-v(inn)
let vod_ac  = v(outp)-v(outn)
let ad_ac   = vod_ac/vid_ac
let ad_real = real(ad_ac)
let ad_imag = imag(ad_ac)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_diff_ac.txt ad_real ad_imag


* Offset
alter @VVCM[DC] = $&vcm_run

alter @VVCM[ACMAG]  = 0
alter @VDIFF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

dc VDIFF -0.02 0.02 1e-5

let off_vdiff  = v(vdiff)-v(agnd)
let off_vinp   = v(inp)-v(agnd)
let off_vinn   = v(inn)-v(agnd)

let off_voutp  = v(outp)-v(agnd)
let off_voutn  = v(outn)-v(agnd)
let off_voutcm = (off_voutp+off_voutn)/2
let off_vod    = off_voutp-off_voutn

let off_idd    = -vavdd#branch
let off_cmfb   = v(cmfb)-v(agnd)

setscale off_vdiff

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_offset.txt off_vinp off_vinn off_voutp off_voutn off_voutcm off_vod off_idd off_cmfb


* Integrated noise
alter @VVCM[DC]  = $&vcm_run
alter @VDIFF[DC] = $&vos_run

alter @VVCM[ACMAG]   = 0
alter @VDIFF[ACMAG]  = 1
alter @VDIFF[ACPHASE] = 0
alter @VAVDD[ACMAG]  = 0
alter @VAVSS[ACMAG]  = 0

noise v(outp,outn) VDIFF dec 100 0.05 150

setplot noise2

let input_noise_Vrms  = inoise_total
let output_noise_Vrms = onoise_total

echo f_low_Hz f_high_Hz input_noise_Vrms output_noise_Vrms > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_noise_integrated.txt
echo 0.05 150 $&input_noise_Vrms $&output_noise_Vrms >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_noise_integrated.txt


* Noise density
noise v(outp,outn) VDIFF dec 100 0.01 10Meg

setplot noise3

let input_noise_VrtHz  = inoise_spectrum
let output_noise_VrtHz = onoise_spectrum

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.ol_noise.txt input_noise_VrtHz output_noise_VrtHz

quit
.endc
"}
C {devices/code_shown.sym} 80 -440 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}

.param VOSDC=0
.param CMFB_BIAS=2.4849
.param CMFB_GAIN=500

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(CMFB)=\{CMFB_BIAS\} v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
"}
C {vsource.sym} 40 -650 0 0 {name=VAVSS       value="dc \{AVSS_SET\} ac 0"       savecurrent=true}
C {gnd.sym} 40 -620 0 0 {name=l11 lab=0}
C {lab_wire.sym} 40 -700 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 350 -920 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 200 -600 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 200 -740 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -740 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -980 2 0 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -650 0 0 {name=EINN        value=-0.5}
C {vcvs.sym} 620 -790 0 0 {name=EINP        value=0.5}
C {lab_wire.sym} 620 -840 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -700 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -740 2 0 {name=p16 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 620 -600 2 0 {name=p17 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 560 -630 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -770 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -670 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -810 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDC/FDC.sym} 220 -900 0 0 {name=xSEOTA1}
C {capa.sym} 680 -1030 0 0 {name=CLN
m=1
value=40p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 680 -980 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 480 -1120 0 1 {name=p22 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 680 -1080 0 1 {name=p25 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 480 -960 0 1 {name=p26 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 380 -920 2 0 {name=p27 sig_type=std_logic lab=CMFB}
C {vsource.sym} 360 -650 0 0 {name=VCMFBBIAS   value="dc \{CMFB_BIAS\} ac 0"      savecurrent=false}
C {lab_wire.sym} 360 -600 2 0 {name=VCMFB2 sig_type=std_logic lab=AGND
value="dc \{CMFB_BIAS\} ac 0"}
C {vcvs.sym} 800 -650 0 0 {name=EOUTCM      value=0.5}
C {vcvs.sym} 800 -790 0 0 {name=EOPH        value=0.5}
C {lab_wire.sym} 800 -840 0 0 {name=p23 sig_type=std_logic lab=OPH}
C {lab_wire.sym} 800 -700 0 0 {name=p24 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 800 -740 2 0 {name=p28 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 800 -600 2 0 {name=p29 sig_type=std_logic lab=OPH}
C {lab_wire.sym} 740 -630 2 1 {name=p30 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -770 2 1 {name=p31 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -670 0 0 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 740 -810 0 0 {name=p33 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 360 -700 0 0 {name=p34 sig_type=std_logic lab=CMFBBIAS}
C {vcvs.sym} 980 -790 0 0 {name=ECMERR      value=1}
C {lab_wire.sym} 980 -840 0 0 {name=p35 sig_type=std_logic lab=CMERR}
C {lab_wire.sym} 980 -740 2 0 {name=p36 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 920 -770 2 1 {name=p37 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 920 -810 0 0 {name=p38 sig_type=std_logic lab=VCM}
C {vcvs.sym} 980 -650 0 0 {name=ECMFB       value=\{CMFB_GAIN\}}
C {lab_wire.sym} 980 -700 0 0 {name=p39 sig_type=std_logic lab=CMFB}
C {lab_wire.sym} 980 -600 2 0 {name=p40 sig_type=std_logic lab=CMFBBIAS}
C {lab_wire.sym} 920 -630 2 1 {name=p41 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 920 -670 0 0 {name=p42 sig_type=std_logic lab=CMERR}
