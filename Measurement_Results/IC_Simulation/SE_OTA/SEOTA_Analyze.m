%%
% SEOTA nominal analysis
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~exist(plotDir,'dir'), mkdir(plotDir); end

TAG = "NOM";
MARK_FREQ_HZ = [0.05 60 150 1e3];
CLOAD_SET_PF = 10;
TRACK_LIMIT = 2e-3;
SETTLE_LIMIT = 2e-3;
NOISE_BAND_HZ = [0.05 150];

%% Operating point
op = cols(numdata(fullfile(baseDir,TAG + ".ol_nom_op.txt")),8);
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
[f_Hz,Ad] = transferFromFile(fullfile(baseDir,TAG + ".ol_nom_diff_ac.txt"));
[gain_dB,phase_deg,ugf_Hz,pm_deg,f3dB_Hz] = acMetrics(f_Hz,Ad);
dcGain_dB = gain_dB(1);

wideFigure();
yyaxis left;
semilogx(f_Hz,gain_dB,'LineWidth',1.5); hold on;
yline(0,'--','HandleVisibility','off');
addCursor(f3dB_Hz,dcGain_dB-3,sprintf('-3dB: %s',freqText(f3dB_Hz)));
addCursor(ugf_Hz,0,sprintf('UGF: %s',freqText(ugf_Hz)));
ylabel('Gain (dB)');

yyaxis right;
semilogx(f_Hz,phase_deg,'LineWidth',1.5); hold on;
addCursor(ugf_Hz,interpAtFreq(f_Hz,phase_deg,ugf_Hz),sprintf('PM: %.4g deg',pm_deg));
ylabel('Phase (deg)');
stylePlot('Frequency (Hz)','SEOTA Open-Loop Gain and Phase');
saveFig(plotDir,'NOM.open_loop_gain_phase.png');

%% Open-loop: CMRR and PSRR
[fCm_Hz,Acm] = transferFromFile(fullfile(baseDir,TAG + ".ol_nom_cm_ac.txt"));
[fP_Hz,AsupP] = transferFromFile(fullfile(baseDir,TAG + ".ol_nom_psrrp_ac.txt"));
[fN_Hz,AsupN] = transferFromFile(fullfile(baseDir,TAG + ".ol_nom_psrrn_ac.txt"));

cmrr_dB = rejectionDb(f_Hz,Ad,fCm_Hz,Acm);
psrrP_dB = rejectionDb(f_Hz,Ad,fP_Hz,AsupP);
psrrN_dB = rejectionDb(f_Hz,Ad,fN_Hz,AsupN);
cmrrAt_dB = interpAtFreq(fCm_Hz,cmrr_dB,MARK_FREQ_HZ);
psrrPAt_dB = interpAtFreq(fP_Hz,psrrP_dB,MARK_FREQ_HZ);
psrrNAt_dB = interpAtFreq(fN_Hz,psrrN_dB,MARK_FREQ_HZ);

wideFigure();
semilogx(fCm_Hz,cmrr_dB,'LineWidth',1.5); hold on;
labelFreqSet(fCm_Hz,cmrr_dB,MARK_FREQ_HZ);
ylabel('CMRR (dB)');
stylePlot('Frequency (Hz)','SEOTA CMRR versus Frequency');
saveFig(plotDir,'NOM.cmrr.png');

wideFigure();
tiledlayout(2,1);
sgtitle('SEOTA PSRR+ and PSRR- versus Frequency');
nexttile;
semilogx(fP_Hz,psrrP_dB,'LineWidth',1.5); hold on;
labelFreqSet(fP_Hz,psrrP_dB,MARK_FREQ_HZ);
ylabel('PSRR+ (dB)');
stylePlot('Frequency (Hz)','SEOTA PSRR+');

nexttile;
semilogx(fN_Hz,psrrN_dB,'LineWidth',1.5); hold on;
labelFreqSet(fN_Hz,psrrN_dB,MARK_FREQ_HZ);
ylabel('PSRR- (dB)');
stylePlot('Frequency (Hz)','SEOTA PSRR-');
saveFig(plotDir,'NOM.psrr.png');

