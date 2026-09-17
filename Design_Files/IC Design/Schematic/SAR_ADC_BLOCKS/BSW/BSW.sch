v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 1400 0 1400 170 {lab=c_n}
N 1400 70 1560 70 {lab=c_n}
N 1800 -50 1800 120 {lab=c_p}
N 1620 70 1800 70 {lab=c_p}
N 1800 180 1800 310 {lab=#net1}
N 1800 250 2000 250 {lab=#net1}
N 2060 250 2130 250 {lab=#net2}
N 2190 250 2270 250 {lab=0}
N 2160 150 2160 210 {lab=clkb}
N 2030 150 2030 210 {lab=VDD}
N 1400 -130 1400 -60 {lab=0}
N 1310 -30 1360 -30 {lab=clkb}
N 1800 -170 1800 -110 {lab=VDD}
N 1400 230 1400 440 {lab=A}
N 1400 440 1770 440 {lab=A}
N 1830 440 2050 440 {lab=B}
N 1210 440 1400 440 {lab=A}
N 1800 570 1800 630 {lab=clkb}
N 1920 -80 1920 250 {lab=#net1}
N 1840 -80 1920 -80 {lab=#net1}
N 1730 -80 1800 -80 {lab=c_p}
N 1730 -80 1730 0 {lab=c_p}
N 1730 0 1800 0 {lab=c_p}
N 1800 350 1800 390 {lab=0}
N 1800 490 1800 530 {lab=VDD}
N 1350 -130 1350 -120 {lab=0}
N 1350 -130 1400 -130 {lab=0}
N 1330 200 1400 200 {lab=0}
N 2030 250 2030 300 {lab=0}
N 2160 250 2160 300 {lab=0}
N 1800 90 1840 90 {lab=c_p}
N 1840 90 1840 150 {lab=c_p}
N 1800 150 1840 150 {lab=c_p}
N 2270 250 2270 270 {lab=0}
N 1130 80 1190 80 {lab=clk}
N 1130 120 1190 120 {lab=clkb}
N 1130 160 1190 160 {lab=VDD}
N 1130 200 1190 200 {lab=A}
N 1130 250 1190 250 {lab=B}
N 1440 200 1500 200 {lab=clk}
N 1700 150 1760 150 {lab=clkb}
N 1400 -30 1460 -30 {lab=0}
N 1460 -30 1460 0 {lab=0}
N 1770 350 1770 440 {lab=A}
N 1830 350 1830 440 {lab=B}
N 1770 440 1770 530 {lab=A}
N 1830 440 1830 530 {lab=B}
N 1870 380 1900 380 {lab=B}
N 1870 380 1870 410 {lab=B}
N 1990 380 1990 410 {lab=B}
N 1960 380 1990 380 {lab=B}
N 1990 410 1990 440 {lab=B}
N 1870 410 1870 440 {lab=B}
N 1930 380 1930 410 {lab=0}
N 1930 300 1930 340 {lab=clkb}
C {capa-2.sym} 1590 70 1 0 {name=C2
m=1
value=50f
footprint=1206
device=polarized_capacitor}
C {lab_pin.sym} 1800 -170 0 0 {name=p21 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1210 440 0 0 {name=p22 sig_type=std_logic lab=A}
C {lab_pin.sym} 1800 630 0 0 {name=p23 sig_type=std_logic lab=clkb}
C {lab_pin.sym} 2030 150 0 0 {name=p24 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 2160 150 0 0 {name=p25 sig_type=std_logic lab=clkb}
C {gnd.sym} 1350 -120 0 0 {name=l8 lab=0}
C {gnd.sym} 1800 390 0 0 {name=l9 lab=0}
C {gnd.sym} 1330 200 0 0 {name=l10 lab=0}
C {gnd.sym} 2030 300 0 0 {name=l11 lab=0}
C {gnd.sym} 2160 300 0 0 {name=l12 lab=0}
C {lab_pin.sym} 2050 440 0 1 {name=p26 sig_type=std_logic lab=B}
C {lab_pin.sym} 1310 -30 0 0 {name=p27 sig_type=std_logic lab=clkb}
C {gnd.sym} 2270 270 0 0 {name=l13 lab=0}
C {ipin.sym} 1130 80 0 0 {name=p28 lab=clk}
C {lab_pin.sym} 1190 80 0 1 {name=p29 sig_type=std_logic lab=clk}
C {ipin.sym} 1130 120 0 0 {name=p30 lab=clkb}
C {lab_pin.sym} 1190 120 0 1 {name=p31 sig_type=std_logic lab=clkb}
C {ipin.sym} 1130 160 0 0 {name=p32 lab=VDD}
C {lab_pin.sym} 1190 160 0 1 {name=p33 sig_type=std_logic lab=VDD}
C {ipin.sym} 1130 200 0 0 {name=p34 lab=A}
C {lab_pin.sym} 1190 200 0 1 {name=p35 sig_type=std_logic lab=A}
C {opin.sym} 1190 250 0 0 {name=p36 lab=B}
C {lab_pin.sym} 1130 250 0 0 {name=p37 sig_type=std_logic lab=B}
C {lab_pin.sym} 1500 200 0 1 {name=p38 sig_type=std_logic lab=clk}
C {lab_pin.sym} 1700 150 0 0 {name=p39 sig_type=std_logic lab=clkb}
C {gnd.sym} 1460 0 0 0 {name=l14 lab=0}
C {lab_pin.sym} 1800 490 0 0 {name=p40 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1800 30 0 0 {name=p41 sig_type=std_logic lab=c_p}
C {lab_pin.sym} 1400 50 0 0 {name=p42 sig_type=std_logic lab=c_n}
C {gnd.sym} 1930 410 0 0 {name=l15 lab=0}
C {lab_pin.sym} 1930 300 0 0 {name=p43 sig_type=std_logic lab=clkb}
C {symbols/nfet_03v3.sym} 1380 -30 0 0 {name=M6
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
C {symbols/pfet_03v3.sym} 1820 -80 0 1 {name=M10
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
C {symbols/nfet_03v3.sym} 1420 200 0 1 {name=M11
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
C {symbols/pfet_03v3.sym} 1780 150 0 0 {name=M12
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
C {symbols/nfet_03v3.sym} 1800 330 3 1 {name=M13
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
C {symbols/nfet_03v3.sym} 1930 360 3 1 {name=M14
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
C {symbols/nfet_03v3.sym} 2160 230 3 1 {name=M16
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
C {symbols/pfet_03v3.sym} 1800 550 3 0 {name=M17
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
C {symbols/nfet_06v0_dss.sym} 2030 230 1 0 {name=M1
L=0.70u
W=0.30u
nf=1
m=1
d_sab=3.78u
s_sab=0.28u
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_06v0_dss
spiceprefix=X
}
