
% FDOTA nominal analysis
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~exist(plotDir,'dir'), mkdir(plotDir); end

TAG = "NOM";
VOUT_CM_TARGET = 1.65;
TRACK_LIMIT = 2e-3;
OFFSET_LIMIT = 2e-3;
ICMR_CURRENT_TOL = 0.20;
ICMR_GAIN_DROP_DB = 0.1;
VOUT_CM_TOL = 2e-3;
OUTPUT_MARGIN = 0.10;
SETTLE_LIMIT = 10e-3;
NOISE_BAND_HZ = [0.05 150];
MARK_FREQ_HZ = [0.05 60 150 1e3];
NOISE_MARK_HZ = [NOISE_BAND_HZ(1) 60 NOISE_BAND_HZ(2)];

%% Operating point
op = cols(numdata(fullfile(baseDir,TAG + ".ol_op.txt")),14);
op = op(end,:);

vdd_V = op(1);
vinCm_V = 0.5*(op(2) + op(3));
idd_A = abs(op(12));
ibiasFdc_A = abs(op(13));
ibiasCmfb_A = abs(op(14));
totalCurrent_A = idd_A + ibiasFdc_A + ibiasCmfb_A;
totalPower_W = vdd_V*totalCurrent_A;

%% Open-loop gain and phase
[f_Hz,Ad] = transferFromFile(fullfile(baseDir,TAG + ".ol_diff_ac.txt"));
[gain_dB,phase_deg,ugf_Hz,pm_deg,f3dB_Hz] = acMetrics(f_Hz,Ad);
dcGain_dB = gain_dB(1);

figure;
yyaxis left;
semilogx(f_Hz,gain_dB,'LineWidth',1.5); hold on;
yline(0,'--','HandleVisibility','off');
addCursor(f3dB_Hz,dcGain_dB-3,sprintf('-3dB: %s',freqText(f3dB_Hz)));
addCursor(ugf_Hz,0,sprintf('UGF: %s',freqText(ugf_Hz)));
ylabel('Differential gain (dB)');

yyaxis right;
semilogx(f_Hz,phase_deg,'LineWidth',1.5); hold on;
addCursor(ugf_Hz,interpAtFreq(f_Hz,phase_deg,ugf_Hz),sprintf('PM: %.4g deg',pm_deg));
ylabel('Differential phase (deg)');
stylePlot('Frequency (Hz)','FDOTA Open-Loop Gain and Phase');
saveFig(plotDir,'NOM.open_loop_gain_phase.png');

%% CMRR and PSRR
[fCm_Hz,Acm] = transferFromFile(fullfile(baseDir,TAG + ".ol_cm_ac.txt"));
[fP_Hz,AsupP] = transferFromFile(fullfile(baseDir,TAG + ".ol_psrrp_ac.txt"));
[fN_Hz,AsupN] = transferFromFile(fullfile(baseDir,TAG + ".ol_psrrn_ac.txt"));

cmrr_dB = rejectionDb(f_Hz,Ad,fCm_Hz,Acm);
psrrP_dB = rejectionDb(f_Hz,Ad,fP_Hz,AsupP);
psrrN_dB = rejectionDb(f_Hz,Ad,fN_Hz,AsupN);

cmrrAt_dB = interpAtFreq(fCm_Hz,cmrr_dB,MARK_FREQ_HZ);
psrrPAt_dB = interpAtFreq(fP_Hz,psrrP_dB,MARK_FREQ_HZ);
psrrNAt_dB = interpAtFreq(fN_Hz,psrrN_dB,MARK_FREQ_HZ);

figure;
semilogx(fCm_Hz,cmrr_dB,'LineWidth',1.5); hold on;
labelFreqSet(fCm_Hz,cmrr_dB,MARK_FREQ_HZ);
ylabel('CMRR (dB)');
stylePlot('Frequency (Hz)','FDOTA CMRR versus Frequency');
saveFig(plotDir,'NOM.cmrr.png');

figure;
tiledlayout(2,1);
sgtitle('FDOTA PSRR+ and PSRR- versus Frequency');
nexttile;
semilogx(fP_Hz,psrrP_dB,'LineWidth',1.5); hold on;
labelFreqSet(fP_Hz,psrrP_dB,MARK_FREQ_HZ);
ylabel('PSRR+ (dB)');
stylePlot('Frequency (Hz)','FDOTA PSRR+');

