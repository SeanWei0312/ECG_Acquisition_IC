% CMFB nominal analysis
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~exist(plotDir,'dir'), mkdir(plotDir); end

VOUT_CM_TARGET = 1.65;
CLOAD_pF = 10;
VIN_DIFF_V = 0;
REG_ERROR_LIMIT = 10e-3;
SETTLE_ERROR = 1e-3;
VCMFB_LIMIT = [0.3 3.0];
MIN_USEFUL_LOOP_GAIN_DB = 20;

%% Operating point
D = numdata(fullfile(baseDir,'NOM.cl_op.txt'));
op = D(end,:);

vdd_V     = op(2);
vcmRef_V  = op(3);
voutcm_V  = op(4);
vcmfbOp_V = op(5);
opError_V = op(6);
ibias_A   = op(7);
idd_A     = op(8);
power_W   = op(9);

%% Open-loop response
D = numdata(fullfile(baseDir,'NOM.ol_ac.txt'));
f_Hz = D(:,1);
Aloop = D(:,2) + 1j*D(:,3);
[gain_dB,phase_deg,ugf_Hz,pm_deg,f3dB_Hz] = acMetrics(f_Hz,Aloop);
dcGain_dB = gain_dB(1);

if dcGain_dB < MIN_USEFUL_LOOP_GAIN_DB
    warning('CMFB loop gain is only %.2f dB. Check ol_ac.txt/testbench.',dcGain_dB);
end

figure;
yyaxis left;
semilogx(f_Hz,gain_dB,'LineWidth',1.5); hold on;
yline(0,'--');
addCursor(f3dB_Hz,dcGain_dB-3,sprintf('-3dB: %s',freqText(f3dB_Hz)));
addCursor(ugf_Hz,0,sprintf('UGF: %s',freqText(ugf_Hz)));
ylabel('Loop gain (dB)');

yyaxis right;
semilogx(f_Hz,phase_deg,'LineWidth',1.5); hold on;
phaseUGF_deg = interpAtFreq(f_Hz,phase_deg,ugf_Hz);
addCursor(ugf_Hz,phaseUGF_deg,sprintf('PM: %.4g deg',pm_deg));
ylabel('Loop phase (deg)');
stylePlot('Frequency (Hz)','CMFB Open-Loop Response');
saveFig(plotDir,'NOM.ol_ac.png');

%% Closed-loop DC
D = numdata(fullfile(baseDir,'NOM.cl_dc.txt'));
clRef_V = D(:,1);
clVoutcm_V = D(:,2);
clIdeal_V = D(:,3);
clVcmfb_V = D(:,4);
clError_V = D(:,5);

requiredVCMFB_V = zeroCross(clVcmfb_V,clVoutcm_V,VOUT_CM_TARGET,VOUT_CM_TARGET);
valid = abs(clError_V) <= REG_ERROR_LIMIT & inRange(clVcmfb_V,VCMFB_LIMIT);
[validLow_V,validHigh_V] = validRange(clRef_V,valid,VOUT_CM_TARGET);

if ~isfinite(requiredVCMFB_V)
    warning('CMFB DC sweep never reaches VCMFB,IN target %.3f V.',VOUT_CM_TARGET);
end

if ~isfinite(validLow_V)
    warning('CMFB has no valid +/-%.1f mV regulation range around %.3f V.', ...
        REG_ERROR_LIMIT*1e3,VOUT_CM_TARGET);
end

figure;
plot(clRef_V,clVoutcm_V,'LineWidth',1.5); hold on;
plot(clRef_V,clIdeal_V,'--','LineWidth',1.2);
if isfinite(validLow_V)
    addCursor(validLow_V,interp1(clRef_V,clVoutcm_V,validLow_V,'linear'), ...
        sprintf('Lo: %.4g V',validLow_V));
    addCursor(validHigh_V,interp1(clRef_V,clVoutcm_V,validHigh_V,'linear'), ...
        sprintf('Hi: %.4g V',validHigh_V));
end
ylabel('VCMFB,IN (V)');
legend('VCMFB,IN','Ideal','Location','best');
stylePlot('VCMFB,REF (V)','CMFB Closed-Loop DC');
saveFig(plotDir,'NOM.cl_dc.png');

%% Closed-loop transient
D = numdata(fullfile(baseDir,'NOM.cl_tran.txt'));

time_s     = D(:,1);
trRef_V    = D(:,2);
trVoutcm_V = D(:,3);

[settlingLow_s,settlingHigh_s,tLow_s,tHigh_s] = settlingToNominal( ...
    time_s,trRef_V,trVoutcm_V,VOUT_CM_TARGET,SETTLE_ERROR);

