function PGA_Analyze
% PGA_ANALYZE Characterize the four-gain fully differential PGA.
%
% MATLAB calculates PVT metrics from raw NGSPICE output, selects full-PVT
% worst cases, summarizes correlated MM/GL/FULL Monte Carlo runs, and
% creates nominal plots. Shared operating-point quantities use G2.

clc; close all;
scriptDir = fileparts(mfilename('fullpath'));
plotDir = fullfile(scriptDir,'Plots'); reportDir = fullfile(scriptDir,'Reports');
if ~isfolder(plotDir), mkdir(plotDir); end
if ~isfolder(reportDir), mkdir(reportDir); end
cfg = analysisConfig(); rows = reportRows(cfg);
processes = ["NOM" "FF" "SS" "FS" "SF"]; processTokens = lower(processes);
cases = ["nom" "vl" "vh" "tl" "th" "vltl" "vlth" "vhtl" "vhth"];
caseLabels = ["NOMNOM" "VLNOM" "VHNOM" "NOMTL" "NOMTH" ...
    "VLTL" "VLTH" "VHTL" "VHTH"];
caseVdd_V = [3.3 3.0 3.6 3.3 3.3 3.0 3.0 3.6 3.6];
caseTemp_C = [27 27 27 -40 125 -40 125 -40 125];
nCorners = numel(processes)*numel(cases);
corners = strings(1,nCorners); cornerProcesses = strings(1,nCorners);
cornerCases = strings(1,nCorners); cornerVdd_V = nan(1,nCorners);
cornerTemp_C = nan(1,nCorners); values = nan(size(rows,1),nCorners);
valueRelations = strings(size(rows,1),nCorners);
metrics = cell(1,nCorners); cornerIndex = 0;
for processIndex = 1:numel(processes)
    process = processes(processIndex); processToken = processTokens(processIndex);
    resultDir = fullfile(scriptDir,processToken+".Result_txt");
    for caseIndex = 1:numel(cases)
        cornerIndex = cornerIndex+1; caseToken = cases(caseIndex);
        corners(cornerIndex) = process+caseLabels(caseIndex);
        cornerProcesses(cornerIndex) = process;
        cornerCases(cornerIndex) = caseLabels(caseIndex);
        cornerVdd_V(cornerIndex) = caseVdd_V(caseIndex);
        cornerTemp_C(cornerIndex) = caseTemp_C(caseIndex);
        metrics{cornerIndex} = analyzeCorner(resultDir,processToken,caseToken, ...
            caseVdd_V(caseIndex),cfg);
        values(:,cornerIndex) = metricsToRaw(metrics{cornerIndex},rows, ...
            caseTemp_C(caseIndex),cfg);
        valueRelations(:,cornerIndex) = metricsToRelations( ...
            metrics{cornerIndex},rows,cfg);
    end
end
specifications = specStrings(rows(:,1),cfg);
checkReportSpecCoverage(rows,specifications);
checkPvtSpecifications(rows,values,corners,cfg);
nominalCorner = parameterIndex(corners,"NOMNOMNOM");
reportColumns = ["NOM" "FF" "SS" "FS" "SF" "VL" "VH" "TL" "TH"];
reportKeys = ["NOMNOMNOM" "FFNOMNOM" "SSNOMNOM" "FSNOMNOM" ...
    "SFNOMNOM" "NOMVLNOM" "NOMVHNOM" "NOMNOMTL" "NOMNOMTH"];
[found,reportIndices] = ismember(reportKeys,corners);
if ~all(found), error('PGA_Analyze:ReportCorners','Required corners are missing.'); end
formattedValues = formatReportValues(values,valueRelations);
reportValues = formattedValues(:,reportIndices);
summaryTable = table(rows(:,1),rows(:,2),specifications, ...
    'VariableNames',{'Parameter','Unit','Spec'});
summaryTable = [summaryTable array2table(reportValues, ...
    'VariableNames',cellstr(reportColumns))];
fprintf('\nPGA COMPARISON SUMMARY\n\n');
printSummaryTable(rows,specifications,reportColumns,reportValues);
writetable(summaryTable,fullfile(reportDir,'PGA_table_report.csv'));
writetable(summaryTable,fullfile(reportDir,'NOM.PGA_summary.csv'));
fullPvtTable = buildFullPvtTable(rows,values,valueRelations,corners, ...
    cornerProcesses,cornerCases,cornerVdd_V,cornerTemp_C);
writetable(fullPvtTable,fullfile(reportDir,'PGA_full_pvt_report.csv'));
worstCase = buildWorstCaseTable(rows,values,valueRelations,corners,cfg);
fprintf('\nPGA FULL-PVT WORST CASE\n\n'); printWorstCaseTable(worstCase);
writetable(worstCase,fullfile(reportDir,'PGA_worst_case_report.csv'));
nominal = metrics{nominalCorner};
plotNominalDifferential(nominal,plotDir,cfg);
plotNominalVtc(nominal,plotDir,cfg);
plotNominalNoise(nominal,plotDir,cfg);
plotNominalRejection(nominal,plotDir,cfg);
plotSelectorTransient(scriptDir,plotDir);
plotGainSwitchTransient(scriptDir,plotDir,cfg);
runMcSection(scriptDir,plotDir,reportDir,cfg);
end

function cfg = analysisConfig
cfg.gains = [2 4 8 16]; cfg.gainTags = ["g2" "g4" "g8" "g16"];
cfg.referenceFrequency_Hz = 10; cfg.bandEdge_Hz = 150;
cfg.noiseBand_Hz = [0.05 150]; cfg.rejectionFrequencies_Hz = [60 150];
cfg.mcRequestedRuns = 200; cfg.biasTarget_uA = 40; cfg.biasTolerance_uA = 10;
cfg.totalCurrentLimit_mA = 2.5; cfg.totalPowerLimit_mW = 9;
cfg.outputCmErrorLimit_mV = 20; cfg.offsetLimit_mV = 5;
cfg.gainErrorLimit_pct = 5; cfg.bandwidthLimit_MHz = 0.15;
cfg.rejectionLimit_dB = 80; cfg.noiseLimit_uVrms = 10;
cfg.vtcCompression_pct = 1;
cfg.vtcCenterFitHalfWidth_V = [0.1 0.05 0.025 0.0125];
cfg.inputRangeLimit_V = [1.2 0.6 0.3 0.15];
cfg.outputRangeLimit_V = 2.4;
cfg.thdFrequency_Hz = 60;
cfg.thdInputVpp_V = [1.2 0.6 0.3 0.15];
cfg.thdLimit_pct = 0.05;
end

function rows = reportRows(cfg)
rows = [
    "Set conditions", ""; "AVDD", "V"; "Temperature", "C";
    "Shared OP gain code", "code"; "", ""; "Operating point", "";
    "FDC bias current", "uA"; "CMFB bias current", "uA";
    "Total current", "mA"; "Total power", "mW"; "Output CM error", "mV"
];
for gain = cfg.gains
    prefix = "G"+gain;
    rows = [rows; "", ""; prefix, ""; prefix+" target gain", "V/V"; ...
        prefix+" input offset", "mV"; prefix+" gain @ 10 Hz", "V/V";
        prefix+" gain @ 150 Hz", "V/V"; prefix+" gain error", "%";
        prefix+" -3 dB bandwidth", "MHz";
        prefix+" input range low", "V"; prefix+" input range high", "V";
        prefix+" output range low", "V"; prefix+" output range high", "V";
        prefix+" CMRR @ 60 Hz", "dB";
        prefix+" CMRR @ 150 Hz", "dB"; prefix+" PSRR+ @ 60 Hz", "dB";
        prefix+" PSRR+ @ 150 Hz", "dB"; prefix+" PSRR- @ 60 Hz", "dB";
        prefix+" PSRR- @ 150 Hz", "dB";
        prefix+" input-referred noise 0.05-150 Hz", "uVrms";
        prefix+" THD @ 60 Hz, "+ ...
            thdInputText(cfg.thdInputVpp_V(gain == cfg.gains))+" Vpp", "%"]; %#ok<AGROW>
