% AFE nominal analysis
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~exist(plotDir,'dir'), mkdir(plotDir); end

TAG = "NOM";
PGA = 1;
EXPECTED_GAIN_VV = 240*2^PGA;
MARK_FREQ_HZ = [0.05 150];
REJECTION_MARK_HZ = [0.05 60 150 1e3];
NOISE_BAND_HZ = [0.05 150];
AC_RANGE_HZ = [0.01 1e4];
OFFSET_ORDER_MV = [500 300 0 -300 -500];

%% Operating point
op = lastRow(readCols(fullfile(baseDir,TAG + ".op.txt"),15));
vdd_V = op(2);
voutCmDC_V = op(11);
voutDiffDC_mV = op(12)*1e3;
vref_V = op(13);
idd_A = abs(op(15));
power_W = vdd_V*idd_A;

%% Differential AC transfer
ac = readCols(fullfile(baseDir,TAG + ".diff_ac.txt"),7);
f_Hz = ac(:,1);
vinDiff = ac(:,2) + 1j*ac(:,3);
voutDiff = ac(:,4) + 1j*ac(:,5);
Hdiff = voutDiff ./ vinDiff;
[gain_dB,phase_deg,f1dB_Hz,f3dB_Hz] = acTransferMetrics(f_Hz,Hdiff);
gain_VV = abs(Hdiff(1));
expectedGain_dB = 20*log10(EXPECTED_GAIN_VV);
gainError_pct = (gain_dB(1)/expectedGain_dB - 1)*100;
gainAt_dB = interpAtFreq(f_Hz,gain_dB,MARK_FREQ_HZ);
gainFlatness_dB = bandRange(f_Hz,gain_dB,MARK_FREQ_HZ);

%% Rejection AC transfer
cmrr = rejectionTransfer(readCols(fullfile(baseDir,TAG + ".cmrr_ac.txt"),7),f_Hz,Hdiff);
psrrp = rejectionTransfer(readCols(fullfile(baseDir,TAG + ".psrrp_ac.txt"),7),f_Hz,Hdiff);
psrrn = rejectionTransfer(readCols(fullfile(baseDir,TAG + ".psrrn_ac.txt"),7),f_Hz,Hdiff);
cmrrAt_dB = interpAtFreq(cmrr.f_Hz,cmrr.dB,REJECTION_MARK_HZ);
psrrPAt_dB = interpAtFreq(psrrp.f_Hz,psrrp.dB,REJECTION_MARK_HZ);
psrrNAt_dB = interpAtFreq(psrrn.f_Hz,psrrn.dB,REJECTION_MARK_HZ);

%% Input-referred noise
[fNoise_Hz,inNoise_VrtHz] = readInputNoise(baseDir,TAG,f_Hz,Hdiff);
inputNoise_Vrms = integrateNoise(fNoise_Hz,inNoise_VrtHz,NOISE_BAND_HZ);

%% Offset transients
cmTests = readTranTests(baseDir,TAG,"vcmdcoffset");
diffTests = readTranTests(baseDir,TAG,"vdiffdcoffset");

voutDiffAbsNoOffset_V = [
    diffAbsAt(cmTests,0,0.5), ...
    diffAbsAt(cmTests,0,5)]/1e3;
voutDiffPpNoOffset_V = [
    diffPpAt(cmTests,0,0.5), ...
    diffPpAt(cmTests,0,5)]/1e3;

%% Plots
figure;
yyaxis left;
semilogx(f_Hz,gain_dB,'LineWidth',1.5); hold on;
yline(maxFinite(gain_dB)-1,'--','-1dB','HandleVisibility','off');
yline(maxFinite(gain_dB)-3,'--','-3dB','HandleVisibility','off');
addFreqCursor(f1dB_Hz,sprintf('LP -1dB: %s',freqText(f1dB_Hz)));
addFreqCursor(f3dB_Hz,sprintf('LP -3dB: %s',freqText(f3dB_Hz)));
labelFreqPoints(f_Hz,gain_dB,MARK_FREQ_HZ,'dB');
ylabel('Differential gain (dB)');

yyaxis right;
semilogx(f_Hz,phase_deg,'LineWidth',1.5);
ylabel('Differential phase (deg)');
stylePlot('Frequency (Hz)','AFE Differential AC Response');
xlim(AC_RANGE_HZ);
saveFig(plotDir,'NOM.diff_ac_response.png');

plotNoise(fNoise_Hz,inNoise_VrtHz,NOISE_BAND_HZ,plotDir);

