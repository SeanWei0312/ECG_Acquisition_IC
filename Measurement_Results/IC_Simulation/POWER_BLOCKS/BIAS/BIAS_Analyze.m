function BIAS_Analyze
% BIAS_ANALYZE Verify PVT and Monte Carlo results.
% Specs, measurements, reports, and plots are defined below.

%% Setup and output directories

clc;
close all;

scriptDir = fileparts(mfilename('fullpath'));
plotDir = fullfile(scriptDir,'Plots');
reportDir = fullfile(scriptDir,'Reports');
if ~isfolder(plotDir), mkdir(plotDir); end
if ~isfolder(reportDir), mkdir(reportDir); end
cfg = analysisConfig();
rows = reportRows();
pvt = analyzePvt(scriptDir,rows,cfg);

startupSummary = buildStartupSummary(pvt.processes,pvt.conditions, ...
    pvt.conditionTemp_C,pvt.conditionVdd_V,pvt.startup_us,pvt.startupAnalyzed, ...
    pvt.missingTransient,pvt.invalidTransient);
selectorWorst = buildSelGlobal(pvt.processes,pvt.conditions,pvt.conditionTemp_C, ...
    pvt.conditionVdd_V,pvt.selRunMax_V,rows.selector);
worstCase = buildGlobalPvt(pvt.processes,pvt.dcValues,pvt.dcTemp_C,pvt.dcVdd_V);
summaryTable = buildComparisonTable(rows.normal,pvt.normalColumns,pvt.normalValues);
startupTable = buildStartupTable(pvt.processes,pvt.conditions,pvt.startup_us);
startupSummaryTable = buildStartupSummaryTable(startupSummary, ...
    numel(pvt.processes)*numel(pvt.conditions));
dcTable = buildDcTable(rows.dc,pvt.processes,pvt.dcValues,pvt.dcTemp_C,pvt.dcVdd_V);
referenceTable = buildComparisonTable(rows.reference,pvt.processes,pvt.referenceValues);

printVerification(pvt,startupSummary,cfg);
fprintf('\nBIAS COMPARISON SUMMARY\n\n');
comparison = buildLpfComparison(pvt,cfg);
printSummaryTable(comparison,pvt.normalColumns);
fprintf('\nBIAS FULL-PVT WORST CASE\n\n');
terminalWorst = buildWorstSummary(worstCase,selectorWorst,startupSummary,pvt,cfg);
terminalWorst = compactWorstTable(terminalWorst,cfg);
printWorstSummary(terminalWorst);
writetable(comparison,fullfile(reportDir,'BIAS_comparison_report.csv'));
writetable(terminalWorst,fullfile(reportDir,'BIAS_worst_case_report.csv'));

writetable(summaryTable,fullfile(reportDir,'BIAS_table_report.csv'));
writetable(startupTable,fullfile(reportDir,'BIAS_startup_report.csv'));
writetable(startupSummaryTable,fullfile(reportDir,'BIAS_startup_summary.csv'));
writetable(buildLocationReportTable(selectorWorst),fullfile(reportDir,'BIAS_sel_report.csv'));
writetable(dcTable,fullfile(reportDir,'BIAS_dc2d_report.csv'));
writetable(buildLocationReportTable(worstCase),fullfile(reportDir,'BIAS_global_worst_case.csv'));
writetable(referenceTable,fullfile(reportDir,'BIAS_reference_report.csv'));
writetable(buildReferenceSweepTable(pvt,cfg),fullfile(reportDir,'BIAS_reference_sweeps.csv'));

if isempty(pvt.nomTransient)
    warning('BIAS_Analyze:NoNomTransientPlots', ...
        'NOM/tran_nom is unavailable; transient plots were skipped.');
else
    plotNominalTransient(pvt.nomTransient,pvt.nomTransientAnalysis,plotDir,cfg);
end
if isempty(pvt.nomDc)
    warning('BIAS_Analyze:NoNomDcPlots', ...
        'NOM DC2D data is unavailable; temperature/VDD plots were skipped.');
else
    plotNominalDc(pvt.nomDc,plotDir,cfg);
end
runMcSection(scriptDir,plotDir,reportDir,cfg);
end

%% Configuration and report definitions

function [processes,conditions,tokens,temp_C,vdd_V] = sweepDefinition
processes = {'NOM','FF','SS','FS','SF'};
conditions = {'NOM','VL','VH','TL','TH','TLVL','THVH','TLVH','THVL'};
tokens = {'nom','vl','vh','tl','th','tlvl','thvh','tlvh','thvl'};
temp_C = [27 27 27 -40 125 -40 125 -40 125];
vdd_V = [3.3 3.0 3.6 3.3 3.3 3.0 3.6 3.6 3.0];
end

function cfg = analysisConfig
cfg.ibiasTarget_A = 40e-6;
cfg.startupMinimumFinal_A = 0.1*cfg.ibiasTarget_A;
cfg.vddRampStart_s = 100e-6;
cfg.plateauTrimFraction = 0.10;
cfg.expectedTranEnd_s = 10e-3;
cfg.expectedDcTemp_C = (-40:125).';
cfg.expectedDcVdd_V = (3.0:0.01:3.6).';
cfg.expectedDcRows = numel(cfg.expectedDcTemp_C)* ...
    numel(cfg.expectedDcVdd_V);
cfg.tcVdd_V = 3.3;
cfg.lineTemp_C = 27;
cfg.mcRequestedRuns = 200;
cfg.ibiasLimits_A = [30e-6 50e-6];
cfg.mirrorErrorMax_pct = 1;
cfg.tcSupplies_V = [3.0 3.3 3.6];
cfg.lineTemperatures_C = [-40 27 125];
end

function rows = reportRows
rows.normal = [
    "Ibias",         "uA"
    "Ibias error",   "%"
    "IRS",           "uA"
    "Mirror error",  "%"
    "BP",            "V"
    "IMST",          "fA"
    "MST margin",    "V"
    "IDD",           "uA"
    "Power",         "uW"
    "Startup time",  "us"
];
rows.dc = [
    "Ibias minimum",                "uA"
    "Ibias maximum",                "uA"
    "Ibias error minimum",          "%"
    "Ibias error maximum",          "%"
    "BP minimum",                   "V"
    "BP maximum",                   "V"
    "Maximum |mirror error|",       "%"
    "Maximum IMST",                 "fA"
    "Minimum MST margin",           "V"
    "IDD minimum",                  "uA"
    "IDD maximum",                  "uA"
    "Power maximum",                "uW"
];
rows.reference = [
    "Temperature coefficient",  "ppm/C"
    "Temperature variation",    "%"
    "Line regulation",          "%/V"
    "Supply variation",         "%"
];
rows.selector = [
    "Maximum |BP INT SEL error|"
    "Maximum |BP EXT SEL error|"
];
end

%% PVT measurement extraction

function pvt = analyzePvt(scriptDir,rows,cfg)
[processes,conditions,conditionTokens,conditionTemp_C,conditionVdd_V] = ...
    sweepDefinition();
normalColumns = [processes conditions(2:5)];

normalParameter = rows.normal(:,1);
dcParameter = rows.dc(:,1);
referenceParameter = rows.reference(:,1);
selParameter = rows.selector;

nProcesses = numel(processes);
nConditions = numel(conditions);
normalValues = nan(numel(normalParameter),numel(normalColumns));
startup_us = nan(nProcesses,nConditions);
startupAnalyzed = false(nProcesses,nConditions);
transientValues = nan(numel(normalParameter),nProcesses,nConditions);
selRunMax_V = nan(numel(selParameter),nProcesses,nConditions);
broadcastTransientCount = 0;
nomTransient = [];
nomTransientAnalysis = struct([]);
missingTransient = strings(nProcesses,nConditions);
invalidTransient = strings(nProcesses,nConditions);

