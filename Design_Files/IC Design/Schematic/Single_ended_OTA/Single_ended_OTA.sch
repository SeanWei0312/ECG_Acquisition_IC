v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 860 -540 980 -540 {lab=#net1}
N 1040 -540 1080 -540 {lab=#net2}
N 980 -460 1100 -460 {lab=#net1}
N 1080 -780 1100 -780 {lab=VB}
N 680 -780 700 -780 {lab=VB}
N 540 -780 680 -780 {lab=VB}
N 860 -660 860 -650 {lab=#net3}
N 620 -700 860 -700 {lab=#net3}
N 620 -660 620 -650 {lab=#net3}
N 500 -860 1140 -860 {lab=DD}
N 620 -700 620 -660 {lab=#net3}
N 860 -700 860 -660 {lab=#net3}
N 740 -750 740 -700 {lab=#net3}
N 980 -540 980 -460 {lab=#net1}
N 1140 -540 1140 -490 {lab=OUT}
N 1140 -750 1140 -540 {lab=OUT}
N 620 -590 620 -490 {lab=#net4}
N 860 -590 860 -540 {lab=#net1}
N 860 -540 860 -490 {lab=#net1}
N 620 -430 620 -380 {lab=SS}
N 1140 -430 1140 -380 {lab=SS}
N 860 -430 860 -380 {lab=SS}
N 860 -380 1140 -380 {lab=SS}
N 620 -380 860 -380 {lab=SS}
N 900 -620 920 -620 {lab=INP}
N 560 -620 580 -620 {lab=INN}
N 660 -460 820 -460 {lab=#net4}
N 740 -540 740 -460 {lab=#net4}
N 620 -540 740 -540 {lab=#net4}
N 500 -720 560 -720 {lab=VB}
N 560 -780 560 -720 {lab=VB}
N 500 -750 500 -720 {lab=VB}
N 500 -720 500 -700 {lab=VB}
N 500 -860 500 -810 {lab=DD}
N 740 -860 740 -810 {lab=DD}
N 1140 -860 1140 -810 {lab=DD}
N 1140 -620 1160 -620 {lab=OUT}
N 360 -860 380 -860 {lab=DD}
N 360 -820 380 -820 {lab=SS}
N 360 -780 380 -780 {lab=INP}
N 360 -740 380 -740 {lab=INN}
N 360 -700 380 -700 {lab=OUT}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {symbols/nfet_03v3.sym} 840 -460 0 0 {name=M4
L=0.28u
W=0.22u
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
C {symbols/nfet_03v3.sym} 640 -460 0 1 {name=M3
L=0.28u
W=0.22u
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
C {symbols/pfet_03v3.sym} 600 -620 0 0 {name=M1
L=1u
W=2u
nf=31
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
C {symbols/pfet_03v3.sym} 880 -620 0 1 {name=M2
L=1u
W=2u
nf=31
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
C {symbols/pfet_03v3.sym} 1120 -780 0 0 {name=M7
L=0.28u
W=0.22u
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
C {res.sym} 1010 -540 3 0 {name=Rz
value=0.5k
footprint=1206
device=resistor
m=1}
C {symbols/pfet_03v3.sym} 720 -780 0 0 {name=M5
L=0.28u
W=0.22u
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
C {symbols/nfet_03v3.sym} 1120 -460 0 0 {name=M6
L=0.28u
W=0.22u
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
C {symbols/pfet_03v3.sym} 520 -780 0 1 {name=M8
L=1u
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
C {capa.sym} 1110 -540 3 0 {name=Cc
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 740 -860 0 0 {name=p1 sig_type=std_logic lab=DD}
C {lab_wire.sym} 740 -380 0 0 {name=p2 sig_type=std_logic lab=SS}
C {lab_wire.sym} 1160 -620 0 1 {name=p3 sig_type=std_logic lab=OUT
}
C {lab_wire.sym} 1080 -780 0 0 {name=p4 sig_type=std_logic lab=VB
}
C {lab_wire.sym} 620 -780 0 0 {name=p5 sig_type=std_logic lab=VB
}
C {lab_wire.sym} 920 -620 0 1 {name=p6 sig_type=std_logic lab=INP
}
C {lab_wire.sym} 560 -620 0 0 {name=p7 sig_type=std_logic lab=INN
}
C {iopin.sym} 360 -860 0 1 {name=p8 lab=DD}
C {iopin.sym} 360 -820 0 1 {name=p9 lab=SS}
C {lab_wire.sym} 740 -860 0 0 {name=p10 sig_type=std_logic lab=DD}
C {lab_wire.sym} 380 -860 0 1 {name=p11 sig_type=std_logic lab=DD}
C {lab_wire.sym} 380 -820 0 1 {name=p12 sig_type=std_logic lab=SS}
C {ipin.sym} 360 -780 0 0 {name=p13 lab=INP}
C {ipin.sym} 360 -740 0 0 {name=p14 lab=INN}
C {lab_wire.sym} 380 -780 0 1 {name=p15 sig_type=std_logic lab=INP}
C {lab_wire.sym} 380 -740 0 1 {name=p16 sig_type=std_logic lab=INN}
C {opin.sym} 360 -700 0 1 {name=p17 lab=OUT}
C {lab_wire.sym} 380 -700 0 1 {name=p18 sig_type=std_logic lab=OUT}
