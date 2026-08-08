v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -500 160 -500 {lab=INV_DD}
N 140 -460 160 -460 {lab=INV_SS}
N 140 -420 160 -420 {lab=INV_IN}
N 140 -380 160 -380 {lab=INV_OUT}
N 320 -440 360 -440 {lab=INV_IN}
N 360 -480 360 -400 {lab=INV_IN}
N 400 -450 400 -430 {lab=INV_OUT}
N 400 -560 400 -510 {lab=INV_DD}
N 400 -520 420 -520 {lab=INV_DD}
N 420 -520 420 -480 {lab=INV_DD}
N 400 -480 420 -480 {lab=INV_DD}
N 400 -400 420 -400 {lab=INV_SS}
N 420 -400 420 -360 {lab=INV_SS}
N 400 -360 420 -360 {lab=INV_SS}
N 400 -370 400 -320 {lab=INV_SS}
N 400 -440 480 -440 {lab=INV_OUT}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -500 0 1 {name=p8 lab=INV_DD}
C {iopin.sym} 140 -460 0 1 {name=p9 lab=INV_SS}
C {lab_wire.sym} 160 -500 0 1 {name=p11 sig_type=std_logic lab=INV_DD}
C {lab_wire.sym} 160 -460 0 1 {name=p12 sig_type=std_logic lab=INV_SS}
C {ipin.sym} 140 -420 0 0 {name=p13 lab=INV_IN}
C {opin.sym} 140 -380 0 1 {name=p14 lab=INV_OUT}
C {lab_wire.sym} 160 -420 0 1 {name=p15 sig_type=std_logic lab=INV_IN}
C {lab_wire.sym} 160 -380 0 1 {name=p16 sig_type=std_logic lab=INV_OUT}
C {symbols/pfet_03v3.sym} 380 -480 0 0 {name=MINVP
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
C {symbols/nfet_03v3.sym} 380 -400 0 0 {name=MINVN
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
C {lab_wire.sym} 400 -560 0 1 {name=p2 sig_type=std_logic lab=INV_DD}
C {lab_wire.sym} 400 -320 2 0 {name=p3 sig_type=std_logic lab=INV_SS}
C {lab_wire.sym} 480 -440 0 1 {name=p1 sig_type=std_logic lab=INV_OUT}
C {lab_wire.sym} 320 -440 0 0 {name=p4 sig_type=std_logic lab=INV_IN}
