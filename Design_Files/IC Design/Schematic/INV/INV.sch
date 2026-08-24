v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -380 160 -380 {lab=INV_DD}
N 140 -340 160 -340 {lab=INV_SS}
N 140 -300 160 -300 {lab=INV_IN}
N 140 -260 160 -260 {lab=INV_OUT}
N 480 -320 520 -320 {lab=INV_IN}
N 520 -360 520 -280 {lab=INV_IN}
N 560 -330 560 -310 {lab=INV_OUT}
N 560 -440 560 -390 {lab=INV_DD}
N 560 -400 580 -400 {lab=INV_DD}
N 580 -400 580 -360 {lab=INV_DD}
N 560 -360 580 -360 {lab=INV_DD}
N 560 -280 580 -280 {lab=INV_SS}
N 580 -280 580 -240 {lab=INV_SS}
N 560 -240 580 -240 {lab=INV_SS}
N 560 -250 560 -200 {lab=INV_SS}
N 560 -320 640 -320 {lab=INV_OUT}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -380 0 1 {name=p8 lab=INV_DD}
C {iopin.sym} 140 -340 0 1 {name=p9 lab=INV_SS}
C {lab_wire.sym} 160 -380 0 1 {name=p11 sig_type=std_logic lab=INV_DD}
C {lab_wire.sym} 160 -340 0 1 {name=p12 sig_type=std_logic lab=INV_SS}
C {ipin.sym} 140 -300 0 0 {name=p13 lab=INV_IN}
C {opin.sym} 140 -260 0 1 {name=p14 lab=INV_OUT}
C {lab_wire.sym} 160 -300 0 1 {name=p15 sig_type=std_logic lab=INV_IN}
C {lab_wire.sym} 160 -260 0 1 {name=p16 sig_type=std_logic lab=INV_OUT}
C {symbols/pfet_03v3.sym} 540 -360 0 0 {name=MINVP
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
C {symbols/nfet_03v3.sym} 540 -280 0 0 {name=MINVN
L=0.5u
W=1u
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
C {lab_wire.sym} 560 -440 0 1 {name=p2 sig_type=std_logic lab=INV_DD}
C {lab_wire.sym} 560 -200 2 0 {name=p3 sig_type=std_logic lab=INV_SS}
C {lab_wire.sym} 640 -320 0 1 {name=p1 sig_type=std_logic lab=INV_OUT}
C {lab_wire.sym} 480 -320 0 0 {name=p4 sig_type=std_logic lab=INV_IN}
