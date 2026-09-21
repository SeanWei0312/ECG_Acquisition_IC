v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -790 {}
N 860 -1780 900 -1780 {lab=OUTN}
N 860 -1900 900 -1900 {lab=OUTP}
N 320 -2000 320 -1960 {lab=REF}
N 360 -2000 360 -1960 {lab=BFDC}
N 400 -2000 400 -1960 {lab=BCMFB}
N 160 -1900 200 -1900 {lab=INP}
N 160 -1780 200 -1780 {lab=INN}
N 160 -1640 760 -1640 {lab=AGND}
N 160 -1680 720 -1680 {lab=AVDD}
N 1020 -1700 1020 -1680 {lab=AGND}
N 1020 -1780 1020 -1760 {lab=OUTP}
N 1100 -1700 1100 -1680 {lab=AGND}
N 1100 -1780 1100 -1760 {lab=OUTN}
N 200 -2080 200 -2040 {lab=AVDD}
N 240 -2080 240 -2040 {lab=AGND}
N 280 -2160 360 -2160 {lab=BP}
N 400 -2130 400 -2080 {lab=BFDC}
N 400 -2240 400 -2190 {lab=AVDD}
N 400 -2160 420 -2160 {lab=AVDD}
N 420 -2200 420 -2160 {lab=AVDD}
N 400 -2200 420 -2200 {lab=AVDD}
N 560 -2130 560 -2080 {lab=BCMFB}
N 560 -2240 560 -2190 {lab=AVDD}
N 560 -2160 580 -2160 {lab=AVDD}
N 580 -2200 580 -2160 {lab=AVDD}
N 560 -2200 580 -2200 {lab=AVDD}
N 480 -2160 520 -2160 {lab=BP}
N 80 -1220 80 -1200 {lab=AGND}
N 80 -1360 80 -1340 {lab=AVDD}
N 240 -1220 240 -1200 {lab=VDIFF}
N 240 -1360 240 -1340 {lab=VCM}
N 560 -1220 560 -1200 {lab=PGA_SEL}
N 560 -1360 560 -1340 {lab=REF}
N 1360 -1220 1360 -1200 {lab=EXTVDIFF}
N 1360 -1360 1360 -1340 {lab=EXTVCM}
N 1200 -1360 1200 -1340 {lab=INP}
N 1200 -1280 1200 -1260 {lab=VCM}
N 1140 -1330 1160 -1330 {lab=VDIFF}
N 1140 -1290 1160 -1290 {lab=AGND}
N 1200 -1220 1200 -1200 {lab=INN}
N 1200 -1140 1200 -1120 {lab=VCM}
N 1360 -1280 1360 -1260 {lab=AGND}
N 1360 -1140 1360 -1120 {lab=AGND}
N 560 -1140 560 -1120 {lab=AGND}
N 240 -1140 240 -1120 {lab=AGND}
N 240 -1280 240 -1260 {lab=AGND}
N 560 -1280 560 -1260 {lab=AGND}
N 1840 -1360 1840 -1340 {lab=FDBUF_EXTP}
N 1840 -1280 1840 -1260 {lab=EXTVCM}
N 1780 -1330 1800 -1330 {lab=EXTVDIFF}
N 1780 -1290 1800 -1290 {lab=AGND}
N 1840 -1220 1840 -1200 {lab=FDBUF_EXTN}
N 1840 -1140 1840 -1120 {lab=EXTVCM}
N 1780 -1190 1800 -1190 {lab=EXTVDIFF}
N 1780 -1150 1800 -1150 {lab=AGND}
N 1140 -1190 1160 -1190 {lab=VDIFF}
N 1140 -1150 1160 -1150 {lab=AGND}
N 500 -1900 500 -1600 {lab=FDBUF_OUTP}
N 460 -1780 540 -1780 {lab=FDBUF_OUTN}
N 540 -1860 660 -1860 {lab=FDBUF_OUTN}
N 540 -1860 540 -1560 {lab=FDBUF_OUTN}
N 460 -1900 660 -1900 {lab=FDBUF_OUTP}
N 760 -1720 760 -1640 {lab=AGND}
N 720 -1720 720 -1680 {lab=AVDD}
N 800 -1720 800 -1600 {lab=FDBUF_SEL}
N 280 -1720 280 -1640 {lab=AGND}
N 240 -1720 240 -1680 {lab=AVDD}
N 460 -1600 500 -1600 {lab=FDBUF_OUTP}
N 460 -1560 540 -1560 {lab=FDBUF_OUTN}
N 620 -1820 660 -1820 {lab=FDBUF_EXTP}
N 620 -1820 620 -1600 {lab=FDBUF_EXTP}
N 620 -1600 660 -1600 {lab=FDBUF_EXTP}
N 580 -1560 660 -1560 {lab=FDBUF_EXTN}
N 580 -1780 580 -1560 {lab=FDBUF_EXTN}
N 580 -1780 660 -1780 {lab=FDBUF_EXTN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -1030 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=0
"}
C {devices/code_shown.sym} 80 -630 0 0 {name=SETUP
only_toplevel=true
value="
.param VDD_SET=3.3
.param TEMP_SET=27

.param VCM_SET=\{VDD_SET/2\}
.param VREF_SET=\{VDD_SET/2\}

.param CL_SET=10p

.param FDBUF_GAIN_TARGET_SET=1

.param TRAN_AMP_SET=50m
.param TRAN_FREQ_SET=10

.param EXT_TRAN_AMP_SET=0
.param EXT_TRAN_FREQ_SET=25

.param SEL_TRAN_HIGH_SET=0
.param SEL_SWITCH_TIME_SET=200m

.csparam MC_RUNS=200

.temp \{TEMP_SET\}

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {devices/code_shown.sym} 960 -1030 0 0 {name=NGSPICE
only_toplevel=true
value="

.control

destroy all

set noaskquit
set wr_singlescale
unset wr_vecnames

option klu
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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.*.txt

foreach vddval 3.3 3.0 3.6
foreach tval 27 -40 125

if $vddval = 3.3
if $tval = 27
set env=nom
else
if $tval = -40
set env=tl
else
set env=th
end
end
else
if $vddval = 3.0
if $tval = 27
set env=vl
else
if $tval = -40
set env=vltl
else
set env=vlth
end
end
else
if $tval = 27
set env=vh
else
if $tval = -40
set env=vhtl
else
set env=vhth
end
end
end
end

alterparam VDD_SET=$vddval
alterparam TEMP_SET=$tval
alterparam SEL_TRAN_HIGH_SET=0
alterparam EXT_TRAN_AMP_SET=0

reset

alter @VSEL[DC]=0

alter @VDIFF[DC]=0

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

save all
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]


* OFFSET

dc VDIFF -20m 20m 10u

let fdbuf_diff=v(FDBUF_OUTP)-v(FDBUF_OUTN)

meas dc vos_meas when fdbuf_diff=0 cross=1

set vos_val=$&vos_meas

echo $vos_val > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.vos_\{$env\}.txt

destroy all

alter @VDIFF[DC]=$vos_val


* OP

op

let op_index=0

let vdd=v(AVDD)-v(AGND)
let vref=v(REF)-v(AGND)

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff=v(INP)-v(INN)

let fdbuf_out_cm=0.5*(v(FDBUF_OUTP)+v(FDBUF_OUTN))-v(AGND)
let fdbuf_out_diff=v(FDBUF_OUTP)-v(FDBUF_OUTN)
let fdbuf_cm_error=fdbuf_out_cm-vref

let out_cm=0.5*(v(OUTP)+v(OUTN))-v(AGND)
let out_diff=v(OUTP)-v(OUTN)

let idd_total=abs(vavdd#branch)
let power_total=vdd*idd_total

let ibfdc=abs(@m.xmbfdc.m0[id])
let ibcmfb=abs(@m.xmbcmfb.m0[id])

setscale op_index

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.op_\{$env\}.txt vdd vref vin_cm vin_diff fdbuf_out_cm fdbuf_out_diff fdbuf_cm_error out_cm out_diff idd_total power_total ibfdc ibcmfb

destroy all


* DIFF AC

alter @VDIFF[ACMAG]=1
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 150 0.01 100Meg

let vin_diff=v(INP)-v(INN)
let fdbuf_diff=v(FDBUF_OUTP)-v(FDBUF_OUTN)
let out_diff=v(OUTP)-v(OUTN)

let vin_r=real(vin_diff)
let vin_i=imag(vin_diff)

let fdbuf_r=real(fdbuf_diff)
let fdbuf_i=imag(fdbuf_diff)

let out_r=real(out_diff)
let out_i=imag(out_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.diff_ac_\{$env\}.txt vin_r vin_i fdbuf_r fdbuf_i out_r out_i

destroy all


* CMRR

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=1
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 100 0.01 1Meg

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let fdbuf_diff=v(FDBUF_OUTP)-v(FDBUF_OUTN)

let vin_r=real(vin_cm)
let vin_i=imag(vin_cm)

let out_r=real(fdbuf_diff)
let out_i=imag(fdbuf_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.cmrr_ac_\{$env\}.txt vin_r vin_i out_r out_i

destroy all


* PSRR+

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=1
alter @VAVDD[ACPHASE]=0
alter @VAVSS[ACMAG]=0

ac dec 100 0.01 1Meg

let vsup=v(AVDD)-v(AGND)
let fdbuf_diff=v(FDBUF_OUTP)-v(FDBUF_OUTN)

let vsup_r=real(vsup)
let vsup_i=imag(vsup)

let out_r=real(fdbuf_diff)
let out_i=imag(fdbuf_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.psrrp_ac_\{$env\}.txt vsup_r vsup_i out_r out_i

destroy all


* PSRR-

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=1
alter @VAVSS[ACPHASE]=0

ac dec 100 0.01 1Meg

let vsup=v(AVDD)-v(AGND)
let fdbuf_diff=v(FDBUF_OUTP)-v(FDBUF_OUTN)

let vsup_r=real(vsup)
let vsup_i=imag(vsup)

let out_r=real(fdbuf_diff)
let out_i=imag(fdbuf_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.psrrn_ac_\{$env\}.txt vsup_r vsup_i out_r out_i

destroy all


* NOISE

alter @VDIFF[ACMAG]=1
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

noise v(FDBUF_OUTP,FDBUF_OUTN) VDIFF dec 100 0.01 10k

setplot previous
setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.noise_\{$env\}.txt onoise_spectrum inoise_spectrum

destroy all

end
end


* SEL FUNCTIONAL

if $&PROC_ID = 0

alterparam VDD_SET=3.3
alterparam TEMP_SET=27

alterparam TRAN_AMP_SET=50m
alterparam TRAN_FREQ_SET=10

alterparam EXT_TRAN_AMP_SET=50m
alterparam EXT_TRAN_FREQ_SET=25

alterparam SEL_TRAN_HIGH_SET=3.3
alterparam SEL_SWITCH_TIME_SET=200m

reset

save all

tran 20u 400m

let int_diff=v(FDBUF_OUTP)-v(FDBUF_OUTN)
let ext_diff=v(FDBUF_EXTP)-v(FDBUF_EXTN)
let out_diff=v(OUTP)-v(OUTN)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/FDBUF/\{$proc\}.Result_txt/\{$proc\}.sel_tran_nom.txt v(FDBUF_SEL) int_diff ext_diff out_diff

destroy all

end

quit

.endc

"}
C {lab_wire.sym} 160 -1900 0 0 {name=p28 sig_type=std_logic lab=INP}
C {lab_wire.sym} 160 -1780 0 0 {name=p29 sig_type=std_logic lab=INN}
C {lab_wire.sym} 160 -1680 0 0 {name=p30 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1640 0 0 {name=p32 sig_type=std_logic lab=AGND}
C {capa.sym} 1020 -1730 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1020 -1780 0 1 {name=p1 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1020 -1680 2 0 {name=p2 sig_type=std_logic lab=AGND}
C {capa.sym} 1100 -1730 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1100 -1680 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1100 -1780 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 900 -1900 0 1 {name=p3 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 900 -1780 0 1 {name=p4 sig_type=std_logic lab=OUTN}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/AFE_BLOCKS/BIAS/BIAS.sym} 120 -2040 0 0 {name=xBIAS1}
C {lab_wire.sym} 200 -2040 2 1 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 240 -2040 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 320 -2160 0 1 {name=p37 sig_type=std_logic lab=BP}
C {lab_wire.sym} 320 -2000 0 0 {name=p7 sig_type=std_logic lab=REF}
C {symbols/pfet_03v3.sym} 380 -2160 0 0 {name=MBFDC
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
C {lab_wire.sym} 400 -2240 0 0 {name=p14 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 400 -2080 2 1 {name=p15 sig_type=std_logic lab=BFDC}
C {symbols/pfet_03v3.sym} 540 -2160 0 0 {name=MBCMFB
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
C {lab_wire.sym} 560 -2240 0 0 {name=p17 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 560 -2080 2 1 {name=p18 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 480 -2160 0 1 {name=p19 sig_type=std_logic lab=BP}
C {lab_wire.sym} 400 -2000 0 1 {name=p20 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 360 -2000 0 1 {name=p21 sig_type=std_logic lab=BFDC}
C {vsource.sym} 80 -1310 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -1280 0 0 {name=l5 lab=0}
C {vsource.sym} 80 -1170 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -1140 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -1220 0 0 {name=p24 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -1360 0 0 {name=p55 sig_type=std_logic lab=AVDD}
C {vsource.sym} 240 -1310 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 240 -1170 0 0 {name=VDIFF value="dc 0 ac 1 sin(0 \{TRAN_AMP_SET\} \{TRAN_FREQ_SET\})" savecurrent=false
}
C {lab_wire.sym} 240 -1220 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 240 -1360 0 0 {name=p6 sig_type=std_logic lab=VCM}
C {vsource.sym} 560 -1310 0 0 {name=VREF value="dc \{VREF_SET\} ac 0" savecurrent=false}
C {vsource.sym} 560 -1170 0 0 {name=VSEL value="dc 0 ac 0 pulse(0 \{SEL_TRAN_HIGH_SET\} \{SEL_SWITCH_TIME_SET\} 1u 1u 400m 800m)" savecurrent=false
}
C {lab_wire.sym} 560 -1220 0 0 {name=p10 sig_type=std_logic lab=FDBUF_SEL}
C {lab_wire.sym} 560 -1360 0 0 {name=p11 sig_type=std_logic lab=REF

}
C {vsource.sym} 1360 -1310 0 0 {name=VEXTCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 1360 -1170 0 0 {name=VEXTDIFF value="dc 0 ac 0 sin(0 \{EXT_TRAN_AMP_SET\} \{EXT_TRAN_FREQ_SET\})" savecurrent=false
}
C {lab_wire.sym} 1360 -1220 0 0 {name=p22 sig_type=std_logic lab=EXTVDIFF}
C {lab_wire.sym} 1360 -1360 0 0 {name=p23 sig_type=std_logic lab=EXTVCM}
C {vcvs.sym} 1200 -1310 0 0 {name=EINP value="0.5" savecurrent=false}
C {lab_wire.sym} 1200 -1360 0 0 {name=p74 sig_type=std_logic lab=INP}
C {lab_wire.sym} 1140 -1330 0 0 {name=p75 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 1140 -1290 0 0 {name=p76 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -1260 2 0 {name=p77 sig_type=std_logic lab=VCM}
C {vcvs.sym} 1200 -1170 0 0 {name=EINN value="-0.5" savecurrent=false}
C {lab_wire.sym} 1200 -1220 0 0 {name=p8 sig_type=std_logic lab=INN}
C {lab_wire.sym} 1200 -1120 2 0 {name=p16 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 1360 -1260 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1360 -1120 2 0 {name=p26 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -1120 2 0 {name=p27 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 240 -1120 2 0 {name=p34 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 240 -1260 2 0 {name=p35 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -1260 2 0 {name=p36 sig_type=std_logic lab=AGND}
C {vcvs.sym} 1840 -1310 0 0 {name=EEXTP value="0.5" savecurrent=false}
C {lab_wire.sym} 1840 -1360 0 0 {name=p38 sig_type=std_logic lab=FDBUF_EXTP}
C {lab_wire.sym} 1780 -1330 0 0 {name=p39 sig_type=std_logic lab=EXTVDIFF
}
C {lab_wire.sym} 1780 -1290 0 0 {name=p40 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1840 -1260 2 0 {name=p41 sig_type=std_logic lab=EXTVCM}
C {vcvs.sym} 1840 -1170 0 0 {name=EEXTN value="-0.5" savecurrent=false}
C {lab_wire.sym} 1840 -1220 0 0 {name=p42 sig_type=std_logic lab=FDBUF_EXTN}
C {lab_wire.sym} 1780 -1190 0 0 {name=p43 sig_type=std_logic lab=EXTVDIFF
}
C {lab_wire.sym} 1780 -1150 0 0 {name=p44 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1840 -1120 2 0 {name=p45 sig_type=std_logic lab=EXTVCM}
C {lab_wire.sym} 1140 -1190 0 0 {name=p9 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 1140 -1150 0 0 {name=p12 sig_type=std_logic lab=AGND}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/DIGITAL_BLOCKS/MUXD/MUXD.sym} 600 -1680 0 0 {name=xMUXD4}
C {lab_wire.sym} 800 -1600 2 0 {name=p87 sig_type=std_logic lab=FDBUF_SEL}
C {lab_wire.sym} 460 -1600 0 0 {name=p92 sig_type=std_logic lab=FDBUF_OUTP}
C {lab_wire.sym} 460 -1560 0 0 {name=p93 sig_type=std_logic lab=FDBUF_OUTN}
C {lab_wire.sym} 660 -1600 0 1 {name=p132 sig_type=std_logic lab=FDBUF_EXTP}
C {lab_wire.sym} 660 -1560 0 1 {name=p133 sig_type=std_logic lab=FDBUF_EXTN}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/AFE_BLOCKS/FDBUF/FDBUF.sym} 120 -1680 0 0 {name=xFDBUF1}
