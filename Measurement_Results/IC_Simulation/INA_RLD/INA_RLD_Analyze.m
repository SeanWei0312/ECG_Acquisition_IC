function INA_RLD_Analyze
% INA_RLD_ANALYZE Characterize the combined INA, RLD, and SEL testbench.
%
% Expected NGSPICE output is stored beside this file in:
%   nom.Result_txt, ff.Result_txt, ss.Result_txt, fs.Result_txt,
%   sf.Result_txt
%
% Every process/environment point contains balanced (BAL) and mismatched
% (MIS) electrode data. Numerical reports use BAL across the full 45-corner
% PVT sweep; MIS remains an automated stress check. NOM/NOM plots use BAL,
% except the CM-to-differential plot, which uses MIS to expose conversion.

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
electrodes = ["BAL" "MIS"];
electrodeTokens = lower(electrodes);
balIndex = find(electrodes == "BAL",1);

nCorners = numel(processes)*numel(cases);
nElectrodes = numel(electrodes);
corners = strings(1,nCorners);
cornerProcess = strings(1,nCorners);
cornerCase = strings(1,nCorners);
cornerVdd_V = nan(1,nCorners);
cornerTemp_C = nan(1,nCorners);
rawValues = nan(size(rows,1),nCorners);
rldPeakCurrent_A = nan(1,nCorners);
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
        cornerVdd_V(cornerIndex) = caseVdd_V(caseIndex);
        cornerTemp_C(cornerIndex) = caseTemp_C(caseIndex);

        for electrodeIndex = 1:nElectrodes
            electrodeToken = electrodeTokens(electrodeIndex);
            m = analyzeRun(resultDir,processToken,caseToken, ...
                electrodeToken,caseVdd_V(caseIndex),cfg);
            metrics{cornerIndex,electrodeIndex} = m;
            if electrodeIndex == balIndex
                rawValues(:,cornerIndex) = metricsToRaw( ...
                    m,rows,caseTemp_C(caseIndex),cfg.diffGainTarget_VV);
                rldPeakCurrent_A(cornerIndex) = m.tran.peakRldCurrent_A;
            end
        end
    end
end

checkMisStress(metrics,corners,cfg);

[rows,scaledValues] = adaptReportUnits(rows,rawValues);
formattedValues = formatReportValues(rows,scaledValues);
specifications = pvtSpecStrings(rows);
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
summaryTable = table(rows(:,1),rows(:,2),specifications, ...
    'VariableNames',{'Parameter','Unit','Spec'});
summaryTable = [summaryTable array2table(reportValues, ...
    'VariableNames',cellstr(reportColumns))];
fprintf('\nINA + RLD COMPARISON SUMMARY\n\n');
printSummaryTable(rows,specifications,reportColumns,reportValues);
writetable(summaryTable,fullfile(reportDir,'INA_RLD_table_report.csv'));
writetable(summaryTable,fullfile(reportDir,'NOM.INA_RLD_summary.csv'));

fullPvtTable = buildFullPvtTable(rows,scaledValues,corners, ...
    cornerProcess,cornerCase,cornerVdd_V,cornerTemp_C,electrodes(balIndex));
writetable(fullPvtTable,fullfile(reportDir,'INA_RLD_full_pvt_report.csv'));

worstCase = buildWorstCaseTable( ...
    rows,scaledValues,corners,rldPeakCurrent_A);
fprintf('\nINA + RLD FULL-PVT WORST CASE\n\n');
printWorstCaseTable(worstCase);
writetable(worstCase,fullfile(reportDir,'INA_RLD_worst_case_report.csv'));

plotNominalResults(scriptDir,plotDir,metrics(nominalCorner,:));
runMcSection(scriptDir);

end

function runMcSection(rootDir)
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
for k = 1:numel(modes)
    [raw,hasSuppression] = mcReadSummary(files(k));
    missingSuppression = missingSuppression || ~hasSuppression;
    results{k} = mcSummarize(raw,defs,modes(k));
    writetable(results{k}.table,fullfile(reportDir,modes(k) + "_MC_Summary.csv"));
    mcPrintSummary(results{k});
end
runTable = table(modes',cellfun(@(r) r.requested,results), ...
    cellfun(@(r) r.valid,results),cellfun(@(r) r.failed,results), ...
    cellfun(@(r) r.overallYield,results), ...
    'VariableNames',{'Mode','RequestedRuns','ValidRuns','FailedRuns','OverallYield_pct'});
writetable(runTable,fullfile(reportDir,'MC_Run_Summary.csv'));
mcPlotHistograms(results,plotDir);
if missingSuppression
    warning('INA_RLD_Analyze:MissingMcSuppression', ...
        ['MC summary files have 13 columns, so 60 Hz and 150 Hz CM suppression are unavailable. ' ...
         'Their CSV rows are N/A and the suppression histogram is skipped.']);
