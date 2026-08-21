v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -260 {}
N 620 -1180 640 -1180 {lab=REF}
N 620 -1220 640 -1220 {lab=INP}
N 620 -1140 640 -1140 {lab=INN}
N 240 -960 240 -940 {lab=VINCM}
N 240 -820 240 -800 {lab=VDIFF}
N 80 -820 80 -800 {lab=AGND}
N 690 -1100 690 -1080 {lab=AGND}
N 240 -880 240 -860 {lab=AGND}
N 240 -740 240 -720 {lab=AGND}
N 400 -960 400 -940 {lab=REF}
N 400 -880 400 -860 {lab=AGND}
N 640 -960 640 -940 {lab=INP}
N 640 -880 640 -860 {lab=VINCM}
N 640 -820 640 -800 {lab=INN}
N 640 -740 640 -720 {lab=VINCM}
N 580 -930 600 -930 {lab=VDIFF}
N 580 -890 600 -890 {lab=AGND}
N 580 -790 600 -790 {lab=VDIFF}
N 580 -750 600 -750 {lab=AGND}
N 720 -1100 720 -1080 {lab=BCMFB}
N 720 -1280 720 -1260 {lab=BFDC}
N 880 -1160 880 -1140 {lab=AGND}
N 800 -1220 820 -1220 {lab=OUTN}
N 800 -1140 820 -1140 {lab=OUTP}
N 880 -1240 880 -1220 {lab=OUTP}
N 960 -1160 960 -1140 {lab=AGND}
N 960 -1240 960 -1220 {lab=OUTN}
N 800 -1180 820 -1180 {lab=VOCM}
N 120 -1120 120 -1080 {lab=AVDD}
N 160 -1120 160 -1080 {lab=AGND}
N 320 -1170 320 -1120 {lab=BFDC}
N 320 -1280 320 -1230 {lab=AVDD}
N 200 -1200 280 -1200 {lab=BP}
N 320 -1200 340 -1200 {lab=AVDD}
N 340 -1240 340 -1200 {lab=AVDD}
N 320 -1240 340 -1240 {lab=AVDD}
N 200 -1160 240 -1160 {lab=REF}
N 80 -960 80 -940 {lab=AVDD}
N 690 -1280 690 -1260 {lab=AVDD}
N 480 -1170 480 -1120 {lab=BCMFB}
N 480 -1280 480 -1230 {lab=AVDD}
N 480 -1200 500 -1200 {lab=AVDD}
N 500 -1240 500 -1200 {lab=AVDD}
N 480 -1240 500 -1240 {lab=AVDD}
N 400 -1200 440 -1200 {lab=BP}
N 800 -960 800 -940 {lab=VOUTDIFF}
N 800 -880 800 -860 {lab=AGND}
N 740 -930 760 -930 {lab=OUTP}
N 740 -890 760 -890 {lab=OUTN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 80 -910 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -880 0 0 {name=l5 lab=0}
C {vsource.sym} 240 -910 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 240 -770 0 0 {name=VDIFF value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 620 -1180 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 240 -960 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 620 -1220 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 240 -820 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 620 -1140 0 0 {name=p6 sig_type=std_logic lab=INN}
C {devices/code_shown.sym} 80 -630 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=0

.param VDD_SET=3.3
.param TEMP_SET=27

.temp \{TEMP_SET\}
"}
C {devices/code_shown.sym} 660 -630 0 0 {name=NGSPICE
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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_*.txt

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
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

* OP

op

let vdd = v(AVDD)-v(AGND)
let vinp = v(INP)-v(AGND)
let vinn = v(INN)-v(AGND)
let voutp = v(OUTP)-v(AGND)
let voutn = v(OUTN)-v(AGND)
let voutcm = 0.5*(voutp+voutn)
let voutdiff = voutp-voutn
let vref = v(REF)-v(AGND)
let vocm = v(VOCM)-v(AGND)
let bfdc = v(BFDC)-v(AGND)
let bcmfb = v(BCMFB)-v(AGND)
let idd_total = abs(vavdd#branch)
let ibias_fdc = abs(@m.xmbfdc.m0[id])
let ibias_cmfb = abs(@m.xmbcmfb.m0[id])

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_op.txt vdd vinp vinn voutp voutn voutcm voutdiff vref vocm bfdc bcmfb idd_total ibias_fdc ibias_cmfb

* DIFF AC

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_diff = v(INP)-v(INN)
let vout_diff = v(OUTP)-v(OUTN)
let vin_diff_real = real(vin_diff)
let vin_diff_imag = imag(vin_diff)
let vout_diff_real = real(vout_diff)
let vout_diff_imag = imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_diff_ac.txt vin_diff_real vin_diff_imag vout_diff_real vout_diff_imag

* CM AC

alter @VCM[ACMAG]=1
alter @VCM[ACPHASE]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let vout_diff = v(OUTP)-v(OUTN)
let vin_cm_real = real(vin_cm)
let vin_cm_imag = imag(vin_cm)
let vout_diff_real = real(vout_diff)
let vout_diff_imag = imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_cm_ac.txt vin_cm_real vin_cm_imag vout_diff_real vout_diff_imag

* PSRR+

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=1
alter @VAVDD[ACPHASE]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vsup = v(AVDD)-v(AGND)
let vout_diff = v(OUTP)-v(OUTN)
let vsup_real = real(vsup)
let vsup_imag = imag(vsup)
let vout_diff_real = real(vout_diff)
let vout_diff_imag = imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrp_ac.txt vsup_real vsup_imag vout_diff_real vout_diff_imag

* PSRR-

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=1
alter @VAVSS[ACPHASE]=0

ac dec 200 0.01 1G

let vagnd = v(AGND)
let vout_diff = v(OUTP)-v(OUTN)
let vagnd_real = real(vagnd)
let vagnd_imag = imag(vagnd)
let vout_diff_real = real(vout_diff)
let vout_diff_imag = imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrn_ac.txt vagnd_real vagnd_imag vout_diff_real vout_diff_imag

* VTC / OFFSET

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

dc VDIFF -20m 20m 1u

let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff = v(INP)-v(INN)
let voutp = v(OUTP)-v(AGND)
let voutn = v(OUTN)-v(AGND)
let voutcm = 0.5*(voutp+voutn)
let voutdiff = voutp-voutn
let vocm = v(VOCM)-v(AGND)
let idd_total = abs(vavdd#branch)

setscale vin_diff

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_vtc.txt vin_cm v(INP) v(INN) voutp voutn voutcm voutdiff vocm idd_total

* NOISE

option sparse

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

noise v(VOUTDIFF) VDIFF dec 100 0.01 1k

setplot previous
setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_noise.txt onoise_spectrum inoise_spectrum

end
end

quit

.endc
"}
C {devices/code_shown.sym} 80 -270 0 0 {name=SETUP
only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}
.param CL_SET=40p

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {vsource.sym} 80 -770 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -740 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -820 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 690 -1080 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 240 -720 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 240 -860 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {vsource.sym} 400 -910 0 0 {name=VREFSTEP value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 400 -960 0 0 {name=p22 sig_type=std_logic lab=REF}
C {lab_wire.sym} 400 -860 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {vcvs.sym} 640 -910 0 0 {name=EINP value=0.5}
C {vcvs.sym} 640 -770 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 640 -960 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 580 -930 0 0 {name=p15 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 580 -890 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -790 0 0 {name=p17 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 580 -750 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -860 2 0 {name=p19 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 640 -720 2 0 {name=p20 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 640 -820 0 0 {name=p21 sig_type=std_logic lab=INN}
C {lab_wire.sym} 720 -1080 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 720 -1280 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {capa.sym} 880 -1190 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 880 -1240 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 880 -1140 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 960 -1190 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 960 -1140 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 820 -1140 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 960 -1240 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 820 -1220 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 820 -1180 0 1 {name=p7 sig_type=std_logic lab=VOCM}
C {noconn.sym} 820 -1180 0 1 {name=l3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 560 -1040 0 0 {name=xFDOTA1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 40 -1080 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -1080 2 1 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1080 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -1200 0 0 {name=MBFDC
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
C {lab_wire.sym} 320 -1280 0 0 {name=p34 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -1120 2 1 {name=p35 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 240 -1160 0 1 {name=p36 sig_type=std_logic lab=REF}
C {lab_wire.sym} 240 -1200 0 1 {name=p37 sig_type=std_logic lab=BP}
C {lab_wire.sym} 80 -960 0 0 {name=p38 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 690 -1280 0 0 {name=p39 sig_type=std_logic lab=AVDD}
C {symbols/pfet_03v3.sym} 460 -1200 0 0 {name=MBCMFB
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
C {lab_wire.sym} 480 -1280 0 0 {name=p40 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 480 -1120 2 1 {name=p41 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 400 -1200 0 1 {name=p42 sig_type=std_logic lab=BP}
C {vcvs.sym} 800 -910 0 0 {name=EOUTDIFF value=1}
C {lab_wire.sym} 800 -960 0 0 {name=p1 sig_type=std_logic lab=VOUTDIFF}
C {lab_wire.sym} 740 -930 0 0 {name=p12 sig_type=std_logic lab=OUTP
}
C {lab_wire.sym} 740 -890 0 0 {name=p26 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 800 -860 2 0 {name=p27 sig_type=std_logic lab=AGND}
