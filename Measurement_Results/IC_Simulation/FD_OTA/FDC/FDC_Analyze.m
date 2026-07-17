% FDC nominal analysis
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~exist(plotDir,'dir'), mkdir(plotDir); end

VOUT_CM_TARGET = 1.65;
VIN_CM_V = 1.65;
CLOAD_PER_OUTPUT_pF = 10;
VOUT_LIMIT = [0.3 3.0];
NOISE_BAND_HZ = [1 150];
NOISE_MARK_HZ = [1 60 150];
VCMFB_WARN_ERROR = 0.5;

%% Operating point
op = numdata(fullfile(baseDir,'NOM.ol_op.txt'));
op = op(end,end-11:end);

vdd_V      = op(1);
voutp_V    = op(5);
voutn_V    = op(6);
voutcm_V   = op(7);
voutdiff_V = op(8);
ibias_A    = op(9);
idd_A      = op(10);
power_W    = op(11);

%% Differential open-loop gain
D = numdata(fullfile(baseDir,'NOM.ol_diff_ac.txt'));
f_Hz = D(:,1);
Ad = D(:,2) + 1j*D(:,3);
[gain_dB,phase_deg,ugf_Hz,pm_deg,f3dB_Hz] = acMetrics(f_Hz,Ad);
dcGain_dB = gain_dB(1);

figure;
yyaxis left;

semilogx(f_Hz,gain_dB,'LineWidth',1.5); hold on;
yline(0,'--');
addCursor(f3dB_Hz,dcGain_dB-3,sprintf('-3dB: %s',freqText(f3dB_Hz)));
addCursor(ugf_Hz,0,sprintf('UGF: %s',freqText(ugf_Hz)));
ylabel('Differential gain (dB)');

yyaxis right;
semilogx(f_Hz,phase_deg,'LineWidth',1.5); hold on;
phaseUGF_deg = interpAtFreq(f_Hz,phase_deg,ugf_Hz);
addCursor(ugf_Hz,phaseUGF_deg,sprintf('PM: %.4g deg',pm_deg));
ylabel('Differential phase (deg)');
stylePlot('Frequency (Hz)','FDC Differential Open-Loop Response');
saveFig(plotDir,'NOM.diff_ac.png');

%% Input offset
D = numdata(fullfile(baseDir,'NOM.ol_offset.txt'));
vinDiff_V = D(:,1);
voutDiff_V = D(:,7);
offset_V = zeroCross(vinDiff_V,voutDiff_V,0);

figure;
plot(vinDiff_V*1e3,voutDiff_V,'LineWidth',1.5); hold on;
yline(0,'--');
addCursor(offset_V*1e3,0,sprintf('Vos: %.4g mV',offset_V*1e3));
ylabel('Differential output (V)');
stylePlot('Differential input (mV)','FDC Input Offset');
saveFig(plotDir,'NOM.offset.png');

%% Input-referred noise, 1 Hz to 150 Hz
D = numdata(fullfile(baseDir,'NOM.ol_noise.txt'));
noiseFreq_Hz = D(:,1);
inputNoise_VrtHz = D(:,2);
noiseBand = noiseFreq_Hz >= NOISE_BAND_HZ(1) & noiseFreq_Hz <= NOISE_BAND_HZ(2);
inputNoise_Vrms = integrateNoiseBand(noiseFreq_Hz,inputNoise_VrtHz,NOISE_BAND_HZ);

figure;
loglog(noiseFreq_Hz(noiseBand),inputNoise_VrtHz(noiseBand)*1e9,'LineWidth',1.5);
xline(NOISE_BAND_HZ(1),'--'); xline(NOISE_BAND_HZ(2),'--');
hold on;
for fMark_Hz = NOISE_MARK_HZ
    nMark_nV = interp1(noiseFreq_Hz,inputNoise_VrtHz,fMark_Hz,'linear',NaN)*1e9;
    addCursor(fMark_Hz,nMark_nV,sprintf('%s: %.4g nV/rtHz',freqText(fMark_Hz),nMark_nV));
end
ylabel('Input noise (nV/\surdHz)');
stylePlot('Frequency (Hz)','FDC Input-Referred Noise, 1 Hz to 150 Hz');
saveFig(plotDir,'NOM.noise.png');

%% Output voltages versus VCMFB
D = numdata(fullfile(baseDir,'NOM.vcmfb_sweep.txt'));
vcmfb_V = D(:,1);
voutpSweep_V = D(:,2);
voutnSweep_V = D(:,3);
voutcmSweep_V = D(:,4);
voutdiffSweep_V = D(:,5);

requiredVCMFB_V = nearestTarget(vcmfb_V,voutcmSweep_V,VOUT_CM_TARGET);
requiredVCMFBErr_V = interp1(vcmfb_V,voutcmSweep_V,requiredVCMFB_V,'linear') - VOUT_CM_TARGET;
valid = inRange(voutpSweep_V,VOUT_LIMIT) & inRange(voutnSweep_V,VOUT_LIMIT);

