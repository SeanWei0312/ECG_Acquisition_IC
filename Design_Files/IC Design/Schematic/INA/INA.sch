v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -640 160 -640 {lab=INA_DD}
N 140 -600 160 -600 {lab=INA_SS}
N 140 -560 160 -560 {lab=INA_INP}
N 140 -520 160 -520 {lab=INA_INN}
N 140 -480 160 -480 {lab=INA_OUTP}
N 140 -240 160 -240 {lab=INA_BFDC}
N 140 -440 160 -440 {lab=INA_OUTN}
N 140 -200 160 -200 {lab=INA_BCMFB}
N 140 -160 160 -160 {lab=INA_REF}
N 1160 -600 1160 -480 {lab=INA_OUTN}
N 1060 -600 1160 -600 {lab=INA_OUTN}
N 920 -600 920 -480 {lab=INA_FDINP}
N 920 -600 1000 -600 {lab=INA_FDINP}
N 920 -400 920 -280 {lab=INA_FDINN}
N 920 -280 1000 -280 {lab=INA_FDINN}
N 1060 -280 1160 -280 {lab=INA_OUTP}
N 1160 -400 1160 -280 {lab=INA_OUTP}
N 400 -600 440 -600 {lab=INA_SEFP}
N 400 -280 440 -280 {lab=INA_SEFN}
N 140 -320 160 -320 {lab=INA_BSE1}
N 400 -480 640 -480 {lab=INA_SEFP}
N 400 -400 640 -400 {lab=INA_SEFN}
N 640 -640 640 -600 {lab=INA_SEOP}
N 640 -280 640 -240 {lab=INA_SEON}
N 360 -680 440 -680 {lab=INA_INP}
N 360 -200 440 -200 {lab=INA_INN}
N 640 -400 640 -340 {lab=INA_SEFN}
N 640 -540 640 -480 {lab=INA_SEFP}
N 400 -600 400 -470 {lab=INA_SEFP}
N 400 -410 400 -280 {lab=INA_SEFN}
N 800 -480 960 -480 {lab=INA_FDINP}
N 800 -540 800 -480 {lab=INA_FDINP}
N 800 -640 800 -600 {lab=INA_SEOP}
N 800 -400 960 -400 {lab=INA_FDINN}
N 800 -400 800 -340 {lab=INA_FDINN}
N 600 -240 840 -240 {lab=INA_SEON}
N 800 -280 800 -240 {lab=INA_SEON}
N 600 -640 840 -640 {lab=INA_SEOP}
N 1120 -400 1200 -400 {lab=INA_OUTP}
N 1120 -480 1200 -480 {lab=INA_OUTN}
N 140 -360 160 -360 {lab=INA_SEON}
N 140 -400 160 -400 {lab=INA_SEOP}
N 520 -160 520 -120 {lab=INA_DD}
N 520 -360 520 -320 {lab=INA_SS}
N 400 -240 440 -240 {lab=INA_BSE2}
N 400 -640 440 -640 {lab=INA_BSE1}
N 520 -760 520 -720 {lab=INA_DD}
N 520 -560 520 -520 {lab=INA_SS}
N 920 -440 960 -440 {lab=INA_REF}
N 1010 -560 1010 -520 {lab=INA_DD}
N 1040 -560 1040 -520 {lab=INA_BFDC}
N 1010 -360 1010 -320 {lab=INA_SS}
N 1040 -360 1040 -320 {lab=INA_BCMFB}
N 1120 -440 1160 -440 {lab=INA_VOCM}
N 140 -280 160 -280 {lab=INA_BSE2}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -640 0 1 {name=p8 lab=INA_DD}
C {iopin.sym} 140 -600 0 1 {name=p9 lab=INA_SS}
C {lab_wire.sym} 160 -640 0 1 {name=p11 sig_type=std_logic lab=INA_DD}
C {lab_wire.sym} 160 -600 0 1 {name=p12 sig_type=std_logic lab=INA_SS}
C {ipin.sym} 140 -560 0 0 {name=p13 lab=INA_INP}
C {ipin.sym} 140 -520 0 0 {name=p14 lab=INA_INN}
C {lab_wire.sym} 160 -560 0 1 {name=p15 sig_type=std_logic lab=INA_INP}
C {lab_wire.sym} 160 -520 0 1 {name=p16 sig_type=std_logic lab=INA_INN}
C {opin.sym} 140 -480 0 1 {name=p17 lab=INA_OUTP}
C {lab_wire.sym} 160 -480 0 1 {name=p18 sig_type=std_logic lab=INA_OUTP}
C {iopin.sym} 140 -240 0 1 {name=p1 lab=INA_BFDC}
C {lab_wire.sym} 160 -240 0 1 {name=p19 sig_type=std_logic lab=INA_BFDC}
C {opin.sym} 140 -440 0 1 {name=p23 lab=INA_OUTN}
C {lab_wire.sym} 160 -440 0 1 {name=p24 sig_type=std_logic lab=INA_OUTN}
C {iopin.sym} 140 -200 0 1 {name=p25 lab=INA_BCMFB}
C {lab_wire.sym} 160 -200 0 1 {name=p26 sig_type=std_logic lab=INA_BCMFB}
C {iopin.sym} 140 -160 0 1 {name=p29 lab=INA_REF}
C {lab_wire.sym} 160 -160 0 1 {name=p30 sig_type=std_logic lab=INA_REF}
C {res.sym} 1030 -600 3 0 {name=RFDFBP
value=40k
footprint=1206
device=resistor
m=1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 880 -300 0 0 {name=xFDOTA1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 360 -500 0 0 {name=xSEOTA1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 360 -380 2 1 {name=xSEOTA2}
C {lab_wire.sym} 520 -760 0 0 {name=p2 sig_type=std_logic lab=INA_DD}
C {lab_wire.sym} 520 -120 2 1 {name=p3 sig_type=std_logic lab=INA_DD}
C {lab_wire.sym} 520 -520 2 1 {name=p4 sig_type=std_logic lab=INA_SS}
C {lab_wire.sym} 520 -360 0 0 {name=p5 sig_type=std_logic lab=INA_SS}
C {lab_wire.sym} 1010 -320 2 1 {name=p10 sig_type=std_logic lab=INA_SS}
C {lab_wire.sym} 1010 -560 0 0 {name=p20 sig_type=std_logic lab=INA_DD}
C {res.sym} 1030 -280 3 1 {name=RFDFBN
value=40k
footprint=1206
device=resistor
m=1}
C {res.sym} 800 -570 0 0 {name=RFDINP
value=10k
footprint=1206
device=resistor
m=1}
C {res.sym} 800 -310 2 1 {name=RFDINN
value=10k
footprint=1206
device=resistor
m=1}
C {res.sym} 640 -570 0 0 {name=RSEFP
value=118k
footprint=1206
device=resistor
m=1}
C {res.sym} 640 -310 2 1 {name=RSEFN
value=118k
footprint=1206
device=resistor
m=1}
C {res.sym} 400 -440 0 1 {name=RSEG
value=4k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 360 -680 0 0 {name=p21 sig_type=std_logic lab=INA_INP}
C {iopin.sym} 140 -320 0 1 {name=p22 lab=INA_BSE1}
C {lab_wire.sym} 160 -320 0 1 {name=p27 sig_type=std_logic lab=INA_BSE1}
C {lab_wire.sym} 400 -640 0 0 {name=p28 sig_type=std_logic lab=INA_BSE1}
C {lab_wire.sym} 400 -240 2 1 {name=p31 sig_type=std_logic lab=INA_BSE2}
C {lab_wire.sym} 360 -200 2 1 {name=p32 sig_type=std_logic lab=INA_INN}
C {lab_wire.sym} 920 -440 0 0 {name=p33 sig_type=std_logic lab=INA_REF}
C {lab_wire.sym} 840 -640 0 1 {name=p37 sig_type=std_logic lab=INA_SEOP}
C {lab_wire.sym} 840 -240 2 0 {name=p38 sig_type=std_logic lab=INA_SEON}
C {lab_wire.sym} 400 -600 0 0 {name=p34 sig_type=std_logic lab=INA_SEFP}
C {lab_wire.sym} 400 -280 2 1 {name=p35 sig_type=std_logic lab=INA_SEFN}
C {lab_wire.sym} 1160 -440 0 1 {name=p36 sig_type=std_logic lab=INA_VOCM}
C {lab_wire.sym} 1040 -320 2 0 {name=p39 sig_type=std_logic lab=INA_BCMFB}
C {lab_wire.sym} 1040 -560 0 1 {name=p40 sig_type=std_logic lab=INA_BFDC}
C {lab_wire.sym} 800 -480 2 1 {name=p41 sig_type=std_logic lab=INA_FDINP}
C {lab_wire.sym} 800 -400 0 0 {name=p42 sig_type=std_logic lab=INA_FDINN}
C {lab_wire.sym} 1200 -480 0 1 {name=p43 sig_type=std_logic lab=INA_OUTN}
C {lab_wire.sym} 1200 -400 2 0 {name=p44 sig_type=std_logic lab=INA_OUTP}
C {iopin.sym} 140 -360 0 1 {name=p45 lab=INA_SEON}
C {lab_wire.sym} 160 -360 0 1 {name=p46 sig_type=std_logic lab=INA_SEON}
C {iopin.sym} 140 -400 0 1 {name=p47 lab=INA_SEOP}
C {lab_wire.sym} 160 -400 0 1 {name=p48 sig_type=std_logic lab=INA_SEOP}
C {iopin.sym} 140 -280 0 1 {name=p49 lab=INA_BSE2}
C {lab_wire.sym} 160 -280 0 1 {name=p50 sig_type=std_logic lab=INA_BSE2}
