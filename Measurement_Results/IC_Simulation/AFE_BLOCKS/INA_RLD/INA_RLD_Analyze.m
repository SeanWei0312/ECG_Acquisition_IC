function INA_RLD_Analyze
% INA_RLD_ANALYZE Characterize the combined INA, RLD, and SEL testbench.
%
% Expected NGSPICE output is stored beside this file in:
%   nom.Result_txt, ff.Result_txt, ss.Result_txt, fs.Result_txt,
%   sf.Result_txt
%
% Normal PVT uses the nominal balanced 51 kOhm || 47 nF electrode model.
% Dedicated standards-derived BAL/MIS-P/MIS-N/MIS-RLD transients verify
% electrode-imbalance robustness separately.

clc;
close all;

scriptDir = fileparts(mfilename('fullpath'));
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

processes = ["NOM" "FF" "SS" "FS" "SF"];
processTokens = lower(processes);
cases = ["nom" "vl" "vh" "tl" "th" "vltl" "vlth" "vhtl" "vhth"];
caseLabels = ["NOMNOM" "VLNOM" "VHNOM" "NOMTL" "NOMTH" ...
    "VLTL" "VLTH" "VHTL" "VHTH"];
caseVdd_V = [3.3 3.0 3.6 3.3 3.3 3.0 3.0 3.6 3.6];
caseTemp_C = [27 27 27 -40 125 -40 125 -40 125];
electrodes = "BAL";
electrodeTokens = "bal";
balIndex = 1;

nCorners = numel(processes)*numel(cases);
nElectrodes = numel(electrodes);
corners = strings(1,nCorners);
cornerProcess = strings(1,nCorners);
cornerCase = strings(1,nCorners);
cornerProcessToken = strings(1,nCorners);
cornerEnvironmentToken = strings(1,nCorners);
cornerVdd_V = nan(1,nCorners);
cornerTemp_C = nan(1,nCorners);
rawValues = nan(size(rows,1),nCorners);
metrics = cell(nCorners,nElectrodes);

cornerIndex = 0;
for processIndex = 1:numel(processes)
    process = processes(processIndex);
    processToken = processTokens(processIndex);
    resultDir = fullfile(scriptDir,processToken+".Result_txt");

    for caseIndex = 1:numel(cases)
        cornerIndex = cornerIndex+1;
        caseToken = cases(caseIndex);
        corners(cornerIndex) = process+caseLabels(caseIndex);
        cornerProcess(cornerIndex) = process;
        cornerCase(cornerIndex) = caseLabels(caseIndex);
        cornerProcessToken(cornerIndex) = processToken;
        cornerEnvironmentToken(cornerIndex) = caseToken;
        cornerVdd_V(cornerIndex) = caseVdd_V(caseIndex);
        cornerTemp_C(cornerIndex) = caseTemp_C(caseIndex);

        for electrodeIndex = 1:nElectrodes
            electrodeToken = electrodeTokens(electrodeIndex);
            m = analyzeRun(resultDir,processToken,caseToken, ...
                electrodeToken,caseVdd_V(caseIndex),cfg);
            metrics{cornerIndex,electrodeIndex} = m;
            if electrodeIndex == balIndex
                rawValues(:,cornerIndex) = metricsToRaw( ...
                    m,rows,caseTemp_C(caseIndex),cfg);
            end
        end
    end
end

checkRldOffBias(metrics,corners,electrodes,cfg);

[rows,scaledValues] = adaptReportUnits(rows,rawValues);
formattedValues = formatReportValues(rows,scaledValues);
specifications = pvtSpecStrings(rows);
checkReportSpecCoverage(rows,specifications);
checkPvtSpecifications(rows,scaledValues,corners);

nominalCorner = find(corners == "NOMNOMNOM",1);
if isempty(nominalCorner)
    error('INA_RLD_Analyze:NominalCorner', ...
        'The NOM/3.3 V/27 C corner is missing.');
end
reportColumns = ["NOM" "FF" "SS" "FS" "SF" "VL" "VH" "TL" "TH"];
reportKeys = ["NOMNOMNOM" "FFNOMNOM" "SSNOMNOM" "FSNOMNOM" ...
    "SFNOMNOM" "NOMVLNOM" "NOMVHNOM" "NOMNOMTL" "NOMNOMTH"];
[found,reportIndices] = ismember(reportKeys,corners);
if ~all(found)
    error('INA_RLD_Analyze:ReportCorners', ...
        'One or more required comparison corners are missing.');
end
reportValues = formattedValues(:,reportIndices);
[rtiRows,rtiSpecifications,rtiValues,rtiResidual_uVpp] = ...
    buildStandardCmrSummary(scriptDir,metrics(:,balIndex), ...
    cornerProcessToken,cornerEnvironmentToken,corners, ...
    reportIndices,reportColumns);
rldHeader = find(rows(:,1) == "RLD" & rows(:,2) == "",1);
if isempty(rldHeader)
    error('INA_RLD_Analyze:MissingRldSection', ...
        'The comparison table is missing its RLD section.');
end
summaryRows = [rows(1:rldHeader,:); rtiRows; rows(rldHeader+1:end,:)];
summarySpecifications = [specifications(1:rldHeader); rtiSpecifications; ...
    specifications(rldHeader+1:end)];
summaryValues = [reportValues(1:rldHeader,:); rtiValues; ...
    reportValues(rldHeader+1:end,:)];
summaryTable = table(summaryRows(:,1),summaryRows(:,2), ...
    summarySpecifications, ...
    'VariableNames',{'Parameter','Unit','Spec'});
summaryTable = [summaryTable array2table(summaryValues, ...
    'VariableNames',cellstr(reportColumns))];
fprintf('\nINA + RLD COMPARISON SUMMARY\n\n');
printSummaryTable(summaryRows,summarySpecifications, ...
    reportColumns,summaryValues);
writetable(summaryTable,fullfile(reportDir,'INA_RLD_table_report.csv'));
writetable(summaryTable,fullfile(reportDir,'NOM.INA_RLD_summary.csv'));

fullPvtTable = buildFullPvtTable(rows,scaledValues,corners, ...
    cornerProcess,cornerCase,cornerVdd_V,cornerTemp_C,electrodes(balIndex));
fullPvtTable = [fullPvtTable; buildFullRtiTable(rtiResidual_uVpp, ...
    corners,cornerProcess,cornerCase,cornerVdd_V,cornerTemp_C)];
writetable(fullPvtTable,fullfile(reportDir,'INA_RLD_full_pvt_report.csv'));

worstCase = buildWorstCaseTable(rows,scaledValues,corners);
worstCase = addRtiWorstCases(worstCase,rtiResidual_uVpp,corners);
fprintf('\nINA + RLD FULL-PVT WORST CASE\n\n');
printWorstCaseTable(worstCase);
writetable(worstCase,fullfile(reportDir,'INA_RLD_worst_case_report.csv'));

plotNominalResults(scriptDir,plotDir,metrics(nominalCorner,:),cfg);
runMcSection(scriptDir,cfg);

end

function runMcSection(rootDir,cfg)
% Monte Carlo reporting is integrated here; the deterministic PVT flow is unchanged.
modes = ["MM","GL","FULL"];
files = string({fullfile(rootDir,'MM.Result_txt','mm.mc_summary.txt'), ...
                fullfile(rootDir,'GL.Result_txt','gl.mc_summary.txt'), ...
                fullfile(rootDir,'FULL.Result_txt','full.mc_summary.txt')});
missingFiles = files(~isfile(files));
if ~isempty(missingFiles)
    warning('INA_RLD_Analyze:MissingMcSummaries', ...
        'MC reporting skipped. Missing source file(s):\n%s',strjoin(missingFiles,newline));
    return
end
reportDir = fullfile(rootDir,'Reports');
if ~isfolder(reportDir), mkdir(reportDir); end
plotDir = fullfile(rootDir,'Plots');
if ~isfolder(plotDir), mkdir(plotDir); end
defs = mcDefinitions();
results = cell(numel(modes),1);
missingSuppression = false;
missingRldBandwidth = false;
for k = 1:numel(modes)
    [raw,hasSuppression,hasRldBandwidth,rldOffVinCm_V] = ...
        mcReadSummary(files(k));
    checkMcRldOffBias(rldOffVinCm_V,modes(k),cfg);
    missingSuppression = missingSuppression || ~hasSuppression;
    missingRldBandwidth = missingRldBandwidth || ~hasRldBandwidth;
    results{k} = mcSummarize(raw,defs,modes(k),cfg);
    writetable(results{k}.table,fullfile(reportDir,modes(k) + "_MC_Summary.csv"));
    mcPrintSummary(results{k});
end
runTable = table(modes',cellfun(@(r) r.requested,results), ...
    cellfun(@(r) r.valid,results),cellfun(@(r) r.failed,results), ...
    cellfun(@(r) r.overallYield,results), ...
    'VariableNames',{'Mode','RequestedRuns','ValidRuns','FailedRuns','OverallYield_pct'});
writetable(runTable,fullfile(reportDir,'MC_Run_Summary.csv'));
mcPlotHistograms(results,defs,plotDir);
mcPlotCmrr(results,defs,plotDir);
if missingSuppression
    warning('INA_RLD_Analyze:MissingMcSuppression', ...
        ['MC summary files have 13 columns, so 60 Hz and 150 Hz CM suppression are unavailable. ' ...
         'Their CSV rows are N/A and the suppression histogram is skipped.']);
else
    mcPlotSuppression(results,defs,plotDir);
end
if missingRldBandwidth
    warning('INA_RLD_Analyze:MissingMcRldBandwidth', ...
        ['At least one MC summary still exports RLD UGF instead of RLD -3 dB bandwidth. ' ...
         'The RLD bandwidth row is reported as N/A until the updated MC testbenches are rerun.']);
end
end

function defs = mcDefinitions()
defs.names = ["Total current","Total power","Output CM error", ...
    "Input-referred offset","S1 gain","S1 gain error","S2 gain","S2 gain error", ...
    "INA gain","INA gain error","INA CMRR @ 60 Hz","INA CMRR @ 150 Hz", ...
    "RLD -3 dB bandwidth","RLD phase margin", ...
    "Input CM suppression @ 60 Hz","Input CM suppression @ 150 Hz"];
defs.units = ["mA","mW","mV","uV","V/V","%","V/V","%","V/V","%", ...
    "dB","dB","Hz","deg","dB","dB"];
defs.columns = [2 3 4 6 7 NaN 8 NaN 9 10 15 16 11 12 13 14];
defs.scales = [1e3 1e3 1e3 1e6 1 1 1 1 1 1 1 1 1 1 1 1];
order = reportParameterOrder(defs.names);
defs.names = defs.names(order);
defs.units = defs.units(order);
defs.columns = defs.columns(order);
defs.scales = defs.scales(order);
defs.specs = strictSpecStrings(defs.names,defs.units);
% Gain V/V is report-only; its corresponding gain-error row is the requirement.
defs.required = strlength(defs.specs) > 0;
defs.yieldChecked = defs.required;
end

function index = parameterIndex(parameters,parameter)
index = find(parameters == parameter,1);
if isempty(index)
    error('INA_RLD_Analyze:MissingParameter', ...
        'Required parameter is not defined: %s',parameter);
end
end

function [raw,hasSuppression,hasRldBandwidth,rldOffVinCm_V] = ...
        mcReadSummary(filePath)
headerLines = readlines(filePath);
headerLine = strtrim(headerLines(1));
hasRldBandwidth = contains(headerLine,"rld_bw3db_Hz");
raw = readmatrix(filePath,'FileType','text');
raw = raw(any(isfinite(raw),2),:);
nCol = size(raw,2);
headerColumnCount = numel(split(headerLine));
if headerColumnCount ~= nCol
    error('INA_RLD_Analyze:McSchemaMismatch', ...
        ['%s declares %d columns but its data rows contain %d. ' ...
         'Delete the stale summary and rerun the MC testbench.'], ...
        filePath,headerColumnCount,nCol);
end
rldOffVinCm_V = nan(size(raw,1),1);
if nCol == 20
    rldOffVinCm_V = raw(:,17);
    raw = raw(:,1:17);
    hasSuppression = true;
    if ~hasRldBandwidth, raw(:,11) = NaN; end
    return;
end
if nCol == 18
    rldOffVinCm_V = raw(:,17);
    raw = raw(:,1:17);
    hasSuppression = true;
    if ~hasRldBandwidth, raw(:,11) = NaN; end
    return;
end
if nCol == 17
    rldOffVinCm_V = raw(:,17);
    hasSuppression = true;
    if ~hasRldBandwidth, raw(:,11) = NaN; end
    return;
