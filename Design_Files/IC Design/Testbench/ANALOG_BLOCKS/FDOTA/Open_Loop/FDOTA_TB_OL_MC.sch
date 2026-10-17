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
option rshunt=1e12


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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt


echo run vos_V dc_gain_dB ugf_Hz phase_ugf_deg pm_deg > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt

echo run vos_V outp_zero_V outn_zero_V outdiff_zero_V outp_center_V outn_center_V outcm_center_V outdiff_center_V ref_V vocm_V > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt


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
option rshunt=1e12


* SOURCES

alter @VAVDD[DC]=3.3
alter @VAVSS[DC]=0

alter @VCM[DC]=1.65
alter @VDIFF[DC]=0
alter @VREFSTEP[DC]=1.65

alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VDIFF[ACMAG]=0
alter @VREFSTEP[ACMAG]=0


* OFFSET + ZERO INPUT VALUES

save INP INN OUTP OUTN REF VOCM AGND

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

save OUTP OUTN REF VOCM AGND

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


echo $runnum $vos_val $outp_zero_val $outn_zero_val $outdiff_zero_val $outp_center_val $outn_center_val $outcm_center_val $outdiff_center_val $ref_val $vocm_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_debug_op.txt

destroy all


* DIFFERENTIAL AC

alter @VDIFF[DC]=$vos_val

alter @VCM[ACMAG]=0

alter @VDIFF[ACMAG]=1
alter @VDIFF[ACPHASE]=0

alter @VREFSTEP[ACMAG]=0
alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0

save INP INN OUTP OUTN AGND

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


echo $runnum $vos_val $gain_db_val $ugf_val $phase_val $pm_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.ol_mc_summary.txt


destroy all

let run=run+1

end


let mode_index=mode_index+1
end

quit

.endc
* \{MEAS_END\}
"}
