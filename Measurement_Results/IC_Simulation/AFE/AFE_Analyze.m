% PATH nominal analysis
clear; clc; close all;
analysisTimer = tic;

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
FCLK_HZ = 500;

%% Operating point
opData = readTxt(fullfile(baseDir,TAG + ".op.txt"));
op = lastRow(rowsForValue(opData,2,PGA_GAIN));
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
diffAcData = readTxt(fullfile(baseDir,TAG + ".diff_ac.txt"));
cmrrAcData = readTxt(fullfile(baseDir,TAG + ".cmrr_ac.txt"));
psrrpAcData = readTxt(fullfile(baseDir,TAG + ".psrrp_ac.txt"));
psrrnAcData = readTxt(fullfile(baseDir,TAG + ".psrrn_ac.txt"));
diffAc = uniqueFreqRows(rowsForValue(diffAcData,2,PGA_GAIN));
fAc_Hz = diffAc(:,1);
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

cmrr = rejectionAc(uniqueFreqRows(rowsForValue(cmrrAcData,2,PGA_GAIN)),fAc_Hz,gain_dB);
psrrp = rejectionAc(uniqueFreqRows(rowsForValue(psrrpAcData,2,PGA_GAIN)),fAc_Hz,gain_dB);
psrrn = rejectionAc(uniqueFreqRows(rowsForValue(psrrnAcData,2,PGA_GAIN)),fAc_Hz,gain_dB);
cmrrAt_dB = interpAtFreq(cmrr.f_Hz,cmrr.rej_dB,MARK_FREQ_HZ);
psrrPAt_dB = interpAtFreq(psrrp.f_Hz,psrrp.rej_dB,MARK_FREQ_HZ);
psrrNAt_dB = interpAtFreq(psrrn.f_Hz,psrrn.rej_dB,MARK_FREQ_HZ);

%% Noise
noiseData = readTxt(fullfile(baseDir,TAG + ".noise_diff.txt"));
noise = noiseMetrics(noiseData,PGA_GAIN);
noiseInBand_Vrms = integrateNoise(noise.f_Hz,noise.in_VrtHz,NOISE_BAND_HZ);
noiseInTotal_Vrms = integrateNoise(noise.f_Hz,noise.in_VrtHz,NOISE_TOTAL_BAND_HZ);
noiseInAt = interpAtFreq(noise.f_Hz,noise.in_VrtHz,NOISE_DENSITY_FREQ_HZ);
signal05mVrms = 0.5e-3/(2*sqrt(2));
snrIn_dB = 20*log10(signal05mVrms/noiseInBand_Vrms);

%% Transient response, rejection, offsets, startup, RLD, THD
% Analyze every exported case using test-specific final-cycle windows.
diffTranAll = diffTranMetrics(readTxtOptional(fullfile(baseDir,TAG + ".diff_tran.txt")));
cmrrTranAll = rejectionTranMetrics(readTxtOptional(fullfile(baseDir,TAG + ".cmrr_tran.txt")), ...
    diffTranAll,20);
psrrpTranAll = rejectionTranMetrics(readTxtOptional(fullfile(baseDir,TAG + ".psrrp_tran.txt")), ...
    diffTranAll,20);
psrrnTranAll = rejectionTranMetrics(readTxtOptional(fullfile(baseDir,TAG + ".psrrn_tran.txt")), ...
    diffTranAll,20);
cmOffsetData = readTxtOptional(fullfile(baseDir,TAG + ".vcmdcoffset_tran.txt"));
diffOffsetData = readTxtOptional(fullfile(baseDir,TAG + ".vdiffdcoffset_tran.txt"));
startupResetData = readTxtOptional(fullfile(baseDir,TAG + ".startup_with_reset.txt"));
startupNoResetData = readTxtOptional(fullfile(baseDir,TAG + ".startup_without_reset.txt"));
rldOffData = readTxtOptional(fullfile(baseDir,TAG + ".rld_off.txt"));
rldOnData = readTxtOptional(fullfile(baseDir,TAG + ".rld_on.txt"));
cmOffset = offsetMetrics(cmOffsetData, ...
    vdd_V,VCM_TARGET_V,10);
diffOffset = offsetMetrics(diffOffsetData, ...
    vdd_V,VCM_TARGET_V,10);
startupReset = startupMetrics(startupResetData,vdd_V,VCM_TARGET_V,FCLK_HZ);
startupNoReset = startupMetrics(startupNoResetData,vdd_V,VCM_TARGET_V,FCLK_HZ);
resetImprovement_dB = 20*log10(abs(startupNoReset.postDiffMean_V)/abs(startupReset.postDiffMean_V));
rld = rldMetrics(rldOffData,rldOnData,10);
thd = thdMetrics(readTxtOptional(fullfile(baseDir,TAG + ".thd_tran.txt")),30,FCLK_HZ);

acPlotCases = buildAcPlotCases(diffAcData,cmrrAcData,psrrpAcData,psrrnAcData,[2 16]);

%% Plots
plotDiffAcCases(acPlotCases,diffTranAll,plotDir);
plotRejectionCases(acPlotCases,cmrrTranAll,'cmrr','PATH CMRR','CMRR (dB)','NOM.cmrr.png',plotDir);
plotPsrrCases(acPlotCases,psrrpTranAll,psrrnTranAll,plotDir);
plotNoise(noise,NOISE_PLOT_FREQ_HZ,plotDir);
plotOffsetPairs(cmOffsetData,'cm,os',plotDir,'NOM.vcmdcoffset');
plotOffsetPairs(diffOffsetData,'diff,os',plotDir,'NOM.vdiffdcoffset');
plotStartupCompare(startupResetData,startupNoResetData,plotDir);
plotRld(rldOffData,rldOnData,plotDir);
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
    "Startup reset","No-reset final VOUT,CM","V",fmt(startupNoReset.postCmMean_V)
    "Startup reset","Reset improvement vs no reset","dB",fmt(resetImprovement_dB)
    "Startup reset","VOUT,CM settling after reset","ms",fmt(startupReset.settleCm10mV_s*1e3)
    "Startup reset","Settling to +/-10 mV","ms",fmt(startupReset.settle10mV_s*1e3)
    "Startup reset","Settling to 1% of pre-reset","ms",fmt(startupReset.settle1pct_s*1e3)
    "Startup reset","No-reset VOUT,CM settling","ms",fmt(startupNoReset.settleCm10mV_s*1e3)
    "Startup reset","No-reset VOUT,diff settling","ms",fmt(startupNoReset.settle10mV_s*1e3)
    "Startup reset","Maximum |VOUT,diff|","V",fmt(startupReset.maxAbsOutDiff_V)
    "Startup reset","No-reset maximum |VOUT,diff|","V",fmt(startupNoReset.maxAbsOutDiff_V)
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
    "RLD","Body 60 Hz improvement","dB",fmt(rld.bodyImprove_dB)
    "RLD","Output diff improvement","dB",fmt(rld.outDiffImprove_dB)
    "RLD","RLD output 60 Hz amplitude","Vpk",fmt(rld.rldAmpOn_V)
    "RLD","RLD current peak","uA",fmt(rld.rldCurrentPeak_A*1e6)
    "RLD","RLD current RMS","uArms",fmt(rld.rldCurrentRms_A*1e6)
    "THD","Maximum THD","%",fmt(thd.max_pct)
];