end
if ~ismember(nCol,[13 15 16])
    error('INA_RLD_Analyze:McColumns', ...
        '%s must have 13, 15, 16, 17, 18, or 20 numeric columns.',filePath);
end
if nCol == 16
    hasSuppression = true;
    if ~hasRldBandwidth, raw(:,11) = NaN; end
    raw(:,17) = NaN;
    return;
end

% Normalize legacy layouts to the current 17-column schema:
% run, IDD, power, output-CM error, RLD DC error, VOS, S1, S2, INA,
% INA gain error, RLD BW, RLD PM, CM suppression 60/150 Hz, CMRR 60/150 Hz,
% and RLD-off input CM.
legacy = raw;
raw = nan(size(legacy,1),17);
raw(:,1:12) = legacy(:,[1 5 6 3 4 2 7 8 9 10 12 13]);
hasSuppression = nCol == 15;
if hasSuppression
    raw(:,13:14) = legacy(:,14:15);
end
raw(:,11) = NaN;
hasRldBandwidth = false;
end

function checkMcRldOffBias(values_V,mode,cfg)
if all(isnan(values_V)), return; end
bad = ~isfinite(values_V) | abs(values_V-cfg.nominalReference_V) > ...
    cfg.rldOffCommonModeTolerance_V;
if any(bad)
    finiteValues_V = values_V(isfinite(values_V));
    if isempty(finiteValues_V)
        valueRange = "no finite values";
    else
        valueRange = sprintf('%.6g to %.6g V', ...
            min(finiteValues_V),max(finiteValues_V));
    end
    warning('INA_RLD_Analyze:McRldOffBias', ...
        '%s RLD-off input CM check failed in %d/%d runs: %s.', ...
        mode,nnz(bad),numel(bad),valueRange);
end
end

function r = mcSummarize(raw,defs,mode,cfg)
values = nan(size(raw,1),numel(defs.names));
sourceMask = isfinite(defs.columns);
values(:,sourceMask) = raw(:,defs.columns(sourceMask)).*defs.scales(sourceMask);
s1GainIndex = parameterIndex(defs.names,"S1 gain");
s1ErrorIndex = parameterIndex(defs.names,"S1 gain error");
s2GainIndex = parameterIndex(defs.names,"S2 gain");
s2ErrorIndex = parameterIndex(defs.names,"S2 gain error");
inaGainIndex = parameterIndex(defs.names,"INA gain");
inaErrorIndex = parameterIndex(defs.names,"INA gain error");
values(:,s1ErrorIndex) = ...
    100*(values(:,s1GainIndex)/cfg.stage1GainTarget_VV-1);
values(:,s2ErrorIndex) = ...
    100*(values(:,s2GainIndex)/cfg.stage2GainTarget_VV-1);
values(:,inaErrorIndex) = ...
    100*(values(:,inaGainIndex)/cfg.diffGainTarget_VV-1);
available = any(isfinite(values),1);
requiredForValidity = defs.required & available;
validMask = all(isfinite(values(:,requiredForValidity)),2);
count = numel(defs.names);
r.mode = mode; r.values = values; r.available = available;
r.requested = size(raw,1); r.valid = nnz(validMask); r.failed = r.requested-r.valid;
r.stats = nan(count,7); r.yield = nan(count,1); r.pass = false(r.requested,count);
lowGainRows = find(validMask & values(:,inaErrorIndex) <= -90);
if ~isempty(lowGainRows)
    warning('INA_RLD_Analyze:SuspiciousMcGain', ...
        ['%s has %d valid sample(s) with INA gain error <= -90%% (MC run ID(s): %s). ' ...
         'Verify circuit collapse versus an ngspice measurement failure before trusting these samples.'], ...
        char(mode),numel(lowGainRows),char(strjoin(string(raw(lowGainRows,1)),', ')));
end
for j = 1:count
    validRows = find(validMask);
    finiteRows = validRows(isfinite(values(validMask,j)));
    v = values(finiteRows,j);
    if isempty(v), continue; end
    mu = mean(v); sigma = std(v,0);
    r.stats(j,:) = [min(v),mu-3*sigma,mu-sigma,mu,mu+sigma,mu+3*sigma,max(v)];
    if defs.yieldChecked(j)
        r.pass(finiteRows,j) = strictSpecPass(defs.names(j),v,defs.units(j));
        r.yield(j) = 100*mean(r.pass(finiteRows,j));
    end
end
requiredAvailable = defs.required & r.available;
jointPass = all(r.pass(:,requiredAvailable),2) & validMask;
if r.valid > 0, r.overallYield = 100*nnz(jointPass)/r.valid; else, r.overallYield = NaN; end
yieldText = strings(count,1);
for j = 1:count
    if ~defs.yieldChecked(j), yieldText(j) = "";
    elseif ~r.available(j), yieldText(j) = "N/A";
    else, yieldText(j) = sprintf('%.2f',r.yield(j));
    end
end
stat = r.stats;
r.table = table(defs.names',defs.units',defs.specs',stat(:,1),stat(:,2),stat(:,3), ...
    stat(:,4),stat(:,5),stat(:,6),stat(:,7),yieldText, ...
    'VariableNames',{'Parameter','Unit','Spec','Min','MeanMinus3Sigma','MeanMinusSigma', ...
    'Mean','MeanPlusSigma','MeanPlus3Sigma','Max','Yield_pct'});
end


function mcPrintSummary(r)
fprintf('\n%s MONTE CARLO SUMMARY\n',r.mode);
fprintf('Requested: %d  Valid: %d  Failed: %d  Overall yield: %s%%\n', ...
    r.requested,r.valid,r.failed,formatOne(r.overallYield,"%"));
fprintf('%-34s %-6s %-14s %10s %10s %10s %10s %10s %10s %10s %8s\n', ...
    'Parameter','Unit','Spec','Min','μ-3σ','μ-σ','Mean','μ+σ','μ+3σ','Max','Yield');
for j = 1:height(r.table)
    fprintf('%-34s %-6s %-14s %10s %10s %10s %10s %10s %10s %10s %8s\n', ...
        char(r.table.Parameter(j)),char(r.table.Unit(j)),char(r.table.Spec(j)), ...
        char(formatOne(r.table.Min(j),r.table.Unit(j))), ...
        char(formatOne(r.table.MeanMinus3Sigma(j),r.table.Unit(j))), ...
        char(formatOne(r.table.MeanMinusSigma(j),r.table.Unit(j))), ...
        char(formatOne(r.table.Mean(j),r.table.Unit(j))), ...
        char(formatOne(r.table.MeanPlusSigma(j),r.table.Unit(j))), ...
        char(formatOne(r.table.MeanPlus3Sigma(j),r.table.Unit(j))), ...
        char(formatOne(r.table.Max(j),r.table.Unit(j))), ...
        char(r.table.Yield_pct(j)));
end
end

function mcPlotHistograms(results,defs,plotDir)
offsetIndex = parameterIndex(defs.names,"Input-referred offset");
inaErrorIndex = parameterIndex(defs.names,"INA gain error");
rldBandwidthIndex = parameterIndex(defs.names,"RLD -3 dB bandwidth");
rldPmIndex = parameterIndex(defs.names,"RLD phase margin");
mcHistogram(results,offsetIndex,plotDir,'Fig_MC_01_Vos_Histogram.png', ...
    'Input-Referred Offset Distribution - MM / GL / FULL', ...
    'Input-referred offset (uV)',[-2500 2500]);
mcHistogram(results,inaErrorIndex,plotDir,'Fig_MC_02_INA_Gain_Error_Histogram.png', ...
    'INA Gain Error Distribution - MM / GL / FULL', ...
    'INA gain error (%)',[-0.5 0.5]);
mcHistogram(results,rldBandwidthIndex,plotDir,'Fig_MC_03_RLD_Bandwidth_Histogram.png', ...
    'RLD -3 dB Bandwidth Distribution - MM / GL / FULL', ...
    'RLD -3 dB bandwidth (Hz)',150);
mcHistogram(results,rldPmIndex,plotDir,'Fig_MC_04_RLD_PM_Histogram.png', ...
    'RLD Phase Margin Distribution - MM / GL / FULL', ...
    'RLD phase margin (deg)',60);
end

function mcHistogram(results,index,plotDir,fileName,titleText,xLabelText,specLines)
fig = figure;
hold on; colors = lines(numel(results)); allValues = [];
for k = 1:numel(results)
    values = results{k}.values(:,index);
    allValues = [allValues; values(isfinite(values))]; %#ok<AGROW>
end
if isempty(allValues)
    close(fig);
    return
end
[lo,hi,displayMask] = mcDisplayRange(allValues,results,index);
displayValues = allValues(displayMask);
binCount = max(12,min(40,ceil(sqrt(numel(displayValues)))));
edges = linspace(lo,hi,binCount+1);
for k = 1:numel(results)
    v = results{k}.values(:,index); v = v(isfinite(v));
    v = v(v >= lo & v <= hi);
    if ~isempty(v)
        probability_pct = 100*histcounts(v,edges,'Normalization','probability');
        stairs(edges,[probability_pct 0],'LineWidth',1.5, ...
            'Color',colors(k,:),'DisplayName',results{k}.mode);
    end
end
for x = specLines
    if x >= lo && x <= hi
        xline(x,'--','HandleVisibility','off');
    end
end
xlim([lo hi]);
ylabel('Samples (%)');
stylePlot(xLabelText,titleText);
legend('Location','northeast');
mcAddFullStatMarkers(results{3},index);
savePlot(fig,plotDir,fileName);
end

function mcPlotCmrr(results,defs,plotDir)
fig = figure;
layout = tiledlayout(2,1);
indices = [parameterIndex(defs.names,"INA CMRR @ 60 Hz") ...
    parameterIndex(defs.names,"INA CMRR @ 150 Hz")];
for p = 1:2
    nexttile(layout); hold on;
    allValues = [];
    for k = 1:numel(results)
        values = results{k}.values(:,indices(p));
        allValues = [allValues; values(isfinite(values))]; %#ok<AGROW>
    end
    if isempty(allValues), continue; end
    [lo,hi,displayMask] = mcDisplayRange(allValues,results,indices(p));
    displayValues = allValues(displayMask);
    edges = linspace(lo,hi,max(12,min(40,ceil(sqrt(numel(displayValues)))))+1);
    colors = lines(numel(results));
    for k = 1:numel(results)
        values = results{k}.values(:,indices(p));
        values = values(isfinite(values) & values >= lo & values <= hi);
        if isempty(values), continue; end
        probabilityPct = 100*histcounts(values,edges,'Normalization','probability');
        stairs(edges,[probabilityPct 0],'LineWidth',1.5, ...
            'Color',colors(k,:),'DisplayName',results{k}.mode);
    end
    xline(80,'--','HandleVisibility','off');
    xlim([lo hi]);
    ylabel('Samples (%)');
    stylePlot(defs.names(indices(p))+" (dB)", ...
        defs.names(indices(p))+" Distribution - MM / GL / FULL");
    legend('Location','northeast');
    mcAddFullStatMarkers(results{3},indices(p));
end
savePlot(fig,plotDir,'Fig_MC_05_INA_CMRR_Histogram.png');
end

function mcPlotSuppression(results,defs,plotDir)
fig = figure;
layout = tiledlayout(2,1);
indices = [parameterIndex(defs.names,"Input CM suppression @ 60 Hz") ...
    parameterIndex(defs.names,"Input CM suppression @ 150 Hz")];
limits = [35 25];
colors = lines(numel(results));
for p = 1:2
    nexttile(layout); hold on;
    allValues = [];
    for k = 1:numel(results)
        values = results{k}.values(:,indices(p));
        allValues = [allValues; values(isfinite(values))]; %#ok<AGROW>
    end
    if isempty(allValues), continue; end
    [lo,hi,displayMask] = mcDisplayRange(allValues,results,indices(p));
    displayValues = allValues(displayMask);
    edges = linspace(lo,hi,max(12,min(40,ceil(sqrt(numel(displayValues)))))+1);
    for k = 1:numel(results)
        v = results{k}.values(:,indices(p)); v = v(isfinite(v));
        v = v(v >= lo & v <= hi);
        probability_pct = 100*histcounts(v,edges,'Normalization','probability');
        stairs(edges,[probability_pct 0],'LineWidth',1.5, ...
            'Color',colors(k,:),'DisplayName',results{k}.mode);
    end
    if limits(p) >= lo && limits(p) <= hi
        xline(limits(p),'--','HandleVisibility','off');
    end
    xlim([lo hi]);
    ylabel('Samples (%)');
    stylePlot(defs.names(indices(p)) + " (dB)", ...
        defs.names(indices(p)) + " Distribution - MM / GL / FULL");
    legend('Location','northeast');
    mcAddFullStatMarkers(results{3},indices(p));
