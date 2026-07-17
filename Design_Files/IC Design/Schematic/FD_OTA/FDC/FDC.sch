v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1060 -440 1180 -440 {lab=#net1}
N 1240 -440 1280 -440 {lab=#net2}
N 1180 -520 1300 -520 {lab=#net1}
N 1280 -200 1300 -200 {lab=FDC_B}
N 880 -200 900 -200 {lab=FDC_B}
N 1060 -330 1060 -320 {lab=#net3}
N 820 -280 1060 -280 {lab=#net3}
N 820 -330 820 -320 {lab=#net3}
N 820 -320 820 -280 {lab=#net3}
N 1060 -320 1060 -280 {lab=#net3}
N 940 -280 940 -230 {lab=#net3}
N 1180 -520 1180 -440 {lab=#net1}
N 1340 -490 1340 -440 {lab=FDC_OUTP}
N 1340 -440 1340 -230 {lab=FDC_OUTP}
N 820 -490 820 -390 {lab=#net4}
N 1060 -440 1060 -390 {lab=#net1}
N 1060 -490 1060 -440 {lab=#net1}
N 820 -600 820 -550 {lab=FDC_DD}
N 1340 -600 1340 -550 {lab=FDC_DD}
N 1060 -600 1060 -550 {lab=FDC_DD}
N 1060 -600 1340 -600 {lab=FDC_DD}
N 820 -600 1060 -600 {lab=FDC_DD}
N 1100 -360 1120 -360 {lab=FDC_INP}
N 760 -360 780 -360 {lab=FDC_INN}
N 860 -520 1020 -520 {lab=FDC_CMFB}
N 300 -260 360 -260 {lab=FDC_B}
N 360 -260 360 -200 {lab=FDC_B}
N 300 -260 300 -230 {lab=FDC_B}
N 300 -280 300 -260 {lab=FDC_B}
N 300 -170 300 -120 {lab=FDC_SS}
N 940 -170 940 -120 {lab=FDC_SS}
N 1340 -170 1340 -120 {lab=FDC_SS}
N 1340 -360 1360 -360 {lab=FDC_OUTP}
N 140 -600 160 -600 {lab=FDC_DD}
N 140 -560 160 -560 {lab=FDC_SS}
N 140 -520 160 -520 {lab=FDC_INP}
N 140 -480 160 -480 {lab=FDC_INN}
N 140 -440 160 -440 {lab=FDC_OUTP}
N 280 -200 300 -200 {lab=FDC_SS}
N 280 -200 280 -160 {lab=FDC_SS}
N 280 -160 300 -160 {lab=FDC_SS}
N 940 -200 960 -200 {lab=FDC_SS}
N 960 -200 960 -160 {lab=FDC_SS}
N 940 -160 960 -160 {lab=FDC_SS}
N 1340 -200 1360 -200 {lab=FDC_SS}
N 1360 -200 1360 -160 {lab=FDC_SS}
N 1340 -160 1360 -160 {lab=FDC_SS}
N 1340 -520 1360 -520 {lab=FDC_DD}
N 1360 -560 1360 -520 {lab=FDC_DD}
N 1340 -560 1360 -560 {lab=FDC_DD}
N 1060 -520 1080 -520 {lab=FDC_DD}
N 1080 -560 1080 -520 {lab=FDC_DD}
N 1060 -560 1080 -560 {lab=FDC_DD}
N 800 -520 820 -520 {lab=FDC_DD}
N 800 -560 800 -520 {lab=FDC_DD}
N 800 -560 820 -560 {lab=FDC_DD}
N 820 -360 840 -360 {lab=FDC_SS}
N 840 -360 840 -120 {lab=FDC_SS}
N 1040 -360 1060 -360 {lab=FDC_SS}
N 1040 -360 1040 -120 {lab=FDC_SS}
N 140 -360 160 -360 {lab=FDC_B}
N 340 -200 360 -200 {lab=FDC_B}
N 700 -440 820 -440 {lab=#net4}
N 600 -440 640 -440 {lab=#net5}
N 580 -520 700 -520 {lab=#net4}
N 580 -200 600 -200 {lab=FDC_B}
N 700 -520 700 -440 {lab=#net4}
N 540 -490 540 -440 {lab=FDC_OUTN}
N 540 -440 540 -230 {lab=FDC_OUTN}
N 540 -600 540 -550 {lab=FDC_DD}
N 540 -600 820 -600 {lab=FDC_DD}
N 540 -170 540 -120 {lab=FDC_SS}
N 520 -360 540 -360 {lab=FDC_OUTN}
N 520 -200 540 -200 {lab=FDC_SS}
N 520 -200 520 -160 {lab=FDC_SS}
N 520 -160 540 -160 {lab=FDC_SS}
N 520 -520 540 -520 {lab=FDC_DD}
N 520 -560 520 -520 {lab=FDC_DD}
N 520 -560 540 -560 {lab=FDC_DD}
N 140 -400 160 -400 {lab=FDC_OUTN}
N 300 -120 1340 -120 {lab=FDC_SS}
N 940 -520 940 -500 {lab=FDC_CMFB}
N 140 -320 160 -320 {lab=FDC_CMFB}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {symbols/pfet_03v3.sym} 840 -520 0 1 {name=M3
L=2u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1320 -200 0 0 {name=M8
L=1u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {res.sym} 1210 -440 3 1 {name=Rz
value=6k
footprint=1206
device=resistor
m=1}
C {symbols/nfet_03v3.sym} 920 -200 0 0 {name=M5
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
model=nfet_03v3
spiceprefix=X}
C {symbols/pfet_03v3.sym} 1320 -520 0 0 {name=M6
L=1u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 320 -200 0 1 {name=M10
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
C {capa.sym} 1310 -440 3 1 {name=Cc
m=1
value=3p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 940 -600 2 1 {name=p2 sig_type=std_logic lab=FDC_DD}
C {lab_wire.sym} 1360 -360 2 0 {name=p3 sig_type=std_logic lab=FDC_OUTP}
C {lab_wire.sym} 1280 -200 2 1 {name=p4 sig_type=std_logic lab=FDC_B
}
C {lab_wire.sym} 360 -200 2 0 {name=p5 sig_type=std_logic lab=FDC_B
}
C {lab_wire.sym} 1120 -360 2 0 {name=p6 sig_type=std_logic lab=FDC_INP
}
C {lab_wire.sym} 760 -360 2 1 {name=p7 sig_type=std_logic lab=FDC_INN
}
C {iopin.sym} 140 -600 0 1 {name=p8 lab=FDC_DD}
C {iopin.sym} 140 -560 0 1 {name=p9 lab=FDC_SS}
C {lab_wire.sym} 940 -120 2 1 {name=p10 sig_type=std_logic lab=FDC_SS}
C {lab_wire.sym} 160 -600 0 1 {name=p11 sig_type=std_logic lab=FDC_DD}
C {lab_wire.sym} 160 -560 0 1 {name=p12 sig_type=std_logic lab=FDC_SS}
C {ipin.sym} 140 -520 0 0 {name=p13 lab=FDC_INP}
C {ipin.sym} 140 -480 0 0 {name=p14 lab=FDC_INN}
C {lab_wire.sym} 160 -520 0 1 {name=p15 sig_type=std_logic lab=FDC_INP}
C {lab_wire.sym} 160 -480 0 1 {name=p16 sig_type=std_logic lab=FDC_INN}
C {opin.sym} 140 -440 0 1 {name=p17 lab=FDC_OUTP}
C {lab_wire.sym} 160 -440 0 1 {name=p18 sig_type=std_logic lab=FDC_OUTP}
C {iopin.sym} 140 -360 0 1 {name=p1 lab=FDC_B}
C {lab_wire.sym} 160 -360 0 1 {name=p19 sig_type=std_logic lab=FDC_B}
C {symbols/nfet_03v3.sym} 560 -200 0 1 {name=M9
L=1u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X}
C {res.sym} 670 -440 1 0 {name=Rz1
value=6k
footprint=1206
device=resistor
m=1}
C {symbols/pfet_03v3.sym} 560 -520 0 1 {name=M7
L=1u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {capa.sym} 570 -440 1 0 {name=Cc1
m=1
value=3p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 520 -360 2 1 {name=p20 sig_type=std_logic lab=FDC_OUTN
}
C {lab_wire.sym} 600 -200 2 0 {name=p21 sig_type=std_logic lab=FDC_B
}
C {lab_wire.sym} 880 -200 2 1 {name=p22 sig_type=std_logic lab=FDC_B
}
C {opin.sym} 140 -400 0 1 {name=p23 lab=FDC_OUTN}
C {lab_wire.sym} 160 -400 0 1 {name=p24 sig_type=std_logic lab=FDC_OUTN}
C {lab_wire.sym} 940 -500 2 0 {name=p25 sig_type=std_logic lab=FDC_CMFB
}
C {lab_wire.sym} 160 -320 0 1 {name=p26 sig_type=std_logic lab=FDC_CMFB
}
C {iopin.sym} 140 -320 0 1 {name=p27 lab=FDC_CMFB}
C {symbols/pfet_03v3.sym} 1040 -520 0 0 {name=M4
L=2u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 800 -360 0 0 {name=M1
L=2u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 1080 -360 0 1 {name=M2
L=2u
W=1u
nf=1
m=200
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
