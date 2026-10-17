function FDBUF_Analyze
% FDBUF_ANALYZE Verify PVT and Monte Carlo results.
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
defs = reportDefinitions(cfg);
processes = ["NOM" "FF" "SS" "FS" "SF"]; processTokens = lower(processes);
cases = ["nom" "vl" "vh" "tl" "th" "vltl" "vlth" "vhtl" "vhth"];
caseLabels = ["NOMNOM" "VLNOM" "VHNOM" "NOMTL" "NOMTH" ...
    "VLTL" "VLTH" "VHTL" "VHTH"];
caseVdd_V = [3.3 3.0 3.6 3.3 3.3 3.0 3.0 3.6 3.6];
caseTemp_C = [27 27 27 -40 125 -40 125 -40 125];
nCorners = numel(processes)*numel(cases);
corners = strings(1,nCorners); cornerProcesses = strings(1,nCorners);
cornerCases = strings(1,nCorners); cornerVdd_V = nan(1,nCorners);
cornerTemp_C = nan(1,nCorners); values = nan(numel(defs.names),nCorners);
metrics = cell(1,nCorners); cornerIndex = 0;
for processIndex = 1:numel(processes)
    process = processes(processIndex); processToken = processTokens(processIndex);
    resultDir = fullfile(scriptDir,processToken+".Result_txt");
    for caseIndex = 1:numel(cases)
        cornerIndex = cornerIndex+1; caseToken = cases(caseIndex);
        corners(cornerIndex) = process+caseLabels(caseIndex);
        cornerProcesses(cornerIndex) = process;
        cornerCases(cornerIndex) = caseToken;
        cornerVdd_V(cornerIndex) = caseVdd_V(caseIndex);
        cornerTemp_C(cornerIndex) = caseTemp_C(caseIndex);
        metrics{cornerIndex} = analyzeCorner(resultDir,processToken,caseToken, ...
            caseVdd_V(caseIndex),cfg);
        values(:,cornerIndex) = metricsToRaw(metrics{cornerIndex});
    end
end
checkPvtSpecifications(values,defs,corners);
reportKeys = ["NOMNOMNOM" "FFNOMNOM" "SSNOMNOM" "FSNOMNOM" ...
    "SFNOMNOM" "NOMVLNOM" "NOMVHNOM" "NOMNOMTL" "NOMNOMTH"];
columns = ["NOM" "FF" "SS" "FS" "SF" "VL" "VH" "TL" "TH"];
[found,reportIndices] = ismember(reportKeys,corners);
if ~all(found), error('FDBUF_Analyze:ReportCorners','Required corners are missing.'); end
summaryTable = buildComparisonTable(values(:,reportIndices),defs,columns, ...
    cornerVdd_V(reportIndices),cornerTemp_C(reportIndices),cfg);
fprintf('\nFDBUF COMPARISON SUMMARY\n\n'); printSummaryTable(summaryTable,columns);
writetable(summaryTable,fullfile(reportDir,'FDBUF_table_report.csv'));
writetable(summaryTable,fullfile(reportDir,'NOM.FDBUF_summary.csv'));
fullPvtTable = buildFullPvtTable(values,defs,corners,cornerProcesses,cornerCases, ...
    cornerVdd_V,cornerTemp_C);
writetable(fullPvtTable,fullfile(reportDir,'FDBUF_full_pvt_report.csv'));
worstCase = buildWorstCaseTable(values,defs,corners);
fprintf('\nFDBUF FULL-PVT WORST CASE\n\n'); printWorstCaseTable(worstCase);
writetable(worstCase,fullfile(reportDir,'FDBUF_worst_case_report.csv'));
if cfg.makePlots
    nominalCorner = find(corners == "NOMNOMNOM",1);
    nominal = metrics{nominalCorner}; plotNominalDifferential(nominal,plotDir,cfg);
    plotNominalRejection(nominal,plotDir,cfg); plotNominalNoise(nominal,plotDir,cfg);
    plotNominalSettling(nominal,plotDir,cfg);
    plotSelectorTransient(scriptDir,plotDir,cfg);
end
runMcSection(scriptDir,plotDir,reportDir,defs,cfg);
end

%% Configuration and report definitions

function cfg = analysisConfig
cfg.loads_pF = [40 60 80 100];
cfg.loadTags = ["l40" "l60" "l80" "l100"];
cfg.sharedLoadIndex = 2;
cfg.targetGain_VV = 1;
cfg.referenceFrequency_Hz = 10;
cfg.noiseBand_Hz = [0.05 150];
cfg.rejectionFrequencies_Hz = [60 150];
cfg.settlingFraction = 0.0005;
cfg.plotVisible = 'on';
cfg.makePlots = true;
cfg.bandwidthMin_Hz = -Inf;
cfg.settling005Max_s = 1e-6;
cfg.mcRequestedRuns = 200;
cfg.biasTarget_uA = 40;
cfg.biasTolerance_uA = 10;
cfg.totalCurrentMax_mA = 2.5;
cfg.totalPowerMax_mW = Inf;
cfg.outputCmErrorMax_mV = 20;
cfg.offsetMax_mV = 10;
cfg.gainErrorMax_pct = 1;
cfg.rejectionMin_dB = 80;
cfg.noiseMax_uVrms = Inf;
cfg.overshootMax_pct = Inf;
validateattributes(cfg.mcRequestedRuns,{'numeric'},{'scalar','integer','positive'});
validateattributes(cfg.settling005Max_s,{'numeric'},{'scalar','finite','positive'});
end

