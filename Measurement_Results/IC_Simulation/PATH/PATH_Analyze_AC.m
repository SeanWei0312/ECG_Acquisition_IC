% PATH AC-only analysis for stacked G2 and G16 TXT outputs
clear; clc; close all;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = fullfile(scriptDir,'NOM.Result_txt');

TAG = "NOM";
PGA_CASES = [2 16];
BASE_GAIN_VV = 60*4;
VCM_TARGET_V = 1.65;
MAKE_PLOTS = true;
SHOW_PLOTS = true;
MARK_FREQ_HZ = [0.05 60 150 1e3];
NOISE_DENSITY_FREQ_HZ = [0.05 1 10 60 150 1e3];
NOISE_PLOT_FREQ_HZ = [0.05 60 150];
NOISE_BAND_HZ = [0.05 150];
NOISE_TOTAL_BAND_HZ = [0.01 1e3];

opData = readTxt(fullfile(baseDir,TAG + ".op.txt"));
diffData = readTxt(fullfile(baseDir,TAG + ".diff_ac.txt"));
cmrrData = readTxt(fullfile(baseDir,TAG + ".cmrr_ac.txt"));
psrrpData = readTxt(fullfile(baseDir,TAG + ".psrrp_ac.txt"));
psrrnData = readTxt(fullfile(baseDir,TAG + ".psrrn_ac.txt"));
noiseData = readTxt(fullfile(baseDir,TAG + ".noise_diff.txt"));

requireCols(opData,16,TAG + ".op.txt");
requireCols(diffData,18,TAG + ".diff_ac.txt");
requireCols(cmrrData,16,TAG + ".cmrr_ac.txt");
requireCols(psrrpData,16,TAG + ".psrrp_ac.txt");
requireCols(psrrnData,16,TAG + ".psrrn_ac.txt");
requireCols(noiseData,4,TAG + ".noise_diff.txt");

cases = repmat(emptyCase(),numel(PGA_CASES),1);
rows = strings(0,3);