else
    mcPlotSuppression(results,defs,plotDir);
end
end

function defs = mcDefinitions()
defs.names = ["Total current","Total power","Output CM error","RLD DC error", ...
    "Input-referred offset","S1 gain","S1 gain error","S2 gain","S2 gain error", ...
    "INA gain","INA gain error","RLD loop UGF","RLD phase margin", ...
    "Input CM suppression @ 60 Hz","Input CM suppression @ 150 Hz"];
defs.units = ["mA","mW","mV","uV","uV","V/V","%","V/V","%","V/V","%", ...
    "kHz","deg","dB","dB"];
defs.specs = strictSpecStrings(defs.names,defs.units);
defs.columns = [5 6 3 4 2 7 NaN 8 NaN 9 10 12 13 14 15];
defs.scales = [1e3 1e3 1 1e3 1e3 1 1 1 1 1 1 1e-3 1 1 1];
% Gain V/V is report-only; its corresponding gain-error row is the requirement.
defs.required = strlength(defs.specs) > 0;
defs.yieldChecked = defs.required;
end

function [raw,hasSuppression] = mcReadSummary(filePath)
raw = readmatrix(filePath,'FileType','text');
raw = raw(any(isfinite(raw),2),:);
if size(raw,2) ~= 13 && size(raw,2) ~= 15
    error('INA_RLD_Analyze:McColumns','%s must have 13 or 15 numeric columns.',filePath);
end
hasSuppression = size(raw,2) >= 15;
if ~hasSuppression, raw(:,14:15) = NaN; end
end

function r = mcSummarize(raw,defs,mode)
values = nan(size(raw,1),numel(defs.names));
sourceMask = isfinite(defs.columns);
values(:,sourceMask) = raw(:,defs.columns(sourceMask)).*defs.scales(sourceMask);
values(:,7) = 100*(values(:,6)/60-1);
values(:,9) = 100*(values(:,8)/4-1);
validMask = all(isfinite(values(:,1:11)),2);
count = numel(defs.names);
r.mode = mode; r.values = values; r.available = any(isfinite(values),1);
r.requested = size(raw,1); r.valid = nnz(validMask); r.failed = r.requested-r.valid;
r.stats = nan(count,7); r.yield = nan(count,1); r.pass = false(r.requested,count);
lowGainRows = find(validMask & values(:,11) <= -90);
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

function mcPlotHistograms(results,plotDir)
mcHistogram(results,5,plotDir,'Fig_MC_01_Vos_Histogram.png', ...
    'Input-Referred Offset Distribution - MM / GL / FULL', ...
    'Input-referred offset (uV)',[-500 500]);
mcHistogram(results,11,plotDir,'Fig_MC_02_INA_Gain_Error_Histogram.png', ...
    'INA Gain Error Distribution - MM / GL / FULL', ...
    'INA gain error (%)',[-1 1]);
mcHistogram(results,12,plotDir,'Fig_MC_03_RLD_UGF_Histogram.png', ...
    'RLD Loop UGF Distribution - MM / GL / FULL', ...
    'RLD loop UGF (kHz)',[0.3 2]);