end
end

function text = thdInputText(value)
text = string(sprintf('%.2f',value));
end

function specifications = specStrings(parameters,cfg)
specifications = strings(size(parameters));
for index = 1:numel(parameters), specifications(index) = specText(parameters(index),cfg); end
end

function specification = specText(parameter,cfg)
parameter = string(parameter);
if any(parameter == ["FDC bias current" "CMFB bias current"])
    specification = sprintf('%g±%g',cfg.biasTarget_uA,cfg.biasTolerance_uA);
elseif parameter == "Total current", specification = "≤"+cfg.totalCurrentLimit_mA;
elseif parameter == "Total power", specification = "≤"+cfg.totalPowerLimit_mW;
elseif parameter == "Output CM error", specification = "±"+cfg.outputCmErrorLimit_mV;
elseif endsWith(parameter," input offset"), specification = "±"+cfg.offsetLimit_mV;
elseif endsWith(parameter," gain error"), specification = "±"+cfg.gainErrorLimit_pct;
elseif endsWith(parameter," -3 dB bandwidth"), specification = "≥"+cfg.bandwidthLimit_MHz;
elseif contains(parameter,"CMRR @") || contains(parameter,"PSRR+") || contains(parameter,"PSRR-")
    specification = "≥"+cfg.rejectionLimit_dB;
elseif contains(parameter,"input-referred noise"), specification = "≤"+cfg.noiseLimit_uVrms;
elseif contains(parameter," THD @ 60 Hz"), specification = "≤"+cfg.thdLimit_pct;
else, specification = "";
end
for gainIndex = 1:numel(cfg.gains)
    prefix = "G"+cfg.gains(gainIndex);
    if parameter == prefix+" input range low"
        specification = "≤-"+cfg.inputRangeLimit_V(gainIndex);
    elseif parameter == prefix+" input range high"
        specification = "≥"+cfg.inputRangeLimit_V(gainIndex);
    elseif parameter == prefix+" output range low"
        specification = "≤-"+cfg.outputRangeLimit_V;
    elseif parameter == prefix+" output range high"
        specification = "≥"+cfg.outputRangeLimit_V;
    end
end
end

function checkReportSpecCoverage(rows,specifications)
p = rows(:,1);
descriptive = rows(:,2) == "" | p == "AVDD" | p == "Temperature" | ...
    p == "Shared OP gain code" | endsWith(p," target gain") | ...
    contains(p," gain @ 10 Hz") | contains(p," gain @ 150 Hz");
missing = rows(:,2) ~= "" & strlength(specifications) == 0 & ~descriptive;
if any(missing)
    error('PGA_Analyze:MissingReportSpec','Rows lack specifications: %s',strjoin(p(missing),', '));
end
end

function pass = specPass(parameter,value,cfg)
if ~isfinite(value), pass = false; return; end
p = string(parameter);
if any(p == ["FDC bias current" "CMFB bias current"])
    pass = abs(value-cfg.biasTarget_uA) <= cfg.biasTolerance_uA;
elseif p == "Total current", pass = value <= cfg.totalCurrentLimit_mA;
elseif p == "Total power", pass = value <= cfg.totalPowerLimit_mW;
elseif p == "Output CM error", pass = abs(value) <= cfg.outputCmErrorLimit_mV;
elseif endsWith(p," input offset"), pass = abs(value) <= cfg.offsetLimit_mV;
elseif endsWith(p," gain error"), pass = abs(value) <= cfg.gainErrorLimit_pct;
elseif endsWith(p," -3 dB bandwidth"), pass = value >= cfg.bandwidthLimit_MHz;
elseif contains(p,"CMRR @") || contains(p,"PSRR+") || contains(p,"PSRR-")
    pass = value >= cfg.rejectionLimit_dB;
elseif contains(p,"input-referred noise"), pass = value <= cfg.noiseLimit_uVrms;
elseif contains(p," THD @ 60 Hz"), pass = value <= cfg.thdLimit_pct;
else, pass = true;
end
for gainIndex = 1:numel(cfg.gains)
    prefix = "G"+cfg.gains(gainIndex);
    if p == prefix+" input range low"
        pass = value <= -cfg.inputRangeLimit_V(gainIndex);
    elseif p == prefix+" input range high"
        pass = value >= cfg.inputRangeLimit_V(gainIndex);
    elseif p == prefix+" output range low"
        pass = value <= -cfg.outputRangeLimit_V;
    elseif p == prefix+" output range high"
        pass = value >= cfg.outputRangeLimit_V;
    end
end
end

function checkPvtSpecifications(rows,values,corners,cfg)
required = strlength(specStrings(rows(:,1),cfg)) > 0;
failures = strings(0,1); passedCorners = 0;
for cornerIndex = 1:numel(corners)
    cornerPass = true;
    for rowIndex = find(required)'
        if ~specPass(rows(rowIndex,1),values(rowIndex,cornerIndex),cfg)
            cornerPass = false;
            failures(end+1) = sprintf('%s: %s=%s %s',corners(cornerIndex), ...
                rows(rowIndex,1),formatOne(values(rowIndex,cornerIndex)), ...
                rows(rowIndex,2)); %#ok<AGROW>
        end
    end
    passedCorners = passedCorners+cornerPass;
end
if isempty(failures)
    fprintf('\nPGA FULL-PVT VERIFICATION: PASS (%d/%d corners)\n',passedCorners,numel(corners));
else
    warning('PGA_Analyze:PvtSpecFailure','PGA PVT: FAIL (%d/%d corners):\n%s', ...
        passedCorners,numel(corners),strjoin(failures,newline));
end
end

function m = analyzeCorner(resultDir,processToken,caseToken,expectedVdd_V,cfg)
opFile = fullfile(resultDir,processToken+".op_g2_"+caseToken+".txt");
m.op = analyzeOperatingPoint(readNumericFile(opFile,16),expectedVdd_V);
m.gain = cell(1,numel(cfg.gains));
for gainIndex = 1:numel(cfg.gains)
    tag = cfg.gainTags(gainIndex); stem = processToken+".%s_"+tag+"_"+caseToken+".txt";
    g.offset_V = readScalar(fullfile(resultDir,sprintf(stem,'vos')));
    g.diff = analyzeDifferential(readNumericFile(fullfile(resultDir,sprintf(stem,'diff_ac')),7), ...
        cfg.gains(gainIndex),cfg);
    g.rejection = analyzeRejection( ...
        readNumericFile(fullfile(resultDir,sprintf(stem,'cmrr_ac')),5), ...
        readNumericFile(fullfile(resultDir,sprintf(stem,'psrrp_ac')),5), ...
        readNumericFile(fullfile(resultDir,sprintf(stem,'psrrn_ac')),5),g.diff,cfg);
    g.noise = analyzeNoise(readNumericFile(fullfile(resultDir,sprintf(stem,'noise')),3),cfg);
    g.vtc = analyzeVtc(readNumericFile(fullfile(resultDir,sprintf(stem,'vtc')),6), ...
        cfg.vtcCenterFitHalfWidth_V(gainIndex),cfg.vtcCompression_pct);
    g.thd = analyzeThd(readNumericFile(fullfile(resultDir,sprintf(stem,'thd')),3), ...
        cfg.thdFrequency_Hz);
    m.gain{gainIndex} = g;