for k = 1:numel(PGA_CASES)
    pga = PGA_CASES(k);
    c = emptyCase();
    c.pga = pga;
    c.label = sprintf('G%.4g',pga);
    c.expectedGain_VV = BASE_GAIN_VV*pga;
    c.expectedGain_dB = 20*log10(c.expectedGain_VV);

    op = lastRow(rowsForGain(opData,pga,2));
    c.vdd_V = pick(op,3);
    c.vinCmDc_V = pick(op,6);
    c.vinDiffDc_mV = pick(op,7)*1e3;
    c.outpDc_V = pick(op,8);
    c.outnDc_V = pick(op,9);
    c.outCmDc_V = pick(op,10);
    c.outDiffDc_mV = pick(op,11)*1e3;
    c.rldDc_V = pick(op,12);
    c.ref_V = pick(op,13);
    c.ibias_A = abs(pick(op,14));
    c.idd_A = abs(pick(op,15));
    c.power_W = pick(op,16);
    if ~isfinite(c.power_W), c.power_W = c.vdd_V*c.idd_A; end
    c.outCmErr_mV = (c.outCmDc_V - VCM_TARGET_V)*1e3;
    c.headroomLow_V = min(c.outpDc_V,c.outnDc_V);
    c.headroomHigh_V = c.vdd_V - max(c.outpDc_V,c.outnDc_V);

    da = uniqueFreqRows(rowsForGain(diffData,pga,2));
    c.f_Hz = da(:,1);
    [c.Hd,c.gain_dB,c.phase_deg] = diffTransfer(da);
    gain60_dB = interpAtFreq(c.f_Hz,c.gain_dB,60);
    c.gainMid_dB = meanBand(c.f_Hz,c.gain_dB,[1 60]);
    if ~isfinite(c.gainMid_dB), c.gainMid_dB = gain60_dB; end
    c.gainMid_VV = 10^(c.gainMid_dB/20);
    c.gainError_dB = c.gainMid_dB - c.expectedGain_dB;
    c.gainAt_dB = interpAtFreq(c.f_Hz,c.gain_dB,MARK_FREQ_HZ);
    c.gainErrorAt_dB = c.gainAt_dB(1:3) - c.expectedGain_dB;
    c.phaseAt_deg = interpAtFreq(c.f_Hz,c.phase_deg,MARK_FREQ_HZ);
    gainRel_dB = c.gain_dB - c.gainMid_dB;
    c.hp1dB_Hz = cornerCrossing(c.f_Hz,gainRel_dB,-1,60,'hp');
    c.hp3dB_Hz = cornerCrossing(c.f_Hz,gainRel_dB,-3,60,'hp');
    c.lp1dB_Hz = cornerCrossing(c.f_Hz,gainRel_dB,-1,60,'lp');
    c.lp3dB_Hz = cornerCrossing(c.f_Hz,gainRel_dB,-3,60,'lp');
    c.gainFlatness_dB = bandRange(c.f_Hz,c.gain_dB,[0.05 150]);

    c.cmrr = rejectionAc(uniqueFreqRows(rowsForGain(cmrrData,pga,2)),c.f_Hz,c.gain_dB);
    c.psrrp = rejectionAc(uniqueFreqRows(rowsForGain(psrrpData,pga,2)),c.f_Hz,c.gain_dB);
    c.psrrn = rejectionAc(uniqueFreqRows(rowsForGain(psrrnData,pga,2)),c.f_Hz,c.gain_dB);
    c.cmrrAt_dB = interpAtFreq(c.cmrr.f_Hz,c.cmrr.rej_dB,MARK_FREQ_HZ);
    c.psrrPAt_dB = interpAtFreq(c.psrrp.f_Hz,c.psrrp.rej_dB,MARK_FREQ_HZ);
    c.psrrNAt_dB = interpAtFreq(c.psrrn.f_Hz,c.psrrn.rej_dB,MARK_FREQ_HZ);

    c.noise = readNoise(uniqueFreqRows(rowsForGain(noiseData,pga,2)));
    c.noiseOutBand_Vrms = integrateNoise(c.noise.f_Hz,c.noise.out_VrtHz,NOISE_BAND_HZ);
    c.noiseInBand_Vrms = integrateNoise(c.noise.f_Hz,c.noise.in_VrtHz,NOISE_BAND_HZ);
    c.noiseInTotal_Vrms = integrateNoise(c.noise.f_Hz,c.noise.in_VrtHz,NOISE_TOTAL_BAND_HZ);
    c.noiseInAt = interpAtFreq(c.noise.f_Hz,c.noise.in_VrtHz,NOISE_DENSITY_FREQ_HZ);
    if pga == 2
        c.snrSignalPp_V = 5e-3;
    elseif pga == 16
        c.snrSignalPp_V = 0.5e-3;
    end
    c.snrOut_dB = 20*log10((c.snrSignalPp_V*c.expectedGain_VV/(2*sqrt(2))) / c.noiseOutBand_Vrms);

    cases(k) = c;
    rows = appendCaseRows(rows,c);
end

if MAKE_PLOTS
    plotDir = fullfile(scriptDir,'Plots');
    if ~exist(plotDir,'dir'), mkdir(plotDir); end
    plotDiffAcCases(cases,plotDir,SHOW_PLOTS);
    plotRejectionCases(cases,'cmrr','PATH CMRR','CMRR (dB)','NOM.cmrr.png',plotDir,SHOW_PLOTS);
    plotPsrrCases(cases,plotDir,SHOW_PLOTS);
    plotNoiseCases(cases,NOISE_PLOT_FREQ_HZ,plotDir,SHOW_PLOTS);
end

summary = array2table(rows,'VariableNames',{'Parameter','Unit','Value'});
disp(summary);
writetable(summary,fullfile(scriptDir,'PATH_AC_summary.csv'));