plotRejection(cmrr,'CMRR (dB)','AFE CMRR','NOM.cmrr.png',plotDir);
plotPsrr(psrrp,psrrn,plotDir);

if ~isempty(cmTests)
    plotOffsetPairAtEcg(cmTests,0.5,OFFSET_ORDER_MV,plotDir, ...
        'AFE VCM DC Offset, Vin,diff = 0.5 mV', ...
        'cm,os', ...
        'NOM.vcmdcoffset_vdiff0p5m.png');
    plotOffsetPairAtEcg(cmTests,5,OFFSET_ORDER_MV,plotDir, ...
        'AFE VCM DC Offset, Vin,diff = 5 mV', ...
        'cm,os', ...
        'NOM.vcmdcoffset_vdiff5m.png');
end

if ~isempty(diffTests)
    plotOffsetPairAtEcg(diffTests,0.5,OFFSET_ORDER_MV,plotDir, ...
        'AFE VDIFF DC Offset, Vin,diff = 0.5 mV', ...
        'diff,os', ...
        'NOM.vdiffdcoffset_vdiff0p5m.png');
    plotOffsetPairAtEcg(diffTests,5,OFFSET_ORDER_MV,plotDir, ...
        'AFE VDIFF DC Offset, Vin,diff = 5 mV', ...
        'diff,os', ...
        'NOM.vdiffdcoffset_vdiff5m.png');
end

%% Summary table
rows = [
    "Total current",                 "mA",   fmt(idd_A*1e3)
    "Total power",                   "mW",   fmt(power_W*1e3)
    "Output common mode",            "V",    fmt(voutCmDC_V)
    "Output common-mode error",      "mV",   fmt((voutCmDC_V-vref_V)*1e3)
    "Output differential DC",        "mV",   fmt(voutDiffDC_mV)
    "Expected gain",                 "V/V",  fmt(EXPECTED_GAIN_VV)
    "Expected gain",                 "dB",   fmt(expectedGain_dB)
    "Differential gain",             "V/V",  fmt(gain_VV)
    "Differential gain",             "dB",   fmt(gain_dB(1))
    "Gain error",                    "%",    fmt(gainError_pct)
    "LP -1dB corner",                "Hz",   fmt(f1dB_Hz)
    "LP -3dB corner",                "Hz",   fmt(f3dB_Hz)
    "Gain at 0.05 Hz",               "dB",   fmt(gainAt_dB(1))
    "Gain at 150 Hz",                "dB",   fmt(gainAt_dB(2))
    "Gain flatness 0.05-150 Hz",     "dB",   fmt(gainFlatness_dB)
    "CMRR @ 0.05 Hz",                "dB",   fmt(cmrrAt_dB(1))
    "CMRR @ 60 Hz",                  "dB",   fmt(cmrrAt_dB(2))
    "CMRR @ 150 Hz",                 "dB",   fmt(cmrrAt_dB(3))
    "CMRR @ 1 kHz",                  "dB",   fmt(cmrrAt_dB(4))
    "PSRR+ @ 0.05 Hz",               "dB",   fmt(psrrPAt_dB(1))
    "PSRR+ @ 60 Hz",                 "dB",   fmt(psrrPAt_dB(2))
    "PSRR+ @ 150 Hz",                "dB",   fmt(psrrPAt_dB(3))
    "PSRR+ @ 1 kHz",                 "dB",   fmt(psrrPAt_dB(4))
    "PSRR- @ 0.05 Hz",               "dB",   fmt(psrrNAt_dB(1))
    "PSRR- @ 60 Hz",                 "dB",   fmt(psrrNAt_dB(2))
    "PSRR- @ 150 Hz",                "dB",   fmt(psrrNAt_dB(3))
    "PSRR- @ 1 kHz",                 "dB",   fmt(psrrNAt_dB(4))
    "Input-referred noise",          "uVrms",fmt(inputNoise_Vrms*1e6)
    "Vout,diff 0.5m",                "V",    fmt(voutDiffAbsNoOffset_V(1))
    "Vout,diff 5m",                  "V",    fmt(voutDiffAbsNoOffset_V(2))
    "Vout,diff p-p 0.5m",            "V",    fmt(voutDiffPpNoOffset_V(1))
    "Vout,diff p-p 5m",              "V",    fmt(voutDiffPpNoOffset_V(2))
];

