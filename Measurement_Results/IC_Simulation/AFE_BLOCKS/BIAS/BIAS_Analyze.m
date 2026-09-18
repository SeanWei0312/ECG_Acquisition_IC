function BIAS_Analyze
% BIAS_ANALYZE Characterize the BIAS reference, startup, and selectors.
%
% Transient results cover process and seven environment conditions. DC2D
% results cover the complete temperature/supply grid for each process.
% Reports retain the established BIAS units and formatting rules; plots use
% the native MATLAB theme and remain independent floating figures.

clc;
close all;

scriptDir = fileparts(mfilename('fullpath'));
plotDir = fullfile(scriptDir,'Plots');
if ~isfolder(plotDir)
    mkdir(plotDir);
end

[processes,conditions,conditionTokens,conditionTemp_C,conditionVdd_V] = ...
    sweepDefinition();
normalColumns = [processes conditions(2:5)];

cfg = analysisConfig();
rows = reportRows();
normalParameter = rows.normal(:,1);
normalUnit = rows.normal(:,2);
dcParameter = rows.dc(:,1);
dcUnit = rows.dc(:,2);
referenceParameter = rows.reference(:,1);
referenceUnit = rows.reference(:,2);
selParameter = rows.selector;

nProcesses = numel(processes);
nConditions = numel(conditions);
normalValues = nan(numel(normalParameter),numel(normalColumns));
startup_us = nan(nProcesses,nConditions);
startupAnalyzed = false(nProcesses,nConditions);
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
nomDc = [];
legacyDc = strings(nProcesses,1);
missingDc = strings(nProcesses,1);

for processIndex = 1:nProcesses
    process = processes{processIndex};
    fileLabel = sprintf('%s.dc2d.txt',process);
    dataFile = fullfile(scriptDir,[process '.Result_txt'],fileLabel);
    if ~isfile(dataFile)
        missingDc(processIndex) = process;
        continue;
    end

    try
        [data,schema] = readDcData(dataFile,fileLabel,cfg);
        analysis = analyzeDc(data,schema,cfg);
        dcValues(:,processIndex) = analysis.values;
        dcTemp_C(:,processIndex) = analysis.temp_C;
        dcVdd_V(:,processIndex) = analysis.vdd_V;
        referenceValues(:,processIndex) = analysis.referenceValues;
        if strcmp(schema,'legacy12')
            legacyDc(processIndex) = process;
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
legacyDc = legacyDc(legacyDc ~= "");
if ~isempty(missingDc)
    warning('BIAS_Analyze:MissingDc', ...
        'Missing DC2D results: %s.',strjoin(missingDc,', '));
end
if ~isempty(legacyDc)
    warning('BIAS_Analyze:LegacyDcSchema', ...
        ['Legacy 12-column DC2D data used for %s. Valid current, voltage, ' ...
         'power, TC, and line-regulation metrics are retained; unavailable ' ...
         'device-sweep extrema are NaN.'],strjoin(legacyDc,', '));
end

startupSummary = buildStartupSummary(processes,conditions, ...
    conditionTemp_C,conditionVdd_V,startup_us,startupAnalyzed, ...
    missingTransient,invalidTransient);
selGlobal = buildSelGlobal(processes,conditions,conditionTemp_C, ...
    conditionVdd_V,selRunMax_V,selParameter);
globalPvt = buildGlobalPvt(processes,dcValues,dcTemp_C,dcVdd_V);

formattedNormal = formatReportValues(normalValues);
formattedDc = formatReportValues(dcValues);
formattedReference = formatReportValues(referenceValues);

fprintf('\nBIAS NORMAL OPERATING POINT\n\n');
printComparisonTable(normalParameter,normalUnit,normalColumns,formattedNormal);

fprintf('\nBIAS STARTUP ROBUSTNESS\n\n');
printStartupTable(processes,conditions,startup_us);
fprintf('\n');
printStartupSummary(startupSummary,nProcesses*nConditions);

fprintf('\nBIAS SEL WORST CASE\n\n');
printLocationResultTable(selGlobal);

fprintf('\nBIAS 2-D PVT\n\n');
printComparisonTable(dcParameter,dcUnit,processes,formattedDc);
fprintf('\n2-D extrema locations: Temp(C) / VDD(V)\n\n');
printLocationTable(dcParameter,processes,dcTemp_C,dcVdd_V);