mcHistogram(results,13,plotDir,'Fig_MC_04_RLD_PM_Histogram.png', ...
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
legend('Location','best');
mcAddFullStatMarkers(results{3},index);
savePlot(fig,plotDir,fileName);
end

function mcPlotSuppression(results,defs,plotDir)
fig = figure;
layout = tiledlayout(2,1);
indices = [14 15]; limits = [50 45]; colors = lines(numel(results));
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
    legend('Location','best');
    mcAddFullStatMarkers(results{3},indices(p));
end
savePlot(fig,plotDir,'Fig_MC_05_Input_CM_Suppression_Histogram.png');
end

function [lo,hi,displayMask] = mcDisplayRange(values,results,index)
% Use one physical x-axis spanning the MM/GL/FULL statistical cores.
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
    lo = min(values);
    hi = max(values);
else
    lo = min(limits);
    hi = max(limits);
end
if lo == hi
    pad = max(abs(lo)*0.05,1);
    lo = lo-pad;
    hi = hi+pad;
end
pad = max(0.05*(hi-lo),eps(max(abs([lo hi]))));
lo = lo-pad;
hi = hi+pad;
displayMask = values >= lo & values <= hi;
if ~any(displayMask)
    lo = min(values); hi = max(values);
    if lo == hi
        pad = max(abs(lo)*0.05,1);
        lo = lo-pad; hi = hi+pad;
    end
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
cfg.diffGainTarget_VV = 240;
cfg.ecgFrequency_Hz = 10;
cfg.noiseBand_Hz = [0.05 150];
cfg.cmFrequencies_Hz = [60 150];
cfg.transientPreStartGuard_s = 40e-3;
cfg.transientPreEndGuard_s = 5e-3;
cfg.transientDuringStartGuard_s = 10e-3;
cfg.transientDuringEndGuard_s = 5e-3;
cfg.vddTolerance_V = 5e-3;
cfg.misMinimumPhaseMargin_deg = 60;
cfg.misPhaseMarginDropWarning_deg = 10;
cfg.misMaximumGainChange_pct = 0.5;
cfg.misMinimumCmDiffReduction_dB = 20;
cfg.misMinimumRldRailHeadroom_V = 0.10;
end

function checkMisStress(metrics,corners,cfg)
messages = strings(0,1);
for cornerIndex = 1:size(metrics,1)
    bal = metrics{cornerIndex,1};
    mis = metrics{cornerIndex,2};
    issues = strings(0,1);

    if ~isfinite(mis.loop.crossover_Hz) || ...
            ~isfinite(mis.loop.phaseMargin_deg)
        issues(end+1) = "RLD crossover/phase margin is not finite"; %#ok<AGROW>
    elseif mis.loop.phaseMargin_deg < cfg.misMinimumPhaseMargin_deg
        issues(end+1) = sprintf('RLD phase margin is %.3f deg', ...
            mis.loop.phaseMargin_deg); %#ok<AGROW>
    elseif isfinite(bal.loop.phaseMargin_deg) && ...
            mis.loop.phaseMargin_deg < bal.loop.phaseMargin_deg- ...
            cfg.misPhaseMarginDropWarning_deg
        issues(end+1) = sprintf(['RLD phase margin dropped by %.3f deg ' ...
            'relative to BAL'],bal.loop.phaseMargin_deg- ...
            mis.loop.phaseMargin_deg); %#ok<AGROW>
    end

    railHeadroom_V = mis.tran.rldRailHeadroom_V;
    if ~isfinite(railHeadroom_V)
        issues(end+1) = "RLD output headroom is not finite"; %#ok<AGROW>
    elseif railHeadroom_V < cfg.misMinimumRldRailHeadroom_V
        issues(end+1) = sprintf('RLD output rail headroom is %.6g V', ...
            railHeadroom_V); %#ok<AGROW>
    end
    if ~isfinite(mis.tran.gainBeforeInterference_VV) || ...
            ~isfinite(mis.tran.gainDuringInterference_VV) || ...
            ~isfinite(mis.tran.gainChangeDuringInterference_pct)
        issues(end+1) = "transient differential gain is not finite"; %#ok<AGROW>
    elseif abs(mis.tran.gainChangeDuringInterference_pct) > ...
            cfg.misMaximumGainChange_pct
        issues(end+1) = sprintf( ...
            'gain change during CM interference is %.6g%%', ...
            mis.tran.gainChangeDuringInterference_pct); %#ok<AGROW>
    end

    reduction_dB = mis.cm.cmToDiffReduction_dB;
    if any(~isfinite(reduction_dB))
        issues(end+1) = ...
            "CM-to-differential reduction is not finite"; %#ok<AGROW>
    elseif any(reduction_dB < cfg.misMinimumCmDiffReduction_dB)
        issues(end+1) = sprintf( ...
            'CM-to-differential reduction is %.3f/%.3f dB at 60/150 Hz', ...
            reduction_dB(1),reduction_dB(2)); %#ok<AGROW>
    end

    if ~isempty(issues)
        messages(end+1) = corners(cornerIndex)+": "+ ...
            strjoin(issues,'; '); %#ok<AGROW>
    end
end
if ~isempty(messages)
    warning('INA_RLD_Analyze:MisStress', ...
        'MIS stress check failed at %d corner(s):\n%s', ...
        numel(messages),strjoin(messages,newline));
end
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
    "RLD DC error",                                 "V"
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
    "",                                            ""
    "RLD",                                         ""
    "RLD loop UGF",                                "Hz"
    "RLD phase margin",                            "deg"
    "Input CM suppression @ 60 Hz",                "dB"
    "Input CM suppression @ 150 Hz",               "dB"
    "RLD Swing Ratio",                             "%"
    "RLD Peak Current",                            "A"
    "CM Interference Gain Change",                  "%"
    "",                                             ""
    "NOISE",                                        ""
    "Input-referred noise 0.05-150 Hz",             "Vrms"
];
end

