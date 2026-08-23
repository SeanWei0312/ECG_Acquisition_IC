v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -520 160 -520 {lab=BIAS_DD}
N 140 -480 160 -480 {lab=BIAS_SS}
N 140 -440 160 -440 {lab=BIAS_BP}
N 140 -400 160 -400 {lab=BIAS_VREF}
N 680 -450 680 -400 {lab=#net1}
N 600 -530 600 -480 {lab=#net2}
N 520 -640 520 -560 {lab=BIAS_BP}
N 520 -560 560 -560 {lab=BIAS_BP}
N 480 -560 480 -480 {lab=#net2}
N 400 -560 480 -560 {lab=#net2}
N 440 -480 640 -480 {lab=#net2}
N 600 -600 680 -600 {lab=BIAS_BP}
N 520 -640 600 -640 {lab=BIAS_BP}
N 600 -680 600 -590 {lab=BIAS_BP}
N 680 -650 680 -510 {lab=BIAS_BP}
N 440 -680 640 -680 {lab=BIAS_BP}
N 400 -650 400 -510 {lab=#net2}
N 680 -760 680 -710 {lab=BIAS_DD}
N 400 -760 400 -710 {lab=BIAS_DD}
N 600 -560 620 -560 {lab=BIAS_SS}
N 680 -480 700 -480 {lab=BIAS_SS}
N 680 -680 700 -680 {lab=BIAS_DD}
N 700 -720 700 -680 {lab=BIAS_DD}
N 680 -720 700 -720 {lab=BIAS_DD}
N 380 -680 400 -680 {lab=BIAS_DD}
N 380 -720 380 -680 {lab=BIAS_DD}
N 380 -720 400 -720 {lab=BIAS_DD}
N 380 -480 400 -480 {lab=BIAS_SS}
N 840 -760 840 -540 {lab=BIAS_DD}
N 840 -480 840 -400 {lab=BIAS_VREF}
N 840 -440 1040 -440 {lab=BIAS_VREF}
N 1000 -440 1000 -400 {lab=BIAS_VREF}
N 680 -600 1040 -600 {lab=BIAS_BP}
N 400 -760 840 -760 {lab=BIAS_DD}
N 820 -510 820 -370 {lab=BIAS_SS}
N 700 -480 700 -370 {lab=BIAS_SS}
N 400 -450 400 -290 {lab=#net3}
N 680 -340 680 -290 {lab=#net4}
N 400 -230 400 -180 {lab=BIAS_SS}
N 680 -230 680 -180 {lab=BIAS_SS}
N 380 -180 1000 -180 {lab=BIAS_SS}
N 1000 -340 1000 -180 {lab=BIAS_SS}
N 840 -340 840 -180 {lab=BIAS_SS}
N 820 -370 820 -180 {lab=BIAS_SS}
N 700 -370 700 -180 {lab=BIAS_SS}
N 600 -260 640 -260 {lab=BIAS_SS}
N 600 -260 600 -180 {lab=BIAS_SS}
N 440 -260 480 -260 {lab=BIAS_SS}
N 480 -260 480 -180 {lab=BIAS_SS}
N 380 -480 380 -180 {lab=BIAS_SS}
N 620 -560 620 -180 {lab=BIAS_SS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -520 0 1 {name=p8 lab=BIAS_DD}
C {iopin.sym} 140 -480 0 1 {name=p9 lab=BIAS_SS}
C {lab_wire.sym} 160 -520 0 1 {name=p11 sig_type=std_logic lab=BIAS_DD}
C {lab_wire.sym} 160 -480 0 1 {name=p12 sig_type=std_logic lab=BIAS_SS}
C {opin.sym} 140 -440 0 1 {name=p17 lab=BIAS_BP}
C {lab_wire.sym} 160 -440 0 1 {name=p18 sig_type=std_logic lab=BIAS_BP}
C {opin.sym} 140 -400 0 1 {name=p23 lab=BIAS_VREF}
C {lab_wire.sym} 160 -400 0 1 {name=p24 sig_type=std_logic lab=BIAS_VREF}
C {symbols/nfet_03v3.sym} 660 -480 0 0 {name=MN2
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
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 660 -680 0 0 {name=MP2
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
C {symbols/nfet_03v3.sym} 420 -480 0 1 {name=MN1
L=4u
W=24u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 420 -680 0 1 {name=MP1
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
C {symbols/nfet_03v3.sym} 580 -560 0 0 {name=MST
L=10u
W=0.5u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 600 -760 0 1 {name=p2 sig_type=std_logic lab=BIAS_DD}
C {lab_wire.sym} 600 -180 2 0 {name=p3 sig_type=std_logic lab=BIAS_SS}
C {lab_wire.sym} 1040 -600 0 1 {name=p10 sig_type=std_logic lab=BIAS_BP}
C {lab_wire.sym} 1040 -440 0 1 {name=p20 sig_type=std_logic lab=BIAS_VREF}
C {symbols/ppolyf_u_2k.sym} 840 -510 0 0 {name=RP
W=4e-6
L=1000e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_2k.sym} 840 -370 0 0 {name=RN
W=4e-6
L=1000e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {symbols/pnp_05p00x00p42.sym} 420 -260 0 1 {name=Q1
model=pnp_05p00x00p42
spiceprefix=X
m=1}
C {symbols/pnp_05p00x00p42.sym} 660 -260 0 0 {name=Q2
model=pnp_05p00x00p42
spiceprefix=X
m=30}
C {symbols/nwell.sym} 680 -370 0 1 {name=RS
W=3e-6
L=1.522e-6
model=nwell
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 1000 -370 0 0 {name=CN
W=70.7e-6
L=70.7e-6
model=cap_mim_2f0fF
spiceprefix=X
m=1}
