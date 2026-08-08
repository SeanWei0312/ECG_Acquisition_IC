v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -640 160 -640 {lab=LPF_DD}
N 140 -600 160 -600 {lab=LPF_SS}
N 140 -560 160 -560 {lab=LPF_INP}
N 140 -520 160 -520 {lab=LPF_INN}
N 140 -480 160 -480 {lab=LPF_OUTP}
N 140 -400 160 -400 {lab=LPF_BFDC}
N 140 -440 160 -440 {lab=LPF_OUTN}
N 140 -360 160 -360 {lab=LPF_BCMFB}
N 140 -320 160 -320 {lab=LPF_REF}
N 500 -400 540 -400 {lab=LPF_REF}
N 590 -520 590 -480 {lab=LPF_DD}
N 620 -520 620 -480 {lab=LPF_BFDC}
N 590 -320 590 -280 {lab=LPF_SS}
N 620 -320 620 -280 {lab=LPF_BCMFB}
N 700 -400 740 -400 {lab=LPF_VOCM}
N 360 -360 400 -360 {lab=LPF_INN}
N 360 -440 400 -440 {lab=LPF_INP}
N 500 -560 580 -560 {lab=#net1}
N 640 -560 740 -560 {lab=LPF_OUTN}
N 640 -240 740 -240 {lab=LPF_OUTP}
N 640 -160 740 -160 {lab=LPF_OUTP}
N 500 -240 580 -240 {lab=#net2}
N 500 -160 580 -160 {lab=#net2}
N 460 -360 540 -360 {lab=#net2}
N 700 -360 780 -360 {lab=LPF_OUTP}
N 700 -440 780 -440 {lab=LPF_OUTN}
N 460 -440 540 -440 {lab=#net1}
N 500 -640 580 -640 {lab=#net1}
N 640 -640 740 -640 {lab=LPF_OUTN}
N 500 -640 500 -440 {lab=#net1}
N 740 -640 740 -440 {lab=LPF_OUTN}
N 500 -360 500 -160 {lab=#net2}
N 740 -360 740 -160 {lab=LPF_OUTP}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -640 0 1 {name=p8 lab=LPF_DD}
C {iopin.sym} 140 -600 0 1 {name=p9 lab=LPF_SS}
C {lab_wire.sym} 160 -640 0 1 {name=p11 sig_type=std_logic lab=LPF_DD}
C {lab_wire.sym} 160 -600 0 1 {name=p12 sig_type=std_logic lab=LPF_SS}
C {ipin.sym} 140 -560 0 0 {name=p13 lab=LPF_INP}
C {ipin.sym} 140 -520 0 0 {name=p14 lab=LPF_INN}
C {lab_wire.sym} 160 -560 0 1 {name=p15 sig_type=std_logic lab=LPF_INP}
C {lab_wire.sym} 160 -520 0 1 {name=p16 sig_type=std_logic lab=LPF_INN}
C {opin.sym} 140 -480 0 1 {name=p17 lab=LPF_OUTP}
C {lab_wire.sym} 160 -480 0 1 {name=p18 sig_type=std_logic lab=LPF_OUTP}
C {iopin.sym} 140 -400 0 1 {name=p1 lab=LPF_BFDC}
C {lab_wire.sym} 160 -400 0 1 {name=p19 sig_type=std_logic lab=LPF_BFDC}
C {opin.sym} 140 -440 0 1 {name=p23 lab=LPF_OUTN}
C {lab_wire.sym} 160 -440 0 1 {name=p24 sig_type=std_logic lab=LPF_OUTN}
C {iopin.sym} 140 -360 0 1 {name=p25 lab=LPF_BCMFB}
C {lab_wire.sym} 160 -360 0 1 {name=p26 sig_type=std_logic lab=LPF_BCMFB}
C {iopin.sym} 140 -320 0 1 {name=p29 lab=LPF_REF}
C {lab_wire.sym} 160 -320 0 1 {name=p30 sig_type=std_logic lab=LPF_REF}
C {res.sym} 610 -560 3 0 {name=RFBP
value=3.7Meg
footprint=1206
device=resistor
m=1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 460 -260 0 0 {name=xFDOTA1}
C {lab_wire.sym} 590 -280 2 1 {name=p10 sig_type=std_logic lab=LPF_SS}
C {lab_wire.sym} 590 -520 0 0 {name=p20 sig_type=std_logic lab=LPF_DD}
C {lab_wire.sym} 500 -400 0 0 {name=p33 sig_type=std_logic lab=LPF_REF}
C {lab_wire.sym} 740 -400 0 1 {name=p36 sig_type=std_logic lab=LPF_VOCM}
C {lab_wire.sym} 620 -280 2 0 {name=p39 sig_type=std_logic lab=LPF_BCMFB}
C {lab_wire.sym} 620 -520 0 1 {name=p40 sig_type=std_logic lab=LPF_BFDC}
C {lab_wire.sym} 780 -440 0 1 {name=p43 sig_type=std_logic lab=LPF_OUTN}
C {lab_wire.sym} 780 -360 2 0 {name=p44 sig_type=std_logic lab=LPF_OUTP}
C {res.sym} 430 -360 3 1 {name=RINN
value=3.7Meg
footprint=1206
device=resistor
m=1}
C {res.sym} 430 -440 3 0 {name=RINP
value=3.7Meg
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 360 -440 0 0 {name=p55 sig_type=std_logic lab=LPF_INP}
C {lab_wire.sym} 360 -360 2 1 {name=p56 sig_type=std_logic lab=LPF_INN}
C {res.sym} 610 -240 3 1 {name=RFBN
value=3.7Meg
footprint=1206
device=resistor
m=1}
C {capa.sym} 610 -640 3 0 {name=CLPFP
m=5
value=20p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 610 -160 3 1 {name=CLPFN
m=5
value=20p
footprint=1206
device="ceramic capacitor"}
