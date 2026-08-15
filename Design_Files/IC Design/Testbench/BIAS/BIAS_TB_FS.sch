v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -550 {}
N 1120 -900 1120 -880 {lab=AGND}
N 1120 -980 1120 -960 {lab=VREF}
N 160 -980 160 -960 {lab=AGND}
N 160 -1120 160 -1100 {lab=AVDD}
N 320 -980 320 -960 {lab=SEL}
N 320 -900 320 -880 {lab=AGND}
N 740 -1050 760 -1050 {lab=AGND}
N 740 -1090 760 -1090 {lab=AVDD}
N 800 -1120 800 -1100 {lab=BPEXT}
N 800 -1040 800 -1020 {lab=AGND}
N 800 -980 800 -960 {lab=VREFEXT}
N 800 -900 800 -880 {lab=AGND}
N 740 -950 760 -950 {lab=AVDD}
N 740 -910 760 -910 {lab=AGND}
N 1120 -1120 1120 -1100 {lab=MPLOAD_D}
N 1120 -1040 1120 -1020 {lab=AGND}
N 1060 -1090 1080 -1090 {lab=AVDD}
N 1060 -1050 1080 -1050 {lab=AGND}
N 160 -1320 160 -1280 {lab=AVDD}
N 200 -1320 200 -1280 {lab=AGND}
N 1380 -1010 1380 -960 {lab=MPLOAD_D}
N 1380 -1120 1380 -1070 {lab=AVDD}
N 1300 -1040 1340 -1040 {lab=BP}
N 1380 -1040 1400 -1040 {lab=AVDD}
N 1400 -1080 1400 -1040 {lab=AVDD}
N 1380 -1080 1400 -1080 {lab=AVDD}
N 560 -1400 600 -1400 {lab=BP}
N 560 -1280 600 -1280 {lab=VREF}
N 320 -1320 360 -1320 {lab=BPEXT}
N 320 -1280 360 -1280 {lab=VREFEXT}
N 500 -1220 500 -1180 {lab=SEL}
N 420 -1220 420 -1180 {lab=AVDD}
N 460 -1220 460 -1180 {lab=AGND}
N 240 -1400 360 -1400 {lab=BPINT}
N 240 -1360 360 -1360 {lab=VREFINT}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -730 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice fs
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.param TEMP_SET=27
.param VDD_SET=3.3
.temp \{TEMP_SET\}
"}
C {devices/code_shown.sym} 80 -470 0 0 {name=SETUP
only_toplevel=true
value="
.param BPEXT_RATIO=0.75
.param VREFEXT_RATIO=0.45
.param CVREF_LOAD_SET=1p

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {devices/code_shown.sym} 1010 -730 0 0 {name=NGSPICE
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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_nom.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_vl.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_vh.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_tl.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_th.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_tlvl.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_thvh.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.dc2d.txt

alterparam VDD_SET=3.3
alterparam TEMP_SET=27
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]
tran 1u 10m
let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_nom.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

alterparam VDD_SET=3.0
alterparam TEMP_SET=27
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]
tran 1u 10m
let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_vl.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

alterparam VDD_SET=3.6
alterparam TEMP_SET=27
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]
tran 1u 10m
let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_vh.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

alterparam VDD_SET=3.3
alterparam TEMP_SET=-40
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]
tran 1u 10m
let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_tl.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

alterparam VDD_SET=3.3
alterparam TEMP_SET=125
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]
tran 1u 10m
let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_th.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

alterparam VDD_SET=3.0
alterparam TEMP_SET=-40
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]
tran 1u 10m
let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_tlvl.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

alterparam VDD_SET=3.6
alterparam TEMP_SET=125
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]
tran 1u 10m
let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.tran_thvh.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

alterparam VDD_SET=3.3
alterparam TEMP_SET=27
reset
save all
save @m.xbias1.xmn2.m0[id]
save @m.xbias1.xmst.m0[id]
save @m.xbias1.xmst.m0[vgs]
save @m.xbias1.xmst.m0[vth]

dc TEMP -40 125 1 VAVDD 3.0 3.6 0.01

