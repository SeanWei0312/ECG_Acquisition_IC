v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 460 -720 480 -720 {lab=B}
N 460 -760 480 -760 {lab=INP}
N 640 -720 720 -720 {lab=OUT}
N 680 -720 680 -600 {lab=OUT}
N 460 -600 680 -600 {lab=OUT}
N 460 -680 460 -600 {lab=OUT}
N 460 -680 480 -680 {lab=OUT}
N 640 -400 640 -380 {lab=INP}
N 80 -260 80 -240 {lab=AGND}
N 640 -320 640 -300 {lab=AGND}
N 720 -660 720 -640 {lab=AGND}
N 560 -640 560 -620 {lab=AGND}
N 80 -400 80 -380 {lab=AVDD}
N 560 -820 560 -800 {lab=AVDD}
N 130 -640 130 -600 {lab=AVDD}
N 170 -640 170 -600 {lab=AGND}
N 330 -690 330 -640 {lab=B}
N 330 -800 330 -750 {lab=AVDD}
N 210 -720 290 -720 {lab=BP}
N 330 -720 350 -720 {lab=AVDD}
N 350 -760 350 -720 {lab=AVDD}
N 330 -760 350 -760 {lab=AVDD}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {capa.sym} 720 -690 0 0 {name=CL
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 460 -720 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 460 -760 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 720 -720 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/ANALOG_BLOCKS/SEOTA/SEOTA.sym} 400 -580 0 0 {name=xSEOTA1}
C {vsource.sym} 80 -350 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -320 0 0 {name=l10 lab=0}
C {vsource.sym} 640 -350 0 0 {name=VIN value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 640 -400 0 0 {name=p6 sig_type=std_logic lab=INP}
C {vsource.sym} 80 -210 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -180 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -260 0 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -300 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -620 2 0 {name=p1 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 720 -640 2 0 {name=p3 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -400 0 0 {name=p8 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 560 -820 0 0 {name=p10 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/POWER_BLOCKS/BIAS/BIAS.sym} 50 -600 0 0 {name=xBIAS1}
C {lab_wire.sym} 130 -600 2 1 {name=p5 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 170 -600 2 1 {name=p12 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 310 -720 0 0 {name=MBIAS
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
C {lab_wire.sym} 330 -800 0 0 {name=p22 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 330 -640 2 1 {name=p23 sig_type=std_logic lab=B}
C {lab_wire.sym} 250 -720 0 1 {name=p27 sig_type=std_logic lab=BP}
C {devices/code_shown.sym} 80 90 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
* \{MODELS_START\}
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=0
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
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_*.txt


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
let vin=v(INP)-v(AGND)
let vout=v(OUT)-v(AGND)

let vin_diff=v(INP)-v(OUT)

let idd_total=abs(vavdd#branch)
let ibias=abs(@m.xmbias.m0[id])

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_op.txt vdd vin vout vin_diff v(B) idd_total ibias


* DC

dc VIN 0 $vddval 1m

let cl_vin=v(INP)-v(AGND)
let cl_vout=v(OUT)-v(AGND)

let cl_err=cl_vout-cl_vin
let cl_vin_diff=v(INP)-v(OUT)

let cl_idd=abs(vavdd#branch)
let cl_ibias=abs(@m.xmbias.m0[id])

setscale cl_vin

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_dc.txt cl_vout cl_err cl_vin_diff cl_idd cl_ibias


* TRAN

reset

option klu

save all
save @m.xmbias.m0[id]


if $vddval = 3.0

alter @VIN[PULSE]=[ 1.0 2.0 1u 10n 10n 10u 20u 0 ]

else

if $vddval = 3.3

alter @VIN[PULSE]=[ 1.15 2.15 1u 10n 10n 10u 20u 0 ]

else

alter @VIN[PULSE]=[ 1.3 2.3 1u 10n 10n 10u 20u 0 ]

end
end


tran 0.5n 30u

let tr_vin=v(INP)-v(AGND)
let tr_vout=v(OUT)-v(AGND)

let tr_err=tr_vout-tr_vin
let tr_vin_diff=v(INP)-v(OUT)

let tr_idd=abs(vavdd#branch)
let tr_ibias=abs(@m.xmbias.m0[id])

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_tran.txt tr_vin tr_vout tr_err tr_vin_diff tr_idd tr_ibias


destroy all

end
end


quit

.endc
* \{MEAS_END\}
"}
