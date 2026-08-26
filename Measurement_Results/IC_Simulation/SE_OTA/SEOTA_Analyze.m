function SEOTA_Analyze
% SEOTA_ANALYZE Characterize the single-ended OTA across PVT.
%
% Expected NGSPICE output is stored beside this file in:
%   nom.Result_txt, ff.Result_txt, ss.Result_txt, fs.Result_txt,
%   sf.Result_txt
%
% The analyzer reports the configured comparison corners and the full-PVT
% worst case, then regenerates the NOM/NOM plots as native MATLAB figures.

clc;
close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'nom.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~isfolder(plotDir)
    mkdir(plotDir);
end
reportDir = fullfile(scriptDir,'Reports');
if ~isfolder(reportDir)
    mkdir(reportDir);
end

cfg = analysisConfig();
rows = reportRows();
nominalToken = "nom";
nominalFiles = runFiles(baseDir,nominalToken,cfg.nominalCase);

%% Operating point
op = readNumericFile(nominalFiles.olOp,8);
op = op(end,:);
vdd_V = op(2);
vinCm_V = 0.5*(op(3) + op(4));
idd_A = abs(op(7));
ibias_A = abs(op(8));
% IDD_TOTAL already includes the BIAS block, XMBIAS, and SEOTA.
totalCurrent_A = idd_A;
totalPower_W = vdd_V*totalCurrent_A;
voutTarget_V = 0.5*vdd_V;

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
ylabel('Gain (dB)');

yyaxis right;
semilogx(f_Hz,phase_deg,'LineWidth',1.5); hold on;
addCursor(ugf_Hz,interpAtFreq(f_Hz,phase_deg,ugf_Hz), ...
    sprintf('PM: %.4g deg',phaseMargin_deg));
ylabel('Phase (deg)');
stylePlot('Frequency (Hz)','SEOTA Open-Loop Gain and Phase');
savePlot(fig,plotDir,'NOM.open_loop_gain_phase.png');

%% Open-loop: CMRR and PSRR
[fCm_Hz,Acm] = transferFromFile(nominalFiles.cmAc);
[fP_Hz,AsupP] = transferFromFile(nominalFiles.psrrpAc);
[fN_Hz,AsupN] = transferFromFile(nominalFiles.psrrnAc);

cmrr_dB = rejectionDb(f_Hz,Ad,fCm_Hz,Acm);
psrrP_dB = rejectionDb(f_Hz,Ad,fP_Hz,AsupP);
psrrN_dB = rejectionDb(f_Hz,Ad,fN_Hz,AsupN);
cmrrAt_dB = interpAtFreq(fCm_Hz,cmrr_dB,cfg.markFrequencies_Hz);
psrrPAt_dB = interpAtFreq(fP_Hz,psrrP_dB,cfg.markFrequencies_Hz);
psrrNAt_dB = interpAtFreq(fN_Hz,psrrN_dB,cfg.markFrequencies_Hz);

fig = figure;
semilogx(fCm_Hz,cmrr_dB,'LineWidth',1.5); hold on;
labelFreqSet(fCm_Hz,cmrr_dB,cfg.markFrequencies_Hz);
ylabel('CMRR (dB)');
stylePlot('Frequency (Hz)','SEOTA CMRR versus Frequency');
savePlot(fig,plotDir,'NOM.cmrr.png');

fig = figure;
tiledlayout(2,1);
sgtitle('SEOTA PSRR+ and PSRR- versus Frequency');
nexttile;
semilogx(fP_Hz,psrrP_dB,'LineWidth',1.5); hold on;
labelFreqSet(fP_Hz,psrrP_dB,cfg.markFrequencies_Hz);
ylabel('PSRR+ (dB)');
stylePlot('Frequency (Hz)','SEOTA PSRR+');

nexttile;
semilogx(fN_Hz,psrrN_dB,'LineWidth',1.5); hold on;
labelFreqSet(fN_Hz,psrrN_dB,cfg.markFrequencies_Hz);
ylabel('PSRR- (dB)');
stylePlot('Frequency (Hz)','SEOTA PSRR-');
savePlot(fig,plotDir,'NOM.psrr.png');

%% Open-loop: input-referred noise
noise = readNumericFile(nominalFiles.noise,3);
fNoise_Hz = noise(:,1);
validateFrequency(fNoise_Hz,nominalFiles.noise);
inNoise_VrtHz = abs(noise(:,3));
inputNoise_Vrms = integrateNoise( ...
    fNoise_Hz,inNoise_VrtHz,cfg.noiseBand_Hz);

fig = figure;
validNoise = fNoise_Hz >= cfg.noiseBand_Hz(1) & ...
    fNoise_Hz <= cfg.noiseBand_Hz(2) & ...
    isfinite(inNoise_VrtHz) & inNoise_VrtHz > 0;
loglog(fNoise_Hz(validNoise),inNoise_VrtHz(validNoise)*1e9,'LineWidth',1.5); hold on;
for f0 = cfg.noiseMarkFrequencies_Hz
    y0 = interpAtFreq(fNoise_Hz,inNoise_VrtHz,f0)*1e9;
    addCursor(f0,y0,sprintf('%s: %.4g nV/rtHz',frequencyText(f0),y0));
end
ylabel('Input noise (nV/sqrtHz)');
xlim(cfg.noiseBand_Hz);
stylePlot('Frequency (Hz)','SEOTA Input-Referred Noise Density versus Frequency');
savePlot(fig,plotDir,'NOM.input_referred_noise_density.png');

%% Open-loop: VTC
vtc = readNumericFile(nominalFiles.vtc,6);
vtcVinDiff_V = vtc(:,1);
vtcVout_V = vtc(:,5);
offset_V = zeroNoJump(vtcVinDiff_V,vtcVout_V-voutTarget_V, ...
    cfg.offsetMaxJumpFraction*vdd_V);

fig = figure;
plot(vtcVinDiff_V*1e3,vtcVout_V,'LineWidth',1.5); hold on;
yline(voutTarget_V,'--','VDD/2','HandleVisibility','off');
addCursor(offset_V*1e3,voutTarget_V,sprintf('Vos: %.4g mV',offset_V*1e3));
ylabel('Vout (V)');
stylePlot('Vin,diff (mV)','SEOTA Open-Loop VTC');
savePlot(fig,plotDir,'NOM.open_loop_vtc.png');

%% Closed-loop: usable follower range
clOp = readNumericFile(nominalFiles.clOp,8);
clOp = clOp(end,:);
clVinDc_V = clOp(3);

cl = readNumericFile(nominalFiles.clDc,6);
clVin_V = cl(:,1);
clVout_V = cl(:,2);
clErr_V = cl(:,3);
[clVin_V,idx] = sort(clVin_V);
clVout_V = clVout_V(idx);
clErr_V = clErr_V(idx);

[~,i0] = min(abs(clVin_V - clVinDc_V));
clGain = localSlope(clVin_V,clVout_V,clVinDc_V);
gainError_pct = 100*(clGain - 1);
voutClosedLoopDc_V = clVout_V(i0);

validTrack = abs(clErr_V) <= cfg.trackTolerance_V;
[iLowTrack,iHighTrack] = continuousIndices(validTrack,i0);

if isfinite(iLowTrack)
    usableInputLow_V = clVin_V(iLowTrack);
    usableInputHigh_V = clVin_V(iHighTrack);

    usableOutputLow_V = min(clVout_V(iLowTrack:iHighTrack));
    usableOutputHigh_V = max(clVout_V(iLowTrack:iHighTrack));