rows = [rows; transientSummaryRows(diffTranAll,cmrrTranAll,psrrpTranAll, ...
    psrrnTranAll,cmOffset,diffOffset,thd)];

summary = array2table(rows,'VariableNames',{'Category','Parameter','Unit','Value'});
writetable(summary,fullfile(scriptDir,'PATH_summary.csv'));

reportRows = tableReportRows(opData,diffAcData,cmrrAcData,psrrpAcData, ...
    psrrnAcData,noiseData,diffTranAll,rld,thd);
terminalRows = strings(0,3);
for section = ["G2" "G16"]
    terminalRows(end+1,:) = [section "" ""]; %#ok<SAGROW>
    terminalRows = [terminalRows; reportRows(reportRows(:,1) == section,2:4)]; %#ok<AGROW>
    terminalRows(end+1,:) = ["" "" ""]; %#ok<SAGROW>
end
sharedRows = reportRows(reportRows(:,1) == "Shared",2:4);
terminalRows = [terminalRows
    "RLD" "" ""
    sharedRows(1:5,:)
    "" "" ""
    "THD" "" ""
    sharedRows(6:end,:)
];
tableReport = array2table(terminalRows, ...
    'VariableNames',{'Parameter','Unit','Value'});
disp(tableReport);
writetable(tableReport,fullfile(scriptDir,'PATH_table_report.csv'));
fprintf('PATH analysis completed in %.2f s.\n',toc(analysisTimer));

%% Local functions
function data = readTxt(file)
    if ~isfile(file), error('Missing file: %s',file); end
    key = char(file);
    data = load(key,'-ascii');
    finiteRows = all(isfinite(data),2);
    if ~all(finiteRows), data = data(finiteRows,:); end
end

function data = readTxtOptional(file)
    if ~isfile(file)
        warning('PATH_Analyze:MissingTransientFile', ...
            'Missing optional transient file: %s. Related metrics and plots will be skipped.',file);
        data = [];
        return;
    end
    data = readTxt(file);
end

function d = rowsForValue(d,col,val)
    if size(d,2) < col, d = d([],:); return; end
    d = d(abs(d(:,col)-val) < max(1e-12,abs(val)*1e-9),:);
end

function d = uniqueFreqRows(d)
    if isempty(d), return; end
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

function r = rejectionAc(d,fDiff,gainDiff_dB)
    r.f_Hz = d(:,1);
    gainDiffAtF_dB = interpAtFreq(fDiff,gainDiff_dB,r.f_Hz);
    r.rej_dB = gainDiffAtF_dB - d(:,15);
end

function noise = noiseMetrics(data,pgaGain)
    d = uniqueFreqRows(rowsForValue(data,2,pgaGain));
    noise.f_Hz = d(:,1);
    noise.out_VrtHz = abs(d(:,3));
    noise.in_VrtHz = abs(d(:,4));
end

function m = diffTranMetrics(d)
    m = struct('pgaGain',[],'freq_Hz',[],'gain_VV',[],'gain_dB',[], ...
        'gainErr_pct',[],'gainRel_dB',[],'attenFrom60_dB',[], ...
        'phase_deg',[],'outCmMean_V',[],'outCmPp_mV',[]);
    if size(d,2) < 8, return; end
    [keys,starts,stops] = caseRuns(d,2:3);
    for k = 1:size(keys,1)
        gain = keys(k,1); f0 = keys(k,2);
        seg = caseCycleSegment(d,starts(k),stops(k),f0, ...
            diffAnalysisCycles(f0),50000);
        if size(seg,1) < 8, continue; end
        [amps,phases] = sineFitMany(seg(:,1),seg(:,[5 7]),f0);
        ain = amps(1); aout = amps(2);
        phIn = phases(1); phOut = phases(2);
        gainVV = aout/ain;
        expected = 60*4*gain;
        g = 20*log10(gainVV);
        p = wrapDeg(phOut - phIn);
        cm = seg(:,6);
        m.pgaGain(end+1,1) = gain;
        m.freq_Hz(end+1,1) = f0;
        m.gain_VV(end+1,1) = gainVV;
        m.gain_dB(end+1,1) = g;
        m.gainErr_pct(end+1,1) = 100*(gainVV/expected-1);
        m.phase_deg(end+1,1) = p;
        m.outCmMean_V(end+1,1) = meanFinite(cm);
        m.outCmPp_mV(end+1,1) = rangeFinite(cm)*1e3;
    end
    m.gainRel_dB = NaN(size(m.gain_VV));
    m.attenFrom60_dB = NaN(size(m.gain_VV));
    for gain = unique(m.pgaGain)'
        idx = abs(m.pgaGain-gain) < 1e-12;
        g60 = valueAtExact(m.freq_Hz(idx),m.gain_VV(idx),60);
        m.gainRel_dB(idx,1) = 20*log10(m.gain_VV(idx)/g60);
        m.attenFrom60_dB(idx,1) = -m.gainRel_dB(idx);
    end
end

function cycles = diffAnalysisCycles(f0)
    if any(abs(f0-[0.05 0.1 0.5]) < 1e-9)
        cycles = 1;
    elseif any(abs(f0-[1 10]) < 1e-9)
        cycles = 3;
    elseif f0 >= 500
        cycles = 20;
    else
        cycles = 10;
    end
end

