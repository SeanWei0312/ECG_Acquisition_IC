v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 440 -1240 460 -1240 {lab=B}
N 440 -1280 460 -1280 {lab=INP}
N 620 -1240 700 -1240 {lab=OUT}
N 660 -1240 660 -1120 {lab=OUT}
N 440 -1120 660 -1120 {lab=OUT}
N 440 -1200 440 -1120 {lab=OUT}
N 440 -1200 460 -1200 {lab=OUT}
N 300 -1060 300 -1040 {lab=INP}
N 120 -920 120 -900 {lab=AGND}
N 300 -980 300 -960 {lab=AGND}
N 700 -1180 700 -1160 {lab=AGND}
N 540 -1160 540 -1140 {lab=AGND}
N 120 -1060 120 -1040 {lab=AVDD}
N 540 -1340 540 -1320 {lab=AVDD}
N 120 -1180 120 -1140 {lab=AVDD}
N 160 -1180 160 -1140 {lab=AGND}
N 320 -1230 320 -1180 {lab=B}
N 320 -1340 320 -1290 {lab=AVDD}
N 200 -1260 280 -1260 {lab=BP}
N 320 -1260 340 -1260 {lab=AVDD}
N 340 -1300 340 -1260 {lab=AVDD}
N 320 -1300 340 -1300 {lab=AVDD}
N 200 -1220 240 -1220 {lab=VREF}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {capa.sym} 700 -1210 0 0 {name=CL
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 440 -1240 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 440 -1280 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 700 -1240 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -710 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice sf
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=4
"}
C {devices/code_shown.sym} 680 -710 0 0 {name=NGSPICE
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


shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_*.txt


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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_op.txt vdd vin vout vin_diff v(B) idd_total ibias


* DC

dc VIN 0 $vddval 1m

let cl_vin=v(INP)-v(AGND)
let cl_vout=v(OUT)-v(AGND)

let cl_err=cl_vout-cl_vin
let cl_vin_diff=v(INP)-v(OUT)

let cl_idd=abs(vavdd#branch)
let cl_ibias=abs(@m.xmbias.m0[id])

setscale cl_vin

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_dc.txt cl_vout cl_err cl_vin_diff cl_idd cl_ibias


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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_tran.txt tr_vin tr_vout tr_err tr_vin_diff tr_idd tr_ibias


destroy all

end
end


quit

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 380 -1100 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -340 0 0 {name=SETUP
only_toplevel=true
value="
.param VDD_SET=3.3
.param TEMP_SET=27

.param VCM_SET=\{VDD_SET/2\}
.param CL_SET=10p

.csparam MC_RUNS=200

.temp \{TEMP_SET\}

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {vsource.sym} 120 -1010 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 120 -980 0 0 {name=l10 lab=0}
C {vsource.sym} 300 -1010 0 0 {name=VIN value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 300 -1060 0 0 {name=p6 sig_type=std_logic lab=INP}
C {vsource.sym} 120 -870 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 120 -840 0 0 {name=l11 lab=0}
C {lab_wire.sym} 120 -920 0 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 300 -960 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 540 -1140 2 0 {name=p1 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 700 -1160 2 0 {name=p3 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 120 -1060 0 0 {name=p8 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 540 -1340 0 0 {name=p10 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 40 -1140 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -1140 2 1 {name=p5 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1140 2 1 {name=p12 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -1260 0 0 {name=MBIAS
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
C {lab_wire.sym} 320 -1340 0 0 {name=p22 sig_type=std_logic lab=AVDD}
C {noconn.sym} 240 -1220 0 1 {name=l3}
C {lab_wire.sym} 320 -1180 2 1 {name=p23 sig_type=std_logic lab=B}
C {lab_wire.sym} 240 -1220 0 1 {name=p24 sig_type=std_logic lab=VREF}
C {lab_wire.sym} 240 -1260 0 1 {name=p27 sig_type=std_logic lab=BP}
