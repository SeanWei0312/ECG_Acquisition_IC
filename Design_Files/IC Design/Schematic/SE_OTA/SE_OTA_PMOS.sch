v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 800 -280 920 -280 {lab=#net1}
N 980 -280 1020 -280 {lab=#net2}
N 920 -200 1040 -200 {lab=#net1}
N 1020 -520 1040 -520 {lab=SEOTA_B}
N 620 -520 640 -520 {lab=SEOTA_B}
N 800 -400 800 -390 {lab=#net3}
N 560 -440 800 -440 {lab=#net3}
N 560 -400 560 -390 {lab=#net3}
N 560 -440 560 -400 {lab=#net3}
N 800 -440 800 -400 {lab=#net3}
N 680 -490 680 -440 {lab=#net3}
N 920 -280 920 -200 {lab=#net1}
N 1080 -280 1080 -230 {lab=SEOTA_OUT}
N 1080 -490 1080 -280 {lab=SEOTA_OUT}
N 560 -330 560 -230 {lab=#net4}
N 800 -330 800 -280 {lab=#net1}
N 800 -280 800 -230 {lab=#net1}
N 560 -170 560 -120 {lab=SEOTA_SS}
N 1080 -170 1080 -120 {lab=SEOTA_SS}
N 800 -170 800 -120 {lab=SEOTA_SS}
N 800 -120 1080 -120 {lab=SEOTA_SS}
N 560 -120 800 -120 {lab=SEOTA_SS}
N 840 -360 860 -360 {lab=SEOTA_INP}
N 500 -360 520 -360 {lab=SEOTA_INN}
N 600 -200 760 -200 {lab=#net4}
N 680 -280 680 -200 {lab=#net4}
N 560 -280 680 -280 {lab=#net4}
N 360 -460 420 -460 {lab=SEOTA_B}
N 420 -520 420 -460 {lab=SEOTA_B}
N 360 -490 360 -460 {lab=SEOTA_B}
N 360 -460 360 -440 {lab=SEOTA_B}
N 360 -600 360 -550 {lab=SEOTA_DD}
N 680 -600 680 -550 {lab=SEOTA_DD}
N 1080 -600 1080 -550 {lab=SEOTA_DD}
N 1080 -360 1100 -360 {lab=SEOTA_OUT}
N 140 -600 160 -600 {lab=SEOTA_DD}
N 140 -560 160 -560 {lab=SEOTA_SS}
N 140 -520 160 -520 {lab=SEOTA_INP}
N 140 -480 160 -480 {lab=SEOTA_INN}
N 140 -440 160 -440 {lab=SEOTA_OUT}
N 340 -520 360 -520 {lab=SEOTA_DD}
N 340 -560 340 -520 {lab=SEOTA_DD}
N 340 -560 360 -560 {lab=SEOTA_DD}
N 680 -520 700 -520 {lab=SEOTA_DD}
N 700 -560 700 -520 {lab=SEOTA_DD}
N 680 -560 700 -560 {lab=SEOTA_DD}
N 1080 -520 1100 -520 {lab=SEOTA_DD}
N 1100 -560 1100 -520 {lab=SEOTA_DD}
N 1080 -560 1100 -560 {lab=SEOTA_DD}
N 1080 -200 1100 -200 {lab=SEOTA_SS}
N 1100 -200 1100 -160 {lab=SEOTA_SS}
N 1080 -160 1100 -160 {lab=SEOTA_SS}
N 800 -200 820 -200 {lab=SEOTA_SS}
N 820 -200 820 -160 {lab=SEOTA_SS}
N 800 -160 820 -160 {lab=SEOTA_SS}
N 540 -200 560 -200 {lab=SEOTA_SS}
N 540 -200 540 -160 {lab=SEOTA_SS}
N 540 -160 560 -160 {lab=SEOTA_SS}
N 560 -360 580 -360 {lab=SEOTA_DD}
N 580 -600 580 -360 {lab=SEOTA_DD}
N 780 -360 800 -360 {lab=SEOTA_DD}
N 780 -600 780 -360 {lab=SEOTA_DD}
N 140 -400 160 -400 {lab=SEOTA_B}
N 400 -520 420 -520 {lab=SEOTA_B}
N 360 -600 1080 -600 {lab=SEOTA_DD}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {symbols/nfet_03v3.sym} 780 -200 0 0 {name=M4
L=2u
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
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 580 -200 0 1 {name=M3
L=2u
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
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 540 -360 0 0 {name=M1
L=2u
W=1u
nf=1
m=400
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 820 -360 0 1 {name=M2
L=2u
W=1u
nf=1
m=400
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1060 -520 0 0 {name=M7
L=0.5u
W=1u
nf=1
m=40
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {res.sym} 950 -280 3 0 {name=Rz
value=0.0001k
footprint=1206
device=resistor
m=1}
C {symbols/pfet_03v3.sym} 660 -520 0 0 {name=M5
L=2u
W=1u
nf=1
m=10
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 380 -520 0 1 {name=M8
L=2u
W=1u
nf=1
m=160
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {capa.sym} 1050 -280 3 0 {name=Cc
m=1
value=2.5p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 680 -120 0 0 {name=p2 sig_type=std_logic lab=SEOTA_SS}
C {lab_wire.sym} 1100 -360 0 1 {name=p3 sig_type=std_logic lab=SEOTA_OUT
}
C {lab_wire.sym} 1020 -520 0 0 {name=p4 sig_type=std_logic lab=SEOTA_B
}
C {lab_wire.sym} 420 -520 0 1 {name=p5 sig_type=std_logic lab=SEOTA_B
}
C {lab_wire.sym} 860 -360 0 1 {name=p6 sig_type=std_logic lab=SEOTA_INP
}
C {lab_wire.sym} 500 -360 0 0 {name=p7 sig_type=std_logic lab=SEOTA_INN
}
C {iopin.sym} 140 -600 0 1 {name=p8 lab=SEOTA_DD}
C {iopin.sym} 140 -560 0 1 {name=p9 lab=SEOTA_SS}
C {lab_wire.sym} 680 -600 0 0 {name=p10 sig_type=std_logic lab=SEOTA_DD}
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
C {lab_wire.sym} 620 -520 0 0 {name=p20 sig_type=std_logic lab=SEOTA_B
}
C {symbols/nfet_03v3.sym} 1060 -200 0 0 {name=M6
L=0.5u
W=1u
nf=1
m=400
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