summary = array2table(rows,'VariableNames',{'Parameter','Unit','Value'});
disp(summary);
writetable(summary,fullfile(scriptDir,'AFE_summary.csv'));

%% Local functions
function data = readCols(file,n)
    if ~isfile(file), error('Missing file: %s',file); end
    data = readmatrix(file,'FileType','text');
    data = data(:,1:min(n,size(data,2)));
    data = data(all(isfinite(data),2),:);
end

function row = lastRow(data)
    if isempty(data), row = NaN(1,size(data,2)); else, row = data(end,:); end
end

function y = diffAbsAt(tests,offset_mV,ecg_mV)
    y = NaN;
    if isempty(tests), return; end
    idx = find(abs([tests.offset_mV]-offset_mV) < 1e-9 & abs([tests.ecg_mV]-ecg_mV) < 1e-9,1,'first');
    if ~isempty(idx), y = maxAbsFinite(tests(idx).voutDiff_mV); end
end

function y = diffPpAt(tests,offset_mV,ecg_mV)
    y = NaN;
    if isempty(tests), return; end
    idx = find(abs([tests.offset_mV]-offset_mV) < 1e-9 & abs([tests.ecg_mV]-ecg_mV) < 1e-9,1,'first');
    if ~isempty(idx), y = rangeFinite(tests(idx).voutDiff_mV); end
end

function y = maxAbsFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(abs(x)); end
end

function y = rangeFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(x) - min(x); end
end

function y = bandRange(f,x,band)
    inBand = f >= band(1) & f <= band(2) & isfinite(x);
    if ~any(inBand), y = NaN; else, y = max(x(inBand)) - min(x(inBand)); end
end

function tests = readTranTests(baseDir,tag,testName)
    files = dir(fullfile(baseDir,char(tag + ".tran_" + testName + "_*.txt")));
    tests = struct('offset_mV',{},'ecg_mV',{}, ...
        'finalDiff_mV',{},'finalCmErr_mV',{}, ...
        't_s',{},'vinCm_V',{},'vinDiff_mV',{},'voutDiff_mV',{},'voutCm_V',{});
    for k = 1:numel(files)
        tok = regexp(files(k).name,'tran_[^_]+_([pn]?)(\d+)(?:m)?_(\d+(?:p\d+)?)m','tokens','once');
        if isempty(tok), continue; end
        d = readCols(fullfile(files(k).folder,files(k).name),12);
        offset_mV = str2double(tok{2});
        if offset_mV == 0
            offset_mV = 0;
        elseif strcmp(tok{1},'n')
            offset_mV = -offset_mV;
        end
        ecg_mV = str2double(strrep(tok{3},'p','.'));
        tests(end+1) = struct( ...
            'offset_mV',offset_mV, ...
            'ecg_mV',ecg_mV, ...
            'finalDiff_mV',tailMean(d(:,11))*1e3, ...
            'finalCmErr_mV',tailMean(d(:,10)-d(:,4))*1e3, ...
            't_s',d(:,1), ...
            'vinCm_V',d(:,4), ...
            'vinDiff_mV',(d(:,6)-d(:,7))*1e3, ...
            'voutDiff_mV',d(:,11)*1e3, ...
            'voutCm_V',d(:,10)); %#ok<AGROW>
    end
end

function [gain_dB,phase_deg,f1dB_Hz,f3dB_Hz] = acTransferMetrics(f_Hz,H)
    gain_dB = 20*log10(abs(H));
    phase_deg = unwrap(angle(H))*180/pi;
    maxGain_dB = maxFinite(gain_dB);
    f1dB_Hz = lowPassCrossing(f_Hz,gain_dB,maxGain_dB - 1);
    f3dB_Hz = lowPassCrossing(f_Hz,gain_dB,maxGain_dB - 3);
end

function r = rejectionTransfer(d,fDiff_Hz,Hdiff)
    r.f_Hz = d(:,1);
    input = d(:,2) + 1j*d(:,3);
    voutDiff = d(:,4) + 1j*d(:,5);
    hBad = voutDiff ./ input;
    hDiffAtF = interpComplexAtFreq(fDiff_Hz,Hdiff,r.f_Hz);
    r.dB = 20*log10(abs(hDiffAtF ./ hBad));
end