else
    usableInputLow_V = NaN;
    usableInputHigh_V = NaN;

    usableOutputLow_V = NaN;
    usableOutputHigh_V = NaN;
end

inputHighHeadroom_V = vdd_V - usableInputHigh_V;
outputHighHeadroom_V = vdd_V - usableOutputHigh_V;

fig = figure;
tiledlayout(2,1);
sgtitle('SEOTA Closed-Loop Usable Input/Output Range');

nexttile;
plot(clVin_V,clErr_V*1e3,'LineWidth',1.5); hold on;
yline(cfg.trackTolerance_V*1e3,'--','+2 mV','HandleVisibility','off');
yline(-cfg.trackTolerance_V*1e3,'--','-2 mV','HandleVisibility','off');
if isfinite(usableInputLow_V)
    xline(usableInputLow_V,':', ...
        sprintf('Input low: %.4g V',usableInputLow_V), ...
        'HandleVisibility','off');
    xline(usableInputHigh_V,':', ...
        sprintf('Input high: %.4g V',usableInputHigh_V), ...
        'HandleVisibility','off');
end
ylabel('Vout - Vin (mV)');
stylePlot('Vin (V)','Tracking Error');

nexttile;
plot(clVin_V,clVout_V,'LineWidth',1.5); hold on;
plot(clVin_V,clVin_V,'--','LineWidth',1.2);
if isfinite(usableInputLow_V)
    xline(usableInputLow_V,':', ...
        sprintf('Input low: %.4g V',usableInputLow_V), ...
        'HandleVisibility','off');
    xline(usableInputHigh_V,':', ...
        sprintf('Input high: %.4g V',usableInputHigh_V), ...
        'HandleVisibility','off');
    yline(usableOutputLow_V,':', ...
        sprintf('Output low: %.4g V',usableOutputLow_V), ...
        'HandleVisibility','off');
    yline(usableOutputHigh_V,':', ...
        sprintf('Output high: %.4g V',usableOutputHigh_V), ...
        'HandleVisibility','off');
end
ylabel('Vout (V)');
legend('Measured','Ideal Vout = Vin','Location','best');
stylePlot('Vin (V)','Vout versus Vin');
savePlot(fig,plotDir,'NOM.closed_loop_usable_range.png');

%% Closed-loop: transient
tr = readNumericFile(nominalFiles.clTran,7);
t_s = tr(:,1);
trVin_V = tr(:,2);
trVout_V = tr(:,3);
[srRise_Vus,srFall_Vus,tRise_s,tFall_s,risePt,fallPt] = ...
    stepMetrics(t_s,trVin_V,trVout_V,cfg.settleTolerance_V);
settlingTime_s = maxFinite([tRise_s tFall_s]);

nomMetrics.vdd_V = vdd_V;
nomMetrics.vinCm_V = vinCm_V;
nomMetrics.ibias_A = ibias_A;
nomMetrics.totalCurrent_A = totalCurrent_A;
nomMetrics.totalPower_W = totalPower_W;
nomMetrics.ugf_Hz = ugf_Hz;
nomMetrics.phaseMargin_deg = phaseMargin_deg;
nomMetrics.dcGain_dB = dcGain_dB;
nomMetrics.cmrr_dB = cmrrAt_dB(2:3);
nomMetrics.psrrP_dB = psrrPAt_dB(2:3);
nomMetrics.psrrN_dB = psrrNAt_dB(2:3);
nomMetrics.offset_V = offset_V;
nomMetrics.inputNoise_Vrms = inputNoise_Vrms;
nomMetrics.clGain_dB = 20*log10(abs(clGain));
nomMetrics.gainError_pct = gainError_pct;
nomMetrics.voutDc_V = voutClosedLoopDc_V;
nomMetrics.voutDcError_V = voutClosedLoopDc_V-clVinDc_V;
nomMetrics.usableInputLow_V = usableInputLow_V;
nomMetrics.usableInputHigh_V = usableInputHigh_V;
nomMetrics.inputHighHeadroom_V = inputHighHeadroom_V;
nomMetrics.usableOutputLow_V = usableOutputLow_V;
nomMetrics.usableOutputHigh_V = usableOutputHigh_V;
nomMetrics.outputHighHeadroom_V = outputHighHeadroom_V;
nomMetrics.srRise_Vus = srRise_Vus;
nomMetrics.srFall_Vus = srFall_Vus;
nomMetrics.settlingTime_s = settlingTime_s;

fig = figure;
plot(t_s*1e6,trVin_V,'--','LineWidth',1.2); hold on;
plot(t_s*1e6,trVin_V+cfg.settleTolerance_V,':','LineWidth',1.0, ...
    'HandleVisibility','off');
plot(t_s*1e6,trVin_V-cfg.settleTolerance_V,':','LineWidth',1.0, ...
    'HandleVisibility','off');
plot(t_s*1e6,trVout_V,'LineWidth',1.5);
addSrCursor(risePt,sprintf('Rise: %.4g V/us',srRise_Vus));
addSrCursor(fallPt,sprintf('Fall: %.4g V/us',srFall_Vus));
addMetricBox({sprintf('Settling time: %s ns', ...
    formatFixed(settlingTime_s*1e9))});
ylabel('Voltage (V)');
legend('Input','Output','Location','best');
stylePlot('Time (us)','SEOTA Closed-Loop Step Response');
savePlot(fig,plotDir,'NOM.closed_loop_step_response.png');

%% Full-PVT analysis and reports
allProcesses = ["NOM" "FF" "SS" "FS" "SF"];
processTokens = lower(allProcesses);
allCases = ["nom" "vl" "vh" "tl" "th" "vltl" "vlth" "vhtl" "vhth"];
caseCornerText = ["NOMNOM" "VLNOM" "VHNOM" "NOMTL" "NOMTH" ...
    "VLTL" "VLTH" "VHTL" "VHTH"];
nExpectedCorners = numel(allProcesses)*numel(allCases);
pvtCorners = strings(nExpectedCorners,1);
pvtRawValues = nan(size(rows,1),nExpectedCorners);
pvtMetrics = cell(nExpectedCorners,1);
missingPvt = strings(nExpectedCorners,1);
pvtIndex = 0;
missingIndex = 0;
for processIndex = 1:numel(allProcesses)
    process = allProcesses(processIndex);
    processToken = processTokens(processIndex);
    for caseIndex = 1:numel(allCases)
        caseName = allCases(caseIndex);
        cornerName = process + caseCornerText(caseIndex);
        resultDir = fullfile(scriptDir,processToken + ".Result_txt");
        files = runFiles(resultDir,processToken,caseName);
        requiredFiles = [files.olOp files.diffAc files.cmAc files.psrrpAc ...
            files.psrrnAc files.vtc files.noise files.clOp files.clDc files.clTran];
        if ~all(isfile(requiredFiles))
            missingIndex = missingIndex+1;
            missingPvt(missingIndex) = cornerName;
            continue;
        end
        pvtIndex = pvtIndex+1;
        if process == "NOM" && caseName == "nom"
            metrics = nomMetrics;
        else
            metrics = analyzeRun(scriptDir,processToken,caseName,cfg);
        end
        pvtMetrics{pvtIndex} = metrics;
        pvtCorners(pvtIndex) = cornerName;
        pvtRawValues(:,pvtIndex) = metricsToRaw( ...
            metrics,rows,cfg);
    end
end
pvtCorners = pvtCorners(1:pvtIndex);
pvtRawValues = pvtRawValues(:,1:pvtIndex);
pvtMetrics = pvtMetrics(1:pvtIndex);
missingPvt = missingPvt(1:missingIndex);
if ~isempty(missingPvt)
    warning('SEOTA_Analyze:MissingPvtRuns', ...
        'PVT runs missing required simulation files: %s.',strjoin(missingPvt,', '));