for processIndex = 1:nProcesses
    process = processes{processIndex};
    resultDir = fullfile(scriptDir,[process '.Result_txt']);
    for conditionIndex = 1:nConditions
        condition = conditions{conditionIndex};
        token = conditionTokens{conditionIndex};
        fileLabel = sprintf('%s.tran_%s.txt',process,token);
        dataFile = fullfile(resultDir,fileLabel);
        if ~isfile(dataFile)
            missingTransient(processIndex,conditionIndex) = ...
                sprintf('%s/%s',process,condition);
            continue;
        end

        try
            data = readTransientData(dataFile,fileLabel, ...
                conditionVdd_V(conditionIndex),cfg);
            analysis = analyzeTransient(data,cfg);
            transientValues(:,processIndex,conditionIndex) = analysis.normalValues;
            startup_us(processIndex,conditionIndex) = ...
                analysis.startupTime_s*1e6;
            startupAnalyzed(processIndex,conditionIndex) = true;
            selRunMax_V(:,processIndex,conditionIndex) = ...
                analysis.selMax_V;
            broadcastTransientCount = broadcastTransientCount+ ...
                analysis.hasBroadcastDeviceData;
            if conditionIndex == 1
                normalValues(:,processIndex) = analysis.normalValues;
            elseif processIndex == 1 && conditionIndex <= 5
                normalValues(:,nProcesses+conditionIndex-1) = ...
                    analysis.normalValues;
            end
            if processIndex == 1 && conditionIndex == 1
                nomTransient = data;
                nomTransientAnalysis = analysis;
            end
        catch exception
            if isBiasAnalysisError(exception)
                invalidTransient(processIndex,conditionIndex) = ...
                    sprintf('%s/%s',process,condition);
                warning('BIAS_Analyze:InvalidTransient', ...
                    '%s is invalid: %s',fileLabel,exception.message);
            else
                rethrow(exception);
            end
        end
    end
end

