v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 110 -90 120 -90 {lab=out+}
N 50 -50 70 -50 {lab=out-}
N 70 -60 70 -50 {lab=out-}
N -100 -60 -100 -50 {lab=out-}
N -100 -50 50 -50 {lab=out-}
N 190 -60 190 -50 {lab=out+}
N 190 -50 360 -50 {lab=out+}
N 360 -60 360 -50 {lab=out+}
N -100 -150 -100 -120 {lab=VDD}
N -100 -150 360 -150 {lab=VDD}
N 360 -150 360 -120 {lab=VDD}
N 190 -150 190 -120 {lab=VDD}
N 70 -150 70 -120 {lab=VDD}
N 140 300 140 310 {lab=0}
N 40 -50 40 -20 {lab=out-}
N 250 -50 250 -20 {lab=out+}
N 120 -90 120 10 {lab=out+}
N 80 10 120 10 {lab=out+}
N 120 -30 250 -30 {lab=out+}
N 150 -90 150 10 {lab=out-}
N 150 10 210 10 {lab=out-}
N 40 -40 150 -40 {lab=out-}
N 40 40 40 110 {lab=intp}
N 40 220 40 230 {lab=#net1}
N 250 220 250 230 {lab=#net1}
N 40 230 140 230 {lab=#net1}
N 140 230 250 230 {lab=#net1}
N 250 40 250 110 {lab=intn}
N 40 110 40 160 {lab=intp}
N 250 110 250 160 {lab=intn}
N 140 290 140 300 {lab=0}
N 190 -90 200 -90 {lab=VDD}
N 350 -90 360 -90 {lab=VDD}
N 60 -90 70 -90 {lab=VDD}
N -100 -90 -90 -90 {lab=VDD}
N 30 10 40 10 {lab=0}
N 40 190 50 190 {lab=0}
N 240 190 250 190 {lab=0}
N 250 10 260 10 {lab=0}
N 140 260 150 260 {lab=0}
N 40 90 100 90 {lab=intp}
N 160 90 250 90 {lab=intn}
N 130 30 130 50 {lab=clkc}
N 130 90 130 100 {lab=VDD}
C {symbols/nfet_03v3.sym} 20 190 0 0 {name=M1
L=0.28u
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
C {symbols/nfet_03v3.sym} 230 10 0 0 {name=M3
L=0.28u
W=1.2u
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
C {symbols/nfet_03v3.sym} 120 260 0 0 {name=M5
L=0.28u
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
C {symbols/pfet_03v3.sym} 170 -90 0 0 {name=M7
L=0.28u
W=1.5u
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
C {ipin.sym} 130 -150 1 0 {name=p1 lab=VDD}
C {gnd.sym} 140 310 0 0 {name=l1 lab=0}
C {opin.sym} 250 -40 0 0 {name=p2 lab=out+}
C {opin.sym} 40 -30 2 0 {name=p3 lab=out-}
C {ipin.sym} -140 -90 0 0 {name=p4 lab=clkc}
C {lab_pin.sym} 400 -90 2 0 {name=p5 sig_type=std_logic lab=clkc}
C {ipin.sym} 0 190 0 0 {name=p7 lab=in+}
C {ipin.sym} 290 190 2 0 {name=p8 lab=in-}
C {lab_pin.sym} 100 260 0 0 {name=p6 sig_type=std_logic lab=clkc}
C {gnd.sym} 50 190 3 0 {name=l2 lab=0}
C {gnd.sym} 240 190 1 0 {name=l3 lab=0}
C {gnd.sym} 30 10 1 0 {name=l4 lab=0}
C {gnd.sym} 260 10 3 0 {name=l5 lab=0}
C {symbols/pfet_03v3.sym} -120 -90 0 0 {name=M4
L=0.28u
W=0.8u
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
C {symbols/pfet_03v3.sym} 90 -90 0 1 {name=M6
L=0.28u
W=1.5u
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
C {symbols/pfet_03v3.sym} 380 -90 0 1 {name=M8
L=0.28u
W=0.8u
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
C {symbols/nfet_03v3.sym} 60 10 0 1 {name=M9
L=0.28u
W=1.2u
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
C {symbols/nfet_03v3.sym} 270 190 0 1 {name=M2
L=0.28u
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
C {lab_pin.sym} -90 -90 2 0 {name=p10 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 200 -90 2 0 {name=p11 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 60 -90 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 350 -90 0 0 {name=p13 sig_type=std_logic lab=VDD}
C {gnd.sym} 150 260 3 0 {name=l6 lab=0}
C {lab_pin.sym} 40 90 0 0 {name=p15 sig_type=std_logic lab=intp}
C {lab_pin.sym} 250 90 2 0 {name=p16 sig_type=std_logic lab=intn}
C {symbols/pfet_03v3.sym} 130 70 3 1 {name=M11
L=0.28u
W=0.6u
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
C {lab_pin.sym} 130 30 0 0 {name=p9 sig_type=std_logic lab=clkc}
C {lab_pin.sym} 130 100 3 0 {name=p14 sig_type=std_logic lab=VDD}
