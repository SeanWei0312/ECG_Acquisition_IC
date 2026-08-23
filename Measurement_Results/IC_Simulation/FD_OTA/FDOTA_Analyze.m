function FDOTA_Analyze
% FDOTA_ANALYZE Characterize the fully differential OTA testbench.
%
% Expected NGSPICE output is stored beside this file in:
%   nom.Result_txt, ff.Result_txt, ss.Result_txt, fs.Result_txt,
%   sf.Result_txt
%
% Numerical reports cover the full 45-corner PVT sweep. Plots use the
% NOM/3.3 V/27 C data and retain MATLAB's native floating figure style.

clc;
close all;

scriptDir = fileparts(mfilename('fullpath'));
plotDir = fullfile(scriptDir,'Plots');
if ~isfolder(plotDir)
    mkdir(plotDir);
end

cfg = analysisConfig();
rows = reportRows();
nominalDir = fullfile(scriptDir,'nom.Result_txt');
nominalFiles = runFiles(nominalDir,"nom",cfg.nominalCase);

%% Operating point
op = readNumericFile(nominalFiles.olOp,15);
op = op(end,:);

vdd_V = op(2);
vinCm_V = 0.5*(op(3) + op(4));

%% Open-loop: gain and phase
[f_Hz,Ad] = transferFromFile(nominalFiles.diffAc);
[gain_dB,phase_deg,ugf_Hz,phaseMargin_deg,f3dB_Hz] = ...
    acMetrics(f_Hz,Ad);
dcGain_dB = gain_dB(1);

fig = figure;
yyaxis left;
semilogx(f_Hz,gain_dB,'LineWidth',1.5); hold on;
yline(0,'--','HandleVisibility','off');
addCursor(f3dB_Hz,dcGain_dB-3, ...
    sprintf('-3dB: %s',frequencyText(f3dB_Hz)));
addCursor(ugf_Hz,0,sprintf('UGF: %s',frequencyText(ugf_Hz)));
ylabel('Differential gain (dB)');

yyaxis right;
semilogx(f_Hz,phase_deg,'LineWidth',1.5); hold on;
addCursor(ugf_Hz,interpAtFreq(f_Hz,phase_deg,ugf_Hz), ...
    sprintf('PM: %.4g deg',phaseMargin_deg));
ylabel('Differential phase (deg)');
stylePlot('Frequency (Hz)','FDOTA Open-Loop Gain and Phase');
savePlot(fig,plotDir,'NOM.open_loop_gain_phase.png');

%% Open-loop: CMRR and PSRR
[fCm_Hz,Acm] = transferFromFile(nominalFiles.cmAc);
[fP_Hz,AsupP] = transferFromFile(nominalFiles.psrrpAc);
[fN_Hz,AsupN] = transferFromFile(nominalFiles.psrrnAc);

cmrr_dB = rejectionDb(f_Hz,Ad,fCm_Hz,Acm);
psrrP_dB = rejectionDb(f_Hz,Ad,fP_Hz,AsupP);
psrrN_dB = rejectionDb(f_Hz,Ad,fN_Hz,AsupN);

fig = figure;
semilogx(fCm_Hz,cmrr_dB,'LineWidth',1.5); hold on;
labelFreqSet(fCm_Hz,cmrr_dB,cfg.markFrequencies_Hz);
ylabel('CMRR (dB)');
stylePlot('Frequency (Hz)','FDOTA CMRR versus Frequency');
savePlot(fig,plotDir,'NOM.cmrr.png');

fig = figure;
tiledlayout(2,1);
sgtitle('FDOTA PSRR+ and PSRR- versus Frequency');
nexttile;
semilogx(fP_Hz,psrrP_dB,'LineWidth',1.5); hold on;
labelFreqSet(fP_Hz,psrrP_dB,cfg.markFrequencies_Hz);
ylabel('PSRR+ (dB)');
stylePlot('Frequency (Hz)','FDOTA PSRR+');

nexttile;
semilogx(fN_Hz,psrrN_dB,'LineWidth',1.5); hold on;
labelFreqSet(fN_Hz,psrrN_dB,cfg.markFrequencies_Hz);
ylabel('PSRR- (dB)');
stylePlot('Frequency (Hz)','FDOTA PSRR-');
savePlot(fig,plotDir,'NOM.psrr.png');

%% Open-loop: input-referred noise
noise = readNumericFile(nominalFiles.noise,3);
fNoise_Hz = noise(:,1);
inNoise_VrtHz = abs(noise(:,3));

fig = figure;
validNoise = fNoise_Hz >= cfg.noiseBand_Hz(1) & ...
    fNoise_Hz <= cfg.noiseBand_Hz(2) & ...
    isfinite(inNoise_VrtHz) & inNoise_VrtHz > 0;
loglog(fNoise_Hz(validNoise),inNoise_VrtHz(validNoise)*1e9,'LineWidth',1.5); hold on;
for f0 = cfg.noiseMarkFrequencies_Hz
    y0 = interpAtFreq(fNoise_Hz,inNoise_VrtHz,f0)*1e9;
    addCursor(f0,y0, ...
        sprintf('%s: %.4g nV/rtHz',frequencyText(f0),y0));
end
ylabel('Input noise (nV/sqrtHz)');
xlim(cfg.noiseBand_Hz);
stylePlot('Frequency (Hz)','FDOTA Input-Referred Noise Density versus Frequency');
savePlot(fig,plotDir,'NOM.input_referred_noise_density.png');

%% Open-loop: VTC
vtc = readNumericFile(nominalFiles.vtc,10);
vtcVinDiff_V = vtc(:,1);
vtcVoutDiff_V = vtc(:,8);
offset_V = zeroNoJump(vtcVinDiff_V,vtcVoutDiff_V, ...
    cfg.offsetMaxJumpFraction*vdd_V);

fig = figure;
plot(vtcVinDiff_V*1e3,vtcVoutDiff_V,'LineWidth',1.5); hold on;
yline(0,'--','HandleVisibility','off');
addCursor(offset_V*1e3,0,sprintf('Vos: %.4g mV',offset_V*1e3));
ylabel('Vout,diff (V)');
stylePlot('Vin,diff (mV)','FDOTA Open-Loop VTC');
savePlot(fig,plotDir,'NOM.open_loop_vtc.png');

%% Closed-loop: VTC and output swing
clOp = readNumericFile(nominalFiles.clOp,14);
clOp = clOp(end,:);
voutCmTarget_V = clOp(10);
cl = readNumericFile(nominalFiles.diffDc,12);
clCmd_V = cl(:,1);
clVoutdiff_V = cl(:,6);

[clCmd_V,idx] = sort(clCmd_V);
clVoutdiff_V = clVoutdiff_V(idx);

