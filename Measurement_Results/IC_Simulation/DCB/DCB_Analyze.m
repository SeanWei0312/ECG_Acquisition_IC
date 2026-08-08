% DCB nominal analysis
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');
plotDir = fullfile(scriptDir,'Plots');
if ~exist(plotDir,'dir'), mkdir(plotDir); end

TAG = "NOM";
MARK_FREQ_HZ = [0.05 150];

%% Operating point
op = lastRow(readCols(fullfile(baseDir,TAG + ".op.txt"),11));
voutCmDC_V = op(7);
vref_V = op(9);
idd_A = abs(op(10));

%% AC transfer
diffAc = readCols(fullfile(baseDir,TAG + ".diff_ac.txt"),7);
fDiff_Hz = diffAc(:,1);
vinDiff = diffAc(:,2) + 1j*diffAc(:,3);
voutDiff = diffAc(:,4) + 1j*diffAc(:,5);
Hdiff = voutDiff ./ vinDiff;
[diffGain_dB,diffPhase_deg,diffF3dB_Hz] = acTransferMetrics(fDiff_Hz,Hdiff);
diffGainAt_dB = interpAtFreq(fDiff_Hz,diffGain_dB,MARK_FREQ_HZ);

pathP = readPathAc(fullfile(baseDir,TAG + ".pathp_ac.txt"));
pathN = readPathAc(fullfile(baseDir,TAG + ".pathn_ac.txt"));
pathP150 = abs(interpAtFreq(pathP.f_Hz,pathP.H,150));
pathN150 = abs(interpAtFreq(pathN.f_Hz,pathN.H,150));
diffGainError_pct = 100*abs(pathP150-pathN150)/mean([pathP150 pathN150]);

%% Offset transients
offsetTests = readOffsetTests(baseDir,TAG);
if isempty(offsetTests)
    maxOffsetBlocked_V = NaN;
else
    maxOffsetBlocked_V = maxAbs([offsetTests.offset_mV])/1e3;
end

%% Plots
figure;
yyaxis left;
semilogx(fDiff_Hz,diffGain_dB,'LineWidth',1.5); hold on;
yline(maxFinite(diffGain_dB)-3,'--','-3dB','HandleVisibility','off');
addFreqCursor(diffF3dB_Hz,sprintf('-3dB: %s',freqText(diffF3dB_Hz)));
labelFreqSet(fDiff_Hz,diffGain_dB,[0.05 150],'dB');
ylabel('Gain (dB)');

yyaxis right;
semilogx(fDiff_Hz,diffPhase_deg,'LineWidth',1.5);
ylabel('Phase (deg)');
xlim([1e-4 1e4]);
stylePlot('Frequency (Hz)','DCB Differential AC Response');
saveFig(plotDir,'NOM.diff_ac_transfer.png');

if ~isempty(offsetTests)
    plotDcInputOutput(offsetTests,plotDir);
    plotOffsetTransient(offsetTests,plotDir);
    plotOffsetCommonMode(offsetTests,plotDir);
end

%% Summary table
rows = [
    "Total current",                "nA",   fmt(idd_A*1e9)
    "Output common mode",           "V",    fmt(voutCmDC_V)
    "Output common-mode error",     "mV",   fmt((voutCmDC_V-vref_V)*1e3)
    "High-pass corner",             "Hz",   fmt(diffF3dB_Hz)
    "Gain at 0.05 Hz",              "dB",   fmt(diffGainAt_dB(1))
    "Gain at 150 Hz",               "dB",   fmt(diffGainAt_dB(2))
    "Differential gain error",      "%",    fmt(diffGainError_pct)
    "Maximum input DC offset blocked","V",   fmt(maxOffsetBlocked_V)
];

summary = array2table(rows,'VariableNames',{'Parameter','Unit','Value'});
disp(summary);
writetable(summary,fullfile(scriptDir,'DCB_summary.csv'));

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

function path = readPathAc(file)
    d = readCols(file,5);
    vin = d(:,2) + 1j*d(:,3);
    out = d(:,4) + 1j*d(:,5);
    H = out ./ vin;
    path.f_Hz = d(:,1);
    path.H = H;
    path.gain_dB = 20*log10(abs(H));
    path.phase_deg = unwrap(angle(H))*180/pi;
end

function tr = readTran(file)
    d = readCols(file,11);
    tr.t_s = d(:,1);
    tr.vinp_V = d(:,2);
    tr.vinn_V = d(:,3);
    tr.vinDiff_V = d(:,4);
    tr.voutp_V = d(:,5);
    tr.voutn_V = d(:,6);
    tr.voutcm_V = d(:,7);
    tr.voutdiff_V = d(:,8);
    tr.vref_V = d(:,9);
    tr.idd_A = abs(d(:,10));
end

