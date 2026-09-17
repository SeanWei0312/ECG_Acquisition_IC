v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -290 0 -290 10 {lab=out+}
N -240 0 -120 0 {lab=out+}
N -120 0 -120 10 {lab=out+}
N -290 0 -240 0 {lab=out+}
N -120 -10 -120 0 {lab=out+}
N 0 -10 0 10 {lab=out-}
N -120 -30 -120 -10 {lab=out+}
N -0 -30 0 -10 {lab=out-}
N -80 -60 -70 -60 {lab=out-}
N -70 -60 -70 40 {lab=out-}
N -80 40 -70 40 {lab=out-}
N -50 -60 -40 -60 {lab=out+}
N -50 -60 -50 40 {lab=out+}
N -50 40 -40 40 {lab=out+}
N -70 -20 -0 -20 {lab=out-}
N -120 -10 -50 -10 {lab=out+}
N 170 0 170 10 {lab=out-}
N 0 -0 170 -0 {lab=out-}
N -0 -110 0 -90 {lab=VDD}
N -120 -110 -120 -90 {lab=VDD}
N 170 70 170 120 {lab=0}
N -0 70 -0 120 {lab=0}
N -120 70 -120 120 {lab=0}
N -290 70 -290 120 {lab=0}
N 0 40 50 40 {lab=0}
N 140 40 170 40 {lab=0}
N 140 40 140 120 {lab=0}
N 50 40 50 120 {lab=0}
N -120 40 -120 70 {lab=0}
N -290 40 -290 70 {lab=0}
N -290 120 170 120 {lab=0}
N -120 -110 -0 -110 {lab=VDD}
N -460 -10 -460 90 {lab=in+}
N -480 40 -460 40 {lab=in+}
N -420 20 -420 60 {lab=#net1}
N -420 -40 -420 -10 {lab=VDD}
N -420 -100 -420 -40 {lab=VDD}
N -420 -110 -420 -100 {lab=VDD}
N -420 -110 -120 -110 {lab=VDD}
N -420 40 -330 40 {lab=#net1}
N -420 90 -420 120 {lab=0}
N -420 120 -290 120 {lab=0}
N 330 -20 330 80 {lab=in-}
N 330 30 350 30 {lab=in-}
N 290 10 290 50 {lab=#net2}
N 210 40 290 40 {lab=#net2}
N 290 80 290 110 {lab=0}
N 290 110 290 120 {lab=0}
N 170 120 290 120 {lab=0}
N 290 -50 290 -20 {lab=VDD}
N 290 -110 290 -50 {lab=VDD}
N 0 -110 290 -110 {lab=VDD}
N -140 -60 -120 -60 {lab=VDD}
N -140 -110 -140 -60 {lab=VDD}
N -0 -60 20 -60 {lab=VDD}
N 20 -110 20 -60 {lab=VDD}
C {symbols/pfet_03v3.sym} -20 -60 0 0 {name=M4
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
C {symbols/nfet_03v3.sym} -20 40 0 0 {name=M8
L=0.28u
W=0.3u
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
C {symbols/nfet_03v3.sym} -310 40 0 0 {name=M9
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
C {ipin.sym} -60 -110 0 0 {name=p1 lab=VDD}
C {gnd.sym} -80 120 0 0 {name=l1 lab=0}
C {ipin.sym} -480 40 0 0 {name=p12 lab=in+}
C {ipin.sym} 350 30 2 0 {name=p13 lab=in-}
C {opin.sym} -120 -20 2 0 {name=p14 lab=out+}
C {opin.sym} 0 -10 0 0 {name=p15 lab=out-}
C {symbols/nfet_03v3.sym} -100 40 0 1 {name=M5
L=0.28u
W=0.3u
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
C {symbols/nfet_03v3.sym} 190 40 0 1 {name=M7
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
C {symbols/pfet_03v3.sym} -100 -60 0 1 {name=M1
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
C {symbols/pfet_03v3.sym} -440 -10 0 0 {name=M2
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
C {symbols/nfet_03v3.sym} -440 90 0 0 {name=M3
L=0.28u
W=0.3u
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
C {symbols/nfet_03v3.sym} 310 80 0 1 {name=M6
L=0.28u
W=0.3u
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
C {symbols/pfet_03v3.sym} 310 -20 0 1 {name=M10
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