function m = rejectionTranMetrics(d,diffMetrics,maxCycles)
    m = struct('pgaGain',[],'freq_Hz',[],'outCmAmp_V',[],'rej_dB',[]);
    [keys,starts,stops] = caseRuns(d,2:3);
    for k = 1:size(keys,1)
        gain = keys(k,1); f0 = keys(k,2);
        seg = caseCycleSegment(d,starts(k),stops(k),f0,maxCycles,50000);
        if size(seg,1) < 8, continue; end
        amps = sineFitMany(seg(:,1),seg(:,4:6),f0);
        ain = amps(1); aoutCm = amps(2); aoutDiff = amps(3);
        ad = gainAtCase(diffMetrics,gain,f0);
        rej = 20*log10(ad*ain/aoutDiff);
        m.pgaGain(end+1,1) = gain;
        m.freq_Hz(end+1,1) = f0;
        m.outCmAmp_V(end+1,1) = aoutCm;
        m.rej_dB(end+1,1) = rej;
    end
end

function m = offsetMetrics(d,vdd,targetCm,maxCycles)
    m = struct('maxCmErr_mV',NaN,'maxDiffAbs_V',NaN,'clipped',NaN, ...
        'gain05m_VV',NaN,'gain5m_VV',NaN,'inputPp_mV',[], ...
        'pgaGain',[],'offset_V',[],'voutCmErr_mV',[],'voutDiffDc_V',[], ...
        'gain_VV',[],'gainErr_pct',[],'usable',[]);
    if size(d,2) < 12, return; end
    maxCmErr = [];
    maxDiffAbs = [];
    clipped = [];
    gains05 = [];
    gains5 = [];
    [cfgKeys,starts,stops] = caseRuns(d,2:5);
    for k = 1:size(cfgKeys,1)
        if ~any(d(starts(k):stops(k),6) > vdd/2), continue; end
        seg = caseCycleSegment(d,starts(k),stops(k),60,maxCycles,50000);
        if size(seg,1) < 4, continue; end

        vinDiff = seg(:,9);
        voutCm = seg(:,10);
        voutDiff = seg(:,11);
        outp = voutCm + 0.5*voutDiff;
        outn = voutCm - 0.5*voutDiff;

        isClipped = any(outp < 0.05 | outp > vdd-0.05 | outn < 0.05 | outn > vdd-0.05);
        maxCmErr(end+1,1) = max(abs(voutCm-targetCm)); %#ok<AGROW>
        maxDiffAbs(end+1,1) = max(abs(voutDiff)); %#ok<AGROW>
        clipped(end+1,1) = isClipped; %#ok<AGROW>

        amps = sineFitMany(seg(:,1),[vinDiff voutDiff],60);
        vinAmp = amps(1); voutAmp = amps(2);
        gain_VV = voutAmp/vinAmp;
        expected = 60*4*cfgKeys(k,3);
        m.inputPp_mV(end+1,1) = cfgKeys(k,2)*1e3;
        m.pgaGain(end+1,1) = cfgKeys(k,3); m.offset_V(end+1,1) = cfgKeys(k,4);
        m.voutCmErr_mV(end+1,1) = (meanFinite(voutCm)-targetCm)*1e3;
        m.voutDiffDc_V(end+1,1) = meanFinite(voutDiff);
        m.gain_VV(end+1,1) = gain_VV; m.gainErr_pct(end+1,1) = 100*(gain_VV/expected-1);
        m.usable(end+1,1) = double(~isClipped && isfinite(gain_VV) && abs(gain_VV/expected-1) <= 0.1);
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

function m = startupMetrics(d,vdd,targetCm,fclk)
    m = struct('preVinDiffMean_V',NaN,'postVinDiffMean_V',NaN,'postVinCmMean_V',NaN, ...
        'preDiffMean_V',NaN,'postDiffMean_V',NaN,'removal_pct',NaN,'attenuation_dB',NaN, ...
        'settle10mV_s',NaN,'settle1pct_s',NaN,'ripplePp_V',NaN,'rippleRms_V',NaN, ...
        'settleCm10mV_s',NaN,'maxAbsOutDiff_V',NaN, ...
        'postCmMean_V',NaN,'postCmErr_mV',NaN,'resetCmDevMax_mV',NaN,'postCmDevMax_mV',NaN, ...
        'finalOutp_V',NaN,'finalOutn_V',NaN,'stuckRail',NaN,'pass',NaN);
    if size(d,2) < 10, return; end
    t = d(:,1); rst = d(:,2); vinCm = d(:,4); vinDiff = d(:,5);
    voutCm = d(:,6); voutDiff = d(:,7); outp = d(:,8); outn = d(:,9);
    clkPeriod_s = 1/fclk;
    wPre = [30e-3 40e-3];
    wReset = [40e-3 60e-3];
    wPost = [180e-3 200e-3];
    fallTime = resetFallTime(t,rst,vdd/2);
    if ~isfinite(fallTime), fallTime = 60e-3; end

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
    [tcCm,vcCm] = clockCycleAverage(t,voutCm,clkPeriod_s);
    finalDiff = m.postDiffMean_V;
    m.postCmMean_V = windowMean(t,voutCm,wPost);
    m.settle10mV_s = cycleSettleTime(tc,vc,finalDiff,10e-3,fallTime);
    m.settle1pct_s = cycleSettleTime(tc,vc,finalDiff, ...
        max(0.01*max(abs(finalDiff),abs(m.preDiffMean_V)),1e-6),fallTime);
    m.settleCm10mV_s = cycleSettleTime(tcCm,vcCm,m.postCmMean_V,10e-3,fallTime);
    m.maxAbsOutDiff_V = max(abs(voutDiff));
    postDiff = windowData(t,voutDiff,wPost);
    postDiffAc = postDiff - meanFinite(postDiff);
    m.ripplePp_V = rangeFinite(postDiffAc);
    m.rippleRms_V = rmsFinite(postDiffAc);
    m.postCmErr_mV = (m.postCmMean_V - targetCm)*1e3;
    m.resetCmDevMax_mV = windowMaxAbs(t,voutCm-targetCm,wReset)*1e3;
    m.postCmDevMax_mV = windowMaxAbs(t,voutCm-targetCm,wPost)*1e3;
    m.finalOutp_V = tailMean(outp);
    m.finalOutn_V = tailMean(outn);
    m.stuckRail = double(m.finalOutp_V < 0.05 || m.finalOutp_V > vdd-0.05 || ...
        m.finalOutn_V < 0.05 || m.finalOutn_V > vdd-0.05);
    m.pass = double(abs(m.postCmErr_mV) <= 10 && m.stuckRail == 0 && ...
        isfinite(m.settle10mV_s));
