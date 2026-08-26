v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 440 -1280 460 -1280 {lab=B}
N 440 -1320 460 -1320 {lab=INP}
N 620 -1280 700 -1280 {lab=OUT}
N 660 -1280 660 -1160 {lab=OUT}
N 440 -1160 660 -1160 {lab=OUT}
N 440 -1240 440 -1160 {lab=OUT}
N 440 -1240 460 -1240 {lab=OUT}
N 300 -1100 300 -1080 {lab=INP}
N 120 -960 120 -940 {lab=AGND}
N 300 -1020 300 -1000 {lab=AGND}
N 700 -1220 700 -1200 {lab=AGND}
N 540 -1200 540 -1180 {lab=AGND}
N 120 -1100 120 -1080 {lab=AVDD}
N 540 -1380 540 -1360 {lab=AVDD}
N 120 -1220 120 -1180 {lab=AVDD}
N 160 -1220 160 -1180 {lab=AGND}
N 320 -1270 320 -1220 {lab=B}
N 320 -1380 320 -1330 {lab=AVDD}
N 200 -1300 280 -1300 {lab=BP}
N 320 -1300 340 -1300 {lab=AVDD}
N 340 -1340 340 -1300 {lab=AVDD}
N 320 -1340 340 -1340 {lab=AVDD}
N 200 -1260 240 -1260 {lab=VREF}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {capa.sym} 700 -1250 0 0 {name=CL
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 440 -1280 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 440 -1320 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 700 -1280 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -750 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=1

.param mc_skew=3
.param res_mc_skew=3
.param cap_mc_skew=3

.lib $::180MCU_MODELS/sm141064.ngspice statistical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=5
"}
C {devices/code_shown.sym} 680 -750 0 0 {name=NGSPICE
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


if $&PROC_ID = 5
set proc=MM
else
if $&PROC_ID = 6
set proc=GL
else
set proc=FULL
end
end


shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


echo run vos_V vout_V out_error_V cl_gain_10 b_V ibias_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt

echo run vin_V vout_V vos_V net1_V net2_V net3_V net4_V b_V ibias_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


let run=1
let mc_runs=$&MC_RUNS


dowhile run <= mc_runs


set runnum=$&run

setseed $runnum
mc_source

option klu
option numdgt=15
option method=gear
option maxord=2
option plotwinsize=0

save all
save @m.xmbias.m0[id]


* OP

op

let vin_op=v(INP)-v(AGND)
let vout_op=v(OUT)-v(AGND)

let vos=vin_op-vout_op
let out_error=vout_op-vin_op

let b_op=v(B)-v(AGND)

let net1_op=v(xseota1.net1)-v(AGND)
let net2_op=v(xseota1.net2)-v(AGND)
let net3_op=v(xseota1.net3)-v(AGND)
let net4_op=v(xseota1.net4)-v(AGND)

let ibias=abs(@m.xmbias.m0[id])
let idd_total=abs(vavdd#branch)
let power_total=(v(AVDD)-v(AGND))*idd_total


set vin_val=$&vin_op
set vout_val=$&vout_op

set vos_val=$&vos
set out_error_val=$&out_error

set b_val=$&b_op

set net1_val=$&net1_op
set net2_val=$&net2_op
set net3_val=$&net3_op
set net4_val=$&net4_op

set ibias_val=$&ibias
set idd_val=$&idd_total
set power_val=$&power_total


echo $runnum $vin_val $vout_val $vos_val $net1_val $net2_val $net3_val $net4_val $b_val $ibias_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


destroy all


* CLOSED-LOOP AC

alter @VIN[ACMAG]=1
alter @VIN[ACPHASE]=0

ac dec 100 0.1 10Meg

let vin_ac=v(INP)-v(AGND)
let vout_ac=v(OUT)-v(AGND)

let cl_tf=vout_ac/vin_ac
let cl_gain=mag(cl_tf)

meas ac cl_gain_10 find cl_gain at=10

set cl_gain_val=$&cl_gain_10


* SUMMARY

echo $runnum $vos_val $vout_val $out_error_val $cl_gain_val $b_val $ibias_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt


destroy all

let run=run+1


end


quit

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 380 -1140 0 0 {name=xSEOTA1}
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
C {vsource.sym} 120 -1050 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 120 -1020 0 0 {name=l10 lab=0}
C {vsource.sym} 300 -1050 0 0 {name=VIN value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 300 -1100 0 0 {name=p6 sig_type=std_logic lab=INP}
C {vsource.sym} 120 -910 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 120 -880 0 0 {name=l11 lab=0}
C {lab_wire.sym} 120 -960 0 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 300 -1000 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 540 -1180 2 0 {name=p1 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 700 -1200 2 0 {name=p3 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 120 -1100 0 0 {name=p8 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 540 -1380 0 0 {name=p10 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 40 -1180 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -1180 2 1 {name=p5 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1180 2 1 {name=p12 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -1300 0 0 {name=MBIAS
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
C {lab_wire.sym} 320 -1380 0 0 {name=p22 sig_type=std_logic lab=AVDD}
C {noconn.sym} 240 -1260 0 1 {name=l3}
C {lab_wire.sym} 320 -1220 2 1 {name=p23 sig_type=std_logic lab=B}
C {lab_wire.sym} 240 -1260 0 1 {name=p24 sig_type=std_logic lab=VREF}
C {lab_wire.sym} 240 -1300 0 1 {name=p27 sig_type=std_logic lab=BP}