end
end

function result = analyzeOperatingPoint(data,expectedVdd_V)
op = data(end,:); result.vdd_V = op(2); result.outputCmError_V = op(10);
result.totalCurrent_A = op(13); result.totalPower_W = op(14);
result.fdcBias_A = op(15); result.cmfbBias_A = op(16);
if abs(result.vdd_V-expectedVdd_V) > 1e-6
    error('PGA_Analyze:SupplyMismatch','OP AVDD %.9g V; expected %.9g V.', ...
        result.vdd_V,expectedVdd_V);
end
end

function result = analyzeDifferential(data,targetGain,cfg)
f = data(:,1); validateFrequency(f,'differential AC');
vin = complex(data(:,2),data(:,3)); vout = complex(data(:,4),data(:,5));
if any(abs(vin) == 0), error('PGA_Analyze:ZeroDifferentialInput','Zero AC input.'); end
gain = abs(vout./vin); gain_dB = 20*log10(gain);
gain10_dB = interpLog(f,gain_dB,cfg.referenceFrequency_Hz);
result.frequency_Hz = f; result.gain_VV = gain; result.gain_dB = gain_dB;
result.relativeGain_dB = gain_dB-gain10_dB;
result.gain10_VV = 10^(gain10_dB/20);
result.gain150_VV = 10^(interpLog(f,gain_dB,cfg.bandEdge_Hz)/20);
result.gainError_pct = 100*(result.gain10_VV/targetGain-1);
result.bandwidth3dB_Hz = descendingCrossing(f,result.relativeGain_dB,-3, ...
    cfg.referenceFrequency_Hz);
end

function result = analyzeRejection(cmData,pData,nData,diff,cfg)
testF = cfg.rejectionFrequencies_Hz;
ad = interpLog(diff.frequency_Hz,diff.gain_VV,testF);
[cmF,cm] = transferMagnitudeCurve(cmData,'CMRR AC');
[pF,p] = transferMagnitudeCurve(pData,'PSRR+ AC');
[nF,n] = transferMagnitudeCurve(nData,'PSRR- AC');
result.cmrr_dB = 20*log10(ad./interpLog(cmF,cm,testF));
result.psrrP_dB = 20*log10(ad./interpLog(pF,p,testF));
result.psrrN_dB = 20*log10(ad./interpLog(nF,n,testF));
result.frequency_Hz = cmF;
adCurve = interpLog(diff.frequency_Hz,diff.gain_VV,cmF);
result.cmrrCurve_dB = 20*log10(adCurve./cm);
result.psrrPCurve_dB = 20*log10(adCurve./interpLog(pF,p,cmF));
result.psrrNCurve_dB = 20*log10(adCurve./interpLog(nF,n,cmF));
end

function [f,magnitude] = transferMagnitudeCurve(data,label)
f = data(:,1); validateFrequency(f,label);
source = complex(data(:,2),data(:,3)); output = complex(data(:,4),data(:,5));
if any(abs(source) == 0), error('PGA_Analyze:ZeroAcSource','%s has zero source.',label); end
magnitude = abs(output./source);
end

function result = analyzeNoise(data,cfg)
f = data(:,1); validateFrequency(f,'noise');
result.frequency_Hz = f; result.inputDensity_VrtHz = abs(data(:,3));
result.inputRms_V = integrateDensity(f,result.inputDensity_VrtHz,cfg.noiseBand_Hz);
end

function result = analyzeVtc(data,fitHalfWidth_V,compression_pct)
vinDiff_V = data(:,2);
pgaOutDiff_V = data(:,6);
if any(diff(vinDiff_V) <= 0)
    error('PGA_Analyze:VtcInput','PGA VTC input must be strictly increasing.');
end

[~,zeroIndex] = min(abs(pgaOutDiff_V));
fitRows = abs(vinDiff_V-vinDiff_V(zeroIndex)) <= fitHalfWidth_V;
if nnz(fitRows) < 3
    error('PGA_Analyze:VtcFit', ...
        'PGA VTC central gain fit requires at least three samples.');
end
centralFit = polyfit(vinDiff_V(fitRows),pgaOutDiff_V(fitRows),1);
centralGain_VV = centralFit(1);
if ~isfinite(centralGain_VV) || abs(centralGain_VV) <= eps
    error('PGA_Analyze:VtcGain', ...
        'PGA VTC central DC gain must be finite and nonzero.');
end

localGain_VV = gradient(pgaOutDiff_V)./gradient(vinDiff_V);
gainError_pct = 100*abs(localGain_VV/centralGain_VV-1);

negativeInsideIndex = zeroIndex;
negativeOutsideIndex = [];
for index = zeroIndex-1:-1:1
    if isfinite(gainError_pct(index)) && gainError_pct(index) <= compression_pct
        negativeInsideIndex = index;
    else
        negativeOutsideIndex = index;
        break;
    end
end

positiveInsideIndex = zeroIndex;
positiveOutsideIndex = [];
for index = zeroIndex+1:numel(vinDiff_V)
    if isfinite(gainError_pct(index)) && gainError_pct(index) <= compression_pct
        positiveInsideIndex = index;
    else
        positiveOutsideIndex = index;
        break;
    end
end

negativeAtBoundary = isempty(negativeOutsideIndex);
positiveAtBoundary = isempty(positiveOutsideIndex);
if negativeAtBoundary
    inputNegative_V = vinDiff_V(1);
    outputNegative_V = pgaOutDiff_V(1);
else
    inputNegative_V = compressionCrossing( ...
        vinDiff_V(negativeOutsideIndex),gainError_pct(negativeOutsideIndex), ...
        vinDiff_V(negativeInsideIndex),gainError_pct(negativeInsideIndex), ...
        compression_pct);
    outputNegative_V = interp1(vinDiff_V,pgaOutDiff_V,inputNegative_V,'linear');
end
if positiveAtBoundary
    inputPositive_V = vinDiff_V(end);
    outputPositive_V = pgaOutDiff_V(end);
else
    inputPositive_V = compressionCrossing( ...
        vinDiff_V(positiveInsideIndex),gainError_pct(positiveInsideIndex), ...
        vinDiff_V(positiveOutsideIndex),gainError_pct(positiveOutsideIndex), ...
        compression_pct);
    outputPositive_V = interp1(vinDiff_V,pgaOutDiff_V,inputPositive_V,'linear');
end

result.input_V = vinDiff_V;
result.output_V = pgaOutDiff_V;
result.centralGain_VV = centralGain_VV;
result.inputNegative_V = inputNegative_V;
result.inputPositive_V = inputPositive_V;
result.outputNegative_V = outputNegative_V;
result.outputPositive_V = outputPositive_V;
result.negativeAtBoundary = negativeAtBoundary;
result.positiveAtBoundary = positiveAtBoundary;
end

function crossing = compressionCrossing(x1,error1,x2,error2,target)
if ~all(isfinite([x1 error1 x2 error2])) || error1 == error2
    crossing = x2;
    return;
end
fraction = (target-error1)/(error2-error1);
crossing = x1+fraction*(x2-x1);
end

function result = analyzeThd(data,fundamental_Hz)
t_s = data(:,1);
pgaOutDiff_V = data(:,3);
if any(diff(t_s) <= 0)
    error('PGA_Analyze:ThdTime','THD transient time must be strictly increasing.');