[~,i0] = min(abs(clCmd_V));
trackError_V = clVoutdiff_V - clCmd_V;
validSwing = abs(trackError_V) <= cfg.trackTolerance_V;
[iLow,iHigh] = continuousIndices(validSwing,i0);
if isfinite(iLow)
    inputLow_V = clCmd_V(iLow);
    inputHigh_V = clCmd_V(iHigh);
    swingLow_V = min(clVoutdiff_V(iLow:iHigh));
    swingHigh_V = max(clVoutdiff_V(iLow:iHigh));
else
    inputLow_V = NaN;
    inputHigh_V = NaN;
    swingLow_V = NaN;
    swingHigh_V = NaN;
end

fig = figure;
tiledlayout(2,1);
sgtitle('FDOTA Output Swing and Closed-Loop VTC');

nexttile;
plot(clCmd_V,trackError_V*1e3,'LineWidth',1.5); hold on;
yline(cfg.trackTolerance_V*1e3,'--','+2mV','HandleVisibility','off');
yline(-cfg.trackTolerance_V*1e3,'--','-2mV','HandleVisibility','off');
if isfinite(iLow)
    xline(clCmd_V(iLow),'--',sprintf('Low: %.4g V',clCmd_V(iLow)),'HandleVisibility','off');
    xline(clCmd_V(iHigh),'--',sprintf('High: %.4g V',clCmd_V(iHigh)),'HandleVisibility','off');
end
ylabel('Tracking error (mV)');
stylePlot('Vin,diff command (V)','');

nexttile;
plot(clCmd_V,clVoutdiff_V,'LineWidth',1.5); hold on;
plot(clCmd_V,clCmd_V,'--','LineWidth',1.2);
if isfinite(iLow)
    addCursorLine(inputLow_V,clVoutdiff_V(iLow),sprintf('In low: %.4g V',inputLow_V));
    addCursorLine(inputHigh_V,clVoutdiff_V(iHigh),sprintf('In high: %.4g V',inputHigh_V));
    addCursorHLine(inputLow_V,swingLow_V,sprintf('Out low: %.4g V',swingLow_V));
    addCursorHLine(inputHigh_V,swingHigh_V,sprintf('Out high: %.4g V',swingHigh_V));
end
ylabel('Vout,diff (V)');
legend('Measured','Ideal','Location','best');
stylePlot('Vin,diff command (V)','');
savePlot(fig,plotDir,'NOM.output_swing_and_closed_loop_vtc.png');

%% Closed-loop: input common-mode range
ic = readNumericFile(nominalFiles.icmr,12);
[icmrLow_V,icmrHigh_V,icmr] = analyzeICMRSweep(ic(:,1),ic(:,2), ...
    ic(:,6),ic(:,7),ic(:,9),abs(ic(:,10)),vinCm_V, ...
    cfg.icmrGainErrorTolerance,cfg.incrementalCmTolerance_V, ...
    cfg.icmrCurrentTolerance);
icmrPlotValid = icmr.valid & icmr.vcm >= icmrLow_V & icmr.vcm <= icmrHigh_V;

fig = figure;
tiledlayout(3,1);
nexttile;
plot(icmr.vcm,icmr.gainError_pct,'LineWidth',1.5); hold on;
plot(icmr.vcm(icmrPlotValid),icmr.gainError_pct(icmrPlotValid), ...
    'r','LineWidth',2.0);
yline(100*cfg.icmrGainErrorTolerance,'--','0.5% limit', ...
    'HandleVisibility','off');
labelRange(icmrLow_V,icmrHigh_V);
ylabel('|Gain error| (%)');
stylePlot('','FDOTA Input Common-Mode Range');

nexttile;
plot(icmr.vcm,icmr.incrementalCmErrorNeg_V*1e3,'LineWidth',1.5); hold on;
plot(icmr.vcm,icmr.incrementalCmErrorPos_V*1e3,'LineWidth',1.5);
yline(cfg.incrementalCmTolerance_V*1e3,'--','+10 mV', ...
    'HandleVisibility','off');
yline(-cfg.incrementalCmTolerance_V*1e3,'--','-10 mV', ...
    'HandleVisibility','off');
labelRange(icmrLow_V,icmrHigh_V);
ylabel('Incremental CM error (mV)');
legend('-10 mV command','+10 mV command','Location','best');
stylePlot('','');

nexttile;
plot(icmr.vcm,icmr.currentDeviation_pct,'LineWidth',1.5); hold on;
yline(100*cfg.icmrCurrentTolerance,'--','+20%', ...
    'HandleVisibility','off');
yline(-100*cfg.icmrCurrentTolerance,'--','-20%', ...
    'HandleVisibility','off');
labelRange(icmrLow_V,icmrHigh_V);
ylabel('IDD deviation (%)');
stylePlot('Vin,cm (V)','');
savePlot(fig,plotDir,'NOM.input_common_mode_range.png');

%% Closed-loop: transient
tr = readNumericFile(nominalFiles.diffTran,13);
tDiff_s = tr(:,1);
trCmd_V = tr(:,2);
trVoutp_V = tr(:,4);
trVoutn_V = tr(:,5);
trVoutdiff_V = tr(:,7);

targetOutp_V = voutCmTarget_V + 0.5*trCmd_V;
targetOutn_V = voutCmTarget_V - 0.5*trCmd_V;
[srOutpRise_Vus,srOutpFall_Vus,tOutpRise_s,tOutpFall_s, ...
    outpRisePt,outpFallPt] = stepMetrics( ...
    tDiff_s,targetOutp_V,trVoutp_V,cfg.trackTolerance_V);
[srOutnRise_Vus,srOutnFall_Vus,tOutnRise_s,tOutnFall_s, ...
    outnRisePt,outnFallPt] = stepMetrics( ...
    tDiff_s,targetOutn_V,trVoutn_V,cfg.trackTolerance_V);
[srDiffRise_Vus,srDiffFall_Vus,tDiffRise_s,tDiffFall_s, ...
    diffRisePt,diffFallPt] = stepMetrics( ...
    tDiff_s,trCmd_V,trVoutdiff_V,cfg.trackTolerance_V);
settleOutp_s = maxFinite([tOutpRise_s tOutpFall_s]);
settleOutn_s = maxFinite([tOutnRise_s tOutnFall_s]);
settleDiff_s = maxFinite([tDiffRise_s tDiffFall_s]);

fig = figure;
tiledlayout(2,1);
nexttile;
plot(tDiff_s*1e6,targetOutp_V,'--','LineWidth',1.1); hold on;
plot(tDiff_s*1e6,targetOutn_V,'--','LineWidth',1.1);
plot(tDiff_s*1e6,trVoutp_V,'LineWidth',1.5);
plot(tDiff_s*1e6,trVoutn_V,'LineWidth',1.5);
addSrCursor(outpRisePt,sprintf('OUTP rise: %.4g V/us',srOutpRise_Vus));
addSrCursor(outpFallPt,sprintf('OUTP fall: %.4g V/us',srOutpFall_Vus));
addSrCursor(outnRisePt,sprintf('OUTN rise: %.4g V/us',srOutnRise_Vus));
addSrCursor(outnFallPt,sprintf('OUTN fall: %.4g V/us',srOutnFall_Vus));
addMetricBox({ ...
    sprintf('OUTP settle: %s ns',formatFixed(settleOutp_s*1e9)), ...
    sprintf('OUTN settle: %s ns',formatFixed(settleOutn_s*1e9))});
