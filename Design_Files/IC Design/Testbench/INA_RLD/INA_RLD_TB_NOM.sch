v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -550 {}
N 1280 -1300 1320 -1300 {lab=OUTN}
N 1280 -1420 1320 -1420 {lab=OUTP}
N 660 -1240 660 -1200 {lab=AVDD}
N 700 -1240 700 -1160 {lab=AGND}
N 920 -1420 920 -1120 {lab=INA_OUTP}
N 1040 -1300 1040 -1000 {lab=INA_EXTN}
N 1000 -1340 1000 -1040 {lab=INA_EXTP}
N 880 -1300 960 -1300 {lab=INA_OUTN}
N 1040 -1300 1080 -1300 {lab=INA_EXTN}
N 1000 -1340 1080 -1340 {lab=INA_EXTP}
N 960 -1380 1080 -1380 {lab=INA_OUTN}
N 960 -1380 960 -1080 {lab=INA_OUTN}
N 880 -1420 1080 -1420 {lab=INA_OUTP}
N 660 -1520 660 -1480 {lab=BSE1}
N 700 -1520 700 -1480 {lab=BSE2}
N 740 -1520 740 -1480 {lab=REF}
N 780 -1520 780 -1480 {lab=BFDC}
N 820 -1520 820 -1480 {lab=BCMFB}
N 1180 -1240 1180 -1160 {lab=AGND}
N 1140 -1240 1140 -1200 {lab=AVDD}
N 1220 -1240 1220 -1120 {lab=INA_SEL}
N 160 -1360 320 -1360 {lab=RLD}
N 480 -1340 600 -1340 {lab=SEON}
N 480 -1380 600 -1380 {lab=SEOP}
N 560 -1340 560 -1120 {lab=SEON}
N 520 -1380 520 -1120 {lab=SEOP}
N 160 -1440 600 -1440 {lab=INP}
N 160 -1280 600 -1280 {lab=INN}
N 360 -1520 360 -1420 {lab=BSE0}
N 400 -1520 400 -1420 {lab=REF}
N 360 -1300 360 -1200 {lab=AVDD}
N 400 -1300 400 -1160 {lab=AGND}
N 160 -1160 1180 -1160 {lab=AGND}
N 160 -1200 1140 -1200 {lab=AVDD}
N 1440 -1220 1440 -1200 {lab=AGND}
N 1440 -1300 1440 -1280 {lab=OUTP}
N 1520 -1220 1520 -1200 {lab=AGND}
N 1520 -1300 1520 -1280 {lab=OUTN}
N 200 -1600 200 -1560 {lab=AVDD}
N 240 -1600 240 -1560 {lab=AGND}
N 400 -1650 400 -1600 {lab=BSE0}
N 400 -1760 400 -1710 {lab=AVDD}
N 280 -1680 360 -1680 {lab=BP}
N 400 -1680 420 -1680 {lab=AVDD}
N 420 -1720 420 -1680 {lab=AVDD}
N 400 -1720 420 -1720 {lab=AVDD}
N 280 -1640 320 -1640 {lab=REF}
N 560 -1650 560 -1600 {lab=BSE1}
N 560 -1760 560 -1710 {lab=AVDD}
N 560 -1680 580 -1680 {lab=AVDD}
N 580 -1720 580 -1680 {lab=AVDD}
N 560 -1720 580 -1720 {lab=AVDD}
N 480 -1680 520 -1680 {lab=BP}
N 720 -1650 720 -1600 {lab=BSE2}
N 720 -1760 720 -1710 {lab=AVDD}
N 720 -1680 740 -1680 {lab=AVDD}
N 740 -1720 740 -1680 {lab=AVDD}
N 720 -1720 740 -1720 {lab=AVDD}
N 640 -1680 680 -1680 {lab=BP}
N 880 -1650 880 -1600 {lab=BFDC}
N 880 -1760 880 -1710 {lab=AVDD}
N 880 -1680 900 -1680 {lab=AVDD}
N 900 -1720 900 -1680 {lab=AVDD}
N 880 -1720 900 -1720 {lab=AVDD}
N 800 -1680 840 -1680 {lab=BP}
N 1040 -1650 1040 -1600 {lab=BCMFB}
N 1040 -1760 1040 -1710 {lab=AVDD}
N 1040 -1680 1060 -1680 {lab=AVDD}
N 1060 -1720 1060 -1680 {lab=AVDD}
N 1040 -1720 1060 -1720 {lab=AVDD}
N 960 -1680 1000 -1680 {lab=BP}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -730 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value=}
C {devices/code_shown.sym} 80 -470 0 0 {name=SETUP
only_toplevel=true
value=}
C {devices/code_shown.sym} 1010 -730 0 0 {name=NGSPICE
only_toplevel=true
value=}
C {lab_wire.sym} 160 -1440 0 0 {name=p28 sig_type=std_logic lab=INP}
C {lab_wire.sym} 160 -1280 0 0 {name=p29 sig_type=std_logic lab=INN}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SEL/SEL.sym} 1020 -1200 0 0 {name=xSEL2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/INA/INA.sym} 540 -1200 0 0 {name=xINA1}
C {lab_wire.sym} 520 -1120 2 1 {name=p94 sig_type=std_logic lab=SEOP}
C {lab_wire.sym} 560 -1120 2 1 {name=p95 sig_type=std_logic lab=SEON}
C {lab_wire.sym} 920 -1120 2 1 {name=p38 sig_type=std_logic lab=INA_OUTP}
C {lab_wire.sym} 960 -1080 2 1 {name=p43 sig_type=std_logic lab=INA_OUTN}
C {lab_wire.sym} 1220 -1120 2 1 {name=p46 sig_type=std_logic lab=INA_SEL}
C {lab_wire.sym} 1000 -1040 2 1 {name=p49 sig_type=std_logic lab=INA_EXTP}
C {lab_wire.sym} 1040 -1000 2 1 {name=p51 sig_type=std_logic lab=INA_EXTN}
C {lab_wire.sym} 160 -1360 0 0 {name=p168 sig_type=std_logic lab=RLD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/RLD/RLD.sym} 560 -1220 0 1 {name=xRLD1}
C {lab_wire.sym} 160 -1200 0 0 {name=p30 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1160 0 0 {name=p32 sig_type=std_logic lab=AGND}
C {capa.sym} 1440 -1250 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1440 -1300 0 1 {name=p1 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1440 -1200 2 0 {name=p2 sig_type=std_logic lab=AGND}
C {capa.sym} 1520 -1250 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1520 -1200 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1520 -1300 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 1320 -1420 0 1 {name=p3 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1320 -1300 0 1 {name=p4 sig_type=std_logic lab=OUTN}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 120 -1560 0 0 {name=xBIAS1}
C {lab_wire.sym} 200 -1560 2 1 {name=p13 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 240 -1560 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 380 -1680 0 0 {name=MBSE0
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
C {lab_wire.sym} 400 -1760 0 0 {name=p34 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 400 -1600 2 1 {name=p35 sig_type=std_logic lab=BSE0}
C {lab_wire.sym} 320 -1640 0 1 {name=p36 sig_type=std_logic lab=REF}
C {lab_wire.sym} 320 -1680 0 1 {name=p37 sig_type=std_logic lab=BP}
C {symbols/pfet_03v3.sym} 540 -1680 0 0 {name=MBSE1
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
C {lab_wire.sym} 560 -1760 0 0 {name=p40 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 560 -1600 2 1 {name=p41 sig_type=std_logic lab=BSE1}
C {lab_wire.sym} 480 -1680 0 1 {name=p42 sig_type=std_logic lab=BP}
C {lab_wire.sym} 360 -1520 0 0 {name=p5 sig_type=std_logic lab=BSE0}
C {lab_wire.sym} 400 -1520 0 0 {name=p6 sig_type=std_logic lab=REF}
C {lab_wire.sym} 740 -1520 0 0 {name=p7 sig_type=std_logic lab=REF}
C {lab_wire.sym} 660 -1520 0 0 {name=p8 sig_type=std_logic lab=BSE1}
C {symbols/pfet_03v3.sym} 700 -1680 0 0 {name=MBSE2
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
C {lab_wire.sym} 720 -1760 0 0 {name=p9 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 720 -1600 2 1 {name=p10 sig_type=std_logic lab=BSE2}
C {lab_wire.sym} 640 -1680 0 1 {name=p11 sig_type=std_logic lab=BP}
C {lab_wire.sym} 700 -1520 0 0 {name=p12 sig_type=std_logic lab=BSE2}
C {symbols/pfet_03v3.sym} 860 -1680 0 0 {name=MBFDC
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
C {lab_wire.sym} 880 -1760 0 0 {name=p14 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 880 -1600 2 1 {name=p15 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 800 -1680 0 1 {name=p16 sig_type=std_logic lab=BP}
C {symbols/pfet_03v3.sym} 1020 -1680 0 0 {name=MBCMFB
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
C {lab_wire.sym} 1040 -1760 0 0 {name=p17 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 1040 -1600 2 1 {name=p18 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 960 -1680 0 1 {name=p19 sig_type=std_logic lab=BP}
C {lab_wire.sym} 820 -1520 0 1 {name=p20 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 780 -1520 0 1 {name=p21 sig_type=std_logic lab=BFDC}
