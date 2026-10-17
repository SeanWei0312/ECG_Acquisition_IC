v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 640 -400 640 -380 {lab=VINCM}
N 1200 -400 1200 -380 {lab=REF}
N 80 -260 80 -240 {lab=AGND}
N 640 -320 640 -300 {lab=AGND}
N 640 -260 640 -240 {lab=DIFFCMD}
N 640 -180 640 -160 {lab=AGND}
N 1120 -720 1120 -700 {lab=AGND}
N 1120 -800 1120 -780 {lab=OUTP}
N 1200 -720 1200 -700 {lab=AGND}
N 1200 -800 1200 -780 {lab=OUTN}
N 760 -760 780 -760 {lab=REF}
N 830 -680 830 -660 {lab=AGND}
N 860 -680 860 -660 {lab=BCMFB}
N 860 -860 860 -840 {lab=BFDC}
N 940 -760 960 -760 {lab=VOCM}
N 1800 -400 1800 -380 {lab=ODIFF}
N 1800 -320 1800 -300 {lab=AGND}
N 1800 -260 1800 -240 {lab=DERR}
N 1800 -180 1800 -160 {lab=AGND}
N 1740 -370 1760 -370 {lab=OUTP}
N 1740 -330 1760 -330 {lab=OUTN}
N 1740 -230 1760 -230 {lab=DIFFCMD}
N 1740 -190 1760 -190 {lab=ODIFF}
N 940 -720 980 -720 {lab=OUTP}
N 940 -800 980 -800 {lab=OUTN}
N 80 -400 80 -380 {lab=AVDD}
N 830 -860 830 -840 {lab=AVDD}
N 120 -700 120 -660 {lab=AVDD}
N 160 -700 160 -660 {lab=AGND}
N 320 -750 320 -700 {lab=BFDC}
N 320 -860 320 -810 {lab=AVDD}
N 200 -780 280 -780 {lab=BP}
N 320 -780 340 -780 {lab=AVDD}
N 340 -820 340 -780 {lab=AVDD}
N 320 -820 340 -820 {lab=AVDD}
N 480 -750 480 -700 {lab=BCMFB}
N 480 -860 480 -810 {lab=AVDD}
N 480 -780 500 -780 {lab=AVDD}
N 500 -820 500 -780 {lab=AVDD}
N 480 -820 500 -820 {lab=AVDD}
N 400 -780 440 -780 {lab=BP}
N 2360 -400 2360 -380 {lab=INP}
N 2360 -320 2360 -300 {lab=VINCM}
N 2360 -260 2360 -240 {lab=INN}
N 2360 -180 2360 -160 {lab=VINCM}
N 2300 -370 2320 -370 {lab=DERR}
N 2300 -330 2320 -330 {lab=AGND}
N 2300 -230 2320 -230 {lab=DERR}
N 2300 -190 2320 -190 {lab=AGND}
N 760 -800 780 -800 {lab=INP}
N 760 -720 780 -720 {lab=INN}
N 1200 -320 1200 -300 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 80 -350 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -320 0 0 {name=l5 lab=0}
C {vsource.sym} 640 -350 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 640 -400 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 1200 -400 0 0 {name=p5 sig_type=std_logic lab=REF}
C {vsource.sym} 80 -210 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -180 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -260 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -300 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {vsource.sym} 640 -210 0 0 {name=VDIFFCMD value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 640 -260 0 0 {name=p22 sig_type=std_logic lab=DIFFCMD}
C {lab_wire.sym} 640 -160 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {capa.sym} 1120 -750 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1120 -800 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1120 -700 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 1200 -750 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1200 -700 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -800 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 760 -760 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 830 -660 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 860 -660 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 860 -860 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 980 -720 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 980 -800 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 960 -760 0 1 {name=p39 sig_type=std_logic lab=VOCM}
C {noconn.sym} 960 -760 0 1 {name=l3}
C {vcvs.sym} 1800 -350 0 0 {name=EODIFF value=1}
C {vcvs.sym} 1800 -210 0 0 {name=EDERR value=1}
C {lab_wire.sym} 1800 -400 0 0 {name=p14 sig_type=std_logic lab=ODIFF}
C {lab_wire.sym} 1740 -370 0 0 {name=p15 sig_type=std_logic lab=OUTP
}
C {lab_wire.sym} 1740 -330 0 0 {name=p16 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 1740 -230 0 0 {name=p17 sig_type=std_logic lab=DIFFCMD}
C {lab_wire.sym} 1740 -190 0 0 {name=p18 sig_type=std_logic lab=ODIFF}
C {lab_wire.sym} 1800 -300 2 0 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1800 -160 2 0 {name=p20 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1800 -260 0 0 {name=p21 sig_type=std_logic lab=DERR}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.sym} 700 -620 0 0 {name=xFDOTA1}
C {lab_wire.sym} 80 -400 0 0 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 830 -860 0 0 {name=p12 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/POWER_BLOCKS/BIAS/BIAS.sym} 40 -660 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -660 2 1 {name=p26 sig_type=std_logic lab=AVDD}
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
C {vcvs.sym} 2360 -350 0 0 {name=EINP value=0.5}
C {vcvs.sym} 2360 -210 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 2360 -400 0 0 {name=p27 sig_type=std_logic lab=INP}
C {lab_wire.sym} 2300 -370 0 0 {name=p38 sig_type=std_logic lab=DERR
}
C {lab_wire.sym} 2300 -330 0 0 {name=p43 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 2300 -230 0 0 {name=p44 sig_type=std_logic lab=DERR}
C {lab_wire.sym} 2300 -190 0 0 {name=p45 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 2360 -300 2 0 {name=p46 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 2360 -160 2 0 {name=p47 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 2360 -260 0 0 {name=p48 sig_type=std_logic lab=INN}
C {lab_wire.sym} 760 -800 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 760 -720 0 0 {name=p6 sig_type=std_logic lab=INN}
C {vsource.sym} 1200 -350 0 0 {name=VREFSTEP value="dc \{VREF_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 1200 -300 2 0 {name=p7 sig_type=std_logic lab=AGND}
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

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


echo run out_cm_error_V cl_gain_10 gain_error_pct ibias_fdc_A ibias_cmfb_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt

echo run vin_diff_V vos_cl_V outp_V outn_V outcm_V outdiff_V ref_V vocm_V bfdc_V bcmfb_V ibias_fdc_A ibias_cmfb_A idd_A power_W > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


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
alter @VDIFFCMD[DC]=0
alter @VREFSTEP[DC]=1.65

alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VDIFFCMD[ACMAG]=0
alter @VREFSTEP[ACMAG]=0


* OP

save AVDD AGND INP INN OUTP OUTN REF VOCM BFDC BCMFB
save vavdd#branch
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

op


let vin_diff=v(INP)-v(INN)

let outp=v(OUTP)-v(AGND)
let outn=v(OUTN)-v(AGND)

let outcm=0.5*(outp+outn)
let outdiff=outp-outn

let ref=v(REF)-v(AGND)
let vocm=v(VOCM)-v(AGND)

let out_cm_error=outcm-ref

let vos_cl=-vin_diff

let bfdc=v(BFDC)-v(AGND)
let bcmfb=v(BCMFB)-v(AGND)

let ibias_fdc=abs(@m.xmbfdc.m0[id])
let ibias_cmfb=abs(@m.xmbcmfb.m0[id])

let idd_total=abs(vavdd#branch)
let power_total=(v(AVDD)-v(AGND))*idd_total


set vin_diff_val=$&vin_diff
set vos_cl_val=$&vos_cl

set outp_val=$&outp
set outn_val=$&outn
set outcm_val=$&outcm
set outdiff_val=$&outdiff

set ref_val=$&ref
set vocm_val=$&vocm

set out_cm_error_val=$&out_cm_error

set bfdc_val=$&bfdc
set bcmfb_val=$&bcmfb

set ibias_fdc_val=$&ibias_fdc
set ibias_cmfb_val=$&ibias_cmfb

set idd_val=$&idd_total
set power_val=$&power_total


echo $runnum $vin_diff_val $vos_cl_val $outp_val $outn_val $outcm_val $outdiff_val $ref_val $vocm_val $bfdc_val $bcmfb_val $ibias_fdc_val $ibias_cmfb_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_debug_op.txt


destroy all


* DIFF AC

alter @VAVDD[ACMAG]=0
alter @VAVSS[ACMAG]=0
alter @VCM[ACMAG]=0
alter @VREFSTEP[ACMAG]=0

alter @VDIFFCMD[DC]=0
alter @VDIFFCMD[ACMAG]=1
alter @VDIFFCMD[ACPHASE]=0

save AGND OUTP OUTN DIFFCMD

ac dec 100 0.1 100Meg


let cmd_ac=v(DIFFCMD)-v(AGND)
let outdiff_ac=v(OUTP)-v(OUTN)

let cl_tf=outdiff_ac/cmd_ac
let cl_gain=mag(cl_tf)

meas ac cl_gain_10_meas find cl_gain at=10

let gain_error_pct=100*(cl_gain_10_meas-1)

set cl_gain_val=$&cl_gain_10_meas
set gain_error_val=$&gain_error_pct


echo $runnum $out_cm_error_val $cl_gain_val $gain_error_val $ibias_fdc_val $ibias_cmfb_val $idd_val $power_val >> /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_mc_summary.txt


destroy all

let run=run+1

end


let mode_index=mode_index+1
end

quit

.endc
* \{MEAS_END\}
"}
