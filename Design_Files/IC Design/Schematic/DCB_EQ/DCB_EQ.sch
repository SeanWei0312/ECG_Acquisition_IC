v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 140 -680 160 -680 {lab=DCBEQ_DD}
N 140 -640 160 -640 {lab=DCBEQ_SS}
N 140 -600 160 -600 {lab=DCBEQ_INP}
N 140 -560 160 -560 {lab=DCBEQ_INN}
N 140 -520 160 -520 {lab=DCBEQ_OUTP}
N 140 -480 160 -480 {lab=DCBEQ_OUTN}
N 380 -720 420 -720 {lab=DCBEQ_INP}
N 390 -400 430 -400 {lab=DCBEQ_INN}
N 140 -440 160 -440 {lab=DCBEQ_REF}
N 520 -640 560 -640 {lab=DCBEQ_OUTP}
N 520 -480 560 -480 {lab=DCBEQ_OUTN}
N 620 -640 660 -640 {lab=DCBEQ_REF}
N 620 -480 660 -480 {lab=DCBEQ_REF}
N 660 -640 660 -480 {lab=DCBEQ_REF}
N 480 -720 700 -720 {lab=DCBEQ_OUTP}
N 490 -400 710 -400 {lab=DCBEQ_OUTN}
N 520 -480 520 -400 {lab=DCBEQ_OUTN}
N 520 -720 520 -640 {lab=DCBEQ_OUTP}
N 380 -560 660 -560 {lab=DCBEQ_REF}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {iopin.sym} 140 -680 0 1 {name=p8 lab=DCBEQ_DD}
C {iopin.sym} 140 -640 0 1 {name=p9 lab=DCBEQ_SS}
C {lab_wire.sym} 160 -680 0 1 {name=p11 sig_type=std_logic lab=DCBEQ_DD}
C {lab_wire.sym} 160 -640 0 1 {name=p12 sig_type=std_logic lab=DCBEQ_SS}
C {ipin.sym} 140 -600 0 0 {name=p13 lab=DCBEQ_INP}
C {ipin.sym} 140 -560 0 0 {name=p14 lab=DCBEQ_INN}
C {lab_wire.sym} 160 -600 0 1 {name=p15 sig_type=std_logic lab=DCBEQ_INP}
C {lab_wire.sym} 160 -560 0 1 {name=p16 sig_type=std_logic lab=DCBEQ_INN}
C {opin.sym} 140 -520 0 1 {name=p17 lab=DCBEQ_OUTP}
C {lab_wire.sym} 160 -520 0 1 {name=p18 sig_type=std_logic lab=DCBEQ_OUTP}
C {opin.sym} 140 -480 0 1 {name=p23 lab=DCBEQ_OUTN}
C {lab_wire.sym} 160 -480 0 1 {name=p24 sig_type=std_logic lab=DCBEQ_OUTN}
C {lab_wire.sym} 380 -720 0 0 {name=p5 sig_type=std_logic lab=DCBEQ_INP}
C {lab_wire.sym} 390 -400 2 1 {name=p10 sig_type=std_logic lab=DCBEQ_INN}
C {capa.sym} 450 -720 3 0 {name=CBP
m=25
value=20p
footprint=1206
device="ceramic capacitor"}
C {capa.sym} 460 -400 3 1 {name=CBN
m=25
value=20p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 380 -560 0 0 {name=p1 sig_type=std_logic lab=DCBEQ_REF}
C {iopin.sym} 140 -440 0 1 {name=p2 lab=DCBEQ_REF}
C {lab_wire.sym} 160 -440 0 1 {name=p3 sig_type=std_logic lab=DCBEQ_REF}
C {res.sym} 590 -640 3 0 {name=REQP
value=20G
footprint=1206
device=resistor
m=1}
C {res.sym} 590 -480 3 1 {name=REQN
value=20G
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 700 -720 0 1 {name=p4 sig_type=std_logic lab=DCBEQ_OUTP}
C {lab_wire.sym} 710 -400 2 0 {name=p6 sig_type=std_logic lab=DCBEQ_OUTN}
