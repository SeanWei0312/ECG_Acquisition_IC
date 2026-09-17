v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -600 160 -600 {lab=SEOTA_DD}
N 140 -560 160 -560 {lab=SEOTA_SS}
N 140 -520 160 -520 {lab=SEOTA_INP}
N 140 -480 160 -480 {lab=SEOTA_INN}
N 140 -440 160 -440 {lab=SEOTA_OUT}
N 140 -400 160 -400 {lab=SEOTA_B}
N 760 -440 880 -440 {lab=#net1}
N 940 -440 980 -440 {lab=#net2}
N 880 -520 1000 -520 {lab=#net1}
N 980 -200 1000 -200 {lab=SEOTA_B}
N 580 -200 600 -200 {lab=SEOTA_B}
N 760 -330 760 -320 {lab=#net3}
N 520 -280 760 -280 {lab=#net3}
N 520 -330 520 -320 {lab=#net3}
N 520 -320 520 -280 {lab=#net3}
N 760 -320 760 -280 {lab=#net3}
N 640 -280 640 -230 {lab=#net3}
N 880 -520 880 -440 {lab=#net1}
N 1040 -490 1040 -440 {lab=SEOTA_OUT}
N 1040 -440 1040 -230 {lab=SEOTA_OUT}
N 520 -490 520 -390 {lab=#net4}
N 760 -440 760 -390 {lab=#net1}
N 760 -490 760 -440 {lab=#net1}
N 520 -600 520 -550 {lab=SEOTA_DD}
N 1040 -600 1040 -550 {lab=SEOTA_DD}
N 760 -600 760 -550 {lab=SEOTA_DD}
N 760 -600 1040 -600 {lab=SEOTA_DD}
N 520 -600 760 -600 {lab=SEOTA_DD}
N 800 -360 820 -360 {lab=SEOTA_INP}
N 460 -360 480 -360 {lab=SEOTA_INN}
N 560 -520 720 -520 {lab=#net4}
N 320 -260 380 -260 {lab=SEOTA_B}
N 380 -260 380 -200 {lab=SEOTA_B}
N 320 -260 320 -230 {lab=SEOTA_B}
N 320 -280 320 -260 {lab=SEOTA_B}
N 320 -170 320 -120 {lab=SEOTA_SS}
N 640 -170 640 -120 {lab=SEOTA_SS}
N 1040 -170 1040 -120 {lab=SEOTA_SS}
N 1040 -360 1060 -360 {lab=SEOTA_OUT}
N 300 -200 320 -200 {lab=SEOTA_SS}
N 300 -200 300 -160 {lab=SEOTA_SS}
N 300 -160 320 -160 {lab=SEOTA_SS}
N 640 -200 660 -200 {lab=SEOTA_SS}
N 660 -200 660 -160 {lab=SEOTA_SS}
N 640 -160 660 -160 {lab=SEOTA_SS}
N 1040 -200 1060 -200 {lab=SEOTA_SS}
N 1060 -200 1060 -160 {lab=SEOTA_SS}
N 1040 -160 1060 -160 {lab=SEOTA_SS}
N 1040 -520 1060 -520 {lab=SEOTA_DD}
N 1060 -560 1060 -520 {lab=SEOTA_DD}
N 1040 -560 1060 -560 {lab=SEOTA_DD}
N 760 -520 780 -520 {lab=SEOTA_DD}
N 780 -560 780 -520 {lab=SEOTA_DD}
N 760 -560 780 -560 {lab=SEOTA_DD}
N 500 -520 520 -520 {lab=SEOTA_DD}
N 500 -560 500 -520 {lab=SEOTA_DD}
N 500 -560 520 -560 {lab=SEOTA_DD}
N 520 -360 540 -360 {lab=SEOTA_SS}
N 540 -360 540 -120 {lab=SEOTA_SS}
N 740 -360 760 -360 {lab=SEOTA_SS}
N 740 -360 740 -120 {lab=SEOTA_SS}
N 360 -200 380 -200 {lab=SEOTA_B}
N 320 -120 1040 -120 {lab=SEOTA_SS}
N 640 -520 640 -440 {lab=#net4}
N 520 -440 640 -440 {lab=#net4}
N 910 -420 910 -120 {lab=SEOTA_SS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -600 0 1 {name=p8 lab=SEOTA_DD}
C {iopin.sym} 140 -560 0 1 {name=p9 lab=SEOTA_SS}
C {lab_wire.sym} 160 -600 0 1 {name=p11 sig_type=std_logic lab=SEOTA_DD}
C {lab_wire.sym} 160 -560 0 1 {name=p12 sig_type=std_logic lab=SEOTA_SS}
C {ipin.sym} 140 -520 0 0 {name=p13 lab=SEOTA_INP}
C {ipin.sym} 140 -480 0 0 {name=p14 lab=SEOTA_INN}
C {lab_wire.sym} 160 -520 0 1 {name=p15 sig_type=std_logic lab=SEOTA_INP}
C {lab_wire.sym} 160 -480 0 1 {name=p16 sig_type=std_logic lab=SEOTA_INN}
C {opin.sym} 140 -440 0 1 {name=p17 lab=SEOTA_OUT}
C {lab_wire.sym} 160 -440 0 1 {name=p18 sig_type=std_logic lab=SEOTA_OUT}
C {iopin.sym} 140 -400 0 1 {name=p1 lab=SEOTA_B}
C {lab_wire.sym} 160 -400 0 1 {name=p19 sig_type=std_logic lab=SEOTA_B}
C {symbols/pfet_03v3.sym} 540 -520 0 1 {name=M3
L=4u
W=30u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1020 -200 0 0 {name=M7
L=0.5u
W=100u
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
C {symbols/nfet_03v3.sym} 620 -200 0 0 {name=M5
L=2u
W=10u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X}
C {symbols/pfet_03v3.sym} 1020 -520 0 0 {name=M6
L=0.5u
W=50u
nf=1
m=8
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 340 -200 0 1 {name=M8
L=2u
W=20u
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
C {lab_wire.sym} 640 -600 2 1 {name=p2 sig_type=std_logic lab=SEOTA_DD}
C {lab_wire.sym} 1060 -360 2 0 {name=p3 sig_type=std_logic lab=SEOTA_OUT}
C {lab_wire.sym} 980 -200 2 1 {name=p4 sig_type=std_logic lab=SEOTA_B
}
C {lab_wire.sym} 380 -200 2 0 {name=p5 sig_type=std_logic lab=SEOTA_B
}
C {lab_wire.sym} 820 -360 2 0 {name=p6 sig_type=std_logic lab=SEOTA_INP
}
C {lab_wire.sym} 640 -120 2 1 {name=p10 sig_type=std_logic lab=SEOTA_SS}
C {lab_wire.sym} 580 -200 2 1 {name=p22 sig_type=std_logic lab=SEOTA_B
}
C {symbols/pfet_03v3.sym} 740 -520 0 0 {name=M4
L=4u
W=30u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 500 -360 0 0 {name=M1
L=4u
W=100u
nf=1
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 780 -360 0 1 {name=M2
L=4u
W=100u
nf=1
m=4
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 460 -360 2 1 {name=p7 sig_type=std_logic lab=SEOTA_INN
}
C {symbols/ppolyf_u_2k.sym} 910 -440 3 0 {name=Rz
W=4e-6
L=7.6e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 1010 -440 1 0 {name=Cc
W=31.623e-6
L=31.623e-6
model=cap_mim_2f0fF
spiceprefix=X
m=1}