function defs = reportDefinitions(cfg)
defs.names = ["FDC bias current" "CMFB bias current" "Total current" ...
    "Total power" "Output CM error" "Input offset"]';
defs.units = ["uA" "uA" "mA" "mW" "mV" "mV"]';
defs.groups = repmat("OPERATING POINT",6,1);
bias = cfg.biasTarget_uA+[-1 1]*cfg.biasTolerance_uA;
defs.bounds = [bias; bias; -Inf cfg.totalCurrentMax_mA; -Inf cfg.totalPowerMax_mW; ...
    -cfg.outputCmErrorMax_mV cfg.outputCmErrorMax_mV; -cfg.offsetMax_mV cfg.offsetMax_mV];
defs.worst = ["distance40" "distance40" "max" "max" "absolute" "absolute"]';
loadNames = ["Gain @ 10 Hz" "Gain error" "-3 dB bandwidth" "CMRR @ 60 Hz" ...
    "CMRR @ 150 Hz" "PSRR+ @ 60 Hz" "PSRR+ @ 150 Hz" ...
    "PSRR- @ 60 Hz" "PSRR- @ 150 Hz" ...
    "Input-referred noise 0.05-150 Hz" "0.05% settling time" "Overshoot"]';
loadUnits = ["V/V" "%" "MHz" "dB" "dB" "dB" "dB" "dB" "dB" "uVrms" "us" "%"]';
loadBounds = [-Inf Inf; -cfg.gainErrorMax_pct cfg.gainErrorMax_pct;
cfg.bandwidthMin_Hz*1e-6 Inf; ...
    repmat([cfg.rejectionMin_dB Inf],6,1); -Inf cfg.noiseMax_uVrms; ...
    -Inf cfg.settling005Max_s*1e6; -Inf cfg.overshootMax_pct];
for load = cfg.loads_pF
    defs.names = [defs.names; loadNames];
    defs.units = [defs.units; loadUnits];
    defs.groups = [defs.groups; repmat("CL"+load,12,1)];
    defs.bounds = [defs.bounds; loadBounds];
    defs.worst = [defs.worst; "distance1"; "absolute"; repmat("min",7,1); repmat("max",3,1)];
end
defs.descriptive = all(isinf(defs.bounds),2);
defs.required = ~defs.descriptive;
defs.specs = strings(numel(defs.names),1);
for k = 1:numel(defs.names), defs.specs(k) = boundsText(defs.bounds(k,:)); end
defs.specs(1:2) = cfg.biasTarget_uA+"±"+cfg.biasTolerance_uA;
end

function names = reportParameterNames(defs)
% Prefix load-dependent report rows, like PGA gain-dependent rows.
names = defs.names;
for k = 1:numel(names)
    if startsWith(defs.groups(k),"CL")
        label = names(k);
        if startsWith(label,"Gain"), label = "gain"+extractAfter(label,4); end
        if label == "gain @ 10 Hz", label = "gain"; end
        if startsWith(label,"Input-referred"), label = "input-referred"+extractAfter(label,14); end
        names(k) = defs.groups(k)+" "+label;
    end
end
end

%% Specifications and verification

function text = boundsText(bounds)
if all(isinf(bounds)), text = "";
elseif bounds(1) == -bounds(2), text = "±"+bounds(2);
elseif isfinite(bounds(1)) && isfinite(bounds(2)), text = bounds(1)+" to "+bounds(2);
elseif isfinite(bounds(1)), text = "≥"+bounds(1);
else, text = "≤"+bounds(2);
end
end

function checkPvtSpecifications(values,defs,corners)
pass = passValues(values,defs.bounds); passedCorners = all(pass(defs.required,:),1);
failures = strings(0,1);
for cornerIndex = 1:numel(corners)
    for rowIndex = find(defs.required & ~pass(:,cornerIndex))'
        failures(end+1) = sprintf('%s: %s %s=%s %s (spec %s)', ...
            corners(cornerIndex),defs.groups(rowIndex),defs.names(rowIndex), ...
            formatOne(values(rowIndex,cornerIndex)),defs.units(rowIndex), ...
            defs.specs(rowIndex)); %#ok<AGROW>
    end
end
if isempty(failures)
    fprintf('\nFDBUF FULL-PVT VERIFICATION: PASS (%d/%d corners)\n', ...
        nnz(passedCorners),numel(corners));
else
    warning('FDBUF_Analyze:PvtSpecFailure','FDBUF PVT: FAIL (%d/%d corners):\n%s', ...
        nnz(passedCorners),numel(corners),strjoin(failures,newline));
end
end

function pass = passValues(values,bounds)
pass = isfinite(values) & values >= bounds(:,1) & values <= bounds(:,2);
end

%% PVT measurement extraction

function m = analyzeCorner(resultDir,process,environment,expectedVdd,cfg)
stem = process+".%s_"+cfg.loadTags(cfg.sharedLoadIndex)+"_"+environment+".txt";
op = readNumericFile(fullfile(resultDir,sprintf(stem,'op')),14);
vos = readNumericFile(fullfile(resultDir,sprintf(stem,'vos')),1); m.shared = nan(6,1);
if ~isempty(op)
    row = op(end,:);
    if abs(row(2)-expectedVdd) > 1e-6
        error('FDBUF_Analyze:SupplyMismatch','%s %s OP supply is inconsistent.',process,environment);
    end
    m.shared(1:5) = [row(13)*1e6 row(14)*1e6 row(11)*1e3 row(12)*1e3 row(8)*1e3];