%% Open-loop: input-referred noise
noise = cols(numdata(fullfile(baseDir,TAG + ".ol_nom_noise.txt")),3);
fNoise_Hz = noise(:,1);
inNoise_VrtHz = abs(noise(:,3));
inputNoise_Vrms = integrateNoise(fNoise_Hz,inNoise_VrtHz,NOISE_BAND_HZ);

wideFigure();
validNoise = fNoise_Hz >= NOISE_BAND_HZ(1) & ...
    fNoise_Hz <= NOISE_BAND_HZ(2) & isfinite(inNoise_VrtHz) & inNoise_VrtHz > 0;
loglog(fNoise_Hz(validNoise),inNoise_VrtHz(validNoise)*1e9,'LineWidth',1.5);
ylabel('Input noise (nV/sqrtHz)');
xlim(NOISE_BAND_HZ);
stylePlot('Frequency (Hz)','SEOTA Input-Referred Noise Density versus Frequency');
saveFig(plotDir,'NOM.input_referred_noise_density.png');

%% Open-loop: VTC
vtc = cols(numdata(fullfile(baseDir,TAG + ".ol_nom_vtc.txt")),6);
vtcVinDiff_V = vtc(:,1);
vtcVout_V = vtc(:,5);
offset_V = zeroNoJump(vtcVinDiff_V,vtcVout_V - voutTarget_V,0.25*vdd_V);

wideFigure();
plot(vtcVinDiff_V*1e3,vtcVout_V,'LineWidth',1.5); hold on;
yline(voutTarget_V,'--','VDD/2','HandleVisibility','off');
addCursor(offset_V*1e3,voutTarget_V,sprintf('Vos: %.4g mV',offset_V*1e3));
ylabel('Vout (V)');
stylePlot('Vin,diff (mV)','SEOTA Open-Loop VTC');
saveFig(plotDir,'NOM.open_loop_vtc.png');

%% Closed-loop: VTC and output swing
clOp = cols(numdata(fullfile(baseDir,TAG + ".cl_nom_op.txt")),8);
clOp = clOp(end,:);
clVinDc_V = clOp(3);

cl = cols(numdata(fullfile(baseDir,TAG + ".cl_nom_dc.txt")),6);
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

validSwing = abs(clErr_V) <= TRACK_LIMIT;
[iLow,iHigh] = continuousIndices(validSwing,i0);
if isfinite(iLow)
    inputLow_V = clVin_V(iLow);
    inputHigh_V = clVin_V(iHigh);
    swingLow_V = min(clVout_V(iLow:iHigh));
    swingHigh_V = max(clVout_V(iLow:iHigh));
else
    inputLow_V = NaN;
    inputHigh_V = NaN;
    swingLow_V = NaN;
    swingHigh_V = NaN;
end

wideFigure();
tiledlayout(2,1);
sgtitle('SEOTA Closed-Loop DC Input Range and Output Swing');

nexttile;
plot(clVin_V,clErr_V*1e3,'LineWidth',1.5); hold on;
yline(TRACK_LIMIT*1e3,'--','+2 mV','HandleVisibility','off');
yline(-TRACK_LIMIT*1e3,'--','-2 mV','HandleVisibility','off');
if isfinite(inputLow_V)
    addCursorLine(inputLow_V,clErr_V(iLow)*1e3, ...
        sprintf('Input CM low: %.4g V',inputLow_V));
    addCursorLine(inputHigh_V,clErr_V(iHigh)*1e3, ...
        sprintf('Input CM high: %.4g V',inputHigh_V));
end
ylabel('Vout - Vin (mV)');
stylePlot('Vin (V)','Tracking Error');

