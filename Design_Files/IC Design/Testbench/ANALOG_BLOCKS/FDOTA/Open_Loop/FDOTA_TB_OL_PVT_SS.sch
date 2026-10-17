v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -670 {}
N 620 -760 640 -760 {lab=REF}
N 620 -800 640 -800 {lab=INP}
N 620 -720 640 -720 {lab=INN}
N 640 -400 640 -380 {lab=VINCM}
N 640 -260 640 -240 {lab=VDIFF}
N 80 -260 80 -240 {lab=AGND}
N 690 -680 690 -660 {lab=AGND}
N 640 -320 640 -300 {lab=AGND}
N 640 -180 640 -160 {lab=AGND}
N 1200 -400 1200 -380 {lab=REF}
N 1200 -320 1200 -300 {lab=AGND}
N 1800 -400 1800 -380 {lab=INP}
N 1800 -320 1800 -300 {lab=VINCM}
N 1800 -260 1800 -240 {lab=INN}
N 1800 -180 1800 -160 {lab=VINCM}
N 1740 -370 1760 -370 {lab=VDIFF}
N 1740 -330 1760 -330 {lab=AGND}
N 1740 -230 1760 -230 {lab=VDIFF}
N 1740 -190 1760 -190 {lab=AGND}
N 720 -680 720 -660 {lab=BCMFB}
N 720 -860 720 -840 {lab=BFDC}
N 880 -740 880 -720 {lab=AGND}
N 800 -800 820 -800 {lab=OUTN}
N 800 -720 820 -720 {lab=OUTP}
N 880 -820 880 -800 {lab=OUTP}
N 960 -740 960 -720 {lab=AGND}
N 960 -820 960 -800 {lab=OUTN}
N 800 -760 820 -760 {lab=VOCM}
N 120 -700 120 -660 {lab=AVDD}
N 160 -700 160 -660 {lab=AGND}
N 320 -750 320 -700 {lab=BFDC}
N 320 -860 320 -810 {lab=AVDD}
N 200 -780 280 -780 {lab=BP}
N 320 -780 340 -780 {lab=AVDD}
N 340 -820 340 -780 {lab=AVDD}
N 320 -820 340 -820 {lab=AVDD}
N 80 -400 80 -380 {lab=AVDD}
N 690 -860 690 -840 {lab=AVDD}
N 480 -750 480 -700 {lab=BCMFB}
N 480 -860 480 -810 {lab=AVDD}
N 480 -780 500 -780 {lab=AVDD}
N 500 -820 500 -780 {lab=AVDD}
N 480 -820 500 -820 {lab=AVDD}
N 400 -780 440 -780 {lab=BP}
N 2360 -400 2360 -380 {lab=VOUTDIFF}
N 2360 -320 2360 -300 {lab=AGND}
N 2300 -370 2320 -370 {lab=OUTP}
N 2300 -330 2320 -330 {lab=OUTN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 80 -350 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -320 0 0 {name=l5 lab=0}
C {vsource.sym} 640 -350 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 640 -210 0 0 {name=VDIFF value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 620 -760 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 640 -400 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 620 -800 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 640 -260 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 620 -720 0 0 {name=p6 sig_type=std_logic lab=INN}
C {vsource.sym} 80 -210 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -180 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -260 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 690 -660 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -160 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -300 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {vsource.sym} 1200 -350 0 0 {name=VREFSTEP value="dc \{VREF_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 1200 -400 0 0 {name=p22 sig_type=std_logic lab=REF}
C {lab_wire.sym} 1200 -300 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {vcvs.sym} 1800 -350 0 0 {name=EINP value=0.5}
C {vcvs.sym} 1800 -210 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 1800 -400 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 1740 -370 0 0 {name=p15 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 1740 -330 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1740 -230 0 0 {name=p17 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 1740 -190 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1800 -300 2 0 {name=p19 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 1800 -160 2 0 {name=p20 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 1800 -260 0 0 {name=p21 sig_type=std_logic lab=INN}
C {lab_wire.sym} 720 -660 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 720 -860 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {capa.sym} 880 -770 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 880 -820 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 880 -720 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 960 -770 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 960 -720 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 820 -720 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 960 -820 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 820 -800 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 820 -760 0 1 {name=p7 sig_type=std_logic lab=VOCM}
C {noconn.sym} 820 -760 0 1 {name=l3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.sym} 560 -620 0 0 {name=xFDOTA1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/POWER_BLOCKS/BIAS/BIAS.sym} 40 -660 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -660 2 1 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -660 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -780 0 0 {name=MBFDC
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
C {lab_wire.sym} 320 -860 0 0 {name=p34 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -700 2 1 {name=p35 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 240 -780 0 1 {name=p37 sig_type=std_logic lab=BP}
C {lab_wire.sym} 80 -400 0 0 {name=p38 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 690 -860 0 0 {name=p39 sig_type=std_logic lab=AVDD}
C {symbols/pfet_03v3.sym} 460 -780 0 0 {name=MBCMFB
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
C {lab_wire.sym} 480 -860 0 0 {name=p40 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 480 -700 2 1 {name=p41 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 400 -780 0 1 {name=p42 sig_type=std_logic lab=BP}
C {vcvs.sym} 2360 -350 0 0 {name=EOUTDIFF value=1}
C {lab_wire.sym} 2360 -400 0 0 {name=p1 sig_type=std_logic lab=VOUTDIFF}
C {lab_wire.sym} 2300 -370 0 0 {name=p12 sig_type=std_logic lab=OUTP
}
C {lab_wire.sym} 2300 -330 0 0 {name=p26 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 2360 -300 2 0 {name=p27 sig_type=std_logic lab=AGND}
C {devices/code_shown.sym} 80 90 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
* \{MODELS_START\}
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice ss
.lib $::180MCU_MODELS/sm141064.ngspice res_ss
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_ss
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_ss

.csparam PROC_ID=2
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

.param CL_SET=40p

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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_*.txt

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

let vdd=v(AVDD)-v(AGND)
let vinp=v(INP)-v(AGND)
let vinn=v(INN)-v(AGND)
let voutp=v(OUTP)-v(AGND)
let voutn=v(OUTN)-v(AGND)
let voutcm=0.5*(voutp+voutn)
let voutdiff=voutp-voutn
let vref=v(REF)-v(AGND)
let vocm=v(VOCM)-v(AGND)
let bfdc=v(BFDC)-v(AGND)
let bcmfb=v(BCMFB)-v(AGND)
let idd_total=abs(vavdd#branch)
let ibias_fdc=abs(@m.xmbfdc.m0[id])
let ibias_cmfb=abs(@m.xmbcmfb.m0[id])

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_op.txt vdd vinp vinn voutp voutn voutcm voutdiff vref vocm bfdc bcmfb idd_total ibias_fdc ibias_cmfb

* DIFF AC

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_diff=v(INP)-v(INN)
let vout_diff=v(OUTP)-v(OUTN)

let vin_diff_real=real(vin_diff)
let vin_diff_imag=imag(vin_diff)
let vout_diff_real=real(vout_diff)
let vout_diff_imag=imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_diff_ac.txt vin_diff_real vin_diff_imag vout_diff_real vout_diff_imag

* CM AC

alter @VCM[ACMAG]=1
alter @VCM[ACPHASE]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let vout_diff=v(OUTP)-v(OUTN)

let vin_cm_real=real(vin_cm)
let vin_cm_imag=imag(vin_cm)
let vout_diff_real=real(vout_diff)
let vout_diff_imag=imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_cm_ac.txt vin_cm_real vin_cm_imag vout_diff_real vout_diff_imag

* PSRR+

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=1
alter @VAVDD[ACPHASE]=0
alter @VAVSS[ACMAG]=0

ac dec 200 0.01 1G

let vsup=v(AVDD)-v(AGND)
let vout_diff=v(OUTP)-v(OUTN)

let vsup_real=real(vsup)
let vsup_imag=imag(vsup)
let vout_diff_real=real(vout_diff)
let vout_diff_imag=imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrp_ac.txt vsup_real vsup_imag vout_diff_real vout_diff_imag

* PSRR-

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=1
alter @VAVSS[ACPHASE]=0

ac dec 200 0.01 1G

let vagnd=v(AGND)
let vout_diff=v(OUTP)-v(OUTN)

let vagnd_real=real(vagnd)
let vagnd_imag=imag(vagnd)
let vout_diff_real=real(vout_diff)
let vout_diff_imag=imag(vout_diff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_psrrn_ac.txt vagnd_real vagnd_imag vout_diff_real vout_diff_imag

* VTC

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

dc VDIFF -20m 20m 1u

let vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff=v(INP)-v(INN)
let voutp=v(OUTP)-v(AGND)
let voutn=v(OUTN)-v(AGND)
let voutcm=0.5*(voutp+voutn)
let voutdiff=voutp-voutn
let vocm=v(VOCM)-v(AGND)
let idd_total=abs(vavdd#branch)

setscale vin_diff

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_vtc.txt vin_cm v(INP) v(INN) voutp voutn voutcm voutdiff vocm idd_total

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_\{$case\}_noise.txt onoise_spectrum inoise_spectrum

destroy all

end
end

quit

.endc
* \{MEAS_END\}
"}
