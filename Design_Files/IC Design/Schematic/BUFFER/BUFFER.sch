v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -520 160 -520 {lab=BUFFER_DD}
N 140 -480 160 -480 {lab=BUFFER_SS}
N 140 -440 160 -440 {lab=BUFFER_INP}
N 140 -400 160 -400 {lab=BUFFER_INN}
N 140 -360 160 -360 {lab=BUFFER_OUTP}
N 140 -280 160 -280 {lab=BUFFER_BFDC}
N 140 -320 160 -320 {lab=BUFFER_OUTN}
N 140 -240 160 -240 {lab=BUFFER_BCMFB}
N 140 -200 160 -200 {lab=BUFFER_REF}
N 560 -320 600 -320 {lab=BUFFER_REF}
N 650 -440 650 -400 {lab=BUFFER_DD}
N 680 -440 680 -400 {lab=BUFFER_BFDC}
N 650 -240 650 -200 {lab=BUFFER_SS}
N 680 -240 680 -200 {lab=BUFFER_BCMFB}
N 760 -320 800 -320 {lab=LPF_VOCM}
N 420 -280 460 -280 {lab=BUFFER_INN}
N 420 -360 460 -360 {lab=BUFFER_INP}
N 560 -480 640 -480 {lab=#net1}
N 700 -480 800 -480 {lab=BUFFER_OUTN}
N 700 -160 800 -160 {lab=BUFFER_OUTP}
N 560 -160 640 -160 {lab=#net2}
N 520 -280 600 -280 {lab=#net2}
N 760 -280 840 -280 {lab=BUFFER_OUTP}
N 760 -360 840 -360 {lab=BUFFER_OUTN}
N 520 -360 600 -360 {lab=#net1}
N 560 -280 560 -160 {lab=#net2}
N 560 -480 560 -360 {lab=#net1}
N 800 -480 800 -360 {lab=BUFFER_OUTN}
N 800 -280 800 -160 {lab=BUFFER_OUTP}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -520 0 1 {name=p8 lab=BUFFER_DD}
C {iopin.sym} 140 -480 0 1 {name=p9 lab=BUFFER_SS}
C {lab_wire.sym} 160 -520 0 1 {name=p11 sig_type=std_logic lab=BUFFER_DD}
C {lab_wire.sym} 160 -480 0 1 {name=p12 sig_type=std_logic lab=BUFFER_SS}
C {ipin.sym} 140 -440 0 0 {name=p13 lab=BUFFER_INP}
C {ipin.sym} 140 -400 0 0 {name=p14 lab=BUFFER_INN}
C {lab_wire.sym} 160 -440 0 1 {name=p15 sig_type=std_logic lab=BUFFER_INP}
C {lab_wire.sym} 160 -400 0 1 {name=p16 sig_type=std_logic lab=BUFFER_INN}
C {opin.sym} 140 -360 0 1 {name=p17 lab=BUFFER_OUTP}
C {lab_wire.sym} 160 -360 0 1 {name=p18 sig_type=std_logic lab=BUFFER_OUTP}
C {iopin.sym} 140 -280 0 1 {name=p1 lab=BUFFER_BFDC}
C {lab_wire.sym} 160 -280 0 1 {name=p19 sig_type=std_logic lab=BUFFER_BFDC}
C {opin.sym} 140 -320 0 1 {name=p23 lab=BUFFER_OUTN}
C {lab_wire.sym} 160 -320 0 1 {name=p24 sig_type=std_logic lab=BUFFER_OUTN}
C {iopin.sym} 140 -240 0 1 {name=p25 lab=BUFFER_BCMFB}
C {lab_wire.sym} 160 -240 0 1 {name=p26 sig_type=std_logic lab=BUFFER_BCMFB}
C {iopin.sym} 140 -200 0 1 {name=p29 lab=BUFFER_REF}
C {lab_wire.sym} 160 -200 0 1 {name=p30 sig_type=std_logic lab=BUFFER_REF}
C {res.sym} 670 -480 3 0 {name=RFBP
value=20k
footprint=1206
device=resistor
m=1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 520 -180 0 0 {name=xFDOTA1}
C {lab_wire.sym} 650 -200 2 1 {name=p10 sig_type=std_logic lab=BUFFER_SS}
C {lab_wire.sym} 650 -440 0 0 {name=p20 sig_type=std_logic lab=BUFFER_DD}
C {lab_wire.sym} 560 -320 0 0 {name=p33 sig_type=std_logic lab=BUFFER_REF}
C {lab_wire.sym} 800 -320 0 1 {name=p36 sig_type=std_logic lab=BUFFER_VOCM}
C {lab_wire.sym} 680 -200 2 0 {name=p39 sig_type=std_logic lab=BUFFER_BCMFB}
C {lab_wire.sym} 680 -440 0 1 {name=p40 sig_type=std_logic lab=BUFFER_BFDC}
C {lab_wire.sym} 840 -360 0 1 {name=p43 sig_type=std_logic lab=BUFFER_OUTN}
C {lab_wire.sym} 840 -280 2 0 {name=p44 sig_type=std_logic lab=BUFFER_OUTP}
C {res.sym} 490 -280 3 1 {name=RINN
value=20k
footprint=1206
device=resistor
m=1}
C {res.sym} 490 -360 3 0 {name=RINP
value=20k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 420 -360 0 0 {name=p55 sig_type=std_logic lab=BUFFER_INP}
C {lab_wire.sym} 420 -280 2 1 {name=p56 sig_type=std_logic lab=BUFFER_INN}
C {res.sym} 670 -160 3 1 {name=RFBN
value=20k
footprint=1206
device=resistor
m=1}
