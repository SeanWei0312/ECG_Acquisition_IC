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
NOISE_MARK_HZ = [NOISE_BAND_HZ(1) 60 NOISE_BAND_HZ(2)];

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
loglog(fNoise_Hz(validNoise),inNoise_VrtHz(validNoise)*1e9,'LineWidth',1.5); hold on;
for f0 = NOISE_MARK_HZ
    y0 = interpAtFreq(fNoise_Hz,inNoise_VrtHz,f0)*1e9;
    addCursor(f0,y0,sprintf('%s: %.4g nV/rtHz',freqText(f0),y0));
end
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

%% Closed-loop: usable follower range
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

validTrack = abs(clErr_V) <= TRACK_LIMIT;
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

wideFigure();
tiledlayout(2,1);
sgtitle('SEOTA Closed-Loop Usable Input/Output Range');

nexttile;
plot(clVin_V,clErr_V*1e3,'LineWidth',1.5); hold on;
yline(TRACK_LIMIT*1e3,'--','+2 mV','HandleVisibility','off');
yline(-TRACK_LIMIT*1e3,'--','-2 mV','HandleVisibility','off');
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
saveFig(plotDir,'NOM.closed_loop_usable_range.png');

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
nomMetrics.usableInputLow_V = usableInputLow_V;
nomMetrics.usableInputHigh_V = usableInputHigh_V;
nomMetrics.inputHighHeadroom_V = inputHighHeadroom_V;
nomMetrics.usableOutputLow_V = usableOutputLow_V;
nomMetrics.usableOutputHigh_V = usableOutputHigh_V;
nomMetrics.outputHighHeadroom_V = outputHighHeadroom_V;
nomMetrics.srRise_Vus = srRise_Vus;
nomMetrics.srFall_Vus = srFall_Vus;
nomMetrics.settle_s = settle_s;

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