fprintf('\nGLOBAL 2-D WORST CASE\n\n');
printLocationResultTable(globalPvt);

fprintf('\nREFERENCE QUALITY\n\n');
printComparisonTable(referenceParameter,referenceUnit,processes, ...
    formattedReference);

writeComparisonCsv(normalParameter,normalUnit,normalColumns, ...
    formattedNormal,fullfile(scriptDir,'BIAS_table_report.csv'));
writeStartupCsv(processes,conditions,startup_us, ...
    fullfile(scriptDir,'BIAS_startup_report.csv'));
writeStartupSummaryCsv(startupSummary,nProcesses*nConditions, ...
    fullfile(scriptDir,'BIAS_startup_summary.csv'));
writeLocationResultCsv(selGlobal,fullfile(scriptDir,'BIAS_sel_report.csv'));
writeDcCsv(dcParameter,dcUnit,processes,formattedDc,dcTemp_C,dcVdd_V, ...
    fullfile(scriptDir,'BIAS_dc2d_report.csv'));
writeLocationResultCsv(globalPvt, ...
    fullfile(scriptDir,'BIAS_global_worst_case.csv'));
writeComparisonCsv(referenceParameter,referenceUnit,processes, ...
    formattedReference,fullfile(scriptDir,'BIAS_reference_report.csv'));

if isempty(nomTransient)
    warning('BIAS_Analyze:NoNomTransientPlots', ...
        'NOM/tran_nom is unavailable; transient plots were skipped.');
else
    plotNominalTransient(nomTransient,nomTransientAnalysis,plotDir,cfg);
end
if isempty(nomDc)
    warning('BIAS_Analyze:NoNomDcPlots', ...
        'NOM DC2D data is unavailable; temperature/VDD plots were skipped.');
else
    plotNominalDc(nomDc,plotDir,cfg);
end

end

function [processes,conditions,tokens,temp_C,vdd_V] = sweepDefinition
processes = {'NOM','FF','SS','FS','SF'};
conditions = {'NOM','VL','VH','TL','TH','TLVL','THVH'};
tokens = {'nom','vl','vh','tl','th','tlvl','thvh'};
temp_C = [27 27 27 -40 125 -40 125];
vdd_V = [3.3 3.0 3.6 3.3 3.3 3.0 3.6];
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
end

function rows = reportRows
rows.normal = [
    "Ibias",         "uA"
    "Ibias error",   "%"
    "IRS",           "uA"
    "Mirror error",  "%"
    "BP",            "V"
    "VREF",          "V"
    "VREF error",    "uV"
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
    "Maximum |VREF error|",         "uV"
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
    "Maximum |VREF INT SEL error|"
    "Maximum |VREF EXT SEL error|"
];
end

function data = readTransientData(dataFile,fileLabel,expectedVdd_V,cfg)
data = readmatrix(dataFile,'FileType','text');
validateNumericMatrix(data,16,fileLabel);
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

function result = analyzeTransient(data,cfg)
time_s = data(:,1);
sel_V = data(:,3);
ibias_A = abs(data(:,10));
edges = detectSelectionPlateaus(time_s,sel_V);

initialSettledRows = finalFractionRows(time_s,time_s(1), ...
    edges.riseStart_s,cfg.plateauTrimFraction);
externalCenterRows = trimmedPlateauRows(time_s,edges.riseEnd_s, ...
    edges.fallStart_s,cfg.plateauTrimFraction);
finalCenterRows = trimmedPlateauRows(time_s,edges.fallEnd_s, ...
    time_s(end),cfg.plateauTrimFraction);
if ~any(initialSettledRows) || ~any(externalCenterRows) || ...
        ~any(finalCenterRows)
    error('BIAS_Analyze:SelectionWindows', ...
        'One or more settled selector regions contain no samples.');
end

steady = data(initialSettledRows,:);
steadyMean = mean(steady,1);
ibiasFinal_A = mean(abs(steady(:,10)));
irsFinal_A = mean(abs(steady(:,11)));
imstFinal_A = mean(abs(steady(:,12)));
mstMargin_V = mean(steady(:,14)-steady(:,13));
mirrorError_pct = safePercent(ibiasFinal_A-irsFinal_A,irsFinal_A);
startupCrossing_s = permanentStartupBandEntry( ...
    time_s,ibias_A,ibiasFinal_A,edges.riseStart_s, ...
    cfg.startupMinimumFinal_A);