nexttile;
semilogx(fN_Hz,psrrN_dB,'LineWidth',1.5); hold on;
labelFreqSet(fN_Hz,psrrN_dB,MARK_FREQ_HZ);
ylabel('PSRR- (dB)');
stylePlot('Frequency (Hz)','FDOTA PSRR-');
saveFig(plotDir,'NOM.psrr.png');

%% Input-referred noise
[fNoise_Hz,outNoise_VrtHz] = readNoise(baseDir,TAG);
inNoise_VrtHz = outNoise_VrtHz ./ interpAtFreq(f_Hz,abs(Ad),fNoise_Hz);
inputNoise_Vrms = integrateNoise(fNoise_Hz,inNoise_VrtHz,NOISE_BAND_HZ);

figure;
validNoise = fNoise_Hz >= NOISE_BAND_HZ(1) & fNoise_Hz <= NOISE_BAND_HZ(2) & ...
    isfinite(inNoise_VrtHz) & inNoise_VrtHz > 0;
loglog(fNoise_Hz(validNoise),inNoise_VrtHz(validNoise)*1e9,'LineWidth',1.5); hold on;
for f0 = NOISE_MARK_HZ
    y0 = interpAtFreq(fNoise_Hz,inNoise_VrtHz,f0)*1e9;
    addCursor(f0,y0,sprintf('%s: %.4g nV/rtHz',freqText(f0),y0));
end
ylabel('Input noise (nV/sqrtHz)');
xlim(NOISE_BAND_HZ);
stylePlot('Frequency (Hz)','FDOTA Input-Referred Noise Density versus Frequency');
saveFig(plotDir,'NOM.input_referred_noise_density.png');

%% Open-loop VTC
vtc = cols(numdata(fullfile(baseDir,TAG + ".ol_vtc.txt")),9);
vtcVinDiff_V = vtc(:,1);
vtcVoutDiff_V = vtc(:,7);
offset_V = zeroNoJump(vtcVinDiff_V,vtcVoutDiff_V,0.25*vdd_V);

figure;
plot(vtcVinDiff_V*1e3,vtcVoutDiff_V,'LineWidth',1.5); hold on;
yline(0,'--','HandleVisibility','off');
addCursor(offset_V*1e3,0,sprintf('Vos: %.4g mV',offset_V*1e3));
ylabel('Vout,diff (V)');
stylePlot('Vin,diff (mV)','FDOTA Open-Loop VTC');
saveFig(plotDir,'NOM.open_loop_vtc.png');

%% Closed-loop VTC and output swing
cl = cols(numdata(fullfile(baseDir,TAG + ".cl_diff_dc.txt")),8);
clCmd_V = cl(:,1);
clVoutp_V = cl(:,3);
clVoutn_V = cl(:,4);
clVoutcm_V = cl(:,5);
clVoutdiff_V = cl(:,6);

[clCmd_V,idx] = sort(clCmd_V);
clVoutp_V = clVoutp_V(idx);
clVoutn_V = clVoutn_V(idx);
clVoutcm_V = clVoutcm_V(idx);
clVoutdiff_V = clVoutdiff_V(idx);

[~,i0] = min(abs(clCmd_V));
clGain = localSlope(clCmd_V,clVoutdiff_V,0);
gainError_pct = 100*(clGain - 1);
voutpDC_V = clVoutp_V(i0);
voutnDC_V = clVoutn_V(i0);
voutcmDC_V = clVoutcm_V(i0);
voutcmError_mV = 1e3*(voutcmDC_V - VOUT_CM_TARGET);
voutdiffDC_V = clVoutdiff_V(i0);

trackError_V = clVoutdiff_V - clCmd_V;
validSwing = abs(trackError_V) <= TRACK_LIMIT;
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

figure;
plot(clCmd_V,trackError_V*1e3,'LineWidth',1.5); hold on;
yline(TRACK_LIMIT*1e3,'--','+2mV','HandleVisibility','off');
yline(-TRACK_LIMIT*1e3,'--','-2mV','HandleVisibility','off');
if isfinite(iLow)
    xline(clCmd_V(iLow),'--',sprintf('Low: %.4g V',clCmd_V(iLow)),'HandleVisibility','off');
    xline(clCmd_V(iHigh),'--',sprintf('High: %.4g V',clCmd_V(iHigh)),'HandleVisibility','off');
