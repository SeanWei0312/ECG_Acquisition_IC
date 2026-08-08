v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -270 {}
N 180 -1000 200 -1000 {lab=INP}
N 180 -920 200 -920 {lab=INN}
N 240 -640 240 -620 {lab=AGND}
N 560 -780 560 -760 {lab=VOS}
N 400 -640 400 -620 {lab=VINCM}
N 560 -700 560 -680 {lab=AGND}
N 400 -560 400 -540 {lab=AGND}
N 300 -880 300 -860 {lab=AGND}
N 300 -1060 300 -1040 {lab=AVDD}
N 400 -1000 420 -1000 {lab=OUTP}
N 400 -920 420 -920 {lab=OUTN}
N 240 -780 240 -760 {lab=AVDD}
N 560 -920 560 -900 {lab=AGND}
N 560 -1000 560 -980 {lab=OUTP}
N 640 -920 640 -900 {lab=AGND}
N 640 -1000 640 -980 {lab=OUTN}
N 400 -780 400 -760 {lab=REF}
N 400 -700 400 -680 {lab=AGND}
N 960 -780 960 -760 {lab=NIP1}
N 960 -700 960 -680 {lab=VINCM}
N 960 -640 960 -620 {lab=INP}
N 960 -560 960 -540 {lab=NIP1}
N 900 -750 920 -750 {lab=VOS}
N 900 -710 920 -710 {lab=AGND}
N 900 -610 920 -610 {lab=VECG}
N 900 -570 920 -570 {lab=VECG}
N 720 -780 720 -760 {lab=VECG}
N 720 -700 720 -680 {lab=AGND}
N 1200 -780 1200 -760 {lab=NIN1}
N 1200 -700 1200 -680 {lab=VINCM}
N 1200 -640 1200 -620 {lab=INN}
N 1200 -560 1200 -540 {lab=NIN1}
N 1140 -750 1160 -750 {lab=VOS}
N 1140 -710 1160 -710 {lab=AGND}
N 1140 -610 1160 -610 {lab=VECG}
N 1140 -570 1160 -570 {lab=AGND}
N 180 -960 200 -960 {lab=REF}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vsource.sym} 240 -730 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 240 -700 0 0 {name=l5 lab=0}
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
C {devices/code_shown.sym} 80 -300 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}
.param VOS_SET=0
.param ECGAMP_SET=0.5m

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(INP)=\{VCM_SET\} v(INN)=\{VCM_SET\}
.nodeset v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
.nodeset v(REF)=\{VCM_SET\}
"}
C {vsource.sym} 240 -590 0 0 {name=VAVSS value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 240 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 240 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 300 -860 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {devices/code_shown.sym} 1290 -1260 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p100m_ecg0p5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p300m_ecg0p5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p500m_ecg0p5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n100m_ecg0p5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n300m_ecg0p5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n500m_ecg0p5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p100m_ecg5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p300m_ecg5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p500m_ecg5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n100m_ecg5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n300m_ecg5m.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n500m_ecg5m.txt

* +100m 0.5m
alterparam VOS_SET=100m
alterparam ECGAMP_SET=0.5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p100m_ecg0p5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* +300m 0.5m
alterparam VOS_SET=300m
alterparam ECGAMP_SET=0.5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p300m_ecg0p5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* +500m 0.5m
alterparam VOS_SET=500m
alterparam ECGAMP_SET=0.5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p500m_ecg0p5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* -100m 0.5m
alterparam VOS_SET=-100m
alterparam ECGAMP_SET=0.5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n100m_ecg0p5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* -300m 0.5m
alterparam VOS_SET=-300m
alterparam ECGAMP_SET=0.5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n300m_ecg0p5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* -500m 0.5m
alterparam VOS_SET=-500m
alterparam ECGAMP_SET=0.5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n500m_ecg0p5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* +100m 5m
alterparam VOS_SET=100m
alterparam ECGAMP_SET=5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p100m_ecg5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* +300m 5m
alterparam VOS_SET=300m
alterparam ECGAMP_SET=5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p300m_ecg5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* +500m 5m
alterparam VOS_SET=500m
alterparam ECGAMP_SET=5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_p500m_ecg5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* -100m 5m
alterparam VOS_SET=-100m
alterparam ECGAMP_SET=5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n100m_ecg5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* -300m 5m
alterparam VOS_SET=-300m
alterparam ECGAMP_SET=5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n300m_ecg5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* -500m 5m
alterparam VOS_SET=-500m
alterparam ECGAMP_SET=5m
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15
tran 1m 5s
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
setscale time
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.offset_n500m_ecg5m.txt v(INP) v(INN) vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

quit
.endc
"}
C {vsource.sym} 560 -730 0 0 {name=VOS   value="pwl(0 0 200m 0 200.001m \{VOS_SET\} 5s \{VOS_SET\})" savecurrent=false}
C {vsource.sym} 400 -590 0 0 {name=VCM   value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 560 -780 0 0 {name=p14 sig_type=std_logic lab=VOS

}
C {lab_wire.sym} 400 -540 2 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -680 2 0 {name=p17 sig_type=std_logic lab=AGND}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/DCB/DCB.sym} 140 -820 0 0 {name=xSEOTA1}
C {lab_wire.sym} 420 -1000 0 1 {name=p5 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 420 -920 0 1 {name=p10 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 180 -960 0 0 {name=p11 sig_type=std_logic lab=REF}
C {lab_wire.sym} 240 -780 0 0 {name=p18 sig_type=std_logic lab=AVDD}
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
C {vsource.sym} 400 -730 0 0 {name=VREF  value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 400 -680 2 0 {name=p30 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -780 0 0 {name=p13 sig_type=std_logic lab=REF}
C {lab_wire.sym} 400 -640 0 0 {name=p15 sig_type=std_logic lab=VINCM}
C {vcvs.sym} 960 -730 0 0 {name=EOSP value=0.5}
C {vcvs.sym} 960 -590 0 0 {name=EOSN value=-0.5}
C {lab_wire.sym} 960 -780 0 0 {name=p1 sig_type=std_logic lab=NIP1}
C {lab_wire.sym} 900 -750 0 0 {name=p12 sig_type=std_logic lab=VOS
}
C {lab_wire.sym} 900 -710 0 0 {name=p21 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 900 -610 0 0 {name=p22 sig_type=std_logic lab=VECG}
C {lab_wire.sym} 900 -570 0 0 {name=p23 sig_type=std_logic lab=VECG}
C {lab_wire.sym} 960 -680 2 0 {name=p24 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 960 -540 2 0 {name=p25 sig_type=std_logic lab=NIP1}
C {lab_wire.sym} 960 -640 0 0 {name=p26 sig_type=std_logic lab=INP}
C {lab_wire.sym} 300 -1060 0 1 {name=p3 sig_type=std_logic lab=AVDD}
C {vsource.sym} 720 -730 0 0 {name=VECG  value="sin(0 \{ECGAMP_SET\} 10 20m 0 0)"               savecurrent=false}
C {lab_wire.sym} 720 -780 0 0 {name=p27 sig_type=std_logic lab=VECG
}
C {lab_wire.sym} 720 -680 2 0 {name=p28 sig_type=std_logic lab=AGND}
C {vcvs.sym} 1200 -730 0 0 {name=EEGP value=0.5}
C {vcvs.sym} 1200 -590 0 0 {name=EEGN value=-0.5}
C {lab_wire.sym} 1200 -780 0 0 {name=p32 sig_type=std_logic lab=NIN1}
C {lab_wire.sym} 1140 -750 0 0 {name=p33 sig_type=std_logic lab=VOS
}
C {lab_wire.sym} 1140 -710 0 0 {name=p34 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1140 -610 0 0 {name=p35 sig_type=std_logic lab=VECG}
C {lab_wire.sym} 1140 -570 0 0 {name=p36 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -680 2 0 {name=p37 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 1200 -540 2 0 {name=p38 sig_type=std_logic lab=NIN1}
C {lab_wire.sym} 1200 -640 0 0 {name=p39 sig_type=std_logic lab=INN}
