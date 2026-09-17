v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 130 870 160 870 {lab=clk_delay}
N 160 770 160 870 {lab=clk_delay}
N 160 770 180 770 {lab=clk_delay}
N -380 750 180 750 {lab=clk}
N -800 750 -380 750 {lab=clk}
N 350 900 410 900 {lab=#net1}
N 350 760 350 900 {lab=#net1}
N 300 760 350 760 {lab=#net1}
N 610 940 730 940 {lab=#net2}
N 880 940 1090 940 {lab=clk_sample_pre}
N 1370 940 1470 940 {lab=clk_sample_b}
N 1370 760 1370 940 {lab=clk_sample_b}
N 1610 940 1780 940 {lab=clk_sample}
N 1370 760 1780 760 {lab=clk_sample_b}
N -220 790 -220 840 {lab=VDD}
N 30 780 30 830 {lab=VDD}
N -110 860 -20 860 {lab=VCM}
N 220 660 220 710 {lab=VDD}
N 500 820 500 870 {lab=VDD}
N 800 840 800 890 {lab=VDD}
N 1160 840 1160 890 {lab=VDD}
N 1540 840 1540 890 {lab=VDD}
N -1020 1050 -900 1050 {lab=clk}
N -1020 1090 -900 1090 {lab=VDD}
N -1020 1130 -900 1130 {lab=VCM}
N -1030 1230 -910 1230 {lab=clk_sample_b}
N -1030 1270 -910 1270 {lab=clk_sample}
N -380 970 410 970 {lab=clk}
N -380 890 -380 970 {lab=clk}
N -380 750 -380 890 {lab=clk}
N 520 1710 600 1710 {lab=nand2}
N 520 1710 520 1820 {lab=nand2}
N 520 1960 520 2060 {lab=Set_pre}
N 800 1680 860 1680 {lab=#net3}
N 1950 1520 2070 1520 {lab=#net4}
N 2320 1520 2430 1520 {lab=#net5}
N 2140 1420 2140 1470 {lab=VDD}
N 2500 1420 2500 1470 {lab=VDD}
N 1710 1560 1810 1560 {lab=#net6}
N 1880 1380 1880 1430 {lab=VDD}
N 1640 1420 1640 1470 {lab=VDD}
N 930 1580 930 1630 {lab=VDD}
N 690 1560 690 1610 {lab=VDD}
N -160 1660 110 1660 {lab=clk_SAR}
N 420 1890 470 1890 {lab=VDD}
N 1640 1650 1640 1760 {lab=clk_sample}
N 1880 1610 1880 1760 {lab=EOC}
N 1340 1400 1440 1400 {lab=q}
N 1440 1400 1440 1600 {lab=q}
N 1440 1600 1570 1600 {lab=q}
N 1200 1300 1200 1360 {lab=Set_pre}
N 520 2060 600 2060 {lab=Set_pre}
N 1140 1240 1140 1360 {lab=VDD}
N 1000 1680 1200 1680 {lab=Reset}
N 1200 1640 1200 1680 {lab=Reset}
N 2680 1520 2680 2220 {lab=clk_SAR}
N -160 2220 2680 2220 {lab=clk_SAR}
N -160 1660 -160 2220 {lab=clk_SAR}
N -1030 1310 -910 1310 {lab=clk_SAR}
N -1030 1350 -910 1350 {lab=clk_SAR_b}
N 1500 1520 1570 1520 {lab=0}
N 1500 1520 1500 1540 {lab=0}
N 1740 1480 1810 1480 {lab=0}
N 1740 1480 1740 1500 {lab=0}
N -1020 1160 -900 1160 {lab=EOC}
N -1020 1190 -900 1190 {lab=Ready}
N -1030 1400 -910 1400 {lab=clk_sample_pre}
N 380 1640 600 1640 {lab=delay1}
N 970 1400 1060 1400 {lab=VDD}
N 880 1500 1060 1500 {lab=clk_sample}
N 260 1650 380 1650 {lab=delay1}
N 160 1560 160 1610 {lab=VDD}
N 20 1640 110 1640 {lab=VCM}
N 380 1640 380 1650 {lab=delay1}
N 270 1970 270 2020 {lab=VDD}
N 130 2050 220 2050 {lab=VCM}
N 140 2070 220 2070 {lab=Ready}
N 370 2060 520 2060 {lab=Set_pre}
N -300 870 -270 870 {lab=VCM}
N -380 890 -270 890 {lab=clk}
N -120 880 -20 880 {lab=clkpre}
N 1230 940 1370 940 {lab=clk_sample_b}
N 2210 1520 2320 1520 {lab=#net5}
N 2570 1520 2680 1520 {lab=clk_SAR}
N 870 940 880 940 {lab=clk_sample_pre}
N 2800 1520 2810 1520 {lab=clk_SAR}
N 2680 1520 2800 1520 {lab=clk_SAR}
C {lab_pin.sym} -800 750 0 0 {name=p1 sig_type=std_logic lab=clk}
C {lab_pin.sym} -220 790 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 30 780 0 0 {name=p4 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -290 870 0 0 {name=p6 sig_type=std_logic lab=VCM}
C {lab_pin.sym} -50 860 0 0 {name=p7 sig_type=std_logic lab=VCM}
C {lab_pin.sym} 220 660 0 0 {name=p8 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 500 820 0 0 {name=p9 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 800 840 0 0 {name=p10 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1160 840 0 0 {name=p11 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1540 840 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1780 760 0 1 {name=p13 sig_type=std_logic lab=clk_sample_b}
C {lab_pin.sym} 1780 940 0 1 {name=p14 sig_type=std_logic lab=clk_sample}
C {lab_pin.sym} -900 1050 0 1 {name=p15 sig_type=std_logic lab=clk}
C {lab_pin.sym} -900 1090 0 1 {name=p18 sig_type=std_logic lab=VDD}
C {lab_pin.sym} -900 1130 0 1 {name=p16 sig_type=std_logic lab=VCM}
C {lab_pin.sym} -1030 1230 0 0 {name=p19 sig_type=std_logic lab=clk_sample_b}
C {lab_pin.sym} -1030 1270 0 0 {name=p20 sig_type=std_logic lab=clk_sample}
C {opin.sym} -910 1270 0 0 {name=p21 lab=clk_sample}
C {opin.sym} -910 1230 0 0 {name=p22 lab=clk_sample_b}
C {lab_pin.sym} 160 820 0 0 {name=p17 sig_type=std_logic lab=clk_delay}
C {lab_pin.sym} 2140 1420 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 2500 1420 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1880 1380 0 0 {name=p23 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1640 1420 0 0 {name=p25 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 930 1580 0 0 {name=p26 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 690 1560 0 0 {name=p27 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 420 1890 3 0 {name=p35 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1640 1760 0 0 {name=p36 sig_type=std_logic lab=clk_sample}
C {lab_pin.sym} 1880 1760 0 0 {name=p37 sig_type=std_logic lab=EOC}
C {lab_pin.sym} 2780 1520 0 0 {name=p38 sig_type=std_logic lab=clk_SAR}
C {lab_pin.sym} 2380 1520 0 0 {name=p39 sig_type=std_logic lab=clk_SAR_b}
C {lab_pin.sym} 140 2070 0 0 {name=p30 sig_type=std_logic lab=Ready}
C {lab_pin.sym} 1200 1300 0 0 {name=p40 sig_type=std_logic lab=Set_pre}
C {lab_pin.sym} 1140 1240 0 0 {name=p41 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1040 1400 0 0 {name=p42 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 1040 940 0 0 {name=p43 sig_type=std_logic lab=clk_sample_pre}
C {lab_pin.sym} -1030 1310 0 0 {name=p45 sig_type=std_logic lab=clk_SAR}
C {lab_pin.sym} -1030 1350 0 0 {name=p46 sig_type=std_logic lab=clk_SAR_b}
C {opin.sym} -910 1350 0 0 {name=p47 lab=clk_SAR_b}
C {opin.sym} -910 1310 0 0 {name=p48 lab=clk_SAR}
C {gnd.sym} 1500 1540 0 0 {name=l1 lab=0}
C {gnd.sym} 1740 1500 0 0 {name=l5 lab=0}
C {lab_pin.sym} -900 1160 0 1 {name=p49 sig_type=std_logic lab=EOC}
C {lab_pin.sym} -900 1190 0 1 {name=p51 sig_type=std_logic lab=Ready}
C {lab_pin.sym} -1030 1400 0 0 {name=p54 sig_type=std_logic lab=clk_sample_pre}
C {opin.sym} -910 1400 0 0 {name=p55 lab=clk_sample_pre}
C {lab_pin.sym} 1150 1680 0 0 {name=p58 sig_type=std_logic lab=Reset}
C {lab_pin.sym} 1420 1400 0 0 {name=p59 sig_type=std_logic lab=q}
C {lab_pin.sym} 520 1750 3 0 {name=p60 sig_type=std_logic lab=nand2}
C {lab_pin.sym} 160 1560 0 0 {name=p28 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 80 1640 0 0 {name=p29 sig_type=std_logic lab=VCM}
C {lab_pin.sym} 270 1970 0 0 {name=p31 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 190 2050 0 0 {name=p32 sig_type=std_logic lab=VCM}
C {lab_pin.sym} 600 2060 0 0 {name=p33 sig_type=std_logic lab=Set_pre}
C {lab_pin.sym} 480 1640 0 0 {name=p34 sig_type=std_logic lab=delay1}
C {ipin.sym} -1020 1050 0 0 {name=p50 lab=clk}
C {ipin.sym} -1020 1090 0 0 {name=p52 lab=VDD}
C {ipin.sym} -1020 1130 0 0 {name=p53 lab=VCM}
C {ipin.sym} -1020 1160 0 0 {name=p56 lab=EOC}
C {ipin.sym} -1020 1190 0 0 {name=p57 lab=Ready}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/DLY_CELL/DLY_CELL.sym} -120 890 0 0 {name=xDLYCELL_1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/DLY_CELL/DLY_CELL.sym} 130 880 0 0 {name=xDLYCELL_2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/DLY_CELL/DLY_CELL.sym} 260 1660 0 0 {name=xDLYCELL_3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/DLY_CELL/DLY_CELL.sym} 370 2070 0 0 {name=xDLYCELL_4}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/INV/INV.sym} 520 1880 3 0 {name=xINV1_1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/INV/INV.sym} 940 1680 0 0 {name=xINV1_2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/NAND/NAND.sym} 720 1680 0 0 {name=xNAND1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/TSPC_FF/TSPC_FF.sym} 1200 1500 0 0 {name=xTSPCFF1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/MUX/MUX.sym} 1650 1560 0 0 {name=xMUX1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/MUX/MUX.sym} 1890 1520 0 0 {name=xMUX2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/INV/INV.sym} 2150 1520 0 0 {name=xINV1_3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/INV2/INV2.sym} 2400 1520 0 0 {name=xINV2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/XOR/XOR.sym} 230 760 0 0 {name=xXOR1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/NAND/NAND.sym} 530 940 0 0 {name=xNAND2}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/INV/INV.sym} 810 940 0 0 {name=xINV1_4}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/INV/INV.sym} 1170 940 0 0 {name=xINV1_5}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/INV/INV.sym} 1550 940 0 0 {name=xINV1_6}
C {lab_pin.sym} -50 880 0 0 {name=p24 sig_type=std_logic lab=clkpre}
C {lab_pin.sym} 880 1500 0 0 {name=p44 sig_type=std_logic lab=clk_sample}