end
savePlot(fig,plotDir,'Fig_MC_06_Input_CM_Suppression_Histogram.png');
end

function [lo,hi,displayMask] = mcDisplayRange(values,results,index)
% Center every MC x-axis on the FULL mean.
fullIndex = find(cellfun(@(r) strcmpi(string(r.mode),"FULL"),results),1);
if isempty(fullIndex)
    fullIndex = numel(results);
end
center = results{fullIndex}.stats(index,4);
if ~isfinite(center)
    fullValues = results{fullIndex}.values(:,index);
    center = mean(fullValues(isfinite(fullValues)),'omitnan');
end
if ~isfinite(center)
    center = mean(values,'omitnan');
end

limits = nan(numel(results),2);
for k = 1:numel(results)
    mu = results{k}.stats(index,4);
    sigma = abs(results{k}.stats(index,5)-mu);
    if isfinite(mu) && isfinite(sigma)
        limits(k,:) = [mu-4*sigma mu+4*sigma];
    end
end
limits = limits(isfinite(limits));
if isempty(limits)
    halfRange = max(abs(values-center),[],'omitnan');
else
    halfRange = max(abs(limits-center),[],'omitnan');
end
if ~isfinite(halfRange) || halfRange <= 0
    halfRange = max(abs(center)*0.05,1);
end
halfRange = 1.05*halfRange;
lo = center-halfRange;
hi = center+halfRange;
displayMask = values >= lo & values <= hi;
if ~any(displayMask)
    halfRange = max(abs(values-center),[],'omitnan');
    halfRange = max(1.05*halfRange,max(abs(center)*0.05,1));
    lo = center-halfRange;
    hi = center+halfRange;
    displayMask = true(size(values));
end
end

function mcAddFullStatMarkers(fullResult,index)
markers = fullResult.stats(index,2:6);
labels = ["-3σ","-σ","μ","+σ","+3σ"];
for markerIndex = 1:numel(markers)
    marker = markers(markerIndex);
    if isfinite(marker)
        addCursorLine(marker,0,labels(markerIndex));
    end
end
end

function cfg = analysisConfig
cfg.stage1GainTarget_VV = 60;
cfg.stage2GainTarget_VV = 4;
cfg.diffGainTarget_VV = ...
    cfg.stage1GainTarget_VV*cfg.stage2GainTarget_VV;
cfg.ecgFrequency_Hz = 10;
cfg.thdFrequency_Hz = 60;
cfg.vtcCompression_pct = 1;
cfg.vtcCenterFitHalfWidth_V = 0.5e-3;
cfg.noiseBand_Hz = [0.05 150];
cfg.cmFrequencies_Hz = [60 150];
cfg.vddTolerance_V = 5e-3;
cfg.nominalReference_V = 1.65;
cfg.rldOffCommonModeTolerance_V = 50e-3;
end

function checkRldOffBias(metrics,corners,electrodes,cfg)
error_V = nan(size(metrics));
for cornerIndex = 1:size(metrics,1)
    for electrodeIndex = 1:size(metrics,2)
        m = metrics{cornerIndex,electrodeIndex};
        error_V(cornerIndex,electrodeIndex) = ...
            abs(m.rldOffVinCm_V-m.vref_V);
    end
end

bad = ~isfinite(error_V) | error_V > cfg.rldOffCommonModeTolerance_V;
if ~any(bad,'all'), return; end

finiteError_V = error_V;
finiteError_V(~isfinite(finiteError_V)) = -Inf;
[worstError_V,worstIndex] = max(finiteError_V(:));
if ~isfinite(worstError_V)
    worstError_V = NaN;
    worstIndex = find(bad,1);
end
[cornerIndex,electrodeIndex] = ind2sub(size(error_V),worstIndex);
warning('INA_RLD_Analyze:RldOffBias', ...
    ['RLD-off input CM check failed in %d/%d cases. Worst: %s, ' ...
     '%s, error %.6g V.'], ...
    nnz(bad),numel(bad),corners(cornerIndex), ...
    electrodes(electrodeIndex),worstError_V);
end

function rows = reportRows
rows = [
    "Set conditions",                              ""
    "AVDD",                                        "V"
    "Temperature",                                 "C"
    "S1 target gain",                              "V/V"
    "S2 target gain",                              "V/V"
    "INA target gain",                             "V/V"
    "",                                            ""
    "Operating point",                             ""
    "Total current",                               "A"
    "Total power",                                 "W"
    "Output CM error",                              "V"
    "Input-referred offset",                        "V"
    "",                                            ""
    "INA",                                         ""
    "S1 gain",                                    "V/V"
    "S1 gain dB",                                 "dB"
    "S1 gain error",                               "%"
    "S1 -3 dB bandwidth",                          "kHz"
    "S2 gain",                                    "V/V"
    "S2 gain dB",                                 "dB"
    "S2 gain error",                               "%"
    "S2 -3 dB bandwidth",                          "Hz"
    "INA gain",                                   "V/V"
    "INA gain dB",                                "dB"
    "INA gain error",                              "%"
    "Gain flatness 0.05-150 Hz",                   "dB"
    "INA -3 dB bandwidth",                         "kHz"
    "Input range low",                              "V"
    "Input range high",                             "V"
    "Output range low",                             "V"
    "Output range high",                            "V"
    "INA CMRR @ 60 Hz",                            "dB"
    "INA CMRR @ 150 Hz",                           "dB"
    "INA PSRR+ @ 60 Hz",                           "dB"
    "INA PSRR+ @ 150 Hz",                          "dB"
    "INA PSRR- @ 60 Hz",                           "dB"
    "INA PSRR- @ 150 Hz",                          "dB"
    "Input-referred noise 0.05-150 Hz",             "Vrms"
    "THD @ 60 Hz, 5 mVpp",                         "%"
    "",                                            ""
    "RLD",                                         ""
    "RLD gain",                                    "V/V"
    "RLD -3 dB bandwidth",                         "Hz"
    "RLD phase margin",                            "deg"
    "Input CM suppression @ 60 Hz",                "dB"
    "Input CM suppression @ 150 Hz",               "dB"
];
end

function order = reportParameterOrder(parameters)
% Keep every derived report in the canonical PVT-table parameter sequence.
rows = reportRows();
[found,pvtIndex] = ismember(parameters,rows(:,1));
if ~all(found)
    error('INA_RLD_Analyze:UnknownReportParameter', ...
        'A derived report contains an unknown parameter: %s', ...
        strjoin(parameters(~found),', '));
end
[~,order] = sort(pvtIndex);
end

function specifications = pvtSpecStrings(rows)
specifications = strictSpecStrings(rows(:,1),rows(:,2));
end

function checkReportSpecCoverage(rows,specifications)
% Set conditions and raw gain rows remain descriptive; every other
% performance row requires a formal specification.
descriptiveParameters = ["" "Set conditions" "AVDD" "Temperature" ...
    "S1 target gain" "S2 target gain" "INA target gain" ...
    "Operating point" "INA" "RLD" ...
    "S1 gain" "S1 gain dB" "S2 gain" "S2 gain dB" "INA gain" "INA gain dB" ...
    "RLD gain"];
missingSpecification = strlength(rows(:,1)) > 0 & ...
    ~ismember(rows(:,1),descriptiveParameters) & strlength(specifications) == 0;
if any(missingSpecification)
    error('INA_RLD_Analyze:MissingReportSpec', ...
        'Formal report row(s) missing a specification: %s', ...
        strjoin(rows(missingSpecification,1),', '));
end
end

function specifications = strictSpecStrings(parameters,units)
specifications = strings(size(parameters));
for parameterIndex = 1:numel(parameters)
    specifications(parameterIndex) = strictSpecText( ...
        parameters(parameterIndex),units(parameterIndex));
end
end

function specification = strictSpecText(parameter,unit)
switch string(parameter)
    case "Total current", specification = "≤"+specNumber(6.2e-3,unit);
    case "Total power", specification = "≤"+specNumber(22e-3,unit);
    case "Output CM error", specification = "±"+specNumber(40e-3,unit);
    case "Input-referred offset", specification = "±"+specNumber(2.5e-3,unit);
    case "S1 gain error", specification = "±0.5";
    case "S1 -3 dB bandwidth", specification = "≥"+specNumber(150e3,unit);
    case "S2 gain error", specification = "±0.25";
    case "S2 -3 dB bandwidth", specification = "≥"+specNumber(1.5e6,unit);
    case "INA gain error", specification = "±0.5";
    case "Gain flatness 0.05-150 Hz", specification = "≤0.1";
    case "INA -3 dB bandwidth", specification = "≥"+specNumber(150e3,unit);
    case "Input range low"
        specification = "≤-"+specNumber(5e-3,unit);
    case "Input range high"
        specification = "≥"+specNumber(5e-3,unit);
    case "Output range low"
        specification = "≤-"+specNumber(1.2,unit);
    case "Output range high"
        specification = "≥"+specNumber(1.2,unit);
    case {"INA CMRR @ 60 Hz","INA CMRR @ 150 Hz"}, specification = "≥80";
    case {"INA PSRR+ @ 60 Hz","INA PSRR+ @ 150 Hz", ...
            "INA PSRR- @ 60 Hz","INA PSRR- @ 150 Hz"}, specification = "≥80";
    case "THD @ 60 Hz, 5 mVpp", specification = "≤0.05";
    case "RLD -3 dB bandwidth"
        specification = "≥"+specNumber(150,unit);
    case "RLD phase margin", specification = "≥60";
    case {"RTI residual - BAL","RTI residual - MIS-P", ...
            "RTI residual - MIS-N","RTI residual - MIS-RLD"}
        specification = "≤1000";
    case "Input CM suppression @ 60 Hz", specification = "≥35";
    case "Input CM suppression @ 150 Hz", specification = "≥25";
    case "Input-referred noise 0.05-150 Hz", specification = "≤4";
    otherwise, specification = "";
end
end

function pass = strictSpecPass(parameter,value,unit)
baseValue = value*unitScaleToBase(unit);
switch string(parameter)
    case "Total current", pass = baseValue <= 6.2e-3;
    case "Total power", pass = baseValue <= 22e-3;
    case "Output CM error", pass = abs(baseValue) <= 40e-3;
    case "Input-referred offset", pass = abs(baseValue) <= 2.5e-3;
    case "S1 gain error", pass = baseValue >= -0.5 & baseValue <= 0.5;
    case "S1 -3 dB bandwidth", pass = baseValue >= 150e3;
    case "S2 gain error", pass = baseValue >= -0.25 & baseValue <= 0.25;
    case "S2 -3 dB bandwidth", pass = baseValue >= 1.5e6;
    case "INA gain error", pass = baseValue >= -0.5 & baseValue <= 0.5;
    case "Gain flatness 0.05-150 Hz", pass = baseValue <= 0.1;
    case "INA -3 dB bandwidth", pass = baseValue >= 150e3;
    case "Input range low"
        pass = baseValue <= -5e-3;
    case "Input range high"
        pass = baseValue >= 5e-3;
    case "Output range low"
        pass = baseValue <= -1.2;
    case "Output range high"
        pass = baseValue >= 1.2;
    case {"INA CMRR @ 60 Hz","INA CMRR @ 150 Hz"}, pass = baseValue >= 80;
    case {"INA PSRR+ @ 60 Hz","INA PSRR+ @ 150 Hz", ...
            "INA PSRR- @ 60 Hz","INA PSRR- @ 150 Hz"}, pass = baseValue >= 80;
    case "THD @ 60 Hz, 5 mVpp", pass = baseValue <= 0.05;
    case "RLD -3 dB bandwidth", pass = baseValue >= 150;
    case "RLD phase margin", pass = baseValue >= 60;
    case {"RTI residual - BAL","RTI residual - MIS-P", ...
            "RTI residual - MIS-N","RTI residual - MIS-RLD"}
        pass = baseValue <= 1000e-6;
    case "Input CM suppression @ 60 Hz", pass = baseValue >= 35;
    case "Input CM suppression @ 150 Hz", pass = baseValue >= 25;
    case "Input-referred noise 0.05-150 Hz", pass = baseValue <= 4e-6;
    otherwise, pass = true(size(value));
end
end

