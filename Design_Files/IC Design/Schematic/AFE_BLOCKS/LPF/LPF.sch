v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -640 160 -640 {lab=LPF_DD}
N 140 -600 160 -600 {lab=LPF_SS}
N 140 -560 160 -560 {lab=LPF_INP}
N 140 -520 160 -520 {lab=LPF_INN}
N 140 -480 160 -480 {lab=LPF_OUTP}
N 140 -400 160 -400 {lab=LPF_BFDC}
N 140 -440 160 -440 {lab=LPF_OUTN}
N 140 -360 160 -360 {lab=LPF_BCMFB}
N 140 -320 160 -320 {lab=LPF_REF}
N 500 -480 540 -480 {lab=LPF_REF}
N 590 -600 590 -560 {lab=LPF_DD}
N 620 -600 620 -560 {lab=LPF_BFDC}
N 590 -400 590 -360 {lab=LPF_SS}
N 620 -400 620 -360 {lab=LPF_BCMFB}
N 700 -480 740 -480 {lab=LPF_VOCM}
N 360 -440 400 -440 {lab=LPF_INN}
N 360 -520 400 -520 {lab=LPF_INP}
N 460 -440 540 -440 {lab=#net1}
N 700 -440 780 -440 {lab=LPF_OUTP}
N 700 -520 780 -520 {lab=LPF_OUTN}
N 460 -520 540 -520 {lab=#net2}
N 500 -800 500 -520 {lab=#net2}
N 740 -800 740 -520 {lab=LPF_OUTN}
N 500 -440 500 -160 {lab=#net1}
N 740 -440 740 -160 {lab=LPF_OUTP}
N 500 -800 580 -800 {lab=#net2}
N 640 -800 740 -800 {lab=LPF_OUTN}
N 500 -680 580 -680 {lab=#net2}
N 640 -680 740 -680 {lab=LPF_OUTN}
N 400 -500 430 -500 {lab=LPF_SS}
N 580 -660 610 -660 {lab=LPF_SS}
N 400 -460 430 -460 {lab=LPF_SS}
N 500 -160 580 -160 {lab=#net1}
N 640 -160 740 -160 {lab=LPF_OUTP}
N 500 -280 580 -280 {lab=#net1}
N 640 -280 740 -280 {lab=LPF_OUTP}
N 580 -300 610 -300 {lab=LPF_SS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -640 0 1 {name=p8 lab=LPF_DD}
C {iopin.sym} 140 -600 0 1 {name=p9 lab=LPF_SS}
C {lab_wire.sym} 160 -640 0 1 {name=p11 sig_type=std_logic lab=LPF_DD}
C {lab_wire.sym} 160 -600 0 1 {name=p12 sig_type=std_logic lab=LPF_SS}
C {ipin.sym} 140 -560 0 0 {name=p13 lab=LPF_INP}
C {ipin.sym} 140 -520 0 0 {name=p14 lab=LPF_INN}
C {lab_wire.sym} 160 -560 0 1 {name=p15 sig_type=std_logic lab=LPF_INP}
C {lab_wire.sym} 160 -520 0 1 {name=p16 sig_type=std_logic lab=LPF_INN}
C {opin.sym} 140 -480 0 1 {name=p17 lab=LPF_OUTP}
C {lab_wire.sym} 160 -480 0 1 {name=p18 sig_type=std_logic lab=LPF_OUTP}
C {iopin.sym} 140 -400 0 1 {name=p1 lab=LPF_BFDC}
C {lab_wire.sym} 160 -400 0 1 {name=p19 sig_type=std_logic lab=LPF_BFDC}
C {opin.sym} 140 -440 0 1 {name=p23 lab=LPF_OUTN}
C {lab_wire.sym} 160 -440 0 1 {name=p24 sig_type=std_logic lab=LPF_OUTN}
C {iopin.sym} 140 -360 0 1 {name=p25 lab=LPF_BCMFB}
C {lab_wire.sym} 160 -360 0 1 {name=p26 sig_type=std_logic lab=LPF_BCMFB}
C {iopin.sym} 140 -320 0 1 {name=p29 lab=LPF_REF}
C {lab_wire.sym} 160 -320 0 1 {name=p30 sig_type=std_logic lab=LPF_REF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.sym} 460 -340 0 0 {name=xFDOTA1}
C {lab_wire.sym} 590 -360 2 1 {name=p10 sig_type=std_logic lab=LPF_SS}
C {lab_wire.sym} 590 -600 0 0 {name=p20 sig_type=std_logic lab=LPF_DD}
C {lab_wire.sym} 500 -480 0 0 {name=p33 sig_type=std_logic lab=LPF_REF}
C {lab_wire.sym} 740 -480 0 1 {name=p36 sig_type=std_logic lab=LPF_VOCM}
C {lab_wire.sym} 620 -360 2 0 {name=p39 sig_type=std_logic lab=LPF_BCMFB}
C {lab_wire.sym} 620 -600 0 1 {name=p40 sig_type=std_logic lab=LPF_BFDC}
C {lab_wire.sym} 780 -520 0 1 {name=p43 sig_type=std_logic lab=LPF_OUTN}
C {lab_wire.sym} 780 -440 2 0 {name=p44 sig_type=std_logic lab=LPF_OUTP}
C {lab_wire.sym} 360 -520 0 0 {name=p55 sig_type=std_logic lab=LPF_INP}
C {lab_wire.sym} 360 -440 2 1 {name=p56 sig_type=std_logic lab=LPF_INN}
C {symbols/ppolyf_u_2k.sym} 610 -680 3 0 {name=RFBP
W=1e-6
L=2500e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 610 -800 3 0 {name=CLPFP
W=75e-6
L=100e-6
model=cap_mim_2f0fF
spiceprefix=X
m=4}
C {lab_wire.sym} 580 -660 2 1 {name=p2 sig_type=std_logic lab=LPF_SS}
C {symbols/ppolyf_u_2k.sym} 430 -520 3 0 {name=RINP
W=1e-6
L=2500e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {lab_wire.sym} 400 -500 2 1 {name=p3 sig_type=std_logic lab=LPF_SS}
C {symbols/ppolyf_u_2k.sym} 430 -440 3 1 {name=RINN
W=1e-6
L=2500e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {lab_wire.sym} 400 -460 0 0 {name=RINN1 sig_type=std_logic lab=LPF_SS}
C {symbols/ppolyf_u_2k.sym} 610 -280 3 1 {name=RFBN
W=1e-6
L=2500e-6
model=ppolyf_u_2k
spiceprefix=X
m=1}
C {symbols/cap_mim_2f0fF.sym} 610 -160 3 1 {name=CLPFN
W=75e-6
L=100e-6
model=cap_mim_2f0fF
spiceprefix=X
m=4}
C {lab_wire.sym} 580 -300 0 0 {name=p4 sig_type=std_logic lab=LPF_SS}
