v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -500 160 -500 {lab=SCR_DD}
N 140 -460 160 -460 {lab=SCR_SS}
N 140 -340 160 -340 {lab=SCR_PH1}
N 140 -420 160 -420 {lab=SCR_A}
N 140 -380 160 -380 {lab=SCR_B}
N 140 -300 160 -300 {lab=SCR_PH1B}
N 140 -260 160 -260 {lab=SCR_PH2}
N 140 -220 160 -220 {lab=SCR_PH2B}
N 560 -260 560 -220 {lab=SCR_B}
N 560 -360 560 -320 {lab=#net1}
N 520 -360 600 -360 {lab=#net1}
N 360 -360 400 -360 {lab=SCR_A}
N 560 -220 760 -220 {lab=SCR_B}
N 760 -360 760 -220 {lab=SCR_B}
N 720 -360 800 -360 {lab=SCR_B}
N 480 -440 480 -400 {lab=SCR_PH1}
N 480 -320 480 -280 {lab=SCR_PH1B}
N 680 -440 680 -400 {lab=SCR_PH2}
N 680 -320 680 -280 {lab=SCR_PH2B}
N 440 -440 440 -400 {lab=SCR_DD}
N 640 -440 640 -400 {lab=SCR_DD}
N 640 -320 640 -280 {lab=SCR_SS}
N 440 -320 440 -280 {lab=SCR_SS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -500 0 1 {name=p8 lab=SCR_DD}
C {iopin.sym} 140 -460 0 1 {name=p9 lab=SCR_SS}
C {lab_wire.sym} 160 -500 0 1 {name=p11 sig_type=std_logic lab=SCR_DD}
C {lab_wire.sym} 160 -460 0 1 {name=p12 sig_type=std_logic lab=SCR_SS}
C {ipin.sym} 140 -340 0 0 {name=p13 lab=SCR_PH1}
C {lab_wire.sym} 160 -340 0 1 {name=p15 sig_type=std_logic lab=SCR_PH1}
C {iopin.sym} 140 -420 0 1 {name=p3 lab=SCR_A}
C {iopin.sym} 140 -380 0 1 {name=p4 lab=SCR_B}
C {lab_wire.sym} 160 -420 0 1 {name=p5 sig_type=std_logic lab=SCR_A}
C {lab_wire.sym} 160 -380 0 1 {name=p6 sig_type=std_logic lab=SCR_B}
C {ipin.sym} 140 -300 0 0 {name=p1 lab=SCR_PH1B}
C {lab_wire.sym} 160 -300 0 1 {name=p2 sig_type=std_logic lab=SCR_PH1B}
C {ipin.sym} 140 -260 0 0 {name=p7 lab=SCR_PH2}
C {lab_wire.sym} 160 -260 0 1 {name=p10 sig_type=std_logic lab=SCR_PH2}
C {ipin.sym} 140 -220 0 0 {name=p14 lab=SCR_PH2B}
C {lab_wire.sym} 160 -220 0 1 {name=p16 sig_type=std_logic lab=SCR_PH2B}
C {capa.sym} 560 -290 0 0 {name=CSW
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 320 -260 0 0 {name=xTG1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 520 -260 0 0 {name=xTG2}
C {lab_wire.sym} 360 -360 0 0 {name=p17 sig_type=std_logic lab=SCR_A}
C {lab_wire.sym} 800 -360 0 1 {name=p18 sig_type=std_logic lab=SCR_B}
C {lab_wire.sym} 440 -440 0 0 {name=p19 sig_type=std_logic lab=SCR_DD}
C {lab_wire.sym} 440 -280 2 1 {name=p20 sig_type=std_logic lab=SCR_SS}
C {lab_wire.sym} 640 -280 2 1 {name=p21 sig_type=std_logic lab=SCR_SS}
C {lab_wire.sym} 640 -440 0 0 {name=p22 sig_type=std_logic lab=SCR_DD}
C {lab_wire.sym} 480 -440 0 1 {name=p23 sig_type=std_logic lab=SCR_PH1}
C {lab_wire.sym} 680 -440 0 1 {name=p24 sig_type=std_logic lab=SCR_PH2}
C {lab_wire.sym} 680 -280 2 0 {name=p25 sig_type=std_logic lab=SCR_PH2B}
C {lab_wire.sym} 480 -280 2 0 {name=p26 sig_type=std_logic lab=SCR_PH1B}