ylabel('Output voltage (V)');
legend('OUTP target','OUTN target','OUTP','OUTN','Location','best');
stylePlot('','FDOTA Closed-Loop Step Response');

nexttile;
plot(tDiff_s*1e6,trCmd_V,'--','LineWidth',1.2); hold on;
plot(tDiff_s*1e6,trCmd_V+cfg.trackTolerance_V,':', ...
    'LineWidth',1.0,'HandleVisibility','off');
plot(tDiff_s*1e6,trCmd_V-cfg.trackTolerance_V,':', ...
    'LineWidth',1.0,'HandleVisibility','off');
plot(tDiff_s*1e6,trVoutdiff_V,'LineWidth',1.5);
addSrCursor(diffRisePt,sprintf('Diff rise: %.4g V/us',srDiffRise_Vus));
addSrCursor(diffFallPt,sprintf('Diff fall: %.4g V/us',srDiffFall_Vus));
addMetricBox({sprintf('Diff settle: %s ns', ...
    formatFixed(settleDiff_s*1e9))});
ylabel('Differential voltage (V)');
legend('Command','Output','Location','best');
stylePlot('Time (us)','FDOTA Closed-Loop Step Response');
savePlot(fig,plotDir,'NOM.closed_loop_step_response.png');

cm = readNumericFile(nominalFiles.cmTran,12);
tCm_s = cm(:,1);
trVref_V = cm(:,2);
trVrefBias_V = cm(:,3);
trVoutcm_V = cm(:,6);
trVocm_V = cm(:,8);
[cmSettleRise_s,cmSettleFall_s] = settleToFinal( ...
    tCm_s,trVref_V,trVoutcm_V,cfg.cmSettleTolerance_V);
outputCmSettling_s = maxFinite([cmSettleRise_s cmSettleFall_s]);

fig = figure;
plot(tCm_s*1e6,trVref_V,'--','LineWidth',1.2); hold on;
plot(tCm_s*1e6,trVrefBias_V,':','LineWidth',1.2);
plot(tCm_s*1e6,trVocm_V,'LineWidth',1.2);
plot(tCm_s*1e6,trVoutcm_V,'LineWidth',1.5);
addMetricBox({sprintf('CM settle (5 mV final-value band): %s ns', ...
    formatFixed(outputCmSettling_s*1e9))});
ylabel('Common-mode voltage (V)');
legend('Applied VREF','BIAS VREF','VOCM pin','Vout,cm','Location','best');
stylePlot('Time (us)','FDOTA Common-Mode Feedback Step Response');
savePlot(fig,plotDir,'NOM.output_cm_transient.png');

%% Summary table
processes = ["NOM" "FF" "SS" "FS" "SF"];
processTokens = lower(processes);
cases = ["nom" "vl" "vh" "tl" "th" "vltl" "vlth" "vhtl" "vhth"];
caseLabels = ["NOMNOM" "VLNOM" "VHNOM" "NOMTL" "NOMTH" ...
    "VLTL" "VLTH" "VHTL" "VHTH"];
corners = strings(1,numel(processes)*numel(cases));
rawValues = nan(size(rows,1),numel(corners));
metrics = cell(1,numel(corners));
cornerIndex = 0;
for processIndex = 1:numel(processes)
    for caseIndex = 1:numel(cases)
        cornerIndex = cornerIndex+1;
        process = processTokens(processIndex);
        caseName = cases(caseIndex);
        corners(cornerIndex) = processes(processIndex)+caseLabels(caseIndex);
        metrics{cornerIndex} = analyzeRun( ...
            scriptDir,process,caseName,cfg);
        rawValues(:,cornerIndex) = ...
            metricsToRaw(metrics{cornerIndex},rows,cfg);
    end
end

[rows,scaledValues] = adaptReportUnits(rows,rawValues);
formattedValues = formatReportValues(rows,scaledValues);

reportColumns = ["NOM" "FF" "SS" "FS" "SF" "VL" "VH" "TL" "TH"];
reportKeys = ["NOMNOMNOM" "FFNOMNOM" "SSNOMNOM" "FSNOMNOM" ...
    "SFNOMNOM" "NOMVLNOM" "NOMVHNOM" "NOMNOMTL" "NOMNOMTH"];
[found,reportIndices] = ismember(reportKeys,corners);
if ~all(found)
    error('FDOTA_Analyze:ReportCorners', ...
        'One or more required comparison corners are missing.');
end
reportValues = formattedValues(:,reportIndices);
summaryTable = table(rows(:,1),rows(:,2), ...
    'VariableNames',{'Parameter','Unit'});
summaryTable = [summaryTable array2table(reportValues, ...
    'VariableNames',cellstr(reportColumns))];
fprintf('\nFDOTA COMPARISON SUMMARY\n\n');
printSummaryTable(rows,reportColumns,reportValues);
writetable(summaryTable,fullfile(scriptDir,'FDOTA_table_report.csv'));
writetable(summaryTable,fullfile(scriptDir,'NOM.FDOTA_summary.csv'));

worstCase = buildWorstCaseTable(rows,corners,scaledValues,metrics,cfg);
fprintf('\nFDOTA FULL-PVT WORST CASE\n\n');
printWorstCaseTable(worstCase);
writetable(worstCase,fullfile(scriptDir,'FDOTA_worst_case_report.csv'));

end

function cfg = analysisConfig
cfg.nominalCase = "nom";
cfg.closedLoopTarget_VV = 1;
cfg.biasTarget_A = 40e-6;
cfg.trackTolerance_V = 2e-3;
cfg.settleTolerance_V = 2e-3;
cfg.cmSettleTolerance_V = 5e-3;
cfg.icmrGainErrorTolerance = 0.005;
cfg.incrementalCmTolerance_V = 10e-3;
cfg.icmrCurrentTolerance = 0.20;
cfg.offsetMaxJumpFraction = 0.25;
cfg.noiseBand_Hz = [0.05 150];
cfg.rejectionFrequencies_Hz = [60 150];
cfg.markFrequencies_Hz = [0.05 60 150 1e3];
cfg.noiseMarkFrequencies_Hz = [cfg.noiseBand_Hz(1) 60 ...
    cfg.noiseBand_Hz(2)];
end

