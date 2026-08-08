v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -720 160 -720 {lab=SEL_DD}
N 140 -680 160 -680 {lab=SEL_SS}
N 140 -640 160 -640 {lab=SEL_INTP}
N 140 -600 160 -600 {lab=SEL_INTN}
N 140 -480 160 -480 {lab=SEL_OUTP}
N 140 -440 160 -440 {lab=SEL_OUTN}
N 140 -560 160 -560 {lab=SEL_EXTP}
N 140 -520 160 -520 {lab=SEL_EXTN}
N 140 -400 160 -400 {lab=SEL_SEL}
N 560 -680 600 -680 {lab=SEL_EXTP}
N 720 -680 760 -680 {lab=SEL_OUTP}
N 680 -740 680 -720 {lab=SEL_SEL}
N 680 -640 680 -620 {lab=SELB}
N 640 -640 640 -620 {lab=SEL_SS}
N 640 -740 640 -720 {lab=SEL_DD}
N 560 -520 600 -520 {lab=SEL_INTP}
N 720 -520 760 -520 {lab=SEL_OUTP}
N 680 -580 680 -560 {lab=SELB}
N 680 -480 680 -460 {lab=SEL_SEL}
N 640 -480 640 -460 {lab=SEL_SS}
N 640 -580 640 -560 {lab=SEL_DD}
N 560 -200 600 -200 {lab=SEL_EXTN}
N 720 -200 760 -200 {lab=SEL_OUTN}
N 680 -260 680 -240 {lab=SEL_SEL}
N 680 -160 680 -140 {lab=SELB}
N 640 -160 640 -140 {lab=SEL_SS}
N 640 -260 640 -240 {lab=SEL_DD}
N 560 -360 600 -360 {lab=SEL_INTN}
N 720 -360 760 -360 {lab=SEL_OUTN}
N 680 -420 680 -400 {lab=SELB}
N 680 -320 680 -300 {lab=SEL_SEL}
N 640 -320 640 -300 {lab=SEL_SS}
N 640 -420 640 -400 {lab=SEL_DD}
N 760 -680 760 -520 {lab=SEL_OUTP}
N 760 -600 800 -600 {lab=SEL_OUTP}
N 760 -360 760 -200 {lab=SEL_OUTN}
N 760 -280 800 -280 {lab=SEL_OUTN}
N 300 -300 300 -260 {lab=SEL_DD}
N 300 -180 300 -140 {lab=SEL_SS}
N 360 -220 400 -220 {lab=SELB}
N 220 -220 260 -220 {lab=SEL_SEL}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -720 0 1 {name=p8 lab=SEL_DD}
C {iopin.sym} 140 -680 0 1 {name=p9 lab=SEL_SS}
C {lab_wire.sym} 160 -720 0 1 {name=p11 sig_type=std_logic lab=SEL_DD}
C {lab_wire.sym} 160 -680 0 1 {name=p12 sig_type=std_logic lab=SEL_SS}
C {ipin.sym} 140 -640 0 0 {name=p13 lab=SEL_INTP}
C {ipin.sym} 140 -600 0 0 {name=p14 lab=SEL_INTN}
C {lab_wire.sym} 160 -640 0 1 {name=p15 sig_type=std_logic lab=SEL_INTP}
C {lab_wire.sym} 160 -600 0 1 {name=p16 sig_type=std_logic lab=SEL_INTN}
C {iopin.sym} 140 -480 0 1 {name=p17 lab=SEL_OUTP}
C {lab_wire.sym} 160 -480 0 1 {name=p18 sig_type=std_logic lab=SEL_OUTP}
C {iopin.sym} 140 -440 0 1 {name=p23 lab=SEL_OUTN}
C {lab_wire.sym} 160 -440 0 1 {name=p24 sig_type=std_logic lab=SEL_OUTN}
C {lab_wire.sym} 300 -300 0 1 {name=p3 sig_type=std_logic lab=SEL_DD}
C {lab_wire.sym} 300 -140 2 0 {name=p4 sig_type=std_logic lab=SEL_SS}
C {lab_wire.sym} 220 -220 0 0 {name=p1 sig_type=std_logic lab=SEL_SEL}
C {lab_wire.sym} 400 -220 0 1 {name=p6 sig_type=std_logic lab=SELB}
C {lab_wire.sym} 680 -740 0 1 {name=p7 sig_type=std_logic lab=SEL_SEL}
C {lab_wire.sym} 560 -520 0 0 {name=p33 sig_type=std_logic lab=SEL_INTP}
C {lab_wire.sym} 560 -360 2 1 {name=p34 sig_type=std_logic lab=SEL_INTN}
C {lab_wire.sym} 800 -280 2 0 {name=p35 sig_type=std_logic lab=SEL_OUTN}
C {lab_wire.sym} 800 -600 0 1 {name=p36 sig_type=std_logic lab=SEL_OUTP}
C {ipin.sym} 140 -560 0 0 {name=p37 lab=SEL_EXTP}
C {ipin.sym} 140 -520 0 0 {name=p38 lab=SEL_EXTN}
C {lab_wire.sym} 160 -560 0 1 {name=p39 sig_type=std_logic lab=SEL_EXTP}
C {lab_wire.sym} 160 -520 0 1 {name=p40 sig_type=std_logic lab=SEL_EXTN}
C {lab_wire.sym} 560 -200 2 1 {name=p41 sig_type=std_logic lab=SEL_EXTN}
C {lab_wire.sym} 560 -680 0 0 {name=p42 sig_type=std_logic lab=SEL_EXTP}
C {ipin.sym} 140 -400 0 0 {name=p19 lab=SEL_SEL}
C {lab_wire.sym} 160 -400 0 1 {name=p31 sig_type=std_logic lab=SEL_SEL}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/INV/INV.sym} 180 -120 0 0 {name=xINV1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 520 -580 0 0 {name=xTG1}
C {lab_wire.sym} 680 -620 2 0 {name=p2 sig_type=std_logic lab=SELB}
C {lab_wire.sym} 640 -740 0 0 {name=p5 sig_type=std_logic lab=SEL_DD}
C {lab_wire.sym} 640 -620 2 1 {name=p10 sig_type=std_logic lab=SEL_SS}
C {lab_wire.sym} 680 -300 2 0 {name=p20 sig_type=std_logic lab=SEL_SEL}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 520 -420 0 0 {name=xTG2}
C {lab_wire.sym} 680 -420 0 1 {name=p21 sig_type=std_logic lab=SELB}
C {lab_wire.sym} 640 -580 0 0 {name=p22 sig_type=std_logic lab=SEL_DD}
C {lab_wire.sym} 640 -460 2 1 {name=p25 sig_type=std_logic lab=SEL_SS}
C {lab_wire.sym} 680 -260 0 1 {name=p26 sig_type=std_logic lab=SEL_SEL}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 520 -100 0 0 {name=xTG3}
C {lab_wire.sym} 680 -140 2 0 {name=p27 sig_type=std_logic lab=SELB}
C {lab_wire.sym} 640 -260 0 0 {name=p28 sig_type=std_logic lab=SEL_DD}
C {lab_wire.sym} 640 -140 2 1 {name=p29 sig_type=std_logic lab=SEL_SS}
C {lab_wire.sym} 680 -460 2 0 {name=p30 sig_type=std_logic lab=SEL_SEL}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 520 -260 0 0 {name=xTG4}
C {lab_wire.sym} 680 -580 0 1 {name=p32 sig_type=std_logic lab=SELB}
C {lab_wire.sym} 640 -420 0 0 {name=p43 sig_type=std_logic lab=SEL_DD}
C {lab_wire.sym} 640 -300 2 1 {name=p44 sig_type=std_logic lab=SEL_SS}
