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
.param sw_stat_global=0
.param sw_stat_mismatch=0
.include $::180MCU_MODELS/design.ngspice
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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$proc\}.Result_txt/\{$proc\}.tran_*.txt /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$proc\}.Result_txt/\{$proc\}.dc2d.txt

* STARTUP / SEL
foreach ecode 0 1 2 3 4 5 6 7 8
set env=nom
set vddval=3.3
set tval=27
if $ecode = 1
set env=vl
set vddval=3.0
end
if $ecode = 2
set env=vh
set vddval=3.6
end
if $ecode = 3
set env=tl
set tval=-40
end
if $ecode = 4
set env=th
set tval=125
end
if $ecode = 5
set env=tlvl
set vddval=3.0
set tval=-40
end
if $ecode = 6
set env=thvh
set vddval=3.6
set tval=125
end
if $ecode = 7
set env=tlvh
set vddval=3.6
set tval=-40
end
if $ecode = 8
set env=thvl
set vddval=3.0
set tval=125
end
alterparam VDD_SET=$vddval
alterparam TEMP_SET=$tval
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]

tran 1u 10m

let ibias=abs(eload#branch)
let irs=abs(@m.xbias1.xmn2.m0[id])
let imst=abs(@m.xbias1.xmst.m0[id])
let vgs_mst=@m.xbias1.xmst.m0[vgs]
let vth_mst=@m.xbias1.xmst.m0[vth]
let idd_total=abs(vavdd#branch)
let power_total=v(AVDD)*idd_total
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$proc\}.Result_txt/\{$proc\}.tran_\{$env\}.txt v(AVDD) v(BIAS_SEL) v(BPINT) v(BP) v(BPEXT) ibias irs imst vgs_mst vth_mst idd_total power_total
destroy all
end

* DC PVT GRID
alterparam VDD_SET=3.3
alterparam TEMP_SET=27
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]

dc TEMP -40 125 1 VAVDD 3.0 3.6 0.01

let ibias=abs(eload#branch)
let irs=abs(@m.xbias1.xmn2.m0[id])
let imst=abs(@m.xbias1.xmst.m0[id])
let vgs_mst=@m.xbias1.xmst.m0[vgs]
let vth_mst=@m.xbias1.xmst.m0[vth]
let idd_total=abs(vavdd#branch)
let power_total=v(AVDD)*idd_total
let mst_margin=vth_mst-vgs_mst
let mirror_error=100*(ibias-irs)/irs
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/\{$proc\}.Result_txt/\{$proc\}.dc2d.txt v(AVDD) v(BPINT) v(BP) ibias irs mirror_error imst mst_margin idd_total power_total
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