nexttile;
plot(clVin_V,clVout_V,'LineWidth',1.5); hold on;
plot(clVin_V,clVin_V,'--','LineWidth',1.2);
if isfinite(inputLow_V)
    xline(inputLow_V,':',sprintf('Input CM low: %.4g V',inputLow_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
    xline(inputHigh_V,':',sprintf('Input CM high: %.4g V',inputHigh_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','right');
    yline(swingLow_V,':',sprintf('Output swing low: %.4g V',swingLow_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','bottom', ...
        'LabelHorizontalAlignment','right');
    yline(swingHigh_V,':',sprintf('Output swing high: %.4g V',swingHigh_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','top', ...
        'LabelHorizontalAlignment','left');
end
ylabel('Vout (V)');
legend('Measured','Ideal Vout = Vin','Location','best');
stylePlot('Vin (V)','Vout versus Vin');
saveFig(plotDir,'NOM.closed_loop_dc_input_range.png');

wideFigure();
plot(clVin_V,clVout_V,'LineWidth',1.5); hold on;
plot(clVin_V,clVin_V,'--','LineWidth',1.2);
if isfinite(inputLow_V)
    xline(inputLow_V,':',sprintf('Input CM low: %.4g V',inputLow_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
    xline(inputHigh_V,':',sprintf('Input CM high: %.4g V',inputHigh_V), ...
        'HandleVisibility','off','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','right');
end
ylabel('Vout (V)');
legend('Measured','Ideal Vout = Vin','Location','best');
stylePlot('Vin (V)','SEOTA Closed-Loop VTC');
saveFig(plotDir,'NOM.closed_loop_vtc.png');

%% Closed-loop: transient
tr = cols(numdata(fullfile(baseDir,TAG + ".cl_nom_tran.txt")),7);
t_s = tr(:,1);
trVin_V = tr(:,2);
trVout_V = tr(:,3);
[srRise_Vus,srFall_Vus,tRise_s,tFall_s,risePt,fallPt] = ...
    stepMetrics(t_s,trVin_V,trVout_V,SETTLE_LIMIT);
settle_s = maxFinite([tRise_s tFall_s]);

nomMetrics.vdd_V = vdd_V;
nomMetrics.vinCm_V = vinCm_V;
nomMetrics.ibias_A = ibias_A;
nomMetrics.totalCurrent_A = totalCurrent_A;
nomMetrics.totalPower_W = totalPower_W;
nomMetrics.ugf_Hz = ugf_Hz;
nomMetrics.pm_deg = pm_deg;
nomMetrics.dcGain_dB = dcGain_dB;
nomMetrics.cmrr_dB = cmrrAt_dB(2:3);
nomMetrics.psrrP_dB = psrrPAt_dB(2:3);
nomMetrics.psrrN_dB = psrrNAt_dB(2:3);
nomMetrics.offset_V = offset_V;
nomMetrics.inputNoise_Vrms = inputNoise_Vrms;
nomMetrics.clGain_dB = 20*log10(abs(clGain));
nomMetrics.gainError_pct = gainError_pct;
nomMetrics.voutDc_V = voutClosedLoopDc_V;
nomMetrics.inputLow_V = inputLow_V;
nomMetrics.inputHigh_V = inputHigh_V;
nomMetrics.swingLow_V = swingLow_V;
nomMetrics.swingHigh_V = swingHigh_V;
nomMetrics.srRise_Vus = srRise_Vus;
nomMetrics.srFall_Vus = srFall_Vus;
nomMetrics.settle_s = settle_s;
[offsetReportValue,offsetReportUnit] = voltageReport(offset_V,"");
[noiseReportValue,noiseReportUnit] = voltageReport(inputNoise_Vrms,"rms");
[voutDcReportValue,voutDcReportUnit] = voltageReport(voutClosedLoopDc_V,"");
[inputLowReportValue,inputLowReportUnit] = voltageReport(inputLow_V,"");
[inputHighReportValue,inputHighReportUnit] = voltageReport(inputHigh_V,"");
[swingLowReportValue,swingLowReportUnit] = voltageReport(swingLow_V,"");
[swingHighReportValue,swingHighReportUnit] = voltageReport(swingHigh_V,"");

wideFigure();
plot(t_s*1e6,trVin_V,'--','LineWidth',1.2); hold on;
plot(t_s*1e6,trVin_V+SETTLE_LIMIT,':','LineWidth',1.0, ...
    'HandleVisibility','off');
plot(t_s*1e6,trVin_V-SETTLE_LIMIT,':','LineWidth',1.0, ...
    'HandleVisibility','off');
plot(t_s*1e6,trVout_V,'LineWidth',1.5);
addSrCursor(risePt,sprintf('Rise: %.4g V/us',srRise_Vus));
addSrCursor(fallPt,sprintf('Fall: %.4g V/us',srFall_Vus));
addMetricBox({sprintf('Settling time: %s ns',fmt(settle_s*1e9))});
ylabel('Voltage (V)');
legend('Input','Output','Location','best');
stylePlot('Time (us)','SEOTA Closed-Loop Step Response');
saveFig(plotDir,'NOM.closed_loop_step_response.png');

%% Summary table
rows = [
    "Set conditions",          "",      ""
    "AVDD",                    "V",     fmt(vdd_V)
    "CLoad",                   "pF",    fmt(CLOAD_SET_PF)
    "Vin,cm",                  "V",     fmt(vinCm_V)
    "Closed-loop target gain", "V/V",   fmt(1)
    "",                        "",      ""
    "Open-loop simulation",    "",      ""
    "Bias current",           "uA",    fmt(ibias_A*1e6)
    "Total current",          "uA",    fmt(totalCurrent_A*1e6)
    "Total power",            "mW",    fmt(totalPower_W*1e3)
    "DC gain",               "dB",    fmtDbPercent(dcGain_dB)
    "UGF",                   "MHz",   fmt(ugf_Hz/1e6)
    "Phase margin",          "deg",   fmt(pm_deg)
    "Input offset",          offsetReportUnit, fmt(offsetReportValue)
    "CMRR @ 60 Hz",          "dB",    fmtDbPercent(cmrrAt_dB(2))
    "CMRR @ 150 Hz",         "dB",    fmtDbPercent(cmrrAt_dB(3))
    "PSRR+ @ 60 Hz",         "dB",    fmtDbPercent(psrrPAt_dB(2))
    "PSRR+ @ 150 Hz",        "dB",    fmtDbPercent(psrrPAt_dB(3))
    "PSRR- @ 60 Hz",         "dB",    fmtDbPercent(psrrNAt_dB(2))
    "PSRR- @ 150 Hz",        "dB",    fmtDbPercent(psrrNAt_dB(3))
    "Input-referred noise 0.05-150 Hz", noiseReportUnit, fmt(noiseReportValue)
    "",                      "",      ""
    "Closed-loop simulation","",      ""
    "Closed-loop gain",      "dB",    fmtDbPercent(20*log10(abs(clGain)))
    "Gain error",            "%",     fmtDbPercent(gainError_pct)
    "Vout,DC",               voutDcReportUnit, fmt(voutDcReportValue)
    "Input CM low",          inputLowReportUnit, fmt(inputLowReportValue)
    "Input CM high",         inputHighReportUnit, fmt(inputHighReportValue)
    "Output swing low",      swingLowReportUnit, fmt(swingLowReportValue)
    "Output swing high",     swingHighReportUnit, fmt(swingHighReportValue)
    "SR rise",               "V/us",  fmt(srRise_Vus)
    "SR fall",               "V/us",  fmt(srFall_Vus)
    "Settling time",         "ns",    fmt(settle_s*1e9)
];

allProcesses = ["NOM" "FF" "SS" "FS" "SF"];
allCases = ["nom" "vl" "vh" "tl" "th" "vltl" "vlth" "vhtl" "vhth"];
caseCornerText = ["NOMNOM" "VLNOM" "VHNOM" "NOMTL" "NOMTH" ...
    "VLTL" "VLTH" "VHTL" "VHTH"];
pvtCorners = strings(0,1);
pvtValues = strings(size(rows,1),0);
pvtMetrics = {};
missingPvt = strings(0,1);
for process = allProcesses
    for caseIndex = 1:numel(allCases)
        caseName = allCases(caseIndex);
        cornerName = process + caseCornerText(caseIndex);
        resultDir = fullfile(scriptDir,process + ".Result_txt");
        olPrefix = fullfile(resultDir,process + ".ol_" + caseName + "_");
        requiredOl = olPrefix + ["op.txt" "diff_ac.txt" "cm_ac.txt" ...
            "psrrp_ac.txt" "psrrn_ac.txt" "vtc.txt" "noise.txt"];
        if ~all(isfile(requiredOl))
            missingPvt(end+1) = cornerName; %#ok<SAGROW>
            continue;
        end
        if process == "NOM" && caseName == "nom"
            metrics = nomMetrics;
        else
            metrics = analyzeRun(scriptDir,process,caseName, ...
                TRACK_LIMIT,SETTLE_LIMIT,NOISE_BAND_HZ);
        end
        pvtMetrics{end+1} = metrics; %#ok<SAGROW>
        pvtCorners(end+1) = cornerName; %#ok<SAGROW>
        pvtValues(:,end+1) = metricsToReport( ...
            metrics,rows(:,1:2),CLOAD_SET_PF); %#ok<SAGROW>
    end
end
if ~isempty(missingPvt)
    warning('SEOTA_Analyze:MissingPvtRuns', ...
        'PVT runs missing required OL files: %s.',strjoin(missingPvt,', '));
end

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

Result = table(rows(:,1),rows(:,2),'VariableNames',{'Parameter','Unit'});
Result = [Result array2table(reportValues, ...
    'VariableNames',cellstr(reportColumns))];
fprintf('\nSEOTA COMPARISON SUMMARY\n\n');
printSummaryTable(rows(:,1:2),reportColumns,reportValues);
writetable(Result,fullfile(scriptDir,'SEOTA_table_report.csv'));
writetable(Result,fullfile(scriptDir,'NOM.SEOTA_summary.csv'));

WorstCase = buildWorstCaseTable( ...
    rows(:,1:2),pvtCorners,pvtValues,pvtMetrics);
fprintf('\nSEOTA FULL-PVT WORST CASE\n\n');
printWorstCaseTable(WorstCase);
writetable(WorstCase,fullfile(scriptDir,'SEOTA_worst_case_report.csv'));

%% Functions
function D = numdata(file)
    D = readmatrix(file,'FileType','text');
    D = D(any(isfinite(D),2),:);
    D = D(:,any(isfinite(D),1));
    if isempty(D), error('No numeric data found in %s',file); end
end

function C = cols(D,n)
    if size(D,2) == n
        C = D;
    elseif size(D,2) == n+1
        C = D(:,2:end);
    elseif size(D,2) > n
        C = D(:,end-n+1:end);
    else
        error('Expected at least %d columns, found %d.',n,size(D,2));
    end
end

function m = analyzeRun(scriptDir,process,caseName,trackLimit,settleLimit, ...
        noiseBand)
    resultDir = fullfile(scriptDir,process + ".Result_txt");
    olPrefix = fullfile(resultDir,process + ".ol_" + caseName + "_");
    clPrefix = fullfile(resultDir,process + ".cl_" + caseName + "_");

    op = cols(numdata(olPrefix + "op.txt"),8);
    op = op(end,:);
    m.vdd_V = op(2);
    m.vinCm_V = 0.5*(op(3)+op(4));
    m.ibias_A = abs(op(8));
    m.totalCurrent_A = abs(op(7));
    m.totalPower_W = m.vdd_V*m.totalCurrent_A;

    [fAd_Hz,Ad] = transferFromFile(olPrefix + "diff_ac.txt");
    [gain_dB,~,m.ugf_Hz,m.pm_deg] = acMetrics(fAd_Hz,Ad);
    m.dcGain_dB = gain_dB(1);
    [fCm_Hz,Acm] = transferFromFile(olPrefix + "cm_ac.txt");
    [fP_Hz,AsupP] = transferFromFile(olPrefix + "psrrp_ac.txt");
    [fN_Hz,AsupN] = transferFromFile(olPrefix + "psrrn_ac.txt");
    cmrr_dB = rejectionDb(fAd_Hz,Ad,fCm_Hz,Acm);
    psrrP_dB = rejectionDb(fAd_Hz,Ad,fP_Hz,AsupP);
    psrrN_dB = rejectionDb(fAd_Hz,Ad,fN_Hz,AsupN);
    m.cmrr_dB = interpAtFreq(fCm_Hz,cmrr_dB,[60 150]);
    m.psrrP_dB = interpAtFreq(fP_Hz,psrrP_dB,[60 150]);
    m.psrrN_dB = interpAtFreq(fN_Hz,psrrN_dB,[60 150]);

    vtc = cols(numdata(olPrefix + "vtc.txt"),6);
    m.offset_V = zeroNoJump(vtc(:,1),vtc(:,5)-0.5*m.vdd_V,0.25*m.vdd_V);
    noise = cols(numdata(olPrefix + "noise.txt"),3);
    m.inputNoise_Vrms = integrateNoise(noise(:,1),abs(noise(:,3)),noiseBand);

    m.clGain_dB = NaN; m.gainError_pct = NaN; m.voutDc_V = NaN;
    m.inputLow_V = NaN; m.inputHigh_V = NaN;
    m.swingLow_V = NaN; m.swingHigh_V = NaN;
    m.srRise_Vus = NaN; m.srFall_Vus = NaN; m.settle_s = NaN;
    clFiles = clPrefix + ["op.txt" "dc.txt" "tran.txt"];
    if all(isfile(clFiles))
        clOp = cols(numdata(clFiles(1)),8);
        clOp = clOp(end,:);
        clVinDc_V = clOp(3);
        cl = cols(numdata(clFiles(2)),6);
        [clVin_V,order] = sort(cl(:,1));
        clVout_V = cl(order,2);
        clErr_V = cl(order,3);
        [~,i0] = min(abs(clVin_V-clVinDc_V));
        clGain = localSlope(clVin_V,clVout_V,clVinDc_V);
        m.clGain_dB = 20*log10(abs(clGain));
        m.gainError_pct = 100*(clGain-1);
        m.voutDc_V = clVout_V(i0);
        [iLow,iHigh] = continuousIndices(abs(clErr_V)<=trackLimit,i0);
        if isfinite(iLow)
            m.inputLow_V = clVin_V(iLow);
            m.inputHigh_V = clVin_V(iHigh);
            m.swingLow_V = min(clVout_V(iLow:iHigh));
            m.swingHigh_V = max(clVout_V(iLow:iHigh));
        end
        tr = cols(numdata(clFiles(3)),7);
        [m.srRise_Vus,m.srFall_Vus,tRise_s,tFall_s] = ...
            stepMetrics(tr(:,1),tr(:,2),tr(:,3),settleLimit);
        m.settle_s = maxFinite([tRise_s tFall_s]);
    end
end

function values = metricsToReport(m,rows,cLoad_pF)
    values = repmat("NaN",size(rows,1),1);
    for rowIndex = 1:size(rows,1)
        parameter = rows(rowIndex,1);
        unit = rows(rowIndex,2);
        if unit == ""
            values(rowIndex) = "";
            continue;
        end
        switch parameter
            case "AVDD", raw = m.vdd_V;
            case "CLoad", raw = cLoad_pF;
            case "Vin,cm", raw = m.vinCm_V;
            case "Closed-loop target gain", raw = 1;
            case "Bias current", raw = m.ibias_A*1e6;
            case "Total current", raw = m.totalCurrent_A*1e6;
            case "Total power", raw = m.totalPower_W*1e3;
            case "DC gain", raw = m.dcGain_dB;
            case "UGF", raw = m.ugf_Hz/1e6;
            case "Phase margin", raw = m.pm_deg;
            case "Input offset", raw = voltageInUnit(m.offset_V,unit);
            case "CMRR @ 60 Hz", raw = m.cmrr_dB(1);
            case "CMRR @ 150 Hz", raw = m.cmrr_dB(2);
            case "PSRR+ @ 60 Hz", raw = m.psrrP_dB(1);
            case "PSRR+ @ 150 Hz", raw = m.psrrP_dB(2);
            case "PSRR- @ 60 Hz", raw = m.psrrN_dB(1);
            case "PSRR- @ 150 Hz", raw = m.psrrN_dB(2);
            case "Input-referred noise 0.05-150 Hz"
                raw = voltageInUnit(m.inputNoise_Vrms,erase(unit,"rms"));
            case "Closed-loop gain", raw = m.clGain_dB;
            case "Gain error", raw = m.gainError_pct;
            case "Vout,DC", raw = voltageInUnit(m.voutDc_V,unit);
            case "Input CM low", raw = voltageInUnit(m.inputLow_V,unit);
            case "Input CM high", raw = voltageInUnit(m.inputHigh_V,unit);
            case "Output swing low", raw = voltageInUnit(m.swingLow_V,unit);
            case "Output swing high", raw = voltageInUnit(m.swingHigh_V,unit);
            case "SR rise", raw = m.srRise_Vus;
            case "SR fall", raw = m.srFall_Vus;
            case "Settling time", raw = m.settle_s*1e9;
            otherwise, raw = NaN;
        end
        if unit == "dB" || unit == "%"
            values(rowIndex) = fmtDbPercent(raw);
        else
            values(rowIndex) = fmt(raw);
        end
    end
end

function value = voltageInUnit(value_V,unit)
    switch string(unit)
        case "V", value = value_V;
        case "mV", value = value_V*1e3;
        case "uV", value = value_V*1e6;
        case "nV", value = value_V*1e9;
        otherwise, error('Unsupported voltage report unit %s.',unit);
    end
end

function results = buildWorstCaseTable(rows,columns,values,metrics)
    keep = rows(:,2) ~= "" & ~ismember(rows(:,1), ...
        ["AVDD" "CLoad" "Vin,cm" "Closed-loop target gain"]);
    parameters = rows(keep,1);
    units = rows(keep,2);
    sourceRows = find(keep);
    worstValues = nan(numel(sourceRows),1);
    worstCorners = strings(numel(sourceRows),1);
    for resultIndex = 1:numel(sourceRows)
        rowIndex = sourceRows(resultIndex);
        parameter = rows(rowIndex,1);
        candidates = str2double(values(rowIndex,:));
        valid = isfinite(candidates);
        if ~any(valid), continue; end
        validIndices = find(valid);

        if ismember(parameter,["DC gain" "UGF" "Phase margin" ...
                "CMRR @ 60 Hz" "CMRR @ 150 Hz" "PSRR+ @ 60 Hz" ...
                "PSRR+ @ 150 Hz" "PSRR- @ 60 Hz" "PSRR- @ 150 Hz" ...
                "Input CM high" "Output swing high" "SR rise" "SR fall"])
            [selectedValue,localIndex] = min(candidates(valid));
        elseif parameter == "Bias current"
            rawCandidates = cellfun(@(m) m.ibias_A,metrics)*1e6;
            [~,selectedColumn] = max(abs(rawCandidates-40));
            selectedValue = candidates(selectedColumn);
        elseif parameter == "Vout,DC"
            rawCandidates = cellfun(@(m) m.voutDc_V,metrics);
            references = cellfun(@(m) m.vinCm_V,metrics);
            rawError_V = rawCandidates-references;
            selectionError = abs(rawError_V);
            selectionError(~isfinite(selectionError)) = -Inf;
            [~,selectedColumn] = max(selectionError);
            [selectedValue,selectedUnit] = ...
                voltageReport(rawError_V(selectedColumn),"");
            parameters(resultIndex) = "Vout,DC error";
            units(resultIndex) = selectedUnit;
        elseif ismember(parameter,["Input offset" "Closed-loop gain" "Gain error"])
            [~,localIndex] = max(abs(candidates(valid)));
            selectedValue = candidates(validIndices(localIndex));
        else
            [selectedValue,localIndex] = max(candidates(valid));
        end
        if parameter ~= "Bias current" && parameter ~= "Vout,DC"
            selectedColumn = validIndices(localIndex);
        end
        worstValues(resultIndex) = selectedValue;
        worstCorners(resultIndex) = columns(selectedColumn);
    end

    formatted = strings(size(worstValues));
    for resultIndex = 1:numel(worstValues)
        if units(resultIndex) == "dB" || units(resultIndex) == "%"
            formatted(resultIndex) = fmtDbPercent(worstValues(resultIndex));
        else
            formatted(resultIndex) = fmt(worstValues(resultIndex));
        end
    end
    results = table(parameters,units,formatted,worstCorners, ...
        'VariableNames',{'Parameter','Unit','Value','Corner'});
end

function printWorstCaseTable(results)
    parameterWidth = max(36,max(strlength(results.Parameter))+2);
    fprintf('%-*s %-8s %13s %-8s\n',parameterWidth, ...
        'Parameter','Unit','Value','Corner');
    fprintf('%s\n',repmat('-',1,parameterWidth+32));
    for rowIndex = 1:height(results)
        fprintf('%-*s %-8s %13s %-8s\n',parameterWidth, ...
            char(results.Parameter(rowIndex)),char(results.Unit(rowIndex)), ...
            char(results.Value(rowIndex)),char(results.Corner(rowIndex)));
    end
end

function [f,H] = transferFromFile(file)
    d = numdata(file);
    d = cols(d,5);
    f = d(:,1);
    in = d(:,2) + 1j*d(:,3);
    out = d(:,4) + 1j*d(:,5);
    H = out ./ in;
end

function [gain_dB,phase_deg,ugf_Hz,pm_deg,f3dB_Hz] = acMetrics(f,H)
    gain_dB = 20*log10(abs(H));
    phase_deg = unwrap(angle(H))*180/pi;
    ugf_Hz = gainCross(f,gain_dB,0);
    pm_deg = 180 + interpAtFreq(f,phase_deg,ugf_Hz);
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
        addCursorLine(f0,y0,sprintf('%s: %.4g dB',freqText(f0),y0));
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

function fig = wideFigure()
fig = figure;
end

function saveFig(plotDir,fileName)
    fig = gcf;
    drawnow;
    fig.PaperUnits = 'inches';
    fig.PaperPosition = [0 0 10 4];
    fig.PaperSize = [10 4];
    print(fig,fullfile(plotDir,fileName),'-dpng','-r250');
end

function [value,unit] = voltageReport(value_V,suffix)
    magnitude_V = abs(value_V);
    if isfinite(value_V) && magnitude_V < 1e-6
        value = value_V*1e9;
        unit = "nV" + suffix;
    elseif isfinite(value_V) && magnitude_V < 1e-3
        value = value_V*1e6;
        unit = "uV" + suffix;
    elseif isfinite(value_V) && magnitude_V < 1
        value = value_V*1e3;
        unit = "mV" + suffix;
    else
        value = value_V;
        unit = "V" + suffix;
    end
end

function printSummaryTable(rows,columns,values)
    parameterWidth = max(36,max(strlength(rows(:,1)))+2);
    fprintf('%-*s %-8s',parameterWidth,'Parameter','Unit');
    for columnIndex = 1:numel(columns)
        fprintf(' %13s',columns(columnIndex));
    end
    fprintf('\n%s\n',repmat('-',1,parameterWidth+9+14*numel(columns)));
    for rowIndex = 1:size(rows,1)
        parameter = rows(rowIndex,1);
        unit = rows(rowIndex,2);
        if parameter == "" && unit == ""
            fprintf('\n');
        elseif unit == ""
            fprintf('%-*s\n',parameterWidth,upper(char(parameter)));
        else
            fprintf('%-*s %-8s',parameterWidth,char(parameter),char(unit));
            for columnIndex = 1:numel(columns)
                fprintf(' %13s',char(values(rowIndex,columnIndex)));
            end
            fprintf('\n');
        end
    end
end

function s = fmt(x)
    if isnan(x)
        s = "NaN";
    elseif isinf(x)
        s = string(sprintf('%+g',x));
    else
        s = string(sprintf('%.3f',x));
    end
end

function s = fmtDbPercent(x)
    if isnan(x)
        s = "NaN";
    elseif isinf(x)
        s = string(sprintf('%+g',x));
    elseif x ~= 0 && abs(x) < 1
        s = string(sprintf('%.3e',x));
    else
        s = string(sprintf('%.3f',x));
    end
end

function s = freqText(f)
    if f >= 1e6
        s = sprintf('%.4g MHz',f/1e6);
    elseif f >= 1e3
        s = sprintf('%.4g kHz',f/1e3);
    else
        s = sprintf('%.4g Hz',f);
    end
end