function tests = readOffsetTests(baseDir,tag)
    files = dir(fullfile(baseDir,char(tag + ".offset_*.txt")));
    tests = struct('offset_mV',{},'ecg_mV',{},'finalDiff_mV',{},'finalCmErr_mV',{}, ...
        'maxIdd_nA',{},'finalInp_V',{},'finalInn_V',{},'finalOutp_V',{},'finalOutn_V',{}, ...
        't_s',{},'vinDiff_mV',{},'vinCm_V',{},'voutDiff_mV',{},'voutCm_V',{});
    for k = 1:numel(files)
        tok = regexp(files(k).name,'offset_([pn])(\d+)m_ecg(\d+(?:p\d+)?)m','tokens','once');
        if isempty(tok), continue; end
        tr = readTran(fullfile(files(k).folder,files(k).name));
        offset_mV = str2double(tok{2});
        if strcmp(tok{1},'n'), offset_mV = -offset_mV; end
        ecg_mV = str2double(strrep(tok{3},'p','.'));
        tests(end+1) = struct( ...
            'offset_mV',offset_mV, ...
            'ecg_mV',ecg_mV, ...
            'finalDiff_mV',tailMean(tr.voutdiff_V)*1e3, ...
            'finalCmErr_mV',tailMean(tr.voutcm_V-tr.vref_V)*1e3, ...
            'maxIdd_nA',maxAbs(tr.idd_A)*1e9, ...
            'finalInp_V',tailMean(tr.vinp_V), ...
            'finalInn_V',tailMean(tr.vinn_V), ...
            'finalOutp_V',tailMean(tr.voutp_V), ...
            'finalOutn_V',tailMean(tr.voutn_V), ...
            't_s',tr.t_s, ...
            'vinDiff_mV',tr.vinDiff_V*1e3, ...
            'vinCm_V',0.5*(tr.vinp_V+tr.vinn_V), ...
            'voutDiff_mV',tr.voutdiff_V*1e3, ...
            'voutCm_V',tr.voutcm_V); %#ok<AGROW>
    end
end

function [gain_dB,phase_deg,f3dB_Hz] = acTransferMetrics(f_Hz,H)
    gain_dB = 20*log10(abs(H));
    phase_deg = unwrap(angle(H))*180/pi;
    passGain_dB = maxFinite(gain_dB);
    target_dB = passGain_dB - 3;
    f3dB_Hz = firstCrossing(f_Hz,gain_dB,target_dB);
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

function f0 = firstCrossing(f,x,target)
    f0 = NaN;
    ok = isfinite(f) & isfinite(x);
    f = f(ok); x = x(ok);
    idx = find((x(1:end-1)-target).*(x(2:end)-target) <= 0,1,'first');
    if ~isempty(idx)
        f0 = 10.^interp1(x(idx:idx+1),log10(f(idx:idx+1)),target,'linear','extrap');
    end
end

function y = tailMean(x)
    n = max(1,ceil(0.1*numel(x)));
    x = x(end-n+1:end);
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = mean(x); end
end

function y = maxAbs(x)
    x = abs(x(isfinite(x)));
    if isempty(x), y = NaN; else, y = max(x); end
end

function y = maxFinite(x)
    x = x(isfinite(x));
    if isempty(x), y = NaN; else, y = max(x); end
end

function plotDcInputOutput(tests,plotDir)
    figure;
    tiledlayout(2,1);
    sgtitle('DCB DC Input-Output Transfer');
    ecgList = unique([tests.ecg_mV]);
    for p = 1:min(2,numel(ecgList))
        idx = find([tests.ecg_mV] == ecgList(p));
        nexttile; hold on;
        plot([tests(idx).finalInp_V],[tests(idx).finalOutp_V],'-o','LineWidth',1.5, ...
            'DisplayName','INP to OUTP');
        plot([tests(idx).finalInn_V],[tests(idx).finalOutn_V],'-o','LineWidth',1.5, ...
            'DisplayName','INN to OUTN');
        title(sprintf('ECG %.4g mV',ecgList(p)));
        ylabel('Output DC (V)');
        legend('Location','best');
        stylePlot('Input DC (V)','');
    end
    saveFig(plotDir,'NOM.dc_input_output_transfer.png');
end

function plotOffsetTransient(tests,plotDir)
    figure;
    tiledlayout(2,1);
    sgtitle('DCB DC-Offset Rejection Transient');
    ecgList = unique([tests.ecg_mV]);
    for p = 1:min(2,numel(ecgList))
        nexttile; hold on;
        idx = find([tests.ecg_mV] == ecgList(p));
        for k = idx
            plot(tests(k).t_s,tests(k).vinDiff_mV,'LineStyle',':','LineWidth',1.0, ...
                'DisplayName',sprintf('VIN %+.0f mV',tests(k).offset_mV));
            plot(tests(k).t_s,tests(k).voutDiff_mV,'LineStyle','-','LineWidth',1.2, ...
                'DisplayName',sprintf('VOUT %+.0f mV',tests(k).offset_mV));
        end
        ylabel('Differential voltage (mV)');
        title(sprintf('ECG %.4g mV',ecgList(p)));
        if p == 1, legend('Location','bestoutside'); end
        stylePlot('Time (s)','');
    end
    saveFig(plotDir,'NOM.offset_rejection_transient.png');
end

function plotOffsetCommonMode(tests,plotDir)
    figure;
    tiledlayout(2,1);
    sgtitle('DCB Offset Common-Mode Transient');
    ecgList = unique([tests.ecg_mV]);
    for p = 1:min(2,numel(ecgList))
        nexttile; hold on;
        idx = find([tests.ecg_mV] == ecgList(p));
        for k = idx
            plot(tests(k).t_s,tests(k).vinCm_V,'LineStyle',':','LineWidth',1.0, ...
                'DisplayName',sprintf('VINCM %+.0f mV',tests(k).offset_mV));
            plot(tests(k).t_s,tests(k).voutCm_V,'LineStyle','-','LineWidth',1.2, ...
                'DisplayName',sprintf('VOUTCM %+.0f mV',tests(k).offset_mV));
        end
        ylabel('Common-mode voltage (V)');
        title(sprintf('ECG %.4g mV',ecgList(p)));
        if p == 1, legend('Location','bestoutside'); end
        stylePlot('Time (s)','');
    end
    saveFig(plotDir,'NOM.offset_common_mode_transient.png');
end

function labelFreqSet(f,x,freqs,unitText)
    for f0 = freqs
        y0 = interpAtFreq(f,x,f0);
        addFreqCursor(f0,sprintf('%s: %.4g %s',freqText(f0),y0,unitText));
    end
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