vcmfbOutError_V = vcmfbOp_V-requiredVCMFB_V;

figure;
plot(time_s*1e6,trRef_V,'--','LineWidth',1.2); hold on;
plot(time_s*1e6,trVoutcm_V,'LineWidth',1.5);

yline(VOUT_CM_TARGET+SETTLE_ERROR,':','HandleVisibility','off');
yline(VOUT_CM_TARGET-SETTLE_ERROR,':','HandleVisibility','off');
addCursor(tLow_s*1e6,interp1(time_s*1e6,trVoutcm_V,tLow_s*1e6,'linear'), ...
    sprintf('tlow: %.4g ns',settlingLow_s*1e9));
addCursor(tHigh_s*1e6,interp1(time_s*1e6,trVoutcm_V,tHigh_s*1e6,'linear'), ...
    sprintf('thigh: %.4g ns',settlingHigh_s*1e9));

ylabel('VCMFB,IN (V)');
legend('Reference','VCMFB,IN','Location','best');
stylePlot('Time (us)','CMFB Closed-Loop Transient');
saveFig(plotDir,'NOM.cl_tran.png');


%% Summary table
rows = [
    "Set conditions",        "",      ""
    "AVDD",                  "V",     fmt(vdd_V)
    "Bias current",          "uA",    fmt(ibias_A*1e6)
    "CLoad per output",      "pF",    fmt(CLOAD_pF)
    "Vin,diff",              "V",     fmt(VIN_DIFF_V)
    "VCMFB,REF",             "V",     fmt(vcmRef_V)
    "Vout,cm target",        "V",     fmt(VOUT_CM_TARGET)
    "",                      "",      ""
    "Operating",             "",      ""
    "Total current",         "uA",    fmt(idd_A*1e6)
    "Total power",           "mW",    fmt(power_W*1e3)
    "VCMFB,OUT",             "V",     fmt(vcmfbOp_V)
    "VCMFB,IN",              "V",     fmt(voutcm_V)
    "VCMFB,OUT target",      "V",     fmt(requiredVCMFB_V)
    "",                      "",      ""
    "Open-loop",             "",      ""
    "DC gain",               "dB",    fmt(dcGain_dB)
    "UGF",                   "MHz",   fmt(ugf_Hz/1e6)
    "PM",                    "deg",   fmt(pm_deg)
    "",                      "",      ""
    "Closed-loop",           "",      ""
    "VCMFB,OUT err",         "mV",    fmt(vcmfbOutError_V*1e3)
    "VCMFB,IN err",          "mV",    fmt(opError_V*1e3)
    "Valid VCMFB,REF",       "V",     string(sprintf("%.6g-%.6g",validLow_V,validHigh_V))
    "tsettle low",           "ns",    fmt(settlingLow_s*1e9)
    "tsettle high",          "ns",    fmt(settlingHigh_s*1e9)
];

Result = table(rows(:,1),rows(:,2),rows(:,3), ...
    'VariableNames',{'Parameter','Unit','Value'});
disp(Result);
writetable(Result,fullfile(scriptDir,'NOM.CMFB_summary.csv'));

if idd_A < 1e-6
    warning('CMFB IDD is %.3g A. This is far below the expected bias current.',idd_A);
end

if abs(voutcm_V - VOUT_CM_TARGET) > REG_ERROR_LIMIT
    warning('CMFB operating VCMFB,IN is %.3f V, not near %.3f V.', ...
        voutcm_V,VOUT_CM_TARGET);
end

%% Functions
function D = numdata(file)
    D = readmatrix(file,'FileType','text');
    D = D(any(isfinite(D),2),:);
    D = D(:,any(isfinite(D),1));
    if isempty(D), error('No numeric data found in %s',file); end
end

function [gain_dB,phase_deg,ugf_Hz,pm_deg,f3dB_Hz] = acMetrics(f_Hz,A)
    phase_deg = unwrap(angle(A))*180/pi;
    if abs(phase_deg(1)) > 90
        A = -A;
        phase_deg = unwrap(angle(A))*180/pi;
    end

    gain_dB = 20*log10(abs(A));
    f3dB_Hz = gainCrossing(f_Hz,gain_dB,gain_dB(1)-3);
    k = find(gain_dB(1:end-1) >= 0 & gain_dB(2:end) < 0,1);

    if isempty(k)
        ugf_Hz = NaN;
        pm_deg = NaN;
        return;
    end

    ugf_Hz = 10^interp1(gain_dB(k:k+1),log10(f_Hz(k:k+1)),0);
    phaseUGF_deg = interp1(log10(f_Hz(k:k+1)),phase_deg(k:k+1),log10(ugf_Hz));
    pm_deg = mod(180 + phaseUGF_deg,360);
