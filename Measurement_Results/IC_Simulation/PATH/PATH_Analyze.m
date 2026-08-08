% PATH nominal analysis
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~exist(plotDir,'dir'), mkdir(plotDir); end

TAG = "NOM";
PGA_GAIN = 16;
EXPECTED_GAIN_VV = 60*4*PGA_GAIN;
VCM_TARGET_V = 1.65;
MARK_FREQ_HZ = [0.05 60 150 1e3];
NOISE_DENSITY_FREQ_HZ = [0.05 1 10 60 150 1e3];
NOISE_PLOT_FREQ_HZ = [0.05 60 150];
NOISE_BAND_HZ = [0.05 150];
NOISE_TOTAL_BAND_HZ = [0.01 1e3];
TRAN_MEASURE_START_S = 108e-3;
TRAN_MAX_CYCLES = 10;
FCLK_HZ = 250;

%% Operating point
op = lastRow(rowsForValue(readTxt(fullfile(baseDir,TAG + ".op.txt")),2,PGA_GAIN));
vdd_V = pick(op,3);
vinCmDc_V = pick(op,6);
vinDiffDc_mV = pick(op,7)*1e3;
outpDc_V = pick(op,8);
outnDc_V = pick(op,9);
outCmDc_V = pick(op,10);
outDiffDc_mV = pick(op,11)*1e3;
rldDc_V = pick(op,12);
ibias_A = abs(pick(op,14));
idd_A = abs(pick(op,15));
power_W = pick(op,16);
if ~isfinite(power_W), power_W = vdd_V*idd_A; end
outCmErr_mV = (outCmDc_V - VCM_TARGET_V)*1e3;
headroomLow_V = min(outpDc_V,outnDc_V);
headroomHigh_V = vdd_V - max(outpDc_V,outnDc_V);

%% AC response
diffAc = uniqueFreqRows(rowsForValue(readTxt(fullfile(baseDir,TAG + ".diff_ac.txt")),2,PGA_GAIN));
fAc_Hz = diffAc(:,1);
Hd = complexCol(diffAc,14,15);
gain_dB = diffAc(:,17);
phase_deg = unwrap(diffAc(:,18)*pi/180)*180/pi;
gain60_dB = interpAtFreq(fAc_Hz,gain_dB,60);
gainMid_dB = meanBand(fAc_Hz,gain_dB,[1 60]);
if ~isfinite(gainMid_dB), gainMid_dB = gain60_dB; end
gainMid_VV = 10^(gainMid_dB/20);
expectedGain_dB = 20*log10(EXPECTED_GAIN_VV);
gainError_dB = gainMid_dB - expectedGain_dB;
gainAt_dB = interpAtFreq(fAc_Hz,gain_dB,MARK_FREQ_HZ);
phaseAt_deg = interpAtFreq(fAc_Hz,phase_deg,[0.05 60 150]);
gainRel_dB = gain_dB - gainMid_dB;
hp1dB_Hz = cornerCrossing(fAc_Hz,gainRel_dB,-1,60,'hp');
hp3dB_Hz = cornerCrossing(fAc_Hz,gainRel_dB,-3,60,'hp');
lp1dB_Hz = cornerCrossing(fAc_Hz,gainRel_dB,-1,60,'lp');
lp3dB_Hz = cornerCrossing(fAc_Hz,gainRel_dB,-3,60,'lp');
gainFlatness_dB = bandRange(fAc_Hz,gain_dB,[0.05 150]);

cmrr = rejectionAc(uniqueFreqRows(rowsForValue(readTxt(fullfile(baseDir,TAG + ".cmrr_ac.txt")),2,PGA_GAIN)),fAc_Hz,gain_dB);
psrrp = rejectionAc(uniqueFreqRows(rowsForValue(readTxt(fullfile(baseDir,TAG + ".psrrp_ac.txt")),2,PGA_GAIN)),fAc_Hz,gain_dB);
psrrn = rejectionAc(uniqueFreqRows(rowsForValue(readTxt(fullfile(baseDir,TAG + ".psrrn_ac.txt")),2,PGA_GAIN)),fAc_Hz,gain_dB);
cmrrAt_dB = interpAtFreq(cmrr.f_Hz,cmrr.rej_dB,MARK_FREQ_HZ);
psrrPAt_dB = interpAtFreq(psrrp.f_Hz,psrrp.rej_dB,MARK_FREQ_HZ);
psrrNAt_dB = interpAtFreq(psrrn.f_Hz,psrrn.rej_dB,MARK_FREQ_HZ);

%% Noise
noise = readNoiseDiff(fullfile(baseDir,TAG + ".noise_diff.txt"),PGA_GAIN);
noiseInBand_Vrms = integrateNoise(noise.f_Hz,noise.in_VrtHz,NOISE_BAND_HZ);
noiseInTotal_Vrms = integrateNoise(noise.f_Hz,noise.in_VrtHz,NOISE_TOTAL_BAND_HZ);
noiseInAt = interpAtFreq(noise.f_Hz,noise.in_VrtHz,NOISE_DENSITY_FREQ_HZ);
signal05mVrms = 0.5e-3/(2*sqrt(2));
snrIn_dB = 20*log10(signal05mVrms/noiseInBand_Vrms);

%% Transient response, rejection, offsets, startup, RLD, THD
diffTran = diffTranMetrics(rowsForValue(readTxt(fullfile(baseDir,TAG + ".diff_tran.txt")),2,PGA_GAIN), ...
    fAc_Hz,gain_dB,vdd_V,TRAN_MEASURE_START_S,TRAN_MAX_CYCLES,FCLK_HZ);
cmrrTran = rejectionTranMetrics(rowsForValue(readTxt(fullfile(baseDir,TAG + ".cmrr_tran.txt")),2,PGA_GAIN), ...
    fAc_Hz,Hd,vdd_V,TRAN_MEASURE_START_S,TRAN_MAX_CYCLES,FCLK_HZ);
psrrpTran = rejectionTranMetrics(rowsForValue(readTxt(fullfile(baseDir,TAG + ".psrrp_tran.txt")),2,PGA_GAIN), ...
    fAc_Hz,Hd,vdd_V,TRAN_MEASURE_START_S,TRAN_MAX_CYCLES,FCLK_HZ);
psrrnTran = rejectionTranMetrics(rowsForValue(readTxt(fullfile(baseDir,TAG + ".psrrn_tran.txt")),2,PGA_GAIN), ...
    fAc_Hz,Hd,vdd_V,TRAN_MEASURE_START_S,TRAN_MAX_CYCLES,FCLK_HZ);
cmOffset = offsetMetrics(rowsForValue(readTxt(fullfile(baseDir,TAG + ".vcmdcoffset_tran.txt")),4,PGA_GAIN), ...
    vdd_V,VCM_TARGET_V,TRAN_MEASURE_START_S,5);
diffOffset = offsetMetrics(rowsForValue(readTxt(fullfile(baseDir,TAG + ".vdiffdcoffset_tran.txt")),4,PGA_GAIN), ...
    vdd_V,VCM_TARGET_V,TRAN_MEASURE_START_S,5);
startupReset = startupMetrics(readTxt(fullfile(baseDir,TAG + ".startup_with_reset.txt")),vdd_V,VCM_TARGET_V);
startupNoReset = startupMetrics(readTxt(fullfile(baseDir,TAG + ".startup_without_reset.txt")),vdd_V,VCM_TARGET_V);
resetImprovement_dB = 20*log10(abs(startupNoReset.postDiffMean_V)/abs(startupReset.postDiffMean_V));
rld = rldMetrics(readTxt(fullfile(baseDir,TAG + ".rld_off.txt")), ...
    readTxt(fullfile(baseDir,TAG + ".rld_on.txt")),vdd_V,TRAN_MEASURE_START_S,8,FCLK_HZ);