%% Local functions
function c = emptyCase()
    c = struct('pga',NaN,'label',"",'expectedGain_VV',NaN,'expectedGain_dB',NaN, ...
        'vdd_V',NaN,'vinCmDc_V',NaN,'vinDiffDc_mV',NaN, ...
        'outpDc_V',NaN,'outnDc_V',NaN,'outCmDc_V',NaN,'outDiffDc_mV',NaN, ...
        'rldDc_V',NaN,'ref_V',NaN,'ibias_A',NaN,'idd_A',NaN,'power_W',NaN, ...
        'outCmErr_mV',NaN,'headroomLow_V',NaN,'headroomHigh_V',NaN, ...
        'f_Hz',[],'Hd',[],'gain_dB',[],'phase_deg',[],'gainMid_VV',NaN, ...
        'gainMid_dB',NaN,'gainError_dB',NaN,'gainAt_dB',[],'gainErrorAt_dB',[], ...
        'phaseAt_deg',[], ...
        'gainFlatness_dB',NaN,'hp1dB_Hz',NaN,'hp3dB_Hz',NaN,'lp1dB_Hz',NaN, ...
        'lp3dB_Hz',NaN,'cmrr',[],'psrrp',[],'psrrn',[],'cmrrAt_dB',[], ...
        'psrrPAt_dB',[],'psrrNAt_dB',[],'noise',[],'noiseOutBand_Vrms',NaN, ...
        'noiseInBand_Vrms',NaN,'noiseInTotal_Vrms',NaN,'noiseInAt',[], ...
        'snrSignalPp_V',NaN,'snrOut_dB',NaN);
end

function rows = appendCaseRows(rows,c)
    rows = addSection(rows,string(c.label));
    rows = addRow(rows,"Total current","uA",c.idd_A*1e6);
    rows = addRow(rows,"Total power","mW",c.power_W*1e3);
    rows = addRow(rows,"Expected gain","V/V",c.expectedGain_VV);
    rows = addRow(rows,"Expected gain","dB",c.expectedGain_dB);
    rows = addGainErrorRows(rows,c.gainErrorAt_dB);
    rows = addMarkedRows(rows,"CMRR",c.cmrrAt_dB,"dB");
    rows = addMarkedRows(rows,"PSRR+",c.psrrPAt_dB,"dB");
    rows = addMarkedRows(rows,"PSRR-",c.psrrNAt_dB,"dB");
    rows = addRow(rows,"HP -1dB corner","Hz",c.hp1dB_Hz);
    rows = addRow(rows,"HP -3dB corner","Hz",c.hp3dB_Hz);
    rows = addRow(rows,"LP -1dB corner","Hz",c.lp1dB_Hz);
    rows = addRow(rows,"LP -3dB corner","Hz",c.lp3dB_Hz);
    rows = addRow(rows,"Input-referred noise 0.05-150 Hz","uVrms",c.noiseInBand_Vrms*1e6);
end

function rows = addGainErrorRows(rows,values)
    labels = ["0.05 Hz" "60 Hz" "150 Hz"];
    for k = 1:numel(labels)
        rows = addRow(rows,"AC gain error @ " + labels(k),"dB",values(k));
    end
end

function rows = addMarkedRows(rows,baseName,values,unit)
    if numel(values) == 6
        labels = ["0.05 Hz" "1 Hz" "10 Hz" "60 Hz" "150 Hz" "1 kHz"];
    else
        labels = ["0.05 Hz" "60 Hz" "150 Hz" "1 kHz"];
    end
    for k = 1:numel(labels)
        rows = addRow(rows,baseName + " @ " + labels(k),unit,values(k));
    end
end

function rows = addSection(rows,label)
    rows(end+1,:) = [string(label) "" ""];
end

function rows = addRow(rows,param,unit,val)
    rows(end+1,:) = [string(param) string(unit) fmt(val)];
end

function data = readTxt(file)
    if ~isfile(file), error('Missing file: %s',file); end
    data = load(file,'-ascii');
    data = data(all(isfinite(data),2),:);
end

function requireCols(data,n,fileName)
    if size(data,2) < n
        error('%s must contain at least %d numeric columns, found %d.',fileName,n,size(data,2));
    end
end

function d = rowsForGain(data,pga,pgaCol)
    d = data(abs(data(:,pgaCol)-pga) < 0.1,:);
    if isempty(d)
        error('No rows found for PGA gain %.4g in column %d.',pga,pgaCol);
    end
end