end
duration_s = t_s(end)-t_s(1);
cycleCount = duration_s*fundamental_Hz;
if abs(cycleCount-round(cycleCount)) > 1e-3
    error('PGA_Analyze:ThdCycles', ...
        'THD transient must contain an integer number of cycles; found %.6g.', ...
        cycleCount);
end
pgaOutDiff_V = pgaOutDiff_V-mean(pgaOutDiff_V,'omitnan');
amplitude_Vpk = zeros(1,5);
for harmonic = 1:5
    angle = 2*pi*harmonic*fundamental_Hz*t_s;
    cosineCoefficient = 2/duration_s*trapz( ...
        t_s,pgaOutDiff_V.*cos(angle));
    sineCoefficient = 2/duration_s*trapz( ...
        t_s,pgaOutDiff_V.*sin(angle));
    amplitude_Vpk(harmonic) = hypot(cosineCoefficient,sineCoefficient);
end
if ~isfinite(amplitude_Vpk(1)) || amplitude_Vpk(1) <= 0
    error('PGA_Analyze:ThdFundamental', ...
        'THD fundamental amplitude must be finite and positive.');
end
result.amplitude_Vpk = amplitude_Vpk;
result.ratio = sqrt(sum(amplitude_Vpk(2:5).^2))/amplitude_Vpk(1);
result.percent = 100*result.ratio;
result.dB = 20*log10(result.ratio);
end

function value = integrateDensity(frequency,density,band)
[f,y] = boundedTrace(frequency,density,band); value = sqrt(trapz(f,y.^2));
end

function [boundedFrequency,boundedValue] = boundedTrace(frequency,value,band)
if band(1) < frequency(1) || band(2) > frequency(end)
    error('PGA_Analyze:BandCoverage','Band is outside the data range.');
end
inside = frequency > band(1) & frequency < band(2);
boundedFrequency = [band(1); frequency(inside); band(2)];
boundedValue = [interpLog(frequency,value,band(1)); value(inside); ...
    interpLog(frequency,value,band(2))];
end

function crossing = descendingCrossing(f,response,level,startFrequency)
start = find(f >= startFrequency,1); crossing = NaN;
if isempty(start), return; end
relative = find(response(start:end-1) > level & response(start+1:end) <= level,1);
if isempty(relative), return; end
i = start+relative-1; x1 = log10(f(i)); x2 = log10(f(i+1));
crossing = 10^(x1+(level-response(i))*(x2-x1)/(response(i+1)-response(i)));
end

function values = metricsToRaw(m,rows,temperature_C,cfg)
values = nan(size(rows,1),1);
for rowIndex = 1:size(rows,1)
    p = rows(rowIndex,1);
    switch p
        case "AVDD", values(rowIndex) = m.op.vdd_V;
        case "Temperature", values(rowIndex) = temperature_C;
        case "Shared OP gain code", values(rowIndex) = cfg.gains(1);
        case "FDC bias current", values(rowIndex) = m.op.fdcBias_A*1e6;
        case "CMFB bias current", values(rowIndex) = m.op.cmfbBias_A*1e6;
        case "Total current", values(rowIndex) = m.op.totalCurrent_A*1e3;
        case "Total power", values(rowIndex) = m.op.totalPower_W*1e3;
        case "Output CM error", values(rowIndex) = m.op.outputCmError_V*1e3;
        otherwise
            for gainIndex = 1:numel(cfg.gains)
                prefix = "G"+cfg.gains(gainIndex); g = m.gain{gainIndex};
                switch p
                    case prefix+" target gain", values(rowIndex) = cfg.gains(gainIndex);
                    case prefix+" input offset", values(rowIndex) = g.offset_V*1e3;
                    case prefix+" gain @ 10 Hz", values(rowIndex) = g.diff.gain10_VV;
                    case prefix+" gain @ 150 Hz", values(rowIndex) = g.diff.gain150_VV;
                    case prefix+" gain error", values(rowIndex) = g.diff.gainError_pct;
                    case prefix+" -3 dB bandwidth", values(rowIndex) = g.diff.bandwidth3dB_Hz*1e-6;
                    case prefix+" input range low", values(rowIndex) = g.vtc.inputNegative_V;
                    case prefix+" input range high", values(rowIndex) = g.vtc.inputPositive_V;
                    case prefix+" output range low", values(rowIndex) = g.vtc.outputNegative_V;
                    case prefix+" output range high", values(rowIndex) = g.vtc.outputPositive_V;
                    case prefix+" CMRR @ 60 Hz", values(rowIndex) = g.rejection.cmrr_dB(1);
                    case prefix+" CMRR @ 150 Hz", values(rowIndex) = g.rejection.cmrr_dB(2);
                    case prefix+" PSRR+ @ 60 Hz", values(rowIndex) = g.rejection.psrrP_dB(1);
                    case prefix+" PSRR+ @ 150 Hz", values(rowIndex) = g.rejection.psrrP_dB(2);
                    case prefix+" PSRR- @ 60 Hz", values(rowIndex) = g.rejection.psrrN_dB(1);
                    case prefix+" PSRR- @ 150 Hz", values(rowIndex) = g.rejection.psrrN_dB(2);
                    case prefix+" input-referred noise 0.05-150 Hz"
                        values(rowIndex) = g.noise.inputRms_V*1e6;
                    case prefix+" THD @ 60 Hz, "+ ...
                            thdInputText(cfg.thdInputVpp_V(gainIndex))+" Vpp"
                        values(rowIndex) = g.thd.percent;
                end
            end
    end
end
end

function relations = metricsToRelations(m,rows,cfg)
relations = strings(size(rows,1),1);
for gainIndex = 1:numel(cfg.gains)
    prefix = "G"+cfg.gains(gainIndex);
    if m.gain{gainIndex}.vtc.negativeAtBoundary
        relations(parameterIndex(rows(:,1),prefix+" input range low")) = "≤";
        relations(parameterIndex(rows(:,1),prefix+" output range low")) = "≤";
    end
    if m.gain{gainIndex}.vtc.positiveAtBoundary
        relations(parameterIndex(rows(:,1),prefix+" input range high")) = "≥";
        relations(parameterIndex(rows(:,1),prefix+" output range high")) = "≥";
    end
end
end

function result = buildFullPvtTable(rows,values,relations,corners,processes,cases,vdd,temp)
metricRows = find(rows(:,2) ~= "" & rows(:,1) ~= "AVDD" & ...
    rows(:,1) ~= "Temperature" & rows(:,1) ~= "Shared OP gain code");
nRecords = numel(corners)*numel(metricRows);
cornerCol = strings(nRecords,1); processCol = strings(nRecords,1);
caseCol = strings(nRecords,1); vddCol = nan(nRecords,1); tempCol = nan(nRecords,1);
parameterCol = strings(nRecords,1); unitCol = strings(nRecords,1); valueCol = strings(nRecords,1);
record = 0;
for cornerIndex = 1:numel(corners)
    range = record+(1:numel(metricRows)); record = range(end);
    cornerCol(range) = corners(cornerIndex); processCol(range) = processes(cornerIndex);
    caseCol(range) = cases(cornerIndex); vddCol(range) = vdd(cornerIndex);
    tempCol(range) = temp(cornerIndex); parameterCol(range) = rows(metricRows,1);
    unitCol(range) = rows(metricRows,2);
    for metricIndex = 1:numel(metricRows)
        r = metricRows(metricIndex);
        valueCol(range(metricIndex)) = formatResult( ...
            values(r,cornerIndex),relations(r,cornerIndex));
    end
