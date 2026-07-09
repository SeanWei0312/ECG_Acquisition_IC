v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 870 -390 910 -390 {
lab=NG}
N 950 -470 950 -420 {
lab=ND}
N 950 -390 1050 -390 {
lab=GND}
N 950 -360 950 -290 {
lab=GND}
N 750 -470 750 -420 {lab=NG}
N 650 -470 650 -420 {lab=ND}
N 750 -360 750 -290 {lab=GND}
N 650 -360 650 -290 {lab=GND}
N 550 -470 550 -420 {lab=VDD}
N 550 -360 550 -290 {lab=GND}
C {devices/code_shown.sym} 1170 -3530 0 0 {name=NGSPICE only_toplevel=true
value="

.param NWid=10u
.param NLen=1u
.param GS=0
.param DS=1.65

.control

shell mkdir -p /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/

set wr_vecnames
set wr_singlescale

* =========================================================
* NMOS gm/Id + fT 2D DC sweep
* W fixed at 10u
* VGS: 0 to 3.3 V
* VDS: 0 to 3.3 V
* Export: VGS VDS ID ID/W gm gds Cgs Cgd Cgb Cgg fT
* =========================================================

alterparam NLen = 0.28u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L0p28u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam NLen = 0.5u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L0p5u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam NLen = 1u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L1u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam NLen = 1.5u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L1p5u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam NLen = 2u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L2u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam NLen = 3u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L3u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam NLen = 4u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L4u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

alterparam NLen = 5u
reset
save v(ng) v(nd) vds#branch @m.xm1.m0[gm] @m.xm1.m0[gds] @m.xm1.m0[cgs] @m.xm1.m0[cgd] @m.xm1.m0[cgb]
dc VGS 0 3.3 0.01 VDS 0 3.3 0.05
let vgs_out = v(ng)
let vds_out = v(nd)
let id = abs(vds#branch)
let id_w = id/10e-6
let gm = abs(@m.xm1.m0[gm])
let gds = abs(@m.xm1.m0[gds])
let cgs = abs(@m.xm1.m0[cgs])
let cgd = abs(@m.xm1.m0[cgd])
let cgb = abs(@m.xm1.m0[cgb])
let cgg = cgs + cgd + cgb
let ft_hz = gm/(6.283185307179586*(cgg + 1e-30))
let ft_mhz = ft_hz/1e6
wrdata /foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/nmos_L5u_W10u.txt vgs_out vds_out id id_w gm gds cgs cgd cgb cgg ft_hz ft_mhz

.endc
"}
C {devices/code_shown.sym} 530 -220 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/lab_pin.sym} 870 -390 0 0 {name=l5 sig_type=std_logic lab=NG}
C {devices/lab_pin.sym} 950 -470 0 0 {name=l6 sig_type=std_logic lab=ND}
C {symbols/nfet_03v3.sym} 930 -390 0 0 {name=M1
L=NLen
W=NWid
nf=1
mult=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {vsource.sym} 750 -390 0 0 {name=VGS value=GS savecurrent=true}
C {vsource.sym} 650 -390 0 0 {name=VDS value=DS savecurrent=true}
C {vsource.sym} 550 -390 0 0 {name=VDD value=3.3 savecurrent=false}
C {gnd.sym} 550 -290 0 0 {name=l11 lab=GND}
C {gnd.sym} 650 -290 0 0 {name=l13 lab=GND}
C {gnd.sym} 750 -290 0 0 {name=l14 lab=GND}
C {gnd.sym} 950 -290 0 0 {name=l15 lab=GND}
C {gnd.sym} 1050 -390 0 0 {name=l16 lab=GND}
C {vdd.sym} 550 -470 0 0 {name=l4 lab=VDD}
C {devices/lab_pin.sym} 750 -470 0 0 {name=l17 sig_type=std_logic lab=NG}
C {devices/lab_pin.sym} 650 -470 0 0 {name=l18 sig_type=std_logic lab=ND}
