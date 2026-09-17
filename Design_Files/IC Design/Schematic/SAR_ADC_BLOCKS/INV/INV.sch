v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 110 -50 110 10 {lab=out}
N 70 -80 70 40 {lab=in}
N 110 -150 110 -110 {lab=vdd}
N 110 70 110 110 {lab=0}
N 40 -20 70 -20 {lab=in}
N 110 -20 140 -20 {lab=out}
N -120 -130 -70 -130 {lab=in}
N -120 -100 -70 -100 {lab=VDD}
N -120 -70 -70 -70 {lab=out}
N 110 -110 110 -80 {lab=vdd}
N 110 40 110 80 {lab=0}
C {symbols/nfet_03v3.sym} 90 40 0 0 {name=M1
L=0.28u
W=0.22u
nf=1
m=wn_inv
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 90 -80 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=wp_inv
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {gnd.sym} 110 110 0 0 {name=l1 lab=0}
C {lab_pin.sym} 40 -20 0 0 {name=p1 sig_type=std_logic lab=in}
C {lab_pin.sym} 140 -20 0 1 {name=p2 sig_type=std_logic lab=out}
C {lab_pin.sym} 110 -150 3 1 {name=p3 sig_type=std_logic lab=vdd}
C {ipin.sym} -120 -130 0 0 {name=p4 lab=in}
C {lab_pin.sym} -70 -130 0 1 {name=p5 sig_type=std_logic lab=in}
C {ipin.sym} -120 -100 0 0 {name=p8 lab=VDD}
C {lab_pin.sym} -70 -100 0 1 {name=p9 sig_type=std_logic lab=VDD}
C {opin.sym} -70 -70 0 0 {name=p10 lab=out}
C {lab_pin.sym} -120 -70 0 0 {name=p11 sig_type=std_logic lab=out}
