v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -260 {}
N 80 -780 80 -760 {lab=BFDC}
N 260 -960 280 -960 {lab=REF}
N 260 -1000 280 -1000 {lab=INP}
N 260 -920 280 -920 {lab=INN}
N 360 -780 360 -760 {lab=VINCM}
N 360 -640 360 -620 {lab=VDIFF}
N 200 -640 200 -620 {lab=AGND}
N 330 -880 330 -860 {lab=AGND}
N 80 -700 80 -680 {lab=AGND}
N 360 -700 360 -680 {lab=AGND}
N 360 -560 360 -540 {lab=AGND}
N 520 -780 520 -760 {lab=REF}
N 520 -700 520 -680 {lab=AGND}
N 760 -780 760 -760 {lab=INP}
N 760 -700 760 -680 {lab=VINCM}
N 760 -640 760 -620 {lab=INN}
N 760 -560 760 -540 {lab=VINCM}
N 700 -750 720 -750 {lab=VDIFF}
N 700 -710 720 -710 {lab=AGND}
N 700 -610 720 -610 {lab=VDIFF}
N 700 -570 720 -570 {lab=AGND}
N 80 -640 80 -620 {lab=BCMFB}
N 80 -560 80 -540 {lab=AGND}
N 360 -880 360 -860 {lab=BCMFB}
N 360 -1060 360 -1040 {lab=BFDC}
N 580 -920 580 -900 {lab=AGND}
N 440 -1000 460 -1000 {lab=OUTN}
N 440 -920 460 -920 {lab=OUTP}
N 580 -1000 580 -980 {lab=OUTP}
N 680 -920 680 -900 {lab=AGND}
N 680 -1000 680 -980 {lab=OUTN}
N 440 -960 460 -960 {lab=VOCM}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 330 -1040 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -730 2 1 {name=IBFDC  value="dc 40u"}
C {vsource.sym} 200 -730 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {vdd.sym} 200 -760 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -700 0 0 {name=l5 lab=0}
C {vsource.sym} 360 -730 0 0 {name=VCM   value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 360 -590 0 0 {name=VDIFF value="dc 0 ac 0"         savecurrent=false}
C {lab_wire.sym} 80 -780 0 0 {name=p1 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 260 -960 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 360 -780 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 260 -1000 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 360 -640 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 260 -920 0 0 {name=p6 sig_type=std_logic lab=INN}
C {devices/code_shown.sym} 80 -440 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.temp 27
.param VDD_SET=3.3
"}
C {devices/code_shown.sym} 820 -2100 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_diff_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_cm_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_psrrp_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_psrrn_ac.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_vtc.txt

* OP
op

let voutcm = 0.5*(v(OUTP)+v(OUTN))
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch
let ibias_fdc = 40u + 0*v(AVDD)
let ibias_cmfb = 40u + 0*v(AVDD)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_op.txt v(AVDD) v(INP) v(INN) v(OUTP) v(OUTN) voutcm voutdiff v(REF) v(VOCM) v(BFDC) v(BCMFB) idd ibias_fdc ibias_cmfb

* Diff AC
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 1
alter @VDIFF[ACPHASE] = 0
alter @VREF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 0.01 100G

let vin_diff = v(INP)-v(INN)
let voutdiff = v(OUTP)-v(OUTN)
let vin_diff_real = real(vin_diff)
let vin_diff_imag = imag(vin_diff)
let voutdiff_real = real(voutdiff)
let voutdiff_imag = imag(voutdiff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_diff_ac.txt vin_diff_real vin_diff_imag voutdiff_real voutdiff_imag

* CM AC
alter @VCM[ACMAG] = 1
alter @VCM[ACPHASE] = 0
alter @VDIFF[ACMAG] = 0
alter @VREF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 0.01 100G

let vin_cm = 0.5*(v(INP)+v(INN))
let voutdiff = v(OUTP)-v(OUTN)
let vin_cm_real = real(vin_cm)
let vin_cm_imag = imag(vin_cm)
let voutdiff_real = real(voutdiff)
let voutdiff_imag = imag(voutdiff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_cm_ac.txt vin_cm_real vin_cm_imag voutdiff_real voutdiff_imag

* PSRR+
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VREF[ACMAG] = 0
alter @VAVDD[ACMAG] = 1
alter @VAVDD[ACPHASE] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 0.01 100G

let vavdd_ac = v(AVDD)
let voutdiff = v(OUTP)-v(OUTN)
let vavdd_real = real(vavdd_ac)
let vavdd_imag = imag(vavdd_ac)
let voutdiff_real = real(voutdiff)
let voutdiff_imag = imag(voutdiff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_psrrp_ac.txt vavdd_real vavdd_imag voutdiff_real voutdiff_imag

* PSRR-
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VREF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 1
alter @VAVSS[ACPHASE] = 0

ac dec 200 0.01 100G

let vagnd_ac = v(AGND)
let voutdiff = v(OUTP)-v(OUTN)
let vagnd_real = real(vagnd_ac)
let vagnd_imag = imag(vagnd_ac)
let voutdiff_real = real(voutdiff)
let voutdiff_imag = imag(voutdiff)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_psrrn_ac.txt vagnd_real vagnd_imag voutdiff_real voutdiff_imag

* VTC
alter @VCM[ACMAG] = 0
alter @VDIFF[ACMAG] = 0
alter @VREF[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

dc VDIFF -20m 20m 10u

let vin_diff = v(INP)-v(INN)
let voutcm = 0.5*(v(OUTP)+v(OUTN))
let voutdiff = v(OUTP)-v(OUTN)
let idd = -vavdd#branch

setscale vin_diff

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.ol_vtc.txt v(INP) v(INN) v(OUTP) v(OUTN) voutcm voutdiff v(VOCM) idd

quit
.endc
"}
C {devices/code_shown.sym} 80 -260 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
.nodeset v(REF)=\{VCM_SET\} v(VOCM)=\{VCM_SET\}
.nodeset v(BFDC)=2.3 v(BCMFB)=2.3
"}
C {vsource.sym} 200 -590 0 0 {name=VAVSS value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 200 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 330 -860 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -540 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -680 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -680 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {vsource.sym} 520 -730 0 0 {name=VREF  value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 520 -780 0 0 {name=p22 sig_type=std_logic lab=REF}
C {lab_wire.sym} 520 -680 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {vcvs.sym} 760 -730 0 0 {name=EINP value=0.5}
C {vcvs.sym} 760 -590 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 760 -780 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 700 -750 0 0 {name=p15 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 700 -710 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 700 -610 0 0 {name=p17 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 700 -570 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 760 -680 2 0 {name=p19 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 760 -540 2 0 {name=p20 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 760 -640 0 0 {name=p21 sig_type=std_logic lab=INN}
C {isource.sym} 80 -590 2 1 {name=IBCMFB value="dc 40u"}
C {lab_wire.sym} 80 -640 0 0 {name=p26 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 80 -540 2 0 {name=p27 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -860 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 360 -1060 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {capa.sym} 580 -950 0 0 {name=CLP
m=1
value=40p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 580 -1000 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 580 -900 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 680 -950 0 0 {name=CLN
m=1
value=40p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 680 -900 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 460 -920 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 680 -1000 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 460 -1000 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 460 -960 0 1 {name=p7 sig_type=std_logic lab=VOCM}
C {noconn.sym} 460 -960 0 1 {name=l3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 200 -820 0 0 {name=xFDOTA1}