end

[rows,pvtScaledValues] = adaptReportUnits(rows,pvtRawValues);
pvtValues = formatReportValues(rows,pvtScaledValues);
pvtSpecifications = pvtSpecStrings(rows);
checkPvtSpecifications(rows,pvtScaledValues,pvtCorners);

reportColumns = ["NOM" "FF" "SS" "FS" "SF" "VL" "VH" "TL" "TH"];
reportCornerKeys = ["NOMNOMNOM" "FFNOMNOM" "SSNOMNOM" "FSNOMNOM" ...
    "SFNOMNOM" "NOMVLNOM" "NOMVHNOM" "NOMNOMTL" "NOMNOMTH"];
[foundReportCorners,reportIndices] = ismember(reportCornerKeys,pvtCorners);
if ~all(foundReportCorners)
    error('SEOTA_Analyze:MissingReportCorners', ...
        'Required summary corners are missing: %s.', ...
        strjoin(reportCornerKeys(~foundReportCorners),', '));
end
reportValues = pvtValues(:,reportIndices);

summaryTable = table(rows(:,1),rows(:,2),pvtSpecifications, ...
    'VariableNames',{'Parameter','Unit','Spec'});
summaryTable = [summaryTable array2table(reportValues, ...
    'VariableNames',cellstr(reportColumns))];
fprintf('\nSEOTA COMPARISON SUMMARY\n\n');
printSummaryTable(rows,pvtSpecifications,reportColumns,reportValues);
writetable(summaryTable,fullfile(reportDir,'SEOTA_table_report.csv'));
writetable(summaryTable,fullfile(reportDir,'NOM.SEOTA_summary.csv'));

worstCase = buildWorstCaseTable( ...
    rows,pvtCorners,pvtScaledValues,pvtMetrics,cfg);
fprintf('\nSEOTA FULL-PVT WORST CASE\n\n');
printWorstCaseTable(worstCase);
writetable(worstCase,fullfile(reportDir,'SEOTA_worst_case_report.csv'));

%% Monte Carlo analysis (independent of the existing PVT flow)
runMcSection(scriptDir,plotDir,reportDir);

end

function runMcSection(scriptDir,plotDir,reportDir)
% Read only compact MM / GL / FULL summaries; debug operating-point exports
% remain available for diagnosis and are intentionally excluded from reports.
modes = ["MM" "GL" "FULL"];
definitions = seotaMcDefinitions();
results = cell(numel(modes),1);
missingFiles = strings(0,1);
for modeIndex = 1:numel(modes)
    token = lower(modes(modeIndex));
    resultDir = fullfile(scriptDir,token+".Result_txt");
    olFile = fullfile(resultDir,token+".ol_mc_summary.txt");
    clFile = fullfile(resultDir,token+".cl_mc_summary.txt");
    if ~isfile(olFile) || ~isfile(clFile)
        missingFiles(end+1,1) = modes(modeIndex)+": "+olFile+" | "+clFile; %#ok<AGROW>
        continue;
    end
    results{modeIndex} = summarizeSeotaMc(olFile,clFile,modes(modeIndex),definitions);
end
if ~isempty(missingFiles)
    warning('SEOTA_Analyze:MissingMcFiles','SEOTA MC files missing:\n%s', ...
        strjoin(cellstr(missingFiles),newline));
end
results = results(~cellfun(@isempty,results));
if isempty(results), return; end

fprintf('\nSE OTA MONTE CARLO SUMMARY\n');
for resultIndex = 1:numel(results)
    result = results{resultIndex};
    fprintf('\n%s MONTE CARLO SUMMARY\n',result.mode);
    fprintf('Requested: %d   Valid: %d   Failed: %d   Overall yield: %.2f%%\n', ...
        result.requested,result.valid,result.failed,result.overallYield);
    if ~isempty(result.failedRunIds)
        fprintf('Failed run IDs: %s\n',strjoin(string(result.failedRunIds),', '));
    end
    printSeotaMcTable(result.table);
    writetable(result.table,fullfile(reportDir,result.mode+'_SEOTA_MC_Summary.csv'));
end
modeValues = string(cellfun(@(r) r.mode,results,'UniformOutput',false));
requestedValues = cellfun(@(r) r.requested,results);
validValues = cellfun(@(r) r.valid,results);
failedValues = cellfun(@(r) r.failed,results);
yieldValues = cellfun(@(r) r.overallYield,results);
runTable = table(modeValues(:),requestedValues(:),validValues(:), ...
    failedValues(:),yieldValues(:), ...
    'VariableNames',{'Mode','Requested','Valid','Failed','OverallYield_pct'});
writetable(runTable,fullfile(reportDir,'SEOTA_MC_Run_Summary.csv'));
fullIndex = find(cellfun(@(r) r.mode == "FULL",results),1);
if isempty(fullIndex) || results{fullIndex}.valid == 0
    warning('SEOTA_Analyze:MissingFullMc', ...
        'MC tables were written, but MC plots require valid FULL data.');
    return;
end
plotSeotaMcHistograms(results,definitions,plotDir);
end

function definitions = seotaMcDefinitions()
definitions.names = ["Bias current" "Total current" "Total power" ...
    "DC gain" "UGF" "Phase margin" "Input offset" "Gain error"];
definitions.units = ["uA" "mA" "mW" "dB" "MHz" "deg" "uV" "%"];
definitions.specs = strings(size(definitions.names));
definitions.bounds = cell(size(definitions.names));
for metricIndex = 1:numel(definitions.names)
    definitions.specs(metricIndex) = seotaSpecText( ...
        definitions.names(metricIndex),definitions.units(metricIndex));
    definitions.bounds{metricIndex} = seotaSpecBounds( ...
        definitions.names(metricIndex),definitions.units(metricIndex));
end
definitions.requestedRuns = 200;
definitions.columns = seotaMcSchema();
definitions.plotIndices = [7 4 5 6 8];
definitions.plotFiles = ["Fig_MC_01_Vos_Histogram.png" ...
    "Fig_MC_02_DC_Gain_Histogram.png" "Fig_MC_03_UGF_Histogram.png" ...
    "Fig_MC_04_Phase_Margin_Histogram.png" "Fig_MC_05_Gain_Error_Histogram.png"];
end

function columns = seotaMcSchema()
% Compact MC TXT column map; keep this synchronized with the testbench.
columns.ol = struct('count',13,'run',1,'vos',2,'centerError',3, ...
    'gainVV',4,'gainDb',5,'ugfHz',6,'phaseUgf',7,'phaseMargin',8, ...
    'vout',9,'biasNode',10,'biasCurrent',11,'totalCurrent',12, ...
    'totalPower',13);
columns.cl = struct('count',9,'run',1,'vos',2,'vout',3, ...
    'voutError',4,'gainVV',5,'biasNode',6,'biasCurrent',7, ...
    'totalCurrent',8,'totalPower',9);
end

function result = summarizeSeotaMc(olFile,clFile,mode,definitions)
columns = definitions.columns;
ol = readMcSummary(olFile,columns.ol.count);
cl = readMcSummary(clFile,columns.cl.count);
validateMcRunIds(ol(:,columns.ol.run),olFile,definitions.requestedRuns);
validateMcRunIds(cl(:,columns.cl.run),clFile,definitions.requestedRuns);
[runIds,olIndex,clIndex] = intersect( ...
    ol(:,columns.ol.run),cl(:,columns.cl.run),'stable');