function specifications = pvtSpecStrings(rows)
specifications = strictSpecStrings(rows(:,1),rows(:,2));
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
    case "RLD DC error", specification = "±"+specNumber(30e-6,unit);
    case "Input-referred offset", specification = "±"+specNumber(300e-6,unit);
    case "S1 gain error", specification = "±0.25";
    case "S1 -3 dB bandwidth", specification = "≥"+specNumber(170e3,unit);
    case "S2 gain error", specification = "±0.10";
    case "S2 -3 dB bandwidth", specification = "≥"+specNumber(1.7e6,unit);
    case "INA gain error", specification = "±0.30";
    case "Gain flatness 0.05-150 Hz", specification = "≤0.001";
    case "INA -3 dB bandwidth", specification = "≥"+specNumber(170e3,unit);
    case "RLD loop UGF", specification = specNumber(1e3,unit)+"±"+specNumber(0.5e3,unit);
    case "RLD phase margin", specification = "≥95";
    case "Input CM suppression @ 60 Hz", specification = "≥54";
    case "Input CM suppression @ 150 Hz", specification = "≥51";
    case "RLD Swing Ratio", specification = "≤1.0";
    case "RLD Peak Current", specification = "≤"+specNumber(3.2e-9,unit);
    case "CM Interference Gain Change", specification = "±0.001";
    case "Input-referred noise 0.05-150 Hz", specification = "≤3.2";
    otherwise, specification = "";
end
end

function pass = strictSpecPass(parameter,value,unit)
baseValue = value*unitScaleToBase(unit);
switch string(parameter)
    case "Total current", pass = baseValue <= 6.2e-3;
    case "Total power", pass = baseValue <= 22e-3;
    case "Output CM error", pass = abs(baseValue) <= 40e-3;
    case "RLD DC error", pass = abs(baseValue) <= 30e-6;
    case "Input-referred offset", pass = abs(baseValue) <= 300e-6;
    case "S1 gain error", pass = baseValue >= -0.25 & baseValue <= 0.25;
    case "S1 -3 dB bandwidth", pass = baseValue >= 170e3;
    case "S2 gain error", pass = baseValue >= -0.10 & baseValue <= 0.10;
    case "S2 -3 dB bandwidth", pass = baseValue >= 1.7e6;
    case "INA gain error", pass = baseValue >= -0.30 & baseValue <= 0.30;
    case "Gain flatness 0.05-150 Hz", pass = baseValue <= 0.001;
    case "INA -3 dB bandwidth", pass = baseValue >= 170e3;
    case "RLD loop UGF", pass = baseValue >= 0.5e3 & baseValue <= 1.5e3;
    case "RLD phase margin", pass = baseValue >= 95;
    case "Input CM suppression @ 60 Hz", pass = baseValue >= 54;
    case "Input CM suppression @ 150 Hz", pass = baseValue >= 51;
    case "RLD Swing Ratio", pass = baseValue <= 1.0;
    case "RLD Peak Current", pass = baseValue <= 3.2e-9;
    case "CM Interference Gain Change", pass = baseValue >= -0.001 & baseValue <= 0.001;
    case "Input-referred noise 0.05-150 Hz", pass = baseValue <= 3.2e-6;
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
    fprintf('\nINA + RLD STRICT PVT SPECIFICATION: PASS (%d/%d corners)\n', ...
        nnz(cornerPass),numel(corners));
else
    failedCorners = corners(~cornerPass);
    warning('INA_RLD_Analyze:PvtSpecFailure', ...
        'INA + RLD strict PVT specification: FAIL (%d/%d corners): %s', ...
        nnz(cornerPass),numel(corners),strjoin(failedCorners,', '));
end
end

function m = analyzeRun(resultDir,process,caseName,electrode, ...
        expectedVdd_V,cfg)
files = runFiles(resultDir,process,caseName,electrode);
opData = readNumericFile(files.op,28);
m = analyzeOperatingPoint(opData);
if abs(m.vdd_V-expectedVdd_V) > cfg.vddTolerance_V
    error('INA_RLD_Analyze:SupplyMismatch', ...
        '%s reports AVDD = %.6g V; expected %.3f V.', ...
        files.op,m.vdd_V,expectedVdd_V);
end
m.diff = analyzeDifferential(readNumericFile(files.diff,11),cfg);
m.cm = analyzeCommonMode(readNumericFile(files.cmOff,13), ...
    readNumericFile(files.cmOn,13),cfg);
m.loop = analyzeRldLoop(readNumericFile(files.loop,11));
m.noise = analyzeNoise(readNumericFile(files.noise,3),cfg);
m.tran = analyzeTransient( ...
    readNumericFile(files.tran,20),cfg,m.vdd_V);
end

function files = runFiles(resultDir,process,caseName,electrode)
stem = sprintf('%s.%%s_%s_%s.txt',process,caseName,electrode);
files.op = fullfile(resultDir,sprintf(stem,'op'));
files.diff = fullfile(resultDir,sprintf(stem,'diff_ac'));
files.cmOff = fullfile(resultDir,sprintf(stem,'cm_off_ac'));
files.cmOn = fullfile(resultDir,sprintf(stem,'cm_on_ac'));
files.loop = fullfile(resultDir,sprintf(stem,'rld_loop_ac'));
files.noise = fullfile(resultDir,sprintf(stem,'noise'));
files.tran = fullfile(resultDir,sprintf(stem,'tran'));
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
m.rldDcError_V = median(data(:,19),'omitnan')-vref_V;
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
result.stage1GainError_pct = 100*(stage1Gain10_VV/60-1);
result.stage2Gain10_VV = stage2Gain10_VV;
result.stage2GainError_pct = 100*(stage2Gain10_VV/4-1);
result.stage1Bandwidth3dB_Hz = upperCrossing(f,stage1Gain_dB, ...
    20*log10(stage1Gain10_VV)-3,10);