end

function f0 = gainCrossing(f_Hz,gain_dB,target_dB)
    k = find(gain_dB(1:end-1) >= target_dB & gain_dB(2:end) < target_dB,1);

    if isempty(k)
        f0 = NaN;
    else
        f0 = 10^interp1(gain_dB(k:k+1),log10(f_Hz(k:k+1)),target_dB);
    end
end

function y0 = interpAtFreq(f_Hz,y,f0_Hz)
    if isfinite(f0_Hz)
        y0 = interp1(log10(f_Hz),y,log10(f0_Hz),'linear',NaN);
    else
        y0 = NaN;
    end
end

function addCursor(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    xline(x,':','HandleVisibility','off');
    plot(x,y,'o','MarkerFaceColor','r','MarkerEdgeColor','r', ...
        'MarkerSize',6,'HandleVisibility','off');
    text(x,y,labelText,'BackgroundColor','w','Color','k', ...
        'Margin',2,'VerticalAlignment','bottom', ...
        'HorizontalAlignment','left','Clipping','on');
end

function x0 = zeroCross(x,y,target,xPreferred)
    z = y-target;
    kAll = find(z(1:end-1).*z(2:end) <= 0);

    if nargin < 4, xPreferred = mean(x(isfinite(x))); end
    if isempty(kAll), x0 = NaN; return; end

    [~,iBest] = min(abs((x(kAll)+x(kAll+1))/2 - xPreferred));
    k = kAll(iBest);

    if z(k) == 0
        x0 = x(k);
    else
        x0 = interp1(z(k:k+1),x(k:k+1),0);
    end
end

function [xLow,xHigh] = validRange(x,valid,target)
    [~,k] = min(abs(x-target));

    if isempty(k) || ~valid(k)
        xLow = NaN;
        xHigh = NaN;
        return;
    end

    kLow = k;
    kHigh = k;
    while kLow > 1 && valid(kLow-1), kLow = kLow-1; end
    while kHigh < length(x) && valid(kHigh+1), kHigh = kHigh+1; end

    xLow = x(kLow);
    xHigh = x(kHigh);
end

function [tsLow,tsHigh,tLow,tHigh] = settlingToNominal(t,ref,y,target,tol)
    vLow = min(ref);
    vHigh = max(ref);

    lowMid = (vLow+target)/2;
    highMid = (vHigh+target)/2;

    % Low disturbance returning to nominal
    iLowReturn = find( ...
        ref(1:end-1) < lowMid & ...
        ref(2:end) >= lowMid,1)+1;

    % End of nominal hold before the high disturbance
    iHighStart = find( ...
        ref(1:end-1) <= target+tol & ...
        ref(2:end) > target+tol,1)+1;

    % High disturbance returning to nominal
    iHighReturn = find( ...
        ref(1:end-1) > highMid & ...
        ref(2:end) <= highMid,1)+1;

    if isempty(iLowReturn) || isempty(iHighStart)
        tsLow = NaN;
        tLow = NaN;
    else
        [tsLow,tLow] = localSettle( ...
            t,y,target,iLowReturn,iHighStart-1,tol);
    end

    if isempty(iHighReturn)
        tsHigh = NaN;
        tHigh = NaN;
    else
        [tsHigh,tHigh] = localSettle( ...
            t,y,target,iHighReturn,length(t),tol);
    end
end

function [ts,tSettle] = localSettle(t,y,target,k1,k2,tol)
    if isnan(k1) || isnan(k2) || k2 < k1
        ts = NaN;
        tSettle = NaN;
        return;
    end

    idx = k1:k2;
    err = abs(y(idx)-target);
    k = find(flip(cummax(flip(err))) <= tol,1);

    if isempty(k)
        ts = NaN;
        tSettle = NaN;
    else
        tSettle = t(idx(k));
        ts = tSettle-t(k1);
    end
end

function ok = inRange(x,lim)
    ok = x >= lim(1) & x <= lim(2);
end

function s = fmt(x)
    s = string(sprintf("%.6g",x));
end

function s = freqText(f_Hz)
    if ~isfinite(f_Hz)
        s = 'NaN';
    elseif f_Hz >= 1e6
        s = sprintf('%.4g MHz',f_Hz/1e6);
    elseif f_Hz >= 1e3
        s = sprintf('%.4g kHz',f_Hz/1e3);
    else
        s = sprintf('%.4g Hz',f_Hz);
    end
end

function stylePlot(xLabelText,titleText)
    xlabel(xLabelText);
    title(titleText);
    grid on;
end

function saveFig(plotDir,fileName)
    exportgraphics(gcf,fullfile(plotDir,fileName),'Resolution',300);
end