thd = thdMetrics(rowsForValue(readTxt(fullfile(baseDir,TAG + ".thd_tran.txt")),5,PGA_GAIN),vdd_V,TRAN_MEASURE_START_S,10,FCLK_HZ);

%% Plots
plotDiffAc(fAc_Hz,gain_dB,phase_deg,gainMid_dB,hp1dB_Hz,hp3dB_Hz,lp1dB_Hz,lp3dB_Hz,diffTran,plotDir);
plotRejection(cmrr,cmrrTran,'PATH CMRR','CMRR (dB)','NOM.cmrr.png',plotDir);
plotPsrr(psrrp,psrrn,psrrpTran,psrrnTran,plotDir);
plotNoise(noise,NOISE_PLOT_FREQ_HZ,plotDir);
plotOffsetPairs(rowsForValue(readTxt(fullfile(baseDir,TAG + ".vcmdcoffset_tran.txt")),4,PGA_GAIN),'cm,os',plotDir,'NOM.vcmdcoffset');
plotOffsetPairs(rowsForValue(readTxt(fullfile(baseDir,TAG + ".vdiffdcoffset_tran.txt")),4,PGA_GAIN),'diff,os',plotDir,'NOM.vdiffdcoffset');
plotStartupCompare(readTxt(fullfile(baseDir,TAG + ".startup_with_reset.txt")), ...
    readTxt(fullfile(baseDir,TAG + ".startup_without_reset.txt")),plotDir);
plotRld(readTxt(fullfile(baseDir,TAG + ".rld_off.txt")),readTxt(fullfile(baseDir,TAG + ".rld_on.txt")),plotDir);
plotThd(thd,plotDir);

%% Summary table
rows = [
    "Operating point","Supply voltage","V",fmt(vdd_V)
    "Operating point","Total supply current","mA",fmt(idd_A*1e3)
    "Operating point","Total power","mW",fmt(power_W*1e3)
    "Operating point","Bias current diagnostic","uA",fmt(ibias_A*1e6)
    "Operating point","Input common mode","V",fmt(vinCmDc_V)
    "Operating point","Input differential DC","mV",fmt(vinDiffDc_mV)
    "Operating point","OUTP DC","V",fmt(outpDc_V)
    "Operating point","OUTN DC","V",fmt(outnDc_V)
    "Operating point","Output common mode","V",fmt(outCmDc_V)
    "Operating point","Output CM error","mV",fmt(outCmErr_mV)
    "Operating point","Output differential DC","mV",fmt(outDiffDc_mV)
    "Operating point","RLD DC","V",fmt(rldDc_V)
    "Operating point","Output low headroom","V",fmt(headroomLow_V)
    "Operating point","Output high headroom","V",fmt(headroomHigh_V)
    "AC response","Expected gain","V/V",fmt(EXPECTED_GAIN_VV)
    "AC response","Expected gain","dB",fmt(expectedGain_dB)
    "AC response","Midband gain","V/V",fmt(gainMid_VV)
    "AC response","Midband gain","dB",fmt(gainMid_dB)
    "AC response","Gain error","dB",fmt(gainError_dB)
    "AC response","Gain @ 0.05 Hz","dB",fmt(gainAt_dB(1))
    "AC response","Gain @ 60 Hz","dB",fmt(gainAt_dB(2))
    "AC response","Gain @ 150 Hz","dB",fmt(gainAt_dB(3))
    "AC response","Gain @ 1 kHz","dB",fmt(gainAt_dB(4))
    "AC response","Phase @ 0.05 Hz","deg",fmt(phaseAt_deg(1))
    "AC response","Phase @ 60 Hz","deg",fmt(phaseAt_deg(2))
    "AC response","Phase @ 150 Hz","deg",fmt(phaseAt_deg(3))
    "AC response","HP -1dB corner","Hz",fmt(hp1dB_Hz)
    "AC response","HP -3dB corner","Hz",fmt(hp3dB_Hz)
    "AC response","LP -1dB corner","Hz",fmt(lp1dB_Hz)
    "AC response","LP -3dB corner","Hz",fmt(lp3dB_Hz)
    "AC response","Gain flatness 0.05-150 Hz","dB",fmt(gainFlatness_dB)
    "AC rejection","CMRR @ 0.05 Hz","dB",fmt(cmrrAt_dB(1))
    "AC rejection","CMRR @ 60 Hz","dB",fmt(cmrrAt_dB(2))
    "AC rejection","CMRR @ 150 Hz","dB",fmt(cmrrAt_dB(3))
    "AC rejection","CMRR @ 1 kHz","dB",fmt(cmrrAt_dB(4))
    "AC rejection","PSRR+ @ 0.05 Hz","dB",fmt(psrrPAt_dB(1))
    "AC rejection","PSRR+ @ 60 Hz","dB",fmt(psrrPAt_dB(2))
    "AC rejection","PSRR+ @ 150 Hz","dB",fmt(psrrPAt_dB(3))
    "AC rejection","PSRR+ @ 1 kHz","dB",fmt(psrrPAt_dB(4))
    "AC rejection","PSRR- @ 0.05 Hz","dB",fmt(psrrNAt_dB(1))
    "AC rejection","PSRR- @ 60 Hz","dB",fmt(psrrNAt_dB(2))
    "AC rejection","PSRR- @ 150 Hz","dB",fmt(psrrNAt_dB(3))
    "AC rejection","PSRR- @ 1 kHz","dB",fmt(psrrNAt_dB(4))
    "Noise","Input noise 0.05-150 Hz","uVrms",fmt(noiseInBand_Vrms*1e6)
    "Noise","Input noise 0.01-1 kHz","uVrms",fmt(noiseInTotal_Vrms*1e6)
    "Noise","Input noise density @ 0.05 Hz","nV/rtHz",fmt(noiseInAt(1)*1e9)
    "Noise","Input noise density @ 1 Hz","nV/rtHz",fmt(noiseInAt(2)*1e9)
    "Noise","Input noise density @ 10 Hz","nV/rtHz",fmt(noiseInAt(3)*1e9)
    "Noise","Input noise density @ 60 Hz","nV/rtHz",fmt(noiseInAt(4)*1e9)
    "Noise","Input noise density @ 150 Hz","nV/rtHz",fmt(noiseInAt(5)*1e9)
    "Noise","Input noise density @ 1 kHz","nV/rtHz",fmt(noiseInAt(6)*1e9)
    "Noise","Input-referred SNR, 0.5 mVpp","dB",fmt(snrIn_dB)
    "Transient response","Gain @ 0.05 Hz","dB",fmt(valueAt(diffTran.freq_Hz,diffTran.gain_dB,0.05))
    "Transient response","Gain @ 60 Hz","dB",fmt(valueAt(diffTran.freq_Hz,diffTran.gain_dB,60))
    "Transient response","Gain @ 150 Hz","dB",fmt(valueAt(diffTran.freq_Hz,diffTran.gain_dB,150))
    "Transient response","Gain error @ 0.05 Hz vs AC","dB",fmt(valueAt(diffTran.freq_Hz,diffTran.gainErr_dB,0.05))
    "Transient response","Gain error @ 60 Hz vs AC","dB",fmt(valueAt(diffTran.freq_Hz,diffTran.gainErr_dB,60))
    "Transient response","Gain error @ 150 Hz vs AC","dB",fmt(valueAt(diffTran.freq_Hz,diffTran.gainErr_dB,150))
    "Transient rejection","CMRR tran @ 0.05 Hz","dB",fmt(valueAt(cmrrTran.freq_Hz,cmrrTran.rej_dB,0.05))
    "Transient rejection","CMRR tran @ 60 Hz","dB",fmt(valueAt(cmrrTran.freq_Hz,cmrrTran.rej_dB,60))
    "Transient rejection","CMRR tran @ 150 Hz","dB",fmt(valueAt(cmrrTran.freq_Hz,cmrrTran.rej_dB,150))
    "Transient rejection","CMRR tran @ 1 kHz","dB",fmt(valueAt(cmrrTran.freq_Hz,cmrrTran.rej_dB,1e3))
    "Transient rejection","PSRR+ tran @ 0.05 Hz","dB",fmt(valueAt(psrrpTran.freq_Hz,psrrpTran.rej_dB,0.05))
    "Transient rejection","PSRR+ tran @ 60 Hz","dB",fmt(valueAt(psrrpTran.freq_Hz,psrrpTran.rej_dB,60))
    "Transient rejection","PSRR+ tran @ 150 Hz","dB",fmt(valueAt(psrrpTran.freq_Hz,psrrpTran.rej_dB,150))
    "Transient rejection","PSRR+ tran @ 1 kHz","dB",fmt(valueAt(psrrpTran.freq_Hz,psrrpTran.rej_dB,1e3))
    "Transient rejection","PSRR- tran @ 0.05 Hz","dB",fmt(valueAt(psrrnTran.freq_Hz,psrrnTran.rej_dB,0.05))
    "Transient rejection","PSRR- tran @ 60 Hz","dB",fmt(valueAt(psrrnTran.freq_Hz,psrrnTran.rej_dB,60))
    "Transient rejection","PSRR- tran @ 150 Hz","dB",fmt(valueAt(psrrnTran.freq_Hz,psrrnTran.rej_dB,150))
    "Transient rejection","PSRR- tran @ 1 kHz","dB",fmt(valueAt(psrrnTran.freq_Hz,psrrnTran.rej_dB,1e3))
    "Offset tolerance","VCM offset post-reset max CM error","mV",fmt(cmOffset.maxCmErr_mV)
    "Offset tolerance","VCM offset post-reset max |VOUT,diff|","V",fmt(cmOffset.maxDiffAbs_V)
    "Offset tolerance","VCM offset post-reset clipped","",fmt(cmOffset.clipped)
    "Offset tolerance","VCM offset post-reset gain 0.5 mVpp","V/V",fmt(cmOffset.gain05m_VV)
    "Offset tolerance","VCM offset post-reset gain 5 mVpp","V/V",fmt(cmOffset.gain5m_VV)
    "Offset tolerance","VDIFF offset post-reset max CM error","mV",fmt(diffOffset.maxCmErr_mV)
    "Offset tolerance","VDIFF offset post-reset max |VOUT,diff|","V",fmt(diffOffset.maxDiffAbs_V)
    "Offset tolerance","VDIFF offset post-reset clipped","",fmt(diffOffset.clipped)
    "Offset tolerance","VDIFF offset post-reset gain 0.5 mVpp","V/V",fmt(diffOffset.gain05m_VV)
    "Offset tolerance","VDIFF offset post-reset gain 5 mVpp","V/V",fmt(diffOffset.gain5m_VV)
    "Startup reset","VIN,diff pre-reset","mV",fmt(startupReset.preVinDiffMean_V*1e3)
    "Startup reset","VIN,diff post-reset","mV",fmt(startupReset.postVinDiffMean_V*1e3)
    "Startup reset","VIN,CM final","V",fmt(startupReset.postVinCmMean_V)
    "Startup reset","VOUT,diff pre-reset","V",fmt(startupReset.preDiffMean_V)
    "Startup reset","VOUT,diff post-reset","mV",fmt(startupReset.postDiffMean_V*1e3)
    "Startup reset","Offset removal","%",fmt(startupReset.removal_pct)
    "Startup reset","Reset attenuation","dB",fmt(startupReset.attenuation_dB)
    "Startup reset","No-reset final VOUT,diff","V",fmt(startupNoReset.postDiffMean_V)
    "Startup reset","Reset improvement vs no reset","dB",fmt(resetImprovement_dB)
    "Startup reset","Settling to +/-10 mV","ms",fmt(startupReset.settle10mV_s*1e3)
    "Startup reset","Settling to 1% of pre-reset","ms",fmt(startupReset.settle1pct_s*1e3)
    "Startup reset","Post-reset ripple p-p","mV",fmt(startupReset.ripplePp_V*1e3)
    "Startup reset","Post-reset ripple RMS","mV",fmt(startupReset.rippleRms_V*1e3)
    "Startup reset","VOUT,CM final","V",fmt(startupReset.postCmMean_V)
    "Startup reset","VOUT,CM final error","mV",fmt(startupReset.postCmErr_mV)
    "Startup reset","Max CM deviation during reset","mV",fmt(startupReset.resetCmDevMax_mV)
    "Startup reset","Max CM deviation after reset","mV",fmt(startupReset.postCmDevMax_mV)
    "Startup reset","Final OUTP","V",fmt(startupReset.finalOutp_V)
    "Startup reset","Final OUTN","V",fmt(startupReset.finalOutn_V)
    "Startup reset","Output stuck near rail","",fmt(startupReset.stuckRail)
    "Startup reset","Pass","",fmt(startupReset.pass)
    "RLD","Input CM improvement","dB",fmt(rld.inputCmImprove_dB)
    "RLD","Output diff improvement","dB",fmt(rld.outDiffImprove_dB)
    "RLD","RLD drive max on","V",fmt(rld.rldMaxOn_V)
    "THD","Maximum THD","%",fmt(thd.max_pct)
];

