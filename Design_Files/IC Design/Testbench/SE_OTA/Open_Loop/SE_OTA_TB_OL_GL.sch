v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 520 -1240 540 -1240 {lab=B}
N 520 -1280 540 -1280 {lab=INP}
N 520 -1200 540 -1200 {lab=INN}
N 700 -1240 780 -1240 {lab=OUT}
N 360 -1060 360 -1040 {lab=VINCM}
N 360 -920 360 -900 {lab=VDIFF}
N 200 -920 200 -900 {lab=AGND}
N 360 -980 360 -960 {lab=AGND}
N 780 -1180 780 -1160 {lab=AGND}
N 360 -840 360 -820 {lab=AGND}
N 620 -1060 620 -1040 {lab=INP}
N 620 -920 620 -900 {lab=INN}
N 620 -980 620 -960 {lab=VINCM}
N 620 -840 620 -820 {lab=VINCM}
N 560 -1030 580 -1030 {lab=VDIFF}
N 560 -990 580 -990 {lab=AGND}
N 560 -890 580 -890 {lab=VDIFF}
N 560 -850 580 -850 {lab=AGND}
N 620 -1160 620 -1140 {lab=AGND}
N 200 -1180 200 -1140 {lab=AVDD}
N 240 -1180 240 -1140 {lab=AGND}
N 400 -1230 400 -1180 {lab=B}
N 400 -1340 400 -1290 {lab=AVDD}
N 280 -1260 360 -1260 {lab=BP}
N 400 -1260 420 -1260 {lab=AVDD}
N 420 -1300 420 -1260 {lab=AVDD}
N 400 -1300 420 -1300 {lab=AVDD}
N 280 -1220 320 -1220 {lab=VREF}
N 200 -1060 200 -1040 {lab=AVDD}
N 620 -1340 620 -1320 {lab=AVDD}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 200 -1010 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 200 -980 0 0 {name=l5 lab=0}
C {capa.sym} 780 -1210 0 0 {name=CL
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 360 -1010 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 360 -870 0 0 {name=VDIFF value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 520 -1240 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 360 -1060 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 520 -1280 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 360 -920 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 520 -1200 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 780 -1240 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -710 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=1
.param sw_stat_mismatch=0

.param mc_skew=3
.param res_mc_skew=3
.param cap_mc_skew=3

.lib $::180MCU_MODELS/sm141064.ngspice statistical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=6
"}
C {devices/code_shown.sym} 640 -710 0 0 {name=NGSPICE
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

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt


echo run vos_V center_error_V ol_gain_1Hz ol_gain_dB ugf_Hz phase_ugf_deg pm_deg vout_center_V b_V ibias_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt

echo run vos_V vout_zero_V vout_center_V center_error_V net1_V net2_V net3_V net4_V b_V ibias_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt


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


* DEFAULT VALUES

set vos_val=0
set vout_zero_val=0
set vout_center_val=0
set center_error_val=0

set gain_val=0
set gain_db_val=0
set ugf_val=0
set phase_val=0
set pm_val=0

set net1_val=0
set net2_val=0
set net3_val=0
set net4_val=0

set b_val=0
set ibias_val=0
set idd_val=0
set power_val=0


* INITIAL SOURCES

alter @VCM[DC]=1.65
alter @VDIFF[DC]=0

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0


save all
save @m.xmbias.m0[id]


* ZERO-DIFFERENTIAL OP

op

let vout_zero=v(OUT)-v(AGND)

set vout_zero_val=$&vout_zero


destroy all


* FIND OFFSET

alter @VDIFF[DC]=0

dc VDIFF -50m 50m 10u

meas dc vos_center when v(OUT)=1.65 cross=1

set vos_val=$&vos_center


destroy all


* CENTER OTA

alter @VDIFF[DC]=$vos_val

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0


save all
save @m.xmbias.m0[id]


op


let vout_center=v(OUT)-v(AGND)
let center_error=vout_center-1.65

let b_op=v(B)-v(AGND)

let net1_op=v(xseota1.net1)-v(AGND)
let net2_op=v(xseota1.net2)-v(AGND)
let net3_op=v(xseota1.net3)-v(AGND)
let net4_op=v(xseota1.net4)-v(AGND)

let ibias=abs(@m.xmbias.m0[id])
let idd_total=abs(vavdd#branch)
let power_total=(v(AVDD)-v(AGND))*idd_total


set vout_center_val=$&vout_center
set center_error_val=$&center_error

set b_val=$&b_op

set net1_val=$&net1_op
set net2_val=$&net2_op
set net3_val=$&net3_op
set net4_val=$&net4_op

set ibias_val=$&ibias
set idd_val=$&idd_total
set power_val=$&power_total


echo $runnum $vos_val $vout_zero_val $vout_center_val $center_error_val $net1_val $net2_val $net3_val $net4_val $b_val $ibias_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt


destroy all


* OPEN-LOOP AC AT CENTERED OP

alter @VDIFF[DC]=$vos_val

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0


ac dec 200 0.01 1G


let vin_diff=v(INP)-v(INN)
let vout_ac=v(OUT)-v(AGND)

let ol_tf=vout_ac/vin_diff

let ol_gain=mag(ol_tf)
let ol_gain_db=db(ol_tf)
let ol_phase=(180/3.141592653589793)*cph(ol_tf)


meas ac ol_gain_1 find ol_gain at=1
meas ac ol_gain_db_1 find ol_gain_db at=1

set gain_val=$&ol_gain_1
set gain_db_val=$&ol_gain_db_1


meas ac ugf_meas when ol_gain=1 cross=1

set ugf_val=$&ugf_meas


meas ac phase_ugf find ol_phase at=$ugf_val

set phase_val=$&phase_ugf


let pm_calc=180+phase_ugf

set pm_val=$&pm_calc


echo $runnum $vos_val $center_error_val $gain_val $gain_db_val $ugf_val $phase_val $pm_val $vout_center_val $b_val $ibias_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt


destroy all

let run=run+1


end


quit

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 460 -1100 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -350 0 0 {name=SETUP
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
C {vsource.sym} 200 -870 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 200 -840 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -920 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 620 -1140 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -820 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -960 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 780 -1160 2 1 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -870 0 0 {name=EINN value=-0.5}
C {vcvs.sym} 620 -1010 0 0 {name=EINP value=0.5}
C {lab_wire.sym} 620 -1060 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -920 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -960 2 0 {name=p16 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 620 -820 2 0 {name=p17 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 560 -850 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -990 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -890 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -1030 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 120 -1140 0 0 {name=xBIAS1}
C {lab_wire.sym} 200 -1140 2 1 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 240 -1140 2 1 {name=p12 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 380 -1260 0 0 {name=MBIAS
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
C {lab_wire.sym} 400 -1340 0 0 {name=p22 sig_type=std_logic lab=AVDD}
C {noconn.sym} 320 -1220 0 1 {name=l3}
C {lab_wire.sym} 400 -1180 2 1 {name=p23 sig_type=std_logic lab=B}
C {lab_wire.sym} 320 -1220 0 1 {name=p24 sig_type=std_logic lab=VREF}
C {lab_wire.sym} 200 -1060 0 0 {name=p25 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 620 -1340 0 0 {name=p26 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -1260 0 1 {name=p27 sig_type=std_logic lab=BP}