let ibias = abs(eload#branch)
let irs = abs(@m.xbias1.xmn2.m0[id])
let imst = abs(@m.xbias1.xmst.m0[id])
let vgs_mst = @m.xbias1.xmst.m0[vgs]
let vth_mst = @m.xbias1.xmst.m0[vth]
let mst_margin = vth_mst-vgs_mst
let mirror_error = 100*(ibias-irs)/irs
let vref_error = v(VREF)-v(AVDD)/2
let idd_total = abs(vavdd#branch)
let idd_bias_sel = idd_total-ibias
let power_bias_sel = v(AVDD)*idd_bias_sel

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/FS.Result_txt/FS.dc2d.txt v(AVDD) v(BPINT) v(BP) v(VREFINT) v(VREF) ibias irs mirror_error vref_error imst mst_margin idd_bias_sel power_bias_sel

quit

.endc
"}
C {capa.sym} 1120 -930 0 0 {name=CVREFLOAD
m=1
value=\{CVREF_LOAD_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1120 -880 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1120 -980 0 0 {name=p31 sig_type=std_logic lab=VREF}
C {vsource.sym} 160 -1070 0 0 {name=VAVDD value="PWL(0 0 100u 0 1.1m \{VDD_SET\} 10m \{VDD_SET\})"}
C {gnd.sym} 160 -1040 0 0 {name=l5 lab=0}
C {vsource.sym} 160 -930 0 0 {name=VAVSS value=0}
C {gnd.sym} 160 -900 0 0 {name=l11 lab=0}
C {lab_wire.sym} 160 -980 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 160 -1120 0 0 {name=p18 sig_type=std_logic lab=AVDD}
C {vsource.sym} 320 -930 0 0 {name=VSEL value="PWL(0 0 5m 0 5.001m \{VDD_SET\} 7m \{VDD_SET\} 7.001m 0 10m 0)"}
C {lab_wire.sym} 320 -880 2 0 {name=p20 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 320 -980 0 0 {name=p21 sig_type=std_logic lab=SEL}
C {vcvs.sym} 800 -1070 0 0 {name=EBPEXT value=\{BPEXT_RATIO\}}
C {vcvs.sym} 800 -930 0 0 {name=EVREFEXT value=\{VREFEXT_RATIO\}}
C {lab_wire.sym} 740 -950 0 0 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 740 -910 0 0 {name=p2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -1090 0 0 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 740 -1050 0 0 {name=p17 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 800 -1120 0 0 {name=p19 sig_type=std_logic lab=BPEXT}
C {lab_wire.sym} 800 -980 0 0 {name=p35 sig_type=std_logic lab=VREFEXT}
C {lab_wire.sym} 800 -1020 2 0 {name=p172 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 800 -880 2 0 {name=p174 sig_type=std_logic lab=AGND}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 80 -1280 0 0 {name=xBIAS1}
C {vcvs.sym} 1120 -1070 0 0 {name=ELOAD value=0.5}
C {lab_wire.sym} 1060 -1090 0 0 {name=p3 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 1060 -1050 0 0 {name=p4 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1120 -1120 0 0 {name=p5 sig_type=std_logic lab=MPLOAD_D}
C {lab_wire.sym} 1120 -1020 2 0 {name=p6 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 160 -1280 2 1 {name=p9 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 200 -1280 2 1 {name=p10 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 1360 -1040 0 0 {name=MPLOAD
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
C {lab_wire.sym} 1380 -1120 0 0 {name=p7 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 1380 -960 2 0 {name=p12 sig_type=std_logic lab=MPLOAD_D}
C {lab_wire.sym} 1300 -1040 0 0 {name=p14 sig_type=std_logic lab=BP}
C {lab_wire.sym} 500 -1180 2 0 {name=p11 sig_type=std_logic lab=SEL}
C {lab_wire.sym} 600 -1400 0 1 {name=p16 sig_type=std_logic lab=BP}
C {lab_wire.sym} 600 -1280 0 1 {name=p22 sig_type=std_logic lab=VREF}
C {lab_wire.sym} 320 -1320 0 0 {name=p24 sig_type=std_logic lab=BPEXT}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SEL/SEL.sym} 300 -1180 0 0 {name=xSEL1}
C {lab_wire.sym} 420 -1180 2 1 {name=p15 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 460 -1180 2 1 {name=p25 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 320 -1280 0 0 {name=p26 sig_type=std_logic lab=VREFEXT}
C {lab_wire.sym} 320 -1400 0 0 {name=p23 sig_type=std_logic lab=BPINT}
C {lab_wire.sym} 320 -1360 0 0 {name=p27 sig_type=std_logic lab=VREFINT}