result.stage2Bandwidth3dB_Hz = upperCrossing(f,stage2Gain_dB, ...
    20*log10(stage2Gain10_VV)-3,10);
result.gain10_dB = interpLogFrequency(f,totalGain_dB,10);
result.gain10_VV = interpLogFrequency(f,abs(total),10);
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
offDiff_dB = interpLogFrequency(fOff,magnitudeDb(off.outDiff),targets);
onDiff_dB = interpLogFrequency(fOn,magnitudeDb(on.outDiff),targets);
result.inputSuppression_dB = offInput_dB-onInput_dB;
result.cmToDiffReduction_dB = offDiff_dB-onDiff_dB;
end

function [f,result] = commonModeTransfers(data)
validateFrequency(data(:,1),'common-mode AC');
f = data(:,1);
source = complex(data(:,2),data(:,3));
result.inputCm = safeDivide(complex(data(:,6),data(:,7)),source);
result.outDiff = safeDivide(complex(data(:,10),data(:,11)),source);
end

function result = analyzeRldLoop(data)
[f,phase_deg,gain_dB] = loopTransfer(data);
firstFiniteGain = find(isfinite(gain_dB),1,'first');
if isempty(firstFiniteGain)
    result.lowFrequencyGain_dB = NaN;
else
    result.lowFrequencyGain_dB = gain_dB(firstFiniteGain);
end
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

function result = analyzeTransient(data,cfg,vdd_V)
t = data(:,1);
if any(~isfinite(t)) || any(diff(t) <= 0)
    error('INA_RLD_Analyze:TransientTime', ...
        'Transient time must be finite and strictly increasing.');
end
cmSource = data(:,2);
inputDiff = data(:,5);
rldOut = data(:,14);
outDiff = data(:,18);
rldCurrent = abs(data(:,19));
edges = detectCmStep(t,cmSource);
result.rldOutMin_V = min(rldOut,[],'omitnan');
result.rldOutMax_V = max(rldOut,[],'omitnan');
result.rldOutExcursion_V = result.rldOutMax_V-result.rldOutMin_V;
result.rldVppNorm_pct = 100*result.rldOutExcursion_V/300e-3;
result.rldRailHeadroom_V = min([rldOut; vdd_V-rldOut],[],'omitnan');
result.peakRldCurrent_A = max(abs(rldCurrent),[],'omitnan');
beforeRows = t >= edges.riseTime_s-cfg.transientPreStartGuard_s & ...
    t <= edges.riseTime_s-cfg.transientPreEndGuard_s;
result.gainBeforeInterference_VV = sineAmplitudeGain( ...
    t,inputDiff,outDiff,beforeRows,cfg.ecgFrequency_Hz);
duringRows = t >= edges.riseTime_s+cfg.transientDuringStartGuard_s & ...
    t <= edges.fallTime_s-cfg.transientDuringEndGuard_s;
result.gainDuringInterference_VV = sineAmplitudeGain( ...
    t,inputDiff,outDiff,duringRows,cfg.ecgFrequency_Hz);
if isfinite(result.gainBeforeInterference_VV) && ...
        result.gainBeforeInterference_VV ~= 0 && ...
        isfinite(result.gainDuringInterference_VV)
    result.gainChangeDuringInterference_pct = 100*( ...
        result.gainDuringInterference_VV/ ...
        result.gainBeforeInterference_VV-1);
else
    result.gainChangeDuringInterference_pct = NaN;
end
end

function gain_VV = sineAmplitudeGain(t,input,output,rows,frequency_Hz)
valid = rows & isfinite(t) & isfinite(input) & isfinite(output);
gain_VV = NaN;
if nnz(valid) < 4
    return;
end
omega = 2*pi*frequency_Hz;
design = [ones(nnz(valid),1) sin(omega*t(valid)) cos(omega*t(valid))];
inputCoefficient = design\input(valid);
outputCoefficient = design\output(valid);
inputAmplitude = hypot(inputCoefficient(2),inputCoefficient(3));
outputAmplitude = hypot(outputCoefficient(2),outputCoefficient(3));
if isfinite(inputAmplitude) && inputAmplitude > 0 && ...
        isfinite(outputAmplitude)
    gain_VV = outputAmplitude/inputAmplitude;
end
end