end

function out = metricGain(in,gain)
    out = in;
    keep = abs(in.pgaGain-gain) < 1e-12;
    names = fieldnames(in);
    for k = 1:numel(names)
        value = in.(names{k});
        if isvector(value) && numel(value) == numel(keep)
            out.(names{k}) = value(keep);
        end
    end
end

function gain = gainAtCase(m,pgaGain,f0)
    idx = abs(m.pgaGain-pgaGain) < 1e-12;
    if any(idx)
        gain = valueAtExact(m.freq_Hz(idx),m.gain_VV(idx),f0);
    else
        gain = NaN;
    end
    % diff_tran has no 1-kHz case.  Use the documented nominal gain instead
    % of extrapolating three transient points across nearly a decade.
    if ~isfinite(gain), gain = 60*4*pgaGain; end
end

function m = rldMetrics(off,on,maxCycles)
    m = struct('inputCmImprove_dB',NaN,'bodyImprove_dB',NaN, ...
        'outDiffImprove_dB',NaN,'rldAmpOn_V',NaN, ...
        'rldMinOn_V',NaN,'rldMaxOn_V',NaN, ...
        'rldCurrentPeak_A',NaN,'rldCurrentRms_A',NaN);
    if size(off,2) < 9 || size(on,2) < 9, return; end
    f0 = 60;
    off = signalCycleSegment(off,f0,maxCycles);
    on = signalCycleSegment(on,f0,maxCycles);
    if size(off,1) < 8 || size(on,1) < 8, return; end
    offAmps = sineFitMany(off(:,1),off(:,[2 3 8]),f0);
    onAmps = sineFitMany(on(:,1),on(:,[2 3 5 6 8]),f0);
    bodyOff = offAmps(1); inOff = offAmps(2); diffOff = offAmps(3);
    bodyOn = onAmps(1); inOn = onAmps(2); rldAmp = onAmps(3);
    rldCurrentAmp_A = onAmps(4); diffOn = onAmps(5);
    m.inputCmImprove_dB = 20*log10(inOff/inOn);
    m.bodyImprove_dB = 20*log10(bodyOff/bodyOn);
    m.outDiffImprove_dB = 20*log10(diffOff/diffOn);
    m.rldAmpOn_V = rldAmp;
    m.rldMinOn_V = min(on(:,5));
    m.rldMaxOn_V = max(on(:,5));
    m.rldCurrentPeak_A = rldCurrentAmp_A;
    m.rldCurrentRms_A = rldCurrentAmp_A/sqrt(2);
end

function r = thdMetrics(d,maxCycles,fclk)
    r = struct('freq_Hz',[],'inputPp_mV',[],'pgaGain',[],'thd_pct',[], ...
        'thd_dB',[],'fundAmp_V',[],'harmonicAmp_V',zeros(0,10), ...
        'max_pct',NaN);
    if size(d,2) < 9, return; end
    [keys,starts,stops] = caseRuns(d,2:5);
    for k = 1:size(keys,1)
        seg = caseCycleSegment(d,starts(k),stops(k),keys(k,2),maxCycles,50000);
        if size(seg,1) < 12, continue; end
        f0 = keys(k,2);
        amplitudes = harmonicAmplitudesClean(seg(:,1),seg(:,8),f0,10,fclk);
        a1 = amplitudes(1);
        harm = amplitudes(2:10);
        thd = sqrt(sumFinite(harm.^2))/a1;
        r.freq_Hz(end+1,1) = f0;
        r.inputPp_mV(end+1,1) = keys(k,3)*1e3;
        r.pgaGain(end+1,1) = keys(k,4);
        r.thd_pct(end+1,1) = 100*thd;
        r.thd_dB(end+1,1) = 20*log10(thd);
        r.fundAmp_V(end+1,1) = a1;
        r.harmonicAmp_V(end+1,:) = amplitudes;
    end
    r.max_pct = maxFinite(r.thd_pct);
end

