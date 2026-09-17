v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 150 -40 150 20 {lab=out}
N 110 -70 110 50 {lab=in}
N 150 -140 150 -100 {lab=vdd}
N 150 80 150 120 {lab=0}
N 80 -10 110 -10 {lab=in}
N 150 -10 180 -10 {lab=out}
N -80 -120 -30 -120 {lab=in}
N -80 -90 -30 -90 {lab=VDD}
N -80 -60 -30 -60 {lab=out}
N 150 -100 150 -70 {lab=vdd}
N 150 50 150 90 {lab=0}
C {symbols/nfet_03v3.sym} 130 50 0 0 {name=M1
L=0.28u
W=0.22u
nf=1
m=wn_inv2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 130 -70 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=wp_inv2
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {gnd.sym} 150 120 0 0 {name=l1 lab=0}
C {lab_pin.sym} 80 -10 0 0 {name=p1 sig_type=std_logic lab=in}
C {lab_pin.sym} 180 -10 0 1 {name=p2 sig_type=std_logic lab=out}
C {lab_pin.sym} 150 -140 3 1 {name=p3 sig_type=std_logic lab=vdd}
C {ipin.sym} -80 -120 0 0 {name=p4 lab=in}
C {lab_pin.sym} -30 -120 0 1 {name=p5 sig_type=std_logic lab=in}
C {ipin.sym} -80 -90 0 0 {name=p8 lab=VDD}
C {lab_pin.sym} -30 -90 0 1 {name=p9 sig_type=std_logic lab=VDD}
C {opin.sym} -30 -60 0 0 {name=p10 lab=out}
C {lab_pin.sym} -80 -60 0 0 {name=p11 sig_type=std_logic lab=out}
