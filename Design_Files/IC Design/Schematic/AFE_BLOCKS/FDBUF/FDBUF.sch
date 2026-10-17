v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -520 160 -520 {lab=FDBUF_DD}
N 140 -480 160 -480 {lab=FDBUF_SS}
N 140 -440 160 -440 {lab=FDBUF_INP}
N 140 -400 160 -400 {lab=FDBUF_INN}
N 140 -360 160 -360 {lab=FDBUF_OUTP}
N 140 -280 160 -280 {lab=FDBUF_BFDC}
N 140 -320 160 -320 {lab=FDBUF_OUTN}
N 140 -240 160 -240 {lab=FDBUF_BCMFB}
N 140 -200 160 -200 {lab=FDBUF_REF}
N 560 -400 600 -400 {lab=FDBUF_REF}
N 650 -520 650 -480 {lab=FDBUF_DD}
N 680 -520 680 -480 {lab=FDBUF_BFDC}
N 650 -320 650 -280 {lab=FDBUF_SS}
N 680 -320 680 -280 {lab=FDBUF_BCMFB}
N 760 -400 800 -400 {lab=FDBUF_VOCM}
N 420 -360 460 -360 {lab=FDBUF_INN}
N 420 -440 460 -440 {lab=FDBUF_INP}
N 560 -600 640 -600 {lab=#net1}
N 700 -600 800 -600 {lab=FDBUF_OUTN}
N 700 -200 800 -200 {lab=FDBUF_OUTP}
N 560 -200 640 -200 {lab=#net2}
N 520 -360 600 -360 {lab=#net2}
N 760 -360 840 -360 {lab=FDBUF_OUTP}
N 760 -440 840 -440 {lab=FDBUF_OUTN}
N 520 -440 600 -440 {lab=#net1}
N 560 -600 560 -440 {lab=#net1}
N 560 -360 560 -200 {lab=#net2}
N 800 -360 800 -200 {lab=FDBUF_OUTP}
N 800 -600 800 -440 {lab=FDBUF_OUTN}
N 640 -580 670 -580 {lab=FDBUF_SS}
N 640 -220 670 -220 {lab=FDBUF_SS}
N 460 -420 490 -420 {lab=FDBUF_SS}
N 460 -380 490 -380 {lab=FDBUF_SS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -520 0 1 {name=p8 lab=FDBUF_DD}
C {iopin.sym} 140 -480 0 1 {name=p9 lab=FDBUF_SS}
C {lab_wire.sym} 160 -520 0 1 {name=p11 sig_type=std_logic lab=FDBUF_DD}
C {lab_wire.sym} 160 -480 0 1 {name=p12 sig_type=std_logic lab=FDBUF_SS}
C {ipin.sym} 140 -440 0 0 {name=p13 lab=FDBUF_INP}
C {ipin.sym} 140 -400 0 0 {name=p14 lab=FDBUF_INN}
C {lab_wire.sym} 160 -440 0 1 {name=p15 sig_type=std_logic lab=FDBUF_INP}
C {lab_wire.sym} 160 -400 0 1 {name=p16 sig_type=std_logic lab=FDBUF_INN}
C {opin.sym} 140 -360 0 1 {name=p17 lab=FDBUF_OUTP}
C {lab_wire.sym} 160 -360 0 1 {name=p18 sig_type=std_logic lab=FDBUF_OUTP}
C {iopin.sym} 140 -280 0 1 {name=p1 lab=FDBUF_BFDC}
C {lab_wire.sym} 160 -280 0 1 {name=p19 sig_type=std_logic lab=FDBUF_BFDC}
C {opin.sym} 140 -320 0 1 {name=p23 lab=FDBUF_OUTN}
C {lab_wire.sym} 160 -320 0 1 {name=p24 sig_type=std_logic lab=FDBUF_OUTN}
C {iopin.sym} 140 -240 0 1 {name=p25 lab=FDBUF_BCMFB}
C {lab_wire.sym} 160 -240 0 1 {name=p26 sig_type=std_logic lab=FDBUF_BCMFB}
C {iopin.sym} 140 -200 0 1 {name=p29 lab=FDBUF_REF}
C {lab_wire.sym} 160 -200 0 1 {name=p30 sig_type=std_logic lab=FDBUF_REF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.sym} 520 -260 0 0 {name=xFDOTA1}
C {lab_wire.sym} 650 -280 2 1 {name=p10 sig_type=std_logic lab=FDBUF_SS}
C {lab_wire.sym} 650 -520 0 0 {name=p20 sig_type=std_logic lab=FDBUF_DD}
C {lab_wire.sym} 560 -400 0 0 {name=p33 sig_type=std_logic lab=FDBUF_REF}
C {lab_wire.sym} 800 -400 0 1 {name=p36 sig_type=std_logic lab=FDBUF_VOCM}
C {lab_wire.sym} 680 -280 2 0 {name=p39 sig_type=std_logic lab=FDBUF_BCMFB}
C {lab_wire.sym} 680 -520 0 1 {name=p40 sig_type=std_logic lab=FDBUF_BFDC}
C {lab_wire.sym} 840 -440 0 1 {name=p43 sig_type=std_logic lab=FDBUF_OUTN}
C {lab_wire.sym} 840 -360 2 0 {name=p44 sig_type=std_logic lab=FDBUF_OUTP}
C {lab_wire.sym} 420 -440 0 0 {name=p55 sig_type=std_logic lab=FDBUF_INP}
C {lab_wire.sym} 420 -360 2 1 {name=p56 sig_type=std_logic lab=FDBUF_INN}
C {symbols/ppolyf_u_2k.sym} 670 -600 1 1 {name=RFBP
W=2e-6
L=20e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_2k.sym} 670 -200 1 0 {name=RFBN
W=2e-6
L=20e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {lab_wire.sym} 640 -580 2 1 {name=p2 sig_type=std_logic lab=FDBUF_SS}
C {lab_wire.sym} 640 -220 0 0 {name=p3 sig_type=std_logic lab=FDBUF_SS}
C {symbols/ppolyf_u_2k.sym} 490 -440 1 1 {name=RINP
W=2e-6
L=20e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {lab_wire.sym} 460 -420 2 1 {name=p4 sig_type=std_logic lab=FDBUF_SS}
C {symbols/ppolyf_u_2k.sym} 490 -360 1 0 {name=RINN
W=2e-6
L=20e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {lab_wire.sym} 460 -380 0 0 {name=RINN1 sig_type=std_logic lab=FDBUF_SS}
