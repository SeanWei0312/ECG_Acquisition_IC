v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -520 160 -520 {lab=BIAS_DD}
N 140 -480 160 -480 {lab=BIAS_SS}
N 140 -440 160 -440 {lab=BIAS_BPEXT}
N 140 -400 160 -400 {lab=BIAS_VCMEXT}
N 140 -360 160 -360 {lab=BIAS_BP}
N 140 -320 160 -320 {lab=BIAS_VCM}
N 680 -310 680 -260 {lab=#net1}
N 680 -200 680 -160 {lab=BIAS_SS}
N 600 -390 600 -340 {lab=#net2}
N 520 -500 520 -420 {lab=BIAS_BPINT}
N 520 -420 560 -420 {lab=BIAS_BPINT}
N 480 -420 480 -340 {lab=#net2}
N 400 -420 480 -420 {lab=#net2}
N 440 -340 640 -340 {lab=#net2}
N 400 -310 400 -160 {lab=BIAS_SS}
N 600 -460 680 -460 {lab=BIAS_BPINT}
N 520 -500 600 -500 {lab=BIAS_BPINT}
N 600 -540 600 -450 {lab=BIAS_BPINT}
N 680 -510 680 -370 {lab=BIAS_BPINT}
N 440 -540 640 -540 {lab=BIAS_BPINT}
N 400 -510 400 -370 {lab=#net2}
N 680 -620 680 -570 {lab=BIAS_DD}
N 400 -620 400 -570 {lab=BIAS_DD}
N 600 -420 620 -420 {lab=BIAS_SS}
N 620 -420 620 -160 {lab=BIAS_SS}
N 680 -340 700 -340 {lab=BIAS_SS}
N 680 -540 700 -540 {lab=BIAS_DD}
N 700 -580 700 -540 {lab=BIAS_DD}
N 680 -580 700 -580 {lab=BIAS_DD}
N 380 -540 400 -540 {lab=BIAS_DD}
N 380 -580 380 -540 {lab=BIAS_DD}
N 380 -580 400 -580 {lab=BIAS_DD}
N 380 -340 400 -340 {lab=BIAS_SS}
N 380 -340 380 -300 {lab=BIAS_SS}
N 380 -300 400 -300 {lab=BIAS_SS}
N 800 -200 800 -160 {lab=BIAS_SS}
N 800 -620 800 -400 {lab=BIAS_DD}
N 800 -340 800 -260 {lab=BIAS_VCMINT}
N 800 -300 840 -300 {lab=BIAS_VCMINT}
N 840 -420 840 -300 {lab=BIAS_VCMINT}
N 1040 -380 1080 -380 {lab=BIAS_BPEXT}
N 1040 -340 1080 -340 {lab=BIAS_VCMEXT}
N 1280 -460 1320 -460 {lab=BIAS_BP}
N 1280 -340 1320 -340 {lab=BIAS_VCM}
N 1180 -280 1180 -160 {lab=BIAS_SS}
N 1140 -280 1140 -240 {lab=BIAS_DD}
N 920 -240 1140 -240 {lab=BIAS_DD}
N 920 -620 920 -240 {lab=BIAS_DD}
N 140 -280 160 -280 {lab=BIAS_SEL}
N 1220 -280 1220 -240 {lab=BIAS_SEL}
N 700 -340 700 -160 {lab=BIAS_SS}
N 400 -160 1180 -160 {lab=BIAS_SS}
N 840 -420 1080 -420 {lab=BIAS_VCMINT}
N 680 -460 1080 -460 {lab=BIAS_BPINT}
N 400 -620 920 -620 {lab=BIAS_DD}
N 880 -420 880 -260 {lab=BIAS_VCMINT}
N 880 -200 880 -160 {lab=BIAS_SS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -520 0 1 {name=p8 lab=BIAS_DD}
C {iopin.sym} 140 -480 0 1 {name=p9 lab=BIAS_SS}
C {lab_wire.sym} 160 -520 0 1 {name=p11 sig_type=std_logic lab=BIAS_DD}
C {lab_wire.sym} 160 -480 0 1 {name=p12 sig_type=std_logic lab=BIAS_SS}
C {ipin.sym} 140 -440 0 0 {name=p13 lab=BIAS_BPEXT}
C {ipin.sym} 140 -400 0 0 {name=p14 lab=BIAS_VCMEXT}
C {lab_wire.sym} 160 -440 0 1 {name=p15 sig_type=std_logic lab=BIAS_BPEXT}
C {lab_wire.sym} 160 -400 0 1 {name=p16 sig_type=std_logic lab=BIAS_VCMEXT}
C {opin.sym} 140 -360 0 1 {name=p17 lab=BIAS_BP}
C {lab_wire.sym} 160 -360 0 1 {name=p18 sig_type=std_logic lab=BIAS_BP}
C {opin.sym} 140 -320 0 1 {name=p23 lab=BIAS_VCM}
C {lab_wire.sym} 160 -320 0 1 {name=p24 sig_type=std_logic lab=BIAS_VCM}
C {symbols/nfet_03v3.sym} 660 -340 0 0 {name=MN2
L=4u
W=16u
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
C {symbols/pfet_03v3.sym} 660 -540 0 0 {name=MP2
L=4u
W=16u
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
C {symbols/nfet_03v3.sym} 420 -340 0 1 {name=MN1
L=4u
W=4u
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
C {symbols/pfet_03v3.sym} 420 -540 0 1 {name=MP1
L=4u
W=16u
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
C {res.sym} 680 -230 0 0 {name=RS
value=10k
footprint=1206
device=resistor
m=1}
C {symbols/nfet_03v3.sym} 580 -420 0 0 {name=MST
L=10u
W=0.5u
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
C {res.sym} 800 -370 0 0 {name=RP
value=500k
footprint=1206
device=resistor
m=1}
C {res.sym} 800 -230 0 0 {name=RN
value=500k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 600 -620 0 1 {name=p2 sig_type=std_logic lab=BIAS_DD}
C {lab_wire.sym} 600 -160 2 0 {name=p3 sig_type=std_logic lab=BIAS_SS}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SEL/SEL.sym} 1020 -240 0 0 {name=xSEL1}
C {lab_wire.sym} 1040 -380 0 0 {name=p4 sig_type=std_logic lab=BIAS_BPEXT}
C {lab_wire.sym} 1040 -340 0 0 {name=p5 sig_type=std_logic lab=BIAS_VCMEXT}
C {lab_wire.sym} 1040 -460 0 0 {name=p6 sig_type=std_logic lab=BIAS_BPINT}
C {lab_wire.sym} 1040 -420 0 0 {name=p7 sig_type=std_logic lab=BIAS_VCMINT}
C {lab_wire.sym} 1320 -460 0 1 {name=p10 sig_type=std_logic lab=BIAS_BP}
C {lab_wire.sym} 1320 -340 0 1 {name=p20 sig_type=std_logic lab=BIAS_VCM}
C {ipin.sym} 140 -280 0 0 {name=p1 lab=BIAS_SEL}
C {lab_wire.sym} 160 -280 0 1 {name=p19 sig_type=std_logic lab=BIAS_SEL}
C {lab_wire.sym} 1220 -240 2 0 {name=p21 sig_type=std_logic lab=BIAS_SEL}
C {capa.sym} 880 -230 0 0 {name=CN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