function d = uniqueFreqRows(d)
    [~,idx] = sort(d(:,1));
    d = d(idx,:);
    [~,~,grp] = unique(d(:,1));
    out = zeros(max(grp),size(d,2));
    for k = 1:size(d,2)
        out(:,k) = accumarray(grp,d(:,k),[],@mean);
    end
    d = out;
end

function row = lastRow(data)
    if isempty(data), row = NaN(1,size(data,2)); else, row = data(end,:); end
end

function y = pick(x,idx)
    if numel(x) < idx, y = NaN; else, y = x(idx); end
end

function z = complexCol(d,r,i)
    z = d(:,r) + 1j*d(:,i);
end

function [H,gain_dB,phase_deg] = diffTransfer(d)
    H = complexCol(d,14,15);
    gain_dB = d(:,17);
    phase_deg = unwrap(d(:,18)*pi/180)*180/pi;
end

function r = rejectionAc(d,fDiff,gainDiff_dB)
    r.f_Hz = d(:,1);
    gainDiffAtF_dB = interpAtFreq(fDiff,gainDiff_dB,r.f_Hz);
    r.rej_dB = gainDiffAtF_dB - d(:,15);
end

function noise = readNoise(d)
    noise.f_Hz = d(:,1);
    noise.out_VrtHz = abs(d(:,3));
    noise.in_VrtHz = abs(d(:,4));
end

function plotDiffAcCases(cases,plotDir,showPlots)
    newFig(showPlots);
    for k = 1:numel(cases)
        c = cases(k);
        subplot(numel(cases),1,k);
        yyaxis left; hold on;
        semilogx(c.f_Hz,c.gain_dB,'LineWidth',1.5,'DisplayName','AC gain');
        yline(c.gainMid_dB-1,'--','-1dB','HandleVisibility','off');
        yline(c.gainMid_dB-3,'--','-3dB','HandleVisibility','off');
        addAcDbCursors(c.f_Hz,c.gain_dB,[0.05 60 150]);
        addFreqCursor(c.hp1dB_Hz,sprintf('HP -1 dB: %s',freqText(c.hp1dB_Hz)));
        addFreqCursor(c.hp3dB_Hz,sprintf('HP -3 dB: %s',freqText(c.hp3dB_Hz)));
        addFreqCursor(c.lp1dB_Hz,sprintf('LP -1 dB: %s',freqText(c.lp1dB_Hz)));
        addFreqCursor(c.lp3dB_Hz,sprintf('LP -3 dB: %s',freqText(c.lp3dB_Hz)));
        ylabel('Gain (dB)');
        paddedYLim([yInFreqLim(c.f_Hz,c.gain_dB); c.gainMid_dB-1; c.gainMid_dB-3]);
        yyaxis right;
        semilogx(c.f_Hz,c.phase_deg,'LineWidth',1.5,'DisplayName','AC phase');
        ylabel('Phase (deg)');
        paddedYLim(yInFreqLim(c.f_Hz,c.phase_deg));
        stylePlot('Frequency (Hz)',sprintf('PATH Differential AC Response - %s',c.label));
        set(gca,'XScale','log');
        applyFreqXLim();
        legend('Location','best');
    end
    saveFig(plotDir,'NOM.diff_response.png',showPlots);
end

function plotRejectionCases(cases,fieldName,titleText,yText,fileName,plotDir,showPlots)
    newFig(showPlots);
    for k = 1:numel(cases)
        subplot(numel(cases),1,k); hold on;
        r = cases(k).(fieldName);
        ok = isfinite(r.f_Hz) & isfinite(r.rej_dB);
        semilogx(r.f_Hz(ok),r.rej_dB(ok),'LineWidth',1.5,'DisplayName','AC');
        addAcDbCursors(r.f_Hz,r.rej_dB,[0.05 60 150 1e3]);
        stylePlot('Frequency (Hz)',sprintf('%s - %s',titleText,cases(k).label));
        set(gca,'XScale','log');
        applyFreqXLim();
        ylabel(yText);
        paddedYLim(yInFreqLim(r.f_Hz,r.rej_dB));
        legend('Location','best');
    end
    saveFig(plotDir,fileName,showPlots);