function rows = reportRows
rows = [
    "Set conditions",                        ""
    "AVDD",                                  "V"
    "Vin,cm",                                "V"
    "VREF",                                  "V"
    "Closed-loop target gain",               "V/V"
    "",                                      ""
    "Open-loop simulation",                  ""
    "FDC bias current",                      "A"
    "CMFB bias current",                     "A"
    "Total current",                         "A"
    "Total power",                           "W"
    "Differential DC gain",                  "dB"
    "Differential UGF",                      "Hz"
    "Differential phase margin",             "deg"
    "Input differential offset",             "V"
    "CMRR @ 60 Hz",                          "dB"
    "CMRR @ 150 Hz",                         "dB"
    "PSRR+ @ 60 Hz",                         "dB"
    "PSRR+ @ 150 Hz",                        "dB"
    "PSRR- @ 60 Hz",                         "dB"
    "PSRR- @ 150 Hz",                        "dB"
    "Input-referred noise 0.05-150 Hz",       "Vrms"
    "",                                      ""
    "Closed-loop simulation",                ""
    "Closed-loop differential gain",         "dB"
    "Gain error",                            "%"
    "Output common mode, DC",                "V"
    "Output CM error at nominal",            "V"
    "Output differential, DC",               "V"
    "Input CM low",                          "V"
    "Input CM high",                         "V"
    "Input CM high headroom",                "V"
    "Differential command low",              "V"
    "Differential command high",             "V"
    "Differential output swing low",         "V"
    "Differential output swing high",        "V"
    "Differential SR rise",                  "V/us"
    "Differential SR fall",                  "V/us"
    "Differential settling time",            "s"
    "Differential-step CM disturbance",      "V"
    "CMFB SR rise",                          "V/us"
    "CMFB SR fall",                          "V/us"
    "CMFB settling time",                    "s"
];
end

function files = runFiles(resultDir,process,caseName)
olPrefix = fullfile(resultDir,process+".ol_"+caseName+"_");
clPrefix = fullfile(resultDir,process+".cl_"+caseName+"_");
files.olOp = olPrefix+"op.txt";
files.diffAc = olPrefix+"diff_ac.txt";
files.cmAc = olPrefix+"cm_ac.txt";
files.psrrpAc = olPrefix+"psrrp_ac.txt";
files.psrrnAc = olPrefix+"psrrn_ac.txt";
files.vtc = olPrefix+"vtc.txt";
files.noise = olPrefix+"noise.txt";
files.clOp = clPrefix+"op.txt";
files.diffDc = clPrefix+"diff_dc.txt";
files.icmr = clPrefix+"icmr.txt";
files.diffTran = clPrefix+"diff_tran.txt";
files.cmTran = clPrefix+"cm_tran.txt";
end

function data = readNumericFile(file,expectedColumns)
if ~isfile(file)
    error('FDOTA_Analyze:MissingFile','Missing required file: %s',file);
end
data = readmatrix(file,'FileType','text');
data = data(any(isfinite(data),2),:);
data = data(:,any(isfinite(data),1));
if isempty(data)
    error('FDOTA_Analyze:EmptyFile','No numeric data found in %s.',file);
end
if size(data,2) == expectedColumns+1 && ...
        columnsMatch(data(:,1),data(:,2))
    data = data(:,2:end);
end
if size(data,2) ~= expectedColumns
    error('FDOTA_Analyze:ColumnCount', ...
        '%s must contain %d columns; found %d.', ...
        file,expectedColumns,size(data,2));
end
if any(~isfinite(data),'all')
    error('FDOTA_Analyze:NonfiniteData', ...
        '%s contains nonfinite numeric samples.',file);
end
end

function tf = columnsMatch(a,b)
scale = max([ones(size(a)) abs(a) abs(b)],[],2);
tf = all(abs(a-b) <= 100*eps(scale));
end

function validateFrequency(f,label)
if any(~isfinite(f)) || any(f <= 0) || any(diff(f) <= 0)
    error('FDOTA_Analyze:FrequencyAxis', ...
        '%s frequency must be finite, positive, and strictly increasing.', ...
        label);
end
end

function m = analyzeRun(scriptDir,process,caseName,cfg)
    resultDir = fullfile(scriptDir,process+".Result_txt");
    files = runFiles(resultDir,process,caseName);
    required = string(struct2cell(files));
    if ~all(isfile(required))
        error('FDOTA_Analyze:MissingFiles', ...
            'Missing FDOTA files for %s/%s.',process,caseName);
    end

    op = readNumericFile(files.olOp,15);
    op = op(end,:);
    m.vdd_V = op(2);
    m.vinCm_V = 0.5*(op(3)+op(4));
    m.vref_V = op(9);
    m.fdcBias_A = abs(op(14));
    m.cmfbBias_A = abs(op(15));
    m.totalCurrent_A = abs(op(13));
    m.totalPower_W = m.vdd_V*m.totalCurrent_A;

    [fAd,Ad] = transferFromFile(files.diffAc);
    [gain_dB,~,m.ugf_Hz,m.phaseMargin_deg] = acMetrics(fAd,Ad);
    m.dcGain_dB = gain_dB(1);
    [fCm,Acm] = transferFromFile(files.cmAc);
    [fP,Ap] = transferFromFile(files.psrrpAc);
    [fN,An] = transferFromFile(files.psrrnAc);
    m.cmrr_dB = interpAtFreq(fCm,rejectionDb(fAd,Ad,fCm,Acm), ...
        cfg.rejectionFrequencies_Hz);
    m.psrrP_dB = interpAtFreq(fP,rejectionDb(fAd,Ad,fP,Ap), ...
        cfg.rejectionFrequencies_Hz);
    m.psrrN_dB = interpAtFreq(fN,rejectionDb(fAd,Ad,fN,An), ...
        cfg.rejectionFrequencies_Hz);
    vtc = readNumericFile(files.vtc,10);
    m.offset_V = zeroNoJump(vtc(:,1),vtc(:,8), ...
        cfg.offsetMaxJumpFraction*m.vdd_V);
    noise = readNumericFile(files.noise,3);
    m.inputNoise_Vrms = integrateNoise( ...
        noise(:,1),abs(noise(:,3)),cfg.noiseBand_Hz);

    clOp = readNumericFile(files.clOp,14);
    clOp = clOp(end,:);
    m.vref_V = clOp(10);
    m.voutCmDc_V = clOp(8);
    m.voutCmError_V = clOp(8)-clOp(10);
    m.voutDiffDc_V = clOp(9);

    dc = readNumericFile(files.diffDc,12);
    [cmd,order] = sort(dc(:,1));
    outDiff = dc(order,6); dcError = dc(order,7);
    [~,i0] = min(abs(cmd));
    gain = localSlope(cmd,outDiff,0);
    m.clGain_dB = 20*log10(abs(gain));
    m.gainError_pct = 100*(gain-1);
    [iLow,iHigh] = continuousIndices( ...
        abs(dcError)<=cfg.trackTolerance_V,i0);
    m.diffCmdLow_V = NaN;
    m.diffCmdHigh_V = NaN;
    m.diffSwingLow_V = NaN;
    m.diffSwingHigh_V = NaN;
    if isfinite(iLow)
        m.diffCmdLow_V = cmd(iLow);
        m.diffCmdHigh_V = cmd(iHigh);
        m.diffSwingLow_V = min(outDiff(iLow:iHigh));
        m.diffSwingHigh_V = max(outDiff(iLow:iHigh));
    end

    ic = readNumericFile(files.icmr,12);
    [m.icmrLow_V,m.icmrHigh_V] = analyzeICMRSweep(ic(:,1),ic(:,2), ...
        ic(:,6),ic(:,7),ic(:,9),abs(ic(:,10)),m.vinCm_V, ...
        cfg.icmrGainErrorTolerance,cfg.incrementalCmTolerance_V, ...
        cfg.icmrCurrentTolerance);
    m.icmrHighHeadroom_V = m.vdd_V-m.icmrHigh_V;

    tr = readNumericFile(files.diffTran,13);
    [m.diffSrRise_Vus,m.diffSrFall_Vus,tRise,tFall] = ...
        stepMetrics(tr(:,1),tr(:,2),tr(:,7),cfg.settleTolerance_V);
    m.diffSettlingTime_s = maxFinite([tRise tFall]);
    m.diffCmDisturbance_V = max(abs(tr(:,6)-tr(:,10)));

    cm = readNumericFile(files.cmTran,12);
    [m.cmSrRise_Vus,m.cmSrFall_Vus] = ...
        stepMetrics(cm(:,1),cm(:,2),cm(:,6),cfg.settleTolerance_V);
    [cmRise,cmFall] = settleToFinal( ...
        cm(:,1),cm(:,2),cm(:,6),cfg.cmSettleTolerance_V);
    m.cmSettlingTime_s = maxFinite([cmRise cmFall]);
