v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 460 -720 480 -720 {lab=B}
N 460 -760 480 -760 {lab=INP}
N 460 -680 480 -680 {lab=INN}
N 640 -720 720 -720 {lab=OUT}
N 640 -400 640 -380 {lab=VINCM}
N 640 -260 640 -240 {lab=VDIFF}
N 80 -260 80 -240 {lab=AGND}
N 640 -320 640 -300 {lab=AGND}
N 720 -660 720 -640 {lab=AGND}
N 640 -180 640 -160 {lab=AGND}
N 1200 -400 1200 -380 {lab=INP}
N 1200 -260 1200 -240 {lab=INN}
N 1200 -320 1200 -300 {lab=VINCM}
N 1200 -180 1200 -160 {lab=VINCM}
N 1140 -370 1160 -370 {lab=VDIFF}
N 1140 -330 1160 -330 {lab=AGND}
N 1140 -230 1160 -230 {lab=VDIFF}
N 1140 -190 1160 -190 {lab=AGND}
N 560 -640 560 -620 {lab=AGND}
N 120 -640 120 -600 {lab=AVDD}
N 160 -640 160 -600 {lab=AGND}
N 320 -690 320 -640 {lab=B}
N 320 -800 320 -750 {lab=AVDD}
N 200 -720 280 -720 {lab=BP}
N 320 -720 340 -720 {lab=AVDD}
N 340 -760 340 -720 {lab=AVDD}
N 320 -760 340 -760 {lab=AVDD}
N 80 -400 80 -380 {lab=AVDD}
N 560 -820 560 -800 {lab=AVDD}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 80 -350 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -320 0 0 {name=l5 lab=0}
C {capa.sym} 720 -690 0 0 {name=CL
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 640 -350 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 640 -210 0 0 {name=VDIFF value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 460 -720 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 640 -400 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 460 -760 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 640 -260 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 460 -680 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 720 -720 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/ANALOG_BLOCKS/SEOTA/SEOTA.sym} 400 -580 0 0 {name=xSEOTA1}
C {vsource.sym} 80 -210 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -180 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -260 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -620 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -160 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -300 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 720 -640 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 1200 -210 0 0 {name=EINN value=-0.5}
C {vcvs.sym} 1200 -350 0 0 {name=EINP value=0.5}
C {lab_wire.sym} 1200 -400 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 1200 -260 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 1200 -300 2 0 {name=p16 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 1200 -160 2 0 {name=p17 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 1140 -190 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1140 -330 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1140 -230 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 1140 -370 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/POWER_BLOCKS/BIAS/BIAS.sym} 40 -600 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -600 2 1 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -600 2 1 {name=p12 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -720 0 0 {name=MBIAS
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
C {lab_wire.sym} 320 -800 0 0 {name=p22 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -640 2 1 {name=p23 sig_type=std_logic lab=B}
C {lab_wire.sym} 80 -400 0 0 {name=p25 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 560 -820 0 0 {name=p26 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 240 -720 0 1 {name=p27 sig_type=std_logic lab=BP}
C {devices/code_shown.sym} 80 90 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
* \{MODELS_START\}
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice ff
.lib $::180MCU_MODELS/sm141064.ngspice res_ff
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_ff
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_ff

.csparam PROC_ID=1
* \{MODELS_END\}
"}
C {devices/code_shown.sym} 640 90 0 0 {name=SETUP
only_toplevel=true
value="
* \{SETUP_START\}
.param VDD_SET=3.3
.param TEMP_SET=27

.param VCM_SET=\{VDD_SET/2\}
.param CL_SET=10p

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


shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_*.txt


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


* OP

op

let vdd=v(AVDD)-v(AGND)
let vinp=v(INP)-v(AGND)
let vinn=v(INN)-v(AGND)
let vout=v(OUT)-v(AGND)

let idd_total=abs(vavdd#branch)
let ibias=abs(@m.xmbias.m0[id])

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_op.txt vdd vinp vinn vout v(B) idd_total ibias


* DIFFERENTIAL AC

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_diff=v(INP)-v(INN)
let vout=v(OUT)-v(AGND)

let vin_diff_real=real(vin_diff)
let vin_diff_imag=imag(vin_diff)

let vout_real=real(vout)
let vout_imag=imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_diff_ac.txt vin_diff_real vin_diff_imag vout_real vout_imag


* COMMON-MODE AC

alter @VCM[ACMAG]=1
alter @VCM[ACPHASE]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let vout=v(OUT)-v(AGND)

let vin_cm_real=real(vin_cm)
let vin_cm_imag=imag(vin_cm)

let vout_real=real(vout)
let vout_imag=imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_cm_ac.txt vin_cm_real vin_cm_imag vout_real vout_imag


* PSRRP

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=1
alter @VAVDD[ACPHASE]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vsup=v(AVDD)-v(AGND)
let vout=v(OUT)-v(AGND)

let vsup_real=real(vsup)
let vsup_imag=imag(vsup)

let vout_real=real(vout)
let vout_imag=imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrp_ac.txt vsup_real vsup_imag vout_real vout_imag


* PSRRN

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=1
alter @VAVSS[ACPHASE]=0

ac dec 200 0.01 1G

let vagnd=v(AGND)
let vout=v(OUT)-v(AGND)

let vagnd_real=real(vagnd)
let vagnd_imag=imag(vagnd)

let vout_real=real(vout)
let vout_imag=imag(vout)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrn_ac.txt vagnd_real vagnd_imag vout_real vout_imag


* VTC

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

dc VDIFF -20m 20m 1u

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff=v(INP)-v(INN)
let vout=v(OUT)-v(AGND)

let idd_total=abs(vavdd#branch)

setscale vin_diff

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_vtc.txt vin_cm v(INP) v(INN) vout idd_total


* NOISE

option sparse

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

noise v(OUT) VDIFF dec 100 0.01 1k

setplot previous
setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_noise.txt onoise_spectrum inoise_spectrum


destroy all

end
end


quit

.endc
* \{MEAS_END\}
"}