function values = metricsToRaw(m,rows,temperature_C,diffGainTarget_VV)
values = nan(size(rows,1),1);
for rowIndex = 1:size(rows,1)
    switch rows(rowIndex,1)
        case "AVDD", values(rowIndex) = m.vdd_V;
        case "Temperature", values(rowIndex) = temperature_C;
        case "S1 target gain", values(rowIndex) = 60;
        case "S2 target gain", values(rowIndex) = 4;
        case "INA target gain", values(rowIndex) = diffGainTarget_VV;
        case "Total current", values(rowIndex) = m.totalCurrent_A;
        case "Total power", values(rowIndex) = m.totalPower_W;
        case "Output CM error", values(rowIndex) = m.outCmError_V;
        case "RLD DC error", values(rowIndex) = m.rldDcError_V;
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
        case "RLD loop UGF", values(rowIndex) = m.loop.crossover_Hz;
        case "RLD phase margin", values(rowIndex) = m.loop.phaseMargin_deg;
        case "Input CM suppression @ 60 Hz", values(rowIndex) = m.cm.inputSuppression_dB(1);
        case "Input CM suppression @ 150 Hz", values(rowIndex) = m.cm.inputSuppression_dB(2);
        case "Input-referred noise 0.05-150 Hz", values(rowIndex) = m.noise.inputRms_V;
        case "RLD Swing Ratio"
            values(rowIndex) = m.tran.rldVppNorm_pct;
        case "RLD Peak Current"
            values(rowIndex) = m.tran.peakRldCurrent_A;
        case "CM Interference Gain Change"
            values(rowIndex) = m.tran.gainChangeDuringInterference_pct;
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

function edges = detectCmStep(t,source)
sampleCount = numel(t);
edgeRows = max(2,round(0.1*sampleCount));
lowLevel = median(source(1:edgeRows),'omitnan');
highLevel = max(source);
span = highLevel-lowLevel;
if ~isfinite(span) || span <= 0
    error('INA_RLD_Analyze:CmStep', ...
        'Transient CM source does not contain a positive step.');
end
midLevel = lowLevel+0.5*span;
riseIndex = find(source >= midLevel,1,'first');
if isempty(riseIndex)
    error('INA_RLD_Analyze:CmStep','CM step rise was not found.');
end
fallOffset = find(source(riseIndex+1:end) <= midLevel,1,'first');
if isempty(fallOffset)
    error('INA_RLD_Analyze:CmStep','CM step fall was not found.');
end
fallIndex = riseIndex+fallOffset;
edges.riseTime_s = t(riseIndex);
edges.fallTime_s = t(fallIndex);
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

function result = buildWorstCaseTable(rows,values,corners,rldPeakCurrent_A)
definitions = [
    "Total current",                            "Total current",                         "max"
    "Total power",                              "Total power",                           "max"
    "Output CM error",                          "Output CM error",                       "maxabs"
    "RLD DC error",                             "RLD DC error",                          "maxabs"
    "S1 gain",                                  "__S1_GAIN_AT_ERROR__",                 "linked"
    "S1 gain dB",                               "__S1_GAIN_DB_AT_ERROR__",              "linked"
    "S1 gain error",                            "S1 gain error",                         "maxabs"
    "S1 -3 dB bandwidth",                       "S1 -3 dB bandwidth",                    "min"
    "S2 gain",                                  "__S2_GAIN_AT_ERROR__",                 "linked"
    "S2 gain dB",                               "__S2_GAIN_DB_AT_ERROR__",              "linked"
    "S2 gain error",                            "S2 gain error",                         "maxabs"
    "S2 -3 dB bandwidth",                       "S2 -3 dB bandwidth",                    "min"
    "INA gain",                                 "__INA_GAIN_AT_ERROR__",                "linked"
    "INA gain dB",                              "__INA_GAIN_DB_AT_ERROR__",             "linked"
    "INA gain error",                           "INA gain error",                        "maxabs"
    "Gain flatness 0.05-150 Hz",                "Gain flatness 0.05-150 Hz",              "max"
    "INA -3 dB bandwidth",                      "INA -3 dB bandwidth",                    "min"
    "RLD loop UGF",                             "RLD loop UGF",                          "min"
    "RLD phase margin",                         "RLD phase margin",                      "min"
    "Input CM suppression @ 60 Hz",             "Input CM suppression @ 60 Hz",          "min"
    "Input CM suppression @ 150 Hz",            "Input CM suppression @ 150 Hz",         "min"
    "RLD Swing Ratio",                          "RLD Swing Ratio",                       "max"
    "RLD Peak Current",                         "__RLD_PEAK_CURRENT__",                  "max"
    "CM Interference Gain Change",               "CM Interference Gain Change",           "maxabs"
    "Input-referred noise 0.05-150 Hz",         "Input-referred noise 0.05-150 Hz",      "max"
];

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
    elseif sourceName == "__RLD_PEAK_CURRENT__"
        [unit(definitionIndex),candidates] = adaptValuesUnit("A",rldPeakCurrent_A);
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
        if definitions(definitionIndex,3) == "maxabs"
            selectedValue(definitionIndex) = abs(candidates(selectedIndex));
        else
            selectedValue(definitionIndex) = candidates(selectedIndex);
        end
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
            case "maxabs"
                [~,selectedIndex] = max(abs(candidates));
            otherwise
                error('INA_RLD_Analyze:WorstCaseMode','Unknown selection mode.');
        end
    end
    if definitions(definitionIndex,3) == "maxabs"
        selectedValue(definitionIndex) = abs(candidates(selectedIndex));
    else
        selectedValue(definitionIndex) = candidates(selectedIndex);
    end
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