function f0 = lowPassCrossing(f,x,target)
    f0 = NaN;
    ok = isfinite(f) & isfinite(x);
    f = f(ok); x = x(ok);
    if numel(f) < 2, return; end
    [~,pk] = max(x);
    idxRel = find(x(pk:end-1) >= target & x(pk+1:end) <= target,1,'first');
    if ~isempty(idxRel)
        idx = pk + idxRel - 1;
        f0 = 10.^interp1(x(idx:idx+1),log10(f(idx:idx+1)),target,'linear','extrap');
    end
end

function y = interpAtFreq(f,x,f0)
    f = f(:); x = x(:);
    if numel(f0) > 1
        y = arrayfun(@(ff) interpAtFreq(f,x,ff),f0);
        return;
    end
    ok = isfinite(f) & isfinite(x);
    if ~any(ok) || ~isfinite(f0)
        y = NaN;
    else
        y = interp1(log10(f(ok)),x(ok),log10(f0),'linear','extrap');
    end
end

function y = interpComplexAtFreq(f,x,f0)
    y = interpAtFreq(f,real(x),f0) + 1j*interpAtFreq(f,imag(x),f0);
end

function y = tailMean(x)
    n = max(1,ceil(0.1*numel(x)));
    x = x(end-n+1:end);
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = mean(x); end
end

function y = maxFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(x); end
end

function [f_Hz,inNoise] = readInputNoise(baseDir,tag,fGain_Hz,Hdiff)
    outpFile = fullfile(baseDir,tag + ".noise_outp.txt");
    outnFile = fullfile(baseDir,tag + ".noise_outn.txt");
    if ~isfile(outpFile)
        warning('AFE noise txt missing.');
        f_Hz = NaN;
        inNoise = NaN;
        return;
    end
    outp = readCols(outpFile,2);
    f_Hz = outp(:,1);
    noiseOutp = abs(outp(:,2));
    noiseOutn = zeros(size(noiseOutp));
    if isfile(outnFile)
        outn = readCols(outnFile,2);
        noiseOutn = interpAtFreq(outn(:,1),abs(outn(:,2)),f_Hz);
    end
    outNoise = sqrt(noiseOutp.^2 + noiseOutn.^2);
    inNoise = outNoise ./ interpAtFreq(fGain_Hz,abs(Hdiff),f_Hz);
end

function plotNoise(f_Hz,inNoise,band_Hz,plotDir)
    ok = f_Hz >= band_Hz(1) & f_Hz <= band_Hz(2) & isfinite(inNoise) & inNoise > 0;
    if ~any(ok), return; end
    figure;
    loglog(f_Hz(ok),inNoise(ok)*1e9,'LineWidth',1.5); hold on;
    for f0 = [band_Hz(1) 60 band_Hz(2)]
        y0 = interpAtFreq(f_Hz,inNoise,f0)*1e9;
        addCursor(f0,y0,sprintf('%s: %.4g nV/rtHz',freqText(f0),y0));
    end
    xlim(band_Hz);
    ylabel('Input noise (nV/sqrtHz)');
    stylePlot('Frequency (Hz)','AFE Input-Referred Noise Density versus Frequency');
    saveFig(plotDir,'NOM.input_referred_noise_density.png');
end

function vn = integrateNoise(f,en,band)
    ok = isfinite(f) & isfinite(en) & f > 0 & en >= 0;
    f = f(ok);
    en = en(ok);
    if numel(f) < 2
        vn = NaN;
        return;
    end
    [f,idx] = sort(f);
    en = en(idx);
    fb = unique([band(:); f(f > band(1) & f < band(2))]);
    if numel(fb) < 2
        vn = NaN;
    else
        eb = interpAtFreq(f,en,fb);
        vn = sqrt(trapz(fb,eb.^2));
    end
end

function plotRejection(r,yText,titleText,fileName,plotDir)
    figure;
    semilogx(r.f_Hz,r.dB,'LineWidth',1.5); hold on;
    labelFreqSet(r.f_Hz,r.dB,[0.05 60 150], 'dB');
    xlim([0.01 1e9]);
    ylabel(yText);
    stylePlot('Frequency (Hz)',titleText);
    saveFig(plotDir,fileName);
end

function plotPsrr(psrrp,psrrn,plotDir)
    figure;
    tiledlayout(2,1,'TileSpacing','compact');
    nexttile;
    semilogx(psrrp.f_Hz,psrrp.dB,'LineWidth',1.5); hold on;
    labelFreqSet(psrrp.f_Hz,psrrp.dB,[0.05 60 150], 'dB');
    xlim([0.01 1e9]);
    ylabel('PSRR+ (dB)');
    title('AFE PSRR+');
    grid on;
    nexttile;
    semilogx(psrrn.f_Hz,psrrn.dB,'LineWidth',1.5); hold on;
    labelFreqSet(psrrn.f_Hz,psrrn.dB,[0.05 60 150], 'dB');
    xlim([0.01 1e9]);
    ylabel('PSRR- (dB)');
    stylePlot('Frequency (Hz)','AFE PSRR-');
    saveFig(plotDir,'NOM.psrr.png');
