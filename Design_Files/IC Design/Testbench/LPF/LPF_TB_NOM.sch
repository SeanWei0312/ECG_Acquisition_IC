v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -790 {}
N 860 -1780 900 -1780 {lab=OUTN}
N 860 -1900 900 -1900 {lab=OUTP}
N 320 -2000 320 -1960 {lab=REF}
N 360 -2000 360 -1960 {lab=BFDC}
N 400 -2000 400 -1960 {lab=BCMFB}
N 160 -1900 200 -1900 {lab=INP}
N 160 -1780 200 -1780 {lab=INN}
N 160 -1640 760 -1640 {lab=AGND}
N 160 -1680 720 -1680 {lab=AVDD}
N 1020 -1700 1020 -1680 {lab=AGND}
N 1020 -1780 1020 -1760 {lab=OUTP}
N 1100 -1700 1100 -1680 {lab=AGND}
N 1100 -1780 1100 -1760 {lab=OUTN}
N 200 -2080 200 -2040 {lab=AVDD}
N 240 -2080 240 -2040 {lab=AGND}
N 280 -2160 360 -2160 {lab=BP}
N 280 -2120 320 -2120 {lab=REF}
N 400 -2130 400 -2080 {lab=BFDC}
N 400 -2240 400 -2190 {lab=AVDD}
N 400 -2160 420 -2160 {lab=AVDD}
N 420 -2200 420 -2160 {lab=AVDD}
N 400 -2200 420 -2200 {lab=AVDD}
N 560 -2130 560 -2080 {lab=BCMFB}
N 560 -2240 560 -2190 {lab=AVDD}
N 560 -2160 580 -2160 {lab=AVDD}
N 580 -2200 580 -2160 {lab=AVDD}
N 560 -2200 580 -2200 {lab=AVDD}
N 480 -2160 520 -2160 {lab=BP}
N 80 -1220 80 -1200 {lab=AGND}
N 80 -1360 80 -1340 {lab=AVDD}
N 500 -1900 500 -1600 {lab=LPF_OUTP}
N 620 -1780 620 -1480 {lab=LPF_EXTN}
N 580 -1820 580 -1520 {lab=LPF_EXTP}
N 460 -1780 540 -1780 {lab=LPF_OUTN}
N 620 -1780 660 -1780 {lab=LPF_EXTN}
N 580 -1820 660 -1820 {lab=LPF_EXTP}
N 540 -1860 660 -1860 {lab=LPF_OUTN}
N 540 -1860 540 -1560 {lab=LPF_OUTN}
N 460 -1900 660 -1900 {lab=LPF_OUTP}
N 280 -1720 280 -1640 {lab=AGND}
N 240 -1720 240 -1680 {lab=AVDD}
N 760 -1720 760 -1640 {lab=AGND}
N 720 -1720 720 -1680 {lab=AVDD}
N 800 -1720 800 -1600 {lab=LPF_SEL}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -1030 0 0 {name=MODELS
only_toplevel=true
value="
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice cap_mim
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice bjt_typical
.csparam PROC_ID=0
"}
C {devices/code_shown.sym} 80 -790 0 0 {name=SETUP
only_toplevel=true
value=}
C {devices/code_shown.sym} 960 -1030 0 0 {name=NGSPICE
only_toplevel=true
value=}
C {lab_wire.sym} 160 -1900 0 0 {name=p28 sig_type=std_logic lab=INP}
C {lab_wire.sym} 160 -1780 0 0 {name=p29 sig_type=std_logic lab=INN}
C {lab_wire.sym} 160 -1680 0 0 {name=p30 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1640 0 0 {name=p32 sig_type=std_logic lab=AGND}
C {capa.sym} 1020 -1730 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1020 -1780 0 1 {name=p1 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1020 -1680 2 0 {name=p2 sig_type=std_logic lab=AGND}
C {capa.sym} 1100 -1730 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1100 -1680 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1100 -1780 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 900 -1900 0 1 {name=p3 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 900 -1780 0 1 {name=p4 sig_type=std_logic lab=OUTN}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 120 -2040 0 0 {name=xBIAS1}
C {lab_wire.sym} 200 -2040 2 1 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 240 -2040 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 320 -2120 0 1 {name=p36 sig_type=std_logic lab=REF}
C {lab_wire.sym} 320 -2160 0 1 {name=p37 sig_type=std_logic lab=BP}
C {lab_wire.sym} 320 -2000 0 0 {name=p7 sig_type=std_logic lab=REF}
C {symbols/pfet_03v3.sym} 380 -2160 0 0 {name=MBFDC
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
C {lab_wire.sym} 400 -2240 0 0 {name=p14 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 400 -2080 2 1 {name=p15 sig_type=std_logic lab=BFDC}
C {symbols/pfet_03v3.sym} 540 -2160 0 0 {name=MBCMFB
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
C {lab_wire.sym} 560 -2240 0 0 {name=p17 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 560 -2080 2 1 {name=p18 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 480 -2160 0 1 {name=p19 sig_type=std_logic lab=BP}
C {lab_wire.sym} 400 -2000 0 1 {name=p20 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 360 -2000 0 1 {name=p21 sig_type=std_logic lab=BFDC}
C {vsource.sym} 80 -1310 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -1280 0 0 {name=l5 lab=0}
C {vsource.sym} 80 -1170 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -1140 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -1220 0 0 {name=p24 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -1360 0 0 {name=p55 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/LPF/LPF.sym} 120 -1680 0 0 {name=xLFP1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SEL/SEL.sym} 600 -1680 0 0 {name=xSEL1}
C {lab_wire.sym} 500 -1600 2 1 {name=p47 sig_type=std_logic lab=LPF_OUTP}
C {lab_wire.sym} 540 -1560 2 1 {name=p48 sig_type=std_logic lab=LPF_OUTN}
C {lab_wire.sym} 580 -1520 2 1 {name=p70 sig_type=std_logic lab=LPF_EXTP}
C {lab_wire.sym} 620 -1480 2 1 {name=p80 sig_type=std_logic lab=LPF_EXTN}
C {lab_wire.sym} 800 -1600 2 1 {name=p82 sig_type=std_logic lab=LPF_SEL}