function rows = tableReportRows(opData,diffAcData,cmrrAcData,psrrpAcData, ...
        psrrnAcData,noiseData,diffTranAll,rld,thd)
    rows = strings(0,4);
    marks = [0.05 60 150 1e3];
    for gain = [2 16]
        section = "G" + string(gain);
        expected = 60*4*gain;
        op = lastRow(rowsForValue(opData,2,gain));
        d = uniqueFreqRows(rowsForValue(diffAcData,2,gain));
        f = d(:,1); gainDb = d(:,17);
        acGain = 10.^(interpAtFreq(f,gainDb,marks)/20);
        acErrorPct = 100*(acGain/expected-1);
        midDb = meanBand(f,gainDb,[1 60]);
        if ~isfinite(midDb), midDb = interpAtFreq(f,gainDb,60); end
        relDb = gainDb-midDb;
        cmrr = rejectionAc(uniqueFreqRows(rowsForValue(cmrrAcData,2,gain)),f,gainDb);
        psrrp = rejectionAc(uniqueFreqRows(rowsForValue(psrrpAcData,2,gain)),f,gainDb);
        psrrn = rejectionAc(uniqueFreqRows(rowsForValue(psrrnAcData,2,gain)),f,gainDb);
        tran = metricGain(diffTranAll,gain);
        noise = noiseMetrics(noiseData,gain);
        noiseRms = integrateNoise(noise.f_Hz,noise.in_VrtHz,[0.05 150]);

        rows = [rows
            section,"Total current","uA",fmt(abs(pick(op,15))*1e6)
            section,"Total power","mW",fmt(pick(op,16)*1e3)
            section,"Bias current","uA",fmt(abs(pick(op,14))*1e6)
            section,"VOUTP","V",fmt(pick(op,8))
            section,"VOUTN","V",fmt(pick(op,9))
            section,"Vo,vm","V",fmt(pick(op,10))
            section,"Vo,diff,DC","V",fmt(pick(op,11))
            section,"Expected gain","V/V",fmt(expected)
            section,"Expected gain","dB",fmt(20*log10(expected))
            section,"AC gain error @ 0.05 Hz","%",fmt(acErrorPct(1))
            section,"Tran gain error @ 0.05 Hz","%",fmt(metricAt(tran,0.05,'gainErr_pct'))
            section,"AC gain error @ 60 Hz","%",fmt(acErrorPct(2))
            section,"Tran gain error @ 60 Hz","%",fmt(metricAt(tran,60,'gainErr_pct'))
            section,"AC gain error @ 150 Hz","%",fmt(acErrorPct(3))
            section,"Tran gain error @ 150 Hz","%",fmt(metricAt(tran,150,'gainErr_pct'))
            section,"CMRR @ 0.05 Hz","dB",fmt(interpAtFreq(cmrr.f_Hz,cmrr.rej_dB,marks(1)))
            section,"CMRR @ 60 Hz","dB",fmt(interpAtFreq(cmrr.f_Hz,cmrr.rej_dB,marks(2)))
            section,"CMRR @ 150 Hz","dB",fmt(interpAtFreq(cmrr.f_Hz,cmrr.rej_dB,marks(3)))
            section,"CMRR @ 1 kHz","dB",fmt(interpAtFreq(cmrr.f_Hz,cmrr.rej_dB,marks(4)))
            section,"PSRR+ @ 0.05 Hz","dB",fmt(interpAtFreq(psrrp.f_Hz,psrrp.rej_dB,marks(1)))
            section,"PSRR+ @ 60 Hz","dB",fmt(interpAtFreq(psrrp.f_Hz,psrrp.rej_dB,marks(2)))
            section,"PSRR+ @ 150 Hz","dB",fmt(interpAtFreq(psrrp.f_Hz,psrrp.rej_dB,marks(3)))
            section,"PSRR+ @ 1 kHz","dB",fmt(interpAtFreq(psrrp.f_Hz,psrrp.rej_dB,marks(4)))
            section,"PSRR- @ 0.05 Hz","dB",fmt(interpAtFreq(psrrn.f_Hz,psrrn.rej_dB,marks(1)))
            section,"PSRR- @ 60 Hz","dB",fmt(interpAtFreq(psrrn.f_Hz,psrrn.rej_dB,marks(2)))
            section,"PSRR- @ 150 Hz","dB",fmt(interpAtFreq(psrrn.f_Hz,psrrn.rej_dB,marks(3)))
            section,"PSRR- @ 1 kHz","dB",fmt(interpAtFreq(psrrn.f_Hz,psrrn.rej_dB,marks(4)))
            section,"HP -1dB corner","Hz",fmt(cornerCrossing(f,relDb,-1,60,'hp'))
            section,"HP -3dB corner","Hz",fmt(cornerCrossing(f,relDb,-3,60,'hp'))
            section,"LP -1dB corner","Hz",fmt(cornerCrossing(f,relDb,-1,60,'lp'))
            section,"LP -3dB corner","Hz",fmt(cornerCrossing(f,relDb,-3,60,'lp'))
            section,"Input-referred noise 0.05-150 Hz","uVrms",fmt(noiseRms*1e6)
        ]; %#ok<AGROW>
    end

    noiseG16 = noiseMetrics(noiseData,16);
    noiseG2 = noiseMetrics(noiseData,2);
    noise16 = integrateNoise(noiseG16.f_Hz,noiseG16.out_VrtHz,[0.05 150]);
    noise2 = integrateNoise(noiseG2.f_Hz,noiseG2.out_VrtHz,[0.05 150]);
    rows = [rows
        "Shared","Vin,cm suppression @ 60 Hz","dB",fmt(rld.inputCmImprove_dB)
        "Shared","Vout,diff improvement @ 60 Hz","dB",fmt(rld.outDiffImprove_dB)
        "Shared","RLD output minimum","V",fmt(rld.rldMinOn_V)
        "Shared","RLD output maximum","V",fmt(rld.rldMaxOn_V)
        "Shared","RLD peak current","uA",fmt(rld.rldCurrentPeak_A*1e6)
        "Shared","0.5 mVpp G16 60 Hz THD","%",fmt(thdAt(thd,16,0.5,60))
        "Shared","0.5 mVpp G16 60 Hz SNR","dB",fmt(20*log10((thdFundAt(thd,16,0.5,60)/sqrt(2))/noise16))
        "Shared","5 mVpp G2 60 Hz THD","%",fmt(thdAt(thd,2,5,60))
        "Shared","5 mVpp G2 60 Hz SNR","dB",fmt(20*log10((thdFundAt(thd,2,5,60)/sqrt(2))/noise2))
    ];
end

function y = metricAt(m,f0,fieldName)
    y = valueAtExact(m.freq_Hz,m.(fieldName),f0);
end

function y = thdAt(thd,gain,inputPp_mV,f0)
    k = thdCaseIndex(thd,gain,inputPp_mV,f0);
    if isempty(k), y = NaN; else, y = thd.thd_pct(k); end
end

function y = thdFundAt(thd,gain,inputPp_mV,f0)
    k = thdCaseIndex(thd,gain,inputPp_mV,f0);
    if isempty(k), y = NaN; else, y = thd.fundAmp_V(k); end
end

function k = thdCaseIndex(thd,gain,inputPp_mV,f0)
    idx = abs(thd.pgaGain-gain) < 1e-12 & ...
        abs(thd.inputPp_mV-inputPp_mV) < 1e-9 & ...
        abs(thd.freq_Hz-f0) < max(1e-12,abs(f0)*1e-9);
    k = find(idx,1);
end

function rows = transientSummaryRows(diffM,cmrrM,psrrpM,psrrnM,cmOff,diffOff,thd)
    rows = strings(0,4);
    for k = 1:numel(diffM.freq_Hz)
        label = sprintf('G%.4g %s',diffM.pgaGain(k),freqText(diffM.freq_Hz(k)));
        rows(end+1,:) = ["Transient differential",label+" gain","V/V",fmt(diffM.gain_VV(k))]; %#ok<AGROW>
        rows(end+1,:) = ["Transient differential",label+" gain error","%",fmt(diffM.gainErr_pct(k))]; %#ok<AGROW>
        rows(end+1,:) = ["Transient differential",label+" gain relative to 60 Hz","dB",fmt(diffM.gainRel_dB(k))]; %#ok<AGROW>
        rows(end+1,:) = ["Transient differential",label+" attenuation from 60 Hz","dB",fmt(diffM.attenFrom60_dB(k))]; %#ok<AGROW>
        rows(end+1,:) = ["Transient differential",label+" phase","deg",fmt(diffM.phase_deg(k))]; %#ok<AGROW>
        rows(end+1,:) = ["Transient differential",label+" output CM","V",fmt(diffM.outCmMean_V(k))]; %#ok<AGROW>
        rows(end+1,:) = ["Transient differential",label+" output CM ripple","mVpp",fmt(diffM.outCmPp_mV(k))]; %#ok<AGROW>
    end
    rows = [rows; rejectionRows(cmrrM,"CMRR"); rejectionRows(psrrpM,"PSRR+"); ...
        rejectionRows(psrrnM,"PSRR-")];
    rows = [rows; offsetRows(cmOff,"VCM offset"); offsetRows(diffOff,"VDIFF offset")];
    for k = 1:numel(thd.freq_Hz)
        label = sprintf('G%.4g %.4g mVpp %s',thd.pgaGain(k),thd.inputPp_mV(k),freqText(thd.freq_Hz(k)));
        rows(end+1,:) = ["THD",label+" THD","%",fmt(thd.thd_pct(k))]; %#ok<AGROW>
        rows(end+1,:) = ["THD",label+" THD","dB",fmt(thd.thd_dB(k))]; %#ok<AGROW>
    end