summary = array2table(rows,'VariableNames',{'Category','Parameter','Unit','Value'});
disp(summary);
writetable(summary,fullfile(scriptDir,'PATH_summary.csv'));

%% Local functions
function data = readTxt(file)
    if ~isfile(file), error('Missing file: %s',file); end
    data = readmatrix(file,'FileType','text');
    data = data(all(isfinite(data),2),:);
end

function d = rowsForValue(d,col,val)
    if size(d,2) < col, d = d([],:); return; end
    d = d(abs(d(:,col)-val) < max(1e-12,abs(val)*1e-9),:);
end

function d = uniqueFreqRows(d)
    if isempty(d), return; end
    [~,idx] = sort(d(:,1));
    d = d(idx,:);
    [~,~,grp] = unique(d(:,1));
    out = zeros(max(grp),size(d,2));
    for k = 1:size(d,2)
        out(:,k) = accumarray(grp,d(:,k),[],@mean);
    end
    d = out;
end

function row = lastRow(data)
    if isempty(data), row = NaN(1,size(data,2)); else, row = data(end,:); end
end

function y = pick(x,idx)
    if numel(x) < idx, y = NaN; else, y = x(idx); end
end

function z = complexCol(d,r,i)
    z = d(:,r) + 1j*d(:,i);
end

function r = rejectionAc(d,fDiff,gainDiff_dB)
    r.f_Hz = d(:,1);
    gainDiffAtF_dB = interpAtFreq(fDiff,gainDiff_dB,r.f_Hz);
    r.rej_dB = gainDiffAtF_dB - d(:,15);
    r.cmOut_dB = NaN(size(r.f_Hz));
end

function noise = readNoiseDiff(file,pgaGain)
    d = uniqueFreqRows(rowsForValue(readTxt(file),2,pgaGain));
    noise.f_Hz = d(:,1);
    noise.out_VrtHz = abs(d(:,3));
    noise.in_VrtHz = abs(d(:,4));
end