function checkPvtSpecifications(rows,values,corners)
checkedRows = false(size(rows,1),1);
passMatrix = true(size(values));
for rowIndex = 1:size(rows,1)
    parameter = rows(rowIndex,1);
    value = values(rowIndex,:);
    if strlength(strictSpecText(parameter,rows(rowIndex,2))) == 0, continue; end
    pass = strictSpecPass(parameter,value,rows(rowIndex,2));
    checkedRows(rowIndex) = true;
    passMatrix(rowIndex,:) = isfinite(value) & pass;
end
cornerPass = all(passMatrix(checkedRows,:),1);
if all(cornerPass)
    fprintf('\nINA + RLD FULL-PVT VERIFICATION: PASS (%d/%d corners)\n', ...
        nnz(cornerPass),numel(corners));
else
    failedCorners = corners(~cornerPass);
    warning('INA_RLD_Analyze:PvtSpecFailure', ...
        'INA + RLD FULL-PVT VERIFICATION: FAIL (%d/%d corners): %s', ...
        nnz(cornerPass),numel(corners),strjoin(failedCorners,', '));
end
end

function m = analyzeRun(resultDir,process,caseName,electrode, ...
        expectedVdd_V,cfg)
files = runFiles(resultDir,process,caseName,electrode);
opData = readNumericFile(files.op,28);
m = analyzeOperatingPoint(opData);
vosData = readNumericFile(files.vos,1);
m.inputOffset_V = vosData(1);
if abs(m.vdd_V-expectedVdd_V) > cfg.vddTolerance_V
    error('INA_RLD_Analyze:SupplyMismatch', ...
        '%s reports AVDD = %.6g V; expected %.3f V.', ...
        files.op,m.vdd_V,expectedVdd_V);
end
diffData = readNumericFile(files.diff,11);
cmOffData = readNumericFile(files.cmOff,13);
cmrrData = readNumericFile(files.cmrr,5);
m.diff = analyzeDifferential(diffData,cfg);
m.cm = analyzeCommonMode(cmOffData,readNumericFile(files.cmOn,13),cfg);
m.rejection = analyzeRejection(diffData,cmrrData, ...
    readNumericFile(files.psrrp,7),readNumericFile(files.psrrn,7),cfg);
m.loop = analyzeRldLoop(readNumericFile(files.loop,11));
m.noise = analyzeNoise(readNumericFile(files.noise,3),cfg);
m.vtc = analyzeVtc(readNumericFile(files.vtc,6),cfg);
m.thd = analyzeThd(readNumericFile(files.thd,4),cfg.thdFrequency_Hz);
rldOffOpData = readNumericFile(files.rldOffOp,5);
m.rldOffVinCm_V = median(rldOffOpData(:,2),'omitnan');
end

function files = runFiles(resultDir,process,caseName,electrode)
stem = sprintf('%s.%%s_%s_%s.txt',process,caseName,electrode);
files.op = fullfile(resultDir,sprintf(stem,'op'));
files.vos = fullfile(resultDir,sprintf(stem,'vos'));
files.diff = fullfile(resultDir,sprintf(stem,'diff_ac'));
files.cmOff = fullfile(resultDir,sprintf(stem,'cm_off_ac'));
files.cmOn = fullfile(resultDir,sprintf(stem,'cm_on_ac'));
files.cmrr = fullfile(resultDir,sprintf(stem,'ina_cmrr_ac'));
files.psrrp = fullfile(resultDir,sprintf(stem,'psrrp_ac'));
files.psrrn = fullfile(resultDir,sprintf(stem,'psrrn_ac'));
files.loop = fullfile(resultDir,sprintf(stem,'rld_loop_ac'));
files.noise = fullfile(resultDir,sprintf(stem,'noise'));
files.vtc = fullfile(resultDir,sprintf(stem,'vtc'));
files.thd = fullfile(resultDir,sprintf(stem,'thd_60'));
files.rldOffOp = fullfile(resultDir,sprintf(stem,'rld_off_op'));
end

function filePath = selTransientFile(resultDir,process,caseName)
filePath = fullfile(resultDir,sprintf('%s.sel_tran_%s.txt', ...
    process,caseName));
end

function m = analyzeOperatingPoint(data)
m.vdd_V = median(data(:,2),'omitnan');
vref_V = median(data(:,3),'omitnan');
m.vref_V = vref_V;
m.outCmError_V = median(data(:,17),'omitnan')-vref_V;
m.totalCurrent_A = abs(median(data(:,22),'omitnan'));
m.totalPower_W = abs(median(data(:,23),'omitnan'));
end

function result = analyzeDifferential(data,cfg)
validateFrequency(data(:,1),'differential AC');
f = data(:,1);
vin = complex(data(:,2),data(:,3));
seDiff = complex(data(:,4),data(:,5));
inaOutDiff = complex(data(:,6),data(:,7));
stage1 = safeDivide(seDiff,vin);
stage2 = safeDivide(inaOutDiff,seDiff);
total = safeDivide(inaOutDiff,vin);
stage1Gain_dB = magnitudeDb(stage1);
stage2Gain_dB = magnitudeDb(stage2);
totalGain_dB = magnitudeDb(total);
stage1Gain10_VV = interpLogFrequency(f,abs(stage1),10);
stage2Gain10_VV = interpLogFrequency(f,abs(stage2),10);
result.stage1Gain10_VV = stage1Gain10_VV;
result.stage1GainError_pct = ...
    100*(stage1Gain10_VV/cfg.stage1GainTarget_VV-1);
result.stage2Gain10_VV = stage2Gain10_VV;
result.stage2GainError_pct = ...
    100*(stage2Gain10_VV/cfg.stage2GainTarget_VV-1);
result.stage1Bandwidth3dB_Hz = upperCrossing(f,stage1Gain_dB, ...
    20*log10(stage1Gain10_VV)-3,10);
result.stage2Bandwidth3dB_Hz = upperCrossing(f,stage2Gain_dB, ...
    20*log10(stage2Gain10_VV)-3,10);
result.gain10_dB = interpLogFrequency(f,totalGain_dB,10);
result.gain10_VV = interpLogFrequency(f,abs(total),10);
result.gain60_VV = interpLogFrequency(f,abs(total),60);
result.gainError_pct = 100*(result.gain10_VV/cfg.diffGainTarget_VV-1);
bandFrequency_Hz = [cfg.noiseBand_Hz(1); ...
    f(f > cfg.noiseBand_Hz(1) & f < cfg.noiseBand_Hz(2)); ...
    cfg.noiseBand_Hz(2)];
bandGain_dB = interpLogFrequency(f,totalGain_dB,bandFrequency_Hz);
result.flatness_dB = max(bandGain_dB,[],'omitnan')- ...
    min(bandGain_dB,[],'omitnan');
result.bandwidth3dB_Hz = upperCrossing(f,totalGain_dB, ...
    result.gain10_dB-3,10);
end

function result = analyzeCommonMode(offData,onData,cfg)
[fOff,off] = commonModeTransfers(offData);
[fOn,on] = commonModeTransfers(onData);
targets = cfg.cmFrequencies_Hz;
offInput_dB = interpLogFrequency(fOff,magnitudeDb(off.inputCm),targets);
onInput_dB = interpLogFrequency(fOn,magnitudeDb(on.inputCm),targets);
result.inputSuppression_dB = offInput_dB-onInput_dB;
end

function result = analyzeRejection(diffData,cmrrData,psrrpData,psrrnData,cfg)
% Keep PVT rejection definitions on the INA output, matching MC.
validateFrequency(diffData(:,1),'differential AC');
fDiff = diffData(:,1);
ad = safeDivide(complex(diffData(:,6),diffData(:,7)), ...
    complex(diffData(:,2),diffData(:,3)));
validateFrequency(cmrrData(:,1),'CMRR AC');
fCm = cmrrData(:,1);
acm = safeDivide(complex(cmrrData(:,4),cmrrData(:,5)), ...
    complex(cmrrData(:,2),cmrrData(:,3)));

fP = psrrpData(:,1);
fN = psrrnData(:,1);
validateFrequency(fP,'PSRR+ AC');
validateFrequency(fN,'PSRR- AC');
apsrrP = safeDivide(complex(psrrpData(:,4),psrrpData(:,5)), ...
    complex(psrrpData(:,2),psrrpData(:,3)));
apsrrN = safeDivide(complex(psrrnData(:,4),psrrnData(:,5)), ...
    complex(psrrnData(:,2),psrrnData(:,3)));

targets = cfg.cmFrequencies_Hz;
ad_dB = interpLogFrequency(fDiff,magnitudeDb(ad),targets);
result.cmrr_dB = ad_dB-interpLogFrequency(fCm,magnitudeDb(acm),targets);
result.psrrP_dB = ad_dB-interpLogFrequency(fP,magnitudeDb(apsrrP),targets);
result.psrrN_dB = ad_dB-interpLogFrequency(fN,magnitudeDb(apsrrN),targets);
end

function [f,result] = commonModeTransfers(data)
validateFrequency(data(:,1),'common-mode AC');
f = data(:,1);
source = complex(data(:,2),data(:,3));
result.inputCm = safeDivide(complex(data(:,6),data(:,7)),source);
end

function result = analyzeRldLoop(data)
[f,phase_deg,gain_dB] = loopTransfer(data);
result.lowFrequencyGain_dB = interpLogFrequency(f,gain_dB,0.01);
result.lowFrequencyGain_VV = 10^(result.lowFrequencyGain_dB/20);
result.bandwidth3dB_Hz = downwardCrossing( ...
    f,gain_dB,result.lowFrequencyGain_dB-3);
result.crossover_Hz = downwardCrossing(f,gain_dB,0);
phaseAtCrossing_deg = interpLogFrequency(f,phase_deg,result.crossover_Hz);
result.phaseMargin_deg = 180+phaseAtCrossing_deg;
end

function [f,phase_deg,gain_dB] = loopTransfer(data)
validateFrequency(data(:,1),'RLD loop AC');
f = data(:,1);
loopIn = complex(data(:,2),data(:,3));
loopOut = complex(data(:,4),data(:,5));
loopGain = -safeDivide(loopOut,loopIn);
gain_dB = magnitudeDb(loopGain);
phase_deg = unwrap(angle(loopGain))*180/pi;
finitePhase = find(isfinite(phase_deg),1);
if ~isempty(finitePhase)
    phase_deg = phase_deg-360*round(phase_deg(finitePhase)/360);
end
end

function result = analyzeNoise(data,cfg)
validateFrequency(data(:,1),'noise');
f = data(:,1);
result.inputRms_V = integrateDensity(f,abs(data(:,3)),cfg.noiseBand_Hz);
end

function result = analyzeVtc(data,cfg)
vinDiff_V = data(:,2);
inaOutDiff_V = data(:,6);
if any(diff(vinDiff_V) <= 0)
    error('INA_RLD_Analyze:VtcInput', ...
        'INA VTC input must be strictly increasing.');
end

[~,zeroIndex] = min(abs(inaOutDiff_V));
fitRows = abs(vinDiff_V-vinDiff_V(zeroIndex)) <= ...
    cfg.vtcCenterFitHalfWidth_V;
if nnz(fitRows) < 3
    error('INA_RLD_Analyze:VtcFit', ...
        'INA VTC central gain fit requires at least three samples.');
end
centralFit = polyfit(vinDiff_V(fitRows),inaOutDiff_V(fitRows),1);
centralGain_VV = centralFit(1);
if ~isfinite(centralGain_VV) || abs(centralGain_VV) <= eps
    error('INA_RLD_Analyze:VtcGain', ...
        'INA VTC central DC gain must be finite and nonzero.');
end

localGain_VV = gradient(inaOutDiff_V)./gradient(vinDiff_V);
gainError_pct = 100*abs(localGain_VV/centralGain_VV-1);

negativeIndex = zeroIndex;
while negativeIndex > 1 && ...
        isfinite(gainError_pct(negativeIndex-1)) && ...
        gainError_pct(negativeIndex-1) <= cfg.vtcCompression_pct
    negativeIndex = negativeIndex-1;
end
positiveIndex = zeroIndex;
while positiveIndex < numel(vinDiff_V) && ...
        isfinite(gainError_pct(positiveIndex+1)) && ...
        gainError_pct(positiveIndex+1) <= cfg.vtcCompression_pct
    positiveIndex = positiveIndex+1;
end

result.centralGain_VV = centralGain_VV;
result.inputNegative_V = vinDiff_V(negativeIndex);
result.inputPositive_V = vinDiff_V(positiveIndex);
result.outputNegative_V = inaOutDiff_V(negativeIndex);
result.outputPositive_V = inaOutDiff_V(positiveIndex);
end

