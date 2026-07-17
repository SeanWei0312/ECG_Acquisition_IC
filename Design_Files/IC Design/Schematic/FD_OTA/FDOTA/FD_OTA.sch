v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -560 160 -560 {lab=FDOTA_DD}
N 140 -520 160 -520 {lab=FDOTA_SS}
N 140 -480 160 -480 {lab=FDOTA_INP}
N 140 -440 160 -440 {lab=FDOTA_INN}
N 140 -400 160 -400 {lab=FDOTA_OUTP}
N 140 -320 160 -320 {lab=FDOTA_BFDC}
N 140 -360 160 -360 {lab=FDOTA_OUTN}
N 420 -480 440 -480 {lab=FDOTA_INP}
N 420 -440 440 -440 {lab=FDOTA_BFDC}
N 420 -400 440 -400 {lab=FDOTA_INN}
N 640 -520 640 -510 {lab=FDOTA_OUTP}
N 640 -370 640 -360 {lab=FDOTA_OUTN}
N 520 -340 520 -220 {lab=FDOTA_VCMFB}
N 520 -220 560 -220 {lab=FDOTA_VCMFB}
N 840 -440 840 -260 {lab=FDOTA_VOCM}
N 490 -340 490 -320 {lab=FDOTA_SS}
N 490 -560 490 -540 {lab=FDOTA_DD}
N 720 -180 740 -180 {lab=FDOTA_REF}
N 720 -220 740 -220 {lab=FDOTA_BCMFB}
N 640 -300 640 -280 {lab=FDOTA_DD}
N 640 -160 640 -140 {lab=FDOTA_SS}
N 140 -280 160 -280 {lab=FDOTA_BCMFB}
N 140 -240 160 -240 {lab=FDOTA_REF}
N 640 -450 640 -430 {lab=FDOTA_VOCM}
N 600 -360 640 -360 {lab=FDOTA_OUTN}
N 600 -520 640 -520 {lab=FDOTA_OUTP}
N 720 -450 720 -430 {lab=FDOTA_VOCM}
N 720 -440 840 -440 {lab=FDOTA_VOCM}
N 720 -260 840 -260 {lab=FDOTA_VOCM}
N 640 -360 720 -360 {lab=FDOTA_OUTN}
N 720 -370 720 -360 {lab=FDOTA_OUTN}
N 720 -520 720 -510 {lab=FDOTA_OUTP}
N 640 -520 720 -520 {lab=FDOTA_OUTP}
N 640 -440 720 -440 {lab=FDOTA_VOCM}
N 140 -200 160 -200 {lab=FDOTA_VOCM}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -560 0 1 {name=p8 lab=FDOTA_DD}
C {iopin.sym} 140 -520 0 1 {name=p9 lab=FDOTA_SS}
C {lab_wire.sym} 160 -560 0 1 {name=p11 sig_type=std_logic lab=FDOTA_DD}
C {lab_wire.sym} 160 -520 0 1 {name=p12 sig_type=std_logic lab=FDOTA_SS}
C {ipin.sym} 140 -480 0 0 {name=p13 lab=FDOTA_INP}
C {ipin.sym} 140 -440 0 0 {name=p14 lab=FDOTA_INN}
C {lab_wire.sym} 160 -480 0 1 {name=p15 sig_type=std_logic lab=FDOTA_INP}
C {lab_wire.sym} 160 -440 0 1 {name=p16 sig_type=std_logic lab=FDOTA_INN}
C {opin.sym} 140 -400 0 1 {name=p17 lab=FDOTA_OUTP}
C {lab_wire.sym} 160 -400 0 1 {name=p18 sig_type=std_logic lab=FDOTA_OUTP}
C {iopin.sym} 140 -320 0 1 {name=p1 lab=FDOTA_BFDC}
C {lab_wire.sym} 160 -320 0 1 {name=p19 sig_type=std_logic lab=FDOTA_BFDC}
C {opin.sym} 140 -360 0 1 {name=p23 lab=FDOTA_OUTN}
C {lab_wire.sym} 160 -360 0 1 {name=p24 sig_type=std_logic lab=FDOTA_OUTN}
C {lab_wire.sym} 490 -560 0 0 {name=p2 sig_type=std_logic lab=FDOTA_DD}
C {lab_wire.sym} 640 -300 0 0 {name=p3 sig_type=std_logic lab=FDOTA_DD}
C {lab_wire.sym} 490 -320 2 1 {name=p4 sig_type=std_logic lab=FDOTA_SS}
C {lab_wire.sym} 640 -140 2 1 {name=p5 sig_type=std_logic lab=FDOTA_SS}
C {lab_wire.sym} 420 -480 0 0 {name=p10 sig_type=std_logic lab=FDOTA_INP}
C {lab_wire.sym} 420 -400 0 0 {name=p20 sig_type=std_logic lab=FDOTA_INN}
C {lab_wire.sym} 720 -520 0 1 {name=p21 sig_type=std_logic lab=FDOTA_OUTP}
C {lab_wire.sym} 720 -360 2 0 {name=p22 sig_type=std_logic lab=FDOTA_OUTN}
C {iopin.sym} 140 -280 0 1 {name=p25 lab=FDOTA_BCMFB}
C {lab_wire.sym} 160 -280 0 1 {name=p26 sig_type=std_logic lab=FDOTA_BCMFB}
C {lab_wire.sym} 420 -440 0 0 {name=p27 sig_type=std_logic lab=FDOTA_BFDC}
C {lab_wire.sym} 740 -220 0 1 {name=p28 sig_type=std_logic lab=FDOTA_BCMFB}
C {iopin.sym} 140 -240 0 1 {name=p29 lab=FDOTA_REF}
C {lab_wire.sym} 160 -240 0 1 {name=p30 sig_type=std_logic lab=FDOTA_REF}
C {lab_wire.sym} 740 -180 0 1 {name=p31 sig_type=std_logic lab=FDOTA_REF}
C {lab_wire.sym} 840 -440 0 1 {name=p32 sig_type=std_logic lab=FDOTA_VOCM}
C {lab_wire.sym} 520 -220 2 1 {name=p33 sig_type=std_logic lab=FDOTA_VCMFB}
C {res.sym} 640 -480 0 0 {name=R1
value=100k
footprint=1206
device=resistor
m=1}
C {res.sym} 640 -400 0 0 {name=R2
value=100k
footprint=1206
device=resistor
m=1}
C {capa.sym} 720 -480 0 0 {name=C1
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 720 -400 0 0 {name=C2
m=1
value=50f
footprint=1206
device="ceramic capacitor"}
C {iopin.sym} 140 -200 0 1 {name=p6 lab=FDOTA_VOCM}
C {lab_wire.sym} 160 -200 0 1 {name=p7 sig_type=std_logic lab=FDOTA_VOCM}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDC/FDC.sym} 360 -300 0 0 {name=xFDC1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/CMFB/CMFB.sym} 860 -50 0 1 {name=xCMFB1}
