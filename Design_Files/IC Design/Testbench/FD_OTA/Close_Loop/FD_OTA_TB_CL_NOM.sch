v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 240 -1040 240 -1020 {lab=VINCM}
N 400 -1040 400 -1020 {lab=REF}
N 80 -900 80 -880 {lab=AGND}
N 240 -960 240 -940 {lab=AGND}
N 400 -960 400 -940 {lab=VREFBIAS}
N 240 -900 240 -880 {lab=DIFFCMD}
N 240 -820 240 -800 {lab=AGND}
N 1120 -1220 1120 -1200 {lab=AGND}
N 1120 -1300 1120 -1280 {lab=OUTP}
N 1200 -1220 1200 -1200 {lab=AGND}
N 1200 -1300 1200 -1280 {lab=OUTN}
N 760 -1260 780 -1260 {lab=REF}
N 830 -1180 830 -1160 {lab=AGND}
N 860 -1180 860 -1160 {lab=BCMFB}
N 860 -1360 860 -1340 {lab=BFDC}
N 940 -1260 960 -1260 {lab=VOCM}
N 640 -1040 640 -1020 {lab=ODIFF}
N 640 -960 640 -940 {lab=AGND}
N 640 -900 640 -880 {lab=DERR}
N 640 -820 640 -800 {lab=AGND}
N 580 -1010 600 -1010 {lab=OUTP}
N 580 -970 600 -970 {lab=OUTN}
N 580 -870 600 -870 {lab=DIFFCMD}
N 580 -830 600 -830 {lab=ODIFF}
N 940 -1220 980 -1220 {lab=OUTP}
N 940 -1300 980 -1300 {lab=OUTN}
N 80 -1040 80 -1020 {lab=AVDD}
N 830 -1360 830 -1340 {lab=AVDD}
N 120 -1200 120 -1160 {lab=AVDD}
N 160 -1200 160 -1160 {lab=AGND}
N 320 -1250 320 -1200 {lab=BFDC}
N 320 -1360 320 -1310 {lab=AVDD}
N 200 -1280 280 -1280 {lab=BP}
N 320 -1280 340 -1280 {lab=AVDD}
N 340 -1320 340 -1280 {lab=AVDD}
N 320 -1320 340 -1320 {lab=AVDD}
N 200 -1240 240 -1240 {lab=VREFBIAS}
N 480 -1250 480 -1200 {lab=BCMFB}
N 480 -1360 480 -1310 {lab=AVDD}
N 480 -1280 500 -1280 {lab=AVDD}
N 500 -1320 500 -1280 {lab=AVDD}
N 480 -1320 500 -1320 {lab=AVDD}
N 400 -1280 440 -1280 {lab=BP}
N 880 -1040 880 -1020 {lab=INP}
N 880 -960 880 -940 {lab=VINCM}
N 880 -900 880 -880 {lab=INN}
N 880 -820 880 -800 {lab=VINCM}
N 820 -1010 840 -1010 {lab=DERR}
N 820 -970 840 -970 {lab=AGND}
N 820 -870 840 -870 {lab=DERR}
N 820 -830 840 -830 {lab=AGND}
N 760 -1300 780 -1300 {lab=INP}
N 760 -1220 780 -1220 {lab=INN}
C {title.sym} 160 -40 0 0 {name=l1 author="Yi-Hsiang Wei"}
C {devices/code_shown.sym} 80 -710 0 0 {name=MODELS
only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice

.param sw_stat_global=0
.param sw_stat_mismatch=0

.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice bjt_typical

.csparam PROC_ID=0
"}
C {devices/code_shown.sym} 680 -710 0 0 {name=NGSPICE
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


shell mkdir -p /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt
shell rm -f /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_*.txt


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
option numdgt=15
option method=gear
option maxord=2
option plotwinsize=0
option rshunt=1e12


* OP

save AVDD AGND INP INN OUTP OUTN REF VOCM DIFFCMD VREFBIAS
save vavdd#branch
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

op

let vdd=v(AVDD)-v(AGND)

let vinp=v(INP)-v(AGND)
let vinn=v(INN)-v(AGND)
let vin_diff=vinp-vinn

let voutp=v(OUTP)-v(AGND)
let voutn=v(OUTN)-v(AGND)

let voutcm=0.5*(voutp+voutn)
let voutdiff=voutp-voutn

let vref=v(REF)-v(AGND)
let vocm=v(VOCM)-v(AGND)

let idd_total=abs(vavdd#branch)

let ibias_fdc=abs(@m.xmbfdc.m0[id])
let ibias_cmfb=abs(@m.xmbcmfb.m0[id])

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_op.txt vdd vinp vinn vin_diff voutp voutn voutcm voutdiff vref vocm idd_total ibias_fdc ibias_cmfb

destroy all


* DIFF DC

let vdiff_low=-$vddval
let vdiff_high=$vddval

save AGND INP INN OUTP OUTN REF VOCM DIFFCMD
save vavdd#branch
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

dc VDIFFCMD $&vdiff_low $&vdiff_high 5m

let cl_cmd=v(DIFFCMD)-v(AGND)

let cl_vin_diff=v(INP)-v(INN)

let cl_voutp=v(OUTP)-v(AGND)
let cl_voutn=v(OUTN)-v(AGND)

let cl_voutcm=0.5*(cl_voutp+cl_voutn)
let cl_voutdiff=cl_voutp-cl_voutn

let cl_err=cl_voutdiff-cl_cmd

let cl_vocm=v(VOCM)-v(AGND)
let cl_vref=v(REF)-v(AGND)

let cl_idd=abs(vavdd#branch)

let cl_ibias_fdc=abs(@m.xmbfdc.m0[id])
let cl_ibias_cmfb=abs(@m.xmbcmfb.m0[id])

setscale cl_cmd

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_diff_dc.txt cl_vin_diff cl_voutp cl_voutn cl_voutcm cl_voutdiff cl_err cl_vocm cl_vref cl_idd cl_ibias_fdc cl_ibias_cmfb

destroy all


* ICMR -10m

option klu
option method=gear
option maxord=2
option itl1=1000
option itl2=5000
option rshunt=1e10

alter VDIFFCMD -10m

save AGND INP INN OUTP OUTN REF VOCM DIFFCMD
save vavdd#branch
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

dc VCM $vddval 0 -5m

let icmr_cmd=v(DIFFCMD)-v(AGND)

let icmr_vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let icmr_vin_diff=v(INP)-v(INN)

let icmr_voutp=v(OUTP)-v(AGND)
let icmr_voutn=v(OUTN)-v(AGND)

let icmr_voutcm=0.5*(icmr_voutp+icmr_voutn)
let icmr_voutdiff=icmr_voutp-icmr_voutn

let icmr_vocm=v(VOCM)-v(AGND)
let icmr_vref=v(REF)-v(AGND)

let icmr_idd=abs(vavdd#branch)

let icmr_ibias_fdc=abs(@m.xmbfdc.m0[id])
let icmr_ibias_cmfb=abs(@m.xmbcmfb.m0[id])

setscale icmr_vin_cm

unset appendwrite

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_icmr.txt icmr_cmd icmr_vin_diff icmr_voutp icmr_voutn icmr_voutcm icmr_voutdiff icmr_vocm icmr_vref icmr_idd icmr_ibias_fdc icmr_ibias_cmfb

destroy all


* ICMR +10m

alter VDIFFCMD 10m

save AGND INP INN OUTP OUTN REF VOCM DIFFCMD
save vavdd#branch
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

dc VCM $vddval 0 -5m

let icmr_cmd=v(DIFFCMD)-v(AGND)

let icmr_vin_cm=0.5*(v(INP)+v(INN))-v(AGND)
let icmr_vin_diff=v(INP)-v(INN)

let icmr_voutp=v(OUTP)-v(AGND)
let icmr_voutn=v(OUTN)-v(AGND)

let icmr_voutcm=0.5*(icmr_voutp+icmr_voutn)
let icmr_voutdiff=icmr_voutp-icmr_voutn

let icmr_vocm=v(VOCM)-v(AGND)
let icmr_vref=v(REF)-v(AGND)

let icmr_idd=abs(vavdd#branch)

let icmr_ibias_fdc=abs(@m.xmbfdc.m0[id])
let icmr_ibias_cmfb=abs(@m.xmbcmfb.m0[id])

setscale icmr_vin_cm

set appendwrite

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_icmr.txt icmr_cmd icmr_vin_diff icmr_voutp icmr_voutn icmr_voutcm icmr_voutdiff icmr_vocm icmr_vref icmr_idd icmr_ibias_fdc icmr_ibias_cmfb

unset appendwrite

destroy all


* DIFF TRAN

reset

option klu
option numdgt=15
option method=gear
option maxord=2
option plotwinsize=0
option rshunt=1e12

alter @VDIFFCMD[PWL]=[ 0 0 1u 0 1.001u 1.0 11u 1.0 11.001u 0 21u 0 21.001u -1.0 31u -1.0 31.001u 0 40u 0 ]

save AGND INP INN OUTP OUTN REF VOCM DIFFCMD
save vavdd#branch
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

tran 5n 40u

let tr_cmd=v(DIFFCMD)-v(AGND)

let tr_vin_diff=v(INP)-v(INN)

let tr_voutp=v(OUTP)-v(AGND)
let tr_voutn=v(OUTN)-v(AGND)

let tr_voutcm=0.5*(tr_voutp+tr_voutn)
let tr_voutdiff=tr_voutp-tr_voutn

let tr_err=tr_voutdiff-tr_cmd

let tr_vocm=v(VOCM)-v(AGND)
let tr_vref=v(REF)-v(AGND)

let tr_idd=abs(vavdd#branch)

let tr_ibias_fdc=abs(@m.xmbfdc.m0[id])
let tr_ibias_cmfb=abs(@m.xmbcmfb.m0[id])

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_diff_tran.txt tr_cmd tr_vin_diff tr_voutp tr_voutn tr_voutcm tr_voutdiff tr_err tr_vocm tr_vref tr_idd tr_ibias_fdc tr_ibias_cmfb

destroy all


* CM TRAN

reset

option klu
option numdgt=15
option method=gear
option maxord=2
option plotwinsize=0
option rshunt=1e12

alter @VREFSTEP[PWL]=[ 0 -0.8 1u -0.8 1.001u 0 11u 0 11.001u 0.8 21u 0.8 21.001u 0 40u 0 ]

save AGND OUTP OUTN REF VREFBIAS VOCM
save vavdd#branch
save @m.xmbfdc.m0[id]
save @m.xmbcmfb.m0[id]

tran 5n 40u

let cm_vref=v(REF)-v(AGND)
let cm_vrefbias=v(VREFBIAS)-v(AGND)

let cm_voutp=v(OUTP)-v(AGND)
let cm_voutn=v(OUTN)-v(AGND)

let cm_voutcm=0.5*(cm_voutp+cm_voutn)
let cm_voutdiff=cm_voutp-cm_voutn

let cm_vocm=v(VOCM)-v(AGND)

let cm_err=cm_voutcm-cm_vref

let cm_idd=abs(vavdd#branch)

let cm_ibias_fdc=abs(@m.xmbfdc.m0[id])
let cm_ibias_cmfb=abs(@m.xmbcmfb.m0[id])

setscale time

wrdata /foss/designs/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/FD_OTA/\{$proc\}.Result_txt/\{$proc\}.cl_\{$case\}_cm_tran.txt cm_vref cm_vrefbias cm_voutp cm_voutn cm_voutcm cm_voutdiff cm_vocm cm_err cm_idd cm_ibias_fdc cm_ibias_cmfb

destroy all


end
end


quit

.endc
"}
C {devices/code_shown.sym} 80 -330 0 0 {name=SETUP
only_toplevel=true
value="
.param VDD_SET=3.3
.param TEMP_SET=27

.param VCM_SET=\{VDD_SET/2\}
.param CL_SET=40p

.csparam MC_RUNS=200

.temp \{TEMP_SET\}

.options gmin=1e-12
.options rshunt=1e12
.options method=gear
"}
C {vsource.sym} 80 -990 0 0 {name=VAVDD value="dc \{VDD_SET\} ac 0" savecurrent=true}
C {gnd.sym} 80 -960 0 0 {name=l5 lab=0}
C {vsource.sym} 240 -990 0 0 {name=VCM value="dc \{VCM_SET\} ac 0" savecurrent=false}
C {vsource.sym} 400 -990 0 0 {name=VREFSTEP value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 240 -1040 0 0 {name=p3 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 400 -1040 0 0 {name=p5 sig_type=std_logic lab=REF}
C {vsource.sym} 80 -850 0 0 {name=VAVSS value="dc 0 ac 0" savecurrent=false}
C {gnd.sym} 80 -820 0 0 {name=l11 lab=0}
C {lab_wire.sym} 80 -900 0 0 {name=p8 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 400 -940 2 0 {name=p10 sig_type=std_logic lab=VREFBIAS}
C {lab_wire.sym} 240 -940 2 0 {name=p11 sig_type=std_logic lab=AGND}
C {vsource.sym} 240 -850 0 0 {name=VDIFFCMD value="dc 0 ac 0" savecurrent=false}
C {lab_wire.sym} 240 -900 0 0 {name=p22 sig_type=std_logic lab=DIFFCMD}
C {lab_wire.sym} 240 -800 2 0 {name=p25 sig_type=std_logic lab=AGND}
C {capa.sym} 1120 -1250 0 0 {name=CLP
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1120 -1300 0 1 {name=p28 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 1120 -1200 2 0 {name=p29 sig_type=std_logic lab=AGND}
C {capa.sym} 1200 -1250 0 0 {name=CLN
m=1
value=\{CL_SET\}
footprint=1206
device="ceramic capacitor"}
C {lab_wire.sym} 1200 -1200 2 0 {name=CLN2 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 1200 -1300 0 1 {name=p31 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 760 -1260 0 0 {name=p2 sig_type=std_logic lab=REF}
C {lab_wire.sym} 830 -1160 2 1 {name=p9 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 860 -1160 2 0 {name=p23 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 860 -1360 0 1 {name=p24 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 980 -1220 0 1 {name=p30 sig_type=std_logic lab=OUTP}
C {lab_wire.sym} 980 -1300 0 1 {name=p32 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 960 -1260 0 1 {name=p39 sig_type=std_logic lab=VOCM}
C {noconn.sym} 960 -1260 0 1 {name=l3}
C {vcvs.sym} 640 -990 0 0 {name=EODIFF value=1}
C {vcvs.sym} 640 -850 0 0 {name=EDERR value=1}
C {lab_wire.sym} 640 -1040 0 0 {name=p14 sig_type=std_logic lab=ODIFF}
C {lab_wire.sym} 580 -1010 0 0 {name=p15 sig_type=std_logic lab=OUTP
}
C {lab_wire.sym} 580 -970 0 0 {name=p16 sig_type=std_logic lab=OUTN}
C {lab_wire.sym} 580 -870 0 0 {name=p17 sig_type=std_logic lab=DIFFCMD}
C {lab_wire.sym} 580 -830 0 0 {name=p18 sig_type=std_logic lab=ODIFF}
C {lab_wire.sym} 640 -940 2 0 {name=p19 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -800 2 0 {name=p20 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 640 -900 0 0 {name=p21 sig_type=std_logic lab=DERR}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/FD_OTA/FDOTA/FD_OTA.sym} 700 -1120 0 0 {name=xFDOTA1}
C {lab_wire.sym} 80 -1040 0 0 {name=p1 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 830 -1360 0 0 {name=p12 sig_type=std_logic lab=AVDD}
C {ECG_Acquisition_IC/Design_Files/IC Design/Schematic/BIAS/BIAS.sym} 40 -1160 0 0 {name=xBIAS1}
C {lab_wire.sym} 120 -1160 2 1 {name=p26 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 160 -1160 2 1 {name=p33 sig_type=std_logic lab=AGND}
C {symbols/pfet_03v3.sym} 300 -1280 0 0 {name=MBFDC
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
C {lab_wire.sym} 320 -1360 0 0 {name=p34 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 320 -1200 2 1 {name=p35 sig_type=std_logic lab=BFDC}
C {lab_wire.sym} 240 -1240 0 1 {name=p36 sig_type=std_logic lab=VREFBIAS}
C {lab_wire.sym} 240 -1280 0 1 {name=p37 sig_type=std_logic lab=BP}
C {symbols/pfet_03v3.sym} 460 -1280 0 0 {name=MBCMFB
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
C {lab_wire.sym} 480 -1360 0 0 {name=p40 sig_type=std_logic lab=AVDD}
C {lab_wire.sym} 480 -1200 2 1 {name=p41 sig_type=std_logic lab=BCMFB}
C {lab_wire.sym} 400 -1280 0 1 {name=p42 sig_type=std_logic lab=BP}
C {vcvs.sym} 880 -990 0 0 {name=EINP value=0.5}
C {vcvs.sym} 880 -850 0 0 {name=EINN value=-0.5}
C {lab_wire.sym} 880 -1040 0 0 {name=p27 sig_type=std_logic lab=INP}
C {lab_wire.sym} 820 -1010 0 0 {name=p38 sig_type=std_logic lab=DERR
}
C {lab_wire.sym} 820 -970 0 0 {name=p43 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 820 -870 0 0 {name=p44 sig_type=std_logic lab=DERR}
C {lab_wire.sym} 820 -830 0 0 {name=p45 sig_type=std_logic lab=AGND}
C {lab_wire.sym} 880 -940 2 0 {name=p46 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 880 -800 2 0 {name=p47 sig_type=std_logic lab=VINCM}
C {lab_wire.sym} 880 -900 0 0 {name=p48 sig_type=std_logic lab=INN}
C {lab_wire.sym} 760 -1300 0 0 {name=p4 sig_type=std_logic lab=INP}
C {lab_wire.sym} 760 -1220 0 0 {name=p6 sig_type=std_logic lab=INN}