function result = analyzeThd(data,fundamental_Hz)
t_s = data(:,1);
inaOutDiff_V = data(:,3);
if any(diff(t_s) <= 0)
    error('INA_RLD_Analyze:ThdTime', ...
        'THD transient time must be strictly increasing.');
end
duration_s = t_s(end)-t_s(1);
cycleCount = duration_s*fundamental_Hz;
if abs(cycleCount-round(cycleCount)) > 1e-3
    error('INA_RLD_Analyze:ThdCycles', ...
        'THD transient must contain an integer number of cycles; found %.6g.', ...
        cycleCount);
end
inaOutDiff_V = inaOutDiff_V-mean(inaOutDiff_V,'omitnan');
amplitude_Vpk = zeros(1,5);
for harmonic = 1:5
    angle = 2*pi*harmonic*fundamental_Hz*t_s;
    cosineCoefficient = 2/duration_s*trapz(t_s,inaOutDiff_V.*cos(angle));
    sineCoefficient = 2/duration_s*trapz(t_s,inaOutDiff_V.*sin(angle));
    amplitude_Vpk(harmonic) = hypot(cosineCoefficient,sineCoefficient);
end
if ~isfinite(amplitude_Vpk(1)) || amplitude_Vpk(1) <= 0
    error('INA_RLD_Analyze:ThdFundamental', ...
        'THD fundamental amplitude is not finite and positive.');
end
result.amplitude_Vpk = amplitude_Vpk;
result.ratio = sqrt(sum(amplitude_Vpk(2:5).^2))/amplitude_Vpk(1);
result.percent = 100*result.ratio;
result.dB = 20*log10(result.ratio);
end

function values = metricsToRaw(m,rows,temperature_C,cfg)
values = nan(size(rows,1),1);
for rowIndex = 1:size(rows,1)
    switch rows(rowIndex,1)
        case "AVDD", values(rowIndex) = m.vdd_V;
        case "Temperature", values(rowIndex) = temperature_C;
        case "S1 target gain"
            values(rowIndex) = cfg.stage1GainTarget_VV;
        case "S2 target gain"
            values(rowIndex) = cfg.stage2GainTarget_VV;
        case "INA target gain"
            values(rowIndex) = cfg.diffGainTarget_VV;
        case "Total current", values(rowIndex) = m.totalCurrent_A;
        case "Total power", values(rowIndex) = m.totalPower_W;
        case "Output CM error", values(rowIndex) = m.outCmError_V;
        case "Input-referred offset", values(rowIndex) = m.inputOffset_V;
        case "S1 gain", values(rowIndex) = m.diff.stage1Gain10_VV;
        case "S1 gain dB", values(rowIndex) = 20*log10(m.diff.stage1Gain10_VV);
        case "S1 gain error", values(rowIndex) = m.diff.stage1GainError_pct;
        case "S1 -3 dB bandwidth", values(rowIndex) = m.diff.stage1Bandwidth3dB_Hz/1e3;
        case "S2 gain", values(rowIndex) = m.diff.stage2Gain10_VV;
        case "S2 gain dB", values(rowIndex) = 20*log10(m.diff.stage2Gain10_VV);
        case "S2 gain error", values(rowIndex) = m.diff.stage2GainError_pct;
        case "S2 -3 dB bandwidth", values(rowIndex) = m.diff.stage2Bandwidth3dB_Hz;
        case "INA gain", values(rowIndex) = m.diff.gain10_VV;
        case "INA gain dB", values(rowIndex) = m.diff.gain10_dB;
        case "INA gain error", values(rowIndex) = m.diff.gainError_pct;
        case "Gain flatness 0.05-150 Hz", values(rowIndex) = m.diff.flatness_dB;
        case "INA -3 dB bandwidth", values(rowIndex) = m.diff.bandwidth3dB_Hz/1e3;
        case "Input range low"
            values(rowIndex) = m.vtc.inputNegative_V;
        case "Input range high"
            values(rowIndex) = m.vtc.inputPositive_V;
        case "Output range low"
            values(rowIndex) = m.vtc.outputNegative_V;
        case "Output range high"
            values(rowIndex) = m.vtc.outputPositive_V;
        case "INA CMRR @ 60 Hz", values(rowIndex) = m.rejection.cmrr_dB(1);
        case "INA CMRR @ 150 Hz", values(rowIndex) = m.rejection.cmrr_dB(2);
        case "INA PSRR+ @ 60 Hz", values(rowIndex) = m.rejection.psrrP_dB(1);
        case "INA PSRR+ @ 150 Hz", values(rowIndex) = m.rejection.psrrP_dB(2);
        case "INA PSRR- @ 60 Hz", values(rowIndex) = m.rejection.psrrN_dB(1);
        case "INA PSRR- @ 150 Hz", values(rowIndex) = m.rejection.psrrN_dB(2);
        case "RLD gain", values(rowIndex) = m.loop.lowFrequencyGain_VV;
        case "RLD -3 dB bandwidth", values(rowIndex) = m.loop.bandwidth3dB_Hz;
        case "RLD phase margin", values(rowIndex) = m.loop.phaseMargin_deg;
        case "Input CM suppression @ 60 Hz", values(rowIndex) = m.cm.inputSuppression_dB(1);
        case "Input CM suppression @ 150 Hz", values(rowIndex) = m.cm.inputSuppression_dB(2);
        case "Input-referred noise 0.05-150 Hz", values(rowIndex) = m.noise.inputRms_V;
        case "THD @ 60 Hz, 5 mVpp", values(rowIndex) = m.thd.percent;
    end
end
end

function data = readNumericFile(file,expectedColumns)
if ~isfile(file)
    error('INA_RLD_Analyze:MissingFile','Missing required file: %s',file);
end
data = readmatrix(file,'FileType','text');
data = data(any(isfinite(data),2),:);
data = data(:,any(isfinite(data),1));
if isempty(data)
    error('INA_RLD_Analyze:EmptyFile','No numeric data found in %s.',file);
end
if size(data,2) == expectedColumns+1 && columnsMatch(data(:,1),data(:,2))
    data = data(:,2:end);
end
if size(data,2) ~= expectedColumns
    error('INA_RLD_Analyze:ColumnCount', ...
        '%s must contain %d columns; found %d.', ...
        file,expectedColumns,size(data,2));
end
if any(~isfinite(data),'all')
    error('INA_RLD_Analyze:NonfiniteData', ...
        '%s contains nonfinite numeric samples.',file);
end
end

function tf = columnsMatch(a,b)
scale = max([ones(size(a)) abs(a) abs(b)],[],2);
tf = all(abs(a-b) <= 100*eps(scale));
end

function validateFrequency(f,label)
if any(~isfinite(f)) || any(f <= 0) || any(diff(f) <= 0)
    error('INA_RLD_Analyze:FrequencyAxis', ...
        '%s frequency must be finite, positive, and strictly increasing.',label);
end
end

function ratio = safeDivide(numerator,denominator)
ratio = nan(size(numerator));
valid = isfinite(numerator) & isfinite(denominator) & abs(denominator) > 0;
ratio(valid) = numerator(valid)./denominator(valid);
end

function gain_dB = magnitudeDb(value)
gain_dB = 20*log10(max(abs(value),realmin));
gain_dB(~isfinite(value)) = NaN;
end

function value = interpLogFrequency(f,y,targetFrequency)
value = nan(size(targetFrequency));
valid = isfinite(f) & f > 0 & isfinite(y);
f = f(valid);
y = y(valid);
if numel(f) < 2
    return;
end
[f,uniqueRows] = unique(f,'stable');
y = y(uniqueRows);
inside = targetFrequency >= f(1) & targetFrequency <= f(end) & ...
    isfinite(targetFrequency) & targetFrequency > 0;
value(inside) = interp1(log10(f),y,log10(targetFrequency(inside)), ...
    'linear',NaN);
end

function crossing_Hz = downwardCrossing(f,y,target)
crossing_Hz = NaN;
valid = isfinite(f) & f > 0 & isfinite(y);
f = f(valid);
y = y(valid);
if numel(f) < 2
    return;
end
index = find(y(1:end-1) >= target & y(2:end) <= target & ...
    y(1:end-1) ~= y(2:end),1,'first');
if isempty(index)
    return;
end
crossing_Hz = 10^interp1(y(index:index+1), ...
    log10(f(index:index+1)),target,'linear',NaN);
end

function crossing_Hz = upperCrossing(f,y,target,startFrequency_Hz)
rows = f >= startFrequency_Hz;
crossing_Hz = downwardCrossing(f(rows),y(rows),target);
end

function rmsValue = integrateDensity(f,density,band_Hz)
valid = isfinite(f) & f > 0 & isfinite(density) & density >= 0;
f = f(valid);
density = density(valid);
[f,uniqueRows] = unique(f,'stable');
density = density(uniqueRows);
if numel(f) < 2 || f(1) > band_Hz(1) || f(end) < band_Hz(2)
    rmsValue = NaN;
    return;
end
inside = f > band_Hz(1) & f < band_Hz(2);
bandFrequency = [band_Hz(1); f(inside); band_Hz(2)];
bandDensity = interp1(log(f),density,log(bandFrequency),'linear');
rmsValue = sqrt(trapz(bandFrequency,bandDensity.^2));
end

function result = buildFullPvtTable(rows,values,corners,processes,cases, ...
        vdd_V,temp_C,electrode)
metricRows = find(rows(:,2) ~= "");
nRecords = numel(metricRows)*numel(corners);
cornerColumn = strings(nRecords,1);
processColumn = strings(nRecords,1);
caseColumn = strings(nRecords,1);
vddColumn = nan(nRecords,1);
tempColumn = nan(nRecords,1);
electrodeColumn = strings(nRecords,1);
parameterColumn = strings(nRecords,1);
unitColumn = strings(nRecords,1);
valueColumn = strings(nRecords,1);
record = 0;
for cornerIndex = 1:numel(corners)
    range = record+(1:numel(metricRows));
    record = range(end);
    cornerColumn(range) = corners(cornerIndex);
    processColumn(range) = processes(cornerIndex);
    caseColumn(range) = cases(cornerIndex);
    vddColumn(range) = vdd_V(cornerIndex);
    tempColumn(range) = temp_C(cornerIndex);
    electrodeColumn(range) = electrode;
    parameterColumn(range) = rows(metricRows,1);
    unitColumn(range) = rows(metricRows,2);
    for metricIndex = 1:numel(metricRows)
        rowIndex = metricRows(metricIndex);
        valueColumn(range(metricIndex)) = formatOne( ...
            values(rowIndex,cornerIndex),rows(rowIndex,2));
    end
end
result = table(cornerColumn,processColumn,caseColumn,vddColumn, ...
    tempColumn,electrodeColumn,parameterColumn,unitColumn,valueColumn, ...
    'VariableNames',{'Corner','Process','Environment','AVDD_V', ...
    'Temperature_C','Electrode','Parameter','Unit','Value'});
end

function result = buildFullRtiTable(rtiResidual_uVpp,corners,processes,cases, ...
        vdd_V,temp_C)
parameters = ["RTI residual - BAL"; "RTI residual - MIS-P"; ...
    "RTI residual - MIS-N"; "RTI residual - MIS-RLD"];
electrodes = ["BAL"; "MIS-P"; "MIS-N"; "MIS-RLD"];
caseCount = numel(parameters);
cornerCount = numel(corners);
if ~isequal(size(rtiResidual_uVpp),[caseCount cornerCount])
    error('INA_RLD_Analyze:FullRtiCornerCount', ...
        'Expected four RTI results for every full-PVT corner.');
end

nRecords = caseCount*cornerCount;
cornerColumn = strings(nRecords,1);
processColumn = strings(nRecords,1);
caseColumn = strings(nRecords,1);
vddColumn = nan(nRecords,1);
tempColumn = nan(nRecords,1);
electrodeColumn = strings(nRecords,1);
parameterColumn = strings(nRecords,1);
unitColumn = repmat("uVpp",nRecords,1);
valueColumn = strings(nRecords,1);
record = 0;
for cornerIndex = 1:cornerCount
    range = record+(1:caseCount);
    record = range(end);
    cornerColumn(range) = corners(cornerIndex);
    processColumn(range) = processes(cornerIndex);
    caseColumn(range) = cases(cornerIndex);
    vddColumn(range) = vdd_V(cornerIndex);
    tempColumn(range) = temp_C(cornerIndex);
    electrodeColumn(range) = electrodes;
    parameterColumn(range) = parameters;
    for caseIndex = 1:caseCount
        valueColumn(range(caseIndex)) = formatOne( ...
            rtiResidual_uVpp(caseIndex,cornerIndex),"uVpp");
    end
