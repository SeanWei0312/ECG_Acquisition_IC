v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 700 -280 820 -280 {lab=#net1}
N 880 -280 920 -280 {lab=#net2}
N 820 -200 940 -200 {lab=#net1}
N 920 -520 940 -520 {lab=SEOTA_B}
N 520 -520 540 -520 {lab=SEOTA_B}
N 380 -520 520 -520 {lab=SEOTA_B}
N 700 -400 700 -390 {lab=#net3}
N 460 -440 700 -440 {lab=#net3}
N 460 -400 460 -390 {lab=#net3}
N 340 -600 980 -600 {lab=SEOTA_DD}
N 460 -440 460 -400 {lab=#net3}
N 700 -440 700 -400 {lab=#net3}
N 580 -490 580 -440 {lab=#net3}
N 820 -280 820 -200 {lab=#net1}
N 980 -280 980 -230 {lab=SEOTA_OUT}
N 980 -490 980 -280 {lab=SEOTA_OUT}
N 460 -330 460 -230 {lab=#net4}
N 700 -330 700 -280 {lab=#net1}
N 700 -280 700 -230 {lab=#net1}
N 460 -170 460 -120 {lab=SEOTA_SS}
N 980 -170 980 -120 {lab=SEOTA_SS}
N 700 -170 700 -120 {lab=SEOTA_SS}
N 700 -120 980 -120 {lab=SEOTA_SS}
N 460 -120 700 -120 {lab=SEOTA_SS}
N 740 -360 760 -360 {lab=SEOTA_INP}
N 400 -360 420 -360 {lab=SEOTA_INN}
N 500 -200 660 -200 {lab=#net4}
N 580 -280 580 -200 {lab=#net4}
N 460 -280 580 -280 {lab=#net4}
N 340 -460 400 -460 {lab=SEOTA_B}
N 400 -520 400 -460 {lab=SEOTA_B}
N 340 -490 340 -460 {lab=SEOTA_B}
N 340 -460 340 -440 {lab=SEOTA_B}
N 340 -600 340 -550 {lab=SEOTA_DD}
N 580 -600 580 -550 {lab=SEOTA_DD}
N 980 -600 980 -550 {lab=SEOTA_DD}
N 980 -360 1000 -360 {lab=SEOTA_OUT}
N 140 -600 160 -600 {lab=SEOTA_DD}
N 140 -560 160 -560 {lab=SEOTA_SS}
N 140 -520 160 -520 {lab=SEOTA_INP}
N 140 -480 160 -480 {lab=SEOTA_INN}
N 140 -440 160 -440 {lab=SEOTA_OUT}
N 320 -520 340 -520 {lab=SEOTA_DD}
N 320 -560 320 -520 {lab=SEOTA_DD}
N 320 -560 340 -560 {lab=SEOTA_DD}
N 580 -520 600 -520 {lab=SEOTA_DD}
N 600 -560 600 -520 {lab=SEOTA_DD}
N 580 -560 600 -560 {lab=SEOTA_DD}
N 980 -520 1000 -520 {lab=SEOTA_DD}
N 1000 -560 1000 -520 {lab=SEOTA_DD}
N 980 -560 1000 -560 {lab=SEOTA_DD}
N 980 -200 1000 -200 {lab=SEOTA_SS}
N 1000 -200 1000 -160 {lab=SEOTA_SS}
N 980 -160 1000 -160 {lab=SEOTA_SS}
N 700 -200 720 -200 {lab=SEOTA_SS}
N 720 -200 720 -160 {lab=SEOTA_SS}
N 700 -160 720 -160 {lab=SEOTA_SS}
N 440 -200 460 -200 {lab=SEOTA_SS}
N 440 -200 440 -160 {lab=SEOTA_SS}
N 440 -160 460 -160 {lab=SEOTA_SS}
N 460 -360 480 -360 {lab=SEOTA_DD}
N 480 -600 480 -360 {lab=SEOTA_DD}
N 680 -360 700 -360 {lab=SEOTA_DD}
N 680 -600 680 -360 {lab=SEOTA_DD}
N 140 -400 160 -400 {lab=SEOTA_B}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {symbols/nfet_03v3.sym} 680 -200 0 0 {name=M4
L=2u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 480 -200 0 1 {name=M3
L=2u
W=2u
nf=1
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 440 -360 0 0 {name=M1
L=1u
W=32u
nf=16
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
C {symbols/pfet_03v3.sym} 720 -360 0 1 {name=M2
L=1u
W=32u
nf=16
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
C {symbols/pfet_03v3.sym} 960 -520 0 0 {name=M7
L=0.5u
W=56u
nf=28
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
C {res.sym} 850 -280 3 0 {name=Rz
value=0.5k
footprint=1206
device=resistor
m=1}
C {symbols/pfet_03v3.sym} 560 -520 0 0 {name=M5
L=2u
W=20u
nf=10
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
C {symbols/nfet_03v3.sym} 960 -200 0 0 {name=M6
L=0.5u
W=16u
nf=8
m=2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 360 -520 0 1 {name=M8
L=2u
W=50u
nf=25
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
C {capa.sym} 950 -280 3 0 {name=Cc
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 580 -120 0 0 {name=p2 sig_type=std_logic lab=SEOTA_SS}
C {lab_wire.sym} 1000 -360 0 1 {name=p3 sig_type=std_logic lab=SEOTA_OUT
}
C {lab_wire.sym} 920 -520 0 0 {name=p4 sig_type=std_logic lab=SEOTA_B
}
C {lab_wire.sym} 460 -520 0 0 {name=p5 sig_type=std_logic lab=SEOTA_B
}
C {lab_wire.sym} 760 -360 0 1 {name=p6 sig_type=std_logic lab=SEOTA_INP
}
C {lab_wire.sym} 400 -360 0 0 {name=p7 sig_type=std_logic lab=SEOTA_INN
}
C {iopin.sym} 140 -600 0 1 {name=p8 lab=SEOTA_DD}
C {iopin.sym} 140 -560 0 1 {name=p9 lab=SEOTA_SS}
C {lab_wire.sym} 580 -600 0 0 {name=p10 sig_type=std_logic lab=SEOTA_DD}
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