function m = diffTranMetrics(d,fAc,gainAc_dB,vdd,measureStart,maxCycles,fclk)
    m = struct('freq_Hz',[],'gain_dB',[],'phase_deg',[],'gainErr_dB',[], ...
        'outCmMean_V',[],'outCmErr_mV',[],'outCmRms_mV',[],'outCmPp_mV',[]);
    for f0 = uniqueStable(d(:,3))'
        seg = cleanSegment(d(abs(d(:,3)-f0) < max(1e-12,abs(f0)*1e-9),:));
        seg = postSignalCycleSegment(seg,f0,8,vdd,measureStart,maxCycles);
        if size(seg,1) < 8, continue; end
        [ain,phIn] = sineFitClean(seg(:,1),seg(:,5),f0,fclk);
        [aout,phOut] = sineFitClean(seg(:,1),seg(:,7),f0,fclk);
        g = 20*log10(aout/ain);
        p = wrapDeg(phOut - phIn);
        cm = seg(:,6);
        m.freq_Hz(end+1,1) = f0; %#ok<AGROW>
        m.gain_dB(end+1,1) = g; %#ok<AGROW>
        m.phase_deg(end+1,1) = p; %#ok<AGROW>
        m.gainErr_dB(end+1,1) = g - interpAtFreq(fAc,gainAc_dB,f0); %#ok<AGROW>
        m.outCmMean_V(end+1,1) = meanFinite(cm); %#ok<AGROW>
        m.outCmErr_mV(end+1,1) = (meanFinite(cm)-vdd/2)*1e3; %#ok<AGROW>
        m.outCmRms_mV(end+1,1) = rmsFinite(cm-meanFinite(cm))*1e3; %#ok<AGROW>
        m.outCmPp_mV(end+1,1) = rangeFinite(cm)*1e3; %#ok<AGROW>
    end
end

function m = rejectionTranMetrics(d,fAc,Hd,vdd,measureStart,maxCycles,fclk)
    m = struct('freq_Hz',[],'rej_dB',[],'cmOutGain_dB',[]);
    for f0 = uniqueStable(d(:,3))'
        seg = cleanSegment(d(abs(d(:,3)-f0) < max(1e-12,abs(f0)*1e-9),:));
        seg = postSignalCycleSegment(seg,f0,7,vdd,measureStart,maxCycles);
        if size(seg,1) < 8, continue; end
        ain = sineAmplitudeClean(seg(:,1),seg(:,4),f0,fclk);
        aoutCm = sineAmplitudeClean(seg(:,1),seg(:,5),f0,fclk);
        aoutDiff = sineAmplitudeClean(seg(:,1),seg(:,6),f0,fclk);
        ad_dB = 20*log10(abs(interpComplexAtFreq(fAc,Hd,f0)));
        rej = ad_dB + 20*log10(ain/aoutDiff);
        m.freq_Hz(end+1,1) = f0;
        m.rej_dB(end+1,1) = rej;
        m.cmOutGain_dB(end+1,1) = 20*log10(aoutCm/ain);
    end
end

function m = offsetMetrics(d,vdd,targetCm,measureStart,maxCycles)
    m = struct('maxCmErr_mV',NaN,'maxDiffAbs_V',NaN,'clipped',NaN, ...
        'gain05m_VV',NaN,'gain5m_VV',NaN);
    if size(d,2) < 12, return; end
    maxCmErr = [];
    maxDiffAbs = [];
    clipped = [];
    gains05 = [];
    gains5 = [];
    cfgKeys = unique(d(:,2:5),'rows','stable');
    for k = 1:size(cfgKeys,1)
        seg = d(all(abs(d(:,2:5)-cfgKeys(k,:)) < 1e-12,2),:);
        if ~hasResetPulse(seg,6,vdd), continue; end
        seg = postSignalCycleSegment(seg,60,6,vdd,measureStart,maxCycles);
        if size(seg,1) < 4, continue; end

        vinDiff = seg(:,9);
        voutCm = seg(:,10);
        voutDiff = seg(:,11);
        outp = voutCm + 0.5*voutDiff;
        outn = voutCm - 0.5*voutDiff;

        maxCmErr(end+1,1) = max(abs(voutCm-targetCm)); %#ok<AGROW>
        maxDiffAbs(end+1,1) = max(abs(voutDiff)); %#ok<AGROW>
        clipped(end+1,1) = any(outp < 0.05 | outp > vdd-0.05 | outn < 0.05 | outn > vdd-0.05); %#ok<AGROW>

        gain_VV = meanFinite(abs(voutDiff - meanFinite(voutDiff))) / ...
            meanFinite(abs(vinDiff - meanFinite(vinDiff)));
        if abs(cfgKeys(k,2) - 0.5e-3) < 1e-12 && abs(cfgKeys(k,4)) < 1e-12
            gains05(end+1,1) = gain_VV; %#ok<AGROW>
        elseif abs(cfgKeys(k,2) - 5e-3) < 1e-12 && abs(cfgKeys(k,4)) < 1e-12
            gains5(end+1,1) = gain_VV; %#ok<AGROW>
        end
    end
    m.maxCmErr_mV = maxFinite(maxCmErr)*1e3;
    m.maxDiffAbs_V = maxFinite(maxDiffAbs);
    m.clipped = double(any(clipped));
    m.gain05m_VV = meanFinite(gains05);
    m.gain5m_VV = meanFinite(gains5);
end

function m = startupMetrics(d,vdd,targetCm)
    m = struct('preVinDiffMean_V',NaN,'postVinDiffMean_V',NaN,'postVinCmMean_V',NaN, ...
        'preDiffMean_V',NaN,'postDiffMean_V',NaN,'removal_pct',NaN,'attenuation_dB',NaN, ...
        'settle10mV_s',NaN,'settle1pct_s',NaN,'ripplePp_V',NaN,'rippleRms_V',NaN, ...
        'postCmMean_V',NaN,'postCmErr_mV',NaN,'resetCmDevMax_mV',NaN,'postCmDevMax_mV',NaN, ...
        'finalOutp_V',NaN,'finalOutn_V',NaN,'stuckRail',NaN,'pass',NaN);
    if size(d,2) < 10, return; end
    t = d(:,1); rst = d(:,2); vinCm = d(:,4); vinDiff = d(:,5);
    voutCm = d(:,6); voutDiff = d(:,7); outp = d(:,8); outn = d(:,9);
    clkPeriod_s = 4e-3;
    wPre = [60e-3 76e-3];
    wReset = [84e-3 96e-3];
    wPost = [160e-3 196e-3];
    fallTime = resetFallTime(t,rst,vdd/2);

    m.preVinDiffMean_V = windowMean(t,vinDiff,wPre);
    m.postVinDiffMean_V = windowMean(t,vinDiff,wPost);
    m.postVinCmMean_V = windowMean(t,vinCm,wPost);
    m.preDiffMean_V = windowMean(t,voutDiff,wPre);
    m.postDiffMean_V = windowMean(t,voutDiff,wPost);
    if abs(m.preDiffMean_V) > 1e-12
        m.removal_pct = 100*(1 - abs(m.postDiffMean_V)/abs(m.preDiffMean_V));
        m.attenuation_dB = 20*log10(abs(m.postDiffMean_V)/abs(m.preDiffMean_V));
    end
    [tc,vc] = clockCycleAverage(t,voutDiff,clkPeriod_s);
    m.settle10mV_s = cycleSettleTime(tc,vc,0,10e-3,fallTime,5);
    m.settle1pct_s = cycleSettleTime(tc,vc,0,0.01*abs(m.preDiffMean_V),fallTime,5);
    postDiff = windowData(t,voutDiff,wPost);
    postDiffAc = postDiff - meanFinite(postDiff);
    m.ripplePp_V = rangeFinite(postDiffAc);
    m.rippleRms_V = rmsFinite(postDiffAc);
    m.postCmMean_V = windowMean(t,voutCm,wPost);
    m.postCmErr_mV = (m.postCmMean_V - targetCm)*1e3;
    m.resetCmDevMax_mV = windowMaxAbs(t,voutCm-targetCm,wReset)*1e3;
    m.postCmDevMax_mV = windowMaxAbs(t,voutCm-targetCm,wPost)*1e3;
    m.finalOutp_V = tailMean(outp);
    m.finalOutn_V = tailMean(outn);
    m.stuckRail = double(m.finalOutp_V < 0.05 || m.finalOutp_V > vdd-0.05 || ...
        m.finalOutn_V < 0.05 || m.finalOutn_V > vdd-0.05);
    m.pass = double(abs(m.preVinDiffMean_V-0.3) <= 0.03 && ...
        abs(m.postVinDiffMean_V-0.3) <= 0.03 && ...
        abs(m.preDiffMean_V) > 10e-3 && abs(m.postDiffMean_V) < abs(m.preDiffMean_V) && ...
        abs(m.postCmErr_mV) <= 10 && m.stuckRail == 0 && isfinite(m.settle10mV_s));
