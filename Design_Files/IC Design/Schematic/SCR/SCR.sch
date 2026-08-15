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
N 560 -460 560 -420 {lab=#net1}
N 560 -560 560 -520 {lab=#net2}
N 520 -560 600 -560 {lab=#net2}
N 360 -560 400 -560 {lab=SCR_A}
N 720 -560 800 -560 {lab=SCR_B}
N 480 -640 480 -600 {lab=SCR_PH1}
N 480 -520 480 -480 {lab=SCR_PH1B}
N 680 -640 680 -600 {lab=SCR_PH2}
N 680 -520 680 -480 {lab=SCR_PH2B}
N 440 -640 440 -600 {lab=SCR_DD}
N 640 -640 640 -600 {lab=SCR_DD}
N 640 -520 640 -480 {lab=SCR_SS}
N 440 -520 440 -480 {lab=SCR_SS}
N 560 -360 560 -320 {lab=#net3}
N 560 -260 560 -220 {lab=#net4}
N 760 -460 760 -420 {lab=#net5}
N 760 -560 760 -520 {lab=SCR_B}
N 760 -360 760 -320 {lab=#net6}
N 760 -260 760 -220 {lab=#net7}
N 760 -160 760 -120 {lab=#net8}
N 560 -120 760 -120 {lab=#net8}
N 560 -160 560 -120 {lab=#net8}
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
C {capa.sym} 560 -490 0 0 {name=CSW1
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 320 -460 0 0 {name=xTG1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 520 -460 0 0 {name=xTG2}
C {lab_wire.sym} 360 -560 0 0 {name=p17 sig_type=std_logic lab=SCR_A}
C {lab_wire.sym} 800 -560 0 1 {name=p18 sig_type=std_logic lab=SCR_B}
C {lab_wire.sym} 440 -640 0 0 {name=p19 sig_type=std_logic lab=SCR_DD}
C {lab_wire.sym} 440 -480 2 1 {name=p20 sig_type=std_logic lab=SCR_SS}
C {lab_wire.sym} 640 -480 2 1 {name=p21 sig_type=std_logic lab=SCR_SS}
C {lab_wire.sym} 640 -640 0 0 {name=p22 sig_type=std_logic lab=SCR_DD}
C {lab_wire.sym} 480 -640 0 1 {name=p23 sig_type=std_logic lab=SCR_PH1}
C {lab_wire.sym} 680 -640 0 1 {name=p24 sig_type=std_logic lab=SCR_PH2}
C {lab_wire.sym} 680 -480 2 0 {name=p25 sig_type=std_logic lab=SCR_PH2B}
C {lab_wire.sym} 480 -480 2 0 {name=p26 sig_type=std_logic lab=SCR_PH1B}
C {capa.sym} 560 -390 0 0 {name=CSW2
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 560 -290 0 0 {name=CSW3
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 560 -190 0 0 {name=CSW4
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 760 -490 0 0 {name=CSW5
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 760 -390 0 0 {name=CSW6
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 760 -290 0 0 {name=CSW7
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 760 -190 0 0 {name=CSW8
m=1
value=100f
footprint=1206
device="ceramic capacitor"}