end
ylabel('Tracking error (mV)');
stylePlot('Vin,diff command (V)','FDOTA Output Swing / DC Tracking Error');
saveFig(plotDir,'NOM.output_swing_tracking_error.png');

figure;
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
stylePlot('Vin,diff command (V)','FDOTA Closed-Loop VTC');
saveFig(plotDir,'NOM.closed_loop_vtc.png');

%% Input common-mode range
ic = cols(numdata(fullfile(baseDir,TAG + ".cl_icmr.txt")),12);
[icmrLow_V,icmrHigh_V,icmr] = analyzeICMRSweep(ic(:,2),ic(:,5),ic(:,6),ic(:,7), ...
    ic(:,8),ic(:,9),ic(:,10),abs(ic(:,12)),vinCm_V,VOUT_CM_TARGET,vdd_V, ...
    OFFSET_LIMIT,ICMR_CURRENT_TOL,ICMR_GAIN_DROP_DB,VOUT_CM_TOL,OUTPUT_MARGIN);

figure;
tiledlayout(4,1);
nexttile;
plot(icmr.vcm,icmr.reqVinDiff*1e3,'LineWidth',1.5); hold on;
plot(icmr.vcm(icmr.valid),icmr.reqVinDiff(icmr.valid)*1e3,'r','LineWidth',2.0);
labelRange(icmrLow_V,icmrHigh_V);
ylabel('Req Vin,diff (mV)');
stylePlot('','FDOTA Input Common-Mode Range');

nexttile;
plot(icmr.vcm,icmr.idd*1e6,'LineWidth',1.5); hold on;
plot(icmr.vcm(icmr.valid),icmr.idd(icmr.valid)*1e6,'r','LineWidth',2.0);
labelRange(icmrLow_V,icmrHigh_V);
ylabel('IDD (uA)');
stylePlot('','');

nexttile;
plot(icmr.vcm,20*log10(abs(icmr.gain)),'LineWidth',1.5); hold on;
plot(icmr.vcm(icmr.valid),20*log10(abs(icmr.gain(icmr.valid))),'r','LineWidth',2.0);
labelRange(icmrLow_V,icmrHigh_V);
ylabel('Local gain (dB)');
stylePlot('','');

nexttile;
voutCmErr_mV = 1e3*(icmr.voutcm - VOUT_CM_TARGET);
plot(icmr.vcm,voutCmErr_mV,'LineWidth',1.5); hold on;
plot(icmr.vcm(icmr.valid),voutCmErr_mV(icmr.valid),'r','LineWidth',2.0);
yline(VOUT_CM_TOL*1e3,'--',sprintf('+%.4gmV',VOUT_CM_TOL*1e3),'HandleVisibility','off');
yline(-VOUT_CM_TOL*1e3,'--',sprintf('-%.4gmV',VOUT_CM_TOL*1e3),'HandleVisibility','off');
labelRange(icmrLow_V,icmrHigh_V);
ylabel('Vout,cm err (mV)');
stylePlot('Vin,cm (V)','');
saveFig(plotDir,'NOM.input_common_mode_range.png');

%% Closed-loop transient
tr = cols(numdata(fullfile(baseDir,TAG + ".cl_diff_tran.txt")),9);
tDiff_s = tr(:,1);
trCmd_V = tr(:,2);
trVoutp_V = tr(:,4);
trVoutn_V = tr(:,5);
trVoutdiff_V = tr(:,7);

targetOutp_V = VOUT_CM_TARGET + 0.5*trCmd_V;
targetOutn_V = VOUT_CM_TARGET - 0.5*trCmd_V;
[srOutpRise_Vus,srOutpFall_Vus,tOutpRise_s,tOutpFall_s,outpRisePt,outpFallPt] = stepMetrics(tDiff_s,targetOutp_V,trVoutp_V,TRACK_LIMIT);
[srOutnRise_Vus,srOutnFall_Vus,tOutnRise_s,tOutnFall_s,outnRisePt,outnFallPt] = stepMetrics(tDiff_s,targetOutn_V,trVoutn_V,TRACK_LIMIT);
[srDiffRise_Vus,srDiffFall_Vus,tDiffRise_s,tDiffFall_s,diffRisePt,diffFallPt] = stepMetrics(tDiff_s,trCmd_V,trVoutdiff_V,TRACK_LIMIT);
settleOutp_s = maxFinite([tOutpRise_s tOutpFall_s]);
settleOutn_s = maxFinite([tOutnRise_s tOutnFall_s]);
settleDiff_s = maxFinite([tDiffRise_s tDiffFall_s]);

