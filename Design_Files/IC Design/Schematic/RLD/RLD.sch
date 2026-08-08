v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -520 160 -520 {lab=RLD_DD}
N 140 -480 160 -480 {lab=RLD_SS}
N 140 -440 160 -440 {lab=RLD_INP}
N 140 -400 160 -400 {lab=RLD_INN}
N 140 -360 160 -360 {lab=RLD_OUT}
N 400 -400 400 -320 {lab=#net1}
N 400 -500 400 -460 {lab=RLD_INP}
N 400 -260 400 -220 {lab=RLD_INN}
N 520 -400 560 -400 {lab=RLD_BSE}
N 520 -440 560 -440 {lab=RLD_REF}
N 640 -520 640 -480 {lab=RLD_DD}
N 640 -320 640 -280 {lab=RLD_SS}
N 400 -360 560 -360 {lab=#net1}
N 140 -320 160 -320 {lab=RLD_BSE}
N 140 -280 160 -280 {lab=RLD_REF}
N 520 -240 600 -240 {lab=#net1}
N 660 -240 760 -240 {lab=RLD_OUT}
N 660 -160 760 -160 {lab=RLD_OUT}
N 520 -160 600 -160 {lab=#net1}
N 720 -400 800 -400 {lab=RLD_OUT}
N 760 -400 760 -160 {lab=RLD_OUT}
N 520 -360 520 -160 {lab=#net1}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -520 0 1 {name=p8 lab=RLD_DD}
C {iopin.sym} 140 -480 0 1 {name=p9 lab=RLD_SS}
C {lab_wire.sym} 160 -520 0 1 {name=p11 sig_type=std_logic lab=RLD_DD}
C {lab_wire.sym} 160 -480 0 1 {name=p12 sig_type=std_logic lab=RLD_SS}
C {ipin.sym} 140 -440 0 0 {name=p13 lab=RLD_INP}
C {ipin.sym} 140 -400 0 0 {name=p14 lab=RLD_INN}
C {lab_wire.sym} 160 -440 0 1 {name=p15 sig_type=std_logic lab=RLD_INP}
C {lab_wire.sym} 160 -400 0 1 {name=p16 sig_type=std_logic lab=RLD_INN}
C {opin.sym} 140 -360 0 1 {name=p37 lab=RLD_OUT}
C {lab_wire.sym} 160 -360 0 1 {name=p39 sig_type=std_logic lab=RLD_OUT}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 480 -260 0 0 {name=xSEOTA1}
C {res.sym} 400 -430 0 1 {name=RRLDP
value=4Meg
footprint=1206
device=resistor
m=1}
C {res.sym} 400 -290 2 0 {name=RRLDN
value=4Meg
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 640 -280 2 1 {name=p1 sig_type=std_logic lab=RLD_SS}
C {lab_wire.sym} 640 -520 0 0 {name=p2 sig_type=std_logic lab=RLD_DD}
C {lab_wire.sym} 400 -500 0 0 {name=p3 sig_type=std_logic lab=RLD_INP}
C {lab_wire.sym} 400 -220 2 1 {name=p4 sig_type=std_logic lab=RLD_INN}
C {lab_wire.sym} 800 -400 0 1 {name=p5 sig_type=std_logic lab=RLD_OUT}
C {lab_wire.sym} 520 -440 0 0 {name=p6 sig_type=std_logic lab=RLD_REF}
C {iopin.sym} 140 -320 0 1 {name=p25 lab=RLD_BSE}
C {lab_wire.sym} 160 -320 0 1 {name=p26 sig_type=std_logic lab=RLD_BSE}
C {iopin.sym} 140 -280 0 1 {name=p29 lab=RLD_REF}
C {lab_wire.sym} 160 -280 0 1 {name=p30 sig_type=std_logic lab=RLD_REF}
C {lab_wire.sym} 520 -400 0 0 {name=p7 sig_type=std_logic lab=RLD_BSE}
C {res.sym} 630 -240 3 1 {name=RRLDF
value=20Meg
footprint=1206
device=resistor
m=1}
C {capa.sym} 630 -160 3 1 {name=CRLDF
m=4
value=20p
footprint=1206
device="ceramic capacitor"}
