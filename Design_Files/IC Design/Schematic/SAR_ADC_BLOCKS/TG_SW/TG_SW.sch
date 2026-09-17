v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 70 -70 100 -70 {lab=in}
N 70 -70 70 70 {lab=in}
N 70 70 100 70 {lab=in}
N 160 -70 190 -70 {lab=out}
N 190 -70 190 70 {lab=out}
N 160 70 190 70 {lab=out}
N 190 0 240 0 {lab=out}
N 20 0 70 0 {lab=in}
N 130 -160 130 -110 {lab=clk}
N 130 110 130 160 {lab=clkb}
N 130 -70 130 -30 {lab=0}
N 130 30 130 70 {lab=VDD}
C {ipin.sym} 20 0 0 0 {name=p1 lab=in}
C {ipin.sym} 130 -160 0 0 {name=p2 lab=clk
}
C {ipin.sym} 130 160 0 0 {name=p3 lab=clkb}
C {opin.sym} 240 0 0 0 {name=p4 lab=out}
C {gnd.sym} 130 -30 0 0 {name=l1 lab=0}
C {ipin.sym} 130 30 0 0 {name=p5 lab=VDD}
C {symbols/nfet_03v3.sym} 130 -90 1 0 {name=M1
L=0.28u
W=0.28u
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
C {symbols/pfet_03v3.sym} 130 90 3 0 {name=M2
L=0.28u
W=0.28u
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