end
result = table(cornerColumn,processColumn,caseColumn,vddColumn, ...
    tempColumn,electrodeColumn,parameterColumn,unitColumn,valueColumn, ...
    'VariableNames',{'Corner','Process','Environment','AVDD_V', ...
    'Temperature_C','Electrode','Parameter','Unit','Value'});
end

function result = buildWorstCaseTable(rows,values,corners)
definitions = [
    "Total current",                            "Total current",                         "max"
    "Total power",                              "Total power",                           "max"
    "Output CM error",                          "Output CM error",                       "maxspecmid"
    "Input-referred offset",                    "Input-referred offset",                 "maxmagnitude"
    "S1 gain",                                  "__S1_GAIN_AT_ERROR__",                 "linked"
    "S1 gain dB",                               "__S1_GAIN_DB_AT_ERROR__",              "linked"
    "S1 gain error",                            "S1 gain error",                         "maxspecmid"
    "S1 -3 dB bandwidth",                       "S1 -3 dB bandwidth",                    "min"
    "S2 gain",                                  "__S2_GAIN_AT_ERROR__",                 "linked"
    "S2 gain dB",                               "__S2_GAIN_DB_AT_ERROR__",              "linked"
    "S2 gain error",                            "S2 gain error",                         "maxspecmid"
    "S2 -3 dB bandwidth",                       "S2 -3 dB bandwidth",                    "min"
    "INA gain",                                 "__INA_GAIN_AT_ERROR__",                "linked"
    "INA gain dB",                              "__INA_GAIN_DB_AT_ERROR__",             "linked"
    "INA gain error",                           "INA gain error",                        "maxspecmid"
    "Gain flatness 0.05-150 Hz",                "Gain flatness 0.05-150 Hz",              "max"
    "INA -3 dB bandwidth",                      "INA -3 dB bandwidth",                    "min"
    "Input range low",                           "Input range low",                        "max"
    "Input range high",                          "Input range high",                       "min"
    "Output range low",                          "Output range low",                       "max"
    "Output range high",                         "Output range high",                      "min"
    "INA CMRR @ 60 Hz",                         "INA CMRR @ 60 Hz",                       "min"
    "INA CMRR @ 150 Hz",                        "INA CMRR @ 150 Hz",                      "min"
    "INA PSRR+ @ 60 Hz",                        "INA PSRR+ @ 60 Hz",                      "min"
    "INA PSRR+ @ 150 Hz",                       "INA PSRR+ @ 150 Hz",                     "min"
    "INA PSRR- @ 60 Hz",                        "INA PSRR- @ 60 Hz",                      "min"
    "INA PSRR- @ 150 Hz",                       "INA PSRR- @ 150 Hz",                     "min"
    "Input-referred noise 0.05-150 Hz",         "Input-referred noise 0.05-150 Hz",      "max"
    "THD @ 60 Hz, 5 mVpp",                    "THD @ 60 Hz, 5 mVpp",                 "max"
    "RLD gain",                                 "RLD gain",                              "min"
    "RLD -3 dB bandwidth",                      "RLD -3 dB bandwidth",                   "min"
    "RLD phase margin",                         "RLD phase margin",                      "min"
    "Input CM suppression @ 60 Hz",             "Input CM suppression @ 60 Hz",          "min"
    "Input CM suppression @ 150 Hz",            "Input CM suppression @ 150 Hz",         "min"
];
definitions = definitions(reportParameterOrder(definitions(:,1)),:);

n = size(definitions,1);
parameter = definitions(:,1);
unit = strings(n,1);
specification = strings(n,1);
selectedValue = nan(n,1);
selectedCorner = strings(n,1);
pvtSpecifications = pvtSpecStrings(rows);

for definitionIndex = 1:n
    specificationIndex = find(rows(:,1) == parameter(definitionIndex),1);
    if ~isempty(specificationIndex)
        specification(definitionIndex) = pvtSpecifications(specificationIndex);
    end
    sourceName = definitions(definitionIndex,2);
    linked = false;
    linkedCandidates = [];
    if startsWith(sourceName,"__S1_GAIN")
        if contains(sourceName,"_DB_")
            rowIndex = find(rows(:,1) == "S1 gain dB",1);
        else
            rowIndex = find(rows(:,1) == "S1 gain" & rows(:,2) == "V/V",1);
        end
        errorIndex = find(rows(:,1) == "S1 gain error",1);
        linked = true;
    elseif startsWith(sourceName,"__S2_GAIN")
        if contains(sourceName,"_DB_")
            rowIndex = find(rows(:,1) == "S2 gain dB",1);
        else
            rowIndex = find(rows(:,1) == "S2 gain" & rows(:,2) == "V/V",1);
        end
        errorIndex = find(rows(:,1) == "S2 gain error",1);
        linked = true;
    elseif startsWith(sourceName,"__INA_GAIN")
        if contains(sourceName,"_DB_")
            rowIndex = find(rows(:,1) == "INA gain dB",1);
        else
            rowIndex = find(rows(:,1) == "INA gain" & rows(:,2) == "V/V",1);
        end
        errorIndex = find(rows(:,1) == "INA gain error",1);
        linked = true;
    end
    if linked
        unit(definitionIndex) = rows(rowIndex,2);
        candidates = values(rowIndex,:);
        linkedCandidates = values(errorIndex,:);
        [~,linkedIndex] = max(abs(linkedCandidates));
    else
        rowIndex = find(rows(:,1) == sourceName,1);
        if isempty(rowIndex)
            error('INA_RLD_Analyze:WorstCaseRow', ...
                'Unknown worst-case parameter %s.',sourceName);
        end
        unit(definitionIndex) = rows(rowIndex,2);
        candidates = values(rowIndex,:);
    end
    failureMask = ~isfinite(candidates);
    if linked
        failureMask = failureMask | ~isfinite(linkedCandidates);
    end
    failureIndices = find(failureMask);
    if ~isempty(failureIndices)
        selectedIndex = failureIndices(1);
        selectedValue(definitionIndex) = candidates(selectedIndex);
        selectedCorner(definitionIndex) = corners(selectedIndex);
        continue;
    end
    if linked
        selectedIndex = linkedIndex;
    else
        switch definitions(definitionIndex,3)
            case "min"
                [~,selectedIndex] = min(candidates);
            case "max"
                [~,selectedIndex] = max(candidates);
            case "maxmagnitude"
                [~,selectedIndex] = max(abs(candidates));
            case "maxspecmid"
                bounds = strictSpecBounds(parameter(definitionIndex), ...
                    unit(definitionIndex));
                [~,selectedIndex] = max(abs(candidates-mean(bounds)));
            otherwise
                error('INA_RLD_Analyze:WorstCaseMode','Unknown selection mode.');
        end
    end
    selectedValue(definitionIndex) = candidates(selectedIndex);
    selectedCorner(definitionIndex) = corners(selectedIndex);
end

formattedValue = strings(size(selectedValue));
for valueIndex = 1:numel(selectedValue)
    formattedValue(valueIndex) = ...
        formatOne(selectedValue(valueIndex),unit(valueIndex));
end
result = table(parameter,unit,specification,formattedValue,selectedCorner, ...
    'VariableNames',{'Parameter','Unit','Spec','Value','Corner'});
end

function result = addRtiWorstCases(result,rtiResidual_uVpp,cornerLabels)
parameters = ["RTI residual - BAL"; "RTI residual - MIS-P"; ...
    "RTI residual - MIS-N"; "RTI residual - MIS-RLD"];
if ~isequal(size(rtiResidual_uVpp),[numel(parameters) numel(cornerLabels)])
    error('INA_RLD_Analyze:RtiWorstCaseCount', ...
        'Expected one RTI residual per case and full-PVT corner.');
end
units = repmat("uVpp",numel(parameters),1);
specifications = repmat("≤1000",numel(parameters),1);
values = strings(numel(parameters),1);
corners = strings(numel(parameters),1);
for valueIndex = 1:numel(parameters)
    [selectedValue,selectedIndex] = ...
        max(rtiResidual_uVpp(valueIndex,:),[],2,'omitnan');
    if ~isfinite(selectedValue)
        error('INA_RLD_Analyze:RtiWorstCaseValue', ...
            'No finite RTI result is available for %s.',parameters(valueIndex));
    end
    values(valueIndex) = formatOne(selectedValue,units(valueIndex));
    corners(valueIndex) = cornerLabels(selectedIndex);
end
rtiResult = table(parameters,units,specifications,values,corners, ...
    'VariableNames',result.Properties.VariableNames);

rldMetricIndex = find(result.Parameter == "RLD gain",1);
if isempty(rldMetricIndex)
    error('INA_RLD_Analyze:MissingRldWorstCase', ...
        'The worst-case table is missing its RLD metrics.');
end
result = [result(1:rldMetricIndex-1,:); rtiResult; ...
    result(rldMetricIndex:end,:)];
end

function bounds = strictSpecBounds(parameter,unit)
% Return finite two-sided strict bounds in the requested display unit.
switch string(parameter)
    case "Output CM error"
        bounds = [-40e-3 40e-3]/unitScaleToBase(unit);
    case "S1 gain error"
        bounds = [-0.5 0.5]/unitScaleToBase(unit);
    case "S2 gain error"
        bounds = [-0.25 0.25]/unitScaleToBase(unit);
    case "INA gain error"
        bounds = [-0.5 0.5]/unitScaleToBase(unit);
    otherwise
        error('INA_RLD_Analyze:MissingSpecBounds', ...
            'No two-sided strict bounds are defined for %s.',parameter);
end
end

function printSummaryTable(rows,specifications,columns,values)
parameterWidth = max(42,max(strlength(rows(:,1)))+2);
fprintf('%-*s %-8s %-14s',parameterWidth,'Parameter','Unit','Spec');
for columnIndex = 1:numel(columns)
    fprintf(' %13s',columns(columnIndex));
end
fprintf('\n%s\n',repmat('-',1, ...
    parameterWidth+24+14*numel(columns)));
for rowIndex = 1:size(rows,1)
    if rows(rowIndex,1) == "" && rows(rowIndex,2) == ""
        fprintf('\n');
    elseif rows(rowIndex,2) == ""
        fprintf('%-*s\n',parameterWidth, ...
            upper(char(rows(rowIndex,1))));
    else
        fprintf('%-*s %-8s %-14s',parameterWidth, ...
            char(rows(rowIndex,1)),char(rows(rowIndex,2)), ...
            char(specifications(rowIndex)));
        for columnIndex = 1:numel(columns)
            fprintf(' %13s',values(rowIndex,columnIndex));
        end
        fprintf('\n');
    end
end
end

function printWorstCaseTable(result)
parameterWidth = max(42,max(strlength(result.Parameter))+2);
fprintf('%-*s %-8s %-14s %13s %-10s\n',parameterWidth, ...
    'Parameter','Unit','Spec','Value','Corner');
fprintf('%s\n',repmat('-',1,parameterWidth+49));
for rowIndex = 1:height(result)
    fprintf('%-*s %-8s %-14s %13s %-10s\n',parameterWidth, ...
        char(result.Parameter(rowIndex)),char(result.Unit(rowIndex)), ...
        char(result.Spec(rowIndex)), ...
        char(result.Value(rowIndex)), ...
        char(result.Corner(rowIndex)));
end
end

function [rtiRows,rtiSpecifications,rtiValues,rtiResidual_uVpp] = ...
        buildStandardCmrSummary(scriptDir,metrics,processTokens, ...
        environmentTokens,cornerLabels,reportIndices,reportColumns)
caseStems = ["bal"; "misp"; "misn"; "misrld"];
rtiParameters = ["RTI residual - BAL"; "RTI residual - MIS-P"; ...
    "RTI residual - MIS-N"; "RTI residual - MIS-RLD"];
cornerCount = numel(cornerLabels);
columnCount = numel(reportColumns);
if numel(metrics) ~= cornerCount || numel(processTokens) ~= cornerCount || ...
        numel(environmentTokens) ~= cornerCount
    error('INA_RLD_Analyze:StandardCmrCornerCount', ...
        'RTI metrics and filename tokens must match the full PVT corners.');
end
if numel(reportIndices) ~= columnCount || ...
        any(reportIndices < 1 | reportIndices > cornerCount)
    error('INA_RLD_Analyze:StandardCmrReportCorners', ...
        'RTI report indices must match the comparison-table columns.');
end