startupTime_s = NaN;
if isfinite(startupCrossing_s) && startupCrossing_s >= cfg.vddRampStart_s
    startupTime_s = startupCrossing_s-cfg.vddRampStart_s;
end

intRows = initialSettledRows | finalCenterRows;
selMax_V = [
    max(abs(data(intRows,5)-data(intRows,4)))
    max(abs(data(externalCenterRows,5)-data(externalCenterRows,6)))
    max(abs(data(intRows,8)-data(intRows,7)))
    max(abs(data(externalCenterRows,8)-data(externalCenterRows,9)))
];

normalValues = [
    ibiasFinal_A*1e6
    100*(ibiasFinal_A-cfg.ibiasTarget_A)/cfg.ibiasTarget_A
    irsFinal_A*1e6
    mirrorError_pct
    steadyMean(5)
    steadyMean(8)
    (steadyMean(8)-steadyMean(2)/2)*1e6
    imstFinal_A*1e15
    mstMargin_V
    steadyMean(15)*1e6
    steadyMean(16)*1e6
    startupTime_s*1e6
];

result.normalValues = normalValues;
result.startupTime_s = startupTime_s;
result.startupCrossing_s = startupCrossing_s;
result.startupThreshold_A = 0.9*ibiasFinal_A;
result.firstSelTime_s = edges.riseStart_s;
result.secondSelTime_s = edges.fallStart_s;
result.selMax_V = selMax_V;
result.imstWaveformUsable = isSweepVector(data(:,12));
result.hasBroadcastDeviceData = ~isSweepVector(data(:,11)) || ...
    ~result.imstWaveformUsable || ~isSweepVector(data(:,13)) || ...
    ~isSweepVector(data(:,14));
end

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

function [data,schema] = readDcData(dataFile,fileLabel,cfg)
data = readmatrix(dataFile,'FileType','text');
columnCount = size(data,2);
if columnCount == 14
    validateNumericMatrix(data,14,fileLabel);
    schema = 'new14';
elseif columnCount == 12
    validateNumericMatrix(data,12,fileLabel);
    schema = 'legacy12';
else
    error('BIAS_Analyze:ColumnCount', ...
        '%s must contain 14 columns; found %d.',fileLabel,columnCount);
end
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

function result = analyzeDc(data,schema,cfg)
temperature_C = data(:,1);
vdd_V = data(:,2);
bp_V = data(:,4);
vref_V = data(:,6);
ibias_A = data(:,7);
irs_A = data(:,8);

if strcmp(schema,'new14')
    mirrorError_pct = data(:,9);
    vrefError_uV = data(:,10)*1e6;
    imst_A = data(:,11);
    mstMargin_V = data(:,12);
    idd_A = data(:,13);
    power_W = data(:,14);
    verifyExportedDcErrors(data,mirrorError_pct,vrefError_uV);
    mirrorUsable = true;
    imstUsable = true;
    marginUsable = true;
else
    mirrorError_pct = nan(size(ibias_A));
    mirrorUsable = isSweepVector(irs_A);
    if mirrorUsable
        nonzeroIrs = irs_A ~= 0;
        mirrorError_pct(nonzeroIrs) = 100* ...
            (ibias_A(nonzeroIrs)-irs_A(nonzeroIrs))./irs_A(nonzeroIrs);
    end
    vrefError_uV = (vref_V-vdd_V/2)*1e6;
    imst_A = data(:,9);
    mstMargin_V = data(:,10);
    idd_A = data(:,11);
    power_W = data(:,12);
    imstUsable = isSweepVector(imst_A);
    marginUsable = isSweepVector(mstMargin_V);
end

ibiasError_pct = 100*(ibias_A-cfg.ibiasTarget_A)/cfg.ibiasTarget_A;
values = nan(13,1);
tempAt_C = nan(13,1);
vddAt_V = nan(13,1);
[values(1),tempAt_C(1),vddAt_V(1)] = extremeWithLocation( ...
    ibias_A*1e6,temperature_C,vdd_V,'min');
[values(2),tempAt_C(2),vddAt_V(2)] = extremeWithLocation( ...
    ibias_A*1e6,temperature_C,vdd_V,'max');
[values(3),tempAt_C(3),vddAt_V(3)] = extremeWithLocation( ...
    ibiasError_pct,temperature_C,vdd_V,'min');