end
if ~isempty(vos), m.shared(6) = vos(end,1)*1e3; end
m.load = cell(1,4); m.loadValues = cell(1,4);
for k = 1:4
    stem = process+".%s_"+cfg.loadTags(k)+"_"+environment+".txt";
    file = @(name)fullfile(resultDir,sprintf(stem,name));
    d = readNumericFile(file('diff_ac'),7); g.values = nan(12,1);
    g.diff = []; g.rejection = cell(1,3); g.noise = []; g.settling = [];
    if ~isempty(d)
        g.diff = analyzeDifferential(d,cfg);
        g.values(1:3) = [g.diff.gain10_VV g.diff.gainError_pct g.diff.bandwidth_Hz*1e-6];
        for r = 1:3
            names = ["cmrr_ac" "psrrp_ac" "psrrn_ac"];
            data = readNumericFile(file(names(r)),5);
            if isempty(data), continue; end
            rejection = analyzeRejection(data,g.diff,cfg);
            g.rejection{r} = rejection;
            g.values(2*r+2:2*r+3) = rejection.atTest_dB;
        end
    end
    data = readNumericFile(file('noise'),3);
    if ~isempty(data), g.noise = analyzeNoise(data,cfg); g.values(10) = g.noise.inputRms_V*1e6; end
    data = readNumericFile(file('settling'),4);
    if ~isempty(data)
        g.settling = analyzeSettling(data,cfg);
        g.values(11:12) = [g.settling.time_s*1e6 g.settling.overshoot_pct];
    end
    m.load{k} = g; m.loadValues{k} = g.values;
end
end

function values = metricsToRaw(m)
values = [m.shared; vertcat(m.loadValues{:})];
end

function d = analyzeDifferential(data,cfg)
f = data(:,1); validateFrequency(f);
vin = complex(data(:,2),data(:,3)); out = complex(data(:,4),data(:,5));
if any(abs(vin) == 0), error('FDBUF_Analyze:ZeroInput','Zero differential AC input.'); end
d.frequency_Hz = f; d.gain_VV = abs(out./vin); gain_dB = 20*log10(d.gain_VV);
reference = interpLog(f,gain_dB,cfg.referenceFrequency_Hz);
d.gain10_VV = 10^(reference/20); d.normalized_dB = gain_dB-reference;
d.gainError_pct = 100*(d.gain10_VV/cfg.targetGain_VV-1);
d.bandwidth_Hz = descendingCrossing(f,d.normalized_dB,-3,cfg.referenceFrequency_Hz);
end

function r = analyzeRejection(data,diff,cfg)
f = data(:,1); validateFrequency(f);
source = complex(data(:,2),data(:,3)); output = complex(data(:,4),data(:,5));
if any(abs(source) == 0), error('FDBUF_Analyze:ZeroSource','Zero rejection AC source.'); end
coupling = abs(output./source);
% Real exports can round a perfectly balanced response to zero.
coupling = max(coupling,realmin);
r.frequency_Hz = f;
r.curve_dB = 20*log10(interpLog(diff.frequency_Hz,diff.gain_VV,f)./coupling);
r.atTest_dB = interpLog(f,r.curve_dB,cfg.rejectionFrequencies_Hz);
end

function n = analyzeNoise(data,cfg)
f = data(:,1); validateFrequency(f);
n.frequency_Hz = f; n.inputDensity_VrtHz = abs(data(:,3));
band = cfg.noiseBand_Hz; inside = f > band(1) & f < band(2);
bf = [band(1); f(inside); band(2)];
% Integrate power spectral density, including exact band endpoints.
psd = n.inputDensity_VrtHz.^2;
bp = [interpLog(f,psd,band(1)); psd(inside); interpLog(f,psd,band(2))];
n.inputRms_V = sqrt(trapz(bf,bp));
end

function s = analyzeSettling(data,cfg)
% Loaded OUT; 0.05% band around the measured plateau, from input 50% crossing.
t = data(:,1); input = data(:,2); output = data(:,4);
if any(diff(t) <= 0), error('FDBUF_Analyze:TimeOrder','Settling time must increase.'); end
s = struct('time_s',NaN,'overshoot_pct',NaN,'relativeTime_s',[], ...
    'input_V',[],'buffer_V',[],'selected_V',[],'final_V',NaN,'tolerance_V',NaN, ...
    'normalizedInput',[],'normalizedBuffer',[],'normalizedOutput',[],'window_s',NaN);