end

function plotPsrrCases(cases,plotDir,showPlots)
    newFig(showPlots);
    tiledlayout(numel(cases),2,'TileSpacing','compact');
    for k = 1:numel(cases)
        nexttile; hold on;
        r = cases(k).psrrp;
        ok = isfinite(r.f_Hz) & isfinite(r.rej_dB);
        semilogx(r.f_Hz(ok),r.rej_dB(ok),'LineWidth',1.5,'DisplayName','AC');
        addAcDbCursors(r.f_Hz,r.rej_dB,[0.05 60 150 1e3]);
        stylePlot('Frequency (Hz)',sprintf('PATH PSRR+ - %s',cases(k).label));
        set(gca,'XScale','log');
        applyFreqXLim();
        ylabel('PSRR+ (dB)');
        paddedYLim(yInFreqLim(r.f_Hz,r.rej_dB));
        legend('Location','best');

        nexttile; hold on;
        r = cases(k).psrrn;
        ok = isfinite(r.f_Hz) & isfinite(r.rej_dB);
        semilogx(r.f_Hz(ok),r.rej_dB(ok),'LineWidth',1.5,'DisplayName','AC');
        addAcDbCursors(r.f_Hz,r.rej_dB,[0.05 60 150 1e3]);
        stylePlot('Frequency (Hz)',sprintf('PATH PSRR- - %s',cases(k).label));
        set(gca,'XScale','log');
        applyFreqXLim();
        ylabel('PSRR- (dB)');
        paddedYLim(yInFreqLim(r.f_Hz,r.rej_dB));
        legend('Location','best');
    end
    saveFig(plotDir,'NOM.psrr.png',showPlots);
end

function plotNoiseCases(cases,marks,plotDir,showPlots)
    newFig(showPlots);
    for k = 1:numel(cases)
        subplot(numel(cases),1,k); hold on;
        n = cases(k).noise;
        loglog(n.f_Hz,n.in_VrtHz*1e9,'LineWidth',1.5,'DisplayName','Input referred');
        stylePlot('Frequency (Hz)',sprintf('PATH Input-Referred Noise Density - %s',cases(k).label));
        set(gca,'XScale','log');
        set(gca,'YScale','log');
        ylabel('Input-referred noise (nV/rtHz)');
        xlim([0.05 150]);
        for f0 = marks
            y = interpAtFreq(n.f_Hz,n.in_VrtHz,f0)*1e9;
            addNoisePoint(f0,y,sprintf('%s: %.4g nV/rtHz',freqText(f0),y));
        end
        legend('Location','best');
    end
    saveFig(plotDir,'NOM.noise.png',showPlots);
end

function vn = integrateNoise(f,en,band)
    [f,en] = uniqueSeries(f,en);
    ok = f >= band(1) & f <= band(2) & isfinite(en);
    fb = f(ok); eb = en(ok);
    if numel(fb) < 2, vn = NaN; return; end
    vn = sqrt(trapz(fb,eb.^2));
end

function y = meanBand(f,x,band)
    ok = f >= band(1) & f <= band(2) & isfinite(x);
    if ~any(ok), y = NaN; else, y = mean(x(ok)); end
end

function y = bandRange(f,x,band)
    ok = f >= band(1) & f <= band(2) & isfinite(x);
    if ~any(ok), y = NaN; else, y = max(x(ok))-min(x(ok)); end
end

function f0 = cornerCrossing(f,x,target,refFreq,side)
    f0 = NaN;
    [f,x] = uniqueSeries(f,x);
    if strcmp(side,'hp'), idx = find(f < refFreq); sense = 'rise'; else, idx = find(f > refFreq); sense = 'fall'; end
    if numel(idx) < 2, return; end
    if strcmp(sense,'rise')
        k = find(x(idx(1:end-1)) <= target & x(idx(2:end)) >= target,1,'last');
    else
        k = find(x(idx(1:end-1)) >= target & x(idx(2:end)) <= target,1,'first');
    end
    if isempty(k), return; end
    ii = idx(k:k+1);
    if abs(diff(x(ii))) < eps
        f0 = 10.^mean(log10(f(ii)));
    else
        f0 = 10.^interp1(x(ii),log10(f(ii)),target,'linear','extrap');
    end