end

function values = metricsToRaw(m,rows,cfg)
    % Returns raw numeric doubles in the initial table units. No rounding.
    values = nan(size(rows,1),1);
    for i = 1:size(rows,1)
        parameter = rows(i,1); unit = rows(i,2);
        if unit == "", continue; end
        switch parameter
            case "AVDD",                             values(i) = m.vdd_V;
            case "Vin,cm",                           values(i) = m.vinCm_V;
            case "VREF",                             values(i) = m.vref_V;
            case "Closed-loop target gain"
                values(i) = cfg.closedLoopTarget_VV;
            case "FDC bias current",                 values(i) = m.fdcBias_A;
            case "CMFB bias current",                values(i) = m.cmfbBias_A;
            case "Total current",                    values(i) = m.totalCurrent_A;
            case "Total power",                      values(i) = m.totalPower_W;
            case "Differential DC gain",             values(i) = m.dcGain_dB;
            case "Differential UGF",                 values(i) = m.ugf_Hz;
            case "Differential phase margin"
                values(i) = m.phaseMargin_deg;
            case "Input differential offset",        values(i) = m.offset_V;
            case "CMRR @ 60 Hz",                     values(i) = m.cmrr_dB(1);
            case "CMRR @ 150 Hz",                    values(i) = m.cmrr_dB(2);
            case "PSRR+ @ 60 Hz",                    values(i) = m.psrrP_dB(1);
            case "PSRR+ @ 150 Hz",                   values(i) = m.psrrP_dB(2);
            case "PSRR- @ 60 Hz",                    values(i) = m.psrrN_dB(1);
            case "PSRR- @ 150 Hz",                   values(i) = m.psrrN_dB(2);
            case "Input-referred noise 0.05-150 Hz", values(i) = m.inputNoise_Vrms;
            case "Closed-loop differential gain",    values(i) = m.clGain_dB;
            case "Gain error",                       values(i) = m.gainError_pct;
            case "Output common mode, DC",           values(i) = m.voutCmDc_V;
            case "Output CM error at nominal",       values(i) = m.voutCmError_V;
            case "Output differential, DC",          values(i) = m.voutDiffDc_V;
            case "Input CM low",                     values(i) = m.icmrLow_V;
            case "Input CM high",                    values(i) = m.icmrHigh_V;
            case "Input CM high headroom",           values(i) = m.icmrHighHeadroom_V;
            case "Differential command low",         values(i) = m.diffCmdLow_V;
            case "Differential command high",        values(i) = m.diffCmdHigh_V;
            case "Differential output swing low",    values(i) = m.diffSwingLow_V;
            case "Differential output swing high",   values(i) = m.diffSwingHigh_V;
            case "Differential SR rise",             values(i) = m.diffSrRise_Vus;
            case "Differential SR fall",             values(i) = m.diffSrFall_Vus;
            case "Differential settling time"
                values(i) = m.diffSettlingTime_s;
            case "Differential-step CM disturbance", values(i) = m.diffCmDisturbance_V;
            case "CMFB SR rise",                     values(i) = m.cmSrRise_Vus;
            case "CMFB SR fall",                     values(i) = m.cmSrFall_Vus;
            case "CMFB settling time"
                values(i) = m.cmSettlingTime_s;
        end
    end
end

function result = buildWorstCaseTable(rows,corners,values,metrics,cfg)
    keep = rows(:,2) ~= "" & ~ismember(rows(:,1), ...
        ["AVDD" "Vin,cm" "VREF" "Closed-loop target gain"]);
    parameters = rows(keep,1); units = rows(keep,2); source = find(keep);
    selected = nan(numel(source),1); selectedCorner = strings(numel(source),1);
    lowerIsWorse = ["Differential DC gain" "Differential UGF" ...
        "Differential phase margin" "CMRR @ 60 Hz" "CMRR @ 150 Hz" ...
        "PSRR+ @ 60 Hz" "PSRR+ @ 150 Hz" "PSRR- @ 60 Hz" ...
        "PSRR- @ 150 Hz" "Differential command high" ...
        "Differential output swing high" "Differential SR rise" ...
        "Differential SR fall" "CMFB SR rise" "CMFB SR fall"];
    maxLowLimit = ["Input CM low" "Differential command low" ...
        "Differential output swing low"];
    absoluteWorst = ["Input differential offset" "Closed-loop differential gain" ...
        "Gain error" "Output CM error at nominal" "Output differential, DC"];
    for i = 1:numel(source)
        parameter = parameters(i);
        candidates = values(source(i),:);   % already numeric double
        if parameter == "Input CM low"
            failed = cellfun(@(x)~isfinite(x.icmrLow_V),metrics);
            if any(failed)
                index = find(failed,1);
                selectedCorner(i) = corners(index);
                continue;
            end
        elseif parameter == "Input CM high"
            failed = cellfun(@(x)~isfinite(x.icmrHigh_V),metrics);
            if any(failed)
                index = find(failed,1);
                selectedCorner(i) = corners(index);
                continue;
            end
        elseif parameter == "Input CM high headroom"
            failed = cellfun(@(x)~isfinite(x.icmrHighHeadroom_V),metrics);
            if any(failed)
                index = find(failed,1);
                selectedCorner(i) = corners(index);
                continue;
            end
        end
        valid = find(isfinite(candidates));
        if isempty(valid), continue; end
        if parameter == "Input CM high"
            headroom = cellfun(@(x)x.icmrHighHeadroom_V,metrics);
            [~,index] = max(headroom);
            selected(i) = candidates(index);
        elseif ismember(parameter,lowerIsWorse)
            [selected(i),j] = min(candidates(valid)); index = valid(j);
        elseif ismember(parameter,maxLowLimit)
            [selected(i),j] = max(candidates(valid)); index = valid(j);
        elseif ismember(parameter,absoluteWorst)
            [~,j] = max(abs(candidates(valid))); index = valid(j);
            selected(i) = candidates(index);
        elseif parameter == "FDC bias current"
            raw = cellfun(@(x)x.fdcBias_A,metrics);
            [~,index] = max(abs(raw-cfg.biasTarget_A));
            selected(i) = candidates(index);
        elseif parameter == "CMFB bias current"
            raw = cellfun(@(x)x.cmfbBias_A,metrics);
            [~,index] = max(abs(raw-cfg.biasTarget_A));
            selected(i) = candidates(index);
        else
            [selected(i),j] = max(candidates(valid)); index = valid(j);
        end
        selectedCorner(i) = corners(index);
    end
    formatted = strings(size(selected));
    for i = 1:numel(selected)
        formatted(i) = formatOne(selected(i),units(i));
    end
    result = table(parameters,units,formatted,selectedCorner, ...
        'VariableNames',{'Parameter','Unit','Value','Corner'});