baseline = median(input(1:max(2,round(numel(t)*0.05))));
[~,peakIndex] = max(abs(input-baseline)); delta = input(peakIndex)-baseline;
if abs(delta) < 1e-12, return; end
level = (input-baseline)/delta; rise = find(level >= 0.5,1);
if isempty(rise) || rise == 1, return; end
% Stop before the input leaves its plateau, not at the falling 50% crossing.
plateauStart = find(level(rise:end) >= 1-1e-6,1);
if isempty(plateauStart), return; end
plateauStart = rise+plateauStart-1;
fall = find(level(plateauStart+1:end) < 1-1e-6,1);
if isempty(fall), last = numel(t); else, last = plateauStart+fall-1; end
edge = t(rise-1)+(0.5-level(rise-1))*(t(rise)-t(rise-1))/(level(rise)-level(rise-1));
plateau = rise:last; tail = plateau(max(1,round(numel(plateau)*0.9)):end);
initial = median(output(1:rise-1)); final = median(output(tail)); swing = final-initial;
if abs(swing) < 1e-12 || numel(plateau) < 10, return; end
tolerance = cfg.settlingFraction*abs(swing);
plotIndices = max(1,rise-5):last; settlingTimes = t(plateau)-edge;
s.relativeTime_s = t(plotIndices)-edge;
s.normalizedInput = level(plotIndices);
s.input_V = input(plotIndices); s.buffer_V = data(plotIndices,3);
s.selected_V = output(plotIndices); s.final_V = final; s.tolerance_V = tolerance;
s.normalizedBuffer = (s.buffer_V-initial)/swing;
s.normalizedOutput = (output(plotIndices)-initial)/swing; s.window_s = t(last)-edge;
s.overshoot_pct = max(0,100*(max(s.normalizedOutput)-1));
% A drifting tail cannot establish the final reference or a settling time.
if max(output(tail))-min(output(tail)) > tolerance, return; end
errorTrace = abs(output(plateau)-final); bad = find(errorTrace > tolerance,1,'last');
if isempty(bad), s.time_s = max(0,t(rise)-edge);
elseif bad < numel(plateau)
    fraction = (errorTrace(bad)-tolerance)/(errorTrace(bad)-errorTrace(bad+1));
    s.time_s = max(0,settlingTimes(bad)+fraction*(settlingTimes(bad+1)-settlingTimes(bad)));
end
end

%% PVT tables and terminal output

function t = buildComparisonTable(values,defs,columns,vdd,temp,cfg)
names = ["AVDD"; "Temperature"; "Target gain"; "Shared OP CLoad"; reportParameterNames(defs)];
units = ["V"; "C"; "V/V"; "pF"; defs.units];
groups = [repmat("SET CONDITIONS",4,1); defs.groups];
specs = [repmat("",4,1); defs.specs];
conditions = [vdd; temp; repmat(cfg.targetGain_VV,1,numel(columns)); repmat(60,1,numel(columns))];
t = table(groups,names,units,specs,'VariableNames',{'Group','Parameter','Unit','Spec'});
t = [t array2table(formatValues([conditions; values]),'VariableNames',cellstr(columns))];
end

function printSummaryTable(t,columns)
group = ""; w = max(46,max(strlength(t.Parameter))+2);
fprintf('%-*s %-8s %-14s',w,'Parameter','Unit','Spec');
for c = columns, fprintf(' %13s',c); end
fprintf('\n%s\n',repmat('-',1,w+24+14*numel(columns)));
for k = 1:height(t)
    if t.Group(k) ~= group
        if group ~= "", fprintf('\n'); end
        group = t.Group(k); fprintf('%-*s\n',w,group);
    end
    fprintf('%-*s %-8s %-14s',w,t.Parameter(k),t.Unit(k),t.Spec(k));
    for c = columns, fprintf(' %13s',t.(c)(k)); end
    fprintf('\n');
end
end

