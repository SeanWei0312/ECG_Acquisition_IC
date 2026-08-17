v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 240 -880 240 -860 {lab=VINCM}
N 400 -880 400 -860 {lab=REF}
N 80 -740 80 -720 {lab=AGND}
N 240 -800 240 -780 {lab=AGND}
N 400 -800 400 -780 {lab=VREFBIAS}
N 240 -740 240 -720 {lab=DIFFCMD}
N 240 -660 240 -640 {lab=AGND}
N 1120 -1060 1120 -1040 {lab=AGND}
N 1120 -1140 1120 -1120 {lab=OUTP}
N 1200 -1060 1200 -1040 {lab=AGND}
N 1200 -1140 1200 -1120 {lab=OUTN}
N 760 -1100 780 -1100 {lab=REF}
N 830 -1020 830 -1000 {lab=AGND}
N 860 -1020 860 -1000 {lab=BCMFB}
N 860 -1200 860 -1180 {lab=BFDC}
N 940 -1100 960 -1100 {lab=VOCM}
N 640 -880 640 -860 {lab=ODIFF}
N 640 -800 640 -780 {lab=AGND}
N 640 -740 640 -720 {lab=DERR}
N 640 -660 640 -640 {lab=AGND}
N 580 -850 600 -850 {lab=OUTP}
N 580 -810 600 -810 {lab=OUTN}
N 580 -710 600 -710 {lab=DIFFCMD}
N 580 -670 600 -670 {lab=ODIFF}
N 940 -1060 980 -1060 {lab=OUTP}
N 940 -1140 980 -1140 {lab=OUTN}
N 80 -880 80 -860 {lab=AVDD}
N 830 -1200 830 -1180 {lab=AVDD}
N 120 -1040 120 -1000 {lab=AVDD}
N 160 -1040 160 -1000 {lab=AGND}
N 320 -1090 320 -1040 {lab=BFDC}
N 320 -1200 320 -1150 {lab=AVDD}
N 200 -1120 280 -1120 {lab=BP}
N 320 -1120 340 -1120 {lab=AVDD}
N 340 -1160 340 -1120 {lab=AVDD}
N 320 -1160 340 -1160 {lab=AVDD}
N 200 -1080 240 -1080 {lab=VREFBIAS}
N 480 -1090 480 -1040 {lab=BCMFB}
N 480 -1200 480 -1150 {lab=AVDD}
N 480 -1120 500 -1120 {lab=AVDD}
N 500 -1160 500 -1120 {lab=AVDD}
N 480 -1160 500 -1160 {lab=AVDD}
N 400 -1120 440 -1120 {lab=BP}
N 880 -880 880 -860 {lab=INP}
N 880 -800 880 -780 {lab=VINCM}
N 880 -740 880 -720 {lab=INN}
N 880 -660 880 -640 {lab=VINCM}
N 820 -850 840 -850 {lab=DERR}
N 820 -810 840 -810 {lab=AGND}
N 820 -710 840 -710 {lab=DERR}
N 820 -670 840 -670 {lab=AGND}
N 760 -1140 780 -1140 {lab=INP}
N 760 -1060 780 -1060 {lab=INN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -550 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ff
.lib $::180MCU_MODELS/sm141064.ngspice res_ff
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_ff
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_ff

.csparam PROC_ID=1

.param VDD_SET=3.3
.param TEMP_SET=27

.temp \{TEMP_SET\}
"}
C {devices/code_shown.sym} 680 -550 0 0 {name=NGSPICE
only_toplevel=true
value="

.control

destroy all

set noaskquit
set wr_singlescale
unset wr_vecnames

option klu
option numdgt=15
option method=gear
option maxord=2
option plotwinsize=0

if $&PROC_ID = 0
set proc=NOM
else
if $&PROC_ID = 1
set proc=FF
else
if $&PROC_ID = 2
set proc=SS
else
if $&PROC_ID = 3
set proc=FS
else
set proc=SF
end
end
end
end

shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_*.txt

foreach vddval 3.3 3.0 3.6
foreach tval 27 -40 125

if $vddval = 3.3
if $tval = 27
set case=nom
else
if $tval = -40
set case=tl
else
set case=th
end
end
else
if $vddval = 3.0
if $tval = 27
set case=vl
else
if $tval = -40
set case=vltl
else
set case=vlth
end
end
else
if $tval = 27
set case=vh
else
if $tval = -40
set case=vhtl
else
set case=vhth
end
end
end
end

alterparam VDD_SET=$vddval
alterparam TEMP_SET=$tval
reset

option klu

save all
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

* OP

op

let vdd = v(AVDD)-v(AGND)
let vinp = v(INP)-v(AGND)
let vinn = v(INN)-v(AGND)
let vin_diff = vinp-vinn
let voutp = v(OUTP)-v(AGND)
let voutn = v(OUTN)-v(AGND)
let voutcm = 0.5*(voutp+voutn)
let voutdiff = voutp-voutn
let vref = v(REF)-v(AGND)
let vocm = v(VOCM)-v(AGND)
let idd_total = abs(vavdd#branch)
let ibias_fdc = abs(@m.xmbfdc.m0[id])
let ibias_cmfb = abs(@m.xmbcmfb.m0[id])

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_op.txt vdd vinp vinn vin_diff voutp voutn voutcm voutdiff vref vocm idd_total ibias_fdc ibias_cmfb

* DIFF DC

let vdiff_low=-$vddval
let vdiff_high=$vddval

dc VDIFFCMD $&vdiff_low $&vdiff_high 1m

let cl_cmd = v(DIFFCMD)-v(AGND)
let cl_vin_diff = v(INP)-v(INN)
let cl_voutp = v(OUTP)-v(AGND)
let cl_voutn = v(OUTN)-v(AGND)
let cl_voutcm = 0.5*(cl_voutp+cl_voutn)
let cl_voutdiff = cl_voutp-cl_voutn
let cl_err = cl_voutdiff-cl_cmd
let cl_vocm = v(VOCM)-v(AGND)
let cl_vref = v(REF)-v(AGND)
let cl_idd = abs(vavdd#branch)
let cl_ibias_fdc = abs(@m.xmbfdc.m0[id])
let cl_ibias_cmfb = abs(@m.xmbcmfb.m0[id])

setscale cl_cmd

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_diff_dc.txt cl_vin_diff cl_voutp cl_voutn cl_voutcm cl_voutdiff cl_err cl_vocm cl_vref cl_idd cl_ibias_fdc cl_ibias_cmfb

* ICMR

reset

option klu

save all
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

dc VCM 0 $vddval 1m VDIFFCMD -10m 10m 20m

let icmr_cmd = v(DIFFCMD)-v(AGND)
let icmr_vin_cm = 0.5*(v(INP)+v(INN))-v(AGND)
let icmr_vin_diff = v(INP)-v(INN)
let icmr_voutp = v(OUTP)-v(AGND)
let icmr_voutn = v(OUTN)-v(AGND)
let icmr_voutcm = 0.5*(icmr_voutp+icmr_voutn)
let icmr_voutdiff = icmr_voutp-icmr_voutn
let icmr_vocm = v(VOCM)-v(AGND)
let icmr_vref = v(REF)-v(AGND)
let icmr_idd = abs(vavdd#branch)
let icmr_ibias_fdc = abs(@m.xmbfdc.m0[id])
let icmr_ibias_cmfb = abs(@m.xmbcmfb.m0[id])

setscale icmr_vin_cm

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_icmr.txt icmr_cmd icmr_vin_diff icmr_voutp icmr_voutn icmr_voutcm icmr_voutdiff icmr_vocm icmr_vref icmr_idd icmr_ibias_fdc icmr_ibias_cmfb

* DIFF TRAN

reset

option klu

save all
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

alter @VDIFFCMD[PWL]=[ 0 0 1u 0 1.001u 1.0 11u 1.0 11.001u 0 21u 0 21.001u -1.0 31u -1.0 31.001u 0 40u 0 ]

tran 0.5n 40u

let tr_cmd = v(DIFFCMD)-v(AGND)
let tr_vin_diff = v(INP)-v(INN)
let tr_voutp = v(OUTP)-v(AGND)
let tr_voutn = v(OUTN)-v(AGND)
let tr_voutcm = 0.5*(tr_voutp+tr_voutn)
let tr_voutdiff = tr_voutp-tr_voutn
let tr_err = tr_voutdiff-tr_cmd
let tr_vocm = v(VOCM)-v(AGND)
let tr_vref = v(REF)-v(AGND)
let tr_idd = abs(vavdd#branch)
let tr_ibias_fdc = abs(@m.xmbfdc.m0[id])
let tr_ibias_cmfb = abs(@m.xmbcmfb.m0[id])

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_diff_tran.txt tr_cmd tr_vin_diff tr_voutp tr_voutn tr_voutcm tr_voutdiff tr_err tr_vocm tr_vref tr_idd tr_ibias_fdc tr_ibias_cmfb

* CM TRAN

reset

option klu

save all
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

alter @VREFSTEP[PWL]=[ 0 -0.8 1u -0.8 1.001u 0 11u 0 11.001u 0.8 21u 0.8 21.001u 0 40u 0 ]

tran 0.5n 40u

let cm_vref = v(REF)-v(AGND)
let cm_vrefbias = v(VREFBIAS)-v(AGND)
let cm_voutp = v(OUTP)-v(AGND)
let cm_voutn = v(OUTN)-v(AGND)
let cm_voutcm = 0.5*(cm_voutp+cm_voutn)
let cm_voutdiff = cm_voutp-cm_voutn
let cm_vocm = v(VOCM)-v(AGND)
let cm_err = cm_voutcm-cm_vref
let cm_idd = abs(vavdd#branch)
let cm_ibias_fdc = abs(@m.xmbfdc.m0[id])
let cm_ibias_cmfb = abs(@m.xmbcmfb.m0[id])

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/FDOTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_cm_tran.txt cm_vref cm_vrefbias cm_voutp cm_voutn cm_voutcm cm_voutdiff cm_vocm cm_err cm_idd cm_ibias_fdc cm_ibias_cmfb

end
end

quit

.endc
"}
C {devices/code_shown.sym} 80 -250 0 0 {name=SETUP
only_toplevel=true
value="
.param VCM_SET=\{VDD_SET/2\}
.param CL_SET=40p

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {vsource.sym} 80 -830 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -800 0 0 {name=l5 lab=0}
C {vsource.sym} 240 -830 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 400 -830 0 0 {name=VREFSTEP value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 240 -880 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 400 -880 0 0 {name=p5 sig_type=std_logic lab=REF}
C {vsource.sym} 80 -690 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -660 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -740 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -780 2 0 {name=p10 sig_type=std_logic lab=VREFBIAS}
C {lab_wire.sym} 240 -780 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {vsource.sym} 240 -690 0 0 {name=VDIFFCMD value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 240 -740 0 0 {name=p22 sig_type=std_logic lab=DIFFCMD}
C {lab_wire.sym} 240 -640 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {capa.sym} 1120 -1090 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1120 -1140 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1120 -1040 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 1200 -1090 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1200 -1040 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -1140 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 760 -1100 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 830 -1000 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 860 -1000 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 860 -1200 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 980 -1060 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 980 -1140 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 960 -1100 0 1 {name=p39 sig_type=std_logic lab=VOCM}
C {noconn.sym} 960 -1100 0 1 {name=l3}
C {vcvs.sym} 640 -830 0 0 {name=EODIFF value=1}
C {vcvs.sym} 640 -690 0 0 {name=EDERR value=1}
C {lab_wire.sym} 640 -880 0 0 {name=p14 sig_type=std_logic lab=ODIFF}
C {lab_wire.sym} 580 -850 0 0 {name=p15 sig_type=std_logic lab=OUTP
}
C {lab_wire.sym} 580 -810 0 0 {name=p16 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 580 -710 0 0 {name=p17 sig_type=std_logic lab=DIFFCMD}
C {lab_wire.sym} 580 -670 0 0 {name=p18 sig_type=std_logic lab=ODIFF}
C {lab_wire.sym} 640 -780 2 0 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -640 2 0 {name=p20 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -740 0 0 {name=p21 sig_type=std_logic lab=DERR}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 700 -960 0 0 {name=xFDOTA1}
C {lab_wire.sym} 80 -880 0 0 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 830 -1200 0 0 {name=p12 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 40 -1000 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -1000 2 1 {name=p26 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1000 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -1120 0 0 {name=MBFDC
L=4u
W=16u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 320 -1200 0 0 {name=p34 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -1040 2 1 {name=p35 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 240 -1080 0 1 {name=p36 sig_type=std_logic lab=VREFBIAS}
C {lab_wire.sym} 240 -1120 0 1 {name=p37 sig_type=std_logic lab=BP}
C {symbols/pfet_03v3.sym} 460 -1120 0 0 {name=MBCMFB
L=4u
W=16u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_wire.sym} 480 -1200 0 0 {name=p40 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 480 -1040 2 1 {name=p41 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 400 -1120 0 1 {name=p42 sig_type=std_logic lab=BP}
C {vcvs.sym} 880 -830 0 0 {name=EINP value=0.5}
C {vcvs.sym} 880 -690 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 880 -880 0 0 {name=p27 sig_type=std_logic lab=INP}
C {lab_wire.sym} 820 -850 0 0 {name=p38 sig_type=std_logic lab=DERR
}
C {lab_wire.sym} 820 -810 0 0 {name=p43 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 820 -710 0 0 {name=p44 sig_type=std_logic lab=DERR}
C {lab_wire.sym} 820 -670 0 0 {name=p45 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 880 -780 2 0 {name=p46 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 880 -640 2 0 {name=p47 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 880 -740 0 0 {name=p48 sig_type=std_logic lab=INN}
C {lab_wire.sym} 760 -1140 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 760 -1060 0 0 {name=p6 sig_type=std_logic lab=INN}
