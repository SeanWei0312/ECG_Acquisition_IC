v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 780 -440 900 -440 {lab=CMFB_OUT}
N 600 -200 620 -200 {lab=CMFB_B}
N 780 -330 780 -320 {lab=#net1}
N 540 -280 780 -280 {lab=#net1}
N 540 -330 540 -320 {lab=#net1}
N 540 -320 540 -280 {lab=#net1}
N 780 -320 780 -280 {lab=#net1}
N 660 -280 660 -230 {lab=#net1}
N 540 -490 540 -390 {lab=#net2}
N 780 -440 780 -390 {lab=CMFB_OUT}
N 780 -490 780 -440 {lab=CMFB_OUT}
N 540 -600 540 -550 {lab=CMFB_DD}
N 780 -600 780 -550 {lab=CMFB_DD}
N 540 -600 780 -600 {lab=CMFB_DD}
N 820 -360 840 -360 {lab=CMFB_IN}
N 480 -360 500 -360 {lab=CMFB_REF}
N 300 -260 360 -260 {lab=CMFB_B}
N 360 -260 360 -200 {lab=CMFB_B}
N 300 -260 300 -230 {lab=CMFB_B}
N 300 -280 300 -260 {lab=CMFB_B}
N 300 -170 300 -120 {lab=CMFB_SS}
N 660 -170 660 -120 {lab=CMFB_SS}
N 140 -600 160 -600 {lab=CMFB_DD}
N 140 -560 160 -560 {lab=CMFB_SS}
N 140 -520 160 -520 {lab=CMFB_IN}
N 140 -480 160 -480 {lab=CMFB_REF}
N 140 -440 160 -440 {lab=CMFB_OUT}
N 280 -200 300 -200 {lab=CMFB_SS}
N 280 -200 280 -160 {lab=CMFB_SS}
N 280 -160 300 -160 {lab=CMFB_SS}
N 660 -200 680 -200 {lab=CMFB_SS}
N 680 -200 680 -160 {lab=CMFB_SS}
N 660 -160 680 -160 {lab=CMFB_SS}
N 780 -520 800 -520 {lab=CMFB_DD}
N 800 -560 800 -520 {lab=CMFB_DD}
N 780 -560 800 -560 {lab=CMFB_DD}
N 520 -520 540 -520 {lab=CMFB_DD}
N 520 -560 520 -520 {lab=CMFB_DD}
N 520 -560 540 -560 {lab=CMFB_DD}
N 540 -360 560 -360 {lab=CMFB_SS}
N 560 -360 560 -120 {lab=CMFB_SS}
N 760 -360 780 -360 {lab=CMFB_SS}
N 760 -360 760 -120 {lab=CMFB_SS}
N 140 -400 160 -400 {lab=CMFB_B}
N 340 -200 360 -200 {lab=CMFB_B}
N 300 -120 760 -120 {lab=CMFB_SS}
N 540 -440 660 -440 {lab=#net2}
N 660 -520 660 -440 {lab=#net2}
N 580 -520 660 -520 {lab=#net2}
N 720 -520 740 -520 {lab=#net2}
N 660 -520 720 -520 {lab=#net2}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {symbols/pfet_03v3.sym} 760 -520 0 0 {name=M4
L=1u
W=1u
nf=1
m=100
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X}
C {symbols/pfet_03v3.sym} 560 -520 0 1 {name=M3
L=1u
W=1u
nf=1
m=100
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X

}
C {symbols/nfet_03v3.sym} 520 -360 0 0 {name=M1
L=1u
W=1u
nf=1
m=100
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X}
C {symbols/nfet_03v3.sym} 800 -360 0 1 {name=M2
L=1u
W=1u
nf=1
m=100
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X}
C {symbols/nfet_03v3.sym} 640 -200 0 0 {name=M5
L=1u
W=1u
nf=1
m=20
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X}
C {symbols/nfet_03v3.sym} 320 -200 0 1 {name=M10
L=1u
W=1u
nf=1
m=50
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X}
C {lab_wire.sym} 660 -600 2 1 {name=p2 sig_type=std_logic lab=CMFB_DD}
C {lab_wire.sym} 360 -200 2 0 {name=p5 sig_type=std_logic lab=CMFB_B
}
C {lab_wire.sym} 840 -360 2 0 {name=p6 sig_type=std_logic lab=CMFB_IN
}
C {iopin.sym} 140 -600 0 1 {name=p8 lab=CMFB_DD}
C {iopin.sym} 140 -560 0 1 {name=p9 lab=CMFB_SS}
C {lab_wire.sym} 660 -120 2 1 {name=p10 sig_type=std_logic lab=CMFB_SS}
C {lab_wire.sym} 160 -600 0 1 {name=p11 sig_type=std_logic lab=CMFB_DD}
C {lab_wire.sym} 160 -560 0 1 {name=p12 sig_type=std_logic lab=CMFB_SS}
C {ipin.sym} 140 -520 0 0 {name=p13 lab=CMFB_IN}
C {ipin.sym} 140 -480 0 0 {name=p14 lab=CMFB_REF}
C {lab_wire.sym} 160 -520 0 1 {name=p15 sig_type=std_logic lab=CMFB_IN}
C {lab_wire.sym} 160 -480 0 1 {name=p16 sig_type=std_logic lab=CMFB_REF}
C {opin.sym} 140 -440 0 1 {name=p17 lab=CMFB_OUT}
C {lab_wire.sym} 160 -440 0 1 {name=p18 sig_type=std_logic lab=CMFB_OUT}
C {iopin.sym} 140 -400 0 1 {name=p1 lab=CMFB_B}
C {lab_wire.sym} 160 -400 0 1 {name=p19 sig_type=std_logic lab=CMFB_B}
C {lab_wire.sym} 600 -200 2 1 {name=p22 sig_type=std_logic lab=CMFB_B
}
C {lab_wire.sym} 480 -360 2 1 {name=p3 sig_type=std_logic lab=CMFB_REF
}
C {lab_wire.sym} 900 -440 0 1 {name=p4 sig_type=std_logic lab=CMFB_OUT}
