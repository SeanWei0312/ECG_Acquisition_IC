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
N 560 -780 560 -760 {lab=REF}
N 400 -640 400 -620 {lab=INN}
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
N 400 -780 400 -760 {lab=INP}
N 400 -700 400 -680 {lab=AGND}
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
C {devices/code_shown.sym} 80 -270 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(INP)=\{VCM_SET\} v(INN)=\{VCM_SET\}
.nodeset v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
.nodeset v(REF)=\{VCM_SET\} v(RST)=0
"}
C {vsource.sym} 240 -590 0 0 {name=VAVSS value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 240 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 240 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 300 -860 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {devices/code_shown.sym} 740 -1860 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.diff_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.pathp_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.pathn_ac.txt

* OP
op

let vdd = v(AVDD)-v(AGND)
let vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.op.txt vdd vin_cm vin_diff v(OUTP) v(OUTN) voutcm voutdiff v(REF) idd

* Diff AC
alter @VP[ACMAG] = 0.5
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 0.5
alter @VN[ACPHASE] = 180
alter @VREF[ACMAG] = 0
alter @VRST[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 0.0001 10k

let vin_diff = v(INP)-v(INN)
let voutdiff = v(OUTP)-v(OUTN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))-v(AGND)

let vin_diff_real = real(vin_diff)
let vin_diff_imag = imag(vin_diff)
let voutdiff_real = real(voutdiff)
let voutdiff_imag = imag(voutdiff)
let voutcm_real = real(voutcm)
let voutcm_imag = imag(voutcm)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.diff_ac.txt vin_diff_real vin_diff_imag voutdiff_real voutdiff_imag voutcm_real voutcm_imag

* P path
alter @VP[ACMAG] = 1
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 0
alter @VN[ACPHASE] = 0

ac dec 200 0.0001 10k

let vinp_ac = v(INP)-v(REF)
let outp_ac = v(OUTP)-v(REF)

let vinp_real = real(vinp_ac)
let vinp_imag = imag(vinp_ac)
let outp_real = real(outp_ac)
let outp_imag = imag(outp_ac)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.pathp_ac.txt vinp_real vinp_imag outp_real outp_imag

* N path
alter @VP[ACMAG] = 0
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 1
alter @VN[ACPHASE] = 0

ac dec 200 0.0001 10k

let vinn_ac = v(INN)-v(REF)
let outn_ac = v(OUTN)-v(REF)

let vinn_real = real(vinn_ac)
let vinn_imag = imag(vinn_ac)
let outn_real = real(outn_ac)
let outn_imag = imag(outn_ac)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/DCB/NOM.Result_txt/NOM.pathn_ac.txt vinn_real vinn_imag outn_real outn_imag

quit
.endc
"}
C {vsource.sym} 560 -730 0 0 {name=VREF value="dc \{VCM_SET\} ac 0"  savecurrent=false}
C {vsource.sym} 400 -590 0 0 {name=VN   value="dc \{VCM_SET\} ac 0.5" savecurrent=false}
C {lab_wire.sym} 560 -780 0 0 {name=p14 sig_type=std_logic lab=REF
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
C {vsource.sym} 400 -730 0 0 {name=VP   value="dc \{VCM_SET\} ac 0.5" savecurrent=false}
C {lab_wire.sym} 400 -680 2 0 {name=p30 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -780 0 0 {name=p13 sig_type=std_logic lab=INP}
C {lab_wire.sym} 400 -640 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 300 -1060 0 1 {name=p1 sig_type=std_logic lab=AVDD}