end

function rows = rejectionRows(m,name)
    rows = strings(0,4);
    for k = 1:numel(m.freq_Hz)
        label = sprintf('G%.4g %s',m.pgaGain(k),freqText(m.freq_Hz(k)));
        rows(end+1,:) = ["Transient rejection",label+" "+name,"dB",fmt(m.rej_dB(k))]; %#ok<AGROW>
        rows(end+1,:) = ["Transient rejection",label+" output CM ripple","Vpk",fmt(m.outCmAmp_V(k))]; %#ok<AGROW>
    end
end

function rows = offsetRows(m,name)
    rows = strings(0,4);
    for k = 1:numel(m.offset_V)
        label = sprintf('G%.4g %.4g mVpp offset %+g mV',m.pgaGain(k), ...
            m.inputPp_mV(k),m.offset_V(k)*1e3);
        rows(end+1,:) = [name,label+" ECG gain","V/V",fmt(m.gain_VV(k))]; %#ok<AGROW>
        rows(end+1,:) = [name,label+" gain error","%",fmt(m.gainErr_pct(k))]; %#ok<AGROW>
        rows(end+1,:) = [name,label+" output CM error","mV",fmt(m.voutCmErr_mV(k))]; %#ok<AGROW>
        rows(end+1,:) = [name,label+" residual output DC","mV",fmt(m.voutDiffDc_V(k)*1e3)]; %#ok<AGROW>
        rows(end+1,:) = [name,label+" usable","",fmt(m.usable(k))]; %#ok<AGROW>
    end
end

function cases = buildAcPlotCases(diffData,cmrrData,psrrpData,psrrnData,gains)
    blank = struct('gain',NaN,'label','', 'f_Hz',[],'gain_dB',[], ...
        'phase_deg',[],'mid_dB',NaN,'hp1',NaN,'hp3',NaN,'lp1',NaN,'lp3',NaN, ...
        'cmrr',[],'psrrp',[],'psrrn',[]);
    cases = repmat(blank,numel(gains),1);
    for k = 1:numel(gains)
        g = gains(k); d = uniqueFreqRows(rowsForValue(diffData,2,g));
        c = blank; c.gain = g; c.label = sprintf('G%.4g',g); c.f_Hz = d(:,1);
        c.gain_dB = d(:,17); c.phase_deg = unwrap(d(:,18)*pi/180)*180/pi;
        c.mid_dB = meanBand(c.f_Hz,c.gain_dB,[1 60]);
        if ~isfinite(c.mid_dB), c.mid_dB = interpAtFreq(c.f_Hz,c.gain_dB,60); end
        rel = c.gain_dB-c.mid_dB;
        c.hp1 = cornerCrossing(c.f_Hz,rel,-1,60,'hp');
        c.hp3 = cornerCrossing(c.f_Hz,rel,-3,60,'hp');
        c.lp1 = cornerCrossing(c.f_Hz,rel,-1,60,'lp');
        c.lp3 = cornerCrossing(c.f_Hz,rel,-3,60,'lp');
        c.cmrr = rejectionAc(uniqueFreqRows(rowsForValue(cmrrData,2,g)),c.f_Hz,c.gain_dB);
        c.psrrp = rejectionAc(uniqueFreqRows(rowsForValue(psrrpData,2,g)),c.f_Hz,c.gain_dB);
        c.psrrn = rejectionAc(uniqueFreqRows(rowsForValue(psrrnData,2,g)),c.f_Hz,c.gain_dB);
        cases(k) = c;
    end
end

function plotDiffAcCases(cases,tranAll,plotDir)
    figure;
    for k = 1:numel(cases)
        c = cases(k); tran = metricGain(tranAll,c.gain);
        subplot(numel(cases),1,k);
        yyaxis left; hold on;
        semilogx(c.f_Hz,c.gain_dB,'LineWidth',1.5,'DisplayName','AC gain');
        yline(c.mid_dB-1,'--','-1dB','HandleVisibility','off');
        yline(c.mid_dB-3,'--','-3dB','HandleVisibility','off');
        addAcDbCursors(c.f_Hz,c.gain_dB,[0.05 60 150]);
        addFreqCursor(c.hp1,sprintf('HP -1 dB: %s',freqText(c.hp1)));
        addFreqCursor(c.hp3,sprintf('HP -3 dB: %s',freqText(c.hp3)));
        addFreqCursor(c.lp1,sprintf('LP -1 dB: %s',freqText(c.lp1)));
        addFreqCursor(c.lp3,sprintf('LP -3 dB: %s',freqText(c.lp3)));
        addTranPoints(tran.freq_Hz,tran.gain_dB,unique(tran.freq_Hz));
        ylabel('Gain (dB)');
        yyaxis right; hold on;
        semilogx(c.f_Hz,c.phase_deg,'LineWidth',1.5,'DisplayName','AC phase');
        ylabel('Phase (deg)');
        stylePlot('Frequency (Hz)',sprintf('PATH Differential Response - %s',c.label));
        set(gca,'XScale','log'); xlim([1e-3 1e4]); legend('Location','best');
    end
    saveFig(plotDir,'NOM.diff_response.png');
end

function plotRejectionCases(cases,tranAll,fieldName,titleText,yText,fileName,plotDir)
    figure;
    for k = 1:numel(cases)
        r = cases(k).(fieldName); tran = metricGain(tranAll,cases(k).gain);
        subplot(numel(cases),1,k); hold on;
        semilogx(r.f_Hz,r.rej_dB,'LineWidth',1.5,'DisplayName','AC');
        addAcDbCursors(r.f_Hz,r.rej_dB,[0.05 60 150 1e3]);
        addTranPoints(tran.freq_Hz,tran.rej_dB,unique(tran.freq_Hz));
        stylePlot('Frequency (Hz)',sprintf('%s - %s',titleText,cases(k).label));
        set(gca,'XScale','log'); xlim([1e-3 1e4]); ylabel(yText); legend('Location','best');
    end
    saveFig(plotDir,fileName);
