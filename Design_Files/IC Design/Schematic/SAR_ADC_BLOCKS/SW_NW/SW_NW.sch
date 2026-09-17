v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 30 -170 30 -110 {lab=VDD}
N 550 -180 550 -110 {lab=VDD}
N 100 -10 160 -10 {lab=db}
N 470 -10 520 -10 {lab=db}
N 620 -10 680 -10 {lab=d}
N 50 70 50 160 {lab=#net1}
N 50 160 570 160 {lab=#net1}
N 570 70 570 160 {lab=#net1}
N -70 -10 0 -10 {lab=d}
N 50 -270 50 -120 {lab=REF_neg}
N 570 -300 570 -160 {lab=REF}
N 350 210 350 290 {lab=VDD}
N 960 220 960 300 {lab=VDD}
N 420 390 490 390 {lab=Sb}
N 220 390 320 390 {lab=S}
N 370 470 370 570 {lab=VOUT}
N 370 570 980 570 {lab=VOUT}
N 980 480 980 570 {lab=VOUT}
N 640 570 640 680 {lab=VOUT}
N 850 400 930 400 {lab=Sb}
N 1030 400 1130 400 {lab=S}
N -40 260 20 260 {lab=d}
N -40 310 20 310 {lab=db}
N -40 360 20 360 {lab=S}
N -40 410 20 410 {lab=Sb}
N -40 470 20 470 {lab=REF_neg}
N -40 520 20 520 {lab=REF}
N -40 570 20 570 {lab=VIN}
N -40 620 20 620 {lab=VOUT}
N -40 680 20 680 {lab=VDD}
N 50 -300 50 -270 {lab=REF_neg}
N 570 -160 570 -110 {lab=REF}
N 370 160 370 290 {lab=#net1}
N 980 30 980 300 {lab=VIN}
N 50 -120 50 -110 {lab=REF_neg}
C {lab_pin.sym} 50 -300 0 0 {name=p1 sig_type=std_logic lab=REF_neg}
C {lab_pin.sym} 30 -170 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 550 -180 0 0 {name=p3 sig_type=std_logic lab=VDD
}
C {lab_pin.sym} 570 -300 0 0 {name=p4 sig_type=std_logic lab=REF}
C {lab_pin.sym} -70 -10 0 0 {name=p5 sig_type=std_logic lab=d}
C {lab_pin.sym} 160 -10 2 0 {name=p6 sig_type=std_logic lab=db}
C {lab_pin.sym} 350 210 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 220 390 0 0 {name=p8 sig_type=std_logic lab=S}
C {lab_pin.sym} 470 -10 0 0 {name=p9 sig_type=std_logic lab=db}
C {lab_pin.sym} 680 -10 2 0 {name=p10 sig_type=std_logic lab=d}
C {lab_pin.sym} 490 390 2 0 {name=p11 sig_type=std_logic lab=Sb}
C {lab_pin.sym} 640 680 0 0 {name=p12 sig_type=std_logic lab=VOUT}
C {lab_pin.sym} 850 400 0 0 {name=p13 sig_type=std_logic lab=Sb}
C {lab_pin.sym} 1130 400 2 0 {name=p14 sig_type=std_logic lab=S}
C {lab_pin.sym} 960 220 0 0 {name=p15 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 980 30 0 0 {name=p16 sig_type=std_logic lab=VIN}
C {ipin.sym} -40 360 0 0 {name=p19 lab=S}
C {ipin.sym} -40 310 0 0 {name=p17 lab=db}
C {ipin.sym} -40 260 0 0 {name=p18 lab=d}
C {ipin.sym} -40 410 0 0 {name=p20 lab=Sb}
C {lab_pin.sym} 20 260 2 0 {name=p21 sig_type=std_logic lab=d
}
C {lab_pin.sym} 20 410 2 0 {name=p23 sig_type=std_logic lab=Sb}
C {lab_pin.sym} 20 360 2 0 {name=p24 sig_type=std_logic lab=S}
C {lab_pin.sym} 20 310 2 0 {name=p25 sig_type=std_logic lab=db}
C {ipin.sym} -40 570 0 0 {name=p22 lab=VIN}
C {ipin.sym} -40 520 0 0 {name=p26 lab=REF}
C {ipin.sym} -40 470 0 0 {name=p27 lab=REF_neg}
C {ipin.sym} -40 620 0 0 {name=p28 lab=VOUT}
C {lab_pin.sym} 20 470 2 0 {name=p29 sig_type=std_logic lab=REF_neg
}
C {lab_pin.sym} 20 620 2 0 {name=p30 sig_type=std_logic lab=VOUT}
C {lab_pin.sym} 20 570 2 0 {name=p31 sig_type=std_logic lab=VIN}
C {lab_pin.sym} 20 520 2 0 {name=p32 sig_type=std_logic lab=REF}
C {ipin.sym} -40 680 0 0 {name=p33 lab=VDD}
C {lab_pin.sym} 20 680 2 0 {name=p34 sig_type=std_logic lab=VDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/TG_SW/TG_SW.sym} 980 400 0 0 {name=xTGSW1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/TG_SW/TG_SW.sym} 370 390 0 0 {name=xTGSW2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/TG_SW/TG_SW.sym} 570 -10 0 0 {name=xTGSW3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/TG_SW/TG_SW.sym} 50 -10 0 0 {name=xTGSW4}
