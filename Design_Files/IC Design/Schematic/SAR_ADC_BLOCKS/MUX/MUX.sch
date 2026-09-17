v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 120 -60 120 60 {lab=#net1}
N 120 -120 120 -90 {lab=VDD}
N 120 90 120 120 {lab=0}
N 40 -90 80 -90 {lab=Select}
N 40 90 80 90 {lab=Select}
N 40 -90 40 90 {lab=Select}
N -10 0 40 -0 {lab=Select}
N 300 -160 350 -160 {lab=in1}
N 300 -300 350 -300 {lab=in1}
N 300 -300 300 -160 {lab=in1}
N 410 -300 460 -300 {lab=OUT}
N 460 -300 460 -160 {lab=OUT}
N 410 -160 460 -160 {lab=OUT}
N 200 -230 300 -230 {lab=in1}
N 460 -230 580 -230 {lab=OUT}
N 380 -400 380 -340 {lab=Select}
N 380 -120 380 -60 {lab=#net1}
N 300 300 350 300 {lab=in0}
N 300 160 350 160 {lab=in0}
N 300 160 300 300 {lab=in0}
N 410 160 460 160 {lab=OUT}
N 460 160 460 300 {lab=OUT}
N 410 300 460 300 {lab=OUT}
N 200 230 300 230 {lab=in0}
N 460 230 580 230 {lab=OUT}
N 380 60 380 120 {lab=#net1}
N 380 340 380 400 {lab=Select}
N 380 -60 380 60 {lab=#net1}
N 120 -0 380 0 {lab=#net1}
N 580 -230 580 230 {lab=OUT}
N 580 0 690 0 {lab=OUT}
N -320 -400 380 -400 {lab=Select}
N -10 -400 -10 -0 {lab=Select}
N -10 -0 -10 400 {lab=Select}
N -10 400 380 400 {lab=Select}
N 120 -170 120 -120 {lab=VDD}
N 120 120 120 160 {lab=0}
N 380 160 380 200 {lab=0}
N 380 260 380 300 {lab=VDD}
N 380 -300 380 -260 {lab=0}
N 380 -200 380 -160 {lab=VDD}
N -320 -300 -200 -300 {lab=VDD}
C {symbols/nfet_03v3.sym} 100 90 0 0 {name=M1
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
C {symbols/pfet_03v3.sym} 100 -90 0 0 {name=M2
L=0.28u
W=0.748u
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
C {symbols/nfet_03v3.sym} 380 -320 1 0 {name=M3
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
C {symbols/pfet_03v3.sym} 380 -140 3 0 {name=M4
L=0.28u
W=0.748u
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
C {symbols/nfet_03v3.sym} 380 140 1 0 {name=M5
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
C {symbols/pfet_03v3.sym} 380 320 3 0 {name=M6
L=0.28u
W=0.748u
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
C {ipin.sym} -320 -400 0 0 {name=p1 lab=Select}
C {opin.sym} 690 0 0 0 {name=p2 lab=OUT}
C {ipin.sym} 200 -230 0 0 {name=p3 lab=in1}
C {ipin.sym} 200 230 0 0 {name=p4 lab=in0}
C {lab_pin.sym} 380 260 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 380 -200 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 120 -170 0 0 {name=p9 sig_type=std_logic lab=VDD}
C {gnd.sym} 120 160 0 0 {name=l1 lab=0}
C {gnd.sym} 380 200 0 0 {name=l2 lab=0}
C {gnd.sym} 380 -260 0 0 {name=l3 lab=0}
C {lab_pin.sym} 150 -400 0 0 {name=p6 sig_type=std_logic lab=Select}
C {lab_pin.sym} 260 -230 0 0 {name=p7 sig_type=std_logic lab=in1}
C {lab_pin.sym} 260 230 0 0 {name=p10 sig_type=std_logic lab=in0}
C {lab_pin.sym} 660 0 0 0 {name=p11 sig_type=std_logic lab=OUT}
C {ipin.sym} -320 -300 0 0 {name=p12 lab=VDD
}
C {lab_pin.sym} -200 -300 0 0 {name=p13 sig_type=std_logic lab=VDD}