if isempty(runIds)
    error('SEOTA_Analyze:McRunIds','%s and %s have no matching MC run IDs.',olFile,clFile);
end
if any(~isfinite(ol(olIndex,columns.ol.centerError)))
    warning('SEOTA_Analyze:McCenterError','%s contains nonfinite OL center-error samples.',olFile);
end
values = [abs(ol(olIndex,columns.ol.biasCurrent))*1e6, ...
    abs(ol(olIndex,columns.ol.totalCurrent))*1e3, ...
    abs(ol(olIndex,columns.ol.totalPower))*1e3, ...
    ol(olIndex,columns.ol.gainDb),ol(olIndex,columns.ol.ugfHz)/1e6, ...
    ol(olIndex,columns.ol.phaseMargin),cl(clIndex,columns.cl.vos)*1e6, ...
    100*(cl(clIndex,columns.cl.gainVV)-1)];
validMask = all(isfinite(values),2) & values(:,5) > 0;
result.mode = mode;
result.requested = definitions.requestedRuns;
result.runs = runIds(validMask);
result.values = values(validMask,:);
result.valid = heightOrLength(result.runs);
result.failed = result.requested-result.valid;
result.failedRunIds = setdiff((1:result.requested)',result.runs);
warnOnSeotaMcGainCollapse(result,definitions);
[result.stats,result.yield,result.overallYield] = seotaMcStatistics( ...
    result.values,definitions);
result.table = table(definitions.names',definitions.units',definitions.specs', ...
    result.stats(:,1),result.stats(:,2),result.stats(:,3),result.stats(:,4), ...
    result.stats(:,5),result.stats(:,6),result.stats(:,7),result.yield', ...
    'VariableNames',{'Parameter','Unit','Spec','Min','MeanMinus3Sigma', ...
    'MeanMinusSigma','Mean','MeanPlusSigma','MeanPlus3Sigma','Max','Yield'});
end

function count = heightOrLength(values)
count = numel(values);
end

function warnOnSeotaMcGainCollapse(result,definitions)
metricIndex = find(definitions.names == "Gain error",1);
if isempty(metricIndex) || isempty(result.values), return; end
collapsed = result.values(:,metricIndex) <= -90;
if any(collapsed)
    warning('SEOTA_Analyze:McGainCollapse', ...
        '%s has %d valid sample(s) with gain error <= -90%% (MC run ID(s): %s). Verify circuit collapse versus an ngspice measurement failure before trusting these samples.', ...
        char(result.mode),nnz(collapsed),char(strjoin(string(result.runs(collapsed)),', ')));
end
end

function [stats,yield,overallYield] = seotaMcStatistics(values,definitions)
nMetrics = numel(definitions.names);
stats = nan(nMetrics,7);
if isempty(values)
    yield = zeros(1,nMetrics);
    overallYield = 0;
    return;
end
pass = false(size(values));
for metricIndex = 1:nMetrics
    x = values(:,metricIndex); mu = mean(x); sigma = std(x,0);
    stats(metricIndex,:) = [min(x) mu-3*sigma mu-sigma mu mu+sigma mu+3*sigma max(x)];
    pass(:,metricIndex) = seotaSpecPass( ...
        definitions.names(metricIndex),x,definitions.units(metricIndex));
end
yield = 100*mean(pass,1);
overallYield = 100*mean(all(pass,2));
end

function validateMcRunIds(runIds,filePath,requestedRuns)
if any(~isfinite(runIds)) || any(runIds ~= round(runIds)) || ...
        any(runIds < 1 | runIds > requestedRuns) || numel(unique(runIds)) ~= numel(runIds)
    error('SEOTA_Analyze:McRunIds', ...
        '%s must contain unique integer MC run IDs in 1...%d.',filePath,requestedRuns);
end
end

function plotSeotaMcHistograms(results,definitions,plotDir)
for plotIndex = 1:numel(definitions.plotIndices)
    metricIndex = definitions.plotIndices(plotIndex);
    seotaMcHistogram(results,metricIndex,plotDir,definitions.plotFiles(plotIndex), ...
        'SEOTA '+definitions.names(metricIndex)+' Distribution - MM / GL / FULL', ...
        mcXAxisLabel(definitions.names(metricIndex),definitions.units(metricIndex)), ...
        definitions.bounds{metricIndex});
end
end

function seotaMcHistogram(results,metricIndex,plotDir,fileName,titleText,xLabelText,specBounds)
valueSets = cellfun(@(r) r.values(:,metricIndex),results,'UniformOutput',false);
allValues = vertcat(valueSets{:});
if isempty(allValues), return; end
[lower,upper,fullResult] = seotaMcDisplayRange(allValues,results,metricIndex,specBounds);
edges = linspace(lower,upper,21);
fig = figure; hold on; colors = lines(numel(results));
for resultIndex = 1:numel(results)
    values = results{resultIndex}.values(:,metricIndex);
    values = values(isfinite(values) & values >= lower & values <= upper);
    if isempty(values), continue; end
    probabilityPct = 100*histcounts(values,edges,'Normalization','probability');
    stairs(edges,[probabilityPct 0],'LineWidth',1.5,'Color',colors(resultIndex,:), ...
        'DisplayName',char(results{resultIndex}.mode));
end
addMcSpecLines(specBounds,lower,upper);
seotaMcAddFullStatMarkers(fullResult,metricIndex);
xlim([lower upper]); ylabel('Samples (%)');
stylePlot(xLabelText,titleText); legend('Location','best');
savePlot(fig,plotDir,fileName);
end

function [lower,upper,fullResult] = seotaMcDisplayRange(values,results,metricIndex,specBounds)
fullIndex = find(cellfun(@(r) r.mode == "FULL",results),1);
fullResult = results{fullIndex};
center = fullResult.stats(metricIndex,4);
distances = abs(values(:)-center);
finiteBounds = specBounds(isfinite(specBounds));
if ~isempty(finiteBounds)
    distances = [distances; abs(finiteBounds(:)-center)];
end
halfRange = max(distances);
if ~isfinite(halfRange) || halfRange == 0, halfRange = max(abs(center)*0.05,1); end
lower = center-1.05*halfRange;
upper = center+1.05*halfRange;
end

function seotaMcAddFullStatMarkers(fullResult,metricIndex)
markers = fullResult.stats(metricIndex,2:6);
labels = ["-3σ" "-σ" "μ" "+σ" "+3σ"];
for markerIndex = 1:numel(markers)
    addCursorLine(markers(markerIndex),0,labels(markerIndex));
end
end

function addMcSpecLines(bounds,lower,upper)
for value = bounds(:)'
    if isfinite(value) && value >= lower && value <= upper
        xline(value,'--','HandleVisibility','off');
    end
end
end

function label = mcXAxisLabel(parameter,unit)
if parameter == "Input offset"
    label = "Input Offset (" + unit + ")";
else
    label = parameter + " (" + unit + ")";
end
end

function printSeotaMcTable(resultTable)
fprintf('%-40s %-6s %-14s %10s %10s %10s %10s %10s %10s %10s %8s\n', ...
    'Parameter','Unit','Spec','Min','μ-3σ','μ-σ','Mean','μ+σ','μ+3σ','Max','Yield');
for rowIndex = 1:height(resultTable)
    fprintf('%-40s %-6s %-14s %10s %10s %10s %10s %10s %10s %10s %8s\n', ...
        char(resultTable.Parameter(rowIndex)),char(resultTable.Unit(rowIndex)), ...
        char(resultTable.Spec(rowIndex)),formatFixed(resultTable.Min(rowIndex)), ...
        formatFixed(resultTable.MeanMinus3Sigma(rowIndex)), ...
        formatFixed(resultTable.MeanMinusSigma(rowIndex)),formatFixed(resultTable.Mean(rowIndex)), ...
        formatFixed(resultTable.MeanPlusSigma(rowIndex)), ...
        formatFixed(resultTable.MeanPlus3Sigma(rowIndex)),formatFixed(resultTable.Max(rowIndex)), ...
        sprintf('%.2f%%',resultTable.Yield(rowIndex)));
end
end

function cfg = analysisConfig
cfg.cLoad_pF = 10;
cfg.nominalCase = "nom";
cfg.closedLoopTarget_VV = 1;
cfg.biasTarget_A = 40e-6;
cfg.trackTolerance_V = 2e-3;
cfg.settleTolerance_V = 2e-3;
cfg.offsetMaxJumpFraction = 0.25;
cfg.noiseBand_Hz = [0.05 150];
cfg.rejectionFrequencies_Hz = [60 150];
cfg.markFrequencies_Hz = [0.05 cfg.rejectionFrequencies_Hz 1e3];
cfg.noiseMarkFrequencies_Hz = [cfg.noiseBand_Hz(1) ...
    cfg.rejectionFrequencies_Hz(1) cfg.noiseBand_Hz(2)];
end

function rows = reportRows
rows = [
    "Set conditions",              ""
    "AVDD",                        "V"
    "CLoad",                       "pF"
    "Vin,cm",                      "V"
    "Closed-loop target gain",     "V/V"
    "",                            ""
    "Operating point",             ""
    "Bias current",                "A"
    "Total current",               "A"
    "Total power",                 "W"
    "",                            ""
    "Open-loop simulation",        ""
    "DC gain",                     "dB"
    "UGF",                         "Hz"
    "Phase margin",                "deg"
    "Input offset",                "V"
    "CMRR @ 60 Hz",                "dB"
    "CMRR @ 150 Hz",               "dB"
    "PSRR+ @ 60 Hz",               "dB"
    "PSRR+ @ 150 Hz",              "dB"
    "PSRR- @ 60 Hz",               "dB"
    "PSRR- @ 150 Hz",              "dB"
    "Input-referred noise 0.05-150 Hz", "Vrms"
    "",                            ""
    "Closed-loop simulation",      ""
    "Closed-loop gain",            "dB"
    "Gain error",                  "%"
    "Vout,DC error",               "V"
    "Input low",                   "V"
    "Input high",                  "V"
    "Input high headroom",         "V"
    "Output low",                  "V"
    "Output high",                 "V"
    "Output high headroom",        "V"
    "SR rise",                     "V/us"
    "SR fall",                     "V/us"
    "Settling time",               "s"
];
end

function specifications = pvtSpecStrings(rows)
specifications = strings(size(rows,1),1);
for rowIndex = 1:size(rows,1)
    specifications(rowIndex) = seotaSpecText(rows(rowIndex,1),rows(rowIndex,2));
end
end

function specification = seotaSpecText(parameter,unit)
switch string(parameter)
    case "Bias current", specification = seotaRangeSpec(40e-6,10e-6,unit);
    case "Total current", specification = "≤"+seotaSpecNumber(1.25e-3,unit);
    case "Total power", specification = "≤"+seotaSpecNumber(4.5e-3,unit);
    case "DC gain", specification = "≥88";
    case "UGF", specification = "≥"+seotaSpecNumber(8e6,unit);
    case "Phase margin", specification = "≥55";
    case "Input offset", specification = "±"+seotaSpecNumber(2e-3,unit);
    case "CMRR @ 60 Hz", specification = "≥105";
    case "CMRR @ 150 Hz", specification = "≥105";
    case "PSRR+ @ 60 Hz", specification = "≥100";
    case "PSRR+ @ 150 Hz", specification = "≥95";
    case "PSRR- @ 60 Hz", specification = "≥100";
    case "PSRR- @ 150 Hz", specification = "≥95";
    case "Input-referred noise 0.05-150 Hz", specification = "≤"+seotaSpecNumber(2.5e-6,unit);
    case "Gain error", specification = "±0.01";
    case "Vout,DC error", specification = "±"+seotaSpecNumber(2e-3,unit);
    case "Input low", specification = "≤"+seotaSpecNumber(600e-3,unit);
    case "Input high", specification = "≥"+seotaSpecNumber(2.75,unit);
    case "Input high headroom", specification = "≤"+seotaSpecNumber(250e-3,unit);
    case "Output low", specification = "≤"+seotaSpecNumber(600e-3,unit);
    case "Output high", specification = "≥"+seotaSpecNumber(2.75,unit);
    case "Output high headroom", specification = "≤"+seotaSpecNumber(250e-3,unit);
    case "SR rise", specification = "≥6.5";
    case "SR fall", specification = "≥5.0";
    case "Settling time", specification = "≤"+seotaSpecNumber(225e-9,unit);
    otherwise, specification = "";
end
end

function specification = seotaRangeSpec(center,tolerance,unit)
specification = seotaSpecNumber(center,unit)+"±"+seotaSpecNumber(tolerance,unit);
end

function text = seotaSpecNumber(baseValue,unit)
text = string(sprintf('%.6g',baseValue*seotaUnitFactor(unit)));
end

function bounds = seotaSpecBounds(parameter,unit)
% Return numeric specification limits in the requested display unit.
baseBounds = seotaSpecBaseBounds(parameter);
bounds = baseBounds/seotaUnitToBase(unit);
end

function bounds = seotaSpecBaseBounds(parameter)
% Each row is defined once in SI/base units: [lower upper].
switch string(parameter)
    case "Bias current", bounds = [30e-6 50e-6];
    case "Total current", bounds = [-Inf 1.25e-3];
    case "Total power", bounds = [-Inf 4.5e-3];
    case "DC gain", bounds = [88 Inf];
    case "UGF", bounds = [8e6 Inf];
    case "Phase margin", bounds = [55 Inf];
    case "Input offset", bounds = [-2e-3 2e-3];
    case {"CMRR @ 60 Hz","CMRR @ 150 Hz"}, bounds = [105 Inf];
    case "PSRR+ @ 60 Hz", bounds = [100 Inf];
    case "PSRR+ @ 150 Hz", bounds = [95 Inf];
    case "PSRR- @ 60 Hz", bounds = [100 Inf];
    case "PSRR- @ 150 Hz", bounds = [95 Inf];
    case "Input-referred noise 0.05-150 Hz", bounds = [-Inf 2.5e-6];
    case "Gain error", bounds = [-0.01 0.01];
    case "Vout,DC error", bounds = [-2e-3 2e-3];
    case {"Input low","Output low"}, bounds = [-Inf 600e-3];
    case {"Input high","Output high"}, bounds = [2.75 Inf];
    case {"Input high headroom","Output high headroom"}, bounds = [-Inf 250e-3];
    case "SR rise", bounds = [6.5 Inf];
    case "SR fall", bounds = [5.0 Inf];
    case "Settling time", bounds = [-Inf 225e-9];
    otherwise, bounds = [-Inf Inf];
end
end

function factor = seotaUnitFactor(unit)
factor = 1/seotaUnitToBase(unit);
end

function checkPvtSpecifications(rows,values,corners)
passMatrix = true(size(values));
checkedRows = false(size(rows,1),1);
for rowIndex = 1:size(rows,1)
    if strlength(seotaSpecText(rows(rowIndex,1),rows(rowIndex,2))) == 0
        continue;
    end
    passMatrix(rowIndex,:) = seotaSpecPass(rows(rowIndex,1), ...
        values(rowIndex,:),rows(rowIndex,2));
    checkedRows(rowIndex) = true;
end
cornerPass = all(passMatrix(checkedRows,:),1);
if all(cornerPass)
    fprintf('\nSEOTA STRICT PVT SPECIFICATION: PASS (%d/%d corners)\n', ...
        nnz(cornerPass),numel(corners));
else
    warning('SEOTA_Analyze:PvtSpecFailure', ...
        'SEOTA strict PVT specification: FAIL (%d/%d corners): %s', ...
        nnz(cornerPass),numel(corners),strjoin(corners(~cornerPass),', '));
end
end

function pass = seotaSpecPass(parameter,value,unit)
bounds = seotaSpecBounds(parameter,unit);
pass = isfinite(value) & value >= bounds(1) & value <= bounds(2);
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
files.clDc = clPrefix+"dc.txt";
files.clTran = clPrefix+"tran.txt";
end

function data = readNumericFile(file,expectedColumns)
if ~isfile(file)
    error('SEOTA_Analyze:MissingFile','Missing required file: %s',file);
end

data = readmatrix(file,'FileType','text');
data = data(any(isfinite(data),2),:);
data = data(:,any(isfinite(data),1));
if isempty(data)
    error('SEOTA_Analyze:EmptyFile','No numeric data found in %s.',file);
end
if size(data,2) == expectedColumns+1 && columnsMatch(data(:,1),data(:,2))
    data = data(:,2:end);
end
if size(data,2) ~= expectedColumns
    error('SEOTA_Analyze:ColumnCount', ...
        '%s must contain %d columns; found %d.', ...
        file,expectedColumns,size(data,2));
end
if any(~isfinite(data),'all')
    error('SEOTA_Analyze:NonfiniteData', ...
        '%s contains nonfinite numeric samples.',file);
end
end

function data = readMcSummary(file,expectedColumns)
% Keep nonfinite metric cells so MC can classify their runs as failed.
if ~isfile(file)
    error('SEOTA_Analyze:MissingFile','Missing required file: %s',file);
end
data = readmatrix(file,'FileType','text');
data = data(any(isfinite(data),2),:);
data = data(:,any(isfinite(data),1));
if isempty(data)
    error('SEOTA_Analyze:EmptyFile','No numeric data found in %s.',file);
end
if size(data,2) == expectedColumns+1 && columnsMatch(data(:,1),data(:,2))
    data = data(:,2:end);
end
if size(data,2) ~= expectedColumns
    error('SEOTA_Analyze:ColumnCount', ...
        '%s must contain %d columns; found %d.',file,expectedColumns,size(data,2));
end
end

function tf = columnsMatch(a,b)
scale = max([ones(size(a)) abs(a) abs(b)],[],2);
tf = all(abs(a-b) <= 100*eps(scale));
end

function validateFrequency(f,label)
if any(~isfinite(f)) || any(f <= 0) || any(diff(f) <= 0)
    error('SEOTA_Analyze:FrequencyAxis', ...
        '%s frequency must be finite, positive, and strictly increasing.', ...
        label);
end
end

function m = analyzeRun(scriptDir,process,caseName,cfg)
    resultDir = fullfile(scriptDir,process + ".Result_txt");
    files = runFiles(resultDir,process,caseName);

    op = readNumericFile(files.olOp,8);
    op = op(end,:);
    m.vdd_V = op(2);
    m.vinCm_V = 0.5*(op(3)+op(4));
    m.ibias_A = abs(op(8));
    m.totalCurrent_A = abs(op(7));
    m.totalPower_W = m.vdd_V*m.totalCurrent_A;

    [fAd_Hz,Ad] = transferFromFile(files.diffAc);
    [gain_dB,~,m.ugf_Hz,m.phaseMargin_deg] = acMetrics(fAd_Hz,Ad);
    m.dcGain_dB = gain_dB(1);
    [fCm_Hz,Acm] = transferFromFile(files.cmAc);
    [fP_Hz,AsupP] = transferFromFile(files.psrrpAc);
    [fN_Hz,AsupN] = transferFromFile(files.psrrnAc);
    cmrr_dB = rejectionDb(fAd_Hz,Ad,fCm_Hz,Acm);
    psrrP_dB = rejectionDb(fAd_Hz,Ad,fP_Hz,AsupP);
    psrrN_dB = rejectionDb(fAd_Hz,Ad,fN_Hz,AsupN);
    m.cmrr_dB = interpAtFreq( ...
        fCm_Hz,cmrr_dB,cfg.rejectionFrequencies_Hz);
    m.psrrP_dB = interpAtFreq( ...
        fP_Hz,psrrP_dB,cfg.rejectionFrequencies_Hz);
    m.psrrN_dB = interpAtFreq( ...
        fN_Hz,psrrN_dB,cfg.rejectionFrequencies_Hz);

    vtc = readNumericFile(files.vtc,6);
    m.offset_V = zeroNoJump(vtc(:,1),vtc(:,5)-0.5*m.vdd_V, ...
        cfg.offsetMaxJumpFraction*m.vdd_V);
    noise = readNumericFile(files.noise,3);
    validateFrequency(noise(:,1),files.noise);
    m.inputNoise_Vrms = integrateNoise( ...
        noise(:,1),abs(noise(:,3)),cfg.noiseBand_Hz);

    m.usableInputLow_V = NaN; m.usableInputHigh_V = NaN;
    m.inputHighHeadroom_V = NaN;
    m.usableOutputLow_V = NaN; m.usableOutputHigh_V = NaN;
    m.outputHighHeadroom_V = NaN;

    clOp = readNumericFile(files.clOp,8);
    clOp = clOp(end,:);
    clVinDc_V = clOp(3);
    cl = readNumericFile(files.clDc,6);
    [clVin_V,order] = sort(cl(:,1));
    clVout_V = cl(order,2);
    clErr_V = cl(order,3);
    [~,i0] = min(abs(clVin_V-clVinDc_V));
    clGain = localSlope(clVin_V,clVout_V,clVinDc_V);
    m.clGain_dB = 20*log10(abs(clGain));
    m.gainError_pct = 100*(clGain-1);
    m.voutDc_V = clVout_V(i0);
    m.voutDcError_V = m.voutDc_V-clVinDc_V;
    [iLow,iHigh] = continuousIndices( ...
        abs(clErr_V)<=cfg.trackTolerance_V,i0);
    if isfinite(iLow)
        m.usableInputLow_V = clVin_V(iLow);
        m.usableInputHigh_V = clVin_V(iHigh);
        m.inputHighHeadroom_V = m.vdd_V - m.usableInputHigh_V;
        m.usableOutputLow_V = min(clVout_V(iLow:iHigh));
        m.usableOutputHigh_V = max(clVout_V(iLow:iHigh));
        m.outputHighHeadroom_V = m.vdd_V - m.usableOutputHigh_V;
    end
    tr = readNumericFile(files.clTran,7);
    [m.srRise_Vus,m.srFall_Vus,tRise_s,tFall_s] = ...
        stepMetrics(tr(:,1),tr(:,2),tr(:,3),cfg.settleTolerance_V);
    m.settlingTime_s = maxFinite([tRise_s tFall_s]);
end

function values = metricsToRaw(m,rows,cfg)
    % Returns raw numeric values in the initial table units (no rounding).
    values = nan(size(rows,1),1);
    for rowIndex = 1:size(rows,1)
        parameter = rows(rowIndex,1);
        unit = rows(rowIndex,2);
        if unit == ""
            continue;
        end
        switch parameter
            case "AVDD",                     values(rowIndex) = m.vdd_V;
            case "CLoad",                    values(rowIndex) = cfg.cLoad_pF;
            case "Vin,cm",                   values(rowIndex) = m.vinCm_V;
            case "Closed-loop target gain"
                values(rowIndex) = cfg.closedLoopTarget_VV;
            case "Bias current",             values(rowIndex) = m.ibias_A;
            case "Total current",            values(rowIndex) = m.totalCurrent_A;
            case "Total power",              values(rowIndex) = m.totalPower_W;
            case "DC gain",                  values(rowIndex) = m.dcGain_dB;
            case "UGF",                      values(rowIndex) = m.ugf_Hz;
            case "Phase margin"
                values(rowIndex) = m.phaseMargin_deg;
            case "Input offset",             values(rowIndex) = m.offset_V;
            case "CMRR @ 60 Hz",             values(rowIndex) = m.cmrr_dB(1);
            case "CMRR @ 150 Hz",            values(rowIndex) = m.cmrr_dB(2);
            case "PSRR+ @ 60 Hz",            values(rowIndex) = m.psrrP_dB(1);
            case "PSRR+ @ 150 Hz",           values(rowIndex) = m.psrrP_dB(2);
            case "PSRR- @ 60 Hz",            values(rowIndex) = m.psrrN_dB(1);
            case "PSRR- @ 150 Hz",           values(rowIndex) = m.psrrN_dB(2);
            case "Input-referred noise 0.05-150 Hz"
                values(rowIndex) = m.inputNoise_Vrms;
            case "Closed-loop gain",         values(rowIndex) = m.clGain_dB;
            case "Gain error",               values(rowIndex) = m.gainError_pct;
            case "Vout,DC error",            values(rowIndex) = m.voutDcError_V;
            case "Input low",                values(rowIndex) = m.usableInputLow_V;
            case "Input high",               values(rowIndex) = m.usableInputHigh_V;
            case "Input high headroom",      values(rowIndex) = m.inputHighHeadroom_V;
            case "Output low",               values(rowIndex) = m.usableOutputLow_V;
            case "Output high",              values(rowIndex) = m.usableOutputHigh_V;
            case "Output high headroom",     values(rowIndex) = m.outputHighHeadroom_V;
            case "SR rise",                  values(rowIndex) = m.srRise_Vus;
            case "SR fall",                  values(rowIndex) = m.srFall_Vus;
            case "Settling time"
                values(rowIndex) = m.settlingTime_s;
        end
    end
end

function results = buildWorstCaseTable(rows,columns,values,metrics,cfg)
    % values is numeric double (pvtScaledValues), already unit-adapted.
    keep = rows(:,2) ~= "" & ~ismember(rows(:,1), ...
        ["AVDD" "CLoad" "Vin,cm" "Closed-loop target gain"]);
    parameters = rows(keep,1);
    units = rows(keep,2);
    specifications = pvtSpecStrings(rows);
    specifications = specifications(keep);
    sourceRows = find(keep);
    worstValues = nan(numel(sourceRows),1);
    worstCorners = strings(numel(sourceRows),1);

    inputHighHeadrooms = cellfun(@(m) m.inputHighHeadroom_V,metrics);
    inputHighHeadrooms(~isfinite(inputHighHeadrooms)) = -Inf;
    [~,worstInputHighCol] = max(inputHighHeadrooms);

    outputHighHeadrooms = cellfun(@(m) m.outputHighHeadroom_V,metrics);
    outputHighHeadrooms(~isfinite(outputHighHeadrooms)) = -Inf;
    [~,worstOutputHighCol] = max(outputHighHeadrooms);

    for resultIndex = 1:numel(sourceRows)
        rowIndex = sourceRows(resultIndex);
        parameter = rows(rowIndex,1);
        candidates = values(rowIndex,:);   % already numeric double
        valid = isfinite(candidates);
        if ~any(valid), continue; end
        validIndices = find(valid);

        if ismember(parameter,["Input high" "Input high headroom"])
            selectedColumn = worstInputHighCol;
            selectedValue = candidates(selectedColumn);
        elseif ismember(parameter,["Output high" "Output high headroom"])
            selectedColumn = worstOutputHighCol;
            selectedValue = candidates(selectedColumn);
        elseif ismember(parameter,["DC gain" "UGF" "Phase margin" ...
                "CMRR @ 60 Hz" "CMRR @ 150 Hz" "PSRR+ @ 60 Hz" ...
                "PSRR+ @ 150 Hz" "PSRR- @ 60 Hz" "PSRR- @ 150 Hz" ...
                "SR rise" "SR fall"])
            [selectedValue,localIndex] = min(candidates(valid));
            selectedColumn = validIndices(localIndex);
        elseif parameter == "Bias current"
            rawCandidates = cellfun(@(m) m.ibias_A,metrics);
            [~,selectedColumn] = max(abs( ...
                rawCandidates-cfg.biasTarget_A));
            selectedValue = candidates(selectedColumn);
        elseif ismember(parameter,["Input offset" "Vout,DC error" ...
                "Closed-loop gain" "Gain error" "CM Interference Gain Change"])
            [~,localIndex] = max(abs(candidates(valid)));
            selectedColumn = validIndices(localIndex);
            selectedValue = candidates(selectedColumn);
        else
            [selectedValue,localIndex] = max(candidates(valid));
            selectedColumn = validIndices(localIndex);
        end
        worstValues(resultIndex) = selectedValue;
        worstCorners(resultIndex) = columns(selectedColumn);
    end

    formatted = strings(size(worstValues));
    for resultIndex = 1:numel(worstValues)
        formatted(resultIndex) = ...
            formatOne(worstValues(resultIndex),units(resultIndex));
    end
    results = table(parameters,units,specifications,formatted,worstCorners, ...
        'VariableNames',{'Parameter','Unit','Spec','Value','Corner'});
end

function printWorstCaseTable(results)
    parameterWidth = max(36,max(strlength(results.Parameter))+2);
    fprintf('%-*s %-8s %-14s %13s %-8s\n',parameterWidth, ...
        'Parameter','Unit','Spec','Value','Corner');
    fprintf('%s\n',repmat('-',1,parameterWidth+47));
    for rowIndex = 1:height(results)
        fprintf('%-*s %-8s %-14s %13s %-8s\n',parameterWidth, ...
            char(results.Parameter(rowIndex)),char(results.Unit(rowIndex)), ...
            char(results.Spec(rowIndex)),char(results.Value(rowIndex)), ...
            char(results.Corner(rowIndex)));
    end
end

function [f,H] = transferFromFile(file)
    d = readNumericFile(file,5);
    f = d(:,1);
    validateFrequency(f,file);
    in = d(:,2) + 1j*d(:,3);
    out = d(:,4) + 1j*d(:,5);
    H = out ./ in;
end

function [gain_dB,phase_deg,ugf_Hz,phaseMargin_deg,f3dB_Hz] = ...
        acMetrics(f,H)
    gain_dB = 20*log10(abs(H));
    phase_deg = unwrap(angle(H))*180/pi;
    ugf_Hz = gainCross(f,gain_dB,0);
    phaseMargin_deg = 180+interpAtFreq(f,phase_deg,ugf_Hz);
    f3dB_Hz = gainCross(f,gain_dB,gain_dB(1)-3);
end

function fc = gainCross(f,gain_dB,target_dB)
    fc = NaN;
    for k = 1:numel(f)-1
        if (gain_dB(k)-target_dB)*(gain_dB(k+1)-target_dB) <= 0
            fc = 10^interp1(gain_dB(k:k+1),log10(f(k:k+1)),target_dB,'linear','extrap');
            return;
        end
    end
end

function y0 = interpAtFreq(f,y,f0)
    y0 = NaN(size(f0));
    ok = isfinite(f0);
    if any(ok)
        y0(ok) = interp1(log10(f),y,log10(f0(ok)),'linear',NaN);
    end
end

function rej_dB = rejectionDb(fAd,Ad,fBad,Abad)
    AdMag = interpAtFreq(fAd,abs(Ad),fBad);
    rej_dB = 20*log10(AdMag ./ abs(Abad));
end

function labelFreqSet(f,y,fList)
    for f0 = fList
        y0 = interpAtFreq(f,y,f0);
        addCursorLine(f0,y0, ...
            sprintf('%s: %.4g dB',frequencyText(f0),y0));
    end
end

function noiseRms = integrateNoise(f,noiseDensity,band)
    ok = f >= band(1) & f <= band(2) & isfinite(noiseDensity);
    if nnz(ok) < 2
        noiseRms = NaN;
    else
        noiseRms = sqrt(trapz(f(ok),noiseDensity(ok).^2));
    end
end

function x0 = zeroNoJump(x,y,jumpLimit)
    [x,idx] = sort(x);
    y = y(idx);
    x0 = NaN;
    for k = 1:numel(x)-1
        if abs(y(k+1)-y(k)) > jumpLimit, continue; end
        if y(k) == 0
            x0 = x(k); return;
        elseif y(k)*y(k+1) <= 0
            x0 = interp1(y(k:k+1),x(k:k+1),0,'linear',NaN);
            return;
        end
    end
end

function g = localSlope(x,y,x0)
    [x,idx] = sort(x);
    y = y(idx);
    if numel(x) < 3 || ~isfinite(x0)
        g = NaN;
    else
        g = interp1(x,gradient(y,x),x0,'linear',NaN);
    end
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
    if any(~isfinite(t)) || any(diff(t) <= 0)
        error('SEOTA_Analyze:TimeAxis', ...
            'Transient time must be finite and strictly increasing.');
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

function addCursor(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    xline(x,':','HandleVisibility','off');
    plot(x,y,'o','MarkerFaceColor','r','MarkerEdgeColor','r', ...
        'MarkerSize',6,'HandleVisibility','off');
    text(x,y," " + string(labelText),'BackgroundColor','w','Color','k', ...
        'Margin',2,'VerticalAlignment','bottom','HorizontalAlignment','left', ...
        'Clipping','on');
end

function addCursorLine(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    xline(x,':'," " + string(labelText),'HandleVisibility','off', ...
        'LabelVerticalAlignment','middle','LabelHorizontalAlignment','left');
end

function stylePlot(xLabelText,titleText)
    grid on;
    if strlength(string(xLabelText)) > 0, xlabel(xLabelText); end
    if strlength(string(titleText)) > 0, title(titleText); end
end

function savePlot(fig,plotDir,fileName)
    drawnow;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 10 4];
    fig.PaperSize = [10 4];
    print(fig,fullfile(plotDir,fileName),'-dpng','-r250');
end

function printSummaryTable(rows,specifications,columns,values)
    parameterWidth = max(36,max(strlength(rows(:,1)))+2);
    fprintf('%-*s %-8s %-14s',parameterWidth,'Parameter','Unit','Spec');
    for columnIndex = 1:numel(columns)
        fprintf(' %13s',columns(columnIndex));
    end
    fprintf('\n%s\n',repmat('-',1,parameterWidth+24+14*numel(columns)));
    for rowIndex = 1:size(rows,1)
        parameter = rows(rowIndex,1);
        unit = rows(rowIndex,2);
        if parameter == "" && unit == ""
            fprintf('\n');
        elseif unit == ""
            fprintf('%-*s\n',parameterWidth,upper(char(parameter)));
        else
            fprintf('%-*s %-8s %-14s',parameterWidth,char(parameter), ...
                char(unit),char(specifications(rowIndex)));
            for columnIndex = 1:numel(columns)
                fprintf(' %13s',char(values(rowIndex,columnIndex)));
            end
            fprintf('\n');
        end
    end
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
        s = "NaN";
    elseif f >= 1e6
        s = sprintf('%.4g MHz',f/1e6);
    elseif f >= 1e3
        s = sprintf('%.4g kHz',f/1e3);
    else
        s = sprintf('%.4g Hz',f);
    end
end

function [rows,scaledValues] = adaptReportUnits(rows,rawValues)
scaledValues = rawValues;
for rowIndex = 1:size(rows,1)
    sharedUnit = seotaCommonDisplayUnit(rows(rowIndex,1));
    if sharedUnit ~= ""
        baseValues = rawValues(rowIndex,:)*seotaUnitToBase(rows(rowIndex,2));
        rows(rowIndex,2) = sharedUnit;
        scaledValues(rowIndex,:) = baseValues/seotaUnitToBase(sharedUnit);
        continue;
    end
    [rows(rowIndex,2),scaledValues(rowIndex,:)] = ...
        adaptValuesUnit(rows(rowIndex,2),rawValues(rowIndex,:));
end
end

function unit = seotaCommonDisplayUnit(parameter)
switch string(parameter)
    case "Bias current", unit = "uA";
    case "Total current", unit = "mA";
    case "Total power", unit = "mW";
    case "DC gain", unit = "dB";
    case "UGF", unit = "MHz";
    case "Phase margin", unit = "deg";
    case "Input offset", unit = "uV";
    case "Gain error", unit = "%";
    otherwise, unit = "";
end
end

function factor = seotaUnitToBase(unit)
[prefix,~] = splitUnitPrefix(unit);
switch prefix
    case "T", factor = 1e12;
    case "G", factor = 1e9;
    case "M", factor = 1e6;
    case "k", factor = 1e3;
    case "m", factor = 1e-3;
    case "u", factor = 1e-6;
    case "n", factor = 1e-9;
    case "p", factor = 1e-12;
    case "f", factor = 1e-15;
    otherwise, factor = 1;
end
end

function [unit,scaledValues] = adaptValuesUnit(unit,values)
    scaledValues = values;
    if unit == "" || unit == "dB" || unit == "%" || unit == "V/V"
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

function formatted = formatReportValues(rows,values)
    formatted = strings(size(values));
    for rowIndex = 1:size(values,1)
        unit = rows(rowIndex,2);
        if unit == ""
            continue;
        end
        for columnIndex = 1:size(values,2)
            formatted(rowIndex,columnIndex) = ...
                formatOne(values(rowIndex,columnIndex),unit);
        end
    end
end

function [newUnit,scalePower] = scaleUnit(magnitude,currentUnit)
    prefixOrder = ["f" "p" "n" "u" "m" "" "k" "M" "G" "T"];

    [prefix,core] = splitUnitPrefix(currentUnit);
    index = find(prefixOrder == prefix,1);

    if isempty(index)
        newUnit = currentUnit;
        scalePower = 0;
        return;
    end

    scaled = abs(magnitude);
    scalePower = 0;

    if scaled == 0
        newUnit = currentUnit;
        return;
    end

    while scaled < 1 && index > 1
        scaled = scaled * 1e3;
        index = index - 1;
        scalePower = scalePower + 1;
    end

    while scaled >= 1000 && index < numel(prefixOrder)
        scaled = scaled / 1e3;
        index = index + 1;
        scalePower = scalePower - 1;
    end

    newUnit = prefixOrder(index) + core;
end

function [prefix,core] = splitUnitPrefix(unit)
    unit = string(unit);

    knownPrefixes = ["T" "G" "M" "k" "m" "u" "n" "p" "f"];

    if strlength(unit) == 0
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
