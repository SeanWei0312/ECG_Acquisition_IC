v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -500 160 -500 {lab=TG_DD}
N 140 -460 160 -460 {lab=TG_SS}
N 140 -420 160 -420 {lab=TG_A}
N 140 -380 160 -380 {lab=TG_B}
N 640 -480 640 -470 {lab=TG_A}
N 440 -480 440 -470 {lab=TG_A}
N 440 -410 440 -400 {lab=TG_B}
N 640 -410 640 -400 {lab=TG_B}
N 440 -440 460 -440 {lab=TG_SS}
N 620 -440 640 -440 {lab=TG_DD}
N 140 -340 160 -340 {lab=TG_SEL}
N 140 -300 160 -300 {lab=TG_SELB}
N 360 -440 400 -440 {lab=TG_SEL}
N 540 -520 540 -480 {lab=TG_A}
N 540 -400 540 -360 {lab=TG_B}
N 680 -440 720 -440 {lab=TG_SELB}
N 440 -480 640 -480 {lab=TG_A}
N 440 -400 640 -400 {lab=TG_B}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -500 0 1 {name=p8 lab=TG_DD}
C {iopin.sym} 140 -460 0 1 {name=p9 lab=TG_SS}
C {lab_wire.sym} 160 -500 0 1 {name=p11 sig_type=std_logic lab=TG_DD}
C {lab_wire.sym} 160 -460 0 1 {name=p12 sig_type=std_logic lab=TG_SS}
C {iopin.sym} 140 -420 0 1 {name=p13 lab=TG_A}
C {iopin.sym} 140 -380 0 1 {name=p14 lab=TG_B}
C {lab_wire.sym} 160 -420 0 1 {name=p15 sig_type=std_logic lab=TG_A}
C {lab_wire.sym} 160 -380 0 1 {name=p16 sig_type=std_logic lab=TG_B}
C {lab_wire.sym} 720 -440 0 1 {name=p1 sig_type=std_logic lab=TG_SELB}
C {lab_wire.sym} 360 -440 0 0 {name=p4 sig_type=std_logic lab=TG_SEL}
C {symbols/pfet_03v3.sym} 660 -440 0 1 {name=MTGP
L=0.5u
W=10u
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
C {symbols/nfet_03v3.sym} 420 -440 0 0 {name=MTGN
L=0.5u
W=5u
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
C {lab_wire.sym} 620 -440 0 0 {name=p22 sig_type=std_logic lab=TG_DD}
C {lab_wire.sym} 460 -440 0 1 {name=p26 sig_type=std_logic lab=TG_SS}
C {ipin.sym} 140 -340 0 0 {name=p2 lab=TG_SEL}
C {lab_wire.sym} 160 -340 0 1 {name=p3 sig_type=std_logic lab=TG_SEL}
C {ipin.sym} 140 -300 0 0 {name=p5 lab=TG_SELB}
C {lab_wire.sym} 160 -300 0 1 {name=p6 sig_type=std_logic lab=TG_SELB}
C {lab_wire.sym} 540 -520 0 1 {name=p7 sig_type=std_logic lab=TG_A}
C {lab_wire.sym} 540 -360 2 0 {name=p10 sig_type=std_logic lab=TG_B}