end

function plotPsrrCases(cases,pTranAll,nTranAll,plotDir)
    figure; tiledlayout(numel(cases),2,'TileSpacing','compact');
    for k = 1:numel(cases)
        nexttile; plotPsrrOne(cases(k).psrrp,metricGain(pTranAll,cases(k).gain), ...
            sprintf('PATH PSRR+ - %s',cases(k).label),'PSRR+ (dB)');
        nexttile; plotPsrrOne(cases(k).psrrn,metricGain(nTranAll,cases(k).gain), ...
            sprintf('PATH PSRR- - %s',cases(k).label),'PSRR- (dB)');
    end
    saveFig(plotDir,'NOM.psrr.png');
end

function plotPsrrOne(ac,tran,titleText,yText)
    hold on; semilogx(ac.f_Hz,ac.rej_dB,'LineWidth',1.5,'DisplayName','AC');
    addAcDbCursors(ac.f_Hz,ac.rej_dB,[0.05 60 150 1e3]);
    addTranPoints(tran.freq_Hz,tran.rej_dB,unique(tran.freq_Hz));
    stylePlot('Frequency (Hz)',titleText); set(gca,'XScale','log');
    xlim([1e-3 1e4]); ylabel(yText); legend('Location','best');
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
    if size(d,2) < 11, return; end
    offsets = [0.5 0.3 0 -0.3 -0.5];
    colors = [
        0.8500 0.3250 0.0980
        0.9290 0.6940 0.1250
        0.0000 0.4470 0.7410
        0.4660 0.6740 0.1880
        0.4940 0.1840 0.5560
    ];
    [keys,starts,stops] = caseRuns(d,2:5);
    for inputPp = [0.5e-3 5e-3]
        if inputPp < 1e-3, gain = 16; else, gain = 2; end
        segments = cell(size(offsets));
        for k = 1:numel(offsets)
            segments{k} = offsetCaseSegment(d,keys,starts,stops, ...
                inputPp,gain,offsets(k));
        end
        figure; tiledlayout(2,1,'TileSpacing','compact');
        nexttile; yyaxis left; hold on;
        cmVals = [];
        for k = 1:numel(offsets)
            off = offsets(k);
            seg = segments{k};
            if isempty(seg), continue; end
            cmVals = [cmVals; seg(:,8); seg(:,10)]; %#ok<AGROW>
            plot(seg(:,1),seg(:,8),':','Color',colors(k,:),'LineWidth',1.0, ...
                'DisplayName',sprintf('VIN,CM %s %+g mV',offsetName,off*1e3));
            plot(seg(:,1),seg(:,10),'-','Color',colors(k,:),'LineWidth',1.2, ...
                'DisplayName',sprintf('VOUT,CM %s %+g mV',offsetName,off*1e3));
        end
        ylabel('VIN,CM / VOUT,CM (V)');
        centerYLim(cmVals,1.65);
        rstSeg = segments{find(offsets == 0,1)};
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
            seg = segments{k};
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
            seg = segments{k};
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

function seg = offsetCaseSegment(d,keys,starts,stops,inputPp,gain,offset)
    candidates = find(abs(keys(:,2)-inputPp) < 1e-12 & ...
        abs(keys(:,3)-gain) < 1e-12 & abs(keys(:,4)-offset) < 1e-12);
    seg = d([],:);
    for k = candidates(:).'
        if any(d(starts(k):stops(k),6) > 1.65)
            count = stops(k)-starts(k)+1;
            if count > 10000
                idx = round(linspace(starts(k),stops(k),10000));
            else
                idx = starts(k):stops(k);
            end
            seg = d(idx,:);
            return;
        end
    end
end

function seg = signalCycleSegment(seg,f0,maxCycles)
    % Select the requested number of complete cycles from the end, which
    % excludes startup/reset without assuming its absolute duration.
    seg = cleanSegment(seg);
    if isempty(seg) || ~isfinite(f0) || f0 <= 0, seg = seg([],:); return; end
    tEnd = seg(end,1);
    tBegin = tEnd-maxCycles/f0;
    firstRow = find(seg(:,1) >= tBegin,1,'first');
    if isempty(firstRow), seg = seg([],:); return; end
    seg = seg(firstRow:end,:);
    seg = thinRows(seg,50000);
end

function seg = caseCycleSegment(d,firstRow,lastRow,f0,maxCycles,maxRows)
    % ngspice exports each case as a contiguous, time-ordered block. Locate
    % the final complete-cycle window from the time column before copying
    % the other columns; this avoids two full-case matrix copies.
    if firstRow > lastRow || ~isfinite(f0) || f0 <= 0
        seg = d([],:); return;
    end
    tBegin = d(lastRow,1)-maxCycles/f0;
    relativeStart = find(d(firstRow:lastRow,1) >= tBegin,1,'first');
    if isempty(relativeStart), seg = d([],:); return; end
    firstRow = firstRow+relativeStart-1;
    count = lastRow-firstRow+1;
    if count > maxRows
        idx = round(linspace(firstRow,lastRow,maxRows));
    else
        idx = firstRow:lastRow;
    end
    seg = d(idx,:);
end

