v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -500 160 -500 {lab=NAND_DD}
N 140 -460 160 -460 {lab=NAND_SS}
N 140 -420 160 -420 {lab=NAND_IN1}
N 140 -340 160 -340 {lab=NAND_OUT}
N 440 -440 460 -440 {lab=NAND_DD}
N 460 -440 460 -400 {lab=NAND_DD}
N 440 -400 460 -400 {lab=NAND_DD}
N 560 -320 580 -320 {lab=NAND_SS}
N 680 -360 760 -360 {lab=NAND_OUT}
N 680 -440 700 -440 {lab=NAND_DD}
N 700 -440 700 -400 {lab=NAND_DD}
N 680 -400 700 -400 {lab=NAND_DD}
N 360 -400 400 -400 {lab=NAND_IN1}
N 600 -400 640 -400 {lab=NAND_IN2}
N 680 -480 680 -430 {lab=NAND_DD}
N 140 -380 160 -380 {lab=NAND_IN2}
N 560 -240 580 -240 {lab=NAND_SS}
N 440 -370 440 -360 {lab=NAND_OUT}
N 440 -360 680 -360 {lab=NAND_OUT}
N 680 -370 680 -360 {lab=NAND_OUT}
N 560 -360 560 -350 {lab=NAND_OUT}
N 560 -290 560 -270 {lab=#net1}
N 560 -210 560 -160 {lab=NAND_SS}
N 440 -480 680 -480 {lab=NAND_DD}
N 560 -200 580 -200 {lab=NAND_SS}
N 580 -320 580 -200 {lab=NAND_SS}
N 560 -520 560 -480 {lab=NAND_DD}
N 440 -480 440 -430 {lab=NAND_DD}
N 480 -320 520 -320 {lab=NAND_IN1}
N 480 -240 520 -240 {lab=NAND_IN2}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -500 0 1 {name=p8 lab=NAND_DD}
C {iopin.sym} 140 -460 0 1 {name=p9 lab=NAND_SS}
C {lab_wire.sym} 160 -500 0 1 {name=p11 sig_type=std_logic lab=NAND_DD}
C {lab_wire.sym} 160 -460 0 1 {name=p12 sig_type=std_logic lab=NAND_SS}
C {ipin.sym} 140 -420 0 0 {name=p13 lab=NAND_IN1}
C {opin.sym} 140 -340 0 1 {name=p14 lab=NAND_OUT}
C {lab_wire.sym} 160 -420 0 1 {name=p15 sig_type=std_logic lab=NAND_IN1}
C {lab_wire.sym} 160 -340 0 1 {name=p16 sig_type=std_logic lab=NAND_OUT}
C {symbols/pfet_03v3.sym} 420 -400 0 0 {name=MNANDP1
L=0.5u
W=2u
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
C {symbols/nfet_03v3.sym} 540 -320 0 0 {name=MNANDN1
L=0.5u
W=2u
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
C {lab_wire.sym} 560 -520 0 1 {name=p2 sig_type=std_logic lab=NAND_DD}
C {lab_wire.sym} 560 -160 2 0 {name=p3 sig_type=std_logic lab=NAND_SS}
C {lab_wire.sym} 760 -360 0 1 {name=p1 sig_type=std_logic lab=NAND_OUT}
C {symbols/pfet_03v3.sym} 660 -400 0 0 {name=MNANDP2
L=0.5u
W=2u
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
C {ipin.sym} 140 -380 0 0 {name=p4 lab=NAND_IN2}
C {lab_wire.sym} 160 -380 0 1 {name=p5 sig_type=std_logic lab=NAND_IN2}
C {lab_wire.sym} 360 -400 0 0 {name=p6 sig_type=std_logic lab=NAND_IN1}
C {lab_wire.sym} 600 -400 0 0 {name=p7 sig_type=std_logic lab=NAND_IN2}
C {symbols/nfet_03v3.sym} 540 -240 0 0 {name=MNANDN2
L=0.5u
W=2u
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
C {lab_wire.sym} 480 -320 0 0 {name=p10 sig_type=std_logic lab=NAND_IN1}
C {lab_wire.sym} 480 -240 0 0 {name=p17 sig_type=std_logic lab=NAND_IN2}