figure;
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
ylabel('Output voltage (V)');
legend('OUTP target','OUTN target','OUTP','OUTN','Location','best');
stylePlot('','FDOTA Closed-Loop Step Response');

nexttile;
plot(tDiff_s*1e6,trCmd_V,'--','LineWidth',1.2); hold on;
plot(tDiff_s*1e6,trCmd_V+TRACK_LIMIT,':','LineWidth',1.0,'HandleVisibility','off');
plot(tDiff_s*1e6,trCmd_V-TRACK_LIMIT,':','LineWidth',1.0,'HandleVisibility','off');
plot(tDiff_s*1e6,trVoutdiff_V,'LineWidth',1.5);
addSrCursor(diffRisePt,sprintf('Diff rise: %.4g V/us',srDiffRise_Vus));
addSrCursor(diffFallPt,sprintf('Diff fall: %.4g V/us',srDiffFall_Vus));
ylabel('Differential voltage (V)');
legend('Command','Output','Location','best');
stylePlot('Time (us)','FDOTA Closed-Loop Step Response');
saveFig(plotDir,'NOM.closed_loop_step_response.png');

cm = cols(numdata(fullfile(baseDir,TAG + ".cl_cm_tran.txt")),8);
tCm_s = cm(:,1);
trVref_V = cm(:,2);
trVocm_V = cm(:,3);
trVoutcm_V = cm(:,6);
[cmSettleLow_s,cmSettleHigh_s] = cmSettling(tCm_s,trVref_V,trVoutcm_V,VOUT_CM_TARGET,SETTLE_LIMIT);
outputCmSettling_s = maxFinite([cmSettleLow_s cmSettleHigh_s]);

figure;
plot(tCm_s*1e6,trVref_V,'--','LineWidth',1.2); hold on;
plot(tCm_s*1e6,trVocm_V,'LineWidth',1.2);
plot(tCm_s*1e6,trVoutcm_V,'LineWidth',1.5);
yline(VOUT_CM_TARGET+SETTLE_LIMIT,':','HandleVisibility','off');
yline(VOUT_CM_TARGET-SETTLE_LIMIT,':','HandleVisibility','off');
ylabel('Common-mode voltage (V)');
legend('VREF','VOCM pin','Vout,cm','Location','best');
stylePlot('Time (us)','FDOTA Output CM Settling: VREF L to VDD/2 and H to VDD/2');
saveFig(plotDir,'NOM.output_cm_transient.png');