end

function printSummaryTable(rows,columns,values)
    parameterWidth = max(42,max(strlength(rows(:,1)))+2);
    fprintf('%-*s %-8s',parameterWidth,'Parameter','Unit');
    for i = 1:numel(columns), fprintf(' %13s',columns(i)); end
    fprintf('\n%s\n',repmat('-',1,parameterWidth+9+14*numel(columns)));
    for i = 1:size(rows,1)
        if rows(i,1) == "" && rows(i,2) == "", fprintf('\n');
        elseif rows(i,2) == "", fprintf('%-*s\n',parameterWidth,upper(char(rows(i,1))));
        else
            fprintf('%-*s %-8s',parameterWidth,char(rows(i,1)),char(rows(i,2)));
            for j = 1:numel(columns), fprintf(' %13s',values(i,j)); end
            fprintf('\n');
        end
    end
end

function printWorstCaseTable(result)
    parameterWidth = max(42,max(strlength(result.Parameter))+2);
    fprintf('%-*s %-8s %13s %-10s\n',parameterWidth,'Parameter','Unit','Value','Corner');
    fprintf('%s\n',repmat('-',1,parameterWidth+34));
    for i = 1:height(result)
        fprintf('%-*s %-8s %13s %-10s\n',parameterWidth, ...
            char(result.Parameter(i)),char(result.Unit(i)), ...
            char(result.Value(i)),char(result.Corner(i)));
    end
end

function [f,A] = transferFromFile(file)
    D = readNumericFile(file,5);
    f = D(:,1);
    validateFrequency(f,file);
    vin = D(:,2) + 1j*D(:,3);
    vout = D(:,4) + 1j*D(:,5);
    A = vout ./ vin;
end

function [gain_dB,phase_deg,ugf_Hz,phaseMargin_deg,f3dB_Hz] = ...
        acMetrics(f,A)
    gain_dB = 20*log10(max(abs(A),realmin));
    phase_deg = unwrap(angle(A))*180/pi;
    if abs(phase_deg(1)) > 90
        A = -A;
        phase_deg = unwrap(angle(A))*180/pi;
    end
    f3dB_Hz = gainCross(f,gain_dB,gain_dB(1)-3);
    ugf_Hz = gainCross(f,gain_dB,0);
    phaseMargin_deg = 180 + interpAtFreq(f,phase_deg,ugf_Hz);
end

function f0 = gainCross(f,g,target)
    k = find(g(1:end-1) >= target & g(2:end) <= target,1);
    if isempty(k)
        f0 = NaN;
    else
        f0 = 10^interp1(g(k:k+1),log10(f(k:k+1)),target,'linear',NaN);
    end
end

function y0 = interpAtFreq(f,y,f0)
    y0 = NaN(size(f0));
    ok = isfinite(f0);
    if any(ok)
        y0(ok) = interp1(log10(f),y,log10(f0(ok)),'linear',NaN);
    end
end

function rDb = rejectionDb(fAd,Ad,fDist,Adist)
    adHere = interpAtFreq(fAd,abs(Ad),fDist);
    rDb = 20*log10(max(adHere,realmin) ./ max(abs(Adist),realmin));
end

function labelFreqSet(f,y,fSet)
    for f0 = fSet
        y0 = interpAtFreq(f,y,f0);
        addCursorLine(f0,y0, ...
            sprintf('%s: %.4g dB',frequencyText(f0),y0));
    end
end

function vn = integrateNoise(f,en,band)
    validateFrequency(f,'Noise');
    ok = isfinite(f) & isfinite(en) & f > 0 & en >= 0;
    f = f(ok);
    en = en(ok);
    if numel(f) < 2
        vn = NaN;
        return;
    end
    f1 = max(band(1),min(f));
    f2 = min(band(2),max(f));
    if f1 >= f2
        vn = NaN;
        return;
    end
    use = f > f1 & f < f2;
    fUse = [f1; f(use); f2];
    enUse = interpAtFreq(f,en,fUse);
    vn = sqrt(trapz(fUse,enUse.^2));
end

function x0 = zeroNoJump(x,y,maxJump)
    [x,idx] = sort(x);
    y = y(idx);
    k = find(y(1:end-1).*y(2:end) <= 0 & abs(diff(y)) <= maxJump,1);
    if isempty(k)
        x0 = NaN;
    else
        x0 = interp1(y(k:k+1),x(k:k+1),0,'linear',NaN);
    end
end

function g = localSlope(x,y,x0)
    [x,idx] = sort(x);
    y = y(idx);
    [x,idx] = unique(x);
    y = y(idx);
    if numel(x) < 3 || ~isfinite(x0)
        g = NaN;
    else
        g = interp1(x,gradient(y,x),x0,'linear',NaN);
    end
end

