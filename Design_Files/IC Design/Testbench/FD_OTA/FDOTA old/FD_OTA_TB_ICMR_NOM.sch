v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 120 -860 120 -840 {lab=BFDC}
N 300 -1040 320 -1040 {lab=REF}
N 300 -1080 320 -1080 {lab=INP}
N 300 -1000 320 -1000 {lab=INN}
N 400 -860 400 -840 {lab=VINCM}
N 400 -720 400 -700 {lab=VDIFF}
N 240 -720 240 -700 {lab=AGND}
N 370 -960 370 -940 {lab=AGND}
N 120 -780 120 -760 {lab=AGND}
N 400 -780 400 -760 {lab=AGND}
N 400 -640 400 -620 {lab=AGND}
N 560 -860 560 -840 {lab=REF}
N 560 -780 560 -760 {lab=AGND}
N 800 -860 800 -840 {lab=INP}
N 800 -780 800 -760 {lab=VINCM}
N 800 -720 800 -700 {lab=INN}
N 800 -640 800 -620 {lab=VINCM}
N 740 -830 760 -830 {lab=VDIFF}
N 740 -790 760 -790 {lab=AGND}
N 740 -690 760 -690 {lab=VDIFF}
N 740 -650 760 -650 {lab=AGND}
N 120 -720 120 -700 {lab=BCMFB}
N 120 -640 120 -620 {lab=AGND}
N 400 -960 400 -940 {lab=BCMFB}
N 400 -1140 400 -1120 {lab=BFDC}
N 620 -1000 620 -980 {lab=AGND}
N 480 -1080 500 -1080 {lab=OUTN}
N 480 -1000 500 -1000 {lab=OUTP}
N 620 -1080 620 -1060 {lab=OUTP}
N 720 -1000 720 -980 {lab=AGND}
N 720 -1080 720 -1060 {lab=OUTN}
N 480 -1040 500 -1040 {lab=VOCM}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -530 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.temp 27
.param VDD_SET=3.3
"}
C {devices/code_shown.sym} 900 -1090 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.icmr_op.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_icmr.txt

* OP
op

let avdd_run = v(AVDD)-v(AGND)
let vcm_run = avdd_run/2

alter @VREF[DC] = $&vcm_run
alter @VCM[DC] = $&vcm_run
alter @VDIFF[DC] = 0

op

let op_voutcm = 0.5*(v(OUTP)+v(OUTN))
let op_voutdiff = v(OUTP)-v(OUTN)
let op_idd = -vavdd#branch

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.icmr_op.txt v(REF) v(VOCM) v(BCMFB) v(INP) v(INN) v(OUTP) v(OUTN) op_voutcm op_voutdiff op_idd

* ICMR
let vcm_low_sweep = 0
let vcm_high_sweep = avdd_run

dc VCM $&vcm_low_sweep $&vcm_high_sweep 0.05 VDIFF -50m 50m 0.5m

let icmr_vin_cm = 0.5*(v(INP)+v(INN))
let icmr_vin_diff = v(INP)-v(INN)
let icmr_voutcm = 0.5*(v(OUTP)+v(OUTN))
let icmr_voutdiff = v(OUTP)-v(OUTN)
let icmr_idd = -vavdd#branch

setscale icmr_vin_cm

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_icmr.txt v(VINCM) v(REF) v(BCMFB) icmr_vin_diff v(INP) v(INN) v(OUTP) v(OUTN) icmr_voutcm icmr_voutdiff v(VOCM) icmr_idd

quit
.endc
"}
C {devices/code_shown.sym} 80 -380 0 0 {name=SETUP only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}

.options gmin=1e-12 rshunt=1e12 method=gear

.nodeset v(OUTP)=\{VCM_SET\} v(OUTN)=\{VCM_SET\}
.nodeset v(INP)=\{VCM_SET\} v(INN)=\{VCM_SET\}
.nodeset v(REF)=\{VCM_SET\} v(VOCM)=\{VCM_SET\}
.nodeset v(BFDC)=2.3 v(BCMFB)=2.3
"}
C {vdd.sym} 370 -1120 0 0 {name=l2 lab=AVDD}
C {isource.sym} 120 -810 2 1 {name=IBFDC  value="dc 40u"}
C {vsource.sym} 240 -810 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {vdd.sym} 240 -840 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 240 -780 0 0 {name=l5 lab=0}
C {vsource.sym} 400 -810 0 0 {name=VCM   value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 400 -670 0 0 {name=VDIFF value="dc 0 ac 0"         savecurrent=false}
C {lab_wire.sym} 120 -860 0 0 {name=p1 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 300 -1040 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 400 -860 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 300 -1080 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 400 -720 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 300 -1000 0 0 {name=p6 sig_type=std_logic lab=INN}
C {vsource.sym} 240 -670 0 0 {name=VAVSS value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 240 -640 0 0 {name=l11 lab=0}
C {lab_wire.sym} 240 -720 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 370 -940 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -620 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -760 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 120 -760 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {vsource.sym} 560 -810 0 0 {name=VREF  value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 560 -860 0 0 {name=p22 sig_type=std_logic lab=REF}
C {lab_wire.sym} 560 -760 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {vcvs.sym} 800 -810 0 0 {name=EINP value=0.5}
C {vcvs.sym} 800 -670 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 800 -860 0 0 {name=p14 sig_type=std_logic lab=INP}
C {lab_wire.sym} 740 -830 0 0 {name=p15 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 740 -790 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -690 0 0 {name=p17 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 740 -650 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 800 -760 2 0 {name=p19 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 800 -620 2 0 {name=p20 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 800 -720 0 0 {name=p21 sig_type=std_logic lab=INN}
C {isource.sym} 120 -670 2 1 {name=IBCMFB value="dc 40u"}
C {lab_wire.sym} 120 -720 0 0 {name=p26 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 120 -620 2 0 {name=p27 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -940 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 400 -1140 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {capa.sym} 620 -1030 0 0 {name=CLP
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 620 -1080 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 620 -980 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 720 -1030 0 0 {name=CLN
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 720 -980 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 500 -1000 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 720 -1080 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 500 -1080 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 500 -1040 0 1 {name=p7 sig_type=std_logic lab=VOCM}
C {noconn.sym} 500 -1040 0 1 {name=l3}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 240 -900 0 0 {name=xFDOTA1}