missingTransient = reshape(missingTransient.',[],1);
missingTransient = missingTransient(missingTransient ~= "");
invalidTransient = reshape(invalidTransient.',[],1);
invalidTransient = invalidTransient(invalidTransient ~= "");
if ~isempty(missingTransient)
    warning('BIAS_Analyze:MissingTransient', ...
        'Missing transient results: %s.',strjoin(missingTransient,', '));
end
if broadcastTransientCount > 0
    warning('BIAS_Analyze:BroadcastTransientDeviceData', ...
        ['IRS/IMST/VGS/VTH are constant exports in %d of %d transient ' ...
         'runs. They are used only as final operating-point scalars; ' ...
         'IMST is not plotted as a waveform for those runs.'], ...
        broadcastTransientCount,nProcesses*nConditions);
end

dcValues = nan(numel(dcParameter),nProcesses);
dcTemp_C = nan(size(dcValues));
dcVdd_V = nan(size(dcValues));
referenceValues = nan(numel(referenceParameter),nProcesses);
tcSweeps = nan(numel(cfg.tcSupplies_V),nProcesses);
lineSweeps = nan(numel(cfg.lineTemperatures_C),nProcesses);
nomDc = [];
missingDc = strings(nProcesses,1);
dcPointCount = zeros(nProcesses,1);
dcComplete = false(nProcesses,1);

for processIndex = 1:nProcesses
    process = processes{processIndex};
    fileLabel = sprintf('%s.dc2d.txt',process);
    dataFile = fullfile(scriptDir,[process '.Result_txt'],fileLabel);
    if ~isfile(dataFile)
        missingDc(processIndex) = process;
        continue;
    end

    try
        data = readDcData(dataFile,fileLabel,cfg);
        analysis = analyzeDc(data,cfg);
        dcPointCount(processIndex) = size(data,1);
        dcComplete(processIndex) = size(data,1) == cfg.expectedDcRows && ...
            coordinateSetsMatch(unique(data(:,1)),cfg.expectedDcTemp_C,1e-8) && ...
            coordinateSetsMatch(unique(data(:,2)),cfg.expectedDcVdd_V,5e-6);
        dcValues(:,processIndex) = analysis.values;
        dcTemp_C(:,processIndex) = analysis.temp_C;
        dcVdd_V(:,processIndex) = analysis.vdd_V;
        referenceValues(:,processIndex) = analysis.referenceValues;
        for slice = 1:numel(cfg.tcSupplies_V)
            sliceCfg = cfg; sliceCfg.tcVdd_V = cfg.tcSupplies_V(slice);
            tcSweeps(slice,processIndex) = temperatureMetrics(data(:,1),data(:,2),data(:,5),sliceCfg);
        end
        for slice = 1:numel(cfg.lineTemperatures_C)
            sliceCfg = cfg; sliceCfg.lineTemp_C = cfg.lineTemperatures_C(slice);
            lineSweeps(slice,processIndex) = supplyMetrics(data(:,1),data(:,2),data(:,5),sliceCfg);
        end
        if processIndex == 1
            nomDc = data;
        end
    catch exception
        if isBiasAnalysisError(exception)
            warning('BIAS_Analyze:InvalidDc', ...
                '%s is invalid: %s',fileLabel,exception.message);
        else
            rethrow(exception);
        end
    end
end

missingDc = missingDc(missingDc ~= "");
if ~isempty(missingDc)
    warning('BIAS_Analyze:MissingDc', ...
        'Missing DC2D results: %s.',strjoin(missingDc,', '));
end
pvt.processes = processes;
pvt.transientValues = transientValues;
pvt.dcPointCount = dcPointCount;
pvt.dcComplete = dcComplete;
pvt.conditions = conditions;
pvt.normalColumns = normalColumns;
pvt.conditionTemp_C = conditionTemp_C;
pvt.conditionVdd_V = conditionVdd_V;
pvt.normalValues = normalValues;
pvt.startup_us = startup_us;
pvt.startupAnalyzed = startupAnalyzed;
pvt.missingTransient = missingTransient;
pvt.invalidTransient = invalidTransient;
pvt.selRunMax_V = selRunMax_V;
pvt.dcValues = dcValues;
pvt.dcTemp_C = dcTemp_C;
pvt.dcVdd_V = dcVdd_V;
pvt.referenceValues = referenceValues;
pvt.tcSweeps = tcSweeps;
pvt.lineSweeps = lineSweeps;
pvt.nomTransient = nomTransient;
pvt.nomTransientAnalysis = nomTransientAnalysis;
pvt.nomDc = nomDc;
end

function result = analyzeTransient(data,cfg)
% IRS is the core reference; Ibias is the MIRROR output at IB.
time_s = data(:,1); sel_V = data(:,3); ibias_A = abs(data(:,7));
edges = detectSelectionPlateaus(time_s,sel_V);
initialSettledRows = finalFractionRows(time_s,time_s(1), ...
    edges.riseStart_s,cfg.plateauTrimFraction);
externalCenterRows = trimmedPlateauRows(time_s,edges.riseEnd_s, ...
    edges.fallStart_s,cfg.plateauTrimFraction);
finalCenterRows = trimmedPlateauRows(time_s,edges.fallEnd_s, ...
    time_s(end),cfg.plateauTrimFraction);
if ~any(initialSettledRows) || ~any(externalCenterRows) || ~any(finalCenterRows)
    error('BIAS_Analyze:SelectionWindows','Settled selector regions contain no samples.');
end
steady = data(initialSettledRows,:); steadyMean = mean(steady,1);
ibiasFinal_A = mean(abs(steady(:,7))); irsFinal_A = mean(abs(steady(:,8)));
imstFinal_A = mean(abs(steady(:,9)));
mstMargin_V = mean(steady(:,11)-steady(:,10));
mirrorError_pct = safePercent(ibiasFinal_A-irsFinal_A,irsFinal_A);
startupCrossing_s = permanentStartupBandEntry(time_s,ibias_A,ibiasFinal_A, ...
    edges.riseStart_s,cfg.startupMinimumFinal_A);
startupTime_s = NaN;
if isfinite(startupCrossing_s) && startupCrossing_s >= cfg.vddRampStart_s
    startupTime_s = startupCrossing_s-cfg.vddRampStart_s;
end
intRows = initialSettledRows | finalCenterRows;
result.selMax_V = [max(abs(data(intRows,5)-data(intRows,4))); ...
    max(abs(data(externalCenterRows,5)-data(externalCenterRows,6)))];
result.normalValues = [ibiasFinal_A*1e6; ...
    100*(ibiasFinal_A-cfg.ibiasTarget_A)/cfg.ibiasTarget_A; irsFinal_A*1e6; ...
    mirrorError_pct; steadyMean(5); imstFinal_A*1e15; mstMargin_V; ...
    steadyMean(12)*1e6; steadyMean(13)*1e6; startupTime_s*1e6];
result.startupTime_s = startupTime_s; result.startupCrossing_s = startupCrossing_s;
result.startupThreshold_A = 0.9*ibiasFinal_A;
result.firstSelTime_s = edges.riseStart_s; result.secondSelTime_s = edges.fallStart_s;
result.imstWaveformUsable = isSweepVector(data(:,9));
result.hasBroadcastDeviceData = ~isSweepVector(data(:,8)) || ...
    ~result.imstWaveformUsable || ~isSweepVector(data(:,10)) || ~isSweepVector(data(:,11));
end

function result = analyzeDc(data,cfg)
temperature_C = data(:,1); vdd_V = data(:,2);
bp_V = data(:,4); ibias_A = data(:,5); irs_A = data(:,6);
mirrorError_pct = data(:,7); imst_A = data(:,8); mstMargin_V = data(:,9);
idd_A = data(:,10); power_W = data(:,11);
computedMirror = 100*(ibias_A-irs_A)./irs_A;
if any(abs(computedMirror-mirrorError_pct) > 1e-6)
    error('BIAS_Analyze:MirrorExport','Exported mirror error does not match Ibias/IRS.');
end
ibiasError_pct = 100*(ibias_A-cfg.ibiasTarget_A)/cfg.ibiasTarget_A;
quantities = [ibias_A*1e6 ibias_A*1e6 ibiasError_pct ibiasError_pct ...
    bp_V bp_V mirrorError_pct abs(imst_A)*1e15 mstMargin_V ...
    idd_A*1e6 idd_A*1e6 power_W*1e6];
operations = {'min','max','min','max','min','max','maxabs','max','min','min','max','max'};
values = nan(12,1); tempAt_C = nan(12,1); vddAt_V = nan(12,1);
for k = 1:12
    [values(k),tempAt_C(k),vddAt_V(k)] = extremeWithLocation( ...
        quantities(:,k),temperature_C,vdd_V,operations{k});
end
[tc_ppm_C,tempVariation_pct] = temperatureMetrics(temperature_C,vdd_V,ibias_A,cfg);
[lineReg_pct_V,supplyVariation_pct] = supplyMetrics(temperature_C,vdd_V,ibias_A,cfg);
result.values = values; result.temp_C = tempAt_C; result.vdd_V = vddAt_V;
result.referenceValues = [tc_ppm_C; tempVariation_pct; lineReg_pct_V; supplyVariation_pct];
end

%% PVT tables and terminal output

function t = buildComparisonTable(rows,columns,values)
t = table(rows(:,1),rows(:,2),'VariableNames',{'Parameter','Unit'});
t = [t array2table(formatReportValues(values),'VariableNames',cellstr(string(columns)))];
end

function t = buildStartupTable(processes,conditions,startup_us)
t = table(string(processes(:)),repmat("us",numel(processes),1), ...
    'VariableNames',{'Process','Unit'});
t = [t array2table(formatReportValues(startup_us),'VariableNames',cellstr(string(conditions)))];
end

function t = buildStartupSummaryTable(summary,totalTests)
parameter = ["Worst startup time"; "Startup failures"];
value = [string(formatOne(summary.worstTime_us)); string(summary.failureCount)];
unit = ["us"; "count"];
process = [summary.process; ""]; condition = [summary.condition; ""];
temp = [string(formatOne(summary.temp_C)); ""];
vdd = [string(formatOne(summary.vdd_V)); ""];
total = [""; string(summary.completedCount)];
parameter = [parameter; "Startup coverage"; "Verification status"];
value = [value; string(summary.completedCount)+"/"+string(totalTests); summary.status];
unit = [unit; "cases"; ""];
process = [process; ""; ""]; condition = [condition; ""; ""];
temp = [temp; ""; ""]; vdd = [vdd; ""; ""];
total = [total; string(totalTests); ""];
if summary.missingCount > 0 || summary.invalidCount > 0
    parameter = [parameter; "Startup files missing"; "Startup files invalid"];
    value = [value; string(summary.missingCount); string(summary.invalidCount)];
    unit = [unit; "count"; "count"];
    process = [process; ""; ""]; condition = [condition; ""; ""];
    temp = [temp; ""; ""]; vdd = [vdd; ""; ""];
    total = [total; string(totalTests); string(totalTests)];
end
t = table(parameter,value,unit,process,condition,temp,vdd,total, ...
    'VariableNames',{'Parameter','Value','Unit','Process','Condition','Temp_C','VDD_V','Total'});
end

function t = buildDcTable(rows,processes,values,temp_C,vdd_V)
names = strings(1,3*numel(processes));
formatted = strings(size(rows,1),numel(names));
for k = 1:numel(processes)
    process = string(processes{k});
    columns = 3*k-2:3*k;
    names(columns) = [process process+"_Temp_C" process+"_VDD_V"];
    formatted(:,columns) = formatReportValues([values(:,k) temp_C(:,k) vdd_V(:,k)]);
end
t = table(rows(:,1),rows(:,2),'VariableNames',{'Parameter','Unit'});
t = [t array2table(formatted,'VariableNames',cellstr(names))];
end

function t = buildLocationReportTable(t)
for field = ["Value" "Temp_C" "VDD_V"]
    t.(field) = formatReportValues(t.(field));
end
end

function printSummaryTable(t,columns)
w = max(42,max(strlength(t.Parameter))+2);
fprintf('%-*s %-8s',w,'Parameter','Unit');
hasSpec = ismember('Spec',t.Properties.VariableNames);
if hasSpec, fprintf(' %-14s','Spec'); end
for k = 1:numel(columns), fprintf(' %13s',columns{k}); end
fprintf('\n%s\n',repmat('-',1,w+9+15*hasSpec+14*numel(columns)));
for k = 1:height(t)
    if t.Unit(k) == ""
        fprintf('\n%-*s\n',w,upper(t.Parameter(k)));
        continue;
    end
    fprintf('%-*s %-8s',w,t.Parameter(k),t.Unit(k));
    if hasSpec, fprintf(' %-14s',t.Spec(k)); end
    for c = 1:numel(columns), fprintf(' %13s',t.(columns{c})(k)); end
    fprintf('\n');
end
end

function t = buildWorstSummary(worst,selector,startup,pvt,cfg)
% Display-only assembly: retain full diagnostic tables in the CSV exports.
t = worst([1 2 4:9],:);
t.Value = formatReportValues(t.Value);
t.Temp_C = formatReportValues(t.Temp_C);
t.VDD_V = formatReportValues(t.VDD_V);
t.Spec = [">=30"; "<=50"; ""; ""; ""; ">0"; ""; ""];
t.Condition = repmat("DC corner",height(t),1);
t.Parameter = ["Ibias minimum"; "Ibias maximum"; "BP minimum"; "BP maximum"; ...
    "Max. absolute mirror error"; "MST margin minimum"; "IDD maximum"; "Power maximum"];
t = t(:,{'Parameter','Unit','Spec','Value','Process','Condition','Temp_C','VDD_V'});
rowIndex = height(t);
extra = array2table(strings(8+height(selector),width(t)), ...
    'VariableNames',t.Properties.VariableNames);
t = [t; extra];
rowIndex = rowIndex+1;
t(rowIndex,:) = {"Startup time maximum","us","",string(formatOne(startup.worstTime_us)), ...
    startup.process,startup.condition,string(formatOne(startup.temp_C)), ...
    string(formatOne(startup.vdd_V))};
total = numel(pvt.processes)*numel(pvt.conditions);
rowIndex = rowIndex+1;
t(rowIndex,:) = {"Startup coverage","cases","", ...
    string(startup.completedCount)+"/"+string(total),"","Completed exports","",""};
rowIndex = rowIndex+1;
t(rowIndex,:) = {"Startup failures","count","0", ...
    string(startup.failureCount)+"/"+string(startup.completedCount),"","Completed cases","",""};
rowIndex = rowIndex+1;
t(rowIndex,:) = {"Missing results","count","0",string(startup.missingCount),"","","",""};
rowIndex = rowIndex+1;
t(rowIndex,:) = {"Invalid results","count","0",string(startup.invalidCount),"","","",""};
rowIndex = rowIndex+1;
t(rowIndex,:) = {"Verification status","","PASS",startup.status,"","Startup / selector","",""};
if startup.missingCount > 0 || startup.invalidCount > 0
    warning('BIAS_Analyze:StartupCoverage', ...
        ['Startup coverage: %d missing and %d invalid files out of %d. ' ...
        'Startup and selector extrema apply only to completed cases.'], ...
        startup.missingCount,startup.invalidCount,total);
end
labels = ["BP INT selector error max."; "BP EXT selector error max."];
for k = 1:height(selector)
    rowIndex = rowIndex+1;
    t(rowIndex,:) = {labels(k),selector.Unit(k),"", ...
        string(formatOne(selector.Value(k))),selector.Process(k),selector.Condition(k), ...
        string(formatOne(selector.Temp_C(k))),string(formatOne(selector.VDD_V(k)))};
end
for row = [1 3]
    if row == 1, sweeps = pvt.tcSweeps; else, sweeps = pvt.lineSweeps; end
    [value,index] = acrossProcessExtreme(abs(sweeps(:)).','max');
    process = "";
    fixedValue = NaN;
    if isfinite(value)
        [slice,processIndex] = ind2sub(size(sweeps),index);
        process = string(pvt.processes{processIndex});
        if row == 1, fixedValue = cfg.tcSupplies_V(slice);
        else, fixedValue = cfg.lineTemperatures_C(slice); end
    end
    if row == 1
        parameter = "Temperature coefficient max."; unit = "ppm/C";
        condition = "Temperature sweep"; temp = "-40 to 125";
        vdd = string(formatOne(fixedValue));
    else
        parameter = "Line regulation maximum"; unit = "%/V";
        condition = "Supply sweep"; temp = string(formatOne(fixedValue));
        vdd = "3.0 to 3.6";
    end
    rowIndex = rowIndex+1;
    t(rowIndex,:) = {parameter,unit,"",string(formatOne(value)),process,condition,temp,vdd};
end
end

function t = buildReferenceSweepTable(pvt,cfg)
n = numel(pvt.tcSweeps)+numel(pvt.lineSweeps);
parameter = strings(n,1); process = strings(n,1); unit = strings(n,1);
fixedVdd = nan(n,1); fixedTemp = nan(n,1); value = nan(n,1);
k = 0;
for p = 1:numel(pvt.processes)
    for s = 1:numel(cfg.tcSupplies_V)
        k = k+1; parameter(k) = "Temperature coefficient"; process(k) = pvt.processes{p};
        unit(k) = "ppm/C"; fixedVdd(k) = cfg.tcSupplies_V(s); value(k) = pvt.tcSweeps(s,p);
    end
    for s = 1:numel(cfg.lineTemperatures_C)
        k = k+1; parameter(k) = "Line regulation"; process(k) = pvt.processes{p};
        unit(k) = "%/V"; fixedTemp(k) = cfg.lineTemperatures_C(s); value(k) = pvt.lineSweeps(s,p);
    end
end
t = table(parameter,process,unit,fixedVdd,fixedTemp,value, ...
    'VariableNames',{'Parameter','Process','Unit','FixedVDD_V','FixedTemp_C','Value'});
end

function printWorstSummary(t)
w = max(42,max(strlength(t.Parameter))+2);
fprintf('%-*s %-8s %-14s %13s %-10s\n',w,'Parameter','Unit','Spec','Value','Corner');
fprintf('%s\n',repmat('-',1,w+49));
for k = 1:height(t)
    fprintf('%-*s %-8s %-14s %13s %-10s\n',w, ...
        t.Parameter(k),t.Unit(k),t.Spec(k),t.Value(k),t.Corner(k));
end
end

function t = buildLpfComparison(pvt,cfg)
parameter = ["SET CONDITIONS"; "AVDD"; "Temperature"; "Ibias target"; ...
    "OPERATING POINT"; "Ibias"; "Total current"; "Total power"; ...
    "BIAS"; "BP"; "Mirror error"; "MST margin"; "Startup time"; ...
    "REFERENCE QUALITY"; "Temperature coefficient"; "Line regulation"];
unit = [""; "V"; "C"; "uA"; ""; "uA"; "uA"; "uW"; ""; "V"; "%"; "V"; "us"; ...
    ""; "ppm/C"; "%/V"];
spec = strings(size(parameter)); spec(6) = "40±10"; spec(12) = ">0";
spec(11) = "±"+string(cfg.mirrorErrorMax_pct);
values = nan(numel(parameter),numel(pvt.normalColumns));
values(2,:) = [repmat(cfg.tcVdd_V,1,5) pvt.conditionVdd_V(2:5)];
values(3,:) = [repmat(cfg.lineTemp_C,1,5) pvt.conditionTemp_C(2:5)];
values(4,:) = cfg.ibiasTarget_A*1e6;
values([6 7 8 10 11 12 13],:) = pvt.normalValues([1 8 9 5 4 7 10],:);
% Sweep-derived metrics belong to process columns, not individual VL/VH/TL/TH points.
values(15:16,1:numel(pvt.processes)) = pvt.referenceValues([1 3],:);
t = buildComparisonTable([parameter unit],pvt.normalColumns,values);
t.Spec = spec;
for k = 1:numel(pvt.normalColumns)
    t.(pvt.normalColumns{k})(unit == "") = "";
    if k > numel(pvt.processes), t.(pvt.normalColumns{k})(15:16) = ""; end
end
t = t(:,[{'Parameter','Unit','Spec'} pvt.normalColumns]);
end

function t = compactWorstTable(t,cfg)
% Match comparison metrics; retain all diagnostic extrema in detailed CSVs.
limits = find(ismember(t.Parameter,["Ibias minimum" "Ibias maximum"]));
deviation = abs(str2double(t.Value(limits))-cfg.ibiasTarget_A*1e6);
deviation(~isfinite(deviation)) = -Inf;
[~,which] = max(deviation);
names = ["IDD maximum"; "Power maximum"; "BP minimum"; ...
    "Max. absolute mirror error"; "MST margin minimum"; "Startup time maximum"; ...
    "Temperature coefficient max."; "Line regulation maximum"];
indices = zeros(numel(names)+1,1); indices(1) = limits(which);
for k = 1:numel(names), indices(k+1) = find(t.Parameter == names(k),1); end
t = t(indices,:);
corner = strings(height(t),1);
for k = 1:height(t)
    if contains(t.Condition(k),"sweep")
        if t.Condition(k) == "Temperature sweep"
            fixed = str2double(t.VDD_V(k)); tag = "";
            if fixed < 3.3, tag = "VL"; elseif fixed > 3.3, tag = "VH"; end
        else
            fixed = str2double(t.Temp_C(k)); tag = "";
            if fixed < 27, tag = "TL"; elseif fixed > 27, tag = "TH"; end
        end
        corner(k) = t.Process(k)+tag+" sweep";
    elseif t.Process(k) == ""
        corner(k) = "ALL";
    else
        vdd = str2double(t.VDD_V(k)); temp = str2double(t.Temp_C(k));
        voltageTag = ""; temperatureTag = "";
        if vdd < 3.3, voltageTag = "VL"; elseif vdd > 3.3, voltageTag = "VH"; end
        if temp < 27, temperatureTag = "TL"; elseif temp > 27, temperatureTag = "TH"; end
        corner(k) = t.Process(k)+voltageTag+temperatureTag;
    end
end
t.Parameter = ["Ibias"; "Total current"; "Total power"; "BP"; "Mirror error"; ...
    "MST margin"; "Startup time"; "Temperature coefficient"; "Line regulation"];
t.Spec(1) = "40±10";
t.Spec(5) = "±"+string(cfg.mirrorErrorMax_pct);
t.Corner = corner;
t = t(:,{'Parameter','Unit','Spec','Value','Corner'});
end

function printVerification(pvt,startup,cfg)
lower = cfg.ibiasLimits_A(1)*1e6; upper = cfg.ibiasLimits_A(2)*1e6;
current = squeeze(pvt.transientValues(1,:,:)); margin = squeeze(pvt.transientValues(7,:,:));
mirrorError = squeeze(pvt.transientValues(4,:,:));
pass = pvt.startupAnalyzed & isfinite(pvt.startup_us) & ...
    current >= lower & current <= upper & margin > 0 & ...
    isfinite(mirrorError) & abs(mirrorError) <= cfg.mirrorErrorMax_pct;
status = "PASS";
if any(pvt.startupAnalyzed & ~pass,'all'), status = "FAIL";
elseif startup.status ~= "PASS", status = "INCOMPLETE"; end
fprintf('\nBIAS FULL-PVT VERIFICATION: %s (%d/%d corners)\n',status,nnz(pass),numel(pass));
dcPass = pvt.dcValues(1,:) >= lower & pvt.dcValues(2,:) <= upper & ...
    pvt.dcValues(9,:) > 0 & pvt.dcValues(7,:) <= cfg.mirrorErrorMax_pct;
dcStatus = "PASS";
if any(pvt.dcPointCount > 0 & ~dcPass(:)), dcStatus = "FAIL";
elseif ~all(pvt.dcComplete), dcStatus = "INCOMPLETE"; end
fprintf('BIAS 2-D DC-PVT VERIFICATION: %s\n',dcStatus);
end

function summary = buildStartupSummary(processes,conditions,temp_C,vdd_V, ...
        startup_us,analyzed,missingFiles,invalidFiles)
valid = analyzed & isfinite(startup_us);
summary.worstTime_us = NaN;
summary.process = "Not available";
summary.condition = "Not available";
summary.temp_C = NaN;
summary.vdd_V = NaN;
if any(valid,'all')
    validRows = find(valid);
    [summary.worstTime_us,localIndex] = max(startup_us(valid));
    [processIndex,conditionIndex] = ind2sub(size(valid), ...
        validRows(localIndex));
    summary.process = string(processes{processIndex});
    summary.condition = string(conditions{conditionIndex});
    summary.temp_C = temp_C(conditionIndex);
    summary.vdd_V = vdd_V(conditionIndex);
end
summary.failureCount = nnz(analyzed & ~isfinite(startup_us));
summary.completedCount = nnz(analyzed);
summary.missingCount = numel(missingFiles);
summary.invalidCount = numel(invalidFiles);
if summary.failureCount > 0
    summary.status = "FAIL";
elseif summary.missingCount > 0 || summary.invalidCount > 0 || ...
        summary.completedCount < numel(analyzed)
    summary.status = "INCOMPLETE";
else
    summary.status = "PASS";
end
end

function resultTable = buildSelGlobal(processes,conditions,temp_C,vdd_V, ...
        runMax_V,parameter)
finiteValues = runMax_V(isfinite(runMax_V));
if isempty(finiteValues) || max(finiteValues) < 1e-6
    scale = 1e9;
    unitText = "nV";
else
    scale = 1e6;
    unitText = "uV";
end
nMetric = size(runMax_V,1);
value = nan(nMetric,1);
processText = strings(nMetric,1);
conditionText = strings(nMetric,1);
selectedTemp_C = nan(nMetric,1);
selectedVdd_V = nan(nMetric,1);
for metricIndex = 1:nMetric
    candidates = reshape(runMax_V(metricIndex,:,:), ...
        numel(processes),numel(conditions));
    validRows = find(isfinite(candidates));
    if isempty(validRows)
        continue;
    end
    [value_V,localIndex] = max(candidates(validRows));
    [processIndex,conditionIndex] = ind2sub(size(candidates), ...
        validRows(localIndex));
    value(metricIndex) = value_V*scale;
    processText(metricIndex) = processes{processIndex};
    conditionText(metricIndex) = conditions{conditionIndex};
    selectedTemp_C(metricIndex) = temp_C(conditionIndex);
    selectedVdd_V(metricIndex) = vdd_V(conditionIndex);
end
unit = repmat(unitText,nMetric,1);
resultTable = table(parameter,unit,value,processText,conditionText, ...
    selectedTemp_C,selectedVdd_V,'VariableNames', ...
    {'Parameter','Unit','Value','Process','Condition','Temp_C','VDD_V'});
end

function resultTable = buildGlobalPvt(processes,values,temp_C,vdd_V)
parameter = [
    "Ibias minimum"
    "Ibias maximum"
    "Worst |Ibias error|"
    "BP minimum"
    "BP maximum"
    "Maximum |mirror error|"
    "Minimum MST margin"
    "Maximum IDD"
    "Maximum power"
];
unit = ["uA";"uA";"%";"V";"V";"%";"V";"uA";"uW"];
selectedValue = nan(numel(parameter),1);
selectedProcess = strings(numel(parameter),1);
selectedTemp_C = nan(numel(parameter),1);
selectedVdd_V = nan(numel(parameter),1);

bestMagnitude = -Inf;
bestProcess = NaN;
bestSourceRow = NaN;
for candidateRow = [3 4]
    for processIndex = 1:numel(processes)
        candidate = values(candidateRow,processIndex);
        if isfinite(candidate) && abs(candidate) > bestMagnitude
            bestMagnitude = abs(candidate);
            bestProcess = processIndex;
            bestSourceRow = candidateRow;
        end
    end
end
if isfinite(bestMagnitude)
    selectedValue(3) = bestMagnitude;
    selectedProcess(3) = processes{bestProcess};
    selectedTemp_C(3) = temp_C(bestSourceRow,bestProcess);
    selectedVdd_V(3) = vdd_V(bestSourceRow,bestProcess);
end

resultRows = [1 2 4 5 6 7 8 9];
sourceRows = [1 2 5 6 7 9 11 12];
operations = {'min','max','min','max','max','min','max','max'};
for mappingIndex = 1:numel(resultRows)
    resultRow = resultRows(mappingIndex);
    sourceRow = sourceRows(mappingIndex);
    [candidateValue,processIndex] = acrossProcessExtreme( ...
        values(sourceRow,:),operations{mappingIndex});
    if isfinite(candidateValue)
        selectedValue(resultRow) = candidateValue;
        selectedProcess(resultRow) = processes{processIndex};
        selectedTemp_C(resultRow) = temp_C(sourceRow,processIndex);
        selectedVdd_V(resultRow) = vdd_V(sourceRow,processIndex);
    end
end

resultTable = table(parameter,unit,selectedValue,selectedProcess, ...
    selectedTemp_C,selectedVdd_V,'VariableNames', ...
    {'Parameter','Unit','Value','Process','Temp_C','VDD_V'});
end





%% Monte Carlo analysis and reporting

function runMcSection(scriptDir,plotDir,reportDir,cfg)
defs = mcDefinitions(cfg);
modes = ["MM" "GL" "FULL"]; results = cell(3,1);
for k = 1:numel(modes)
    results{k} = summarizeMc(scriptDir,modes(k),defs,cfg);
    printMcSummary(results{k});
    writetable(results{k}.table,fullfile(reportDir,modes(k)+"_MC_Summary.csv"));
end
runTable = table(modes',cellfun(@(r)r.requested,results), ...
    cellfun(@(r)r.valid,results),cellfun(@(r)r.failed,results), ...
    cellfun(@(r)r.overallYield,results), ...
    'VariableNames',{'Mode','Requested','Valid','Failed','OverallYield_pct'});
writetable(runTable,fullfile(reportDir,'MC_Run_Summary.csv'));
plotMcHistogram(results,defs,1,plotDir,'Fig_MC_01_Ibias_Histogram.png',cfg);
plotMcHistogram(results,defs,10,plotDir,'Fig_MC_02_Startup_Histogram.png',cfg);
end

function defs = mcDefinitions(cfg)
rows = reportRows;
defs.names = [rows.normal(:,1); "Startup success"];
defs.units = [rows.normal(:,2); ""];
defs.specs = strings(size(defs.names));
defs.specs(1) = "40±10";
defs.specs(4) = "±"+string(cfg.mirrorErrorMax_pct);
defs.specs(7) = ">0";
defs.specs(11) = "PASS";
defs.required = strlength(defs.specs) > 0;
end

function r = summarizeMc(scriptDir,mode,defs,cfg)
token = lower(mode); resultDir = fullfile(scriptDir,token+".Result_txt");
summaryFile = fullfile(resultDir,token+".mc_summary.txt");
values = nan(cfg.mcRequestedRuns,numel(defs.names));
if ~isfile(summaryFile)
    warning('BIAS_Analyze:MissingMcSummary','%s MC not simulated: %s',mode,summaryFile);
else
    raw = readMcNumeric(summaryFile,8);
    ids = raw(:,1);
    if any(ids < 1 | ids > cfg.mcRequestedRuns | ids ~= round(ids)) || ...
            numel(unique(ids)) ~= numel(ids)
        error('BIAS_Analyze:McRunIds','Invalid or duplicate MC IDs in %s.',summaryFile);
    end
    for k = 1:numel(ids)
        run = ids(k);
        startupFile = fullfile(resultDir,token+".startup_"+run+".txt");
        if ~isfile(startupFile), continue; end
        try
            startup = readMcNumeric(startupFile,3);
            if any(diff(startup(:,1)) <= 0) || startup(end,1) < cfg.expectedTranEnd_s-1e-9
                error('BIAS_Analyze:McStartupCoverage','Startup trace does not cover 0–10 ms.');
            end
            if startup(1,1) > 1e-9 || abs(startup(1,2)) > 1e-6 || ...
                    abs(startup(end,2)-3.3) > 5e-3
                error('BIAS_Analyze:McStartupSupply','Startup trace must ramp from 0 V to 3.3 V.');
            end
            tail = startup(:,1) >= 0.9*cfg.expectedTranEnd_s;
            finalCurrent = mean(abs(startup(tail,3)));
            entry = permanentStartupBandEntry(startup(:,1),abs(startup(:,3)), ...
                finalCurrent,Inf,cfg.startupMinimumFinal_A);
            success = isfinite(entry) && entry >= cfg.vddRampStart_s && ...
                all(abs(startup(tail,3)) >= cfg.ibiasLimits_A(1) & ...
                    abs(startup(tail,3)) <= cfg.ibiasLimits_A(2));
            row = raw(k,:); ibias = row(2); irs = row(3);
            startupTime_us = NaN;
            if isfinite(entry), startupTime_us = (entry-cfg.vddRampStart_s)*1e6; end
            values(run,:) = [ibias*1e6, ...
                100*(ibias-cfg.ibiasTarget_A)/cfg.ibiasTarget_A,irs*1e6, ...
                safePercent(ibias-irs,irs),row(4),row(5)*1e15,row(6), ...
                row(7)*1e6,row(8)*1e6,startupTime_us,success];
        catch exception
            if ~isBiasAnalysisError(exception), rethrow(exception); end
            warning('BIAS_Analyze:InvalidMcStartup','%s run %d: %s',mode,run,exception.message);
        end
    end
end
valid = all(isfinite(values),2) & values(:,11) == 1;
pass = true(size(values));
pass(:,1) = values(:,1) >= cfg.ibiasLimits_A(1)*1e6 & values(:,1) <= cfg.ibiasLimits_A(2)*1e6;
pass(:,4) = abs(values(:,4)) <= cfg.mirrorErrorMax_pct;
pass(:,7) = values(:,7) > 0;
pass(:,11) = values(:,11) == 1;
stats = nan(numel(defs.names),7); yields = nan(numel(defs.names),1);
for k = 1:numel(defs.names)
    x = values(valid,k);
    if ~isempty(x)
        mu = mean(x); sigma = std(x,0);
        stats(k,:) = [min(x) mu-3*sigma mu-sigma mu mu+sigma mu+3*sigma max(x)];
    end
    if defs.required(k), yields(k) = 100*nnz(valid & pass(:,k))/cfg.mcRequestedRuns; end
end
r.mode = mode; r.values = values; r.validMask = valid;
r.requested = cfg.mcRequestedRuns; r.valid = nnz(valid); r.failed = r.requested-r.valid;
r.overallYield = 100*nnz(valid & all(pass(:,defs.required),2))/r.requested;
r.table = table(defs.names,defs.units,defs.specs,stats(:,1),stats(:,2),stats(:,3), ...
    stats(:,4),stats(:,5),stats(:,6),stats(:,7),yields, ...
    'VariableNames',{'Parameter','Unit','Spec','Min','MeanMinus3Sigma', ...
    'MeanMinusSigma','Mean','MeanPlusSigma','MeanPlus3Sigma','Max','Yield_pct'});
% Keep diagnostic values internally; publish only independent MC metrics.
r.table = r.table([1 8 5 4 7 10 11],:);
r.table.Parameter(r.table.Parameter == "IDD") = "Total current";
end

function printMcSummary(r)
fprintf('\n%s MONTE CARLO SUMMARY\n',r.mode);
fprintf('Requested: %d  Valid: %d  Failed: %d  Overall yield: %.2f%%\n', ...
    r.requested,r.valid,r.failed,r.overallYield);
t = r.table; w = max(46,max(strlength(t.Parameter))+2);
fprintf('%-*s %-8s %-12s %10s %10s %10s %10s %10s %10s %10s %9s\n', ...
    w,'Parameter','Unit','Spec','Min','μ-3σ','μ-σ','Mean','μ+σ','μ+3σ','Max','Yield');
for k = 1:height(t)
    yieldText = '';
    if isfinite(t.Yield_pct(k)), yieldText = sprintf('%.2f',t.Yield_pct(k)); end
    fprintf('%-*s %-8s %-12s %10s %10s %10s %10s %10s %10s %10s %9s\n', ...
        w,t.Parameter(k),t.Unit(k),t.Spec(k),formatOne(t.Min(k)), ...
        formatOne(t.MeanMinus3Sigma(k)),formatOne(t.MeanMinusSigma(k)), ...
        formatOne(t.Mean(k)),formatOne(t.MeanPlusSigma(k)), ...
        formatOne(t.MeanPlus3Sigma(k)),formatOne(t.Max(k)),yieldText);
end
end

%% Plots and annotations

function plotMcHistogram(results,defs,index,plotDir,fileName,cfg)
samples = cellfun(@(r)r.values(r.validMask,index),results,'UniformOutput',false);
allValues = vertcat(samples{:});
if isempty(allValues), return; end
centerValues = samples{3};
if isempty(centerValues), centerValues = allValues; end
center = mean(centerValues); sigma = std(centerValues,0);
span = max(abs(allValues-center)); span = max(span,1e-6);
edges = linspace(center-1.1*span,center+1.1*span,21);
fig = figure; hold on; colors = lines(3);
for k = 1:3
    if isempty(samples{k}), continue; end
    counts = 100*histcounts(samples{k},edges)/numel(samples{k});
    stairs(edges,[counts 0],'LineWidth',1.5,'Color',colors(k,:), ...
        'DisplayName',results{k}.mode);
end
if ~isempty(samples{3})
    for n = [-3 -1 0 1 3]
        xline(center+n*sigma,':','HandleVisibility','off');
    end
end
if index == 1
    for limit = cfg.ibiasLimits_A*1e6, xline(limit,'--','HandleVisibility','off'); end
end
ylabel('Samples (%)'); legend('Location','best'); xlim([edges(1) edges(end)]);
stylePlot(defs.names(index)+" ("+defs.units(index)+")", ...
    "BIAS "+defs.names(index)+" Distribution - MM / GL / FULL");
savePlot(fig,plotDir,fileName);
end

function plotNominalTransient(data,analysis,plotDir,cfg)
time_ms = data(:,1)*1e3;
startupEnd_s = min(4e-3,analysis.firstSelTime_s);
startupRows = data(:,1) >= 0 & data(:,1) <= startupEnd_s;

fig = figure;
if analysis.imstWaveformUsable
    yyaxis left;
end
plot(time_ms(startupRows),abs(data(startupRows,7))*1e6, ...
    'LineWidth',1.5,'DisplayName','I_{BIAS}');
hold on;
yline(analysis.startupThreshold_A*1e6,'--','90% threshold', ...
    'HandleVisibility','off');
ylabel('I_{BIAS} (uA)');
if analysis.imstWaveformUsable
    yyaxis right;
    plot(time_ms(startupRows),abs(data(startupRows,9))*1e15, ...
        'LineWidth',1.5,'DisplayName','I_{MST}');
    ylabel('|I_{MST}| (fA)');
else
    xLimits = xlim;
    yLimits = ylim;
    text(xLimits(1)+0.52*(xLimits(2)-xLimits(1)), ...
        yLimits(1)+0.12*(yLimits(2)-yLimits(1)), ...
        'IMST unavailable: constant export', ...
        'HorizontalAlignment','center');
end
if isfinite(analysis.startupCrossing_s)
    xline(analysis.startupCrossing_s*1e3,'--','90% startup', ...
        'HandleVisibility','off');
end
xlim([0 startupEnd_s*1e3]);
stylePlot('Time (ms)','BIAS Startup Current - NOM');
legend('Location','best');
savePlot(fig,plotDir,'NOM_BIAS_STARTUP.png');

fig = figure;
plot(time_ms(startupRows),data(startupRows,2), ...
    'LineWidth',1.5,'DisplayName','AVDD');
hold on;
plot(time_ms(startupRows),data(startupRows,4), ...
    'LineWidth',1.5,'DisplayName','BPINT');
plot(time_ms(startupRows),data(startupRows,5), ...
    'LineWidth',1.5,'DisplayName','BP');
xlim([0 startupEnd_s*1e3]);
ylabel('Voltage (V)');
stylePlot('Time (ms)','BIAS Startup Voltage - NOM');
legend('Location','best');
savePlot(fig,plotDir,'NOM_BIAS_STARTUP_VOLTAGE.png');

selectionRows = data(:,1) >= 0 & data(:,1) <= cfg.expectedTranEnd_s;
fig = figure;
selectorLines = gobjects(4,1);
selectorLines(1) = plot(time_ms(selectionRows),data(selectionRows,3), ...
    'LineWidth',1.5,'DisplayName','SEL');
hold on;
selectorLines(2) = plot(time_ms(selectionRows),data(selectionRows,4), ...
    'LineWidth',1.5,'DisplayName','BPINT');
selectorLines(3) = plot(time_ms(selectionRows),data(selectionRows,5), ...
    'LineWidth',1.5,'DisplayName','BP');
selectorLines(4) = plot(time_ms(selectionRows),data(selectionRows,6), ...
    'LineWidth',1.5,'DisplayName','BPEXT');
addSelectionGuides(analysis.firstSelTime_s*1e3, ...
    analysis.secondSelTime_s*1e3,cfg.expectedTranEnd_s*1e3);
ylabel('Voltage (V)');
stylePlot('Time (ms)','BP Internal / External Selection - NOM');
legend(selectorLines,{'SEL','BPINT','BP','BPEXT'},'Location','best','Visible','on');

savePlot(fig,plotDir,'NOM_BIAS_SEL.png');
end

function addSelectionGuides(firstEdge_ms,secondEdge_ms,endTime_ms)
xline(firstEdge_ms,'--','HandleVisibility','off');
xline(secondEdge_ms,'--','HandleVisibility','off');
xlim([0 endTime_ms]);
axisLimits = ylim;
labelY = axisLimits(1)+0.10*(axisLimits(2)-axisLimits(1));
text(firstEdge_ms/2,labelY,'INT','HorizontalAlignment','center');
text(mean([firstEdge_ms secondEdge_ms]),labelY,'EXT', ...
    'HorizontalAlignment','center');
text(mean([secondEdge_ms endTime_ms]),labelY,'INT', ...
    'HorizontalAlignment','center');
end

function plotNominalDc(data,plotDir,cfg)
temperature_C = data(:,1);
vdd_V = data(:,2);
ibias_uA = data(:,5)*1e6;

fig = figure;
hold on;
for targetVdd_V = [3.0 3.3 3.6]
    rows = abs(vdd_V-targetVdd_V) <= 5e-4;
    rowIndices = find(rows);
    [plotTemp_C,order] = sort(temperature_C(rows));
    plot(plotTemp_C,ibias_uA(rowIndices(order)), ...
        'LineWidth',1.5,'DisplayName', ...
        sprintf('VDD = %.1f V',targetVdd_V));
end
ylabel('I_{BIAS} (uA)');
stylePlot('Temperature (C)','BIAS Current vs Temperature - NOM');
legend('Location','best');
savePlot(fig,plotDir,'NOM_BIAS_TEMP.png');

fig = figure;
hold on;
for targetTemp_C = [-40 27 125]
    rows = abs(temperature_C-targetTemp_C) <= 1e-8;
    rowIndices = find(rows);
    [plotVdd_V,order] = sort(vdd_V(rows));
    plot(plotVdd_V,ibias_uA(rowIndices(order)), ...
        'LineWidth',1.5,'DisplayName', ...
        sprintf('T = %.0f C',targetTemp_C));
end
xlim([cfg.expectedDcVdd_V(1) cfg.expectedDcVdd_V(end)]);
ylabel('I_{BIAS} (uA)');
stylePlot('VDD (V)','BIAS Current vs Supply - NOM');
legend('Location','best');
savePlot(fig,plotDir,'NOM_BIAS_VDD.png');

[temperatureAxis_C,~,temperatureIndex] = unique(temperature_C);
[vddAxis_V,~,vddIndex] = unique(vdd_V);
ibiasError_pct = 100*(data(:,5)-cfg.ibiasTarget_A)/cfg.ibiasTarget_A;
errorGrid_pct = accumarray([temperatureIndex vddIndex],ibiasError_pct, ...
    [numel(temperatureAxis_C) numel(vddAxis_V)],@mean,NaN);

fig = figure;
imagesc(vddAxis_V,temperatureAxis_C,errorGrid_pct);
axis xy tight;
colorLimit_pct = max(abs(errorGrid_pct),[],'all');
if isfinite(colorLimit_pct) && colorLimit_pct > 0
    clim([-colorLimit_pct colorLimit_pct]);
    contourStep_pct = max(1,ceil(colorLimit_pct/5));
    contourLevels_pct = (-floor(colorLimit_pct/contourStep_pct): ...
        floor(colorLimit_pct/contourStep_pct))*contourStep_pct;
    hold on;
    heatmapAxes = gca;
    contourColor = heatmapAxes.XColor;
    contourOutlineColor = heatmapAxes.Color;
    contour(vddAxis_V,temperatureAxis_C,errorGrid_pct, ...
        contourLevels_pct,'LineColor',contourOutlineColor, ...
        'LineWidth',2.5);
    [contourMatrix,contourLines] = contour(vddAxis_V,temperatureAxis_C, ...
        errorGrid_pct,contourLevels_pct,'LineColor',contourColor, ...
        'LineWidth',1.25);
    clabel(contourMatrix,contourLines,'Color',contourColor, ...
        'FontSize',11,'FontWeight','bold','LabelSpacing',280);
end
heatmapColorMap = 0.70*turbo(256);
colormap(heatmapColorMap);
colorScale = colorbar;
colorScale.Label.String = 'I_{BIAS} error (%)';
xlabel('VDD (V)');
ylabel('Temperature (C)');
title('BIAS Current Error vs Temperature and Supply - NOM');
box on;
savePlot(fig,plotDir,'NOM_BIAS_2D.png');
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

%% File input and validation

function data = readMcNumeric(file,columns)
opts = detectImportOptions(file,'FileType','text','Delimiter',{' ',sprintf('\t')}, ...
    'ConsecutiveDelimitersRule','join','LeadingDelimitersRule','ignore');
opts = setvartype(opts,'double'); opts.DataLines = [1 Inf]; opts.VariableNamesLine = 0;
data = readmatrix(file,opts); data = data(~all(isnan(data),2),:);
validateNumericMatrix(data,columns,file);
end

function data = readTransientData(dataFile,fileLabel,expectedVdd_V,cfg)
data = readmatrix(dataFile,'FileType','text');
validateNumericMatrix(data,13,fileLabel);
time_s = data(:,1);
if any(diff(time_s) <= 0)
    error('BIAS_Analyze:TimeOrder', ...
        '%s time must be strictly increasing.',fileLabel);
end
timeTolerance_s = max(1e-12,100*eps(cfg.expectedTranEnd_s));
if time_s(1) > timeTolerance_s || ...
        time_s(end) < cfg.expectedTranEnd_s-timeTolerance_s
    error('BIAS_Analyze:TimeCoverage', ...
        '%s must cover 0 to %.3f ms.', ...
        fileLabel,cfg.expectedTranEnd_s*1e3);
end
finalRows = time_s >= time_s(end)-0.05*(time_s(end)-time_s(1));
finalVdd_V = mean(data(finalRows,2));
if abs(finalVdd_V-expectedVdd_V) > 5e-3
    error('BIAS_Analyze:TransientCondition', ...
        '%s settles to %.6g V; expected %.3f V.', ...
        fileLabel,finalVdd_V,expectedVdd_V);
end
end

function data = readDcData(dataFile,fileLabel,cfg)
data = readmatrix(dataFile,'FileType','text');
validateNumericMatrix(data,11,fileLabel);
if size(data,1) ~= cfg.expectedDcRows
    warning('BIAS_Analyze:DcRowCount', ...
        '%s has %d rows; expected %d.', ...
        fileLabel,size(data,1),cfg.expectedDcRows);
end
if size(unique(data(:,1:2),'rows'),1) ~= size(data,1)
    error('BIAS_Analyze:DuplicateDcPoint', ...
        '%s contains duplicate Temp/VDD coordinates.',fileLabel);
end
temperatures = unique(data(:,1));
supplies = unique(data(:,2));
if ~coordinateSetsMatch(temperatures,cfg.expectedDcTemp_C,1e-8) || ...
        ~coordinateSetsMatch(supplies,cfg.expectedDcVdd_V,5e-6) || ...
        numel(temperatures)*numel(supplies) ~= size(data,1)
    warning('BIAS_Analyze:IncompleteDcGrid', ...
        '%s does not contain the complete expected grid.',fileLabel);
end
end

function validateNumericMatrix(data,columnCount,fileLabel)
if ~isnumeric(data) || isempty(data) || size(data,2) ~= columnCount
    error('BIAS_Analyze:ColumnCount', ...
        '%s must contain exactly %d numeric columns; found %d.', ...
        fileLabel,columnCount,size(data,2));
end
if any(~isfinite(data),'all')
    error('BIAS_Analyze:NonfiniteData', ...
        '%s contains nonfinite values.',fileLabel);
end
end

function matches = coordinateSetsMatch(actual,expected,tolerance)
matches = numel(actual) == numel(expected) && ...
    all(abs(actual(:)-expected(:)) <= tolerance);
end

function tf = isBiasAnalysisError(exception)
tf = startsWith(exception.identifier,'BIAS_Analyze:');
end

%% Numerical helpers

function edges = detectSelectionPlateaus(time_s,sel_V)
selLow_V = min(sel_V);
selHigh_V = max(sel_V);
if selHigh_V-selLow_V < 0.1
    error('BIAS_Analyze:SelectionAmplitude', ...
        'SEL does not contain distinct low and high plateaus.');
end
span_V = selHigh_V-selLow_V;
lowLimit_V = selLow_V+1e-3*span_V;
highLimit_V = selHigh_V-1e-3*span_V;
riseDeparture = find(sel_V > lowLimit_V,1,'first');
if isempty(riseDeparture) || riseDeparture == 1
    error('BIAS_Analyze:SelectionSequence', ...
        'SEL must contain an INT to EXT to INT sequence.');
end
riseEndOffset = find(sel_V(riseDeparture+1:end) >= highLimit_V,1,'first');
if isempty(riseEndOffset)
    error('BIAS_Analyze:SelectionSequence', ...
        'SEL never reaches the EXT plateau.');
end
riseEnd = riseDeparture+riseEndOffset;
fallDepartureOffset = find(sel_V(riseEnd+1:end) < highLimit_V,1,'first');
if isempty(fallDepartureOffset)
    error('BIAS_Analyze:SelectionSequence', ...
        'SEL does not contain a complete EXT plateau.');
end
fallDeparture = riseEnd+fallDepartureOffset;
fallEndOffset = find(sel_V(fallDeparture+1:end) <= lowLimit_V,1,'first');
if isempty(fallEndOffset)
    error('BIAS_Analyze:SelectionSequence', ...
        'SEL does not return to the INT plateau.');
end
fallEnd = fallDeparture+fallEndOffset;
edges.riseStart_s = time_s(riseDeparture-1);
edges.riseEnd_s = time_s(riseEnd);
edges.fallStart_s = time_s(fallDeparture-1);
edges.fallEnd_s = time_s(fallEnd);
if edges.riseEnd_s <= edges.riseStart_s || ...
        edges.fallStart_s <= edges.riseEnd_s || ...
        edges.fallEnd_s <= edges.fallStart_s
    error('BIAS_Analyze:SelectionSequence', ...
        'Detected selector plateau order is invalid.');
end
end

function rows = finalFractionRows(time_s,startTime_s,endTime_s,fraction)
windowStart_s = endTime_s-fraction*(endTime_s-startTime_s);
rows = time_s >= windowStart_s & time_s < endTime_s;
end

function rows = trimmedPlateauRows(time_s,startTime_s,endTime_s,fraction)
duration_s = endTime_s-startTime_s;
rows = time_s >= startTime_s+fraction*duration_s & ...
    time_s <= endTime_s-fraction*duration_s;
end

function crossingTime_s = permanentStartupBandEntry( ...
        time_s,ibias_A,ibiasFinal_A,endTime_s,minimumFinal_A)
crossingTime_s = NaN;
if ~isfinite(ibiasFinal_A) || ibiasFinal_A <= minimumFinal_A
    return;
end
lower_A = 0.9*ibiasFinal_A;
upper_A = 1.1*ibiasFinal_A;
rows = find(time_s < endTime_s);
if numel(rows) < 2
    return;
end
regionTime_s = time_s(rows);
regionCurrent_A = ibias_A(rows);
outsideBand = regionCurrent_A < lower_A | regionCurrent_A > upper_A;
if outsideBand(end)
    return;
end
lastOutside = find(outsideBand,1,'last');
if isempty(lastOutside)
    crossingTime_s = regionTime_s(1);
    return;
end
if lastOutside == numel(regionTime_s)
    return;
end
if regionCurrent_A(lastOutside) < lower_A
    boundary_A = lower_A;
else
    boundary_A = upper_A;
end
crossingTime_s = interpolateThreshold( ...
    regionTime_s(lastOutside:lastOutside+1), ...
    regionCurrent_A(lastOutside:lastOutside+1),boundary_A);
end

function crossing = interpolateThreshold(timePair,signalPair,threshold)
delta = signalPair(2)-signalPair(1);
if delta == 0
    crossing = timePair(2);
else
    crossing = timePair(1)+(threshold-signalPair(1))* ...
        (timePair(2)-timePair(1))/delta;
end
end

function usable = isSweepVector(signal)
usable = any(signal ~= signal(1));
end

function [value,temp_C,vdd_V] = extremeWithLocation( ...
        quantity,temperature_C,supply_V,operation)
value = NaN;
temp_C = NaN;
vdd_V = NaN;
valid = isfinite(quantity) & isfinite(temperature_C) & isfinite(supply_V);
if ~any(valid)
    return;
end
sourceRows = find(valid);
candidate = quantity(valid);
switch operation
    case 'min'
        [value,localIndex] = min(candidate);
    case 'max'
        [value,localIndex] = max(candidate);
    case 'maxabs'
        [value,localIndex] = max(abs(candidate));
    otherwise
        error('BIAS_Analyze:ExtremeOperation', ...
            'Unknown extreme operation %s.',operation);
end
selectedRow = sourceRows(localIndex);
temp_C = temperature_C(selectedRow);
vdd_V = supply_V(selectedRow);
end

function [tc_ppm_C,variation_pct] = temperatureMetrics( ...
        temperature_C,vdd_V,ibias_A,cfg)
tc_ppm_C = NaN;
variation_pct = NaN;
rows = abs(vdd_V-cfg.tcVdd_V) <= 5e-4;
sliceTemp_C = temperature_C(rows);
sliceCurrent_A = ibias_A(rows);
if numel(sliceTemp_C) ~= numel(cfg.expectedDcTemp_C) || ...
        ~coordinateSetsMatch(sort(sliceTemp_C),cfg.expectedDcTemp_C,1e-8)
    warning('BIAS_Analyze:IncompleteTemperatureSlice', ...
        'VDD = %.3g V temperature slice is incomplete.',cfg.tcVdd_V);
    return;
end
i27_A = valueAtCoordinate(sliceTemp_C,sliceCurrent_A,27,1e-8);
if ~isfinite(i27_A) || i27_A == 0
    return;
end
currentRange_A = max(sliceCurrent_A)-min(sliceCurrent_A);
tc_ppm_C = currentRange_A/(i27_A*165)*1e6;
variation_pct = currentRange_A/i27_A*100;
end

function [lineReg_pct_V,variation_pct] = supplyMetrics( ...
        temperature_C,vdd_V,ibias_A,cfg)
lineReg_pct_V = NaN;
variation_pct = NaN;
rows = abs(temperature_C-cfg.lineTemp_C) <= 1e-8;
sliceVdd_V = vdd_V(rows);
sliceCurrent_A = ibias_A(rows);
if numel(sliceVdd_V) ~= numel(cfg.expectedDcVdd_V) || ...
        ~coordinateSetsMatch(sort(sliceVdd_V),cfg.expectedDcVdd_V,5e-6)
    warning('BIAS_Analyze:IncompleteSupplySlice', ...
        'T = %.3g C supply slice is incomplete.',cfg.lineTemp_C);
    return;
end
i3p3_A = valueAtCoordinate(sliceVdd_V,sliceCurrent_A,3.3,5e-4);
if ~isfinite(i3p3_A) || i3p3_A == 0
    return;
end
currentRange_A = max(sliceCurrent_A)-min(sliceCurrent_A);
lineReg_pct_V = currentRange_A/(i3p3_A*0.6)*100;
variation_pct = currentRange_A/i3p3_A*100;
end

function value = valueAtCoordinate(coordinate,quantity,target,tolerance)
rows = abs(coordinate-target) <= tolerance;
if nnz(rows) ~= 1
    value = NaN;
else
    value = quantity(rows);
end
end

function value = safePercent(numerator,denominator)
if ~isfinite(denominator) || denominator == 0
    value = NaN;
else
    value = 100*numerator/denominator;
end
end

function [value,index] = acrossProcessExtreme(candidates,operation)
value = NaN;
index = NaN;
validRows = find(isfinite(candidates));
if isempty(validRows)
    return;
end
switch operation
    case 'min'
        [value,localIndex] = min(candidates(validRows));
    case 'max'
        [value,localIndex] = max(candidates(validRows));
    otherwise
        error('BIAS_Analyze:ProcessExtreme', ...
            'Unknown process extreme operation %s.',operation);
end
index = validRows(localIndex);
end

%% Units and formatting

function formatted = formatReportValues(values)
formatted = strings(size(values));
for valueIndex = 1:numel(values)
    formatted(valueIndex) = formatOne(values(valueIndex));
end
end

function textValue = formatOne(value)
if isnan(value)
    textValue = 'NaN';
elseif isinf(value)
    textValue = sprintf('%+g',value);
elseif value ~= 0 && abs(value) < 1
    textValue = sprintf('%.3e',value);
else
    textValue = sprintf('%.3f',value);
end
end
