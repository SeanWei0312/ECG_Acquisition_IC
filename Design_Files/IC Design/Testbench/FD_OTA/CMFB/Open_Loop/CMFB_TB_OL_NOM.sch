v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
P 4 1 270 -300 {}
N 80 -780 80 -760 {lab=B}
N 480 -960 500 -960 {lab=B}
N 480 -1000 500 -1000 {lab=CMFB_IN}
N 480 -920 500 -920 {lab=CMFB_REF}
N 660 -960 740 -960 {lab=CMFB_OUT}
N 360 -780 360 -760 {lab=VCM}
N 360 -640 360 -620 {lab=VDIFF}
N 200 -640 200 -620 {lab=AGND}
N 580 -900 580 -880 {lab=AGND}
N 80 -700 80 -680 {lab=AGND}
N 360 -700 360 -680 {lab=AGND}
N 740 -900 740 -880 {lab=AGND}
N 360 -560 360 -540 {lab=AGND}
N 540 -780 540 -760 {lab=VOUTBIAS}
N 540 -640 540 -620 {lab=CMFBBIAS}
N 540 -700 540 -680 {lab=AGND}
N 540 -560 540 -540 {lab=AGND}
N 820 -780 820 -760 {lab=CMFB_REF}
N 820 -700 820 -680 {lab=VCM}
N 820 -640 820 -620 {lab=CMFB_IN}
N 820 -560 820 -540 {lab=VCM}
N 760 -750 780 -750 {lab=VDIFF}
N 760 -710 780 -710 {lab=AGND}
N 760 -610 780 -610 {lab=VDIFF}
N 760 -570 780 -570 {lab=AGND}
N 80 -640 80 -620 {lab=VOUTCM}
N 80 -560 80 -540 {lab=VOUTBIAS}
N 20 -610 40 -610 {lab=CMFB_OUT}
N 20 -570 40 -570 {lab=CMFBBIAS}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 580 -1020 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -730 2 1 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 200 -730 0 0 {name=VAVDD             value="dc \{AVDD_SET\} ac 0"               savecurrent=true}
C {vdd.sym} 200 -760 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -700 0 0 {name=l5 lab=0}
C {capa.sym} 740 -930 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 360 -730 0 0 {name=VVCM              value="dc \{VCM_SET\} ac 0"                savecurrent=false}
C {vsource.sym} 360 -590 0 0 {name=VDIFF             value="dc 0 ac 1"                        savecurrent=false}
C {lab_wire.sym} 80 -780 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 480 -960 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 360 -780 0 0 {name=p3 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 480 -1000 0 0 {name=p4 sig_type=std_logic lab=CMFB_IN}
C {lab_wire.sym} 360 -640 0 0 {name=p5 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 480 -920 0 0 {name=p6 sig_type=std_logic lab=CMFB_REF}
C {lab_wire.sym} 740 -960 0 1 {name=p7 sig_type=std_logic lab=CMFB_OUT}
C {devices/code_shown.sym} 80 -480 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 910 -980 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.ol_ac.txt

let avdd_run = 3.3
let vcm_run  = avdd_run/2

alter @VAVDD[DC] = $&avdd_run
alter @VVCM[DC]  = $&vcm_run
alter @VDIFF[DC] = 0

alter @VVCM[ACMAG]   = 0
alter @VDIFF[ACMAG]  = 1
alter @VDIFF[ACPHASE] = 0
alter @VAVDD[ACMAG]  = 0
alter @VAVSS[ACMAG]  = 0

* Open-loop AC
ac dec 200 1 1G

let error_ac = v(cmfb_ref)-v(cmfb_in)
let loop_ac  = v(voutcm)/error_ac

let loop_real = real(loop_ac)
let loop_imag = imag(loop_ac)

setscale frequency

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/CMFB/NOM.Result_txt/NOM.ol_ac.txt loop_real loop_imag

quit
.endc
"}
C {devices/code_shown.sym} 80 -380 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27

.param VCM_SET=\{AVDD_SET/2\}
.param VOUT_CM_BIAS=\{AVDD_SET/2\}
.param CMFB_OUT_BIAS=2.4849

.param PLANT_GAIN=500

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(CMFB_OUT)=\{CMFB_OUT_BIAS\} v(VOUTCM)=\{VOUT_CM_BIAS\}
"}
C {vsource.sym} 200 -590 0 0 {name=VAVSS             value="dc \{AVSS_SET\} ac 0"               savecurrent=true}
C {gnd.sym} 200 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 580 -880 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -540 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 360 -680 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -680 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 740 -880 2 0 {name=p13 sig_type=std_logic lab=AGND}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/CMFB/CMFB.sym} 360 -790 0 0 {name=xSEOTA1}
C {vsource.sym} 540 -730 0 0 {name=VOUTBIAS          value="dc \{VOUT_CM_BIAS\} ac 0"           savecurrent=false}
C {vsource.sym} 540 -590 0 0 {name=VCMFBOUTBIAS      value="dc \{CMFB_OUT_BIAS\} ac 0"          savecurrent=false}
C {lab_wire.sym} 540 -780 0 0 {name=p22 sig_type=std_logic lab=VOUTBIAS}
C {lab_wire.sym} 540 -640 0 0 {name=p23 sig_type=std_logic lab=CMFBBIAS}
C {lab_wire.sym} 540 -540 2 0 {name=p24 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 540 -680 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {vcvs.sym} 820 -730 0 0 {name=EREF              value=0.5}
C {vcvs.sym} 820 -590 0 0 {name=EIN               value=-0.5}
C {vcvs.sym} 80 -590 0 0 {name=EPLANT            value=\{PLANT_GAIN\}}
C {lab_wire.sym} 820 -780 0 0 {name=p14 sig_type=std_logic lab=CMFB_REF}
C {lab_wire.sym} 760 -750 0 0 {name=p15 sig_type=std_logic lab=VDIFF
}
C {lab_wire.sym} 760 -710 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 760 -610 0 0 {name=p17 sig_type=std_logic lab=VDIFF}
C {lab_wire.sym} 760 -570 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 820 -680 2 0 {name=p19 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 820 -540 2 0 {name=p20 sig_type=std_logic lab=VCM}
C {lab_wire.sym} 820 -640 0 0 {name=p21 sig_type=std_logic lab=CMFB_IN}
C {lab_wire.sym} 80 -640 0 0 {name=p26 sig_type=std_logic lab=VOUTCM}
C {lab_wire.sym} 20 -610 0 0 {name=p27 sig_type=std_logic lab=CMFB_OUT}
C {lab_wire.sym} 20 -570 0 0 {name=p28 sig_type=std_logic lab=CMFBBIAS}
C {lab_wire.sym} 80 -540 2 0 {name=p29 sig_type=std_logic lab=VOUTBIAS}