end
result = table(cornerCol,processCol,caseCol,vddCol,tempCol,parameterCol,unitCol,valueCol, ...
    'VariableNames',{'Corner','Process','Environment','AVDD_V','Temperature_C', ...
    'Parameter','Unit','Value'});
end

function result = buildWorstCaseTable(rows,values,relations,corners,cfg)
settings = rows(:,1) == "AVDD" | rows(:,1) == "Temperature" | ...
    rows(:,1) == "Shared OP gain code" | endsWith(rows(:,1)," target gain");
metricRows = find(rows(:,2) ~= "" & ~settings); n = numel(metricRows);
parameters = rows(metricRows,1); units = rows(metricRows,2);
specifications = specStrings(parameters,cfg); selected = nan(n,1);
selectedRelations = strings(n,1); selectedCorners = strings(n,1);
for index = 1:n
    r = metricRows(index); candidates = values(r,:); p = parameters(index);
    if contains(p," gain @ ")
        prefix = extractBefore(p," gain @ ");
        errorRow = parameterIndex(rows(:,1),prefix+" gain error");
        [~,i] = max(abs(values(errorRow,:)));
    elseif endsWith(p," -3 dB bandwidth") || contains(p,"CMRR @") || ...
            contains(p,"PSRR+") || contains(p,"PSRR-")
        [~,i] = min(candidates);
    elseif endsWith(p," input range low") || endsWith(p," output range low")
        [~,i] = max(candidates);
    elseif endsWith(p," input range high") || endsWith(p," output range high")
        [~,i] = min(candidates);
    elseif p == "Total current" || p == "Total power" || ...
            contains(p,"input-referred noise") || contains(p," THD @ 60 Hz")
        [~,i] = max(candidates);
    elseif any(p == ["FDC bias current" "CMFB bias current"])
        [~,i] = max(abs(candidates-cfg.biasTarget_uA));
    else, [~,i] = max(abs(candidates));
    end
    selected(index) = candidates(i);
    selectedRelations(index) = relations(r,i);
    selectedCorners(index) = corners(i);
end
formatted = strings(n,1);
for index = 1:n
    formatted(index) = formatResult(selected(index),selectedRelations(index));
end
result = table(parameters,units,specifications,formatted,selectedCorners, ...
    'VariableNames',{'Parameter','Unit','Spec','Value','Corner'});
end

function runMcSection(scriptDir,plotDir,reportDir,cfg)
modes = ["MM" "GL" "FULL"]; defs = mcDefinitions(cfg); results = cell(3,1);
for modeIndex = 1:3
    mode = modes(modeIndex); resultDir = fullfile(scriptDir,lower(mode)+".Result_txt");
    opFile = fullfile(resultDir,lower(mode)+".op_mc_summary.txt");
    opRaw = readMcSummary(opFile,6);
    gainRaw = cell(1,4);
    for gainIndex = 1:4
        file = fullfile(resultDir,lower(mode)+"."+cfg.gainTags(gainIndex)+"_mc_summary.txt");
        gainRaw{gainIndex} = readMcSummary(file,8);
    end
    [opRaw,gainRaw] = joinMcByRun(opRaw,gainRaw,mode,cfg);
    results{modeIndex} = summarizeMc(opRaw,gainRaw,defs,mode,cfg);
    printMcSummary(results{modeIndex});
    writetable(results{modeIndex}.table,fullfile(reportDir,mode+"_MC_Summary.csv"));
end
runTable = table(modes',cellfun(@(r)r.requested,results),cellfun(@(r)r.valid,results), ...
    cellfun(@(r)r.failed,results),cellfun(@(r)r.overallYield,results), ...
    'VariableNames',{'Mode','RequestedRuns','ValidRuns','FailedRuns','OverallYield_pct'});
writetable(runTable,fullfile(reportDir,'MC_Run_Summary.csv'));
plotMcGainGrid(results,defs,cfg,"input offset",'Fig_MC_01_Input_Offset_Histogram.png',plotDir);
plotMcGainGrid(results,defs,cfg,"gain error",'Fig_MC_02_Gain_Error_Histogram.png',plotDir);
plotMcGainGrid(results,defs,cfg,"-3 dB bandwidth",'Fig_MC_03_Bandwidth_Histogram.png',plotDir);
plotMcGainGrid(results,defs,cfg,"CMRR @ 60 Hz",'Fig_MC_04_CMRR_60Hz_Histogram.png',plotDir);
end

function defs = mcDefinitions(cfg)
defs.names = ["FDC bias current" "CMFB bias current" "Total current" "Total power" "Output CM error"];
defs.units = ["uA" "uA" "mA" "mW" "mV"];
for gain = cfg.gains
    prefix = "G"+gain;
    defs.names = [defs.names prefix+" input offset" prefix+" gain @ 10 Hz" ...
        prefix+" gain @ 150 Hz" prefix+" gain error" prefix+" -3 dB bandwidth" ...
        prefix+" CMRR @ 60 Hz" prefix+" CMRR @ 150 Hz"];
    defs.units = [defs.units "mV" "V/V" "V/V" "%" "MHz" "dB" "dB"];
end
defs.specs = specStrings(defs.names,cfg); defs.required = strlength(defs.specs) > 0;
end

function raw = readMcSummary(filePath,expectedColumns)
if ~isfile(filePath), error('PGA_Analyze:MissingMcSummary','Missing %s',filePath); end
raw = readmatrix(filePath,'FileType','text'); raw = raw(any(isfinite(raw),2),:);
raw = raw(:,any(isfinite(raw),1));
if size(raw,2) ~= expectedColumns
    error('PGA_Analyze:McColumns','%s must have %d numeric columns; found %d.', ...
        filePath,expectedColumns,size(raw,2));
end
end

function [opRaw,gainRaw] = joinMcByRun(opRaw,gainRaw,mode,cfg)
runIds = opRaw(:,1);
if any(~isfinite(runIds)) || numel(unique(runIds)) ~= numel(runIds)
    error('PGA_Analyze:DuplicateMcRun','%s OP summary has invalid or duplicate run IDs.',mode);
end
for gainIndex = 1:numel(gainRaw)
    gainRunIds = gainRaw{gainIndex}(:,1);
    if any(~isfinite(gainRunIds)) || numel(unique(gainRunIds)) ~= numel(gainRunIds)
        error('PGA_Analyze:DuplicateMcRun', ...
            '%s G%d summary has invalid or duplicate run IDs.',mode,cfg.gains(gainIndex));
    end
    [present,locations] = ismember(runIds,gainRunIds);
    if ~all(present) || numel(gainRunIds) ~= numel(runIds) || ...
            ~all(ismember(gainRunIds,runIds))
        error('PGA_Analyze:McRunAlignment', ...
            '%s OP and G%d summaries do not contain the same run IDs.', ...
            mode,cfg.gains(gainIndex));
    end
    gainRaw{gainIndex} = gainRaw{gainIndex}(locations,:);
end
end

function result = summarizeMc(opRaw,gainRaw,defs,mode,cfg)
runIds = opRaw(:,1);
values = [opRaw(:,2)*1e6 opRaw(:,3)*1e6 opRaw(:,4)*1e3 ...
    opRaw(:,5)*1e3 opRaw(:,6)*1e3];
for gainIndex = 1:4
    d = gainRaw{gainIndex};
    values = [values d(:,2)*1e3 d(:,3) d(:,5) d(:,4) ...
        d(:,6)*1e-6 d(:,7) d(:,8)]; %#ok<AGROW>