%% Summary table: 2-column definition (parameter, unit only — no NOM values)
rows = [
    "Set conditions",              ""
    "AVDD",                        "V"
    "CLoad",                       "pF"
    "Vin,cm",                      "V"
    "Closed-loop target gain",     "V/V"
    "",                            ""
    "Open-loop simulation",        ""
    "Bias current",                "A"
    "Total current",               "A"
    "Total power",                 "W"
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
    "Vout,DC",                     "V"
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

allProcesses = ["NOM" "FF" "SS" "FS" "SF"];
allCases = ["nom" "vl" "vh" "tl" "th" "vltl" "vlth" "vhtl" "vhth"];
caseCornerText = ["NOMNOM" "VLNOM" "VHNOM" "NOMTL" "NOMTH" ...
    "VLTL" "VLTH" "VHTL" "VHTH"];
pvtCorners = strings(0,1);
pvtRawValues = nan(size(rows,1),0);
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
        pvtRawValues(:,end+1) = metricsToRaw( ...
            metrics,rows,CLOAD_SET_PF); %#ok<SAGROW>
    end
end
if ~isempty(missingPvt)
    warning('SEOTA_Analyze:MissingPvtRuns', ...
        'PVT runs missing required OL files: %s.',strjoin(missingPvt,', '));
end

[rows,pvtScaledValues] = adaptReportUnits(rows,pvtRawValues);
pvtValues = formatReportValues(rows,pvtScaledValues);

reportColumns = ["NOM" "FF" "SS" "FS" "SF" "VL" "VH" "TL" "TH"];
reportCornerKeys = ["NOMNOMNOM" "FFNOMNOM" "SSNOMNOM" "FSNOMNOM" ...
    "SFNOMNOM" "NOMVLNOM" "NOMVHNOM" "NOMNOMTL" "NOMNOMTH"];
[foundReportCorners,reportIndices] = ismember(reportCornerKeys,pvtCorners);
if ~all(foundReportCorners)
    error('SEOTA_Analyze:MissingReportCorners', ...
        'Required summary corners are missing: %s.', ...
        strjoin(reportCornerKeys(~foundReportCorners),', '));
end
reportScaledValues = pvtScaledValues(:,reportIndices);
reportValues = pvtValues(:,reportIndices);

Result = table(rows(:,1),rows(:,2),'VariableNames',{'Parameter','Unit'});
Result = [Result array2table(reportValues, ...
    'VariableNames',cellstr(reportColumns))];
fprintf('\nSEOTA COMPARISON SUMMARY\n\n');
printSummaryTable(rows,reportColumns,reportValues);
writetable(Result,fullfile(scriptDir,'SEOTA_table_report.csv'));
writetable(Result,fullfile(scriptDir,'NOM.SEOTA_summary.csv'));

WorstCase = buildWorstCaseTable( ...
    rows,pvtCorners,pvtScaledValues,pvtMetrics);
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
    m.usableInputLow_V = NaN; m.usableInputHigh_V = NaN;
    m.inputHighHeadroom_V = NaN;
    m.usableOutputLow_V = NaN; m.usableOutputHigh_V = NaN;
    m.outputHighHeadroom_V = NaN;
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
            m.usableInputLow_V = clVin_V(iLow);
            m.usableInputHigh_V = clVin_V(iHigh);
            m.inputHighHeadroom_V = m.vdd_V - m.usableInputHigh_V;
            m.usableOutputLow_V = min(clVout_V(iLow:iHigh));
            m.usableOutputHigh_V = max(clVout_V(iLow:iHigh));
            m.outputHighHeadroom_V = m.vdd_V - m.usableOutputHigh_V;
        end
        tr = cols(numdata(clFiles(3)),7);
        [m.srRise_Vus,m.srFall_Vus,tRise_s,tFall_s] = ...
            stepMetrics(tr(:,1),tr(:,2),tr(:,3),settleLimit);
        m.settle_s = maxFinite([tRise_s tFall_s]);
    end
end

function values = metricsToRaw(m,rows,cLoad_pF)
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
            case "CLoad",                    values(rowIndex) = cLoad_pF;
            case "Vin,cm",                   values(rowIndex) = m.vinCm_V;
            case "Closed-loop target gain",  values(rowIndex) = 1;
            case "Bias current",             values(rowIndex) = m.ibias_A;
            case "Total current",            values(rowIndex) = m.totalCurrent_A;
            case "Total power",              values(rowIndex) = m.totalPower_W;
            case "DC gain",                  values(rowIndex) = m.dcGain_dB;
            case "UGF",                      values(rowIndex) = m.ugf_Hz;
            case "Phase margin",             values(rowIndex) = m.pm_deg;
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
            case "Vout,DC",                  values(rowIndex) = m.voutDc_V;
            case "Input low",                values(rowIndex) = m.usableInputLow_V;
            case "Input high",               values(rowIndex) = m.usableInputHigh_V;
            case "Input high headroom",      values(rowIndex) = m.inputHighHeadroom_V;
            case "Output low",               values(rowIndex) = m.usableOutputLow_V;
            case "Output high",              values(rowIndex) = m.usableOutputHigh_V;
            case "Output high headroom",     values(rowIndex) = m.outputHighHeadroom_V;
            case "SR rise",                  values(rowIndex) = m.srRise_Vus;
            case "SR fall",                  values(rowIndex) = m.srFall_Vus;
            case "Settling time",            values(rowIndex) = m.settle_s;
        end
    end
end

function results = buildWorstCaseTable(rows,columns,values,metrics)
    % values is numeric double (pvtScaledValues), already unit-adapted.
    keep = rows(:,2) ~= "" & ~ismember(rows(:,1), ...
        ["AVDD" "CLoad" "Vin,cm" "Closed-loop target gain"]);
    parameters = rows(keep,1);
    units = rows(keep,2);
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
            [selectedValue,newUnit] = scaleSingleMetric( ...
                rawError_V(selectedColumn),"V");
            parameters(resultIndex) = "Vout,DC error";
            units(resultIndex) = newUnit;
        elseif ismember(parameter,["Input offset" "Closed-loop gain" "Gain error"])
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
        if units(resultIndex) == "dB" || units(resultIndex) == "%"
            formatted(resultIndex) = fmtDbPercent(worstValues(resultIndex));
        else
            formatted(resultIndex) = fmtMetric(worstValues(resultIndex),units(resultIndex));
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
    elseif x ~= 0 && (abs(x) < 1e-3 || abs(x) > 999)
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

function [rows,scaledValues] = adaptReportUnits(rows,rawValues)
    % rawValues and scaledValues remain numeric doubles.
    % Unit changes use exact powers of 1000 only.
    scaledValues = rawValues;

    for i = 1:size(rows,1)
        unit = string(rows(i,2));

        if unit == "" || unit == "dB" || unit == "%"
            continue;
        end

        x = rawValues(i,:);
        finiteMask = isfinite(x);
        nonzeroMask = finiteMask & x ~= 0;

        if ~any(finiteMask)
            continue;
        end

        if ~any(nonzeroMask)
            continue;
        end

        magnitude = max(abs(x(nonzeroMask)));

        [newUnit,scalePower] = scaleUnit(magnitude,unit);

        scaledValues(i,:) = x * 1e3^scalePower;
        rows(i,2) = newUnit;
    end
end

function formatted = formatReportValues(rows,scaledValues)
    % First and only place numbers become strings.
    formatted = strings(size(scaledValues));
    for i = 1:size(scaledValues,1)
        unit = string(rows(i,2));
        if unit == ""
            continue;
        end
        for j = 1:size(scaledValues,2)
            if unit == "dB" || unit == "%"
                formatted(i,j) = fmtDbPercent(scaledValues(i,j));
            else
                formatted(i,j) = fmtMetric(scaledValues(i,j),unit);
            end
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

function s = fmtMetric(x,unit)
    if isnan(x)
        s = "NaN";
        return;
    end

    if isinf(x)
        s = string(sprintf('%+g',x));
        return;
    end

    [prefix,~] = splitUnitPrefix(unit);

    if prefix == "f" && x ~= 0 && abs(x) < 1e-3
        s = string(sprintf('%.3e',x));
    elseif prefix == "T" && abs(x) > 999
        s = string(sprintf('%.3e',x));
    else
        s = string(sprintf('%.3f',x));
    end
end

function [scaledValue,newUnit] = scaleSingleMetric(value,currentUnit)
    if ~isfinite(value) || value == 0
        scaledValue = value;
        newUnit = currentUnit;
        return;
    end

    [newUnit,scalePower] = scaleUnit(abs(value),currentUnit);
    scaledValue = value * 1e3^scalePower;
end

