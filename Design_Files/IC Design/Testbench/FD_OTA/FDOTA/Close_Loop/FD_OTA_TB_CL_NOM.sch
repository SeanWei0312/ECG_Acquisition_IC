v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 120 -860 120 -840 {lab=BFDC}
N 400 -860 400 -840 {lab=VINCM}
N 560 -860 560 -840 {lab=VDIFFCMD}
N 240 -720 240 -700 {lab=AGND}
N 120 -780 120 -760 {lab=AGND}
N 400 -780 400 -760 {lab=AGND}
N 560 -780 560 -760 {lab=AGND}
N 400 -720 400 -700 {lab=REF}
N 400 -640 400 -620 {lab=AGND}
N 120 -720 120 -700 {lab=BCMFB}
N 120 -640 120 -620 {lab=AGND}
N 620 -1120 620 -1100 {lab=AGND}
N 620 -1200 620 -1180 {lab=OUTP}
N 720 -1120 720 -1100 {lab=AGND}
N 720 -1200 720 -1180 {lab=OUTN}
N 300 -1160 320 -1160 {lab=REF}
N 370 -1080 370 -1060 {lab=AGND}
N 400 -1080 400 -1060 {lab=BCMFB}
N 400 -1260 400 -1240 {lab=BFDC}
N 480 -1160 500 -1160 {lab=VOCM}
N 760 -860 760 -840 {lab=VINP_CMD}
N 760 -780 760 -760 {lab=VINCM}
N 760 -720 760 -700 {lab=VINN_CMD}
N 760 -640 760 -620 {lab=VINCM}
N 700 -830 720 -830 {lab=VDIFFCMD}
N 700 -790 720 -790 {lab=AGND}
N 700 -690 720 -690 {lab=VDIFFCMD}
N 700 -650 720 -650 {lab=AGND}
N 500 -1320 500 -1200 {lab=OUTN}
N 420 -1320 500 -1320 {lab=OUTN}
N 300 -1320 360 -1320 {lab=INP}
N 300 -1320 300 -1200 {lab=INP}
N 200 -1200 220 -1200 {lab=VINP_CMD}
N 200 -1120 220 -1120 {lab=VINN_CMD}
N 280 -1120 320 -1120 {lab=INN}
N 300 -1120 300 -1000 {lab=INN}
N 300 -1000 360 -1000 {lab=INN}
N 420 -1000 500 -1000 {lab=OUTP}
N 500 -1120 500 -1000 {lab=OUTP}
N 280 -1200 320 -1200 {lab=INP}
N 480 -1120 520 -1120 {lab=OUTP}
N 480 -1200 520 -1200 {lab=OUTN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -530 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.temp 27
.param VDD_SET=3.3
"}
C {devices/code_shown.sym} 980 -1360 0 0 {name=NGSPICE only_toplevel=true
value="

.control
destroy all
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt

shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_diff_dc.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_icmr.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_diff_tran.txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_cm_tran.txt

* DC
op
let avdd_run = v(AVDD)-v(AGND)
let vcm_run = avdd_run/2
let vdiff_low = -avdd_run
let vdiff_high = avdd_run

alter @VCM[DC] = $&vcm_run
alter @VREF[DC] = $&vcm_run
alter @VDIFFCMD[DC] = 0

dc VDIFFCMD $&vdiff_low $&vdiff_high 0.001

let cl_vin_diff = v(INP)-v(INN)
let cl_voutcm = 0.5*(v(OUTP)+v(OUTN))
let cl_voutdiff = v(OUTP)-v(OUTN)
let cl_idd = -vavdd#branch

setscale v(VDIFFCMD)

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_diff_dc.txt cl_vin_diff v(OUTP) v(OUTN) cl_voutcm cl_voutdiff v(VOCM) cl_idd

* ICMR
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

op
let avdd_run = v(AVDD)-v(AGND)
let vref_run = avdd_run/2
let vcm_low_sweep = 0
let vcm_high_sweep = avdd_run

alter @VREF[DC] = $&vref_run
alter @VDIFFCMD[DC] = 0

dc VCM $&vcm_low_sweep $&vcm_high_sweep 0.001 VDIFFCMD -20m 20m 2m

let icmr_vin_cm = 0.5*(v(INP)+v(INN))
let icmr_vin_diff = v(INP)-v(INN)
let icmr_voutcm = 0.5*(v(OUTP)+v(OUTN))
let icmr_voutdiff = v(OUTP)-v(OUTN)
let icmr_idd = -vavdd#branch

setscale icmr_vin_cm

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_icmr.txt v(VINCM) v(REF) v(BCMFB) v(VDIFFCMD) icmr_vin_diff v(OUTP) v(OUTN) icmr_voutcm icmr_voutdiff v(VOCM) icmr_idd

* Tran
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

op
let avdd_run = v(AVDD)-v(AGND)
let vcm_run = avdd_run/2

alter @VCM[DC] = $&vcm_run
alter @VREF[DC] = $&vcm_run
alter @VDIFFCMD[PWL] = [ 0 0 1u 0 1.01u 1.0 11u 1.0 11.01u 0 21u 0 21.01u -1.0 31u -1.0 31.01u 0 40u 0 ]

tran 5n 40u

let tr_vin_diff = v(INP)-v(INN)
let tr_voutcm = 0.5*(v(OUTP)+v(OUTN))
let tr_voutdiff = v(OUTP)-v(OUTN)
let tr_idd = -vavdd#branch

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_diff_tran.txt v(VDIFFCMD) tr_vin_diff v(OUTP) v(OUTN) tr_voutcm tr_voutdiff v(VOCM) tr_idd

* CM tran
reset
save all
set wr_vecnames
set wr_singlescale
option numdgt=15

op
let avdd_run = v(AVDD)-v(AGND)
let vcm_run = avdd_run/2
let vref_low_step = vcm_run - 0.80
let vref_high_step = vcm_run + 0.80

alter @VDIFFCMD[PWL] = [ 0 0 40u 0 ]
alter @VREF[PWL] = [ 0 $&vref_low_step 1u $&vref_low_step 1.01u $&vcm_run 11u $&vcm_run 11.01u $&vref_high_step 21u $&vref_high_step 21.01u $&vcm_run 40u $&vcm_run ]

tran 5n 40u

let cm_voutcm = 0.5*(v(OUTP)+v(OUTN))
let cm_voutdiff = v(OUTP)-v(OUTN)
let cm_idd = -vavdd#branch

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/NOM.Result_txt/NOM.cl_cm_tran.txt v(REF) v(VOCM) v(OUTP) v(OUTN) cm_voutcm cm_voutdiff cm_idd

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
C {isource.sym} 120 -810 2 1 {name=IBFDC  value="dc 40u"}
C {vsource.sym} 240 -810 0 0 {name=VAVDD    value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {vdd.sym} 240 -840 0 0 {name=l4 lab=AVDD}
C {gnd.sym} 240 -780 0 0 {name=l5 lab=0}
C {vsource.sym} 400 -810 0 0 {name=VCM      value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 560 -810 0 0 {name=VDIFFCMD value="dc 0 ac 0"         savecurrent=false}
C {lab_wire.sym} 120 -860 0 0 {name=p1 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 400 -860 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 560 -860 0 0 {name=p5 sig_type=std_logic lab=VDIFFCMD}
C {vsource.sym} 240 -670 0 0 {name=VAVSS    value="dc 0 ac 0"         savecurrent=true}
C {gnd.sym} 240 -640 0 0 {name=l11 lab=0}
C {lab_wire.sym} 240 -720 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 560 -760 2 0 {name=p10 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -760 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 120 -760 2 0 {name=p12 sig_type=std_logic lab=AGND}
C {vsource.sym} 400 -670 0 0 {name=VREF     value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {lab_wire.sym} 400 -720 0 0 {name=p22 sig_type=std_logic lab=REF}
C {lab_wire.sym} 400 -620 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {isource.sym} 120 -670 2 1 {name=IBCMFB value="dc 40u"}
C {lab_wire.sym} 120 -720 0 0 {name=p26 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 120 -620 2 0 {name=p27 sig_type=std_logic lab=AGND}
C {capa.sym} 620 -1150 0 0 {name=CLP
m=1
value=40p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 620 -1200 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 620 -1100 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 720 -1150 0 0 {name=CLN
m=1
value=40p
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 720 -1100 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 720 -1200 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {vdd.sym} 370 -1240 0 0 {name=l2 lab=AVDD}
C {lab_wire.sym} 300 -1160 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 300 -1320 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 300 -1000 2 1 {name=p6 sig_type=std_logic lab=INN}
C {lab_wire.sym} 370 -1060 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -1060 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 400 -1260 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 520 -1120 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 520 -1200 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 500 -1160 0 1 {name=p39 sig_type=std_logic lab=VOCM}
C {noconn.sym} 500 -1160 0 1 {name=l3}
C {vcvs.sym} 760 -810 0 0 {name=ECMDP value=0.5}
C {vcvs.sym} 760 -670 0 0 {name=ECMDN value=-0.5}
C {lab_wire.sym} 760 -860 0 0 {name=p14 sig_type=std_logic lab=VINP_CMD}
C {lab_wire.sym} 700 -830 0 0 {name=p15 sig_type=std_logic lab=VDIFFCMD
}
C {lab_wire.sym} 700 -790 0 0 {name=p16 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 700 -690 0 0 {name=p17 sig_type=std_logic lab=VDIFFCMD}
C {lab_wire.sym} 700 -650 0 0 {name=p18 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 760 -760 2 0 {name=p19 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 760 -620 2 0 {name=p20 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 760 -720 0 0 {name=p21 sig_type=std_logic lab=VINN_CMD}
C {res.sym} 250 -1200 3 0 {name=RINP
value=50k
footprint=1206
device=resistor
m=1}
C {res.sym} 250 -1120 3 1 {name=RINN
value=50k
footprint=1206
device=resistor
m=1}
C {res.sym} 390 -1320 3 0 {name=RFBP
value=50k
footprint=1206
device=resistor
m=1}
C {res.sym} 390 -1000 3 1 {name=RFBN
value=50k
footprint=1206
device=resistor
m=1}
C {lab_wire.sym} 200 -1200 0 0 {name=p7 sig_type=std_logic lab=VINP_CMD}
C {lab_wire.sym} 200 -1120 0 0 {name=p13 sig_type=std_logic lab=VINN_CMD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 240 -1020 0 0 {name=xFDOTA1}
