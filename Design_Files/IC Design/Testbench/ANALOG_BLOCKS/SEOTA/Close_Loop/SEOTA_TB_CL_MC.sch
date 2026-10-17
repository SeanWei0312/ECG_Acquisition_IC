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
.param sw_stat_mismatch=1

.param mc_skew=3
.param res_mc_skew=3
.param cap_mc_skew=3

.lib $::180MCU_MODELS/sm141064.ngspice statistical
.lib $::180MCU_MODELS/sm141064.ngspice res_statistical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_statistical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_statistical

.csparam PROC_ID=5
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


let mode_index=0
dowhile mode_index < 3
if mode_index = 0
set proc=MM
alterparam sw_stat_global=0
alterparam sw_stat_mismatch=1
end
if mode_index = 1
set proc=GL
alterparam sw_stat_global=1
alterparam sw_stat_mismatch=0
end
if mode_index = 2
set proc=FULL
alterparam sw_stat_global=1
alterparam sw_stat_mismatch=1
end
reset

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


echo run vos_V vout_V out_error_V cl_gain_10 b_V ibias_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt

echo run vin_V vout_V vos_V net1_V net2_V net3_V net4_V b_V ibias_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


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


echo $runnum $vin_val $vout_val $vos_val $net1_val $net2_val $net3_val $net4_val $b_val $ibias_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


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

echo $runnum $vos_val $vout_val $out_error_val $cl_gain_val $b_val $ibias_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt


destroy all

let run=run+1


end


let mode_index=mode_index+1
end

quit

.endc
* \{MEAS_END\}
"}