function plotNominalResults(scriptDir,plotDir,nominalMetrics)
resultDir = fullfile(scriptDir,'nom.Result_txt');
balFiles = runFiles(resultDir,"nom","nom","bal");
misFiles = runFiles(resultDir,"nom","nom","mis");
selTransient = selTransientFile(resultDir,"nom","nom");
plotDifferentialAc(balFiles.diff,nominalMetrics{1},plotDir);
plotRldLoop(balFiles.loop,nominalMetrics{1},plotDir);
plotCmRejectionCombined(balFiles.cmOff,balFiles.cmOn, ...
    misFiles.cmOff,misFiles.cmOn,nominalMetrics{1},nominalMetrics{2},plotDir);
plotTransient(balFiles.tran,nominalMetrics{1},plotDir);
plotNoise(balFiles.noise,nominalMetrics{1},plotDir);
plotSelFunctionalCheck(selTransient,plotDir);
end

function plotDifferentialAc(balFile,metric,plotDir)
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
    'DisplayName','Stage 1: IN to SEO');
hold on;
semilogx(fBal,stage2_dB,'LineWidth',1.5, ...
    'DisplayName','Stage 2: SEO to OUT');
semilogx(fBal,total_dB,'LineWidth',1.5, ...
    'DisplayName','Total INA: IN to OUT');
yline(20*log10(60),'--','HandleVisibility','off');
yline(20*log10(4),'--','HandleVisibility','off');
yline(20*log10(240),'--','HandleVisibility','off');
addCursor(metric.diff.stage1Bandwidth3dB_Hz, ...
    20*log10(metric.diff.stage1Gain10_VV)-3, ...
    sprintf('-3 dB: %s', ...
    char(frequencyText(metric.diff.stage1Bandwidth3dB_Hz))));
addCursor(metric.diff.stage2Bandwidth3dB_Hz, ...
    20*log10(metric.diff.stage2Gain10_VV)-3, ...
    sprintf('-3 dB: %s', ...
    char(frequencyText(metric.diff.stage2Bandwidth3dB_Hz))));
cursorFrequencies_Hz = [0.05 60 150];
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
legend('Location','best');
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
plot(time_ms,intDiff_mV,'LineWidth',1.5, ...
    'DisplayName','INT differential');
hold on;
plot(time_ms,extDiff_mV,'--','LineWidth',1.5, ...
    'DisplayName','EXT differential');
addSelectorSwitchGuide(switchTime_ms,false);
ylabel('Differential voltage (mV)');
legend('Location','best');
stylePlot('', '(b) Available INT and EXT Signals');

outputAxes = nexttile(layout);
plot(time_ms,outDiff_mV,'LineWidth',2.0, ...
    'DisplayName','OUT differential');
addSelectorSwitchGuide(switchTime_ms,false);
ylabel('Differential voltage (mV)');
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

function plotCmRejectionCombined(balOffFile,balOnFile,misOffFile,misOnFile, ...
    balMetric,misMetric,plotDir)
[fBal,balSuppression_dB] = inputCmSuppressionCurve(balOffFile,balOnFile);
[fOff,off] = commonModeTransfers(readNumericFile(misOffFile,13));
[fOn,on] = commonModeTransfers(readNumericFile(misOnFile,13));
offGain_dB = magnitudeDb(off.outDiff);
fig = figure;
layout = tiledlayout(fig,2,1);

topAxes = nexttile(layout);
semilogx(fBal,balSuppression_dB,'LineWidth',1.5, ...
    'DisplayName','Balanced electrodes');
hold on;
cursorFrequencies_Hz = [60 150];
for frequencyIndex = 1:2
    frequency_Hz = cursorFrequencies_Hz(frequencyIndex);
    addCursorLine(frequency_Hz,balMetric.cm.inputSuppression_dB(frequencyIndex), ...
        sprintf('%g Hz: %.2f dB',frequency_Hz, ...
        balMetric.cm.inputSuppression_dB(frequencyIndex)));
end
xlim([0.01 1e4]);
ylabel('CM suppression (dB)');
legend('Location','best');
stylePlot('', '(a) Input Common-Mode Suppression - NOM, BAL');

bottomAxes = nexttile(layout);
semilogx(fOff,offGain_dB,'LineWidth',1.5,'DisplayName','RLD OFF - MIS');
hold on;
semilogx(fOn,magnitudeDb(on.outDiff),'--','LineWidth',1.5, ...
    'DisplayName','RLD ON - MIS');
