v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -400 20 -390 20 {lab=A}
N -400 20 -400 110 {lab=A}
N -400 110 -390 110 {lab=A}
N -350 50 -350 80 {lab=Abar}
N -350 50 -350 60 {lab=Abar}
N -350 60 -320 60 {lab=Abar}
N -240 20 -230 20 {lab=B}
N -240 20 -240 110 {lab=B}
N -240 110 -230 110 {lab=B}
N -190 50 -190 80 {lab=Bbar}
N -190 50 -190 60 {lab=Bbar}
N -190 60 -160 60 {lab=Bbar}
N 40 -10 40 30 {lab=AxorB}
N 40 -100 40 -70 {lab=#net1}
N -30 -130 0 -130 {lab=Abar}
N -30 -40 0 -40 {lab=B}
N -30 60 0 60 {lab=A}
N -30 150 0 150 {lab=B}
N 40 -180 40 -160 {lab=VDD}
N 40 -180 210 -180 {lab=VDD}
N 210 -180 210 -160 {lab=VDD}
N 140 -130 170 -130 {lab=A}
N 140 -40 170 -40 {lab=Bbar}
N 210 -100 210 -70 {lab=#net2}
N 210 -10 210 30 {lab=AxorB}
N 40 10 210 10 {lab=AxorB}
N 40 90 40 120 {lab=#net3}
N 210 90 210 120 {lab=#net4}
N 40 180 40 200 {lab=0}
N 40 200 210 200 {lab=0}
N 210 180 210 200 {lab=0}
N 140 60 170 60 {lab=Abar}
N 140 150 170 150 {lab=Bbar}
N 40 -130 60 -130 {lab=VDD}
N 40 -40 60 -40 {lab=VDD}
N 210 -130 230 -130 {lab=VDD}
N 210 -40 230 -40 {lab=VDD}
N 210 60 240 60 {lab=0}
N 210 150 240 150 {lab=0}
N 40 60 70 60 {lab=0}
N 40 150 60 150 {lab=0}
N -190 140 -190 200 {lab=0}
N -190 200 40 200 {lab=0}
N -350 140 -350 200 {lab=0}
N -350 200 -190 200 {lab=0}
N -350 -180 -350 -10 {lab=VDD}
N -350 -180 40 -180 {lab=VDD}
N -190 -180 -190 -10 {lab=VDD}
N 210 10 240 10 {lab=AxorB}
N -350 20 -320 20 {lab=VDD}
N -350 110 -320 110 {lab=0}
N -190 20 -160 20 {lab=VDD}
N -190 110 -160 110 {lab=0}
N 70 60 70 200 {lab=0}
N 240 150 240 200 {lab=0}
N 210 200 240 200 {lab=0}
N 240 60 240 150 {lab=0}
N 60 150 70 150 {lab=0}
N -320 110 -320 200 {lab=0}
N -160 110 -160 200 {lab=0}
C {symbols/nfet_03v3.sym} -370 110 0 0 {name=M1
L=0.28u
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
C {symbols/pfet_03v3.sym} -370 20 0 0 {name=M2
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
model=pfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} -210 110 0 0 {name=M3
L=0.28u
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
C {symbols/pfet_03v3.sym} -210 20 0 0 {name=M4
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
model=pfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 20 -130 0 0 {name=M5
L=0.28u
W=1.6u
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
C {symbols/pfet_03v3.sym} 20 -40 0 0 {name=M6
L=0.28u
W=1.6u
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
C {symbols/pfet_03v3.sym} 190 -130 0 0 {name=M7
L=0.28u
W=1.6u
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
C {symbols/pfet_03v3.sym} 190 -40 0 0 {name=M8
L=0.28u
W=1.6u
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
C {symbols/nfet_03v3.sym} 20 60 0 0 {name=M9
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
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 190 60 0 0 {name=M10
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
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 20 150 0 0 {name=M11
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
model=nfet_03v3
spiceprefix=X
}
C {symbols/nfet_03v3.sym} 190 150 0 0 {name=M12
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
model=nfet_03v3
spiceprefix=X
}
C {ipin.sym} 110 -180 1 0 {name=p3 lab=VDD}
C {gnd.sym} 120 200 0 0 {name=l1 lab=0}
C {ipin.sym} -400 60 0 0 {name=p4 lab=A}
C {ipin.sym} -240 90 0 0 {name=p5 lab=B}
C {opin.sym} 240 10 0 0 {name=p6 lab=AxorB}
C {lab_pin.sym} -30 -130 0 0 {name=p7 sig_type=std_logic lab=Abar}
C {lab_pin.sym} -30 -40 0 0 {name=p8 sig_type=std_logic lab=B}
C {lab_pin.sym} -30 60 0 0 {name=p9 sig_type=std_logic lab=A}
C {lab_pin.sym} -30 150 0 0 {name=p10 sig_type=std_logic lab=B}
C {lab_pin.sym} 140 -130 0 0 {name=p11 sig_type=std_logic lab=A}
C {lab_pin.sym} 160 -40 0 0 {name=p12 sig_type=std_logic lab=Bbar}
C {lab_pin.sym} 140 60 0 0 {name=p13 sig_type=std_logic lab=Abar}
C {lab_pin.sym} 140 150 0 0 {name=p14 sig_type=std_logic lab=Bbar}
C {lab_pin.sym} 60 -130 2 0 {name=p15 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 60 -40 2 0 {name=p16 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 230 -130 2 0 {name=p19 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 230 -40 2 0 {name=p20 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -320 60 2 0 {name=p1 sig_type=std_logic lab=Abar}
C {lab_pin.sym} -160 60 2 0 {name=p2 sig_type=std_logic lab=Bbar}
C {lab_pin.sym} -320 20 2 0 {name=p24 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -160 20 2 0 {name=p25 sig_type=std_logic lab=VDD}
