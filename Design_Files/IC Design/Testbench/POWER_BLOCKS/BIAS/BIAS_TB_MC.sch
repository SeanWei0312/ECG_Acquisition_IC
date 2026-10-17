v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -570 {}
N 80 -260 80 -240 {lab=AGND}
N 80 -400 80 -380 {lab=AVDD}
N 640 -260 640 -240 {lab=#net1}
N 640 -180 640 -160 {lab=AGND}
N 1140 -330 1160 -330 {lab=AGND}
N 1140 -370 1160 -370 {lab=AVDD}
N 1200 -400 1200 -380 {lab=BPEXT}
N 1200 -320 1200 -300 {lab=AGND}
N 640 -400 640 -380 {lab=IB}
N 640 -320 640 -300 {lab=AGND}
N 580 -370 600 -370 {lab=AVDD}
N 580 -330 600 -330 {lab=AGND}
N 280 -840 280 -760 {lab=BPINT}
N 320 -720 360 -720 {lab=BPEXT}
N 320 -840 320 -720 {lab=BPEXT}
N 240 -760 360 -760 {lab=BPINT}
N 400 -680 400 -640 {lab=AVDD}
N 440 -840 440 -800 {lab=BIAS_SEL}
N 200 -600 440 -600 {lab=AGND}
N 440 -680 440 -600 {lab=AGND}
N 160 -640 480 -640 {lab=AVDD}
N 160 -680 160 -560 {lab=AVDD}
N 200 -680 200 -560 {lab=AGND}
N 520 -840 520 -720 {lab=BP}
N 560 -840 560 -720 {lab=IB}
N 480 -760 520 -760 {lab=BP}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
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
* \{MODELS_END\}
"}
C {devices/code_shown.sym} 640 90 0 0 {name=SETUP
only_toplevel=true
value="
* \{SETUP_START\}
.param VDD_SET=3.3
.param TEMP_SET=27

.param BPEXT_RATIO=0.75
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
set mode=mm
alterparam sw_stat_global=0
alterparam sw_stat_mismatch=1
end
if mode_index = 1
set mode=gl
alterparam sw_stat_global=1
alterparam sw_stat_mismatch=0
end
if mode_index = 2
set mode=full
alterparam sw_stat_global=1
alterparam sw_stat_mismatch=1
end
shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$mode\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$mode\}.Result_txt/\{$mode\}.mc_summary.txt /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$mode\}.Result_txt/\{$mode\}.startup_*.txt
echo run > /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$mode\}.Result_txt/\{$mode\}.mc_summary.txt
let run=1
let requested_runs=$&MC_RUNS
dowhile run <= requested_runs
set runnum=$&run
setseed $runnum
mc_source
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]

* STARTUP
alter @VSEL[pwl]=[ 0 0 10m 0 ]
tran 1u 10m

let ibias=abs(eload#branch)
let irs=abs(@m.xbias1.xmn2.m0[id])
let imst=abs(@m.xbias1.xmst.m0[id])
let vgs_mst=@m.xbias1.xmst.m0[vgs]
let vth_mst=@m.xbias1.xmst.m0[vth]
let idd_total=abs(vavdd#branch)
let power_total=v(AVDD)*idd_total
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$mode\}.Result_txt/\{$mode\}.startup_\{$runnum\}.txt v(AVDD) ibias
let final_index=length(time)-1
let run_id=run
let ibias_final=ibias[final_index]
let irs_final=irs[final_index]
let bp_final=v(BP)[final_index]
let imst_final=imst[final_index]
let mst_margin_final=vth_mst[final_index]-vgs_mst[final_index]
let idd_final=idd_total[final_index]
let power_final=power_total[final_index]
setscale run_id
set appendwrite
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$mode\}.Result_txt/\{$mode\}.mc_summary.txt ibias_final irs_final bp_final imst_final mst_margin_final idd_final power_final
unset appendwrite
destroy all
let run=run+1
end
let mode_index=mode_index+1
end
quit
.endc
* \{MEAS_END\}
"}
C {vsource.sym} 80 -350 0 0 {name=VAVDD value="PWL(0 0 100u 0 1.1m \{VDD_SET\} 10m \{VDD_SET\})"}
C {gnd.sym} 80 -320 0 0 {name=l5 lab=0}
C {vsource.sym} 80 -210 0 0 {name=VAVSS value=0}
C {gnd.sym} 80 -180 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -260 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -400 0 0 {name=p18 sig_type=std_logic lab=AVDD}
C {vsource.sym} 640 -210 0 0 {name=VSEL value="PWL(0 0 5m 0 5.001m \{VDD_SET\} 7m \{VDD_SET\} 7.001m 0 10m 0)"}
C {lab_wire.sym} 640 -160 2 0 {name=p20 sig_type=std_logic lab=AGND}
C {vcvs.sym} 1200 -350 0 0 {name=EBPEXT value=\{BPEXT_RATIO\}}
C {lab_wire.sym} 1140 -370 0 0 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 1140 -330 0 0 {name=p17 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -400 0 0 {name=p19 sig_type=std_logic lab=BPEXT}
C {lab_wire.sym} 1200 -300 2 0 {name=p172 sig_type=std_logic lab=AGND}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/POWER_BLOCKS/BIAS/BIAS.sym} 80 -640 0 0 {name=xBIAS1}
C {vcvs.sym} 640 -350 0 0 {name=ELOAD value=0.5}
C {lab_wire.sym} 580 -370 0 0 {name=p3 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 580 -330 0 0 {name=p4 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -400 0 0 {name=p5 sig_type=std_logic lab=IB}
C {lab_wire.sym} 640 -300 2 0 {name=p6 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 160 -560 2 1 {name=p9 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 200 -560 2 1 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 440 -840 0 0 {name=p33 sig_type=std_logic lab=BIAS_SEL}
C {lab_wire.sym} 320 -840 0 0 {name=p36 sig_type=std_logic lab=BPEXT}
C {lab_wire.sym} 280 -840 0 0 {name=p53 sig_type=std_logic lab=BPINT}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/DIGITAL_BLOCKS/MUX/MUX.sym} 280 -560 0 0 {name=xMUX1}
C {lab_wire.sym} 520 -840 0 0 {name=p7 sig_type=std_logic lab=BP}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/POWER_BLOCKS/MIRROR/MIRROR.sym} 40 -520 0 0 {name=xMIRROR1}
C {lab_wire.sym} 560 -840 0 0 {name=p55 sig_type=std_logic lab=IB}
C {noconn.sym} 520 -600 3 0 {name=l2}
C {noconn.sym} 580 -600 3 0 {name=l3}
C {noconn.sym} 620 -600 3 0 {name=l4}
C {noconn.sym} 700 -600 3 0 {name=l6}
C {noconn.sym} 740 -600 3 0 {name=l7}
C {noconn.sym} 1420 -600 3 0 {name=l8}
C {noconn.sym} 1460 -600 3 0 {name=l9}
C {noconn.sym} 2140 -600 3 0 {name=l10}
C {noconn.sym} 2180 -600 3 0 {name=l12}
C {noconn.sym} 2860 -600 3 0 {name=l13}
C {noconn.sym} 2900 -600 3 0 {name=l14}
C {lab_wire.sym} 640 -260 0 0 {name=p1 sig_type=std_logic lab=BIAS_SEL}
