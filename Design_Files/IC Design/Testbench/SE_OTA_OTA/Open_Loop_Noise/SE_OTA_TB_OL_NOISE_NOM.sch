v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 80 -780 80 -760 {lab=B}
N 500 -640 520 -640 {lab=B}
N 500 -680 520 -680 {lab=INP}
N 500 -600 520 -600 {lab=INN}
N 680 -640 760 -640 {lab=OUT}
N 380 -780 380 -760 {lab=INP}
N 380 -640 380 -620 {lab=INN}
N 200 -640 200 -620 {lab=AGND}
N 600 -580 600 -560 {lab=AGND}
N 80 -700 80 -680 {lab=AGND}
N 380 -700 380 -680 {lab=AGND}
N 760 -580 760 -560 {lab=AGND}
N 380 -560 380 -540 {lab=AGND}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {vdd.sym} 600 -700 0 0 {name=l2 lab=AVDD}
C {isource.sym} 80 -730 0 0 {name=IBIAS   value="dc 40u"}
C {vsource.sym} 200 -730 0 0 {name=VAVDD   value="dc \{AVDD_SET\} ac 0"    savecurrent=true}
C {vdd.sym} 200 -760 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 200 -700 0 0 {name=l5 lab=0}
C {capa.sym} 760 -610 0 0 {name=CL
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {vsource.sym} 380 -730 0 0 {name=VP      value="dc \{IP\} ac 0"          savecurrent=false}
C {vsource.sym} 380 -590 0 0 {name=VN      value="dc \{IN\} ac 0"          savecurrent=false}
C {lab_wire.sym} 80 -780 0 0 {name=p1 sig_type=std_logic lab=B}
C {lab_wire.sym} 500 -640 0 0 {name=p2 sig_type=std_logic lab=B}
C {lab_wire.sym} 380 -780 0 0 {name=p3 sig_type=std_logic lab=INP}
C {lab_wire.sym} 500 -680 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 380 -640 0 0 {name=p5 sig_type=std_logic lab=INN}
C {lab_wire.sym} 500 -600 0 0 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 760 -640 0 1 {name=p7 sig_type=std_logic lab=OUT}
C {devices/code_shown.sym} 80 -480 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {devices/code_shown.sym} 810 -2410 0 0 {name=NGSPICE only_toplevel=true
value="
.control
destroy all
save all
set wr_singlescale

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA

let avdd_run = 3.3
let vcm_run  = avdd_run/2
let off_lo   = vcm_run - 0.05
let off_hi   = vcm_run + 0.05
let off_step = 10u

* OP
op
let op_avdd  = v(avdd) - v(agnd)
let op_inp   = v(inp)  - v(agnd)
let op_inn   = v(inn)  - v(agnd)
let op_out   = v(out)  - v(agnd)
let op_b     = v(b)    - v(agnd)
let op_idd   = -vavdd#branch
let op_ivss  =  vavss#branch
let op_ibias = 40e-6
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_op.txt op_avdd op_inp op_inn op_out op_b op_idd op_ivss op_ibias

* Offset
dc VP $&off_lo $&off_hi $&off_step
let off_inp = v(inp) - v(agnd)
let off_inn = v(inn) - v(agnd)
let off_out = v(out) - v(agnd)
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_offset.txt off_inp off_inn off_out

* Diff AC
alter @VP[DC] = $&vcm_run
alter @VN[DC] = $&vcm_run
alter @VP[ACMAG] = 0.5
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 0.5
alter @VN[ACPHASE] = 180
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G
let out_rel = v(out) - v(agnd)
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_ac_diff.txt db(out_rel) ph(out_rel) mag(out_rel)

* CMRR
alter @VP[ACMAG] = 1
alter @VP[ACPHASE] = 0
alter @VN[ACMAG] = 1
alter @VN[ACPHASE] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G
let out_rel = v(out) - v(agnd)
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_ac_cm.txt db(out_rel) mag(out_rel)

* PSRR+
alter @VP[ACMAG] = 0
alter @VN[ACMAG] = 0
alter @VAVDD[ACMAG] = 1
alter @VAVDD[ACPHASE] = 0
alter @VAVSS[ACMAG] = 0

ac dec 200 1 1G
let out_rel = v(out) - v(agnd)
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_ac_psrrp.txt db(out_rel) mag(out_rel)

* PSRR-
alter @VP[ACMAG] = 0
alter @VN[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 1
alter @VAVSS[ACPHASE] = 0

ac dec 200 1 1G
let out_rel = v(out) - v(agnd)
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_ac_psrrn.txt db(out_rel) mag(out_rel)

* Noise total
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0
alter @VP[ACMAG] = 1
alter @VN[ACMAG] = 0

noise v(OUT) VP dec 100 0.05 150
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_noise_total.txt inoise_total onoise_total

* ICMR, 0.01 V step
alter @VP[ACMAG] = 0
alter @VN[ACMAG] = 0
alter @VAVDD[ACMAG] = 0
alter @VAVSS[ACMAG] = 0

dc VP 0 $&avdd_run 0.01 VN 0 $&avdd_run 0.01
let icmr_inp = v(inp) - v(agnd)
let icmr_inn = v(inn) - v(agnd)
let icmr_vcm = 0.5*(icmr_inp + icmr_inn)
let icmr_vid = icmr_inp - icmr_inn
let icmr_out = v(out) - v(agnd)
let icmr_idd = -vavdd#branch
let icmr_ivss = vavss#branch
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_icmr_dc.txt icmr_vcm icmr_vid icmr_out icmr_idd icmr_ivss

* Differential input, 0.01 V step
alter @VN[DC] = $&vcm_run
dc VP 1.55 1.75 0.01
let diff_inp = v(inp) - v(agnd)
let diff_inn = v(inn) - v(agnd)
let diff_vid = diff_inp - diff_inn
let diff_vcm = 0.5*(diff_inp + diff_inn)
let diff_out = v(out) - v(agnd)
let diff_idd = -vavdd#branch
wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA/NOM.ol_diff_dc.txt diff_vid diff_vcm diff_out diff_idd

.endc
"}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/SE_OTA/SE_OTA.sym} 440 -500 0 0 {name=xSEOTA1}
C {devices/code_shown.sym} 80 -380 0 0 {name=SETUP only_toplevel=true
value="
.param AVDD_SET=3.3
.param AVSS_SET=0
.param TEMP_SET=27
.param VCM_SET=\{AVDD_SET/2\}
.param IP=\{VCM_SET\}
.param IN=\{VCM_SET\}

.temp \{TEMP_SET\}

.options gmin=1e-12 rshunt=1e12 method=gear
.nodeset v(B)=2.3 v(OUT)=\{VCM_SET\}
"}
C {vsource.sym} 200 -590 0 0 {name=VAVSS   value="dc \{AVSS_SET\} ac 0"    savecurrent=true}
C {gnd.sym} 200 -560 0 0 {name=l11 lab=0}
C {lab_wire.sym} 200 -640 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 600 -560 2 0 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 380 -540 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 380 -680 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 80 -680 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 760 -560 2 1 {name=p13 sig_type=std_logic lab=AGND}
