v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -340 {}
N 620 -1260 640 -1260 {lab=REF}
N 620 -1300 640 -1300 {lab=INP}
N 620 -1220 640 -1220 {lab=INN}
N 240 -1040 240 -1020 {lab=VINCM}
N 240 -900 240 -880 {lab=VDIFF}
N 80 -900 80 -880 {lab=AGND}
N 690 -1180 690 -1160 {lab=AGND}
N 240 -960 240 -940 {lab=AGND}
N 240 -820 240 -800 {lab=AGND}
N 400 -1040 400 -1020 {lab=REF}
N 400 -960 400 -940 {lab=VREFBIAS}
N 640 -1040 640 -1020 {lab=INP}
N 640 -960 640 -940 {lab=VINCM}
N 640 -900 640 -880 {lab=INN}
N 640 -820 640 -800 {lab=VINCM}
N 580 -1010 600 -1010 {lab=VDIFF}
N 580 -970 600 -970 {lab=AGND}
N 580 -870 600 -870 {lab=VDIFF}
N 580 -830 600 -830 {lab=AGND}
N 720 -1180 720 -1160 {lab=BCMFB}
N 720 -1360 720 -1340 {lab=BFDC}
N 880 -1240 880 -1220 {lab=AGND}
N 800 -1300 820 -1300 {lab=OUTN}
N 800 -1220 820 -1220 {lab=OUTP}
N 880 -1320 880 -1300 {lab=OUTP}
N 960 -1240 960 -1220 {lab=AGND}
N 960 -1320 960 -1300 {lab=OUTN}
N 800 -1260 820 -1260 {lab=VOCM}
N 120 -1200 120 -1160 {lab=AVDD}
N 160 -1200 160 -1160 {lab=AGND}
N 320 -1250 320 -1200 {lab=BFDC}
N 320 -1360 320 -1310 {lab=AVDD}
N 200 -1280 280 -1280 {lab=BP}
N 320 -1280 340 -1280 {lab=AVDD}
N 340 -1320 340 -1280 {lab=AVDD}
N 320 -1320 340 -1320 {lab=AVDD}
N 200 -1240 240 -1240 {lab=VREFBIAS}
N 80 -1040 80 -1020 {lab=AVDD}
N 690 -1360 690 -1340 {lab=AVDD}
N 480 -1250 480 -1200 {lab=BCMFB}
N 480 -1360 480 -1310 {lab=AVDD}
N 480 -1280 500 -1280 {lab=AVDD}
N 500 -1320 500 -1280 {lab=AVDD}
N 480 -1320 500 -1320 {lab=AVDD}
N 400 -1280 440 -1280 {lab=BP}
N 800 -1040 800 -1020 {lab=VOUTDIFF}
N 800 -960 800 -940 {lab=AGND}
N 740 -1010 760 -1010 {lab=OUTP}
N 740 -970 760 -970 {lab=OUTN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 80 -990 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -960 0 0 {name=l5 lab=0}
C {vsource.sym} 240 -990 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 240 -850 0 0 {name=VDIFF value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 620 -1260 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 240 -1040 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 620 -1300 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 240 -900 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 620 -1220 0 0 {name=p6 sig_type=std_logic lab=INN}
C {devices/code_shown.sym} 80 -710 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=1
.param sw_stat_mismatch=1

.param mc_skew=3
.param res_mc_skew=3
.param cap_mc_skew=3

.lib $::180MCU_MODELS/sm141064.ngspice statistical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=7
"}
C {devices/code_shown.sym} 660 -710 0 0 {name=NGSPICE
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


shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt


echo run vos_V dc_gain_dB ugf_Hz phase_ugf_deg pm_deg > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt

echo run vos_V outp_zero_V outn_zero_V outdiff_zero_V outp_center_V outn_center_V outcm_center_V outdiff_center_V ref_V vocm_V > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt


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


* SOURCES

alter @VAVDD[DC]=3.3
alter @VAVSS[DC]=0
alter @VCM[DC]=1.65
alter @VDIFF[DC]=0
alter @VREFSTEP[DC]=0

alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0


* OFFSET + ZERO INPUT VALUES

save INP INN OUTP OUTN REF VOCM

dc VDIFF -10m 10m 10u

let outdiff_sweep=v(OUTP)-v(OUTN)

meas dc outp_zero_meas find v(OUTP) at=0
meas dc outn_zero_meas find v(OUTN) at=0
meas dc outdiff_zero_meas find outdiff_sweep at=0

meas dc vos_center when outdiff_sweep=0 cross=1

set outp_zero_val=$&outp_zero_meas
set outn_zero_val=$&outn_zero_meas
set outdiff_zero_val=$&outdiff_zero_meas
set vos_val=$&vos_center

destroy all


* CENTER OP

alter @VDIFF[DC]=$vos_val

save OUTP OUTN REF VOCM

op

let outp_center=v(OUTP)-v(AGND)
let outn_center=v(OUTN)-v(AGND)

let outcm_center=0.5*(outp_center+outn_center)
let outdiff_center=outp_center-outn_center

let ref_center=v(REF)-v(AGND)
let vocm_center=v(VOCM)-v(AGND)

set outp_center_val=$&outp_center
set outn_center_val=$&outn_center
set outcm_center_val=$&outcm_center
set outdiff_center_val=$&outdiff_center
set ref_val=$&ref_center
set vocm_val=$&vocm_center


echo $runnum $vos_val $outp_zero_val $outn_zero_val $outdiff_zero_val $outp_center_val $outn_center_val $outcm_center_val $outdiff_center_val $ref_val $vocm_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt

destroy all


* DIFFERENTIAL AC

alter @VDIFF[DC]=$vos_val

alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0
alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

save INP INN OUTP OUTN

ac dec 100 1 200Meg

let vin_diff=v(INP)-v(INN)
let vout_diff=v(OUTP)-v(OUTN)

let ol_tf=vout_diff/vin_diff

let ol_gain=mag(ol_tf)
let ol_gain_db=db(ol_tf)
let ol_phase=(180/3.141592653589793)*cph(ol_tf)

meas ac dc_gain_db find ol_gain_db at=1

meas ac ugf_meas when ol_gain=1 fall=1

meas ac phase_ugf find ol_phase at=$&ugf_meas

let pm_calc=180+phase_ugf

set gain_db_val=$&dc_gain_db
set ugf_val=$&ugf_meas
set phase_val=$&phase_ugf
set pm_val=$&pm_calc


echo $runnum $vos_val $gain_db_val $ugf_val $phase_val $pm_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt

destroy all


let run=run+1

end


quit

.endc
"}
C {devices/code_shown.sym} 80 -350 0 0 {name=SETUP
only_toplevel=true
value="
.param VDD_SET=3.3
.param TEMP_SET=27

.param VCM_SET=\{VDD_SET/2\}
.param CL_SET=40p

.csparam MC_RUNS=200

.temp \{TEMP_SET\}

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {vsource.sym} 80 -850 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -820 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -900 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 690 -1160 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 240 -800 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 240 -940 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {vsource.sym} 400 -990 0 0 {name=VREFSTEP value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 400 -1040 0 0 {name=p22 sig_type=std_logic lab=REF}
C {lab_wire.sym} 400 -940 2 0 {name=p25 sig_type=std_logic lab=VREFBIAS}
C {vcvs.sym} 640 -990 0 0 {name=EINP value=0.5}
C {vcvs.sym} 640 -850 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 640 -1040 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 580 -1010 0 0 {name=p15 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 580 -970 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -870 0 0 {name=p17 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 580 -830 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -940 2 0 {name=p19 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 640 -800 2 0 {name=p20 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 640 -900 0 0 {name=p21 sig_type=std_logic lab=INN}
C {lab_wire.sym} 720 -1160 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 720 -1360 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {capa.sym} 880 -1270 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 880 -1320 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 880 -1220 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 960 -1270 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 960 -1220 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 820 -1220 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 960 -1320 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 820 -1300 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 820 -1260 0 1 {name=p7 sig_type=std_logic lab=VOCM}
C {noconn.sym} 820 -1260 0 1 {name=l3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 560 -1120 0 0 {name=xFDOTA1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 40 -1160 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -1160 2 1 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1160 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -1280 0 0 {name=MBFDC
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
C {lab_wire.sym} 320 -1360 0 0 {name=p34 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -1200 2 1 {name=p35 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 240 -1240 0 1 {name=p36 sig_type=std_logic lab=VREFBIAS}
C {lab_wire.sym} 240 -1280 0 1 {name=p37 sig_type=std_logic lab=BP}
C {lab_wire.sym} 80 -1040 0 0 {name=p38 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 690 -1360 0 0 {name=p39 sig_type=std_logic lab=AVDD}
C {symbols/pfet_03v3.sym} 460 -1280 0 0 {name=MBCMFB
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
C {lab_wire.sym} 480 -1360 0 0 {name=p40 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 480 -1200 2 1 {name=p41 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 400 -1280 0 1 {name=p42 sig_type=std_logic lab=BP}
C {vcvs.sym} 800 -990 0 0 {name=EOUTDIFF value=1}
C {lab_wire.sym} 800 -1040 0 0 {name=p1 sig_type=std_logic lab=VOUTDIFF}
C {lab_wire.sym} 740 -1010 0 0 {name=p12 sig_type=std_logic lab=OUTP
}
C {lab_wire.sym} 740 -970 0 0 {name=p26 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 800 -940 2 0 {name=p27 sig_type=std_logic lab=AGND}