end

function m = rldMetrics(off,on,vdd,measureStart,maxCycles,fclk)
    m = struct('inputCmImprove_dB',NaN,'outDiffImprove_dB',NaN,'rldMaxOn_V',NaN);
    if size(off,2) < 9 || size(on,2) < 9, return; end
    f0 = 60;
    off = postSignalCycleSegment(off,f0,9,vdd,measureStart,maxCycles);
    on = postSignalCycleSegment(on,f0,9,vdd,measureStart,maxCycles);
    if size(off,1) < 8 || size(on,1) < 8, return; end
    inOff = sineAmplitudeClean(off(:,1),off(:,3),f0,fclk);
    inOn = sineAmplitudeClean(on(:,1),on(:,3),f0,fclk);
    diffOff = sineAmplitudeClean(off(:,1),off(:,8),f0,fclk);
    diffOn = sineAmplitudeClean(on(:,1),on(:,8),f0,fclk);
    m.inputCmImprove_dB = 20*log10(inOff/inOn);
    m.outDiffImprove_dB = 20*log10(diffOff/diffOn);
    m.rldMaxOn_V = max(abs(on(:,5)));
end

function r = thdMetrics(d,vdd,measureStart,maxCycles,fclk)
    r = struct('freq_Hz',[],'inputPp_mV',[],'pgaGain',[],'thd_pct',[], ...
        'thd_dB',[],'fundAmp_V',[],'gain_VV',[],'maxOutDiff_V',[], ...
        'minOutDiff_V',[],'meanOutCm_V',[],'cmRipple_mV',[],'clipped',[],'max_pct',NaN);
    if size(d,2) < 9, return; end
    keys = unique(d(:,2:5),'rows','stable');
    for k = 1:size(keys,1)
        idx = all(abs(d(:,2:5)-keys(k,:)) < 1e-12,2);
        seg = cleanSegment(d(idx,:));
        seg = postSignalCycleSegment(seg,keys(k,2),9,vdd,measureStart,maxCycles);
        if size(seg,1) < 12, continue; end
        f0 = keys(k,2);
        a1 = sineAmplitudeClean(seg(:,1),seg(:,8),f0,fclk);
        harm = NaN(1,4);
        for h = 2:5, harm(h-1) = sineAmplitudeClean(seg(:,1),seg(:,8),h*f0,fclk); end
        thd = sqrt(sumFinite(harm.^2))/a1;
        r.freq_Hz(end+1,1) = f0; %#ok<AGROW>
        r.inputPp_mV(end+1,1) = keys(k,3)*1e3; %#ok<AGROW>
        r.pgaGain(end+1,1) = keys(k,4); %#ok<AGROW>
        r.thd_pct(end+1,1) = 100*thd; %#ok<AGROW>
        r.thd_dB(end+1,1) = 20*log10(thd); %#ok<AGROW>
        r.fundAmp_V(end+1,1) = a1; %#ok<AGROW>
        r.gain_VV(end+1,1) = 2*a1/keys(k,3); %#ok<AGROW>
        r.maxOutDiff_V(end+1,1) = max(seg(:,8)); %#ok<AGROW>
        r.minOutDiff_V(end+1,1) = min(seg(:,8)); %#ok<AGROW>
        r.meanOutCm_V(end+1,1) = meanFinite(seg(:,7)); %#ok<AGROW>
        r.cmRipple_mV(end+1,1) = rangeFinite(seg(:,7))*1e3; %#ok<AGROW>
        r.clipped(end+1,1) = double(any(abs(seg(:,8)) > vdd-0.1)); %#ok<AGROW>
    end
    r.max_pct = maxFinite(r.thd_pct);
end

function plotDiffAc(f,gain,phase,mid,hp1,hp3,lp1,lp3,tran,plotDir)
    figure;
    yyaxis left;
    semilogx(f,gain,'LineWidth',1.5,'DisplayName','AC gain'); hold on;
    yline(mid-1,'--','-1dB','HandleVisibility','off');
    yline(mid-3,'--','-3dB','HandleVisibility','off');
    addAcDbCursors(f,gain,[0.05 60 150]);
    addFreqCursor(hp1,sprintf('-1 dB: %s',freqText(hp1)));
    addFreqCursor(hp3,sprintf('-3 dB: %s',freqText(hp3)));
    addFreqCursor(lp1,sprintf('-1 dB: %s',freqText(lp1)));
    addFreqCursor(lp3,sprintf('-3 dB: %s',freqText(lp3)));
    addTranPoints(tran.freq_Hz,tran.gain_dB,[0.05 60 150],'Tran gain');
    ylabel('Gain (dB)');
    yyaxis right;
    semilogx(f,phase,'LineWidth',1.5,'DisplayName','AC phase');
    ylabel('Phase (deg)');
    stylePlot('Frequency (Hz)','PATH Differential AC Response');
    legend('Location','best');
    xlim([1e-3 1e4]);
    saveFig(plotDir,'NOM.diff_response.png');
end

function plotRejection(r,tran,titleText,yText,fileName,plotDir)
    figure;
    ok = isfinite(r.f_Hz) & isfinite(r.rej_dB);
    semilogx(r.f_Hz(ok),r.rej_dB(ok),'LineWidth',1.5,'DisplayName','AC'); hold on;
    addAcDbCursors(r.f_Hz,r.rej_dB,[0.05 60 150 1e3]);
    addTranPoints(tran.freq_Hz,tran.rej_dB,[0.05 60 150 1e3],'Tran');
    stylePlot('Frequency (Hz)',titleText);
    xlim([1e-3 1e4]); ylabel(yText); legend('Location','best');
    saveFig(plotDir,fileName);
end

function plotPsrr(p,n,pTran,nTran,plotDir)
    figure;
    tiledlayout(2,1,'TileSpacing','compact');
    nexttile; ok = isfinite(p.f_Hz) & isfinite(p.rej_dB);
    semilogx(p.f_Hz(ok),p.rej_dB(ok),'LineWidth',1.5,'DisplayName','AC'); hold on;
    addAcDbCursors(p.f_Hz,p.rej_dB,[0.05 60 150 1e3]);
    addTranPoints(pTran.freq_Hz,pTran.rej_dB,[0.05 60 150 1e3],'Tran');
    stylePlot('Frequency (Hz)','PATH PSRR+'); xlim([1e-3 1e4]); ylabel('PSRR+ (dB)'); legend('Location','best');
    nexttile; ok = isfinite(n.f_Hz) & isfinite(n.rej_dB);
    semilogx(n.f_Hz(ok),n.rej_dB(ok),'LineWidth',1.5,'DisplayName','AC'); hold on;
    addAcDbCursors(n.f_Hz,n.rej_dB,[0.05 60 150 1e3]);
    addTranPoints(nTran.freq_Hz,nTran.rej_dB,[0.05 60 150 1e3],'Tran');
    stylePlot('Frequency (Hz)','PATH PSRR-'); xlim([1e-3 1e4]); ylabel('PSRR- (dB)'); legend('Location','best');
    saveFig(plotDir,'NOM.psrr.png');