[values(4),tempAt_C(4),vddAt_V(4)] = extremeWithLocation( ...
    ibiasError_pct,temperature_C,vdd_V,'max');
[values(5),tempAt_C(5),vddAt_V(5)] = extremeWithLocation( ...
    bp_V,temperature_C,vdd_V,'min');
[values(6),tempAt_C(6),vddAt_V(6)] = extremeWithLocation( ...
    bp_V,temperature_C,vdd_V,'max');
[values(7),tempAt_C(7),vddAt_V(7)] = extremeWithLocation( ...
    vrefError_uV,temperature_C,vdd_V,'maxabs');
if mirrorUsable
    [values(8),tempAt_C(8),vddAt_V(8)] = extremeWithLocation( ...
        mirrorError_pct,temperature_C,vdd_V,'maxabs');
end
if imstUsable
    [values(9),tempAt_C(9),vddAt_V(9)] = extremeWithLocation( ...
        abs(imst_A)*1e15,temperature_C,vdd_V,'max');
end
if marginUsable
    [values(10),tempAt_C(10),vddAt_V(10)] = extremeWithLocation( ...
        mstMargin_V,temperature_C,vdd_V,'min');
end
[values(11),tempAt_C(11),vddAt_V(11)] = extremeWithLocation( ...
    idd_A*1e6,temperature_C,vdd_V,'min');
[values(12),tempAt_C(12),vddAt_V(12)] = extremeWithLocation( ...
    idd_A*1e6,temperature_C,vdd_V,'max');
[values(13),tempAt_C(13),vddAt_V(13)] = extremeWithLocation( ...
    power_W*1e6,temperature_C,vdd_V,'max');

[tc_ppm_C,tempVariation_pct] = temperatureMetrics( ...
    temperature_C,vdd_V,ibias_A,cfg);
[lineReg_pct_V,supplyVariation_pct] = supplyMetrics( ...
    temperature_C,vdd_V,ibias_A,cfg);

result.values = values;
result.temp_C = tempAt_C;
result.vdd_V = vddAt_V;
result.referenceValues = [tc_ppm_C;tempVariation_pct; ...
    lineReg_pct_V;supplyVariation_pct];
end

function verifyExportedDcErrors(data,mirrorError_pct,vrefError_uV)
ibias_A = data(:,7);
irs_A = data(:,8);
recomputedMirror_pct = nan(size(ibias_A));
nonzeroIrs = irs_A ~= 0;
recomputedMirror_pct(nonzeroIrs) = 100* ...
    (ibias_A(nonzeroIrs)-irs_A(nonzeroIrs))./irs_A(nonzeroIrs);
recomputedVref_uV = (data(:,6)-data(:,2)/2)*1e6;
mirrorResidual = abs(mirrorError_pct-recomputedMirror_pct);
vrefResidual = abs(vrefError_uV-recomputedVref_uV);
if any(mirrorResidual(isfinite(mirrorResidual)) > 1e-6) || ...
        any(vrefResidual(isfinite(vrefResidual)) > 1e-3)
    warning('BIAS_Analyze:ExportedErrorMismatch', ...
        'Exported mirror or VREF error differs from its recomputed value.');
end
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
        'VDD = 3.3 V temperature slice is incomplete.');
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
        'T = 27 C supply slice is incomplete.');
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

function value = safePercent(numerator,denominator)
if ~isfinite(denominator) || denominator == 0
    value = NaN;
else
    value = 100*numerator/denominator;
end
end

function tf = isBiasAnalysisError(exception)
tf = startsWith(exception.identifier,'BIAS_Analyze:');
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
summary.failureCount = nnz(analyzed & ~isfinite(startup_us))+ ...
    numel(missingFiles)+numel(invalidFiles);
summary.missingCount = numel(missingFiles);
summary.invalidCount = numel(invalidFiles);
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
    "Maximum |VREF error|"
    "Maximum |mirror error|"
    "Minimum MST margin"
    "Maximum IDD"
    "Maximum power"
];
unit = ["uA";"uA";"%";"V";"V";"uV";"%";"V";"uA";"uW"];
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

resultRows = [1 2 4 5 6 7 8 9 10];
sourceRows = [1 2 5 6 7 8 10 12 13];
operations = {'min','max','min','max','max','max','min','max','max'};
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