end

function plotOffsetPairAtEcg(tests,ecg_mV,offsetOrder_mV,plotDir,titleText,offsetName,fileName)
    figure;
    tiledlayout(2,1,'TileSpacing','compact');
    plotOffsetCmpane(tests,ecg_mV,offsetOrder_mV,offsetName);
    title(titleText);
    plotOffsetDiffPane(tests,ecg_mV,offsetOrder_mV,offsetName);
    xlabel('Time (s)');
    saveFig(plotDir,fileName);
end

function plotOffsetCmpane(tests,ecg_mV,offsetOrder_mV,offsetName)
    nexttile;
    hold on;
    for off = offsetOrder_mV
        idx = find(abs([tests.ecg_mV] - ecg_mV) < 1e-9 & [tests.offset_mV] == off,1,'first');
        if isempty(idx), continue; end
        plot(tests(idx).t_s,tests(idx).vinCm_V,':','LineWidth',1.0, ...
            'DisplayName',sprintf('VIN,CM %s %+.0f mV',offsetName,off));
        plot(tests(idx).t_s,tests(idx).voutCm_V,'-','LineWidth',1.2, ...
            'DisplayName',sprintf('VOUT,CM %s %+.0f mV',offsetName,off));
    end
    ylabel('Voltage (V)');
    grid on;
    legend('Location','bestoutside');
end

function plotOffsetDiffPane(tests,ecg_mV,offsetOrder_mV,offsetName)
    nexttile;
    yyaxis left;
    hold on;
    for off = offsetOrder_mV
        idx = find(abs([tests.ecg_mV] - ecg_mV) < 1e-9 & [tests.offset_mV] == off,1,'first');
        if isempty(idx), continue; end
        plot(tests(idx).t_s,tests(idx).vinDiff_mV,':','LineWidth',1.0, ...
            'DisplayName',sprintf('VIN %s %+.0f mV',offsetName,off));
    end
    ylabel('VIN,diff (mV)');
    yyaxis right;
    hold on;
    for off = offsetOrder_mV
        idx = find(abs([tests.ecg_mV] - ecg_mV) < 1e-9 & [tests.offset_mV] == off,1,'first');
        if isempty(idx), continue; end
        plot(tests(idx).t_s,tests(idx).voutDiff_mV/1e3,'-','LineWidth',1.2, ...
            'DisplayName',sprintf('VOUT,diff %s %+.0f mV',offsetName,off));
    end
    ylabel('VOUT,diff (V)');
    grid on;
    legend('Location','bestoutside');
end

function labelFreqSet(f,x,freqs,unitText)
    for f0 = freqs
        y0 = interpAtFreq(f,x,f0);
        addFreqCursor(f0,sprintf('%s: %.4g %s',freqText(f0),y0,unitText));
    end
end

function labelFreqPoints(f,x,freqs,unitText)
    for f0 = freqs
        y0 = interpAtFreq(f,x,f0);
        addCursor(f0,y0,sprintf('%s: %.4g %s',freqText(f0),y0,unitText));
    end
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

function addFreqCursor(x,labelText)
    if ~isfinite(x), return; end
    xline(x,':'," " + string(labelText),'HandleVisibility','off', ...
        'LabelVerticalAlignment','middle','LabelHorizontalAlignment','left');
end

function stylePlot(xText,titleText)
    grid on;
    if strlength(string(xText)) > 0, xlabel(xText); end
    if strlength(string(titleText)) > 0, title(titleText); end
end

function saveFig(plotDir,fileName)
    saveas(gcf,fullfile(plotDir,fileName));
end

function s = fmt(x)
    if ~isfinite(x), s = "NaN"; else, s = string(sprintf('%.6g',x)); end
end

function s = freqText(f)
    if ~isfinite(f)
        s = 'NaN';
    elseif f >= 1e6
        s = sprintf('%.4g MHz',f/1e6);
    elseif f >= 1e3
        s = sprintf('%.4g kHz',f/1e3);
    else
        s = sprintf('%.4g Hz',f);
    end
end