end

function plotNoise(noise,marks,plotDir)
    figure;
    loglog(noise.f_Hz,noise.in_VrtHz*1e9,'LineWidth',1.5,'DisplayName','Input referred'); hold on;
    set(gca,'XScale','log');
    set(gca,'YScale','log');
    xlim([0.05 150]);
    for f0 = marks
        y = interpAtFreq(noise.f_Hz,noise.in_VrtHz,f0)*1e9;
        addNoisePoint(f0,y,sprintf('%s: %.4g nV/rtHz',freqText(f0),y));
    end
    stylePlot('Frequency (Hz)','PATH Input-Referred Noise Density');
    ylabel('Input-referred noise (nV/rtHz)');
    legend('Location','best');
    saveFig(plotDir,'NOM.noise.png');
end

function plotOffsetPairs(d,offsetName,plotDir,filePrefix)
    offsets = [0.5 0.3 0 -0.3 -0.5];
    colors = [
        0.8500 0.3250 0.0980
        0.9290 0.6940 0.1250
        0.0000 0.4470 0.7410
        0.4660 0.6740 0.1880
        0.4940 0.1840 0.5560
    ];
    for inputPp = [0.5e-3 5e-3]
        figure; tiledlayout(2,1,'TileSpacing','compact');
        nexttile; yyaxis left; hold on;
        cmVals = [];
        for k = 1:numel(offsets)
            off = offsets(k);
            seg = offsetSeg(d,inputPp,off);
            if isempty(seg), continue; end
            cmVals = [cmVals; seg(:,8); seg(:,10)]; %#ok<AGROW>
            plot(seg(:,1),seg(:,8),':','Color',colors(k,:),'LineWidth',1.0, ...
                'DisplayName',sprintf('VIN,CM %s %+g mV',offsetName,off*1e3));
            plot(seg(:,1),seg(:,10),'-','Color',colors(k,:),'LineWidth',1.2, ...
                'DisplayName',sprintf('VOUT,CM %s %+g mV',offsetName,off*1e3));
        end
        ylabel('VIN,CM / VOUT,CM (V)');
        centerYLim(cmVals,1.65);
        rstSeg = offsetSeg(d,inputPp,0);
        yyaxis right; hold on;
        if ~isempty(rstSeg)
            plot(rstSeg(:,1),rstSeg(:,6),'--','LineWidth',1.1,'DisplayName','RST');
        end
        ylabel('RST (V)'); ylim([-0.1 3.4]);
        title(sprintf('PATH %s, %.4g mVpp input, With Reset',offsetName,inputPp*1e3),'Interpreter','none');
        grid on; legend('Location','bestoutside');
        nexttile; yyaxis left; hold on;
        inDiffVals_mV = [];
        for k = 1:numel(offsets)
            off = offsets(k);
            seg = offsetSeg(d,inputPp,off);
            if isempty(seg), continue; end
            inDiffVals_mV = [inDiffVals_mV; seg(:,9)*1e3]; %#ok<AGROW>
            plot(seg(:,1),seg(:,9)*1e3,':','Color',colors(k,:),'LineWidth',1.0, ...
                'DisplayName',sprintf('VIN,diff %s %+g mV',offsetName,off*1e3));
        end
        ylabel('VIN,diff (mV)');
        centerYLim(inDiffVals_mV,0);
        yyaxis right; hold on;
        outDiffVals = [];
        for k = 1:numel(offsets)
            off = offsets(k);
            seg = offsetSeg(d,inputPp,off);
            if isempty(seg), continue; end
            outDiffVals = [outDiffVals; seg(:,11)]; %#ok<AGROW>
            plot(seg(:,1),seg(:,11),'-','Color',colors(k,:),'LineWidth',1.2, ...
                'DisplayName',sprintf('VOUT,diff %s %+g mV',offsetName,off*1e3));
        end
        ylabel('VOUT,diff (V)'); centerYLim(outDiffVals,0);
        grid on; legend('Location','bestoutside'); xlabel('Time (s)');
        saveFig(plotDir,char(string(filePrefix) + "_vin" + milliText(inputPp*1e3) + ".png"));
    end
end

function seg = offsetSeg(d,inputPp,offset)
    idx = abs(d(:,3)-inputPp) < 1e-12 & abs(d(:,5)-offset) < 1e-12;
    seg = cleanSegment(d(idx,:));
end

function yes = hasResetPulse(seg,rstCol,vdd)
    yes = ~isempty(seg) && size(seg,2) >= rstCol && any(seg(:,rstCol) > vdd/2);
end

function seg = postSignalCycleSegment(seg,f0,rstCol,vdd,measureStart,maxCycles)
    seg = cleanSegment(seg);
    if isempty(seg), return; end
    if size(seg,2) >= rstCol && hasResetPulse(seg,rstCol,vdd)
        fallTime = resetFallTime(seg(:,1),seg(:,rstCol),vdd/2);
        if isfinite(fallTime)
            measureStart = max(measureStart,fallTime);
        end
    end
    if ~isfinite(f0) || f0 <= 0 || ~isfinite(measureStart)
        seg = seg(seg(:,1) >= measureStart,:);
        return;
    end
    tEnd = max(seg(:,1));
    nCycles = floor((tEnd - measureStart)*f0);
    if nCycles < 1
        seg = seg([],:);
        return;
    end
    nUse = min(nCycles,maxCycles);
    measureEnd = measureStart + nCycles/f0;
    measureBegin = measureEnd - nUse/f0;
    keep = seg(:,1) >= measureBegin & seg(:,1) <= measureEnd;
    seg = seg(keep,:);
end

function seg = postResetSettledSegment(seg,rstCol,vdd)
    seg = cleanSegment(seg);
    if isempty(seg) || size(seg,2) < rstCol, return; end
    t = seg(:,1);
    rst = seg(:,rstCol);
    fallTime = resetFallTime(t,rst,vdd/2);
    if isfinite(fallTime)
        startTime = fallTime + 20e-3;
    else
        startTime = min(t) + 0.8*(max(t)-min(t));
    end
    stopTime = max(t) - 4e-3;
    if stopTime <= startTime
        stopTime = max(t);
    end
    keep = t >= startTime & t <= stopTime;
    seg = seg(keep,:);
end