%% Summary table
rows = [
    "Open-loop simulation",  "",      ""
    "Total current",         "uA",    fmt(totalCurrent_A*1e6)
    "Total power",           "mW",    fmt(totalPower_W*1e3)
    "Diff DC gain",          "dB",    fmt(dcGain_dB)
    "Diff UGF",              "MHz",   fmt(ugf_Hz/1e6)
    "Diff Phase margin",     "deg",   fmt(pm_deg)
    "Input offset",          "mV",    fmt(offset_V*1e3)
    "CMRR @ 0.05 Hz",        "dB",    fmt(cmrrAt_dB(1))
    "CMRR @ 60 Hz",          "dB",    fmt(cmrrAt_dB(2))
    "CMRR @ 150 Hz",         "dB",    fmt(cmrrAt_dB(3))
    "CMRR @ 1 kHz",          "dB",    fmt(cmrrAt_dB(4))
    "PSRR+ @ 0.05 Hz",       "dB",    fmt(psrrPAt_dB(1))
    "PSRR+ @ 60 Hz",         "dB",    fmt(psrrPAt_dB(2))
    "PSRR+ @ 150 Hz",        "dB",    fmt(psrrPAt_dB(3))
    "PSRR+ @ 1 kHz",         "dB",    fmt(psrrPAt_dB(4))
    "PSRR- @ 0.05 Hz",       "dB",    fmt(psrrNAt_dB(1))
    "PSRR- @ 60 Hz",         "dB",    fmt(psrrNAt_dB(2))
    "PSRR- @ 150 Hz",        "dB",    fmt(psrrNAt_dB(3))
    "PSRR- @ 1 kHz",         "dB",    fmt(psrrNAt_dB(4))
    "Input-referred noise",  "uVrms", fmt(inputNoise_Vrms*1e6)
    "",                      "",      ""
    "Closed-loop simulation","",      ""
    "Gain error",            "%",     fmt(gainError_pct)
    "Voutp,DC",              "V",     fmt(voutpDC_V)
    "Voutn,DC",              "V",     fmt(voutnDC_V)
    "Vout,cm",               "V",     fmt(voutcmDC_V)
    "Vout,cm error",         "mV",    fmt(voutcmError_mV)
    "Vout,diff,DC",          "V",     fmt(voutdiffDC_V)
    "Input CM low",          "V",     fmt(icmrLow_V)
    "Input CM high",         "V",     fmt(icmrHigh_V)
    "Diff Input low",        "V",     fmt(inputLow_V)
    "Diff Input high",       "V",     fmt(inputHigh_V)
    "Diff Output swing low", "V",     fmt(swingLow_V)
    "Diff Output swing high","V",     fmt(swingHigh_V)
    "SR rise +",             "V/us",  fmt(srOutpRise_Vus)
    "SR fall +",             "V/us",  fmt(srOutpFall_Vus)
    "SR rise -",             "V/us",  fmt(srOutnRise_Vus)
    "SR fall -",             "V/us",  fmt(srOutnFall_Vus)
    "Diff rise",             "V/us",  fmt(srDiffRise_Vus)
    "Diff fall",             "V/us",  fmt(srDiffFall_Vus)
    "Settling time + OUTP",  "ns",    fmt(settleOutp_s*1e9)
    "Settling time - OUTN",  "ns",    fmt(settleOutn_s*1e9)
    "Diff Settling time",    "ns",    fmt(settleDiff_s*1e9)
    "Output CM settling time","ns",   fmt(outputCmSettling_s*1e9)
];

Result = table(rows(:,1),rows(:,2),rows(:,3), ...
    'VariableNames',{'Parameter','Unit','Value'});
disp(Result);
writetable(Result,fullfile(scriptDir,'NOM.FDOTA_summary.csv'));

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

function [f,A] = transferFromFile(file)
    D = cols(numdata(file),5);
    f = D(:,1);
    vin = D(:,2) + 1j*D(:,3);
    vout = D(:,4) + 1j*D(:,5);
    A = vout ./ vin;
end

function [gain_dB,phase_deg,ugf_Hz,pm_deg,f3dB_Hz] = acMetrics(f,A)
    gain_dB = 20*log10(max(abs(A),realmin));
    phase_deg = unwrap(angle(A))*180/pi;
    if abs(phase_deg(1)) > 90
        A = -A;
        phase_deg = unwrap(angle(A))*180/pi;
    end
    f3dB_Hz = gainCross(f,gain_dB,gain_dB(1)-3);
    ugf_Hz = gainCross(f,gain_dB,0);
    pm_deg = 180 + interpAtFreq(f,phase_deg,ugf_Hz);
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
        addCursorLine(f0,y0,sprintf('%s: %.4g dB',freqText(f0),y0));
    end
end

function [f,en] = readNoise(baseDir,tag)
    Dp = cols(numdata(fullfile(baseDir,tag + ".ol_noise_outp.txt")),2);
    Dn = cols(numdata(fullfile(baseDir,tag + ".ol_noise_outn.txt")),2);
    f = Dp(:,1);
    enN = interp1(Dn(:,1),Dn(:,2),f,'linear',NaN);
    en = sqrt(abs(Dp(:,2)).^2 + abs(enN).^2);
end

function vn = integrateNoise(f,en,band)
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