function plotNominalTransient(data,analysis,plotDir,cfg)
time_ms = data(:,1)*1e3;
startupEnd_s = min(4e-3,analysis.firstSelTime_s);
startupRows = data(:,1) >= 0 & data(:,1) <= startupEnd_s;

fig = figure;
if analysis.imstWaveformUsable
    yyaxis left;
end
plot(time_ms(startupRows),abs(data(startupRows,10))*1e6, ...
    'LineWidth',1.5,'DisplayName','I_{BIAS}');
hold on;
yline(analysis.startupThreshold_A*1e6,'--','90% threshold', ...
    'HandleVisibility','off');
ylabel('I_{BIAS} (uA)');
if analysis.imstWaveformUsable
    yyaxis right;
    plot(time_ms(startupRows),abs(data(startupRows,12))*1e15, ...
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
plot(time_ms(startupRows),data(startupRows,7), ...
    'LineWidth',1.5,'DisplayName','VREFINT');
xlim([0 startupEnd_s*1e3]);
ylabel('Voltage (V)');
stylePlot('Time (ms)','BIAS Startup Voltage - NOM');
legend('Location','best');
savePlot(fig,plotDir,'NOM_BIAS_STARTUP_VOLTAGE.png');

selectionRows = data(:,1) >= 0 & data(:,1) <= cfg.expectedTranEnd_s;
fig = figure;
bpAxes = subplot(2,1,1);
plot(time_ms(selectionRows),data(selectionRows,3), ...
    'LineWidth',1.5,'DisplayName','SEL');
hold on;
plot(time_ms(selectionRows),data(selectionRows,4), ...
    'LineWidth',1.5,'DisplayName','BPINT');
plot(time_ms(selectionRows),data(selectionRows,5), ...
    'LineWidth',1.5,'DisplayName','BP');
plot(time_ms(selectionRows),data(selectionRows,6), ...
    'LineWidth',1.5,'DisplayName','BPEXT');
addSelectionGuides(analysis.firstSelTime_s*1e3, ...
    analysis.secondSelTime_s*1e3,cfg.expectedTranEnd_s*1e3);
ylabel('Voltage (V)');
stylePlot('','BP Selector');
legend('Location','best');

vrefAxes = subplot(2,1,2);
plot(time_ms(selectionRows),data(selectionRows,3), ...
    'LineWidth',1.5,'DisplayName','SEL');
hold on;
plot(time_ms(selectionRows),data(selectionRows,7), ...
    'LineWidth',1.5,'DisplayName','VREFINT');
plot(time_ms(selectionRows),data(selectionRows,8), ...
    'LineWidth',1.5,'DisplayName','VREF');
plot(time_ms(selectionRows),data(selectionRows,9), ...
    'LineWidth',1.5,'DisplayName','VREFEXT');
addSelectionGuides(analysis.firstSelTime_s*1e3, ...
    analysis.secondSelTime_s*1e3,cfg.expectedTranEnd_s*1e3);
ylabel('Voltage (V)');
stylePlot('Time (ms)','VREF Selector');
legend('Location','best');
linkaxes([bpAxes vrefAxes],'x');
sgtitle('BIAS Internal / External Selection - NOM');
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
ibias_uA = data(:,7)*1e6;

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
ibiasError_pct = 100*(data(:,7)-cfg.ibiasTarget_A)/cfg.ibiasTarget_A;
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

function printComparisonTable(parameters,units,columns,formattedValues)
parameterWidth = max(28,max(strlength(parameters))+2);
fprintf('%-*s %-8s',parameterWidth,'Parameter','Unit');
for columnIndex = 1:numel(columns)
    fprintf(' %13s',columns{columnIndex});
end
fprintf('\n%s\n',repmat('-',1,parameterWidth+9+14*numel(columns)));
for rowIndex = 1:numel(parameters)
    fprintf('%-*s %-8s',parameterWidth,char(parameters(rowIndex)), ...
        char(units(rowIndex)));
    for columnIndex = 1:numel(columns)
        fprintf(' %13s',char(formattedValues(rowIndex,columnIndex)));
    end
    fprintf('\n');
end
end

function printStartupTable(processes,conditions,startup_us)
fprintf('%-10s %-8s','Process','Unit');
for conditionIndex = 1:numel(conditions)
    fprintf(' %13s',conditions{conditionIndex});
end
fprintf('\n%s\n',repmat('-',1,19+14*numel(conditions)));
for processIndex = 1:numel(processes)
    fprintf('%-10s %-8s',processes{processIndex},'us');
    for conditionIndex = 1:numel(conditions)
        fprintf(' %13s',fixedReportValue( ...
            startup_us(processIndex,conditionIndex)));
    end
    fprintf('\n');
end
end

function printStartupSummary(summary,totalTests)
fprintf('%-24s %s us\n','Worst startup time', ...
    fixedReportValue(summary.worstTime_us));
fprintf('%-24s %s\n','Worst process',char(summary.process));
fprintf('%-24s %s\n','Worst condition',char(summary.condition));
fprintf('%-24s %s C\n','Temperature', ...
    fixedReportValue(summary.temp_C));
fprintf('%-24s %s V\n','VDD',fixedReportValue(summary.vdd_V));
fprintf('%-24s %d / %d\n','Startup failures', ...
    summary.failureCount,totalTests);
if summary.missingCount > 0 || summary.invalidCount > 0
    fprintf('%-24s %d\n','Startup files missing',summary.missingCount);
    fprintf('%-24s %d\n','Startup files invalid',summary.invalidCount);
end
end

function printLocationTable(parameters,processes,temp_C,vdd_V)
parameterWidth = max(30,max(strlength(parameters))+2);
fprintf('%-*s',parameterWidth,'Parameter');
for processIndex = 1:numel(processes)
    fprintf(' %22s',processes{processIndex});
end
fprintf('\n%s\n',repmat('-',1,parameterWidth+23*numel(processes)));
for rowIndex = 1:numel(parameters)
    fprintf('%-*s',parameterWidth,char(parameters(rowIndex)));
    for processIndex = 1:numel(processes)
        if isfinite(temp_C(rowIndex,processIndex)) && ...
                isfinite(vdd_V(rowIndex,processIndex))
            location = sprintf('%.3f / %.3f', ...
                temp_C(rowIndex,processIndex),vdd_V(rowIndex,processIndex));
        else
            location = 'NaN / NaN';
        end
        fprintf(' %22s',location);
    end
    fprintf('\n');
end
end

function printLocationResultTable(results)
hasCondition = ismember('Condition',results.Properties.VariableNames);
if hasCondition
    fprintf('%-31s %-7s %13s %-8s %-10s %10s %10s\n', ...
        'Parameter','Unit','Value','Process','Condition','Temp(C)','VDD(V)');
    fprintf('%s\n',repmat('-',1,99));
else
    fprintf('%-31s %-7s %13s %-8s %10s %10s\n', ...
        'Parameter','Unit','Value','Process','Temp(C)','VDD(V)');
    fprintf('%s\n',repmat('-',1,88));
end
for rowIndex = 1:height(results)
    if hasCondition
        fprintf('%-31s %-7s %13s %-8s %-10s %10s %10s\n', ...
            char(results.Parameter(rowIndex)),char(results.Unit(rowIndex)), ...
            fixedReportValue(results.Value(rowIndex)), ...
            char(results.Process(rowIndex)), ...
            char(results.Condition(rowIndex)), ...
            fixedReportValue(results.Temp_C(rowIndex)), ...
            fixedReportValue(results.VDD_V(rowIndex)));
    else
        fprintf('%-31s %-7s %13s %-8s %10s %10s\n', ...
            char(results.Parameter(rowIndex)),char(results.Unit(rowIndex)), ...
            fixedReportValue(results.Value(rowIndex)), ...
            char(results.Process(rowIndex)), ...
            fixedReportValue(results.Temp_C(rowIndex)), ...
            fixedReportValue(results.VDD_V(rowIndex)));
    end
end
end

function writeComparisonCsv(parameters,units,columns,formattedValues,csvFile)
fid = openCsv(csvFile);
fileCleanup = onCleanup(@() fclose(fid));
fprintf(fid,'Parameter,Unit');
for columnIndex = 1:numel(columns)
    fprintf(fid,',%s',columns{columnIndex});
end
fprintf(fid,'\n');
for rowIndex = 1:numel(parameters)
    fprintf(fid,'%s,%s',char(parameters(rowIndex)),char(units(rowIndex)));
    for columnIndex = 1:numel(columns)
        fprintf(fid,',%s',char(formattedValues(rowIndex,columnIndex)));
    end
    fprintf(fid,'\n');
end
end

function writeStartupCsv(processes,conditions,startup_us,csvFile)
fid = openCsv(csvFile);
fileCleanup = onCleanup(@() fclose(fid));
fprintf(fid,'Process,Unit');
for conditionIndex = 1:numel(conditions)
    fprintf(fid,',%s',conditions{conditionIndex});
end
fprintf(fid,'\n');
for processIndex = 1:numel(processes)
    fprintf(fid,'%s,us',processes{processIndex});
    for conditionIndex = 1:numel(conditions)
        fprintf(fid,',%s',fixedReportValue( ...
            startup_us(processIndex,conditionIndex)));
    end
    fprintf(fid,'\n');
end
end

function writeStartupSummaryCsv(summary,totalTests,csvFile)
fid = openCsv(csvFile);
fileCleanup = onCleanup(@() fclose(fid));
fprintf(fid,'Parameter,Value,Unit,Process,Condition,Temp_C,VDD_V,Total\n');
fprintf(fid,'Worst startup time,%s,us,%s,%s,%s,%s,\n', ...
    fixedReportValue(summary.worstTime_us),char(summary.process), ...
    char(summary.condition),fixedReportValue(summary.temp_C), ...
    fixedReportValue(summary.vdd_V));
fprintf(fid,'Startup failures,%d,count,,,,,%d\n', ...
    summary.failureCount,totalTests);
if summary.missingCount > 0 || summary.invalidCount > 0
    fprintf(fid,'Startup files missing,%d,count,,,,,%d\n', ...
        summary.missingCount,totalTests);
    fprintf(fid,'Startup files invalid,%d,count,,,,,%d\n', ...
        summary.invalidCount,totalTests);
end
end

function writeDcCsv(parameters,units,processes,formattedValues, ...
        temp_C,vdd_V,csvFile)
fid = openCsv(csvFile);
fileCleanup = onCleanup(@() fclose(fid));
fprintf(fid,'Parameter,Unit');
for processIndex = 1:numel(processes)
    fprintf(fid,',%s,%s_Temp_C,%s_VDD_V', ...
        processes{processIndex},processes{processIndex}, ...
        processes{processIndex});
end
fprintf(fid,'\n');
for rowIndex = 1:numel(parameters)
    fprintf(fid,'%s,%s',char(parameters(rowIndex)),char(units(rowIndex)));
    for processIndex = 1:numel(processes)
        fprintf(fid,',%s,%s,%s', ...
            char(formattedValues(rowIndex,processIndex)), ...
            fixedReportValue(temp_C(rowIndex,processIndex)), ...
            fixedReportValue(vdd_V(rowIndex,processIndex)));
    end
    fprintf(fid,'\n');
end
end

function writeLocationResultCsv(results,csvFile)
fid = openCsv(csvFile);
fileCleanup = onCleanup(@() fclose(fid));
hasCondition = ismember('Condition',results.Properties.VariableNames);
if hasCondition
    fprintf(fid,'Parameter,Unit,Value,Process,Condition,Temp_C,VDD_V\n');
else
    fprintf(fid,'Parameter,Unit,Value,Process,Temp_C,VDD_V\n');
end
for rowIndex = 1:height(results)
    if hasCondition
        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s\n', ...
            char(results.Parameter(rowIndex)),char(results.Unit(rowIndex)), ...
            fixedReportValue(results.Value(rowIndex)), ...
            char(results.Process(rowIndex)),char(results.Condition(rowIndex)), ...
            fixedReportValue(results.Temp_C(rowIndex)), ...
            fixedReportValue(results.VDD_V(rowIndex)));
    else
        fprintf(fid,'%s,%s,%s,%s,%s,%s\n', ...
            char(results.Parameter(rowIndex)),char(results.Unit(rowIndex)), ...
            fixedReportValue(results.Value(rowIndex)), ...
            char(results.Process(rowIndex)), ...
            fixedReportValue(results.Temp_C(rowIndex)), ...
            fixedReportValue(results.VDD_V(rowIndex)));
    end
end
end

function fid = openCsv(csvFile)
fid = fopen(csvFile,'w');
if fid < 0
    error('BIAS_Analyze:CsvOpen', ...
        'Unable to write CSV report %s.',csvFile);
end
end

function formatted = formatReportValues(values)
formatted = strings(size(values));
for valueIndex = 1:numel(values)
    formatted(valueIndex) = fixedReportValue(values(valueIndex));
end
end

function textValue = fixedReportValue(value)
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