rtiResidual_uVpp = nan(numel(caseStems),cornerCount);
for cornerIndex = 1:cornerCount
    processToken = processTokens(cornerIndex);
    environmentToken = environmentTokens(cornerIndex);
    resultDir = fullfile(scriptDir,processToken+".Result_txt");
    fileNames = processToken+".std_"+caseStems+"_"+ ...
        environmentToken+".txt";
    files = fullfile(resultDir,fileNames);
    missingFiles = files(~isfile(files));
    if ~isempty(missingFiles)
        error('INA_RLD_Analyze:MissingStandardCmr', ...
            'Missing standards-derived CMR result file(s):\n%s', ...
            strjoin(missingFiles,newline));
    end
    metric = metrics{cornerIndex};
    rtiResidual_uVpp(:,cornerIndex) = ...
        standardCmrResiduals(files,metric.diff.gain60_VV);
end

reportResidual_uVpp = rtiResidual_uVpp(:,reportIndices);

rtiRows = [rtiParameters repmat("uVpp",numel(rtiParameters),1)];
rtiSpecifications = repmat("≤1000",numel(rtiParameters),1);
rtiValues = strings(numel(rtiParameters),columnCount);
for resultIndex = 1:numel(rtiParameters)
    for columnIndex = 1:columnCount
        rtiValues(resultIndex,columnIndex) = ...
            formatOne(reportResidual_uVpp(resultIndex,columnIndex),"uVpp");
    end
end

pass = rtiResidual_uVpp <= 1000;
if all(pass,'all')
    fprintf(['\nAAMI/IEC-DERIVED CMR & RLD-ELECTRODE ROBUSTNESS: ' ...
        'PASS (%d/%d cases)\n'],nnz(pass),numel(pass));
else
    [failedRows,failedColumns] = find(~pass);
    failedCases = rtiParameters(failedRows)+" ["+ ...
        cornerLabels(failedColumns).'+"]";
    warning('INA_RLD_Analyze:StandardCmrFailure', ...
        ['AAMI/IEC-DERIVED CMR & RLD-ELECTRODE ROBUSTNESS: ' ...
         'FAIL (%d/%d cases): %s'], ...
         nnz(pass),numel(pass),strjoin(failedCases,', '));
end
end

function rtiResidual_uVpp = standardCmrResiduals(files,gain60_VV)
if ~isfinite(gain60_VV) || gain60_VV <= 0
    error('INA_RLD_Analyze:StandardCmrGain', ...
        'The corner-specific 60 Hz differential gain must be finite and positive.');
end

rtiResidual_uVpp = nan(numel(files),1);
for fileIndex = 1:numel(files)
    data = readNumericFile(files(fileIndex),7);
    t = data(:,1);
    duration_s = t(end)-t(1);
    settledRows = t >= t(1)+min(5,0.5*duration_s);
    outDiff_V = data(settledRows,6);
    outDiffAc_V = outDiff_V-mean(outDiff_V,'omitnan');
    outPp_V = max(outDiffAc_V,[],'omitnan')- ...
        min(outDiffAc_V,[],'omitnan');
    rtiResidual_uVpp(fileIndex) = outPp_V/gain60_VV*1e6;
end
if any(~isfinite(rtiResidual_uVpp))
    error('INA_RLD_Analyze:StandardCmrResidual', ...
        'One or more standards-derived RTI residuals are not finite.');
end
end

function plotNominalResults(scriptDir,plotDir,nominalMetrics,cfg)
resultDir = fullfile(scriptDir,'nom.Result_txt');
balFiles = runFiles(resultDir,"nom","nom","bal");
selTransient = selTransientFile(resultDir,"nom","nom");
plotDifferentialAc(balFiles.diff,nominalMetrics{1},plotDir,cfg);
plotInaVtc(balFiles.vtc,nominalMetrics{1},plotDir,cfg);
plotRejectionResponse(balFiles.diff,balFiles.cmrr,balFiles.psrrp, ...
    balFiles.psrrn,plotDir);
plotRldLoop(balFiles.loop,nominalMetrics{1},plotDir);
plotCmRejectionCombined(balFiles.cmOff,balFiles.cmOn, ...
    nominalMetrics{1},plotDir);
plotNoise(balFiles.noise,nominalMetrics{1},plotDir);
plotSelFunctionalCheck(selTransient,plotDir);
end

function plotInaVtc(filePath,metric,plotDir,cfg)
data = readNumericFile(filePath,6);
vin_mV = data(:,2)*1e3;
inaOutDiff_V = data(:,6);
idealOutDiff_V = cfg.diffGainTarget_VV*data(:,2);

fig = figure;
plot(vin_mV,inaOutDiff_V,'LineWidth',1.5, ...
    'DisplayName','Actual');
hold on;
plot(vin_mV,idealOutDiff_V,'--','LineWidth',1.2, ...
    'DisplayName',sprintf('Ideal G = %.0f V/V, V_{OS} = 0', ...
    cfg.diffGainTarget_VV));
plot(1e3*[metric.vtc.inputNegative_V metric.vtc.inputPositive_V], ...
    [metric.vtc.outputNegative_V metric.vtc.outputPositive_V], ...
    'o','MarkerSize',7,'LineWidth',1.2, ...
    'DisplayName','1% compression points');
inputLow_mV = 1e3*metric.vtc.inputNegative_V;
inputHigh_mV = 1e3*metric.vtc.inputPositive_V;
outputLow_V = metric.vtc.outputNegative_V;
outputHigh_V = metric.vtc.outputPositive_V;
xline(inputLow_mV,':',sprintf('Input low: %.3f mV',inputLow_mV), ...
    'HandleVisibility','off','LabelVerticalAlignment','middle', ...
    'LabelHorizontalAlignment','left');
xline(inputHigh_mV,':',sprintf('Input high: %.3f mV',inputHigh_mV), ...
    'HandleVisibility','off','LabelVerticalAlignment','middle', ...
    'LabelHorizontalAlignment','right');
yline(outputLow_V,':',sprintf('Output low: %.3f V',outputLow_V), ...
    'HandleVisibility','off','LabelVerticalAlignment','bottom', ...
    'LabelHorizontalAlignment','right');
yline(outputHigh_V,':',sprintf('Output high: %.3f V',outputHigh_V), ...
    'HandleVisibility','off','LabelVerticalAlignment','top', ...
    'LabelHorizontalAlignment','left');
xline(-5,'--','HandleVisibility','off');
xline(5,'--','HandleVisibility','off');
yline(-1.2,'--','HandleVisibility','off');
yline(1.2,'--','HandleVisibility','off');
ylabel('INA Differential Output Voltage (V)');
legend('Location','best');
stylePlot('Differential Input Voltage (mV)', ...
    'INA VTC + 1% Compression - NOM');
savePlot(fig,plotDir,'NOM.INA_RLD_vtc.png');
end

function plotDifferentialAc(balFile,metric,plotDir,cfg)
bal = readNumericFile(balFile,11);
fBal = bal(:,1);
vin = complex(bal(:,2),bal(:,3));
seDiff = complex(bal(:,4),bal(:,5));
inaOutDiff = complex(bal(:,6),bal(:,7));
stage1_dB = magnitudeDb(safeDivide(seDiff,vin));
stage2_dB = magnitudeDb(safeDivide(inaOutDiff,seDiff));
total_dB = magnitudeDb(safeDivide(inaOutDiff,vin));
fig = figure;
semilogx(fBal,stage1_dB,'LineWidth',1.5, ...
    'DisplayName','Stage 1');
hold on;
semilogx(fBal,stage2_dB,'LineWidth',1.5, ...
    'DisplayName','Stage 2');
semilogx(fBal,total_dB,'LineWidth',1.5, ...
    'DisplayName','Total');
yline(20*log10(cfg.stage1GainTarget_VV),'--', ...
    sprintf('%g V/V',cfg.stage1GainTarget_VV), ...
    'HandleVisibility','off','LabelHorizontalAlignment','right');
yline(20*log10(cfg.stage2GainTarget_VV),'--', ...
    sprintf('%g V/V',cfg.stage2GainTarget_VV), ...
    'HandleVisibility','off','LabelHorizontalAlignment','right');
yline(20*log10(cfg.diffGainTarget_VV),'--', ...
    sprintf('%g V/V',cfg.diffGainTarget_VV), ...
    'HandleVisibility','off','LabelHorizontalAlignment','right');
addCursor(metric.diff.stage1Bandwidth3dB_Hz, ...
    20*log10(metric.diff.stage1Gain10_VV)-3, ...
    sprintf('-3 dB: %s', ...
    char(frequencyText(metric.diff.stage1Bandwidth3dB_Hz))));
addCursor(metric.diff.stage2Bandwidth3dB_Hz, ...
    20*log10(metric.diff.stage2Gain10_VV)-3, ...
    sprintf('-3 dB: %s', ...
    char(frequencyText(metric.diff.stage2Bandwidth3dB_Hz))));
cursorFrequencies_Hz = [0.05 150];
for frequency_Hz = cursorFrequencies_Hz
    stage1Gain_dB = interpLogFrequency(fBal,stage1_dB,frequency_Hz);
    stage2Gain_dB = interpLogFrequency(fBal,stage2_dB,frequency_Hz);
    gain_dB = interpLogFrequency(fBal,total_dB,frequency_Hz);
    addCursorLine(frequency_Hz,gain_dB,char(frequencyText(frequency_Hz)));
    addPointAnnotation(frequency_Hz,stage1Gain_dB, ...
        sprintf('%.2f dB',stage1Gain_dB));
    addPointAnnotation(frequency_Hz,stage2Gain_dB, ...
        sprintf('%.2f dB',stage2Gain_dB));
    addPointAnnotation(frequency_Hz,gain_dB, ...
        sprintf('%.2f dB',gain_dB));
end
addCursor(metric.diff.bandwidth3dB_Hz,metric.diff.gain10_dB-3, ...
    sprintf('-3 dB: %s',char(frequencyText(metric.diff.bandwidth3dB_Hz))));
ylabel('Gain (dB)');
xlim([1e-2 1e7]);
legend('Location','southwest');
stylePlot('Frequency (Hz)','INA Differential Frequency Response - NOM');
savePlot(fig,plotDir,'NOM.INA_RLD_differential_ac.png');
end

function plotSelFunctionalCheck(filePath,plotDir)
data = readNumericFile(filePath,5);
if any(diff(data(:,1)) <= 0)
    error('INA_RLD_Analyze:SelectorTransientTime', ...
        'Selector transient time must be strictly increasing: %s',filePath);
end
time_ms = data(:,1)*1e3;
sel_V = data(:,2);
intDiff_mV = data(:,3)*1e3;
extDiff_mV = data(:,4)*1e3;
outDiff_mV = data(:,5)*1e3;
switchTime_ms = selectorSwitchTime_ms(time_ms,sel_V,filePath);

fig = figure;
layout = tiledlayout(fig,3,1);

controlAxes = nexttile(layout);
plot(time_ms,sel_V,'LineWidth',1.5);
hold on;
addSelectorSwitchGuide(switchTime_ms,true);
ylim([-0.15 max(sel_V)+0.15]);
ylabel('SEL (V)');
stylePlot('', '(a) SEL Control');

signalAxes = nexttile(layout);
yyaxis left;
intLine = plot(time_ms,intDiff_mV,'LineWidth',1.5, ...
    'DisplayName','INT input differential');
hold on;
intLimit_mV = max(abs(intDiff_mV),[],'omitnan');
ylim(1.05*[-intLimit_mV intLimit_mV]);
ylabel('INT input differential (mV)');
yyaxis right;
extLine = plot(time_ms,extDiff_mV,'--','LineWidth',1.5, ...
    'DisplayName','EXT input differential');
extLimit_mV = max(abs(extDiff_mV),[],'omitnan');
ylim(1.05*[-extLimit_mV extLimit_mV]);
ylabel('EXT input differential (mV)');
addSelectorSwitchGuide(switchTime_ms,false);
legend([intLine extLine],'Location','northeast');
stylePlot('', '(b) Available INT and EXT Input Signals');

outputAxes = nexttile(layout);
plot(time_ms,outDiff_mV,'LineWidth',2.0, ...
    'DisplayName','OUT differential');
addSelectorSwitchGuide(switchTime_ms,false);
outputLimit_mV = max(abs([intDiff_mV; extDiff_mV; outDiff_mV]), ...
    [],'omitnan');
ylim(1.05*[-outputLimit_mV outputLimit_mV]);
ylabel('Output differential (mV)');
stylePlot('Time (ms)', '(c) Selected Output');

linkaxes([controlAxes signalAxes outputAxes],'x');
xlim([time_ms(1) time_ms(end)]);
sgtitle('SEL INT / EXT Functional Check - NOM');
savePlot(fig,plotDir,'NOM.INA_RLD_sel_functional_check.png');
end