function plotStartupCompare(withReset,withoutReset,plotDir)
    if size(withReset,2) < 10 || size(withoutReset,2) < 10, return; end
    withReset = thinRows(withReset,15000);
    withoutReset = thinRows(withoutReset,15000);
    windows = [4 16; 30 40; 40 60; 60 80; 180 200]*1e-3;
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
    if size(off,2) < 8 || size(on,2) < 8, return; end
    off = thinRows(off,15000);
    on = thinRows(on,15000);
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
    figure; tiledlayout(2,1,'TileSpacing','compact');
    caseGain = [16 2];
    caseInput_mVpp = [0.5 5];
    caseLabels = {'0.5 mVpp, G16','5 mVpp, G2'};
    for f0 = [60 150]
        dBc = NaN(9,2);
        thdPct = NaN(1,2);
        for c = 1:2
            k = thdCaseIndex(thd,caseGain(c),caseInput_mVpp(c),f0);
            if isempty(k), continue; end
            amplitudes = thd.harmonicAmp_V(k,:);
            dBc(:,c) = 20*log10(amplitudes(2:10).'/amplitudes(1));
            thdPct(c) = thd.thd_pct(k);
        end
        nexttile;
        bar(2:10,dBc,'grouped');
        xticks(2:10); xticklabels(compose('H%d',2:10));
        xlabel('Harmonic number'); ylabel('Amplitude (dBc)');
        ylim([-100 0]);
        title(sprintf(['PATH Output Harmonics at %.4g Hz | H1 = 0 dBc | ' ...
            'THD: %.4g%% (G16), %.4g%% (G2)'],f0,thdPct(1),thdPct(2)), ...
            'Interpreter','none');
        grid on; legend(caseLabels,'Location','best');
    end
    saveFig(plotDir,'NOM.thd.png');
end

function d = cleanSegment(d)
    if isempty(d), return; end
    if all(diff(d(:,1)) > 0), return; end
    [~,idx] = sort(d(:,1)); d = d(idx,:);
    [~,idx] = unique(d(:,1),'stable'); d = d(idx,:);
end

function [keys,starts,stops] = caseRuns(d,keyCols)
    % ngspice appends each test case as one contiguous block.  Finding the
    % block boundaries once avoids rescanning a multi-GB matrix per case.
    if isempty(d)
        keys = zeros(0,numel(keyCols)); starts = []; stops = []; return;
    end
    changed = false(size(d,1)-1,1);
    for col = keyCols
        changed = changed | abs(diff(d(:,col))) > 1e-12;
    end
    starts = [1; find(changed)+1];
    stops = [starts(2:end)-1; size(d,1)];
    keys = d(starts,keyCols);
end

function d = thinRows(d,maxRows)
    if size(d,1) <= maxRows, return; end
    idx = round(linspace(1,size(d,1),maxRows));
    d = d(idx,:);
end

function [amplitudes,phases] = sineFitMany(t,x,f)
    if isvector(x), x = x(:); end
    ok = isfinite(t) & all(isfinite(x),2);
    t = t(ok); x = x(ok,:);
    amplitudes = NaN(1,size(x,2));
    phases = NaN(1,size(x,2));
    if numel(t) < 4 || ~isfinite(f) || f <= 0, return; end
    t = t(:);
    M = [sin(2*pi*f*t), cos(2*pi*f*t), ones(size(t))];
    coeff = M\x;
    amplitudes = hypot(coeff(1,:),coeff(2,:));
    phases = atan2(coeff(2,:),coeff(1,:))*180/pi;
end

function amplitudes = harmonicAmplitudesClean(t,x,f0,nHarm,fclk)
    % Fit the fundamental and all requested harmonics in one regression.
    % Use raw samples: clock-cycle averaging samples at fclk and would alias
    % harmonics above fclk/2.  Non-overlapping clock harmonics are included
    % as nuisance tones so nearby switching energy is not assigned to H1-H10.
    ok = isfinite(t) & isfinite(x);
    t = t(ok); x = x(ok);
    amplitudes = NaN(1,nHarm);
    if numel(t) < 2*nHarm+1 || f0 <= 0, return; end
    harmonicFreqs = (1:nHarm)*f0;
    clockFreqs = fclk:fclk:max(harmonicFreqs);
    for h = 1:numel(harmonicFreqs)
        clockFreqs(abs(clockFreqs-harmonicFreqs(h)) <= ...
            max(1e-9,harmonicFreqs(h)*1e-9)) = [];
    end
    fitFreqs = [harmonicFreqs clockFreqs];
    X = ones(numel(t),1+2*numel(fitFreqs));
    for k = 1:numel(fitFreqs)
        angle = 2*pi*fitFreqs(k)*t;
        X(:,2*k) = cos(angle);
        X(:,2*k+1) = sin(angle);
    end
    coeff = X\x;
    for h = 1:nHarm
        amplitudes(h) = hypot(coeff(2*h),coeff(2*h+1));
    end
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
    ok = isfinite(t) & isfinite(x);
    t = t(ok); x = x(ok);
    if isempty(t), tc = []; xc = []; return; end
    t0 = min(t);
    bin = floor((t-t0)/period);
    [~,~,group] = unique(bin,'stable');
    tc = accumarray(group,t,[],@mean);
    xc = accumarray(group,x,[],@mean);
end

function ts = cycleSettleTime(t,x,target,tol,startTime)
    ts = NaN;
    if isempty(t) || ~isfinite(startTime) || ~isfinite(tol), return; end
    err = abs(x-target);
    idx0 = find(t >= startTime,1,'first');
    if isempty(idx0), return; end
    lastBad = find(err(idx0:end) > tol,1,'last');
    if isempty(lastBad), settleIdx = idx0; else, settleIdx = idx0+lastBad; end
    if settleIdx <= numel(t), ts = t(settleIdx)-startTime; end
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

function y = valueAtExact(f,x,f0)
    tol = max(1e-12,abs(f0)*1e-9);
    idx = find(abs(f-f0) <= tol,1);
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
    querySize = size(f0);
    f0 = f0(:);
    ok = isfinite(f) & isfinite(x) & f > 0;
    if ~any(ok)
        y = NaN(querySize);
    else
        f = f(ok); x = x(ok);
        [f,~,idx] = unique(f);
        x = accumarray(idx,x,[],@mean);
        y = NaN(size(f0));
        validQuery = isfinite(f0) & f0 > 0;
        y(validQuery) = interp1(log10(f),x,log10(f0(validQuery)), ...
            'linear','extrap');
        y = reshape(y,querySize);
    end
end

function a = wrapDeg(a)
    a = mod(a+180,360)-180;
end

function addTranPoints(freqs,values,marks)
    if isempty(freqs) || isempty(values), return; end
    % MATLAB iterates over columns in a for-loop.  unique() returns a
    % column vector here, so force the marks to a row to visit one scalar
    % frequency at a time.
    for f0 = marks(:).'
        y = valueAt(freqs,values,f0);
        if ~isfinite(y), continue; end
        plot(f0,y,'s','MarkerFaceColor',[1 0.6 0], ...
            'MarkerEdgeColor','w','MarkerSize',8, ...
            'LineStyle','none','HandleVisibility','off');
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
    fig = gcf;
    saveas(fig,fullfile(plotDir,fileName));
    % Keep figures visible when the script runs in the MATLAB desktop, but
    % release them in headless/batch runs to limit memory use.
    if ~usejava('desktop'), close(fig); end
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
