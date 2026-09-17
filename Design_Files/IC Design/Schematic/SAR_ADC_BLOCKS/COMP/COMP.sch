v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -110 100 -20 100 {lab=saoutp}
N -20 100 -20 110 {lab=saoutp}
N -110 140 -20 140 {lab=saoutn}
N -20 130 -20 140 {lab=saoutn}
N -70 -10 10 -10 {lab=saoutp}
N -70 -10 -70 100 {lab=saoutp}
N -60 10 10 10 {lab=saoutn}
N -60 10 -60 140 {lab=saoutn}
N 130 0 160 0 {lab=ready}
N 170 110 200 110 {lab=outp}
N 170 130 200 130 {lab=outn}
N -270 90 -240 90 {lab=inp}
N -270 150 -240 150 {lab=inn}
N -180 180 -180 210 {lab=clkc}
N -180 30 -180 60 {lab=VDD}
N 80 40 80 70 {lab=VDD}
N 50 -80 50 -50 {lab=VDD}
C {ipin.sym} 50 -80 0 0 {name=p1 lab=VDD}
C {ipin.sym} -270 90 0 0 {name=p2 lab=inp}
C {ipin.sym} -270 150 0 0 {name=p3 lab=inn}
C {opin.sym} 200 110 0 0 {name=p4 lab=outp}
C {opin.sym} 200 130 0 0 {name=p5 lab=outn}
C {ipin.sym} -180 210 3 0 {name=p6 lab=clkc}
C {lab_pin.sym} -180 30 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 80 40 2 0 {name=p8 sig_type=std_logic lab=VDD}
C {opin.sym} 160 0 0 0 {name=p9 lab=ready}
C {lab_pin.sym} -40 140 0 0 {name=p14 sig_type=std_logic lab=saoutn}
C {lab_pin.sym} -30 100 0 0 {name=p15 sig_type=std_logic lab=saoutp}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/XOR/XOR.sym} 60 0 0 0 {name=xXOR1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/RS_LATCH/RS_LATCH.sym} 90 120 0 0 {name=xRSLATCH1}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SAR_ADC_BLOCKS/SA_LATCH/SA_LATCH.sym} -130 120 0 0 {name=xSALATCH1}
