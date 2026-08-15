v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -550 {}
N 1120 -880 1120 -860 {lab=AGND}
N 1120 -960 1120 -940 {lab=VREF}
N 160 -960 160 -940 {lab=AGND}
N 160 -1100 160 -1080 {lab=AVDD}
N 320 -960 320 -940 {lab=SEL}
N 320 -880 320 -860 {lab=AGND}
N 740 -1030 760 -1030 {lab=AGND}
N 740 -1070 760 -1070 {lab=AVDD}
N 800 -1100 800 -1080 {lab=BPEXT}
N 800 -1020 800 -1000 {lab=AGND}
N 800 -960 800 -940 {lab=VREFEXT}
N 800 -880 800 -860 {lab=AGND}
N 740 -930 760 -930 {lab=AVDD}
N 740 -890 760 -890 {lab=AGND}
N 1120 -1100 1120 -1080 {lab=MPLOAD_D}
N 1120 -1020 1120 -1000 {lab=AGND}
N 1060 -1070 1080 -1070 {lab=AVDD}
N 1060 -1030 1080 -1030 {lab=AGND}
N 160 -1300 160 -1260 {lab=AVDD}
N 200 -1300 200 -1260 {lab=AGND}
N 1380 -990 1380 -940 {lab=MPLOAD_D}
N 1380 -1100 1380 -1050 {lab=AVDD}
N 1300 -1020 1340 -1020 {lab=BP}
N 1380 -1020 1400 -1020 {lab=AVDD}
N 1400 -1060 1400 -1020 {lab=AVDD}
N 1380 -1060 1400 -1060 {lab=AVDD}
N 560 -1380 600 -1380 {lab=BP}
N 560 -1260 600 -1260 {lab=VREF}
N 320 -1300 360 -1300 {lab=BPEXT}
N 320 -1260 360 -1260 {lab=VREFEXT}
N 500 -1200 500 -1160 {lab=SEL}
N 420 -1200 420 -1160 {lab=AVDD}
N 460 -1200 460 -1160 {lab=AGND}
N 240 -1380 360 -1380 {lab=BPINT}
N 240 -1340 360 -1340 {lab=VREFINT}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -730 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
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

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_nom.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_vl.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_vh.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_tl.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_th.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_tlvl.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_thvh.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.dc2d.txt

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_nom.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_vl.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_vh.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_tl.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_th.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_tlvl.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.tran_thvh.txt v(AVDD) v(SEL) v(BPINT) v(BP) v(BPEXT) v(VREFINT) v(VREF) v(VREFEXT) ibias irs imst vgs_mst vth_mst idd_bias_sel power_bias_sel

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

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/BIAS/NOM.Result_txt/NOM.dc2d.txt v(AVDD) v(BPINT) v(BP) v(VREFINT) v(VREF) ibias irs mirror_error vref_error imst mst_margin idd_bias_sel power_bias_sel

quit

.endc
"}
C {capa.sym} 1120 -910 0 0 {name=CVREFLOAD
m=1
value=\{CVREF_LOAD_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1120 -860 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1120 -960 0 0 {name=p31 sig_type=std_logic lab=VREF}
C {vsource.sym} 160 -1050 0 0 {name=VAVDD value="PWL(0 0 100u 0 1.1m \{VDD_SET\} 10m \{VDD_SET\})"}
C {gnd.sym} 160 -1020 0 0 {name=l5 lab=0}
C {vsource.sym} 160 -910 0 0 {name=VAVSS value=0}
C {gnd.sym} 160 -880 0 0 {name=l11 lab=0}
C {lab_wire.sym} 160 -960 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 160 -1100 0 0 {name=p18 sig_type=std_logic lab=AVDD}
C {vsource.sym} 320 -910 0 0 {name=VSEL value="PWL(0 0 5m 0 5.001m \{VDD_SET\} 7m \{VDD_SET\} 7.001m 0 10m 0)"}
C {lab_wire.sym} 320 -860 2 0 {name=p20 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 320 -960 0 0 {name=p21 sig_type=std_logic lab=SEL}
C {vcvs.sym} 800 -1050 0 0 {name=EBPEXT value=\{BPEXT_RATIO\}}
C {vcvs.sym} 800 -910 0 0 {name=EVREFEXT value=\{VREFEXT_RATIO\}}
C {lab_wire.sym} 740 -930 0 0 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 740 -890 0 0 {name=p2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -1070 0 0 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 740 -1030 0 0 {name=p17 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 800 -1100 0 0 {name=p19 sig_type=std_logic lab=BPEXT}
C {lab_wire.sym} 800 -960 0 0 {name=p35 sig_type=std_logic lab=VREFEXT}
C {lab_wire.sym} 800 -1000 2 0 {name=p172 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 800 -860 2 0 {name=p174 sig_type=std_logic lab=AGND}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 80 -1260 0 0 {name=xBIAS1}
C {vcvs.sym} 1120 -1050 0 0 {name=ELOAD value=0.5}
C {lab_wire.sym} 1060 -1070 0 0 {name=p3 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 1060 -1030 0 0 {name=p4 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1120 -1100 0 0 {name=p5 sig_type=std_logic lab=MPLOAD_D}
C {lab_wire.sym} 1120 -1000 2 0 {name=p6 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 160 -1260 2 1 {name=p9 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 200 -1260 2 1 {name=p10 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 1360 -1020 0 0 {name=MPLOAD
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
C {lab_wire.sym} 1380 -1100 0 0 {name=p7 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 1380 -940 2 0 {name=p12 sig_type=std_logic lab=MPLOAD_D}
C {lab_wire.sym} 1300 -1020 0 0 {name=p14 sig_type=std_logic lab=BP}
C {lab_wire.sym} 500 -1160 2 0 {name=p11 sig_type=std_logic lab=SEL}
C {lab_wire.sym} 600 -1380 0 1 {name=p16 sig_type=std_logic lab=BP}
C {lab_wire.sym} 600 -1260 0 1 {name=p22 sig_type=std_logic lab=VREF}
C {lab_wire.sym} 320 -1300 0 0 {name=p24 sig_type=std_logic lab=BPEXT}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SEL/SEL.sym} 300 -1160 0 0 {name=xSEL1}
C {lab_wire.sym} 420 -1160 2 1 {name=p15 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 460 -1160 2 1 {name=p25 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 320 -1260 0 0 {name=p26 sig_type=std_logic lab=VREFEXT}
C {lab_wire.sym} 320 -1380 0 0 {name=p23 sig_type=std_logic lab=BPINT}
C {lab_wire.sym} 320 -1340 0 0 {name=p27 sig_type=std_logic lab=VREFINT}
