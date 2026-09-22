v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -670 {}
N 1320 -740 1360 -740 {lab=OUTN}
N 1320 -860 1360 -860 {lab=OUTP}
N 780 -960 780 -920 {lab=REF}
N 820 -960 820 -920 {lab=BFDC}
N 860 -960 860 -920 {lab=BCMFB}
N 600 -860 640 -860 {lab=INP}
N 600 -740 640 -740 {lab=INN}
N 600 -600 1220 -600 {lab=AGND}
N 600 -640 1180 -640 {lab=AVDD}
N 1480 -1000 1480 -960 {lab=AGND}
N 1480 -900 1480 -860 {lab=OUTP}
N 1480 -640 1480 -600 {lab=AGND}
N 1480 -740 1480 -700 {lab=OUTN}
N 640 -1040 640 -1000 {lab=AVDD}
N 680 -1040 680 -1000 {lab=AGND}
N 720 -1120 800 -1120 {lab=BP}
N 840 -1090 840 -1040 {lab=BFDC}
N 840 -1200 840 -1150 {lab=AVDD}
N 840 -1120 860 -1120 {lab=AVDD}
N 860 -1160 860 -1120 {lab=AVDD}
N 840 -1160 860 -1160 {lab=AVDD}
N 1000 -1090 1000 -1040 {lab=BCMFB}
N 1000 -1200 1000 -1150 {lab=AVDD}
N 1000 -1120 1020 -1120 {lab=AVDD}
N 1020 -1160 1020 -1120 {lab=AVDD}
N 1000 -1160 1020 -1160 {lab=AVDD}
N 920 -1120 960 -1120 {lab=BP}
N 80 -260 80 -240 {lab=AGND}
N 80 -400 80 -380 {lab=AVDD}
N 740 -680 740 -600 {lab=AGND}
N 700 -680 700 -640 {lab=AVDD}
N 960 -860 960 -560 {lab=LPF_OUTP}
N 920 -740 1000 -740 {lab=LPF_OUTN}
N 1000 -820 1120 -820 {lab=LPF_OUTN}
N 1000 -820 1000 -520 {lab=LPF_OUTN}
N 920 -860 1120 -860 {lab=LPF_OUTP}
N 1220 -680 1220 -600 {lab=AGND}
N 1180 -680 1180 -640 {lab=AVDD}
N 1260 -680 1260 -560 {lab=LPF_SEL}
N 920 -560 960 -560 {lab=LPF_OUTP}
N 920 -520 1000 -520 {lab=LPF_OUTN}
N 1040 -740 1120 -740 {lab=LPF_EXTN}
N 1040 -740 1040 -520 {lab=LPF_EXTN}
N 1040 -520 1120 -520 {lab=LPF_EXTN}
N 1080 -560 1120 -560 {lab=LPF_EXTP}
N 1080 -780 1080 -560 {lab=LPF_EXTP}
N 1080 -780 1120 -780 {lab=LPF_EXTP}
N 1200 -260 1200 -240 {lab=VDIFF}
N 1200 -400 1200 -380 {lab=VCM}
N 640 -260 640 -240 {lab=LPF_SEL}
N 640 -400 640 -380 {lab=REF}
N 1760 -260 1760 -240 {lab=EXTVDIFF}
N 1760 -400 1760 -380 {lab=EXTVCM}
N 400 -940 400 -900 {lab=INP}
N 400 -840 400 -760 {lab=VCM}
N 320 -890 360 -890 {lab=VDIFF}
N 320 -850 360 -850 {lab=AGND}
N 400 -700 400 -660 {lab=INN}
N 1760 -320 1760 -300 {lab=AGND}
N 1760 -180 1760 -160 {lab=AGND}
N 640 -180 640 -160 {lab=AGND}
N 1200 -180 1200 -160 {lab=AGND}
N 1200 -320 1200 -300 {lab=AGND}
N 640 -320 640 -300 {lab=AGND}
N 160 -940 160 -900 {lab=LPF_EXTP}
N 160 -840 160 -760 {lab=EXTVCM}
N 80 -890 120 -890 {lab=EXTVDIFF}
N 80 -850 120 -850 {lab=AGND}
N 160 -700 160 -660 {lab=LPF_EXTN}
N 80 -710 120 -710 {lab=EXTVDIFF}
N 80 -750 120 -750 {lab=AGND}
N 320 -710 360 -710 {lab=VDIFF}
N 320 -750 360 -750 {lab=AGND}
N 480 -860 520 -860 {lab=INP}
N 480 -940 480 -860 {lab=INP}
N 480 -740 520 -740 {lab=INN}
N 480 -740 480 -660 {lab=INN}
N 400 -940 480 -940 {lab=INP}
N 400 -660 480 -660 {lab=INN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 90 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
* \{MODELS_START\}
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice fs
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=3
* \{MODELS_END\}
"}
C {devices/code_shown.sym} 640 90 0 0 {name=SETUP
only_toplevel=true
value="
* \{SETUP_START\}
.param VDD_SET=3.3
.param TEMP_SET=27

.param VCM_SET=\{VDD_SET/2\}
.param VREF_SET=\{VDD_SET/2\}

.param CL_SET=10p

.param LPF_GAIN_TARGET_SET=1
.param LPF_F1DB_TARGET_SET=150
.param LPF_F3DB_TARGET_SET=300

.param TRAN_AMP_SET=100m
.param TRAN_FREQ_SET=10

.param EXT_TRAN_AMP_SET=50m
.param EXT_TRAN_FREQ_SET=25

.param SEL_TRAN_HIGH_SET=0
.param SEL_SWITCH_TIME_SET=200m

.csparam MC_RUNS=200

.temp \{TEMP_SET\}

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
* \{SETUP_END\}
"}
C {devices/code_shown.sym} 1200 90 0 0 {name=NGSPICE
only_toplevel=true
value="
* \{MEAS_START\}
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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.*.txt

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

save all
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

* OFFSET

alter @VSEL[DC]=0
alter @VDIFF[DC]=0

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

dc VDIFF -10m 10m 10u

let lpf_diff=v(LPF_OUTP)-v(LPF_OUTN)

meas dc vos_meas when lpf_diff=0 cross=1

set vos_val=$&vos_meas

echo $vos_val > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.vos_\{$env\}.txt

destroy all

alter @VDIFF[DC]=$vos_val

* OP

op

let op_index=0

let vdd=v(AVDD)-v(AGND)
let vref=v(REF)-v(AGND)

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff=v(INP)-v(INN)

let lpf_out_cm=0.5*(v(LPF_OUTP)+v(LPF_OUTN))-v(AGND)
let lpf_out_diff=v(LPF_OUTP)-v(LPF_OUTN)
let lpf_cm_error=lpf_out_cm-vref

let out_cm=0.5*(v(OUTP)+v(OUTN))-v(AGND)
let out_diff=v(OUTP)-v(OUTN)

let idd_total=abs(vavdd#branch)
let power_total=vdd*idd_total

let ibfdc=abs(@m.xmbfdc.m0[id])
let ibcmfb=abs(@m.xmbcmfb.m0[id])

setscale op_index

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.op_\{$env\}.txt vdd vref vin_cm vin_diff lpf_out_cm lpf_out_diff lpf_cm_error out_cm out_diff idd_total power_total ibfdc ibcmfb

destroy all

* DIFF AC

alter @VDIFF[ACMAG]=1
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 100k

let vin_diff=v(INP)-v(INN)
let lpf_diff=v(LPF_OUTP)-v(LPF_OUTN)
let out_diff=v(OUTP)-v(OUTN)

let vin_r=real(vin_diff)
let vin_i=imag(vin_diff)
let lpf_r=real(lpf_diff)
let lpf_i=imag(lpf_diff)
let out_r=real(out_diff)
let out_i=imag(out_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.diff_ac_\{$env\}.txt vin_r vin_i lpf_r lpf_i out_r out_i

destroy all

* CMRR

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=1
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 100k

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let lpf_diff=v(LPF_OUTP)-v(LPF_OUTN)

let vin_r=real(vin_cm)
let vin_i=imag(vin_cm)
let out_r=real(lpf_diff)
let out_i=imag(lpf_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.cmrr_ac_\{$env\}.txt vin_r vin_i out_r out_i

destroy all

* PSRR+

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=1
alter @VAVDD[ACPHASE]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 100k

let vsup=v(AVDD)-v(AGND)
let lpf_diff=v(LPF_OUTP)-v(LPF_OUTN)

let vsup_r=real(vsup)
let vsup_i=imag(vsup)
let out_r=real(lpf_diff)
let out_i=imag(lpf_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.psrrp_ac_\{$env\}.txt vsup_r vsup_i out_r out_i

destroy all

* PSRR-

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=1
alter @VAVSS[ACPHASE]=0

ac dec 200 0.01 100k

let vsup=v(AVDD)-v(AGND)
let lpf_diff=v(LPF_OUTP)-v(LPF_OUTN)

let vsup_r=real(vsup)
let vsup_i=imag(vsup)
let out_r=real(lpf_diff)
let out_i=imag(lpf_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.psrrn_ac_\{$env\}.txt vsup_r vsup_i out_r out_i

destroy all

* NOISE

alter @VDIFF[ACMAG]=1
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

noise v(LPF_OUTP,LPF_OUTN) VDIFF dec 100 0.01 10k

setplot previous
setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.noise_\{$env\}.txt onoise_spectrum inoise_spectrum

destroy all


* LPF VTC

alter @VSEL[DC]=0
alter @VDIFF[DC]=0

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

* VTC
dc VDIFF -3.3 3.3 2m

let vin_diff=v(INP)-v(INN)
let lpf_outp=v(LPF_OUTP)-v(AGND)
let lpf_outn=v(LPF_OUTN)-v(AGND)
let lpf_out_cm=0.5*(v(LPF_OUTP)+v(LPF_OUTN))-v(AGND)
let lpf_out_diff=v(LPF_OUTP)-v(LPF_OUTN)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.vtc_\{$env\}.txt vin_diff lpf_outp lpf_outn lpf_out_cm lpf_out_diff

destroy all


* LPF THD

* 5 mVpp ECG x INA gain 240 = 1.2 Vpp = 0.6 V peak.
alterparam TRAN_AMP_SET=0.6
alterparam TRAN_FREQ_SET=60

reset
save all

alter @VSEL[DC]=0
alter @VDIFF[DC]=0

alter @VDIFF[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREF[ACMAG]=0
alter @VEXTDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

* Save exactly 10 cycles after 100 ms settling.
tran 20u 266.666667m 100m

let vin_diff=v(INP)-v(INN)
let lpf_out_diff=v(LPF_OUTP)-v(LPF_OUTN)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.thd_\{$env\}.txt vin_diff lpf_out_diff

destroy all

* Restore normal testbench transient settings.
alterparam TRAN_AMP_SET=100m
alterparam TRAN_FREQ_SET=10


end
end

* SEL

if $&PROC_ID = 0

alterparam VDD_SET=3.3
alterparam TEMP_SET=27

alterparam TRAN_AMP_SET=100m
alterparam TRAN_FREQ_SET=10

alterparam EXT_TRAN_AMP_SET=50m
alterparam EXT_TRAN_FREQ_SET=25

alterparam SEL_TRAN_HIGH_SET=3.3
alterparam SEL_SWITCH_TIME_SET=200m

reset

save all

tran 20u 400m

let int_in_diff=v(INP)-v(INN)
let ext_diff=v(LPF_EXTP)-v(LPF_EXTN)
let out_diff=v(OUTP)-v(OUTN)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/\{$proc\}.Result_txt/\{$proc\}.sel_tran_nom.txt v(LPF_SEL) int_in_diff ext_diff out_diff

destroy all

end

quit

.endc
* \{MEAS_END\}
"}
C {lab_wire.sym} 600 -860 0 0 {name=p28 sig_type=std_logic lab=INP}
C {lab_wire.sym} 600 -740 2 1 {name=p29 sig_type=std_logic lab=INN}
C {lab_wire.sym} 600 -640 0 0 {name=p30 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 600 -600 0 0 {name=p32 sig_type=std_logic lab=AGND}
C {capa.sym} 1480 -930 2 1 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1480 -860 0 0 {name=p1 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1480 -1000 0 1 {name=p2 sig_type=std_logic lab=AGND}
C {capa.sym} 1480 -670 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1480 -600 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1480 -740 2 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 1360 -860 0 1 {name=p3 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1360 -740 2 0 {name=p4 sig_type=std_logic lab=OUTN}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/AFE_BLOCKS/BIAS/BIAS.sym} 560 -1000 0 0 {name=xBIAS1}
C {lab_wire.sym} 640 -1000 2 1 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 680 -1000 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 760 -1120 0 1 {name=p37 sig_type=std_logic lab=BP}
C {lab_wire.sym} 780 -960 0 0 {name=p7 sig_type=std_logic lab=REF}
C {symbols/pfet_03v3.sym} 820 -1120 0 0 {name=MBFDC
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
C {lab_wire.sym} 840 -1200 0 0 {name=p14 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 840 -1040 2 1 {name=p15 sig_type=std_logic lab=BFDC}
C {symbols/pfet_03v3.sym} 980 -1120 0 0 {name=MBCMFB
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
C {lab_wire.sym} 1000 -1200 0 0 {name=p17 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 1000 -1040 2 1 {name=p18 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 920 -1120 0 1 {name=p19 sig_type=std_logic lab=BP}
C {lab_wire.sym} 860 -960 0 1 {name=p20 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 820 -960 0 1 {name=p21 sig_type=std_logic lab=BFDC}
C {vsource.sym} 80 -350 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -320 0 0 {name=l5 lab=0}
C {vsource.sym} 80 -210 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -180 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -260 0 0 {name=p24 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -400 0 0 {name=p55 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/AFE_BLOCKS/LPF/LPF.sym} 580 -640 0 0 {name=xLFP1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/DIGITAL_BLOCKS/MUXD/MUXD.sym} 1060 -640 0 0 {name=xMUXD2}
C {lab_wire.sym} 920 -560 0 0 {name=p47 sig_type=std_logic lab=LPF_OUTP}
C {lab_wire.sym} 920 -520 0 0 {name=p48 sig_type=std_logic lab=LPF_OUTN}
C {lab_wire.sym} 1120 -560 0 1 {name=p70 sig_type=std_logic lab=LPF_EXTP}
C {lab_wire.sym} 1120 -520 0 1 {name=p80 sig_type=std_logic lab=LPF_EXTN}
C {lab_wire.sym} 1260 -560 2 0 {name=p82 sig_type=std_logic lab=LPF_SEL}
C {vsource.sym} 1200 -350 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 1200 -210 0 0 {name=VDIFF value="dc 0 ac 1 sin(0 \{TRAN_AMP_SET\} \{TRAN_FREQ_SET\})" savecurrent=false}
C {lab_wire.sym} 1200 -260 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 1200 -400 0 0 {name=p6 sig_type=std_logic lab=VCM}
C {vsource.sym} 640 -350 0 0 {name=VREF value="dc \{VREF_SET\} ac 0" savecurrent=false}
C {vsource.sym} 640 -210 0 0 {name=VSEL value="dc 0 ac 0 pulse(0 \{SEL_TRAN_HIGH_SET\} \{SEL_SWITCH_TIME_SET\} 1u 1u 400m 800m)" savecurrent=false
}
C {lab_wire.sym} 640 -260 0 0 {name=p10 sig_type=std_logic lab=LPF_SEL}
C {lab_wire.sym} 640 -400 0 0 {name=p11 sig_type=std_logic lab=REF

}
C {vsource.sym} 1760 -350 0 0 {name=VEXTCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 1760 -210 0 0 {name=VEXTDIFF value="dc 0 ac 0 sin(0 \{EXT_TRAN_AMP_SET\} \{EXT_TRAN_FREQ_SET\})" savecurrent=false
}
C {lab_wire.sym} 1760 -260 0 0 {name=p22 sig_type=std_logic lab=EXTVDIFF}
C {lab_wire.sym} 1760 -400 0 0 {name=p23 sig_type=std_logic lab=EXTVCM}
C {vcvs.sym} 400 -870 0 0 {name=EINP value="0.5" savecurrent=false}
C {lab_wire.sym} 520 -860 0 1 {name=p74 sig_type=std_logic lab=INP}
C {lab_wire.sym} 320 -890 0 0 {name=p75 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 320 -850 0 0 {name=p76 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -800 0 0 {name=p77 sig_type=std_logic lab=VCM}
C {vcvs.sym} 400 -730 2 1 {name=EINN value="-0.5" savecurrent=false}
C {lab_wire.sym} 520 -740 2 0 {name=p8 sig_type=std_logic lab=INN}
C {lab_wire.sym} 1760 -300 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1760 -160 2 0 {name=p26 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -160 2 0 {name=p27 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -160 2 0 {name=p34 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -300 2 0 {name=p35 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -300 2 0 {name=p36 sig_type=std_logic lab=AGND}
C {vcvs.sym} 160 -870 0 0 {name=EEXTP value="0.5" savecurrent=false}
C {lab_wire.sym} 160 -940 0 0 {name=p38 sig_type=std_logic lab=LPF_EXTP}
C {lab_wire.sym} 80 -890 0 0 {name=p39 sig_type=std_logic lab=EXTVDIFF
}
C {lab_wire.sym} 80 -850 0 0 {name=p40 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 160 -800 0 0 {name=p41 sig_type=std_logic lab=EXTVCM}
C {vcvs.sym} 160 -730 2 1 {name=EEXTN value="-0.5" savecurrent=false}
C {lab_wire.sym} 160 -660 2 1 {name=p42 sig_type=std_logic lab=LPF_EXTN}
C {lab_wire.sym} 80 -710 2 1 {name=p43 sig_type=std_logic lab=EXTVDIFF
}
C {lab_wire.sym} 80 -750 2 1 {name=p44 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 320 -710 2 1 {name=p9 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 320 -750 2 1 {name=p12 sig_type=std_logic lab=AGND}