end
validMask = all(isfinite(values(:,defs.required)),2); count = numel(defs.names);
stats = nan(count,7); yield = nan(count,1); pass = false(size(values));
for j = 1:count
    sample = values(validMask & isfinite(values(:,j)),j); if isempty(sample), continue; end
    mu = mean(sample); sigma = std(sample,0);
    stats(j,:) = [min(sample) mu-3*sigma mu-sigma mu mu+sigma mu+3*sigma max(sample)];
    if defs.required(j)
        for i = find(validMask)', pass(i,j) = specPass(defs.names(j),values(i,j),cfg); end
        yield(j) = 100*nnz(pass(validMask,j))/nnz(validMask);
    end
end
if any(validMask), overallYield = 100*nnz(all(pass(validMask,defs.required),2))/nnz(validMask);
else, overallYield = NaN; end
result.mode = mode; result.runIds = runIds; result.values = values;
result.validMask = validMask; result.stats = stats; result.requested = cfg.mcRequestedRuns;
result.valid = nnz(validMask); result.failed = max(0,cfg.mcRequestedRuns-result.valid);
result.overallYield = overallYield; yieldText = strings(count,1);
for j = 1:count, if defs.required(j), yieldText(j) = sprintf('%.2f',yield(j)); end, end
result.table = table(defs.names',defs.units',defs.specs',stats(:,1),stats(:,2), ...
    stats(:,3),stats(:,4),stats(:,5),stats(:,6),stats(:,7),yieldText, ...
    'VariableNames',{'Parameter','Unit','Spec','Min','MeanMinus3Sigma', ...
    'MeanMinusSigma','Mean','MeanPlusSigma','MeanPlus3Sigma','Max','Yield_pct'});
end

function printMcSummary(result)
fprintf('\n%s MONTE CARLO SUMMARY\n',result.mode);
fprintf('Requested: %d  Valid: %d  Failed: %d  Overall yield: %.2f%%\n', ...
    result.requested,result.valid,result.failed,result.overallYield);
w = max(46,max(strlength(result.table.Parameter))+2);
fprintf('%-*s %-8s %-12s %10s %10s %10s %10s %10s %10s %10s %9s\n', ...
    w,'Parameter','Unit','Spec','Min','μ-3σ','μ-σ','Mean','μ+σ','μ+3σ','Max','Yield');
for j = 1:height(result.table)
    t = result.table;
    fprintf('%-*s %-8s %-12s %10s %10s %10s %10s %10s %10s %10s %9s\n',w, ...
        t.Parameter(j),t.Unit(j),t.Spec(j),formatFixed(t.Min(j)), ...
        formatFixed(t.MeanMinus3Sigma(j)),formatFixed(t.MeanMinusSigma(j)), ...
        formatFixed(t.Mean(j)),formatFixed(t.MeanPlusSigma(j)), ...
        formatFixed(t.MeanPlus3Sigma(j)),formatFixed(t.Max(j)),t.Yield_pct(j));
end
end

function plotMcGainGrid(results,defs,cfg,suffix,fileName,plotDir)
fig = figure; layout = tiledlayout(fig,2,2);
for gainIndex = 1:4
    parameter = "G"+cfg.gains(gainIndex)+" "+suffix;
    metricIndex = parameterIndex(defs.names,parameter);
    nexttile(layout); hold on;
    valueSets = cellfun(@(r)r.values(r.validMask,metricIndex),results,'UniformOutput',false);
    allValues = vertcat(valueSets{:}); bounds = mcSpecBounds(parameter,cfg);
    [lo,hi,fullResult] = mcDisplayRange(allValues,results,metricIndex);
    edges = linspace(lo,hi,21); colors = lines(3); distributionLines = gobjects(3,1);
    for k = 1:3
        sample = valueSets{k}; sample = sample(isfinite(sample) & sample >= lo & sample <= hi);
        probability = 100*histcounts(sample,edges,'Normalization','probability');
        distributionLines(k) = stairs(edges,[probability 0], ...
            'LineWidth',1.5,'Color',colors(k,:), ...
            'DisplayName',results{k}.mode);
    end
    for x = bounds(isfinite(bounds))
        if x >= lo && x <= hi
            xline(x,'--','HandleVisibility','off');
        end
    end
    addFullStatMarkers(fullResult,metricIndex); xlim([lo hi]); ylabel('Samples (%)');
    stylePlot(suffix+" ("+defs.units(metricIndex)+")", ...
        "("+char('a'+gainIndex-1)+") G"+cfg.gains(gainIndex));
    legend(distributionLines,{'MM','GL','FULL'},'Location','northeast');
end
sgtitle(layout,"PGA "+suffix+" Distribution - MM / GL / FULL");
savePlot(fig,plotDir,fileName);
end

function bounds = mcSpecBounds(parameter,cfg)
if endsWith(parameter,"input offset")
    bounds = [-cfg.offsetLimit_mV cfg.offsetLimit_mV];
elseif endsWith(parameter,"gain error")
    bounds = [-cfg.gainErrorLimit_pct cfg.gainErrorLimit_pct];
elseif endsWith(parameter,"-3 dB bandwidth")
    bounds = [cfg.bandwidthLimit_MHz Inf];
elseif contains(parameter,"CMRR @")
    bounds = [cfg.rejectionLimit_dB Inf];
else
    bounds = [-Inf Inf];
end
end

function [lo,hi,fullResult] = mcDisplayRange(values,results,index)
fullIndex = find(cellfun(@(r)strcmpi(string(r.mode),"FULL"),results),1);
if isempty(fullIndex)
    fullIndex = numel(results);
end
fullResult = results{fullIndex};

center = fullResult.stats(index,4);
if ~isfinite(center)
    fullValues = fullResult.values(:,index);
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

finiteLimits = limits(isfinite(limits));
if isempty(finiteLimits)
    halfRange = max(abs(values-center),[],'omitnan');
else
    halfRange = max(abs(finiteLimits-center),[],'omitnan');
end
if ~isfinite(halfRange) || halfRange <= 0
    halfRange = max(abs(center)*0.05,1);
end
halfRange = 1.05*halfRange;
lo = center-halfRange;
hi = center+halfRange;
end

function addFullStatMarkers(fullResult,index)
markers = fullResult.stats(index,2:6); labels = ["-3σ" "-σ" "μ" "+σ" "+3σ"];
for k = 1:5, addCursorLine(markers(k),labels(k)); end
end

function plotNominalDifferential(nominal,plotDir,cfg)
fig = figure; hold on; colors = lines(numel(cfg.gains));
gainLines = gobjects(numel(cfg.gains),1);
for k = 1:4
    g = nominal.gain{k};
    targetGain_dB = 20*log10(cfg.gains(k));
    gainLines(k) = semilogx(g.diff.frequency_Hz,g.diff.gain_dB, ...
        'LineWidth',1.5,'Color',colors(k,:),'DisplayName',"G"+cfg.gains(k));
    yline(targetGain_dB,':',sprintf('%g V/V',cfg.gains(k)), ...
        'Color','w','HandleVisibility','off');
    xline(g.diff.bandwidth3dB_Hz,'--', ...
        "G"+cfg.gains(k)+" -3dB: "+frequencyText(g.diff.bandwidth3dB_Hz), ...
        'Color','w','HandleVisibility','off', ...
        'LabelVerticalAlignment','bottom');
