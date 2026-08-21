v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -520 160 -520 {lab=RLD_DD}
N 140 -480 160 -480 {lab=RLD_SS}
N 140 -440 160 -440 {lab=RLD_INP}
N 140 -400 160 -400 {lab=RLD_INN}
N 140 -360 160 -360 {lab=RLD_OUT}
N 400 -560 400 -480 {lab=#net1}
N 400 -660 400 -620 {lab=RLD_INP}
N 400 -420 400 -380 {lab=RLD_INN}
N 600 -560 640 -560 {lab=RLD_BSE}
N 600 -600 640 -600 {lab=RLD_REF}
N 720 -680 720 -640 {lab=RLD_DD}
N 720 -480 720 -440 {lab=RLD_SS}
N 400 -520 640 -520 {lab=#net1}
N 140 -320 160 -320 {lab=RLD_BSE}
N 140 -280 160 -280 {lab=RLD_REF}
N 800 -560 880 -560 {lab=RLD_OUT}
N 840 -560 840 -200 {lab=RLD_OUT}
N 600 -520 600 -200 {lab=#net1}
N 360 -590 380 -590 {lab=RLD_SS}
N 360 -450 380 -450 {lab=RLD_SS}
N 720 -260 720 -240 {lab=RLD_SS}
N 750 -200 840 -200 {lab=RLD_OUT}
N 600 -200 690 -200 {lab=#net1}
N 750 -280 840 -280 {lab=RLD_OUT}
N 600 -280 690 -280 {lab=#net1}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -520 0 1 {name=p8 lab=RLD_DD}
C {iopin.sym} 140 -480 0 1 {name=p9 lab=RLD_SS}
C {lab_wire.sym} 160 -520 0 1 {name=p11 sig_type=std_logic lab=RLD_DD}
C {lab_wire.sym} 160 -480 0 1 {name=p12 sig_type=std_logic lab=RLD_SS}
C {ipin.sym} 140 -440 0 0 {name=p13 lab=RLD_INP}
C {ipin.sym} 140 -400 0 0 {name=p14 lab=RLD_INN}
C {lab_wire.sym} 160 -440 0 1 {name=p15 sig_type=std_logic lab=RLD_INP}
C {lab_wire.sym} 160 -400 0 1 {name=p16 sig_type=std_logic lab=RLD_INN}
C {opin.sym} 140 -360 0 1 {name=p37 lab=RLD_OUT}
C {lab_wire.sym} 160 -360 0 1 {name=p39 sig_type=std_logic lab=RLD_OUT}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 560 -420 0 0 {name=xSEOTA1}
C {lab_wire.sym} 720 -440 2 1 {name=p1 sig_type=std_logic lab=RLD_SS}
C {lab_wire.sym} 720 -680 0 0 {name=p2 sig_type=std_logic lab=RLD_DD}
C {lab_wire.sym} 400 -660 0 0 {name=p3 sig_type=std_logic lab=RLD_INP}
C {lab_wire.sym} 400 -380 2 1 {name=p4 sig_type=std_logic lab=RLD_INN}
C {lab_wire.sym} 880 -560 0 1 {name=p5 sig_type=std_logic lab=RLD_OUT}
C {lab_wire.sym} 600 -600 0 0 {name=p6 sig_type=std_logic lab=RLD_REF}
C {iopin.sym} 140 -320 0 1 {name=p25 lab=RLD_BSE}
C {lab_wire.sym} 160 -320 0 1 {name=p26 sig_type=std_logic lab=RLD_BSE}
C {iopin.sym} 140 -280 0 1 {name=p29 lab=RLD_REF}
C {lab_wire.sym} 160 -280 0 1 {name=p30 sig_type=std_logic lab=RLD_REF}
C {lab_wire.sym} 600 -560 0 0 {name=p7 sig_type=std_logic lab=RLD_BSE}
C {symbols/ppolyf_u_2k.sym} 400 -590 0 0 {name=RRLDP
W=2e-6
L=4000e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_2k.sym} 400 -450 2 1 {name=RRLDN
W=2e-6
L=4000e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {lab_wire.sym} 360 -590 0 0 {name=p10 sig_type=std_logic lab=RLD_SS}
C {lab_wire.sym} 360 -450 2 1 {name=p17 sig_type=std_logic lab=RLD_SS}
C {symbols/ppolyf_u_2k.sym} 720 -280 3 0 {name=RRLDF1
W=2e-6
L=10000e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {lab_wire.sym} 720 -240 0 0 {name=p18 sig_type=std_logic lab=RLD_SS}
C {symbols/cap_mim_2f0fF.sym} 720 -200 1 0 {name=CRLDF
W=100e-6
L=100e-6
model=cap_mim_2f0fF
spiceprefix=X
m=4}
