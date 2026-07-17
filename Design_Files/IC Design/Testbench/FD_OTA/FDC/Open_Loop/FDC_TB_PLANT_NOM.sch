v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -340 {}
N 360 -820 360 -800 {lab=B}
N 280 -1020 300 -1020 {lab=B}
N 280 -1060 300 -1060 {lab=INP}
N 280 -980 300 -980 {lab=INN}
N 200 -820 200 -800 {lab=VCM}
N 200 -680 200 -660 {lab=VDIFF}
N 40 -680 40 -660 {lab=AGND}
N 360 -740 360 -720 {lab=AGND}
N 200 -740 200 -720 {lab=AGND}
N 580 -980 580 -960 {lab=AGND}
N 200 -600 200 -580 {lab=AGND}
N 620 -820 620 -800 {lab=INP}
N 620 -680 620 -660 {lab=INN}
N 620 -740 620 -720 {lab=VCM}
N 620 -600 620 -580 {lab=VCM}
N 560 -790 580 -790 {lab=VDIFF}
N 560 -750 580 -750 {lab=AGND}
N 560 -650 580 -650 {lab=VDIFF}
N 560 -610 580 -610 {lab=AGND}
N 460 -1100 480 -1100 {lab=OUTP}
N 380 -920 380 -900 {lab=CMFB}
N 460 -940 480 -940 {lab=OUTN}
N 580 -1060 580 -1040 {lab=OUTP}
N 680 -980 680 -960 {lab=AGND}
N 680 -1060 680 -1040 {lab=OUTN}
N 360 -680 360 -660 {lab=CMFB}
N 360 -600 360 -580 {lab=AGND}
N 350 -920 350 -900 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 350 -1120 0 0 {name=l2 lab=AVDD}
C {isource.sym} 360 -770 2 1 {name=IBIAS       value="dc 40u"}
C {vsource.sym} 40 -770 0 0 {name=VAVDD       value="dc \{AVDD_SET\} ac 0"       savecurrent=true}
C {vdd.sym} 40 -800 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 40 -740 0 0 {name=l5 lab=0}
C {capa.sym} 580 -1010 0 0 {name=CLP
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 200 -770 0 0 {name=VVCM        value="dc \{VCM_SET\} ac 0"        savecurrent=false}
C {vsource.sym} 200 -630 0 0 {name=VDIFF       value="dc 0 ac 0"                savecurrent=false}
C {lab_wire.sym} 360 -820 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 280 -1020 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 200 -820 0 0 {name=p3 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 280 -1060 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 200 -680 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 280 -980 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 580 -1060 0 1 {name=p7 sig_type=std_logic lab=OUTP}
C {devices/code_shown.sym} 80 -520 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 800 -970 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.plant_ac.txt

alter @VAVDD[ACMAG]  = 0
alter @VAVSS[ACMAG]  = 0
alter @VVCM[ACMAG]   = 0
alter @VDIFF[ACMAG]  = 0

alter @VCMFB[ACMAG]   = 1
alter @VCMFB[ACPHASE] = 0

ac dec 200 0.1 1G

let vcmfb_ac  = v(cmfb)-v(agnd)
let voutp_ac  = v(outp)-v(agnd)
let voutn_ac  = v(outn)-v(agnd)
let voutcm_ac = (voutp_ac+voutn_ac)/2

let plant_ac   = voutcm_ac/vcmfb_ac
let plant_real = real(plant_ac)
let plant_imag = imag(plant_ac)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDC/NOM.Result_txt/NOM.plant_ac.txt plant_real plant_imag

quit
.endc
"}
C {devices/code_shown.sym} 80 -420 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}

.param CMFB_OP=2.1497

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear plotwinsize=0
.nodeset v(B)=2.3 v(CMFB)=\{CMFB_OP\}
+ v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
"}
C {vsource.sym} 40 -630 0 0 {name=VAVSS       value="dc \{AVSS_SET\} ac 0"       savecurrent=true}
C {gnd.sym} 40 -600 0 0 {name=l11 lab=0}
C {lab_wire.sym} 40 -680 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 350 -900 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 200 -580 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 200 -720 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -720 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -960 2 0 {name=p13 sig_type=std_logic lab=AGND}
C {vcvs.sym} 620 -630 0 0 {name=EINN        value=-0.5}
C {vcvs.sym} 620 -770 0 0 {name=EINP        value=0.5
}
C {lab_wire.sym} 620 -820 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 620 -680 0 0 {name=p15 sig_type=std_logic lab=INN}
C {lab_wire.sym} 620 -720 2 0 {name=p16 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 620 -580 2 0 {name=p17 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 560 -610 2 1 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -750 2 1 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -650 0 0 {name=p20 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 560 -790 0 0 {name=p21 sig_type=std_logic lab=VDIFF}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDC/FDC.sym} 220 -880 0 0 {name=xSEOTA1}
C {capa.sym} 680 -1010 0 0 {name=CLN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 680 -960 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 480 -1100 0 1 {name=p22 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 680 -1060 0 1 {name=p25 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 480 -940 0 1 {name=p26 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 380 -900 2 0 {name=p27 sig_type=std_logic lab=CMFB}
C {vsource.sym} 360 -630 0 0 {name=VCMFB       value="dc \{CMFB_OP\} ac 1"        savecurrent=false}
C {lab_wire.sym} 360 -580 2 0 {name=VCMFB2 sig_type=std_logic lab=AGND
value="dc \{CMFB_BIAS\} ac 0"}
C {lab_wire.sym} 360 -680 0 0 {name=p34 sig_type=std_logic lab=CMFB}
