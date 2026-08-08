v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -680 160 -680 {lab=DCB_DD}
N 140 -640 160 -640 {lab=DCB_SS}
N 140 -600 160 -600 {lab=DCB_INP}
N 140 -560 160 -560 {lab=DCB_INN}
N 140 -520 160 -520 {lab=DCB_OUTP}
N 140 -480 160 -480 {lab=DCB_OUTN}
N 400 -1160 440 -1160 {lab=DCB_INP}
N 400 -280 440 -280 {lab=DCB_INN}
N 140 -440 160 -440 {lab=DCB_REF}
N 140 -400 160 -400 {lab=DCB_RST}
N 140 -360 160 -360 {lab=DCB_CLK}
N 880 -1480 880 -1440 {lab=DCB_DD}
N 940 -1400 980 -1400 {lab=RSTB}
N 880 -1360 880 -1320 {lab=DCB_SS}
N 800 -1400 840 -1400 {lab=DCB_RST}
N 440 -840 480 -840 {lab=DCB_SS}
N 440 -800 480 -800 {lab=RSTB}
N 440 -640 480 -640 {lab=RSTB}
N 440 -600 480 -600 {lab=DCB_SS}
N 560 -600 600 -600 {lab=DCB_DD}
N 560 -640 600 -640 {lab=DCB_RST}
N 560 -800 600 -800 {lab=DCB_RST}
N 560 -840 600 -840 {lab=DCB_DD}
N 140 -320 160 -320 {lab=DCB_RLD}
N 140 -280 160 -280 {lab=DCB_SEOP}
N 140 -240 160 -240 {lab=DCB_SEON}
N 140 -200 160 -200 {lab=DCB_BSE0}
N 600 -1400 640 -1400 {lab=DCB_RLD}
N 490 -1320 490 -1280 {lab=DCB_SS}
N 520 -1320 520 -1280 {lab=DCB_REF}
N 520 -1520 520 -1480 {lab=DCB_BSE0}
N 490 -1520 490 -1480 {lab=DCB_DD}
N 400 -1440 440 -1440 {lab=DCB_SEOP}
N 400 -1360 440 -1360 {lab=DCB_SEON}
N 1080 -1440 1120 -1440 {lab=DCB_CLK}
N 1080 -1360 1120 -1360 {lab=RSTB}
N 1160 -1300 1160 -1260 {lab=DCB_SS}
N 1160 -1540 1160 -1500 {lab=DCB_DD}
N 1240 -1460 1280 -1460 {lab=PH1}
N 1240 -1420 1280 -1420 {lab=PH1B}
N 1240 -1380 1280 -1380 {lab=PH2}
N 1240 -1340 1280 -1340 {lab=PH2B}
N 600 -960 600 -920 {lab=DCB_SS}
N 600 -1080 600 -1040 {lab=DCB_DD}
N 520 -1000 560 -1000 {lab=DCB_OUTP}
N 600 -520 600 -480 {lab=DCB_SS}
N 600 -400 600 -360 {lab=DCB_DD}
N 520 -440 560 -440 {lab=DCB_OUTN}
N 520 -760 520 -720 {lab=DCB_REF}
N 520 -720 520 -680 {lab=DCB_REF}
N 400 -720 760 -720 {lab=DCB_REF}
N 720 -440 760 -440 {lab=DCB_REF}
N 720 -1000 760 -1000 {lab=DCB_REF}
N 640 -1080 640 -1040 {lab=PH1}
N 680 -1080 680 -1040 {lab=PH2}
N 640 -960 640 -920 {lab=PH1B}
N 680 -960 680 -920 {lab=PH2B}
N 520 -1000 520 -880 {lab=DCB_OUTP}
N 760 -1000 760 -720 {lab=DCB_REF}
N 500 -1160 800 -1160 {lab=DCB_OUTP}
N 520 -1160 520 -1000 {lab=DCB_OUTP}
N 680 -400 680 -360 {lab=PH2}
N 640 -400 640 -360 {lab=PH1}
N 640 -520 640 -480 {lab=PH1B}
N 680 -520 680 -480 {lab=PH2B}
N 520 -560 520 -440 {lab=DCB_OUTN}
N 520 -440 520 -280 {lab=DCB_OUTN}
N 500 -280 800 -280 {lab=DCB_OUTN}
N 760 -720 760 -440 {lab=DCB_REF}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -680 0 1 {name=p8 lab=DCB_DD}
C {iopin.sym} 140 -640 0 1 {name=p9 lab=DCB_SS}
C {lab_wire.sym} 160 -680 0 1 {name=p11 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 160 -640 0 1 {name=p12 sig_type=std_logic lab=DCB_SS}
C {ipin.sym} 140 -600 0 0 {name=p13 lab=DCB_INP}
C {ipin.sym} 140 -560 0 0 {name=p14 lab=DCB_INN}
C {lab_wire.sym} 160 -600 0 1 {name=p15 sig_type=std_logic lab=DCB_INP}
C {lab_wire.sym} 160 -560 0 1 {name=p16 sig_type=std_logic lab=DCB_INN}
C {opin.sym} 140 -520 0 1 {name=p17 lab=DCB_OUTP}
C {lab_wire.sym} 160 -520 0 1 {name=p18 sig_type=std_logic lab=DCB_OUTP}
C {opin.sym} 140 -480 0 1 {name=p23 lab=DCB_OUTN}
C {lab_wire.sym} 160 -480 0 1 {name=p24 sig_type=std_logic lab=DCB_OUTN}
C {lab_wire.sym} 400 -1160 0 0 {name=p5 sig_type=std_logic lab=DCB_INP}
C {lab_wire.sym} 400 -280 2 1 {name=p10 sig_type=std_logic lab=DCB_INN}
C {lab_wire.sym} 800 -1160 0 1 {name=p7 sig_type=std_logic lab=DCB_OUTP}
C {lab_wire.sym} 800 -280 2 0 {name=p19 sig_type=std_logic lab=DCB_OUTN}
C {lab_wire.sym} 400 -720 0 0 {name=p1 sig_type=std_logic lab=DCB_REF}
C {iopin.sym} 140 -440 0 1 {name=p2 lab=DCB_REF}
C {lab_wire.sym} 160 -440 0 1 {name=p3 sig_type=std_logic lab=DCB_REF}
C {iopin.sym} 140 -400 0 1 {name=p20 lab=DCB_RST}
C {lab_wire.sym} 160 -400 0 1 {name=p21 sig_type=std_logic lab=DCB_RST}
C {iopin.sym} 140 -360 0 1 {name=p4 lab=DCB_CLK}
C {lab_wire.sym} 160 -360 0 1 {name=p6 sig_type=std_logic lab=DCB_CLK}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 420 -960 1 0 {name=xTG1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 420 -480 1 1 {name=xTG2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/INV/INV.sym} 760 -1300 0 0 {name=xINV1}
C {lab_wire.sym} 800 -1400 0 0 {name=p22 sig_type=std_logic lab=DCB_RST}
C {lab_wire.sym} 600 -800 0 1 {name=p25 sig_type=std_logic lab=DCB_RST}
C {lab_wire.sym} 600 -640 2 0 {name=p26 sig_type=std_logic lab=DCB_RST}
C {lab_wire.sym} 880 -1480 0 0 {name=p27 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 600 -840 0 1 {name=p28 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 600 -600 2 0 {name=p29 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 880 -1320 2 1 {name=p30 sig_type=std_logic lab=DCB_SS}
C {lab_wire.sym} 440 -600 2 1 {name=p31 sig_type=std_logic lab=DCB_SS}
C {lab_wire.sym} 440 -840 0 0 {name=p32 sig_type=std_logic lab=DCB_SS}
C {lab_wire.sym} 980 -1400 0 1 {name=p33 sig_type=std_logic lab=RSTB}
C {lab_wire.sym} 440 -640 2 1 {name=p34 sig_type=std_logic lab=RSTB}
C {lab_wire.sym} 440 -800 0 0 {name=p35 sig_type=std_logic lab=RSTB}
C {opin.sym} 140 -320 0 1 {name=p36 lab=DCB_RLD}
C {lab_wire.sym} 160 -320 0 1 {name=p37 sig_type=std_logic lab=DCB_RLD}
C {ipin.sym} 140 -280 0 0 {name=p38 lab=DCB_SEOP}
C {lab_wire.sym} 160 -280 0 1 {name=p39 sig_type=std_logic lab=DCB_SEOP}
C {ipin.sym} 140 -240 0 0 {name=p40 lab=DCB_SEON}
C {lab_wire.sym} 160 -240 0 1 {name=p41 sig_type=std_logic lab=DCB_SEON}
C {iopin.sym} 140 -200 0 1 {name=p42 lab=DCB_BSE0}
C {lab_wire.sym} 160 -200 0 1 {name=p43 sig_type=std_logic lab=DCB_BSE0}
C {lab_wire.sym} 490 -1520 0 0 {name=p44 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 490 -1280 2 1 {name=p45 sig_type=std_logic lab=DCB_SS}
C {lab_wire.sym} 520 -1280 2 0 {name=p46 sig_type=std_logic lab=DCB_REF}
C {lab_wire.sym} 520 -1520 0 1 {name=p47 sig_type=std_logic lab=DCB_BSE0}
C {lab_wire.sym} 640 -1400 0 1 {name=p48 sig_type=std_logic lab=DCB_RLD}
C {lab_wire.sym} 400 -1440 0 0 {name=p49 sig_type=std_logic lab=DCB_SEOP}
C {lab_wire.sym} 400 -1360 0 0 {name=p50 sig_type=std_logic lab=DCB_SEON}
C {lab_wire.sym} 1080 -1440 0 0 {name=p51 sig_type=std_logic lab=DCB_CLK}
C {lab_wire.sym} 1080 -1360 0 0 {name=p52 sig_type=std_logic lab=RSTB}
C {lab_wire.sym} 1160 -1540 0 0 {name=p53 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 1160 -1260 2 1 {name=p54 sig_type=std_logic lab=DCB_SS}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SCR/SCR.sym} 480 -840 0 0 {name=xSCR1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/CLK2P/CLK2P.sym} 1040 -1280 0 0 {name=xCLK2P1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/RLD/RLD.sym} 360 -1240 0 0 {name=xRLD1}
C {lab_wire.sym} 600 -1080 0 0 {name=p55 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 600 -920 2 1 {name=p56 sig_type=std_logic lab=DCB_SS}
C {lab_wire.sym} 1280 -1460 0 1 {name=p57 sig_type=std_logic lab=PH1}
C {lab_wire.sym} 1280 -1420 0 1 {name=p58 sig_type=std_logic lab=PH1B}
C {lab_wire.sym} 1280 -1380 0 1 {name=p59 sig_type=std_logic lab=PH2}
C {lab_wire.sym} 1280 -1340 0 1 {name=p60 sig_type=std_logic lab=PH2B}
C {lab_wire.sym} 640 -1080 0 0 {name=p61 sig_type=std_logic lab=PH1}
C {lab_wire.sym} 680 -1080 0 0 {name=p62 sig_type=std_logic lab=PH2}
C {lab_wire.sym} 640 -920 2 1 {name=p63 sig_type=std_logic lab=PH1B}
C {lab_wire.sym} 680 -920 2 1 {name=p64 sig_type=std_logic lab=PH2B}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SCR/SCR.sym} 480 -600 2 1 {name=xSCR2}
C {lab_wire.sym} 600 -360 2 1 {name=p65 sig_type=std_logic lab=DCB_DD}
C {lab_wire.sym} 600 -520 0 0 {name=p66 sig_type=std_logic lab=DCB_SS}
C {lab_wire.sym} 640 -360 2 1 {name=p67 sig_type=std_logic lab=PH1}
C {lab_wire.sym} 680 -360 2 1 {name=p68 sig_type=std_logic lab=PH2}
C {lab_wire.sym} 640 -520 0 0 {name=p69 sig_type=std_logic lab=PH1B}
C {lab_wire.sym} 680 -520 0 0 {name=p70 sig_type=std_logic lab=PH2B}
C {capa.sym} 470 -1160 3 0 {name=CBP
m=25
value=20p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 470 -280 3 1 {name=CBN
m=25
value=20p
footprint=1206
device="ceramic capacitor"}
