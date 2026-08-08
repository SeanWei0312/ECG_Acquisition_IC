v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -270 {}
N 260 -880 260 -860 {lab=RST}
N 180 -1000 200 -1000 {lab=INP}
N 180 -920 200 -920 {lab=INN}
N 340 -880 340 -860 {lab=AGND}
N 340 -1060 340 -1040 {lab=AVDD}
N 260 -1060 260 -1040 {lab=REF}
N 400 -1000 420 -1000 {lab=OUTP}
N 400 -920 420 -920 {lab=OUTN}
N 560 -920 560 -900 {lab=AGND}
N 560 -1000 560 -980 {lab=OUTP}
N 640 -920 640 -900 {lab=AGND}
N 640 -1000 640 -980 {lab=OUTN}
N 120 -640 120 -620 {lab=AGND}
N 440 -780 440 -760 {lab=VOS}
N 280 -640 280 -620 {lab=VINCM}
N 440 -700 440 -680 {lab=AGND}
N 280 -560 280 -540 {lab=AGND}
N 120 -780 120 -760 {lab=AVDD}
N 440 -640 440 -620 {lab=RST}
N 440 -560 440 -540 {lab=AGND}
N 280 -780 280 -760 {lab=REF}
N 280 -700 280 -680 {lab=AGND}
N 840 -780 840 -760 {lab=INP}
N 840 -700 840 -680 {lab=VINCM}
N 840 -640 840 -620 {lab=INN}
N 840 -560 840 -540 {lab=VINCM}
N 780 -750 800 -750 {lab=VOS}
N 780 -710 800 -710 {lab=AGND}
N 780 -610 800 -610 {lab=VOS}
N 780 -570 800 -570 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {lab_wire.sym} 260 -860 2 1 {name=p2 sig_type=std_logic lab=RST}
C {lab_wire.sym} 180 -1000 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 180 -920 0 0 {name=p6 sig_type=std_logic lab=INN}
C {devices/code_shown.sym} 80 -450 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.temp 27
.param VDD_SET=3.3
"}
C {devices/code_shown.sym} 80 -270 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(INP)=\{VCM_SET+150m\} v(INN)=\{VCM_SET-150m\}
.nodeset v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
.nodeset v(REF)=\{VCM_SET\}
"}
C {lab_wire.sym} 340 -860 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {devices/code_shown.sym} 1000 -730 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.reset_vos300m.txt

* Reset with 300mV input offset
op
let avdd_run = v(AVDD)-v(AGND)

alter @VRST[PWL] = [ 0 0 50m 0 50.001m $&avdd_run 150m $&avdd_run 150.001m 0 2s 0 ]

tran 100u 2s

let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let idd = -vavdd#branch

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.reset_vos300m.txt v(RST) vin_cm v(INP) v(INN) v(OUTP) v(OUTN) voutcm v(REF) idd

quit
.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/DCB/DCB.sym} 140 -820 0 0 {name=xSEOTA1}
C {lab_wire.sym} 420 -1000 0 1 {name=p5 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 420 -920 0 1 {name=p10 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 260 -1060 0 0 {name=p11 sig_type=std_logic lab=REF}
C {capa.sym} 560 -950 0 0 {name=CLP
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 560 -1000 0 1 {name=p7 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 560 -900 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 640 -950 0 0 {name=CLN
m=1
value=2p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 640 -900 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -1000 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 340 -1060 0 1 {name=p3 sig_type=std_logic lab=AVDD}
C {vsource.sym} 120 -730 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 120 -700 0 0 {name=l5 lab=0}
C {vsource.sym} 120 -590 0 0 {name=VAVSS value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 120 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 120 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {vsource.sym} 440 -730 0 0 {name=VOS  value="dc 300m"            savecurrent=false}
C {vsource.sym} 280 -590 0 0 {name=VCM  value="dc \{VCM_SET\} ac 0"  savecurrent=false}
C {lab_wire.sym} 440 -780 0 0 {name=p14 sig_type=std_logic lab=VOS

}
C {lab_wire.sym} 280 -540 2 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 440 -680 2 0 {name=p17 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 120 -780 0 0 {name=p18 sig_type=std_logic lab=AVDD}
C {vsource.sym} 440 -590 0 0 {name=VRST value="dc 0"               savecurrent=false}
C {lab_wire.sym} 440 -640 0 0 {name=p19 sig_type=std_logic lab=RST
}
C {lab_wire.sym} 440 -540 2 0 {name=p20 sig_type=std_logic lab=AGND}
C {vsource.sym} 280 -730 0 0 {name=VREF value="dc \{VCM_SET\} ac 0"  savecurrent=false}
C {lab_wire.sym} 280 -680 2 0 {name=p30 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 280 -780 0 0 {name=p13 sig_type=std_logic lab=REF}
C {lab_wire.sym} 280 -640 0 0 {name=p15 sig_type=std_logic lab=VINCM}
C {vcvs.sym} 840 -730 0 0 {name=EOSP value=0.5}
C {vcvs.sym} 840 -590 0 0 {name=EOSN value=0.5}
C {lab_wire.sym} 840 -780 0 0 {name=p1 sig_type=std_logic lab=INP}
C {lab_wire.sym} 780 -750 0 0 {name=p12 sig_type=std_logic lab=VOS
}
C {lab_wire.sym} 780 -710 0 0 {name=p21 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 780 -610 0 0 {name=p22 sig_type=std_logic lab=VOS}
C {lab_wire.sym} 780 -570 0 0 {name=p23 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 840 -680 2 0 {name=p24 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 840 -540 2 0 {name=p25 sig_type=std_logic lab=VINCM
}
C {lab_wire.sym} 840 -640 0 0 {name=p26 sig_type=std_logic lab=INN}