function [lo,hi,icmr] = analyzeICMRSweep(vcm,command,voutcm,voutdiff, ...
        vref,idd,vinCmNom,gainErrorTol,cmTol,currentTol)
    [vcmSorted,order] = sort(vcm);
    command  = command(order);
    voutcm   = voutcm(order);
    voutdiff = voutdiff(order);
    vref     = vref(order);
    idd      = idd(order);

    tol = max(1e-12, 100*eps(max(1, max(abs(vcmSorted)))));
    group = ones(size(vcmSorted));
    for k = 2:numel(vcmSorted)
        if abs(vcmSorted(k)-vcmSorted(k-1)) > tol
            group(k) = group(k-1)+1;
        else
            group(k) = group(k-1);
        end
    end
    n = max(group);
    vcmList = nan(n,1);
    gain = NaN(n,1); cmErrorNeg_V = NaN(n,1);
    cmErrorPos_V = NaN(n,1); idd_A = NaN(n,1);
    for i = 1:n
        rows = group == i;
        vcmList(i) = mean(vcmSorted(rows));
        cmd = command(rows); vod = voutdiff(rows);
        vcmOut = voutcm(rows); reference = vref(rows); current = abs(idd(rows));
        neg = cmd < 0; pos = cmd > 0;
        if ~any(neg) || ~any(pos), continue; end
        cmdNeg = mean(cmd(neg)); cmdPos = mean(cmd(pos));
        gain(i) = (mean(vod(pos))-mean(vod(neg)))/(cmdPos-cmdNeg);
        cmErrorNeg_V(i) = mean(vcmOut(neg)-reference(neg));
        cmErrorPos_V(i) = mean(vcmOut(pos)-reference(pos));
        idd_A(i) = mean(current);
    end
    finite = isfinite(gain) & isfinite(cmErrorNeg_V) & ...
        isfinite(cmErrorPos_V);
    idxFinite = find(finite);
    lo = NaN; hi = NaN;
    if isempty(idxFinite)
        iNom = NaN;
        gainAtCenter = NaN;
        cmErrorAtCenter_V = NaN;
        currentAtCenter_A = NaN;
    else
        [~,j] = min(abs(vcmList(idxFinite)-vinCmNom));
        iNom = idxFinite(j);
        gainAtCenter = gain(iNom);
        cmErrorAtCenter_V = mean([cmErrorNeg_V(iNom) cmErrorPos_V(iNom)]);
        currentAtCenter_A = idd_A(iNom);
    end
    gainError_pct = 100*abs(gain/gainAtCenter-1);
    incrementalCmErrorNeg_V = cmErrorNeg_V-cmErrorAtCenter_V;
    incrementalCmErrorPos_V = cmErrorPos_V-cmErrorAtCenter_V;
    currentDeviation_pct = 100*(idd_A/currentAtCenter_A-1);
    valid = finite & gainError_pct <= 100*gainErrorTol & ...
        abs(incrementalCmErrorNeg_V) <= cmTol & ...
        abs(incrementalCmErrorPos_V) <= cmTol & ...
        abs(currentDeviation_pct) <= 100*currentTol;
    [iLow,iHigh] = continuousIndices(valid,iNom);
    if isfinite(iLow)
        lo = vcmList(iLow);
        hi = vcmList(iHigh);
    end
    icmr = struct('vcm',vcmList,'gain',gain, ...
        'gainAtCenter',gainAtCenter,'gainError_pct',gainError_pct, ...
        'cmErrorAtCenter_V',cmErrorAtCenter_V, ...
        'incrementalCmErrorNeg_V',incrementalCmErrorNeg_V, ...
        'incrementalCmErrorPos_V',incrementalCmErrorPos_V, ...
        'currentAtCenter_A',currentAtCenter_A, ...
        'currentDeviation_pct',currentDeviation_pct,'valid',valid);
end

function [iLow,iHigh] = continuousIndices(valid,iCenter)
    if isempty(valid) || ~isfinite(iCenter) || ~valid(iCenter)
        iLow = NaN; iHigh = NaN; return;
    end
    iLow = iCenter;
    iHigh = iCenter;
    while iLow > 1 && valid(iLow-1), iLow = iLow-1; end
    while iHigh < numel(valid) && valid(iHigh+1), iHigh = iHigh+1; end
end

function [srRise,srFall,tsRise,tsFall,risePt,fallPt] = stepMetrics(t,target,out,tol)
    if numel(t) ~= numel(target) || numel(t) ~= numel(out)
        error('FDOTA_Analyze:TransientLength', ...
            'Time, target, and output vectors must have equal lengths.');
    end
    if any(~isfinite(t)) || any(diff(t) <= 0)
        error('FDOTA_Analyze:TimeAxis', ...
            'Transient time must be finite and strictly increasing.');
    end
    if any(~isfinite(target)) || any(~isfinite(out))
        error('FDOTA_Analyze:TransientData', ...
            'Transient target and output samples must be finite.');
    end
    events = stepEvents(target);
    srRiseList = []; srFallList = []; tsRiseList = []; tsFallList = [];
    risePtList = []; fallPtList = [];
    for i = 1:numel(events)
        i1 = events(i);
        if i < numel(events), i2 = events(i+1)-1; else, i2 = numel(t); end
        if i2-i1 < 5 || i1 < 2, continue; end

        pre = max(1,i1-10):i1-1;
        y0 = mean(out(pre));
        yf = target(i2);
        step = yf-y0;
        if abs(step) < eps, continue; end

        t10 = crossTime(t(i1:i2),out(i1:i2),y0+0.1*step,sign(step));
        t90 = crossTime(t(i1:i2),out(i1:i2),y0+0.9*step,sign(step));
        if isfinite(t10) && isfinite(t90) && t90 > t10
            sr = 0.8*abs(step)/(t90-t10)/1e6;
        else
            sr = NaN;
        end

        ts = settleTime(t(i1:i2),out(i1:i2),target(i1:i2),tol);
        t50 = crossTime(t(i1:i2),out(i1:i2),y0+0.5*step,sign(step));
        pt50 = [t50*1e6, y0+0.5*step];
        if step > 0
            srRiseList(end+1) = sr; %#ok<AGROW>
            tsRiseList(end+1) = ts; %#ok<AGROW>
            risePtList(end+1,:) = pt50; %#ok<AGROW>
        else
            srFallList(end+1) = sr; %#ok<AGROW>
            tsFallList(end+1) = ts; %#ok<AGROW>
            fallPtList(end+1,:) = pt50; %#ok<AGROW>
        end
    end

    [srRise,risePt] = worstSrWithPoint(srRiseList,risePtList);
    [srFall,fallPt] = worstSrWithPoint(srFallList,fallPtList);
    tsRise = maxFinite(tsRiseList);
    tsFall = maxFinite(tsFallList);
end

function [value,point] = worstSrWithPoint(values,points)
    finite = isfinite(values);
    if ~any(finite)
        value = NaN;
        point = [NaN NaN];
    else
        idx = find(finite);
        [value,j] = min(values(idx));
        point = points(idx(j),:);
    end
end

function events = stepEvents(cmd)
    d = abs(diff(cmd));
    if isempty(d) || max(d) == 0
        events = [];
        return;
    end
    threshold = max(d)*0.2;
    candidates = find(d > threshold) + 1;
    events = candidates([true; diff(candidates) > 1]);
end

function tc = crossTime(t,y,level,dirSign)
    if dirSign > 0
        k = find(y(1:end-1) <= level & y(2:end) >= level,1);
    else
        k = find(y(1:end-1) >= level & y(2:end) <= level,1);
    end
    if isempty(k)
        tc = NaN;
    else
        tc = interp1(y(k:k+1),t(k:k+1),level,'linear',NaN);
    end
end