end

function y = interpAtFreq(f,x,f0)
    [f,x] = uniqueSeries(f,x);
    f0Size = size(f0);
    f0 = f0(:);
    y = NaN(size(f0));
    ok0 = isfinite(f0) & f0 > 0;
    if isempty(f) || ~any(ok0)
        y = reshape(y,f0Size);
        return;
    elseif numel(f) < 2
        y(ok0) = x(1);
    else
        y(ok0) = interp1(log10(f),x,log10(f0(ok0)),'linear','extrap');
    end
    y = reshape(y,f0Size);
end

function [f,x] = uniqueSeries(f,x)
    f = f(:); x = x(:);
    ok = isfinite(f) & isfinite(x) & f > 0;
    f = f(ok); x = x(ok);
    if isempty(f), return; end
    [f,~,idx] = unique(f);
    x = accumarray(idx,x,[],@mean);
end

function addAcDbCursors(f,y,marks)
    for f0 = marks
        y0 = interpAtFreq(f,y,f0);
        addCursor(f0,y0,sprintf('%s: %.4g dB',freqText(f0),y0));
    end
end

function addCursor(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    xline(x,':',char(labelText),'HandleVisibility','off', ...
        'Color','w','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
end

function addNoisePoint(x,y,labelText)
    if ~isfinite(x) || ~isfinite(y), return; end
    ax = gca;
    xl = xlim(ax);
    if strcmp(ax.XScale,'log')
        pad = 0.018*(log10(xl(2))-log10(xl(1)));
        xText = 10^(log10(x) + pad);
        if x <= xl(1)
            xText = 10^(log10(xl(1)) + pad);
        elseif x >= xl(2)
            xText = 10^(log10(xl(2)) - pad);
        end
    else
        pad = 0.018*(xl(2)-xl(1));
        xText = x + pad;
        if x <= xl(1)
            xText = xl(1) + pad;
        elseif x >= xl(2)
            xText = xl(2) - pad;
        end
    end
    plot(x,y,'o','MarkerFaceColor',[1 0.6 0], ...
        'MarkerEdgeColor','w','MarkerSize',6, ...
        'LineStyle','none','HandleVisibility','off');
    text(xText,y,char(labelText),'Color','w','VerticalAlignment','middle', ...
        'HorizontalAlignment','left','Clipping','on');
end

function addFreqCursor(x,labelText)
    if ~isfinite(x), return; end
    xline(x,':'," " + string(labelText),'HandleVisibility','off', ...
        'Color','w','LabelVerticalAlignment','middle', ...
        'LabelHorizontalAlignment','left');
end

function stylePlot(xText,titleText)
    grid on;
    xlabel(xText);
    title(titleText,'Interpreter','none');
end

function applyFreqXLim()
    xlim([1e-3 1e4]);
end

function yv = yInFreqLim(f,y)
    lim = [1e-3 1e4];
    keep = f >= lim(1) & f <= lim(2);
    yv = y(keep);
end

function paddedYLim(y)
    y = y(isfinite(y));
    if isempty(y), return; end
    lo = min(y);
    hi = max(y);
    pad = 0.08*max(hi-lo,eps);
    ylim([lo-pad hi+pad]);
end

function saveFig(plotDir,fileName,showPlots)
    filePath = fullfile(plotDir,fileName);
    drawnow;
    if exist('exportgraphics','file')
        exportgraphics(gcf,filePath,'Resolution',150);
    else
        saveas(gcf,filePath);
    end
    if ~showPlots
        close(gcf);
    end
end

function newFig(showPlots)
    if showPlots
        figure;
    else
        figure('Visible','off');
    end
end

function s = freqText(f)
    if ~isfinite(f), s = 'NaN';
    elseif f >= 1e3, s = sprintf('%.4g kHz',f/1e3);
    else, s = sprintf('%.4g Hz',f);
    end
end

function s = fmt(x)
    if ~isfinite(x), s = "NaN"; else, s = string(sprintf('%.6g',x)); end
end
