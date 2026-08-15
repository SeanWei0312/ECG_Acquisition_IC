v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -440 160 -440 {lab=SW_DD}
N 140 -400 160 -400 {lab=SW_SS}
N 140 -360 160 -360 {lab=SW_INT}
N 140 -280 160 -280 {lab=SW_OUT}
N 140 -320 160 -320 {lab=SW_EXT}
N 140 -240 160 -240 {lab=SW_SEL}
N 740 -400 780 -400 {lab=#net1}
N 900 -400 940 -400 {lab=SW_OUT}
N 860 -460 860 -440 {lab=SW_SEL}
N 860 -360 860 -340 {lab=SWB}
N 820 -360 820 -340 {lab=SW_SS}
N 820 -460 820 -440 {lab=SW_DD}
N 740 -240 780 -240 {lab=SW_EXT}
N 900 -240 940 -240 {lab=SW_OUT}
N 860 -300 860 -280 {lab=SWB}
N 860 -200 860 -180 {lab=SW_SEL}
N 820 -200 820 -180 {lab=SW_SS}
N 820 -300 820 -280 {lab=SW_DD}
N 940 -400 940 -240 {lab=SW_OUT}
N 940 -320 980 -320 {lab=SW_OUT}
N 520 -380 520 -340 {lab=SW_DD}
N 520 -260 520 -220 {lab=SW_SS}
N 580 -300 620 -300 {lab=SWB}
N 440 -300 480 -300 {lab=SW_SEL}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -440 0 1 {name=p8 lab=SW_DD}
C {iopin.sym} 140 -400 0 1 {name=p9 lab=SW_SS}
C {lab_wire.sym} 160 -440 0 1 {name=p11 sig_type=std_logic lab=SW_DD}
C {lab_wire.sym} 160 -400 0 1 {name=p12 sig_type=std_logic lab=SW_SS}
C {ipin.sym} 140 -360 0 0 {name=p13 lab=SW_INT}
C {lab_wire.sym} 160 -360 0 1 {name=p15 sig_type=std_logic lab=SW_INT}
C {iopin.sym} 140 -280 0 1 {name=p17 lab=SW_OUT}
C {lab_wire.sym} 160 -280 0 1 {name=p18 sig_type=std_logic lab=SW_OUT}
C {lab_wire.sym} 520 -380 0 1 {name=p3 sig_type=std_logic lab=SW_DD}
C {lab_wire.sym} 520 -220 2 0 {name=p4 sig_type=std_logic lab=SW_SS}
C {lab_wire.sym} 440 -300 0 0 {name=p1 sig_type=std_logic lab=SW_SEL}
C {lab_wire.sym} 620 -300 0 1 {name=p6 sig_type=std_logic lab=SWB}
C {lab_wire.sym} 860 -460 0 1 {name=p7 sig_type=std_logic lab=SW_SEL}
C {lab_wire.sym} 740 -400 0 0 {name=p33 sig_type=std_logic lab=SW_INT}
C {lab_wire.sym} 980 -320 0 1 {name=p36 sig_type=std_logic lab=SW_OUT}
C {ipin.sym} 140 -320 0 0 {name=p37 lab=SW_EXT}
C {lab_wire.sym} 160 -320 0 1 {name=p39 sig_type=std_logic lab=SW_EXT}
C {lab_wire.sym} 740 -240 0 0 {name=p42 sig_type=std_logic lab=SW_EXT}
C {ipin.sym} 140 -240 0 0 {name=p19 lab=SW_SEL}
C {lab_wire.sym} 160 -240 0 1 {name=p31 sig_type=std_logic lab=SW_SEL}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/INV/INV.sym} 400 -200 0 0 {name=xINV1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 700 -300 0 0 {name=xTG1}
C {lab_wire.sym} 860 -340 2 0 {name=p2 sig_type=std_logic lab=SWB}
C {lab_wire.sym} 820 -460 0 0 {name=p5 sig_type=std_logic lab=SW_DD}
C {lab_wire.sym} 820 -340 2 1 {name=p10 sig_type=std_logic lab=SW_SS}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/TG/TG.sym} 700 -140 0 0 {name=xTG2}
C {lab_wire.sym} 820 -300 0 0 {name=p22 sig_type=std_logic lab=SW_DD}
C {lab_wire.sym} 820 -180 2 1 {name=p25 sig_type=std_logic lab=SW_SS}
C {lab_wire.sym} 860 -180 2 0 {name=p30 sig_type=std_logic lab=SW_SEL}
C {lab_wire.sym} 860 -300 0 1 {name=p32 sig_type=std_logic lab=SWB}
