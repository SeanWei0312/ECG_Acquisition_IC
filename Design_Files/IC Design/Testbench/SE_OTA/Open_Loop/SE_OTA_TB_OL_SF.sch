v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -420 {}
N 520 -1080 540 -1080 {lab=B}
N 520 -1120 540 -1120 {lab=INP}
N 520 -1040 540 -1040 {lab=INN}
N 700 -1080 780 -1080 {lab=OUT}
N 360 -900 360 -880 {lab=VINCM}
N 360 -760 360 -740 {lab=VDIFF}
N 200 -760 200 -740 {lab=AGND}
N 360 -820 360 -800 {lab=AGND}
N 780 -1020 780 -1000 {lab=AGND}
N 360 -680 360 -660 {lab=AGND}
N 620 -900 620 -880 {lab=INP}
N 620 -760 620 -740 {lab=INN}
N 620 -820 620 -800 {lab=VINCM}
N 620 -680 620 -660 {lab=VINCM}
N 560 -870 580 -870 {lab=VDIFF}
N 560 -830 580 -830 {lab=AGND}
N 560 -730 580 -730 {lab=VDIFF}
N 560 -690 580 -690 {lab=AGND}
N 620 -1000 620 -980 {lab=AGND}
N 200 -1020 200 -980 {lab=AVDD}
N 240 -1020 240 -980 {lab=AGND}
N 400 -1070 400 -1020 {lab=B}
N 400 -1180 400 -1130 {lab=AVDD}
N 280 -1100 360 -1100 {lab=BP}
N 400 -1100 420 -1100 {lab=AVDD}
N 420 -1140 420 -1100 {lab=AVDD}
N 400 -1140 420 -1140 {lab=AVDD}
N 280 -1060 320 -1060 {lab=VREF}
N 200 -900 200 -880 {lab=AVDD}
N 620 -1180 620 -1160 {lab=AVDD}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 200 -850 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 200 -820 0 0 {name=l5 lab=0}
C {capa.sym} 780 -1050 0 0 {name=CL
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 360 -850 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 360 -710 0 0 {name=VDIFF value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 520 -1080 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 360 -900 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 520 -1120 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 360 -760 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 520 -1040 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 780 -1080 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -550 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice sf
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=4

.param VDD_SET=3.3
.param TEMP_SET=27

.temp \{TEMP_SET\}
"}
C {devices/code_shown.sym} 640 -550 0 0 {name=NGSPICE
only_toplevel=true
value="

.control

destroy all

set noaskquit
set wr_singlescale
unset wr_vecnames

option numdgt=15
option method=gear
option maxord=2
option plotwinsize=0

if $&PROC_ID = 0
set proc=NOM
else
if $&PROC_ID = 1
set proc=FF
else
if $&PROC_ID = 2
set proc=SS
else
if $&PROC_ID = 3
set proc=FS
else
set proc=SF
end
end
end
end

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_*.txt

foreach vddval 3.3 3.0 3.6
foreach tval 27 -40 125

if $vddval = 3.3
if $tval = 27
set case=nom
else
if $tval = -40
set case=tl
else
set case=th
end
end
else
if $vddval = 3.0
if $tval = 27
set case=vl
else
if $tval = -40
set case=vltl
else
set case=vlth
end
end
else
if $tval = 27
set case=vh
else
if $tval = -40
set case=vhtl
else
set case=vhth
end
end
end
end

alterparam VDD_SET=$vddval
alterparam TEMP_SET=$tval
reset

option klu

save all
save @m.xmbias.m0[id]

op

let vdd = v(AVDD)-v(AGND)
let vinp = v(INP)-v(AGND)
let vinn = v(INN)-v(AGND)
let vout = v(OUT)-v(AGND)
let idd_total = abs(vavdd#branch)
let ibias = abs(@m.xmbias.m0[id])

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_op.txt vdd vinp vinn vout v(B) idd_total ibias

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_diff = v(INP)-v(INN)
let vout = v(OUT)-v(AGND)
let vin_diff_real = real(vin_diff)
let vin_diff_imag = imag(vin_diff)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_diff_ac.txt vin_diff_real vin_diff_imag vout_real vout_imag

alter @VCM[ACMAG]=1
alter @VCM[ACPHASE]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let vout = v(OUT)-v(AGND)
let vin_cm_real = real(vin_cm)
let vin_cm_imag = imag(vin_cm)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_cm_ac.txt vin_cm_real vin_cm_imag vout_real vout_imag

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=1
alter @VAVDD[ACPHASE]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vsup = v(AVDD)-v(AGND)
let vout = v(OUT)-v(AGND)
let vsup_real = real(vsup)
let vsup_imag = imag(vsup)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrp_ac.txt vsup_real vsup_imag vout_real vout_imag

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=1
alter @VAVSS[ACPHASE]=0

ac dec 200 0.01 1G

let vagnd = v(AGND)
let vout = v(OUT)-v(AGND)
let vagnd_real = real(vagnd)
let vagnd_imag = imag(vagnd)
let vout_real = real(vout)
let vout_imag = imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrn_ac.txt vagnd_real vagnd_imag vout_real vout_imag

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

dc VDIFF -20m 20m 1u

let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff = v(INP)-v(INN)
let vout = v(OUT)-v(AGND)
let idd_total = abs(vavdd#branch)

setscale vin_diff

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_vtc.txt vin_cm v(INP) v(INN) vout idd_total

option sparse

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

noise v(OUT) VDIFF dec 100 0.01 1k

setplot previous
setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_noise.txt onoise_spectrum inoise_spectrum

end
end

quit

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 460 -940 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -270 0 0 {name=SETUP
only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}
.param CL_SET=10p

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {vsource.sym} 200 -710 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 200 -680 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -760 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 620 -980 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -660 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -800 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 780 -1000 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -710 0 0 {name=EINN value=-0.5}
C {vcvs.sym} 620 -850 0 0 {name=EINP value=0.5}
C {lab_wire.sym} 620 -900 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -760 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -800 2 0 {name=p16 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 620 -660 2 0 {name=p17 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 560 -690 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -830 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -730 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -870 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 120 -980 0 0 {name=xBIAS1}
C {lab_wire.sym} 200 -980 2 1 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 240 -980 2 1 {name=p12 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 380 -1100 0 0 {name=MBIAS
L=4u
W=16u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 400 -1180 0 0 {name=p22 sig_type=std_logic lab=AVDD}
C {noconn.sym} 320 -1060 0 1 {name=l3}
C {lab_wire.sym} 400 -1020 2 1 {name=p23 sig_type=std_logic lab=B}
C {lab_wire.sym} 320 -1060 0 1 {name=p24 sig_type=std_logic lab=VREF}
C {lab_wire.sym} 200 -900 0 0 {name=p25 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 620 -1180 0 0 {name=p26 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -1100 0 1 {name=p27 sig_type=std_logic lab=BP}