function plotStartupCompare(withReset,withoutReset,plotDir)
    if size(withReset,2) < 10 || size(withoutReset,2) < 10, return; end
    windows = [4 16; 60 76; 84 96; 104 120; 160 196]*1e-3;
    names = {'zero','pre','reset','early post','final'};
    t = withReset(:,1); rst = withReset(:,2); clk = withReset(:,3);
    vinCm = withReset(:,4); vinDiff = withReset(:,5); voutCm = withReset(:,6); voutDiff = withReset(:,7);
    riseT = resetRiseTime(t,rst,1.65);
    fallT = resetFallTime(t,rst,1.65);

    figure; tiledlayout(3,1,'TileSpacing','compact');
    nexttile;
    plot(t*1e3,rst,'LineWidth',1.2,'DisplayName','RST'); hold on;
    plot(t*1e3,clk,'LineWidth',1.0,'DisplayName','CLK');
    addTimeCursor(riseT*1e3,'RST rise'); addTimeCursor(fallT*1e3,'RST fall');
    title('PATH Reset Operation: RST and CLK','Interpreter','none');
    ylabel('Voltage (V)'); grid on; legend('Location','best');

    nexttile;
    yyaxis left; plot(t*1e3,vinDiff*1e3,':','LineWidth',1.1,'DisplayName','VIN,diff'); ylabel('VIN,diff (mV)'); hold on;
    yyaxis right; plot(t*1e3,voutDiff,'LineWidth',1.2,'DisplayName','VOUT,diff'); ylabel('VOUT,diff (V)'); hold on;
    addWindowCursors(windows*1e3,names);
    title('Differential Signals','Interpreter','none'); grid on; legend('Location','best');

    nexttile;
    plot(t*1e3,vinCm,':','LineWidth',1.1,'DisplayName','VIN,CM'); hold on;
    plot(t*1e3,voutCm,'LineWidth',1.2,'DisplayName','VOUT,CM');
    yline(1.65,'--','1.65 V','HandleVisibility','off');
    addWindowCursors(windows*1e3,names);
    title('Common-Mode Signals','Interpreter','none');
    xlabel('Time (ms)'); ylabel('Voltage (V)'); grid on; legend('Location','best');
    saveFig(plotDir,'NOM.startup_reset_operation.png');

    figure;
    yyaxis left;
    plot(withReset(:,1)*1e3,withReset(:,7),'LineWidth',1.3,'DisplayName','VOUT,diff with reset'); hold on;
    plot(withoutReset(:,1)*1e3,withoutReset(:,7),'LineWidth',1.3,'DisplayName','VOUT,diff without reset');
    ylabel('VOUT,diff (V)');
    ylim(commonYLim([withReset(:,7); withoutReset(:,7)]));
    yyaxis right;
    plot(withReset(:,1)*1e3,withReset(:,2),'--','LineWidth',1.1,'DisplayName','RST');
    hold on;
    plot(withReset(:,1)*1e3,withReset(:,5),':','LineWidth',1.1,'DisplayName','VIN,diff');
    ylabel('RST / VIN,diff (V)');
    ylim([-0.1 3.4]);
    title('PATH Startup: With Reset vs No Reset','Interpreter','none');
    xlabel('Time (ms)'); grid on; legend('Location','best');
    xlim([0 max([withReset(:,1); withoutReset(:,1)])*1e3]);
    saveFig(plotDir,'NOM.startup_reset_compare.png');
end

function plotRld(off,on,plotDir)
    figure; tiledlayout(2,1,'TileSpacing','compact');
    nexttile;
    plot(off(:,1),off(:,2),'LineWidth',1.2,'DisplayName','BODY off'); hold on;
    plot(on(:,1),on(:,2),'LineWidth',1.2,'DisplayName','BODY on');
    plot(off(:,1),off(:,3),':','LineWidth',1.0,'DisplayName','VIN,CM off');
    plot(on(:,1),on(:,3),':','LineWidth',1.0,'DisplayName','VIN,CM on');
    plot(off(:,1),off(:,7),'--','LineWidth',1.0,'DisplayName','VOUT,CM off');
    plot(on(:,1),on(:,7),'--','LineWidth',1.0,'DisplayName','VOUT,CM on');
    title('PATH RLD Off/On','Interpreter','none'); ylabel('Common-mode voltage (V)'); grid on; legend('Location','best');
    nexttile;
    yyaxis left; plot(off(:,1),off(:,8),'LineWidth',1.2,'DisplayName','VOUT,diff off'); hold on;
    plot(on(:,1),on(:,8),'LineWidth',1.2,'DisplayName','VOUT,diff on'); ylabel('VOUT,diff (V)');
    yyaxis right; plot(on(:,1),on(:,5),'LineWidth',1.2,'DisplayName','RLD on'); ylabel('RLD (V)');
    grid on; legend('Location','best'); xlabel('Time (s)');
    saveFig(plotDir,'NOM.rld.png');
end

function plotThd(thd,plotDir)
    if isempty(thd.thd_pct), return; end
    figure;
    labels = strings(numel(thd.thd_pct),1);
    for k = 1:numel(labels)
        labels(k) = sprintf('%.4g mVpp G%.4g %.4g Hz',thd.inputPp_mV(k),thd.pgaGain(k),thd.freq_Hz(k));
    end
    bar(categorical(labels),thd.thd_pct);
    ylabel('THD (%)'); title('PATH THD from VOUT,diff','Interpreter','none'); grid on;
    saveFig(plotDir,'NOM.thd.png');
end

function d = cleanSegment(d)
    if isempty(d), return; end
    [~,idx] = sort(d(:,1)); d = d(idx,:);
    [~,idx] = unique(d(:,1),'stable'); d = d(idx,:);
end

function x = uniqueStable(x)
    x = unique(x(isfinite(x)),'stable');
end

function [A,phase] = sineFit(t,x,f)
    ok = isfinite(t) & isfinite(x) & isfinite(f);
    t = t(ok); x = x(ok);
    if numel(t) < 4 || f <= 0, A = NaN; phase = NaN; return; end
    t = t(:); x = x(:);
    M = [sin(2*pi*f*t), cos(2*pi*f*t), ones(size(t)), t-mean(t)];
    b = M \ x;
    A = hypot(b(1),b(2));
    phase = atan2(b(2),b(1))*180/pi;
end

function [A,phase] = sineFitClean(t,x,f,fclk)
    ok = isfinite(t) & isfinite(x) & isfinite(f);
    t = t(ok); x = x(ok);
    if numel(t) < 8 || f <= 0
        A = NaN; phase = NaN;
        return;
    end
    t = t(:); x = x(:);
    fitFreqs = f;
    for fr = [fclk 2*fclk]
        if isfinite(fr) && fr > 0 && all(abs(fitFreqs-fr) > max(1e-9,1e-6*fr))
            fitFreqs(end+1) = fr; %#ok<AGROW>
        end
    end
    M = [];
    for fr = fitFreqs
        M = [M, sin(2*pi*fr*t), cos(2*pi*fr*t)]; %#ok<AGROW>
    end
    M = [M, ones(size(t)), t-mean(t)];
    if size(M,1) <= size(M,2)
        [A,phase] = sineFit(t,x,f);
        return;
    end
    b = M \ x;
    A = hypot(b(1),b(2));
    phase = atan2(b(2),b(1))*180/pi;
end

function A = sineAmplitudeClean(t,x,f,fclk)
    [A,~] = sineFitClean(t,x,f,fclk);
end

function vn = integrateNoise(f,en,band)
    ok = f >= band(1) & f <= band(2) & isfinite(en);
    fb = f(ok); eb = en(ok);
    if numel(fb) < 2, vn = NaN; return; end
    vn = sqrt(trapz(fb,eb.^2));
end

function xw = windowData(t,x,win)
    ok = t >= win(1) & t <= win(2) & isfinite(x);
    xw = x(ok);
end

function y = windowMean(t,x,win)
    y = meanFinite(windowData(t,x,win));
end

function y = windowMaxAbs(t,x,win)
    xw = windowData(t,x,win);
    if isempty(xw), y = NaN; else, y = max(abs(xw)); end
end

function tr = resetRiseTime(t,rst,thr)
    tr = edgeTime(t,rst,thr,'rise');
end

function tf = resetFallTime(t,rst,thr)
    tf = edgeTime(t,rst,thr,'fall');
end