function [lo,hi,icmr] = analyzeICMRSweep(vcm,cmd,vinDiff,voutp,voutn,voutcm,voutdiff,idd, ...
    vinCmNom,voutCmTarget,vdd,offsetLimit,currentTol,gainDrop_dB,cmTol,outputMargin)
    vcmKey = round(vcm*1e9)/1e9;
    vcmList = unique(vcmKey);
    n = numel(vcmList);
    reqVinDiff = NaN(n,1); gain = NaN(n,1); current = NaN(n,1);
    outp = NaN(n,1); outn = NaN(n,1); outcm = NaN(n,1);

    for i = 1:n
        m = vcmKey == vcmList(i);
        c = cmd(m); vd = vinDiff(m); vp = voutp(m); vn = voutn(m);
        vc = voutcm(m); vo = voutdiff(m); ii = idd(m);
        [c,idx] = sort(c);
        vd = vd(idx); vp = vp(idx); vn = vn(idx); vc = vc(idx); vo = vo(idx); ii = ii(idx);

        c0 = zeroNoJump(c,vo,0.25*vdd);
        if ~isfinite(c0), continue; end

        reqVinDiff(i) = interp1(c,vd,c0,'linear',NaN);
        gain(i) = localSlope(c,vo,c0);
        current(i) = abs(interp1(c,ii,c0,'linear',NaN));
        outp(i) = interp1(c,vp,c0,'linear',NaN);
        outn(i) = interp1(c,vn,c0,'linear',NaN);
        outcm(i) = interp1(c,vc,c0,'linear',NaN);
    end

    valid = false(n,1);
    lo = NaN; hi = NaN;
    finite = isfinite(reqVinDiff) & isfinite(gain) & isfinite(current) & isfinite(outcm);

    if any(finite)
        idxFinite = find(finite);
        [~,j] = min(abs(vcmList(idxFinite)-vinCmNom));
        iNom = idxFinite(j);
        gainNom = abs(gain(iNom));
        currentNom = current(iNom);
        gainDrop = abs(20*log10(abs(gain)/gainNom));

        valid = finite & abs(reqVinDiff) <= offsetLimit & ...
            abs(current-currentNom) <= currentTol*currentNom & ...
            gainDrop <= gainDrop_dB & ...
            abs(outcm-voutCmTarget) <= cmTol & ...
            outp >= outputMargin & outp <= vdd-outputMargin & ...
            outn >= outputMargin & outn <= vdd-outputMargin;

        [iLow,iHigh] = continuousIndices(valid,iNom);
        if isfinite(iLow)
            lo = vcmList(iLow);
            hi = vcmList(iHigh);
        end
    end

    icmr = struct('vcm',vcmList,'reqVinDiff',reqVinDiff,'gain',gain, ...
        'idd',current,'voutcm',outcm,'valid',valid);
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

function [tLow,tHigh] = cmSettling(t,cmd,out,target,tol)
    events = stepEvents(cmd);
    tLow = NaN; tHigh = NaN;
    for i = 1:numel(events)
        i1 = events(i);
        if i < numel(events), i2 = events(i+1)-1; else, i2 = numel(t); end
        if i2-i1 < 5, continue; end
        startRef = cmd(max(1,i1-1));
        finalRef = mean(cmd(max(i1,i2-round(0.1*(i2-i1))):i2));
        ts = settleTime(t(i1:i2),out(i1:i2),target,tol);
        if finalRef > startRef
            tLow = ts;
        else
            tHigh = ts;
        end
    end
end

function y = maxFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(x); end
end

function addSrCursor(point,labelText)
    addCursor(point(1),point(2),labelText);
end

function labelRange(lo,hi)
    if isfinite(lo), xline(lo,'--',sprintf('Lo: %.4g V',lo),'HandleVisibility','off'); end
    if isfinite(hi), xline(hi,'--',sprintf('Hi: %.4g V',hi),'HandleVisibility','off'); end
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

function addCursorHLine(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    yline(y,':'," " + string(labelText),'HandleVisibility','off', ...
        'LabelVerticalAlignment','middle','LabelHorizontalAlignment','left');
end

function stylePlot(xLabelText,titleText)
    grid on;
    if strlength(string(xLabelText)) > 0, xlabel(xLabelText); end
    if strlength(string(titleText)) > 0, title(titleText); end
end

function saveFig(plotDir,fileName)
    saveas(gcf,fullfile(plotDir,fileName));
end

function s = fmt(x)
    if ~isfinite(x)
        s = "NaN";
    else
        s = string(sprintf('%.6g',x));
    end
end

function s = freqText(f)
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