function t = buildFullPvtTable(values,defs,corners,processes,cases,vdd,temp)
count = numel(defs.names);
t = table(repelem(corners',count),repelem(processes',count),repelem(cases',count), ...
    repelem(vdd',count),repelem(temp',count),repmat(defs.groups,numel(corners),1), ...
    repmat(reportParameterNames(defs),numel(corners),1),repmat(defs.units,numel(corners),1), ...
    repmat(defs.specs,numel(corners),1),values(:), ...
    'VariableNames',{'Corner','Process','Environment','AVDD_V','Temperature_C', ...
    'Group','Parameter','Unit','Spec','Value'});
end

function t = buildWorstCaseTable(values,defs,corners)
count = numel(defs.names); selected = nan(count,1); corner = strings(count,1);
for k = 1:count
    x = values(k,:); indices = find(isfinite(x));
    if numel(indices) < numel(corners), corner(k) = "INCOMPLETE"; end
    if isempty(indices), continue; end
    valid = x(indices);
    switch defs.worst(k)
        case "min", [~,i] = min(valid);
        case "max", [~,i] = max(valid);
        case "distance40", [~,i] = max(abs(valid-40));
        case "distance1", [~,i] = max(abs(valid-1));
        otherwise, [~,i] = max(abs(valid));
    end
    selected(k) = valid(i);
    if numel(indices) == numel(corners), corner(k) = corners(indices(i));
    else, corner(k) = corners(indices(i))+" (partial)"; end
end
t = table(defs.groups,reportParameterNames(defs),defs.units,defs.specs,selected,corner, ...
    'VariableNames',{'Group','Parameter','Unit','Spec','Value','Corner'});
end

function printWorstCaseTable(t)
w = max(46,max(strlength(t.Parameter))+2);
fprintf('%-*s %-8s %-14s %13s %-10s\n',w,'Parameter','Unit','Spec','Value','Corner');
fprintf('%s\n',repmat('-',1,w+49));
for k = 1:height(t)
    fprintf('%-*s %-8s %-14s %13s %-10s\n',w,t.Parameter(k),t.Unit(k), ...
        t.Spec(k),formatOne(t.Value(k)),t.Corner(k));
end
end

%% Monte Carlo analysis and reporting

function runMcSection(dataDir,plotDir,reportDir,pvtDefs,cfg)
% Six shared columns and five load-sensitive columns per load.
selection = zeros(1,26); selection(1:6) = 1:6;
for k = 1:4, selection(6+(k-1)*5+(1:5)) = 6+(k-1)*12+(1:5); end
defs = pvtDefs;
for field = ["names" "units" "groups" "bounds" "worst" "descriptive" "required" "specs"]
    defs.(field) = defs.(field)(selection,:);
end
modes = ["MM" "GL" "FULL"]; results = cell(3,1);
for modeIndex = 1:3
    mode = modes(modeIndex); results{modeIndex} = summarizeMc(dataDir,mode,defs,cfg);
    printMcSummary(results{modeIndex},defs);
    writetable(results{modeIndex}.table,fullfile(reportDir,mode+"_MC_Summary.csv"));
end
runTable = table(modes',cellfun(@(r)r.requested,results),cellfun(@(r)r.valid,results), ...
    cellfun(@(r)r.failed,results),cellfun(@(r)r.overallYield,results), ...
    'VariableNames',{'Mode','Requested','Valid','Failed','OverallYield_pct'});
writetable(runTable,fullfile(reportDir,'MC_Run_Summary.csv'));
if cfg.makePlots
    plotMcDistribution(results,defs,cfg,"Input offset",plotDir,'FDBUF_MC_input_offset.png');
    plotMcLoadGrid(results,defs,cfg,"Gain error",plotDir,'FDBUF_MC_gain_error.png');
    plotMcLoadGrid(results,defs,cfg,"-3 dB bandwidth",plotDir,'FDBUF_MC_bandwidth.png');
    plotMcLoadGrid(results,defs,cfg,"CMRR @ 60 Hz",plotDir,'FDBUF_MC_CMRR_60Hz.png');
    plotMcLoadGrid(results,defs,cfg,"CMRR @ 150 Hz",plotDir,'FDBUF_MC_CMRR_150Hz.png');
end
end

function r = summarizeMc(dataDir,mode,defs,cfg)
token = lower(mode); values = nan(cfg.mcRequestedRuns,26); raw = cell(1,4);
for k = 1:4
    file = fullfile(dataDir,token+".Result_txt",token+"."+cfg.loadTags(k)+"_mc_summary.txt");
    data = readNumericFile(file,12,true); aligned = nan(cfg.mcRequestedRuns,12);
    if ~isempty(data)
        ids = data(:,1);
        if size(data,2) ~= 12 || any(ids ~= fix(ids) | ids < 1 | ids > cfg.mcRequestedRuns) ...
                || numel(unique(ids)) ~= numel(ids)
            error('FDBUF_Analyze:McRunIds','%s has duplicate/invalid IDs or columns.',file);
        end
        aligned(ids,:) = data;
    end
    raw{k} = aligned;
    values(:,6+(k-1)*5+(1:5)) = aligned(:,8:12).*[1 1 1e-6 1 1];
end
shared = raw{cfg.sharedLoadIndex}(:,2:7);
sharedConsistent = true(cfg.mcRequestedRuns,1);
for k = 1:4
    other = raw{k}(:,2:7); finite = all(isfinite(other),2) & all(isfinite(shared),2);
    mismatch = any(abs(other-shared) > 1e-12+1e-6*abs(shared),2);
    sharedConsistent = sharedConsistent & ~(finite & mismatch);
end
values(:,1:6) = shared.*[1e6 1e6 1e3 1e3 1e3 1e3];
valid = all(isfinite(values),2) & sharedConsistent;
stats = nan(26,7); yield = nan(26,1); pass = passValues(values',defs.bounds)';
required = defs.required;
for k = 1:26
    sample = values(valid,k);
    if isempty(sample), continue; end
    mu = mean(sample); sigma = std(sample,0);
    stats(k,:) = [min(sample) mu-3*sigma mu-sigma mu mu+sigma mu+3*sigma max(sample)];
    if required(k), yield(k) = 100*nnz(valid & pass(:,k))/cfg.mcRequestedRuns; end
end
r.mode = mode; r.values = values; r.validMask = valid; r.stats = stats;
r.requested = cfg.mcRequestedRuns; r.valid = nnz(valid); r.failed = r.requested-r.valid;
r.passed = nnz(valid & all(pass(:,required),2));
r.overallYield = 100*r.passed/r.requested;
r.table = table(defs.groups,reportParameterNames(defs),defs.units,defs.specs,stats(:,1),stats(:,2), ...
    stats(:,3),stats(:,4),stats(:,5),stats(:,6),stats(:,7),yield, ...
    'VariableNames',{'Group','Parameter','Unit','Spec','Min','MeanMinus3Sigma', ...
    'MeanMinusSigma','Mean','MeanPlusSigma','MeanPlus3Sigma','Max','Yield_pct'});
end

function printMcSummary(r,defs)
fprintf('\n%s MONTE CARLO SUMMARY\n',r.mode);
fprintf('Requested: %d  Valid: %d  Failed: %d  Overall yield: %.2f%%\n', ...
    r.requested,r.valid,r.failed,r.overallYield);
names = reportParameterNames(defs);
w = max(46,max(strlength(names))+2);
fprintf('%-*s %-8s %-12s %10s %10s %10s %10s %10s %10s %10s %9s\n', ...
    w,'Parameter','Unit','Spec','Min','μ-3σ','μ-σ','Mean','μ+σ','μ+3σ','Max','Yield');
for k = 1:26
    fprintf('%-*s %-8s %-12s',w,names(k),defs.units(k),defs.specs(k));
    for value = r.stats(k,:), fprintf(' %10s',formatOne(value)); end
    if isfinite(r.table.Yield_pct(k)), text = sprintf('%.2f',r.table.Yield_pct(k));
    else, text = ''; end
    fprintf(' %9s\n',text);
end
end

%% Plots and annotations

function plotNominalDifferential(nominal,plotDir,cfg)
if ~any(cellfun(@(g)~isempty(g.diff),nominal.load)), return; end
fig = newFigure(cfg); hold on; colors = lines(4); gainLines = gobjects(4,1); bandwidthLabels = strings(4,1);
for k = 1:4
    d = nominal.load{k}.diff; if isempty(d), continue; end
    gainLines(k) = semilogx(d.frequency_Hz,20*log10(d.gain_VV),'LineWidth',1.5, ...
        'Color',colors(k,:),'DisplayName',"CL"+cfg.loads_pF(k));
    if isfinite(d.bandwidth_Hz)
        plot(d.bandwidth_Hz,20*log10(d.gain10_VV)-3,'o','Color',colors(k,:),'HandleVisibility','off');
        xline(d.bandwidth_Hz,':','Color',colors(k,:),'HandleVisibility','off');
        bandwidthLabels(k) = "CL"+cfg.loads_pF(k)+": "+frequencyText(d.bandwidth_Hz);
    end
end
yline(-3,'--','-3 dB','HandleVisibility','off'); set(gca,'XScale','log');
xlim([0.01 1e8]); ylabel('Differential gain (dB)'); legend(gainLines(isgraphics(gainLines)),'Location','southwest');
addMetricBox(["-3 dB bandwidth"; bandwidthLabels(strlength(bandwidthLabels) > 0)],'left');
stylePlot('Frequency (Hz)','FDBUF Differential Response - NOM');
savePlot(fig,plotDir,'FDBUF_differential_response.png');
end

function plotNominalRejection(nominal,plotDir,cfg)
if ~any(cellfun(@(g)any(~cellfun(@isempty,g.rejection)),nominal.load)), return; end
fig = newFigure(cfg); layout = tiledlayout(fig,3,1); colors = lines(4);
names = ["CMRR" "PSRR+" "PSRR-"];
for r = 1:3
    nexttile(layout); hold on; rejectionLines = gobjects(4,1);
    for k = 1:4
        list = nominal.load{k}.rejection;
        if numel(list) < r || isempty(list{r}), continue; end
        d = list{r}; rejectionLines(k) = semilogx(d.frequency_Hz,d.curve_dB,'LineWidth',1.5, ...
            'Color',colors(k,:),'DisplayName',"CL"+cfg.loads_pF(k));
    end
    for f = cfg.rejectionFrequencies_Hz, xline(f,':',frequencyText(f),'HandleVisibility','off'); end
    yline(cfg.rejectionMin_dB,'--',cfg.rejectionMin_dB+" dB",'HandleVisibility','off');
    set(gca,'XScale','log'); xlim([0.01 1e6]);
    limits = ylim; ylim(limits+[-1 1]*max(1,0.05*diff(limits)));
    ylabel('Rejection (dB)'); legend(rejectionLines(isgraphics(rejectionLines)),'Location','best');
    stylePlot('Frequency (Hz)',"("+char('a'+r-1)+") FDBUF "+names(r)+" - NOM");
end
savePlot(fig,plotDir,'FDBUF_rejection.png',[10 9]);
end

function plotNominalNoise(nominal,plotDir,cfg)
if ~any(cellfun(@(g)~isempty(g.noise),nominal.load)), return; end
fig = newFigure(cfg); hold on; colors = lines(4); labels = strings(4,1);
for k = 1:4
    n = nominal.load{k}.noise; if isempty(n), continue; end
    loglog(n.frequency_Hz,n.inputDensity_VrtHz*1e9,'LineWidth',1.5, ...
        'Color',colors(k,:),'DisplayName',"CL"+cfg.loads_pF(k));
    labels(k) = sprintf('CL%d: %.4g uVrms',cfg.loads_pF(k),n.inputRms_V*1e6);
end
set(gca,'XScale','log','YScale','log'); ylabel('Input noise (nV/sqrt(Hz))');
xlim([0.01 1e4]); addMetricBox(["Integrated 0.05-150 Hz"; labels(strlength(labels) > 0)]);
legend('Location','southwest');
stylePlot('Frequency (Hz)','FDBUF Input-Referred Noise - NOM');
savePlot(fig,plotDir,'FDBUF_input_referred_noise.png');
end

function plotNominalSettling(nominal,plotDir,cfg)
present = cellfun(@(g)~isempty(g.settling) && ~isempty(g.settling.relativeTime_s),nominal.load);
if ~any(present), return; end
fig = newFigure(cfg); hold on; colors = lines(4);
first = find(present,1); input = nominal.load{first}.settling; labels = strings(4,1);
plot(input.relativeTime_s*1e6,input.normalizedInput,'--','Color',[0.65 0.65 0.65], ...
    'LineWidth',1.2,'DisplayName','Input step');
for k = find(present)
    s = nominal.load{k}.settling;
    plot(s.relativeTime_s*1e6,s.normalizedOutput,'LineWidth',1.5, ...
        'Color',colors(k,:),'DisplayName',"CL"+cfg.loads_pF(k));
    labels(k) = sprintf('CL%d: tsettle = %s us, OS = %.2f%%',cfg.loads_pF(k), ...
        formatOne(s.time_s*1e6),s.overshoot_pct);
end
ylabel('Normalized step excursion'); legend('Location','southwest');
allTimes = cellfun(@(g)g.values(11),nominal.load); allTimes = allTimes(isfinite(allTimes));
if isempty(allTimes), span = input.window_s*1e6; else, span = max(1,2*max(allTimes)); end
xlim([min(input.relativeTime_s)*1e6 min(input.window_s*1e6,span)]);
addMetricBox(labels(strlength(labels) > 0));
stylePlot('Time after input 50% crossing (us)','FDBUF Loaded OUT Step - NOM');
savePlot(fig,plotDir,'FDBUF_settling_response.png');
end

function plotSelectorTransient(dataDir,plotDir,cfg)
data = readNumericFile(fullfile(dataDir,'nom.Result_txt','nom.sel_tran_nom.txt'),5);
if isempty(data), return; end
t = data(:,1)*1e3; sel = data(:,2); index = find(sel >= 0.5*(min(sel)+max(sel)),1);
if isempty(index) || max(sel) == min(sel), return; end
switchTime = t(index); fig = newFigure(cfg); layout = tiledlayout(fig,3,1); axesList = gobjects(3,1);
axesList(1) = nexttile(layout); plot(t,sel,'LineWidth',1.5); ylabel('SEL (V)');
stylePlot('','(a) Selector Control - CL60');
axesList(2) = nexttile(layout); plot(t,data(:,3)*1e3,'LineWidth',1.5,'DisplayName','FDBUF internal'); hold on;
plot(t,data(:,4)*1e3,'--','LineWidth',1.5,'DisplayName','External'); ylabel('Differential voltage (mV)');
legend('Location','best'); stylePlot('','(b) Internal / External Signals');
axesList(3) = nexttile(layout); plot(t,data(:,5)*1e3,'LineWidth',1.5); ylabel('OUT differential (mV)');
stylePlot('Time (ms)','(c) Selected Loaded Output');
for ax = axesList', xline(ax,switchTime,'--','Switch','HandleVisibility','off'); end
linkaxes(axesList,'x'); xlim([t(1) t(end)]); sgtitle('FDBUF SEL4 Functional Check - NOM / CL60');
savePlot(fig,plotDir,'FDBUF_SEL4_functional_check.png',[10 8]);
end

function plotMcLoadGrid(results,defs,cfg,name,plotDir,fileName)
indices = find(strcmpi(defs.names,name));
if ~any(cellfun(@(r)any(r.validMask),results)), return; end
fig = newFigure(cfg); layout = tiledlayout(fig,2,2); colors = lines(3);
for k = 1:4
    j = indices(k); nexttile(layout); hold on;
    samples = cellfun(@(r)r.values(r.validMask,j),results,'UniformOutput',false);
    allValues = vertcat(samples{:}); full = results{3}; center = full.stats(j,4);
    if ~isfinite(center), center = mean(allValues); end
    statMarkers = full.stats(j,2:6); statMarkers = statMarkers(isfinite(statMarkers));
    radius = max(abs([allValues; statMarkers(:)]-center));
    radius = max(radius*1.05,max(abs(center)*1e-6,1e-6));
    edges = linspace(center-radius,center+radius,21);
    distributionLines = gobjects(3,1);
    for modeIndex = 1:3
        if isempty(samples{modeIndex}), continue; end
        probability = 100*histcounts(samples{modeIndex},edges,'Normalization','probability');
        distributionLines(modeIndex) = stairs(edges,[probability 0],'LineWidth',1.5,'Color',colors(modeIndex,:), ...
            'DisplayName',results{modeIndex}.mode);
    end
    for value = defs.bounds(j,isfinite(defs.bounds(j,:)))
        xline(value,'--','Spec','HandleVisibility','off');
    end
    markers = full.stats(j,2:6); labels = ["-3σ" "-σ" "μ" "+σ" "+3σ"];
    for i = 1:5
        if isfinite(markers(i)), xline(markers(i),':',labels(i),'HandleVisibility','off'); end
    end
    xlim([edges(1) edges(end)]); ylabel('Samples (%)'); legend(distributionLines(isgraphics(distributionLines)),'Location','northeast');
    stylePlot(name+" ("+defs.units(j)+")","("+char('a'+k-1)+") CL"+cfg.loads_pF(k));
end
sgtitle(layout,"FDBUF "+name+" - MM / GL / FULL; centered on FULL mean");
savePlot(fig,plotDir,fileName,[11 7]);
end

function plotMcDistribution(results,defs,cfg,name,plotDir,fileName)
if name == "Input offset", group = "OPERATING POINT";
else, group = "CL"+cfg.loads_pF(cfg.sharedLoadIndex); end
index = find(defs.names == name & defs.groups == group,1);
if ~any(cellfun(@(r)any(r.validMask),results)), return; end
fig = newFigure(cfg); hold on; colors = lines(3); distributionLines = gobjects(3,1);
samples = cellfun(@(r)r.values(r.validMask,index),results,'UniformOutput',false);
allValues = vertcat(samples{:}); full = results{3}; center = full.stats(index,4);
if ~isfinite(center), center = mean(allValues); end
statMarkers = full.stats(index,2:6); statMarkers = statMarkers(isfinite(statMarkers));
radius = max(abs([allValues; statMarkers(:)]-center));
radius = max(radius*1.05,max(abs(center)*1e-6,1e-6));
edges = linspace(center-radius,center+radius,21);
for modeIndex = 1:3
    if isempty(samples{modeIndex}), continue; end
    probability = 100*histcounts(samples{modeIndex},edges,'Normalization','probability');
    distributionLines(modeIndex) = stairs(edges,[probability 0],'LineWidth',1.5,'Color',colors(modeIndex,:), ...
        'DisplayName',results{modeIndex}.mode);
end
for value = defs.bounds(index,isfinite(defs.bounds(index,:)))
    if value >= edges(1) && value <= edges(end)
        xline(value,'--','Spec','HandleVisibility','off');
    end
end
markers = full.stats(index,2:6); labels = ["-3σ" "-σ" "μ" "+σ" "+3σ"];
for k = 1:5
    if isfinite(markers(k)), xline(markers(k),':',labels(k),'HandleVisibility','off'); end
end
xlim([edges(1) edges(end)]); ylabel('Samples (%)');
legend(distributionLines(isgraphics(distributionLines)),'Location','northeast');
stylePlot(name+" ("+defs.units(index)+")","FDBUF "+name+" - MM / GL / FULL / CL60");
savePlot(fig,plotDir,fileName);
end

function fig = newFigure(cfg)
fig = figure('Visible',cfg.plotVisible);
end

function addMetricBox(lines,alignment)
if nargin < 2, alignment = 'right'; end
if strcmp(alignment,'left'), x = 0.02; else, x = 0.98; end
text(x,0.94,strjoin(lines,newline),'Units','normalized','BackgroundColor','w', ...
    'Color','k','Margin',4,'VerticalAlignment','top','HorizontalAlignment',alignment, ...
    'HandleVisibility','off');
end

function stylePlot(xLabel,titleText)
grid on; if strlength(string(xLabel)) > 0, xlabel(xLabel); end
if strlength(string(titleText)) > 0, title(titleText); end
end

function savePlot(fig,plotDir,fileName,paperSize)
if nargin < 4, paperSize = [10 4]; end
drawnow; fig.PaperUnits = 'inches'; fig.PaperPosition = [0 0 paperSize]; fig.PaperSize = paperSize;
print(fig,fullfile(plotDir,fileName),'-dpng','-r250');
end

%% File input and validation

function data = readNumericFile(file,columns,allowNonfinite)
if nargin < 3, allowNonfinite = false; end
if ~isfile(file), data = []; return; end
opts = detectImportOptions(file,'FileType','text','Delimiter',{' ',sprintf('\t')}, ...
    'ConsecutiveDelimitersRule','join','LeadingDelimitersRule','ignore');
opts = setvartype(opts,'double'); opts.DataLines = [1 Inf]; opts.VariableNamesLine = 0;
data = readmatrix(file,opts);
if isempty(data) || size(data,2) ~= columns || (~allowNonfinite && any(~isfinite(data),'all'))
    warning('FDBUF_Analyze:InvalidFile','Expected %d finite numeric columns: %s',columns,file);
    data = [];
end
end

function validateFrequency(f)
if any(~isfinite(f) | f <= 0) || any(diff(f) <= 0)
    error('FDBUF_Analyze:Frequency','Frequency must be positive and increasing.');
end
end

%% Numerical helpers

function value = interpLog(f,y,query)
if any(query < f(1)*(1-1e-12) | query > f(end)*(1+1e-12))
    error('FDBUF_Analyze:Coverage','Frequency query lies outside exported data.');
end
query = min(max(query,f(1)),f(end)); value = interp1(log10(f),y,log10(query),'linear');
end

function crossing = descendingCrossing(f,y,level,start)
crossing = NaN; i = find(f(1:end-1) >= start & y(1:end-1) > level & y(2:end) <= level,1);
if isempty(i), return; end
crossing = 10^(log10(f(i))+(level-y(i))*(log10(f(i+1))-log10(f(i)))/(y(i+1)-y(i)));
end

%% Units and formatting

function formatted = formatValues(values)
formatted = strings(size(values));
for k = 1:numel(values), formatted(k) = formatOne(values(k)); end
end

function text = formatOne(value)
if ~isfinite(value)
    text = "NaN";
elseif abs(value) > 0 && (abs(value) < 1e-3 || abs(value) >= 1e4)
    text = string(sprintf('%.3e',value));
else
    text = string(sprintf('%.3f',value));
end
end

function text = frequencyText(f)
if f >= 1e6
    text = string(sprintf('%.4g MHz',f/1e6));
elseif f >= 1e3
    text = string(sprintf('%.4g kHz',f/1e3));
else
    text = string(sprintf('%.4g Hz',f));
end
end