function te = edgeTime(t,x,thr,kind)
    te = NaN;
    if numel(t) < 2, return; end
    if strcmp(kind,'rise')
        idx = find(x(1:end-1) < thr & x(2:end) >= thr,1,'first');
    else
        idx = find(x(1:end-1) >= thr & x(2:end) < thr,1,'last');
    end
    if isempty(idx), return; end
    te = interp1(x(idx:idx+1),t(idx:idx+1),thr,'linear','extrap');
end

function [tc,xc] = clockCycleAverage(t,x,period)
    if isempty(t), tc = []; xc = []; return; end
    t0 = min(t);
    bin = floor((t-t0)/period);
    bins = unique(bin,'stable');
    tc = NaN(numel(bins),1); xc = NaN(numel(bins),1);
    for k = 1:numel(bins)
        idx = bin == bins(k);
        tc(k) = meanFinite(t(idx));
        xc(k) = meanFinite(x(idx));
    end
end

function ts = cycleSettleTime(t,x,target,tol,startTime,holdCycles)
    ts = NaN;
    if isempty(t) || ~isfinite(startTime) || ~isfinite(tol), return; end
    err = abs(x-target);
    idx0 = find(t >= startTime,1,'first');
    if isempty(idx0), return; end
    for k = idx0:(numel(t)-holdCycles+1)
        if all(err(k:k+holdCycles-1) <= tol)
            ts = t(k)-startTime;
            return;
        end
    end
end

function y = meanBand(f,x,band)
    ok = f >= band(1) & f <= band(2) & isfinite(x);
    if ~any(ok), y = NaN; else, y = mean(x(ok)); end
end

function y = bandRange(f,x,band)
    ok = f >= band(1) & f <= band(2) & isfinite(x);
    if ~any(ok), y = NaN; else, y = max(x(ok))-min(x(ok)); end
end

function y = rangeFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(x)-min(x); end
end

function y = meanFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = mean(x); end
end

function y = rmsFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = sqrt(mean(x.^2)); end
end

function y = maxFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(x); end
end

function y = sumFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = sum(x); end
end

function y = tailMean(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, n = max(1,ceil(0.1*numel(x))); y = mean(x(end-n+1:end)); end
end

function y = valueAt(f,x,f0)
    [~,idx] = min(abs(f-f0));
    if isempty(idx), y = NaN; else, y = x(idx); end
end

function f0 = cornerCrossing(f,x,target,refFreq,side)
    f0 = NaN;
    ok = isfinite(f) & isfinite(x);
    f = f(ok); x = x(ok);
    if strcmp(side,'hp'), idx = find(f < refFreq); sense = 'rise'; else, idx = find(f > refFreq); sense = 'fall'; end
    if numel(idx) < 2, return; end
    if strcmp(sense,'rise')
        k = find(x(idx(1:end-1)) <= target & x(idx(2:end)) >= target,1,'last');
    else
        k = find(x(idx(1:end-1)) >= target & x(idx(2:end)) <= target,1,'first');
    end
    if isempty(k), return; end
    ii = idx(k:k+1);
    f0 = 10.^interp1(x(ii),log10(f(ii)),target,'linear','extrap');
end

function y = interpAtFreq(f,x,f0)
    f = f(:); x = x(:);
    if numel(f0) > 1, y = arrayfun(@(ff) interpAtFreq(f,x,ff),f0); return; end
    ok = isfinite(f) & isfinite(x) & f > 0;
    if ~any(ok) || ~isfinite(f0)
        y = NaN;
    else
        f = f(ok); x = x(ok);
        [f,~,idx] = unique(f);
        x = accumarray(idx,x,[],@mean);
        y = interp1(log10(f),x,log10(f0),'linear','extrap');
    end
end

function y = interpComplexAtFreq(f,x,f0)
    y = interpAtFreq(f,real(x),f0) + 1j*interpAtFreq(f,imag(x),f0);
end

function a = wrapDeg(a)
    a = mod(a+180,360)-180;
end

function addTranPoints(freqs,values,marks,labelPrefix)
    if isempty(freqs) || isempty(values), return; end
    for f0 = marks
        y = valueAt(freqs,values,f0);
        if ~isfinite(y), continue; end
        plot(f0,y,'s','MarkerFaceColor',[1 0.6 0], ...
            'MarkerEdgeColor','w','MarkerSize',8, ...
            'LineStyle','none','DisplayName',sprintf('%s %s',labelPrefix,freqText(f0)));
        text(f0,y,sprintf(' %s: %.4g dB',freqText(f0),y), ...
            'Color','w','VerticalAlignment','top','HorizontalAlignment','left','Clipping','on');
    end
end

function addAcDbCursors(f,y,marks)
    for f0 = marks
        y0 = interpAtFreq(f,y,f0);
        addCursor(f0,y0,sprintf('%s: %.4g dB',freqText(f0),y0));
    end
end

function addCursor(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    xline(x,':',char(labelText),'HandleVisibility','off', ...
        'Color','w','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
end

function addNoisePoint(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    ax = gca;
    xl = xlim(ax);
    if strcmp(ax.XScale,'log')
        pad = 0.018*(log10(xl(2))-log10(xl(1)));
        xText = 10^(log10(x) + pad);
        if x <= xl(1)
            xText = 10^(log10(xl(1)) + pad);
        elseif x >= xl(2)
            xText = 10^(log10(xl(2)) - pad);
        end
    else
        pad = 0.018*(xl(2)-xl(1));
        xText = x + pad;
        if x <= xl(1)
            xText = xl(1) + pad;
        elseif x >= xl(2)
            xText = xl(2) - pad;
        end
    end
    plot(x,y,'o','MarkerFaceColor',[1 0.6 0], ...
        'MarkerEdgeColor','w','MarkerSize',6, ...
        'LineStyle','none','HandleVisibility','off');
    text(xText,y,char(labelText),'Color','w','VerticalAlignment','middle', ...
        'HorizontalAlignment','left','Clipping','on');
end

function addFreqCursor(x,labelText)
    if ~isfinite(x), return; end
    xline(x,':'," " + string(labelText),'HandleVisibility','off', ...
        'Color','w','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
end

function addTimeCursor(x,labelText)
    if ~isfinite(x), return; end
    xline(x,':',char(labelText),'HandleVisibility','off', ...
        'Color','w','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
end

function addWindowCursors(windows,names)
    for k = 1:size(windows,1)
        xline(windows(k,1),':',char(names{k}),'HandleVisibility','off', ...
            'Color','w','LabelVerticalAlignment','bottom', ...
            'LabelHorizontalAlignment','left');
        xline(windows(k,2),':','HandleVisibility','off','Color','w');
    end
end

function yl = commonYLim(x)
    x = x(isfinite(x));
    if isempty(x), yl = [-1 1]; return; end
    pad = 0.05*max(rangeFinite(x),eps);
    yl = [min(x)-pad max(x)+pad];
end

function centerYLim(x,center)
    x = x(isfinite(x));
    if isempty(x) || ~isfinite(center), return; end
    span = max(abs(x-center));
    span = 1.05*max(span,eps);
    ylim(center + [-span span]);
end

function stylePlot(xText,titleText)
    grid on;
    xlabel(xText);
    title(titleText,'Interpreter','none');
end

function saveFig(plotDir,fileName)
    saveas(gcf,fullfile(plotDir,fileName));
end

function s = freqText(f)
    if ~isfinite(f), s = 'NaN';
    elseif f >= 1e3, s = sprintf('%.4g kHz',f/1e3);
    else, s = sprintf('%.4g Hz',f);
    end
end

function s = milliText(x)
    s = string(strrep(sprintf('%.4g',x),'.','p')) + "m";
end

function s = fmt(x)
    if ~isfinite(x), s = "NaN"; else, s = string(sprintf('%.6g',x)); end
end