function ts = settleTime(t,y,target,tol)
    bad = find(abs(y-target) > tol);
    if isempty(bad)
        ts = 0;
    elseif bad(end) == numel(t)
        ts = NaN;
    else
        ts = t(bad(end)+1) - t(1);
    end
end

function y = maxFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(x); end
end

function addSrCursor(point,labelText)
    addCursor(point(1),point(2),labelText);
end

function addMetricBox(lines)
    text(0.02,0.94,strjoin(lines,newline),'Units','normalized', ...
        'BackgroundColor','w','Color','k','Margin',4, ...
        'VerticalAlignment','top','HorizontalAlignment','left', ...
        'HandleVisibility','off');
end

function labelRange(lo,hi)
    if isfinite(lo)
        xline(lo,'--',sprintf('Lo: %.4g V',lo), ...
            'HandleVisibility','off');
    end
    if isfinite(hi)
        xline(hi,'--',sprintf('Hi: %.4g V',hi), ...
            'HandleVisibility','off');
    end
end

function addCursor(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y)
        return;
    end
    xline(x,':','HandleVisibility','off');
    plot(x,y,'o','MarkerFaceColor','r','MarkerEdgeColor','r', ...
        'MarkerSize',6,'HandleVisibility','off');
    text(x,y," " + string(labelText),'BackgroundColor','w','Color','k', ...
        'Margin',2,'VerticalAlignment','bottom','HorizontalAlignment','left', ...
        'Clipping','on');
end

function addCursorLine(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y)
        return;
    end
    xline(x,':'," " + string(labelText),'HandleVisibility','off', ...
        'LabelVerticalAlignment','middle','LabelHorizontalAlignment','left');
end

function addCursorHLine(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y)
        return;
    end
    yline(y,':'," " + string(labelText),'HandleVisibility','off', ...
        'LabelVerticalAlignment','middle','LabelHorizontalAlignment','left');
end

function stylePlot(xLabelText,titleText)
    grid on;
    if strlength(string(xLabelText)) > 0
        xlabel(xLabelText);
    end
    if strlength(string(titleText)) > 0
        title(titleText);
    end
end

function savePlot(fig,plotDir,fileName)
    drawnow;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 10 4];
    fig.PaperSize = [10 4];
    print(fig,fullfile(plotDir,fileName),'-dpng','-r250');
end

function [tsRise,tsFall] = settleToFinal(t,command,out,tolerance)
    events = stepEvents(command);
    riseTimes = []; fallTimes = [];
    for i = 1:numel(events)
        i1 = events(i);
        if i < numel(events), i2 = events(i+1)-1; else, i2 = numel(t); end
        if i1 < 2 || i2-i1 < 5, continue; end
        startCommand = mean(command(max(1,i1-10):i1-1));
        tailStart = max(i1,i2-round(0.1*(i2-i1)));
        finalCommand = mean(command(tailStart:i2));
        stepAmplitude = abs(finalCommand-startCommand);
        if stepAmplitude <= eps, continue; end
        finalOutput = mean(out(tailStart:i2));
        ts = settleTime(t(i1:i2),out(i1:i2),finalOutput,tolerance);
        if finalCommand > startCommand
            riseTimes(end+1) = ts; %#ok<AGROW>
        else
            fallTimes(end+1) = ts; %#ok<AGROW>
        end
    end
    tsRise = maxFinite(riseTimes);
    tsFall = maxFinite(fallTimes);
end

function s = formatFixed(x)
    if isnan(x)
        s = "NaN";
    elseif isinf(x)
        s = string(sprintf('%+g',x));
    else
        s = string(sprintf('%.3f',x));
    end
end

function s = frequencyText(f)
    if ~isfinite(f)
        s = 'NaN';
    elseif f >= 1e6
        s = sprintf('%.4gMHz',f/1e6);
    elseif f >= 1e3
        s = sprintf('%.4gkHz',f/1e3);
    else
        s = sprintf('%.4gHz',f);
    end
end

function [rows,scaledValues] = adaptReportUnits(rows,rawValues)
scaledValues = rawValues;
for rowIndex = 1:size(rows,1)
    [rows(rowIndex,2),scaledValues(rowIndex,:)] = ...
        adaptValuesUnit(rows(rowIndex,2),rawValues(rowIndex,:));
end
end

function [unit,scaledValues] = adaptValuesUnit(unit,values)
scaledValues = values;
if unit == "" || unit == "dB" || unit == "%"
    return;
end
nonzero = isfinite(values) & values ~= 0;
if ~any(nonzero)
    return;
end
magnitude = max(abs(values(nonzero)));
[unit,scalePower] = scaleUnit(magnitude,unit);
scaledValues = values*1e3^scalePower;
end

function formatted = formatReportValues(rows,scaledValues)
formatted = strings(size(scaledValues));
for rowIndex = 1:size(scaledValues,1)
    unit = rows(rowIndex,2);
    if unit == ""
        continue;
    end
    for columnIndex = 1:size(scaledValues,2)
        formatted(rowIndex,columnIndex) = ...
            formatOne(scaledValues(rowIndex,columnIndex),unit);
    end
end
end

function [newUnit,scalePower] = scaleUnit(magnitude,currentUnit)
prefixOrder = ["f" "p" "n" "u" "m" "" "k" "M" "G" "T"];
[prefix,core] = splitUnitPrefix(currentUnit);
index = find(prefixOrder == prefix,1);
scaled = abs(magnitude);
scalePower = 0;
while scaled < 1 && index > 1
    scaled = scaled*1e3;
    index = index-1;
    scalePower = scalePower+1;
end
while scaled >= 1000 && index < numel(prefixOrder)
    scaled = scaled/1e3;
    index = index+1;
    scalePower = scalePower-1;
end
newUnit = prefixOrder(index)+core;
end

function [prefix,core] = splitUnitPrefix(unit)
knownPrefixes = ["T" "G" "M" "k" "m" "u" "n" "p" "f"];
unit = string(unit);
if unit == ""
    prefix = "";
    core = "";
    return;
end
firstCharacter = extractBetween(unit,1,1);
if ismember(firstCharacter,knownPrefixes)
    prefix = firstCharacter;
    core = extractAfter(unit,1);
else
    prefix = "";
    core = unit;
end
end

function s = formatOne(x,unit)
if isnan(x)
    s = "NaN";
elseif isinf(x)
    s = string(sprintf('%+g',x));
elseif unit == "dB" || unit == "%"
    if x ~= 0 && (abs(x) < 1e-3 || abs(x) > 999)
        s = string(sprintf('%.3e',x));
    else
        s = string(sprintf('%.3f',x));
    end
else
    [prefix,~] = splitUnitPrefix(unit);
    if prefix == "f" && x ~= 0 && abs(x) < 1e-3
        s = string(sprintf('%.3e',x));
    elseif prefix == "T" && abs(x) > 999
        s = string(sprintf('%.3e',x));
    else
        s = string(sprintf('%.3f',x));
    end
end
end

