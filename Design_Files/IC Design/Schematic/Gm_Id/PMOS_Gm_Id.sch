v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1280 -420 1320 -420 {
lab=PG}
N 1360 -500 1360 -450 {
lab=VDD}
N 1360 -420 1460 -420 {
lab=VDD}
N 1360 -390 1360 -320 {
lab=PD}
N 1160 -500 1160 -450 {lab=VDD}
N 1060 -500 1060 -450 {lab=VDD}
N 1060 -390 1060 -320 {lab=PD}
N 1160 -390 1160 -320 {lab=PG}
N 960 -500 960 -450 {lab=VDD}
N 960 -390 960 -320 {lab=GND}
C {devices/lab_pin.sym} 1280 -420 0 0 {name=l1 sig_type=std_logic lab=PG}
C {devices/lab_pin.sym} 1360 -320 0 0 {name=l3 sig_type=std_logic lab=PD}
C {devices/code_shown.sym} 1540 -3210 0 0 {name=NGSPICE only_toplevel=true
value="

.param PWid=10u
.param PLen=1u
.param SG=0
.param SD=1.65

.control

shell mkdir -p /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/

set wr_vecnames
set wr_singlescale

* =========================================================
* PMOS gm/Id + fT 2D DC sweep
* W fixed at 10u
* VSG: 0 to 3.3 V
* VSD: 0 to 3.3 V
* Export: VSG VSD ID ID/W gm gds Cgs Cgd Cgb Cgg fT
* =========================================================

alterparam PLen = 0.28u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L0p28u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam PLen = 0.5u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L0p5u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam PLen = 1u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L1u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam PLen = 1.5u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L1p5u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam PLen = 2u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L2u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam PLen = 3u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L3u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam PLen = 4u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L4u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam PLen = 5u
reset
save v(vdd) v(pg) v(pd) vsd#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VSG 0 3.3 0.01 VSD 0 3.3 0.05
let vsg_out = v(vdd)-v(pg)
let vsd_out = v(vdd)-v(pd)
let id = abs(vsd#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/pmos_L5u_W10u.txt vsg_out vsd_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

.endc
"}
C {symbols/pfet_03v3.sym} 1340 -420 0 0 {name=M1
L=PLen
W=PWid
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {devices/code_shown.sym} 950 -240 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {vsource.sym} 1160 -420 0 0 {name=VSG value=SG savecurrent=false}
C {vsource.sym} 1060 -420 0 0 {name=VSD value=SD savecurrent=true}
C {devices/lab_pin.sym} 1160 -320 0 0 {name=l2 sig_type=std_logic lab=PG}
C {vdd.sym} 1360 -500 0 0 {name=l7 lab=VDD}
C {vdd.sym} 1460 -420 0 0 {name=l8 lab=VDD}
C {vsource.sym} 960 -420 0 0 {name=VDD value=3.3 savecurrent=false}
C {gnd.sym} 960 -320 0 0 {name=l9 lab=GND}
C {vdd.sym} 960 -500 0 0 {name=l10 lab=VDD}
C {devices/lab_pin.sym} 1060 -320 0 0 {name=l12 sig_type=std_logic lab=PD}
C {vdd.sym} 1060 -500 0 0 {name=l19 lab=VDD}
C {vdd.sym} 1160 -500 0 0 {name=l20 lab=VDD}
