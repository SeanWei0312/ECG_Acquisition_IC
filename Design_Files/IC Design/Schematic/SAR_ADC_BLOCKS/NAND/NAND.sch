v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -170 -100 -120 -100 {lab=A}
N -170 -60 -120 -60 {lab=B}
N -170 -20 -120 -20 {lab=VDD}
N -170 20 -120 20 {lab=OUT}
N 150 -60 330 -60 {lab=OUT}
N 240 -60 240 -40 {lab=OUT}
N 240 20 240 70 {lab=#net1}
N 330 -160 330 -120 {lab=VDD}
N 150 -160 330 -160 {lab=VDD}
N 240 -190 240 -160 {lab=VDD}
N 330 -120 330 -90 {lab=VDD}
N 150 -120 150 -90 {lab=VDD}
N 150 -160 150 -120 {lab=VDD}
N 60 -90 110 -90 {lab=A}
N 160 -10 200 -10 {lab=B}
N 250 -90 290 -90 {lab=B}
N 160 100 200 100 {lab=A}
N 240 100 240 130 {lab=0}
N 240 130 240 160 {lab=0}
N 240 -10 270 -10 {lab=0}
N 240 -50 360 -50 {lab=OUT}
C {ipin.sym} -170 -100 0 0 {name=p1 lab=A}
C {lab_pin.sym} -120 -100 0 1 {name=p2 sig_type=std_logic lab=A}
C {ipin.sym} -170 -60 0 0 {name=p3 lab=B}
C {lab_pin.sym} -120 -60 0 1 {name=p4 sig_type=std_logic lab=B}
C {ipin.sym} -170 -20 0 0 {name=p5 lab=VDD}
C {lab_pin.sym} -120 -20 0 1 {name=p6 sig_type=std_logic lab=VDD}
C {opin.sym} -120 20 0 0 {name=p7 lab=OUT}
C {lab_pin.sym} -170 20 0 0 {name=p8 sig_type=std_logic lab=OUT}
C {symbols/nfet_03v3.sym} 220 -10 0 0 {name=M1
L=0.28u
W=0.22u
nf=1
m=m_nand
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 220 100 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=m_nand
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 130 -90 0 0 {name=M3
L=0.28u
W=0.22u
nf=1
m=m_nand
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 310 -90 0 0 {name=M4
L=0.28u
W=0.22u
nf=1
m=m_nand
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 360 -50 0 1 {name=p9 sig_type=std_logic lab=OUT}
C {lab_pin.sym} 60 -90 0 0 {name=p10 sig_type=std_logic lab=A}
C {lab_pin.sym} 160 100 0 0 {name=p11 sig_type=std_logic lab=A}
C {lab_pin.sym} 160 -10 0 0 {name=p12 sig_type=std_logic lab=B}
C {lab_pin.sym} 250 -90 0 0 {name=p13 sig_type=std_logic lab=B}
C {lab_pin.sym} 240 -190 0 0 {name=p14 sig_type=std_logic lab=VDD}
C {gnd.sym} 240 160 0 0 {name=l1 lab=0}
C {gnd.sym} 270 -10 0 0 {name=l2 lab=0}