for frequencyIndex = 1:2
    frequency_Hz = cursorFrequencies_Hz(frequencyIndex);
    markerGain_dB = interpLogFrequency(fOff,offGain_dB,frequency_Hz);
    addCursorLine(frequency_Hz,markerGain_dB, ...
        sprintf('%g Hz: %.2f dB',frequency_Hz, ...
        misMetric.cm.cmToDiffReduction_dB(frequencyIndex)));
end
xlim([0.01 1e4]);
ylabel('CM-to-differential gain (dB)');
legend('Location','best');
stylePlot('Frequency (Hz)', '(b) CM-to-Differential Conversion - NOM, MIS');
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

function plotTransient(balFile,metric,plotDir)
bal = readNumericFile(balFile,20);
tBal_ms = bal(:,1)*1e3;
edges = detectCmStep(bal(:,1),bal(:,2));
stepTimes_ms = [edges.riseTime_s edges.fallTime_s]*1e3;
gainBal_VV = metric.tran.gainBeforeInterference_VV;
if ~isfinite(gainBal_VV), gainBal_VV = metric.diff.gain10_VV; end
fig = figure;
layout = tiledlayout(3,1);
commonModeAxes = nexttile(layout);
inputCmError_mV = (bal(:,4)-metric.vref_V)*1e3;
outputCmError_uV = (bal(:,17)-metric.vref_V)*1e6;
yyaxis left;
plot(tBal_ms,inputCmError_mV,'LineWidth',1.5, ...
    'DisplayName','INA input CM error');
hold on;
addTimeGuides(stepTimes_ms);
yline(0,'--','HandleVisibility','off');
ylabel('Input CM error (mV)');
text(mean(stepTimes_ms),0.85*max(abs(inputCmError_mV)), ...
    '+300 mV CM interference','HorizontalAlignment','center', ...
    'VerticalAlignment','top','HandleVisibility','off');
yyaxis right;
plot(tBal_ms,outputCmError_uV,'LineWidth',1.3, ...
    'DisplayName','Output CM error');
yline(0,'--','HandleVisibility','off');
ylabel('Output CM error (\muV)');
legend('Location','best');
stylePlot('', 'Input and Output Common-Mode Error');

rldAxes = nexttile(layout);
yyaxis left;
rldDeviation_mV = (bal(:,14)-metric.vref_V)*1e3;
plot(tBal_ms,rldDeviation_mV,'LineWidth',1.5, ...
    'DisplayName','RLD output - VREF');
hold on;
addTimeGuides(stepTimes_ms);
yline(0,'--','HandleVisibility','off');
ylabel('RLD output deviation (mV)');
yyaxis right;
plot(tBal_ms,bal(:,19)*1e9,'LineWidth',1.2, ...
    'Color',[0.8500 0.3250 0.0980], 'DisplayName','|I_{RLD}|');
ylabel('|I_{RLD}| (nA)');
legend('Location','best');
addMetricBox({ ...
    sprintf('RLD Swing Ratio = %.3f %%',metric.tran.rldVppNorm_pct); ...
    sprintf('RLD Peak Current = %.3f nA', ...
    metric.tran.peakRldCurrent_A*1e9)});
stylePlot('', 'RLD Response');

differentialAxes = nexttile(layout);
plot(tBal_ms,bal(:,5)*1e3,'LineWidth',1.5, ...
    'DisplayName','VIN differential');
hold on;
plot(tBal_ms,bal(:,18)/gainBal_VV*1e3,'--','LineWidth',1.5, ...
    'DisplayName','VOUT differential / pre-interference gain');
addTimeGuides(stepTimes_ms);
signalLimit_mV = max(abs([bal(:,5); bal(:,18)/gainBal_VV]))*1e3;
if ~isfinite(signalLimit_mV) || signalLimit_mV <= 0
    signalLimit_mV = 1;
end
ylim([-1.1*signalLimit_mV 2.0*signalLimit_mV]);
ylabel('Differential signal (mV)');
legend('Location','northeast');
addMetricBox({sprintf('CM Interference Gain Change = %.3g %%', ...
    metric.tran.gainChangeDuringInterference_pct)});
stylePlot('Time (ms)','ECG Differential Integrity');
linkaxes([commonModeAxes rldAxes differentialAxes],'x');
sgtitle('INA + RLD Common-Mode Interference Response - NOM, BAL');
savePlot(fig,plotDir,'NOM.INA_RLD_transient.png');
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

function addTimeGuides(times_ms)
for time_ms = times_ms
    xline(time_ms,'--','HandleVisibility','off');
end
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
    [rows(rowIndex,2),scaledValues(rowIndex,:)] = ...
        adaptValuesUnit(rows(rowIndex,2),rawValues(rowIndex,:));
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