if abs(requiredVCMFBErr_V) >= VCMFB_WARN_ERROR
    warning('FDC Required VCMFB is approximate: VOUT,CM error = %.6g V.', ...
        requiredVCMFBErr_V);
end



figure;
yyaxis left;
plot(vcmfb_V,voutcmSweep_V,'LineWidth',1.4);
hold on; yline(VOUT_CM_TARGET,'--');
ylabel('VOUT,CM (V)');

yyaxis right;
plot(vcmfb_V,voutdiffSweep_V,'LineWidth',1.4);
ylabel('Differential output (V)');

if isfinite(requiredVCMFB_V)
    yyaxis left;
    voutcmAtVCMFB_V = interp1(vcmfb_V,voutcmSweep_V,requiredVCMFB_V,'linear',NaN);
    addCursor(requiredVCMFB_V,voutcmAtVCMFB_V,sprintf('VCMFB: %.4g V',requiredVCMFB_V));
end
if any(valid)
    validVCMFB_V = vcmfb_V(valid);
    xline(min(validVCMFB_V),':'); xline(max(validVCMFB_V),':');
end

legend('VOUT,CM','Target VOUT,CM','VOUT,diff','Location','best');
stylePlot('VCMFB (V)','FDC Outputs versus VCMFB');
saveFig(plotDir,'NOM.vcmfb_sweep.png');

%% Plant gain at 1 Hz
D = numdata(fullfile(baseDir,'NOM.plant_ac.txt'));
plantFreq_Hz = D(:,1);
Aplant = D(:,2) + 1j*D(:,3);
plantGain1Hz_VV = abs(interpAtFreq(plantFreq_Hz,Aplant,1));

%% Summary table
rows = [
    "Set conditions",        "",      ""
    "AVDD",                  "V",     fmt(vdd_V)
    "Bias current",          "uA",    fmt(ibias_A*1e6)
    "CLoad per output",      "pF",    fmt(CLOAD_PER_OUTPUT_pF)
    "Vin,cm",                "V",     fmt(VIN_CM_V)
    "Vout,cm target",        "V",     fmt(VOUT_CM_TARGET)
    "",                      "",      ""
    "Operating",             "",      ""
    "Total current",         "uA",    fmt(idd_A*1e6)
    "Total power",           "mW",    fmt(power_W*1e3)
    "VOUTP,DC",              "V",     fmt(voutp_V)
    "VOUTN,DC",              "V",     fmt(voutn_V)
    "VOUT,CM",               "V",     fmt(voutcm_V)
    "VOUT,diff,DC",          "V",     fmt(voutdiff_V)
    "Required VCMFB",        "V",     fmt(requiredVCMFB_V)
    "",                      "",      ""
    "Open-loop",             "",      ""
    "Differential DC gain",  "dB",    fmt(dcGain_dB)
    "Differential UGF",      "MHz",   fmt(ugf_Hz/1e6)
    "Differential PM",       "deg",   fmt(pm_deg)
    "Plant gain",            "V/V",   fmt(plantGain1Hz_VV)
    "",                      "",      ""
    "Noise/Offset",          "",      ""
    "Input offset",          "mV",    fmt(offset_V*1e3)
    "Input noise, 1-150 Hz", "uVrms", fmt(inputNoise_Vrms*1e6)
];

Result = table(rows(:,1),rows(:,2),rows(:,3), ...
    'VariableNames',{'Parameter','Unit','Value'});
disp(Result);
writetable(Result,fullfile(scriptDir,'NOM.FDC_summary.csv'));

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
    pm_deg = 180 + phaseUGF_deg;
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

function x0 = zeroCross(x,y,target)
    z = y-target;
    k = find(z(1:end-1).*z(2:end) <= 0,1);

    if isempty(k)
        x0 = NaN;
    elseif z(k) == 0
        x0 = x(k);
    else
        x0 = interp1(z(k:k+1),x(k:k+1),0);
    end
end

function x0 = nearestTarget(x,y,target)
    [~,k] = min(abs(y-target));
    x0 = x(k);
end

function noiseRms = integrateNoiseBand(freq_Hz,noise_VrtHz,band_Hz)
    inBand = freq_Hz >= band_Hz(1) & freq_Hz <= band_Hz(2);

    if nnz(inBand) < 2
        noiseRms = NaN;
        return;
    end

    f = [band_Hz(1); freq_Hz(inBand); band_Hz(2)];
    n = [ ...
        interp1(freq_Hz,noise_VrtHz,band_Hz(1),'linear')
        noise_VrtHz(inBand)
        interp1(freq_Hz,noise_VrtHz,band_Hz(2),'linear')
    ];
    [f,idx] = unique(f);
    n = n(idx);
    noiseRms = sqrt(trapz(f,n.^2));
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