function switchTime_ms = selectorSwitchTime_ms(time_ms,sel_V,filePath)
lowLevel_V = min(sel_V,[],'omitnan');
highLevel_V = max(sel_V,[],'omitnan');
threshold_V = 0.5*(lowLevel_V+highLevel_V);
switchIndex = find(sel_V >= threshold_V,1,'first');
if ~isfinite(lowLevel_V) || ~isfinite(highLevel_V) || ...
        highLevel_V <= lowLevel_V || isempty(switchIndex)
    error('INA_RLD_Analyze:SelectorSwitch', ...
        'Selector control does not contain a low-to-high switch: %s',filePath);
end
switchTime_ms = time_ms(switchIndex);
end

function addSelectorSwitchGuide(switchTime_ms,showRegionLabels)
xline(switchTime_ms,'--','HandleVisibility','off');
if showRegionLabels
    text(0.25,0.90,'INT Selected','Units','normalized', ...
        'HorizontalAlignment','center','VerticalAlignment','top', ...
        'HandleVisibility','off');
    text(0.75,0.90,'EXT Selected','Units','normalized', ...
        'HorizontalAlignment','center','VerticalAlignment','top', ...
        'HandleVisibility','off');
end
end

function plotCmRejectionCombined(offFile,onFile,metric,plotDir)
[fSuppression,suppression_dB] = inputCmSuppressionCurve(offFile,onFile);
[fOff,off] = commonModeTransfers(readNumericFile(offFile,13));
[fOn,on] = commonModeTransfers(readNumericFile(onFile,13));
offInputGain_dB = magnitudeDb(off.inputCm);
onInputGain_dB = magnitudeDb(on.inputCm);
fig = figure;
layout = tiledlayout(fig,2,1);

topAxes = nexttile(layout);
semilogx(fSuppression,suppression_dB,'LineWidth',1.5);
hold on;
cursorFrequencies_Hz = [60 150];
for frequencyIndex = 1:2
    frequency_Hz = cursorFrequencies_Hz(frequencyIndex);
    addCursorLine(frequency_Hz,metric.cm.inputSuppression_dB(frequencyIndex), ...
        sprintf('%g Hz: %.2f dB',frequency_Hz, ...
        metric.cm.inputSuppression_dB(frequencyIndex)));
end
xlim([0.01 1e4]);
ylabel('CM suppression (dB)');
stylePlot('', '(a) Input Common-Mode Suppression - NOM');

bottomAxes = nexttile(layout);
semilogx(fOff,offInputGain_dB,'LineWidth',1.5,'DisplayName','RLD OFF');
hold on;
semilogx(fOn,onInputGain_dB,'--','LineWidth',1.5, ...
    'DisplayName','RLD ON');
xlim([0.01 1e4]);
ylabel('|V_{IN,CM} / V_{CM,SRC}| (dB)');
legend('Location','southwest');
stylePlot('Frequency (Hz)', '(b) Input Common-Mode Transfer - NOM');
linkaxes([topAxes bottomAxes],'x');
sgtitle('RLD Common-Mode Rejection Performance - NOM');
savePlot(fig,plotDir,'NOM.INA_RLD_cm_rejection.png');
end

function [f,suppression_dB] = inputCmSuppressionCurve(offFile,onFile)
[f,off] = commonModeTransfers(readNumericFile(offFile,13));
[fOn,on] = commonModeTransfers(readNumericFile(onFile,13));
off_dB = magnitudeDb(off.inputCm);
on_dB = magnitudeDb(on.inputCm);
if isequal(f,fOn)
    suppression_dB = off_dB-on_dB;
else
    suppression_dB = off_dB-interpLogFrequency(fOn,on_dB,f);
end
end

function plotRejectionResponse(diffFile,cmrrFile,psrrpFile,psrrnFile,plotDir)
% Use the INA differential output for all three rejection definitions.
% CMRR = 20log10(|A_D/A_CM|), while PSRR+/− compare A_D with the
% corresponding supply-to-output feedthrough.
diffData = readNumericFile(diffFile,11);
fDiff = diffData(:,1);
ad = safeDivide(complex(diffData(:,6),diffData(:,7)), ...
    complex(diffData(:,2),diffData(:,3)));

[fCm,acm] = cmrrTransfer(readNumericFile(cmrrFile,5));
cmrr_dB = magnitudeDb(ad)-interpLogFrequency(fCm, ...
    magnitudeDb(acm),fDiff);

[fP,apsrrP] = supplyFeedthrough(psrrpFile);
[fN,apsrrN] = supplyFeedthrough(psrrnFile);
psrrP_dB = magnitudeDb(ad)-interpLogFrequency(fP,magnitudeDb(apsrrP),fDiff);
psrrN_dB = magnitudeDb(ad)-interpLogFrequency(fN,magnitudeDb(apsrrN),fDiff);

fig = figure;
semilogx(fDiff,cmrr_dB,'LineWidth',1.5,'DisplayName','INA CMRR'); hold on;
semilogx(fDiff,psrrP_dB,'LineWidth',1.5,'DisplayName','PSRR+');
semilogx(fDiff,psrrN_dB,'LineWidth',1.5,'DisplayName','PSRR-');
yline(80,'--','80 dB','HandleVisibility','off');
for frequency_Hz = [60 150]
    addCursorLine(frequency_Hz, ...
        interpLogFrequency(fDiff,cmrr_dB,frequency_Hz), ...
        sprintf('%g Hz',frequency_Hz));
end
xlim([0.01 1e5]);
ylabel('Rejection (dB)');
legend('Location','southwest');
stylePlot('Frequency (Hz)','INA CMRR, PSRR+, and PSRR- - NOM, BAL');
savePlot(fig,plotDir,'NOM.INA_RLD_rejection_response.png');
end

function [f,feedthrough] = supplyFeedthrough(filePath)
data = readNumericFile(filePath,7);
f = data(:,1);
validateFrequency(f,filePath);
supply = complex(data(:,2),data(:,3));
outDiff = complex(data(:,4),data(:,5));
feedthrough = safeDivide(outDiff,supply);
end

function [f,transfer] = cmrrTransfer(data)
validateFrequency(data(:,1),'CMRR AC');
f = data(:,1);
inputCm = complex(data(:,2),data(:,3));
inaOutDiff = complex(data(:,4),data(:,5));
transfer = safeDivide(inaOutDiff,inputCm);
end

function plotRldLoop(balFile,metric,plotDir)
balData = readNumericFile(balFile,11);
[fBal,phaseBal,gainBal] = loopTransfer(balData);
fig = figure;
yyaxis left;
semilogx(fBal,gainBal,'LineWidth',1.5);
hold on;
yline(0,'--','HandleVisibility','off');
addCursor(metric.loop.bandwidth3dB_Hz, ...
    metric.loop.lowFrequencyGain_dB-3, ...
    sprintf('-3dB: %s', ...
    char(frequencyText(metric.loop.bandwidth3dB_Hz))));
addCursor(metric.loop.crossover_Hz,0,sprintf('UGF: %s', ...
    char(frequencyText(metric.loop.crossover_Hz))));
ylabel('Loop gain (dB)');

yyaxis right;
semilogx(fBal,phaseBal,'LineWidth',1.5);
hold on;
phaseAtBal = interpLogFrequency(fBal,phaseBal, ...
    metric.loop.crossover_Hz);
addCursor(metric.loop.crossover_Hz,phaseAtBal, ...
    sprintf('PM: %.2f deg',metric.loop.phaseMargin_deg));
ylabel('Loop phase (deg)');
stylePlot('Frequency (Hz)', ...
    'RLD Open-Loop Gain and Phase - NOM, BAL');
savePlot(fig,plotDir,'NOM.INA_RLD_loop_gain.png');
end

function plotNoise(balFile,metric,plotDir)
bal = readNumericFile(balFile,3);
density_nV = abs(bal(:,3))*1e9;
fig = figure;
loglog(bal(:,1),density_nV,'LineWidth',1.5);
hold on;
for frequency_Hz = [0.05 1 60 150]
    markerDensity_nV = interpLogFrequency( ...
        bal(:,1),density_nV,frequency_Hz);
    addCursor(frequency_Hz,markerDensity_nV, ...
        sprintf('%s: %.2f nV/sqrt(Hz)', ...
        char(frequencyText(frequency_Hz)),markerDensity_nV));
end
addMetricBox({sprintf('Integrated 0.05-150 Hz = %.3f uVrms', ...
    metric.noise.inputRms_V*1e6)},[0.98 0.94],'right');
xlim([0.04 500]);
ylabel('Input-referred noise density (nV/sqrt(Hz))');
stylePlot('Frequency (Hz)', ...
    'INA + RLD Input-Referred Noise Density - NOM, BAL');
savePlot(fig,plotDir,'NOM.INA_RLD_noise.png');
end

function addCursor(xValue,yValue,labelText)
if ~isfinite(xValue) || ~isfinite(yValue)
    return;
end
xline(xValue,':','HandleVisibility','off');
plot(xValue,yValue,'o','MarkerFaceColor','r', ...
    'MarkerEdgeColor','r','MarkerSize',6,'HandleVisibility','off');
text(xValue,yValue," "+string(labelText), ...
    'BackgroundColor','w','Color','k','Margin',2, ...
    'VerticalAlignment','bottom','HorizontalAlignment','left', ...
    'Clipping','on','HandleVisibility','off');
end

function addPointAnnotation(xValue,yValue,labelText)
if ~isfinite(xValue) || ~isfinite(yValue)
    return;
end
plot(xValue,yValue,'o','MarkerFaceColor','r', ...
    'MarkerEdgeColor','r','MarkerSize',6,'HandleVisibility','off');
text(xValue,yValue," "+string(labelText), ...
    'BackgroundColor','w','Color','k','Margin',2, ...
    'VerticalAlignment','bottom','HorizontalAlignment','left', ...
    'Clipping','on','HandleVisibility','off');
end

function addCursorLine(xValue,yValue,labelText)
if ~isfinite(xValue) || ~isfinite(yValue)
    return;
end
xline(xValue,':'," "+string(labelText),'HandleVisibility','off', ...
    'LabelVerticalAlignment','middle', ...
    'LabelHorizontalAlignment','left');
end

function addMetricBox(lines,position,horizontalAlignment)
if nargin < 2
    position = [0.02 0.94];
end
if nargin < 3
    horizontalAlignment = 'left';
end
text(position(1),position(2),strjoin(lines,newline), ...
    'Units','normalized', ...
    'BackgroundColor','w','Color','k','Margin',4, ...
    'VerticalAlignment','top', ...
    'HorizontalAlignment',horizontalAlignment, ...
    'HandleVisibility','off');
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

function textValue = frequencyText(frequency_Hz)
if ~isfinite(frequency_Hz)
    textValue = "NaN";
elseif frequency_Hz >= 1e6
    textValue = string(sprintf('%.4g MHz',frequency_Hz/1e6));
elseif frequency_Hz >= 1e3
    textValue = string(sprintf('%.4g kHz',frequency_Hz/1e3));
else
    textValue = string(sprintf('%.4g Hz',frequency_Hz));
end
end

function [rows,scaledValues] = adaptReportUnits(rows,rawValues)
scaledValues = rawValues;
for rowIndex = 1:size(rows,1)
    if rows(rowIndex,1) == "Input-referred offset"
        rows(rowIndex,2) = "uV";
        scaledValues(rowIndex,:) = rawValues(rowIndex,:)*1e6;
    else
        [rows(rowIndex,2),scaledValues(rowIndex,:)] = ...
            adaptValuesUnit(rows(rowIndex,2),rawValues(rowIndex,:));
    end
end
end

function [unit,scaledValues] = adaptValuesUnit(unit,values)
scaledValues = values;
if unit == "" || unit == "dB" || unit == "%" || unit == "V/V" || unit == "deg"
    return;
end
nonzero = isfinite(values) & values ~= 0;
if ~any(nonzero)
    return;
end
[unit,scalePower] = scaleUnit(max(abs(values(nonzero))),unit);
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

function value = specNumber(baseValue,unit)
value = string(sprintf('%.6g',baseValue/unitScaleToBase(unit)));
end

function factor = unitScaleToBase(unit)
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

function textValue = formatOne(value,unit)
if isnan(value)
    textValue = "NaN";
elseif isinf(value)
    textValue = string(sprintf('%+g',value));
elseif unit == "dB" || unit == "%"
    if value ~= 0 && (abs(value) < 1e-3 || abs(value) > 999)
        textValue = string(sprintf('%.3e',value));
    else
        textValue = string(sprintf('%.3f',value));
    end
else
    textValue = string(sprintf('%.3f',value));
end
end