end
set(gca,'XScale','log'); xlim([0.01 1e8]); ylabel('Differential gain (dB)');
legend(gainLines,cellstr("G"+string(cfg.gains)),'Location','southwest');
stylePlot('Frequency (Hz)','PGA Differential Frequency Response - NOM');
savePlot(fig,plotDir,'NOM.PGA_differential_ac.png');
end

function plotNominalVtc(nominal,plotDir,cfg)
fig = figure;
layout = tiledlayout(fig,2,2);
for gainIndex = 1:numel(cfg.gains)
    gain = cfg.gains(gainIndex);
    vtc = nominal.gain{gainIndex}.vtc;
    nexttile(layout);
    plot(vtc.input_V,vtc.output_V,'LineWidth',1.5, ...
        'DisplayName','Simulated');
    hold on;
    plot(vtc.input_V,gain*vtc.input_V,'--','LineWidth',1.2, ...
        'DisplayName',sprintf('Ideal G = %g V/V',gain));

    inputPoints = [vtc.inputNegative_V vtc.inputPositive_V];
    outputPoints = [vtc.outputNegative_V vtc.outputPositive_V];
    boundaryMask = [vtc.negativeAtBoundary vtc.positiveAtBoundary];
    if any(~boundaryMask)
        plot(inputPoints(~boundaryMask),outputPoints(~boundaryMask), ...
            'o','MarkerSize',7,'LineWidth',1.2, ...
            'DisplayName','1% compression points');
    end
    if any(boundaryMask)
        plot(inputPoints(boundaryMask),outputPoints(boundaryMask), ...
            's','MarkerSize',7,'LineWidth',1.2, ...
            'DisplayName','Sweep boundaries');
    end

    lowRelation = "";
    highRelation = "";
    if vtc.negativeAtBoundary, lowRelation = "≤"; end
    if vtc.positiveAtBoundary, highRelation = "≥"; end
    xline(vtc.inputNegative_V,':', ...
        sprintf('Input low: %s%.3f V',lowRelation,vtc.inputNegative_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
    xline(vtc.inputPositive_V,':', ...
        sprintf('Input high: %s%.3f V',highRelation,vtc.inputPositive_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','right');
    yline(vtc.outputNegative_V,':', ...
        sprintf('Output low: %s%.3f V',lowRelation,vtc.outputNegative_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','bottom', ...
        'LabelHorizontalAlignment','right');
    yline(vtc.outputPositive_V,':', ...
        sprintf('Output high: %s%.3f V',highRelation,vtc.outputPositive_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','top', ...
        'LabelHorizontalAlignment','left');

    xline(-cfg.inputRangeLimit_V(gainIndex),'--','HandleVisibility','off');
    xline(cfg.inputRangeLimit_V(gainIndex),'--','HandleVisibility','off');
    yline(-cfg.outputRangeLimit_V,'--','HandleVisibility','off');
    yline(cfg.outputRangeLimit_V,'--','HandleVisibility','off');
    ylabel('Differential output (V)');
    legend('Location','best');
    stylePlot('Differential input (V)', ...
        "("+char('a'+gainIndex-1)+") G"+gain);
end
sgtitle(layout,'PGA VTC + 1% Compression - NOM');
savePlot(fig,plotDir,'NOM.PGA_vtc.png',[10 7]);
end

function plotNominalNoise(nominal,plotDir,cfg)
fig = figure; hold on; colors = lines(numel(cfg.gains));
noiseLines = gobjects(numel(cfg.gains),1);
integratedText = strings(numel(cfg.gains),1);
for k = 1:4
    g = nominal.gain{k};
    density = g.noise.inputDensity_VrtHz*1e9;
    noiseLines(k) = loglog(g.noise.frequency_Hz,density,'LineWidth',1.5, ...
        'Color',colors(k,:),'DisplayName',"G"+cfg.gains(k));
    integratedText(k) = "G"+cfg.gains(k)+": "+ ...
        sprintf('%.3f uVrms',g.noise.inputRms_V*1e6);
end
set(gca,'XScale','log','YScale','log');
for f = [0.05 1 60 150]
    xline(f,':'," "+frequencyText(f),'Color','w','HandleVisibility','off', ...
        'LabelVerticalAlignment','middle','LabelHorizontalAlignment','left');
end
addMetricBox(["Integrated 0.05-150 Hz"; integratedText]);
xlim([0.04 500]); ylabel('Input-referred noise density (nV/sqrt(Hz))');
legend(noiseLines,cellstr("G"+string(cfg.gains)),'Location','southwest');
stylePlot('Frequency (Hz)','PGA Input-Referred Noise Density - NOM');
savePlot(fig,plotDir,'NOM.PGA_noise.png');
end

function plotNominalRejection(nominal,plotDir,cfg)
fig = figure; layout = tiledlayout(fig,3,1); colors = lines(numel(cfg.gains));
responseFields = ["cmrrCurve_dB" "psrrPCurve_dB" "psrrNCurve_dB"];
responseNames = ["CMRR" "PSRR+" "PSRR-"];
for responseIndex = 1:3
    nexttile(layout); hold on;
    responseLines = gobjects(numel(cfg.gains),1); allValues = [];
    for gainIndex = 1:numel(cfg.gains)
        r = nominal.gain{gainIndex}.rejection;
        response = r.(responseFields(responseIndex));
        responseLines(gainIndex) = semilogx(r.frequency_Hz,response, ...
            'LineWidth',1.5,'Color',colors(gainIndex,:), ...
            'DisplayName',"G"+cfg.gains(gainIndex));
        allValues = [allValues; response(:)]; %#ok<AGROW>
    end
    for f = cfg.rejectionFrequencies_Hz
        xline(f,':'," "+frequencyText(f),'HandleVisibility','off', ...
            'Color','w','LabelVerticalAlignment','middle', ...
            'LabelHorizontalAlignment','left');
    end
    yline(cfg.rejectionLimit_dB,'--',cfg.rejectionLimit_dB+" dB", ...
        'Color','w','HandleVisibility','off', ...
        'LabelHorizontalAlignment','left');
    allValues = allValues(isfinite(allValues));
    ylim([min(70,min(allValues)-5) max(allValues)+5]);
    set(gca,'XScale','log'); xlim([0.01 1e5]); ylabel('Rejection (dB)');
    legend(responseLines,cellstr("G"+string(cfg.gains)),'Location','best');
    if responseIndex == 3, xLabel = 'Frequency (Hz)'; else, xLabel = ''; end
    stylePlot(xLabel,"("+char('a'+responseIndex-1)+") PGA "+ ...
        responseNames(responseIndex)+" - NOM");
end
savePlot(fig,plotDir,'NOM.PGA_rejection.png');
end

function plotSelectorTransient(scriptDir,plotDir)
file = fullfile(scriptDir,'nom.Result_txt','nom.sel_tran_nom.txt');
data = readNumericFile(file,5); time = data(:,1)*1e3; sel = data(:,2);
internal = data(:,3)*1e3; external = data(:,4)*1e3; output = data(:,5)*1e3;
switchTime = selectorSwitchTime(time,sel,file); fig = figure; layout = tiledlayout(fig,3,1);
a1 = nexttile(layout); plot(time,sel,'LineWidth',1.5); hold on;
addSelectorSwitchGuide(switchTime,true); ylabel('SEL (V)'); stylePlot('','(a) SEL Control');
a2 = nexttile(layout); plot(time,internal,'LineWidth',1.5,'DisplayName','PGA internal'); hold on;
plot(time,external,'--','LineWidth',1.5,'DisplayName','External');
addSelectorSwitchGuide(switchTime,false); ylabel('Differential voltage (mV)');
legend('Location','best'); stylePlot('','(b) Available PGA and External Signals');
a3 = nexttile(layout); plot(time,output,'LineWidth',2,'DisplayName','OUT differential'); hold on;
addSelectorSwitchGuide(switchTime,false); ylabel('Differential voltage (mV)');
stylePlot('Time (ms)','(c) Selected Output'); linkaxes([a1 a2 a3],'x'); xlim([time(1) time(end)]);
sgtitle('SEL PGA / EXT Functional Check - NOM'); savePlot(fig,plotDir,'NOM.PGA_SEL_functional_check.png');
end

function plotGainSwitchTransient(scriptDir,plotDir,cfg)
file = fullfile(scriptDir,'nom.Result_txt','nom.gain_switch_tran_nom.txt');
if ~isfile(file)
    warning('PGA_Analyze:MissingGainSwitchTransient', ...
        'Gain-switch plot skipped because %s is missing.',file); return;
end
data = readNumericFile(file,5); time = data(:,1)*1e3; fig = figure;
layout = tiledlayout(fig,3,1); nexttile(layout);
stairs(time,data(:,2),'LineWidth',1.5,'DisplayName','S1'); hold on;
stairs(time,data(:,3),'--','LineWidth',1.5,'DisplayName','S0');
ylabel('Control (V)'); legend('Location','best'); stylePlot('','(a) Gain Code');
nexttile(layout); plot(time,data(:,4)*1e3,'LineWidth',1.5);
ylabel('Input diff. (mV)'); stylePlot('','(b) PGA Input');
nexttile(layout); plot(time,data(:,5)*1e3,'LineWidth',1.5);
ylabel('Output diff. (mV)'); stylePlot('Time (ms)','(c) PGA Output');
sgtitle("PGA Gain Switching G"+strjoin(string(cfg.gains),' → G')+" - NOM");
savePlot(fig,plotDir,'NOM.PGA_gain_switching.png');
end

function switchTime = selectorSwitchTime(time,sel,file)
low = min(sel,[],'omitnan'); high = max(sel,[],'omitnan');
index = find(sel >= 0.5*(low+high),1,'first');
if ~isfinite(low) || ~isfinite(high) || high <= low || isempty(index)
    error('PGA_Analyze:SelectorSwitch','No selector transition in %s.',file);
end
switchTime = time(index);
end

function addSelectorSwitchGuide(time,showLabels)
xline(time,'--','HandleVisibility','off');
if showLabels
    text(0.25,0.90,'PGA Selected','Units','normalized','HorizontalAlignment','center', ...
        'VerticalAlignment','top','HandleVisibility','off');
    text(0.75,0.90,'EXT Selected','Units','normalized','HorizontalAlignment','center', ...
        'VerticalAlignment','top','HandleVisibility','off');
end
end

function printSummaryTable(rows,specs,columns,values)
w = max(46,max(strlength(rows(:,1)))+2); fprintf('%-*s %-8s %-14s',w,'Parameter','Unit','Spec');
for i = 1:numel(columns), fprintf(' %13s',columns(i)); end
fprintf('\n%s\n',repmat('-',1,w+24+14*numel(columns)));
for r = 1:size(rows,1)
    if rows(r,1) == "" && rows(r,2) == "", fprintf('\n');
    elseif rows(r,2) == "", fprintf('%-*s\n',w,upper(rows(r,1)));
    else
        fprintf('%-*s %-8s %-14s',w,rows(r,1),rows(r,2),specs(r));
        for c = 1:numel(columns), fprintf(' %13s',values(r,c)); end
        fprintf('\n');
    end
end
end

function printWorstCaseTable(t)
w = max(46,max(strlength(t.Parameter))+2);
fprintf('%-*s %-8s %-14s %13s %-10s\n',w,'Parameter','Unit','Spec','Value','Corner');
fprintf('%s\n',repmat('-',1,w+49));
for i = 1:height(t)
    fprintf('%-*s %-8s %-14s %13s %-10s\n',w,t.Parameter(i),t.Unit(i), ...
        t.Spec(i),t.Value(i),t.Corner(i));
end
end

function formatted = formatReportValues(values,relations)
formatted = strings(size(values));
for r = 1:size(values,1)
    for c = 1:size(values,2)
        formatted(r,c) = formatResult(values(r,c),relations(r,c));
    end
end
end

function text = formatResult(value,relation)
text = string(relation)+formatOne(value);
end

function text = formatOne(value)
if ~isfinite(value), text = "NaN"; return; end
if abs(value) > 0 && (abs(value) < 1e-3 || abs(value) >= 1e4)
    text = string(sprintf('%.3e',value));
else
    text = string(sprintf('%.3f',value));
end
end

function text = formatFixed(value)
if ~isfinite(value)
    text = "NaN";
elseif abs(value) > 0 && (abs(value) < 1e-3 || abs(value) >= 1e4)
    text = string(sprintf('%.3e',value));
else
    text = string(sprintf('%.3f',value));
end
end

function index = parameterIndex(parameters,parameter)
index = find(parameters == parameter,1);
if isempty(index), error('PGA_Analyze:MissingParameter','Missing parameter: %s',parameter); end
end

function value = readScalar(file)
data = readNumericFile(file,1); value = data(find(isfinite(data(:,1)),1,'last'),1);
end

function data = readNumericFile(file,minimumColumns)
if ~isfile(file), error('PGA_Analyze:MissingFile','Missing result file: %s',file); end
data = readmatrix(file,'FileType','text'); data = data(any(isfinite(data),2),:);
data = data(:,any(isfinite(data),1));
if isempty(data) || size(data,2) < minimumColumns
    error('PGA_Analyze:InvalidFile','%s must have at least %d numeric columns.',file,minimumColumns);
end
end

function validateFrequency(f,label)
if any(~isfinite(f)) || any(f <= 0) || any(diff(f) <= 0)
    error('PGA_Analyze:InvalidFrequency','%s frequency is invalid.',label);
end
end

function result = interpLog(f,value,query)
if any(query < f(1) | query > f(end))
    error('PGA_Analyze:InterpolationRange','Frequency query is outside data.');
end
result = interp1(log10(f),value,log10(query),'linear');
end

function text = frequencyText(f)
if ~isfinite(f)
    text = "NaN";
elseif f >= 1e6
    text = string(sprintf('%.4g MHz',f/1e6));
elseif f >= 1e3
    text = string(sprintf('%.4g kHz',f/1e3));
else
    text = string(sprintf('%.4g Hz',f));
end
end

function addMetricBox(lines)
text(0.98,0.94,strjoin(lines,newline),'Units','normalized','BackgroundColor','w', ...
    'Color','k','Margin',4,'VerticalAlignment','top','HorizontalAlignment','right', ...
    'HandleVisibility','off');
end

function addCursorLine(x,label)
if ~isfinite(x), return; end
xline(x,':'," "+string(label),'HandleVisibility','off', ...
    'LabelVerticalAlignment','middle','LabelHorizontalAlignment','left');
end

function stylePlot(xLabel,titleText)
grid on; if strlength(string(xLabel)) > 0, xlabel(xLabel); end
if strlength(string(titleText)) > 0, title(titleText); end
end

function savePlot(fig,plotDir,fileName,paperSize)
if nargin < 4, paperSize = [10 4]; end
drawnow;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 paperSize];
fig.PaperSize = paperSize;
print(fig,fullfile(plotDir,fileName),'-dpng','-r250');
end
