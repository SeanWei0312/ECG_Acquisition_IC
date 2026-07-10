clear; clc; close all;

annotationColor = [1 0 0];
annotationTextColor = [0 0 0];
annotationBackgroundColor = [1 1 1];
format shortEng;

baseDir = "/Users/sean/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/SE_OTA";
plotDir = fullfile(baseDir, "Plots");

if ~exist(plotDir, "dir")
    mkdir(plotDir);
end

tags = ["NOM","FF","SS","FS","SF","V30","V36","Cn40","C125"];
pvtNames = ["Nominal","ff","ss","fs","sf","3.0 V","3.6 V","-40 C","125 C"];
avddList = [3.3 3.3 3.3 3.3 3.3 3.0 3.6 3.3 3.3];

swingErrLimit = 10e-3;     % valid unity-gain range: |Vout - Vin| <= 10 mV
settleErr = 10e-3;         % settling band for 1 V step
slewLow_V = 1.1;           % 10% point for 1 V -> 2 V step
slewHigh_V = 1.9;          % 90% point for 1 V -> 2 V step
settleStart_s = 1e-6;      % rising step starts at 1 us
settleFinal_V = 2.0;       % final value after rising step
settleEnd_s = 10e-6;
CLoad_pF = 10;

R = cell(1, numel(tags));

for k = 1:numel(tags)
    fprintf("Analyzing %s...\n", tags(k));
    R{k} = analyze_one_safe(baseDir, tags(k), avddList(k), swingErrLimit, ...
                            settleErr, slewLow_V, slewHigh_V, ...
                            settleStart_s, settleFinal_V, settleEnd_s);
end

%% =========================================================
% Full PVT table
% =========================================================
Parameter = [
    "AVDD"
    "Bias current"
    "Total current"
    "Total power"
    "Vin,cm"
    "Vout,DC"
    "Input CM range"
    "Output swing"
    "DC gain"
    "UGF"
    "Phase margin"
    "CLoad"
    "Slew rate rising"
    "Slew rate falling"
    "Settling time"
    "Input-referred noise"
    "Input offset"
    "CMRR @ 1 Hz"
    "CMRR @ 60 Hz"
    "CMRR @ 150 Hz"
    "CMRR @ 1 kHz"
    "PSRR+ @ 1 Hz"
    "PSRR+ @ 60 Hz"
    "PSRR+ @ 150 Hz"
    "PSRR+ @ 1 kHz"
    "PSRR- @ 1 Hz"
    "PSRR- @ 60 Hz"
    "PSRR- @ 150 Hz"
    "PSRR- @ 1 kHz"
];

Unit = [
    "V"
    "uA"
    "uA"
    "mW"
    "V"
    "V"
    "V"
    "V"
    "dB"
    "MHz"
    "deg"
    "pF"
    "V/us"
    "V/us"
    "ns"
    "uVrms"
    "mV"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
    "dB"
];

C = cell(numel(Parameter)+1, numel(tags)+2);
C(1,:) = cellstr(["Parameter","Unit",pvtNames]);
C(2:end,1) = cellstr(Parameter);
C(2:end,2) = cellstr(Unit);

for k = 1:numel(tags)
    V = [
        fmt(R{k}.AVDD, "%.3f")
        fmt(R{k}.Ibias_uA, "%.3f")
        fmt(R{k}.Idd_uA, "%.3f")
        fmt(R{k}.Power_mW, "%.4f")
        fmt(R{k}.Vin_cm, "%.4f")
        fmt(R{k}.Vout_DC, "%.4f")
        fmt_range(R{k}.Input_cm_min, R{k}.Input_cm_max, "%.3f")
        fmt_range(R{k}.Output_swing_min, R{k}.Output_swing_max, "%.3f")
        fmt(R{k}.DC_gain_dB, "%.2f")
        fmt(R{k}.UGF_MHz, "%.4f")
        fmt(R{k}.PM_deg, "%.2f")
        fmt(CLoad_pF, "%.0f")
        fmt(R{k}.SR_rise_Vus, "%.3f")
        fmt(R{k}.SR_fall_Vus, "%.3f")
        fmt(R{k}.Settling_ns, "%.2f")
        fmt(R{k}.Input_noise_uVrms, "%.3f")
        fmt(R{k}.Input_offset_mV, "%.3f")
        fmt(R{k}.CMRR_1, "%.2f")
        fmt(R{k}.CMRR_60, "%.2f")
        fmt(R{k}.CMRR_150, "%.2f")
        fmt(R{k}.CMRR_1k, "%.2f")
        fmt(R{k}.PSRRP_1, "%.2f")
        fmt(R{k}.PSRRP_60, "%.2f")
        fmt(R{k}.PSRRP_150, "%.2f")
        fmt(R{k}.PSRRP_1k, "%.2f")
        fmt(R{k}.PSRRN_1, "%.2f")
        fmt(R{k}.PSRRN_60, "%.2f")
        fmt(R{k}.PSRRN_150, "%.2f")
        fmt(R{k}.PSRRN_1k, "%.2f")
    ];

    C(2:end,k+2) = cellstr(V);
end

Tdisp = cell2table(C(2:end,:), "VariableNames", matlab.lang.makeValidName(C(1,:)));

fprintf("\n================ FULL SE OTA PVT TABLE ================\n");
disp(Tdisp);

txtFile = fullfile(baseDir, "SE_OTA_Full_PVT_Table.txt");
xlsxFile = fullfile(baseDir, "SE_OTA_Full_PVT_Table.xlsx");

writecell(C, txtFile, "Delimiter", "\t");
writecell(C, xlsxFile);

fprintf("\nSaved table:\n%s\n%s\n", txtFile, xlsxFile);

%% =========================================================
% Plot nominal results
% =========================================================
N = R{1};

% 1 Open-loop gain and phase
figure;
if ~isempty(N.f)
    yyaxis left;
    semilogx(N.f, N.gain_dB, "LineWidth", 1.5);
    hold on;
    ylabel("Magnitude (dB)");

    yyaxis right;
    semilogx(N.f, N.phase_rel, "LineWidth", 1.5);
    hold on;
    ylabel("Phase (deg)");

    xlabel("Frequency (Hz)");
    grid on;
    title("1. Open-loop Gain and Phase");

    if isfinite(N.UGF_Hz)
        ugf_MHz = N.UGF_Hz / 1e6;
        phaseAtUGF = interp_log(N.f, N.phase_rel, N.UGF_Hz);

        yyaxis left;
        xline(N.UGF_Hz, "--", "U");
        plot(N.UGF_Hz, 0, "o", "Color", annotationColor, "MarkerFaceColor", annotationColor);
        text(N.UGF_Hz, 0, sprintf(" U %.3fM", ugf_MHz), ...
             "VerticalAlignment", "bottom", ...
             "Color", annotationTextColor, ...
             "BackgroundColor", annotationBackgroundColor, ...
             "Margin", 1);

        yyaxis right;
        plot(N.UGF_Hz, phaseAtUGF, "s", "Color", annotationColor, "MarkerFaceColor", annotationColor);
        text(N.UGF_Hz, phaseAtUGF, sprintf(" PM %.1f", N.PM_deg), ...
             "VerticalAlignment", "top", ...
             "Color", annotationTextColor, ...
             "BackgroundColor", annotationBackgroundColor, ...
             "Margin", 1);
    end
else
    text(0.1, 0.5, "NOM AC data missing");
    axis off;
    title("1. Open-loop Gain and Phase");
end
saveas(gcf, fullfile(plotDir, "plot1_open_loop_gain_phase.png"));

% 2 Closed-loop step response
figure;
if ~isempty(N.t_slew)
    plot(N.t_slew*1e6, N.slew_inp, "--", "LineWidth", 1.2);
    hold on;
    plot(N.t_slew*1e6, N.slew_out, "LineWidth", 1.5);
    grid on;
    xlabel("Time (us)");
    ylabel("Voltage (V)");
    title("2. Closed-loop Step Response");
    legend("Vin", "Vout", "Location", "best");

    if isfinite(N.Settling_ns)
        settleTime_us = settleStart_s * 1e6 + N.Settling_ns / 1e3;
        settleV = interp1(N.t_slew*1e6, N.slew_out, settleTime_us, "linear", "extrap");
        plot(settleTime_us, settleV, "o", "Color", annotationColor, "MarkerFaceColor", annotationColor);
        text(settleTime_us, settleV, sprintf(" Ts %.1fns", N.Settling_ns), ...
             "VerticalAlignment", "bottom", ...
             "Color", annotationTextColor, ...
             "BackgroundColor", annotationBackgroundColor, ...
             "Margin", 1);
    end

    labelSlewSegment(N.t_slew, N.slew_out, N.t10r, N.t90r, ...
                     N.SR_rise_Vus, "SR+");
    labelSlewSegment(N.t_slew, N.slew_out, N.t90f, N.t10f, ...
                     N.SR_fall_Vus, "SR-");
else
    text(0.1, 0.5, "NOM slew data missing");
    axis off;
    title("2. Closed-loop Step Response");
end
saveas(gcf, fullfile(plotDir, "plot2_closed_loop_step_response.png"));

% 3 Output swing / DC transfer
figure;
if ~isempty(N.vid_offset)
    plot(N.vid_offset*1e3, N.out_offset, "LineWidth", 1.5);
    hold on;
    grid on;
    xlabel("Vin,diff (mV)");
    ylabel("Vout (V)");
    title("3. Input Offset / DC Transfer");

    if isfinite(N.offset_vid) && isfinite(N.offset_out)
        yline(N.offset_out, "--", "Vcm");
        plot(N.offset_vid*1e3, N.offset_out, ...
             "o", "Color", annotationColor, "MarkerFaceColor", annotationColor);
        text(N.offset_vid*1e3, N.offset_out, ...
             sprintf(" Vos %.3fm", N.Input_offset_mV), ...
             "VerticalAlignment", "bottom", ...
             "Color", annotationTextColor, ...
             "BackgroundColor", annotationBackgroundColor, ...
             "Margin", 1);
    end

    if isfinite(N.Output_swing_min) && isfinite(N.Output_swing_max)
        yline(N.Output_swing_min, "--", sprintf("Lo %.3f", N.Output_swing_min));
        yline(N.Output_swing_max, "--", sprintf("Hi %.3f", N.Output_swing_max));
    end
else
    text(0.1, 0.5, "NOM offset data missing");
    axis off;
    title("3. Input Offset / DC Transfer");
end
saveas(gcf, fullfile(plotDir, "plot3_output_swing_dc_transfer.png"));

% 4 Input common-mode range
figure;
if ~isempty(N.sw_inp)
    tiledlayout(3,1);

    ax1 = nexttile;
    plot(N.sw_inp, N.sw_out, "LineWidth", 1.5);
    grid on;
    ylabel("Vout,DC (V)");
    title("4. Input Common-mode Range");
    labelCmRange(N);

    ax2 = nexttile;
    plot(N.sw_inp, N.sw_idd*1e6, "LineWidth", 1.5);
    grid on;
    ylabel("Bias current (uA)");
    labelCmRange(N);

    ax3 = nexttile;
    plot(N.sw_inp, N.sw_gain, "LineWidth", 1.5);
    grid on;
    xlabel("Vin,cm (V)");
    ylabel("Gain (V/V)");
    labelCmRange(N);
    linkaxes([ax1 ax2 ax3], "x");
else
    text(0.1, 0.5, "NOM swing data missing");
    axis off;
    title("4. Input Common-mode Range");
end
saveas(gcf, fullfile(plotDir, "plot4_input_common_mode_range.png"));

% 5 CMRR
figure;
if ~isempty(N.f)
    semilogx(N.f, N.CMRR_curve, "LineWidth", 1.5);
    hold on;
    grid on;
    xlabel("Frequency (Hz)");
    ylabel("CMRR (dB)");
    title("5. CMRR vs Frequency");
    labelLogPoint(N.f, N.CMRR_curve, 60, "60");
    labelLogPoint(N.f, N.CMRR_curve, 1e3, "1k");
else
    text(0.1, 0.5, "NOM CMRR data missing");
    axis off;
    title("5. CMRR vs Frequency");
end
saveas(gcf, fullfile(plotDir, "plot5_cmrr.png"));

% 6 PSRR+ and PSRR-
figure;
if ~isempty(N.f)
    semilogx(N.f, N.PSRRP_curve, "LineWidth", 1.5);
    hold on;
    semilogx(N.f, N.PSRRN_curve, "LineWidth", 1.5);
    grid on;
    xlabel("Frequency (Hz)");
    ylabel("PSRR (dB)");
    title("6. PSRR+ and PSRR- vs Frequency");
    legend("PSRR+", "PSRR-", "Location", "best");
    labelLogPoint(N.f, N.PSRRP_curve, 60, "P+60");
    labelLogPoint(N.f, N.PSRRN_curve, 60, "P-60");
    labelLogPoint(N.f, N.PSRRP_curve, 1e3, "P+1k");
    labelLogPoint(N.f, N.PSRRN_curve, 1e3, "P-1k");
else
    text(0.1, 0.5, "NOM PSRR data missing");
    axis off;
    title("6. PSRR+ and PSRR- vs Frequency");
end
saveas(gcf, fullfile(plotDir, "plot6_psrr.png"));

% 7 Input-referred integrated noise
figure;
noise_uVrms = nan(1, numel(tags));

for k = 1:numel(tags)
    noise_uVrms(k) = R{k}.Input_noise_uVrms;
end

if any(isfinite(noise_uVrms))
    bar(noise_uVrms);
    grid on;
    set(gca, "XTick", 1:numel(tags), "XTickLabel", pvtNames);
    xtickangle(45);
    ylabel("Integrated input-referred noise (uVrms)");
    title("7. Input-referred Integrated Noise");

    for k = 1:numel(noise_uVrms)
        if isfinite(noise_uVrms(k))
            text(k, noise_uVrms(k), sprintf("%.2f", noise_uVrms(k)), ...
                 "HorizontalAlignment", "center", ...
                 "VerticalAlignment", "bottom", ...
                 "Color", annotationTextColor, ...
                 "BackgroundColor", annotationBackgroundColor, ...
                 "Margin", 1);
        end
    end
else
    text(0.1, 0.5, "Noise total file not found");
    axis off;
    title("7. Input-referred Integrated Noise");
end
saveas(gcf, fullfile(plotDir, "plot7_input_referred_noise.png"));

fprintf("\nSaved plots in:\n%s\n", plotDir);

%% =========================================================
% Functions
% =========================================================
function R = analyze_one_safe(baseDir, tag, avddSet, swingErrLimit, settleErr, ...
                              slewLow_V, slewHigh_V, settleStart_s, ...
                              settleFinal_V, settleEnd_s)
    try
        R = analyze_one(baseDir, tag, avddSet, swingErrLimit, settleErr, ...
                        slewLow_V, slewHigh_V, settleStart_s, ...
                        settleFinal_V, settleEnd_s);
    catch ME
        warning("Failed to analyze %s: %s", tag, ME.message);
        R = empty_result(tag);
    end
end

function R = empty_result(tag)
    R.tag = tag;

    R.AVDD = NaN;
    R.Ibias_uA = NaN;
    R.Idd_uA = NaN;
    R.Power_mW = NaN;
    R.Vin_cm = NaN;
    R.Vout_DC = NaN;
    R.Input_cm_min = NaN;
    R.Input_cm_max = NaN;
    R.Output_swing_min = NaN;
    R.Output_swing_max = NaN;
    R.DC_gain_dB = NaN;
    R.UGF_Hz = NaN;
    R.UGF_MHz = NaN;
    R.PM_deg = NaN;
    R.SR_rise_Vus = NaN;
    R.SR_fall_Vus = NaN;
    R.t10r = NaN;
    R.t90r = NaN;
    R.t90f = NaN;
    R.t10f = NaN;
    R.Settling_ns = NaN;
    R.Input_noise_uVrms = NaN;
    R.Input_offset_V = NaN;
    R.Input_offset_mV = NaN;
    R.offset_vid = NaN;
    R.offset_out = NaN;
    R.CMRR_1 = NaN;
    R.CMRR_60 = NaN;
    R.CMRR_150 = NaN;
    R.CMRR_1k = NaN;
    R.PSRRP_1 = NaN;
    R.PSRRP_60 = NaN;
    R.PSRRP_150 = NaN;
    R.PSRRP_1k = NaN;
    R.PSRRN_1 = NaN;
    R.PSRRN_60 = NaN;
    R.PSRRN_150 = NaN;
    R.PSRRN_1k = NaN;
    R.f = [];
    R.gain_dB = [];
    R.phase_rel = [];
    R.CMRR_curve = [];
    R.PSRRP_curve = [];
    R.PSRRN_curve = [];

    R.t_slew = [];
    R.slew_inp = [];
    R.slew_out = [];

    R.vid_offset = [];
    R.out_offset = [];

    R.sw_inp = [];
    R.sw_out = [];
    R.sw_idd = [];
    R.sw_gain = [];

end

function R = analyze_one(baseDir, tag, avddSet, swingErrLimit, settleErr, ...
                         slewLow_V, slewHigh_V, settleStart_s, ...
                         settleFinal_V, settleEnd_s)

    ol_op      = parse_file(baseDir, tag + ".ol_op.txt", 7);
    ol_offset  = parse_file(baseDir, tag + ".ol_offset.txt", 3);
    ol_ac_diff = parse_file(baseDir, tag + ".ol_ac_diff.txt", 3);
    ol_ac_cm   = parse_file(baseDir, tag + ".ol_ac_cm.txt", 2);
    ol_psp     = parse_file(baseDir, tag + ".ol_ac_psrrp.txt", 2);
    ol_psn     = parse_file(baseDir, tag + ".ol_ac_psrrn.txt", 2);

    cl_op      = parse_file(baseDir, tag + ".cl_op.txt", 6);
    cl_swing   = parse_file(baseDir, tag + ".cl_swing.txt", 3);
    cl_slew    = parse_file(baseDir, tag + ".cl_slew.txt", 2);

    R = empty_result(tag);

    %% OP
    op = ol_op.data(end,:);

    R.AVDD = op(1);
    ol_inp = op(2);
    ol_inn = op(3);
    R.Idd_OL = abs(op(6));
    R.Ibias = abs(op(7));

    cl = cl_op.data(end,:);

    cl_avdd = cl(1);
    cl_inp  = cl(2);
    cl_out  = cl(3);
    R.Idd_CL = abs(cl(5));

    R.Ibias_uA = R.Ibias * 1e6;
    R.Idd_uA = R.Idd_CL * 1e6;
    R.Power_mW = cl_avdd * R.Idd_CL * 1e3;

    R.Vin_cm = 0.5 * (ol_inp + ol_inn);
    R.Vout_DC = cl_out;

    %% Input offset
    off_inp = ol_offset.data(:,1);
    off_inn = ol_offset.data(:,2);
    off_out = ol_offset.data(:,3);

    vcm = avddSet / 2;
    off_vid = off_inp - off_inn;

    outErr = off_out - vcm;
    idxList = find(outErr(1:end-1).*outErr(2:end) <= 0);

    if ~isempty(idxList)
        offsetCandidates = NaN(numel(idxList), 1);

        for n = 1:numel(idxList)
            idx = idxList(n);
            y1 = off_out(idx);
            y2 = off_out(idx+1);

            if y2 == y1
                if y1 == vcm
                    alpha = 0;
                else
                    continue;
                end
            else
                alpha = (vcm - y1) / (y2 - y1);
            end

            if alpha >= 0 && alpha <= 1
                inp_cross = off_inp(idx) + alpha * (off_inp(idx+1) - off_inp(idx));
                inn_cross = off_inn(idx) + alpha * (off_inn(idx+1) - off_inn(idx));
                offsetCandidates(n) = inp_cross - inn_cross;
            end
        end

        offsetCandidates = offsetCandidates(isfinite(offsetCandidates));

        if ~isempty(offsetCandidates)
            [~, bestIdx] = min(abs(offsetCandidates));
            R.Input_offset_V = offsetCandidates(bestIdx);
            R.offset_vid = R.Input_offset_V;
            R.offset_out = vcm;
        end
    end

    if ~isfinite(R.Input_offset_V)
        [~, idxNear] = min(abs(outErr));
        R.Input_offset_V = off_vid(idxNear);
        R.offset_vid = off_vid(idxNear);
        R.offset_out = off_out(idxNear);
    end

    R.Input_offset_mV = R.Input_offset_V * 1e3;

    R.vid_offset = off_vid;
    R.out_offset = off_out;

    %% Gain and phase
    R.f = ol_ac_diff.scale;
    R.gain_dB = ol_ac_diff.data(:,1);
    phase_rad = ol_ac_diff.data(:,2);
    phase_deg = phase_rad * 180/pi;

    R.DC_gain_dB = interp_log(R.f, R.gain_dB, 1);

    phase_unwrap = unwrap(phase_deg*pi/180)*180/pi;
    R.phase_rel = phase_unwrap - phase_unwrap(1);

    idxUGF = find(R.gain_dB(1:end-1) >= 0 & R.gain_dB(2:end) <= 0, 1, "first");

    if ~isempty(idxUGF)
        logUGF = interp1(R.gain_dB(idxUGF:idxUGF+1), log10(R.f(idxUGF:idxUGF+1)), 0);
        R.UGF_Hz = 10^logUGF;
        phaseUGF = interp_log(R.f, R.phase_rel, R.UGF_Hz);
        R.PM_deg = 180 + phaseUGF;
    else
        R.UGF_Hz = NaN;
        R.PM_deg = NaN;
    end

    R.UGF_MHz = R.UGF_Hz / 1e6;

    %% CMRR
    cmDB = ol_ac_cm.data(:,1);
    cmInterp = interp1(log10(ol_ac_cm.scale), cmDB, log10(R.f), "linear", "extrap");
    R.CMRR_curve = R.gain_dB - cmInterp;

    R.CMRR_1   = interp_log(R.f, R.CMRR_curve, 1);
    R.CMRR_60  = interp_log(R.f, R.CMRR_curve, 60);
    R.CMRR_150 = interp_log(R.f, R.CMRR_curve, 150);
    R.CMRR_1k  = interp_log(R.f, R.CMRR_curve, 1e3);

    %% PSRR+
    pspDB = ol_psp.data(:,1);
    pspInterp = interp1(log10(ol_psp.scale), pspDB, log10(R.f), "linear", "extrap");
    R.PSRRP_curve = R.gain_dB - pspInterp;

    R.PSRRP_1   = interp_log(R.f, R.PSRRP_curve, 1);
    R.PSRRP_60  = interp_log(R.f, R.PSRRP_curve, 60);
    R.PSRRP_150 = interp_log(R.f, R.PSRRP_curve, 150);
    R.PSRRP_1k  = interp_log(R.f, R.PSRRP_curve, 1e3);

    %% PSRR-
    psnDB = ol_psn.data(:,1);
    psnInterp = interp1(log10(ol_psn.scale), psnDB, log10(R.f), "linear", "extrap");
    R.PSRRN_curve = R.gain_dB - psnInterp;

    R.PSRRN_1   = interp_log(R.f, R.PSRRN_curve, 1);
    R.PSRRN_60  = interp_log(R.f, R.PSRRN_curve, 60);
    R.PSRRN_150 = interp_log(R.f, R.PSRRN_curve, 150);
    R.PSRRN_1k  = interp_log(R.f, R.PSRRN_curve, 1e3);

    %% Noise total
    noiseTotalFile = find_file(baseDir, tag + ".ol_noise_total.txt");

    if noiseTotalFile ~= ""
        nt = parse_file(baseDir, tag + ".ol_noise_total.txt", 2);
        R.Input_noise_Vrms = abs(nt.data(end,1));
    else
        R.Input_noise_Vrms = NaN;
    end

    R.Input_noise_uVrms = R.Input_noise_Vrms * 1e6;

    %% CL swing and input common-mode range
    R.sw_inp = cl_swing.data(:,1);
    R.sw_out = cl_swing.data(:,2);
    R.sw_idd = abs(cl_swing.data(:,3));

    sw_err = R.sw_out - R.sw_inp;
    valid = abs(sw_err) <= swingErrLimit;
    valid = largest_true_run(valid);

    if any(valid)
        R.Input_cm_min = min(R.sw_inp(valid));
        R.Input_cm_max = max(R.sw_inp(valid));
        R.Output_swing_min = min(R.sw_out(valid));
        R.Output_swing_max = max(R.sw_out(valid));
    else
        R.Input_cm_min = NaN;
        R.Input_cm_max = NaN;
        R.Output_swing_min = NaN;
        R.Output_swing_max = NaN;
    end

    R.sw_gain = gradient(R.sw_out) ./ gradient(R.sw_inp);

    %% Slew and settling
    R.t_slew = cl_slew.scale;
    R.slew_inp = cl_slew.data(:,1);
    R.slew_out = cl_slew.data(:,2);

    t10r = cross_time(R.t_slew, R.slew_out, slewLow_V, "rise");
    t90r = cross_time(R.t_slew, R.slew_out, slewHigh_V, "rise");
    t90f = cross_time(R.t_slew, R.slew_out, slewHigh_V, "fall");
    t10f = cross_time(R.t_slew, R.slew_out, slewLow_V, "fall");

    R.t10r = t10r;
    R.t90r = t90r;
    R.t90f = t90f;
    R.t10f = t10f;

    slewDelta_V = slewHigh_V - slewLow_V;

    if isfinite(t10r) && isfinite(t90r) && t90r > t10r
        R.SR_rise_Vus = slewDelta_V / (t90r - t10r) / 1e6;
    end

    if isfinite(t90f) && isfinite(t10f) && t10f > t90f
        R.SR_fall_Vus = slewDelta_V / (t10f - t90f) / 1e6;
    end

    R.Settling_ns = settling_ns(R.t_slew, R.slew_out, settleFinal_V, ...
                                settleStart_s, settleEnd_s, settleErr);

end

function S = parse_file(baseDir, filename, nVec)
    fp = find_file(baseDir, filename);

    if fp == ""
        error("Missing file: %s", fullfile(baseDir, filename));
    end

    raw = read_ng(fp);
    [scale, data] = parse_wrdata(raw, nVec);

    S.scale = scale;
    S.data = data;
end

function fp = find_file(baseDir, filename)
    fp1 = fullfile(baseDir, filename);

    if isfile(fp1)
        fp = fp1;
        return;
    end

    d = dir(baseDir);
    fp = "";

    for i = 1:numel(d)
        if strcmpi(d(i).name, filename)
            fp = fullfile(baseDir, d(i).name);
            return;
        end
    end
end

function M = read_ng(filename)
    txt = fileread(filename);
    lines = regexp(txt, "\r\n|\n|\r", "split");

    rows = {};
    maxCols = 0;

    numPattern = '[-+]?(?:\d+\.\d*|\.\d+|\d+)(?:[eE][-+]?\d+)?';

    for i = 1:numel(lines)
        tokens = regexp(lines{i}, numPattern, "match");

        if isempty(tokens)
            continue;
        end

        nums = str2double(tokens);

        if all(isfinite(nums))
            rows{end+1} = nums; %#ok<AGROW>
            maxCols = max(maxCols, numel(nums));
        end
    end

    if isempty(rows)
        error("No numeric data found in %s", filename);
    end

    M = NaN(numel(rows), maxCols);

    for i = 1:numel(rows)
        M(i,1:numel(rows{i})) = rows{i};
    end

    good = sum(isfinite(M),2) == maxCols;
    M = M(good,:);
end

function [scale, data] = parse_wrdata(M, nVec)
    nCol = size(M,2);

    if nCol == nVec + 1
        scale = M(:,1);
        data = M(:,2:end);

    elseif nCol == 2*nVec
        scale = M(:,1);
        data = M(:,2:2:end);

    elseif nCol >= nVec + 1
        scale = M(:,1);
        data = M(:,end-nVec+1:end);

    elseif nCol == nVec
        scale = (1:size(M,1)).';
        data = M;

    else
        error("Cannot parse wrdata. Columns=%d, vectors=%d", nCol, nVec);
    end
end

function y0 = interp_log(f, y, f0)
    y0 = interp1(log10(f), y, log10(f0), "linear", "extrap");
end

function tc = cross_time(t, y, level, type)
    switch type
        case "rise"
            idx = find(y(1:end-1) < level & y(2:end) >= level, 1, "first");

        case "fall"
            idx = find(y(1:end-1) > level & y(2:end) <= level, 1, "first");

        otherwise
            error("type must be rise or fall");
    end

    if isempty(idx)
        tc = NaN;
    else
        tc = interp1(y(idx:idx+1), t(idx:idx+1), level);
    end
end

function ts = settling_ns(t, y, finalVal, tStart, tEnd, errBand)
    idx = find(t >= tStart & t <= tEnd);

    if isempty(idx)
        ts = NaN;
        return;
    end

    tw = t(idx);
    yw = y(idx);

    good = abs(yw - finalVal) <= errBand;
    ts_s = NaN;

    for k = 1:numel(good)
        if good(k) && all(good(k:end))
            ts_s = tw(k) - tStart;
            break;
        end
    end

    ts = ts_s * 1e9;
end

function valid2 = largest_true_run(valid)
    valid = valid(:);

    d = diff([false; valid; false]);
    starts = find(d == 1);
    stops  = find(d == -1) - 1;

    if isempty(starts)
        valid2 = valid;
        return;
    end

    [~, k] = max(stops - starts + 1);

    valid2 = false(size(valid));
    valid2(starts(k):stops(k)) = true;
end

function labelCmRange(R)
    if isfinite(R.Input_cm_min) && isfinite(R.Input_cm_max)
        xline(R.Input_cm_min, "--", sprintf("Lo %.3f", R.Input_cm_min));
        xline(R.Input_cm_max, "--", sprintf("Hi %.3f", R.Input_cm_max));
    end
end

function labelLogPoint(f, y, f0, labelText)
    annotationColor = [1 0 0];
    annotationTextColor = [0 0 0];
    annotationBackgroundColor = [1 1 1];

    if isempty(f) || isempty(y) || ~isfinite(f0)
        return;
    end

    y0 = interp_log(f, y, f0);

    if ~isfinite(y0)
        return;
    end

    plot(f0, y0, "o", "Color", annotationColor, "MarkerFaceColor", annotationColor);
    text(f0, y0, sprintf(" %s %.1f", labelText, y0), ...
         "VerticalAlignment", "bottom", ...
         "Color", annotationTextColor, ...
         "BackgroundColor", annotationBackgroundColor, ...
         "Margin", 1);
end

function labelSlewSegment(t, y, t1, t2, slewRate, labelText)
    annotationColor = [1 0 0];
    annotationTextColor = [0 0 0];
    annotationBackgroundColor = [1 1 1];

    if ~isfinite(t1) || ~isfinite(t2) || ~isfinite(slewRate)
        return;
    end

    t_us = [t1 t2] * 1e6;
    y_seg = interp1(t, y, [t1 t2], "linear", "extrap");
    t_mid_us = mean(t_us);
    y_mid = mean(y_seg);

    plot(t_mid_us, y_mid, "o", "Color", annotationColor, "MarkerFaceColor", annotationColor);
    label = sprintf(" %s %.2fV/us", labelText, slewRate);
    label = regexprep(char(label), "\r|\n", " ");

    text(t_mid_us, y_mid, label, ...
         "VerticalAlignment", "bottom", ...
         "HorizontalAlignment", "left", ...
         "Color", annotationTextColor, ...
         "BackgroundColor", annotationBackgroundColor, ...
         "Margin", 1, ...
         "Interpreter", "none");
end

function s = fmt(x, f)
    if isnan(x) || isinf(x)
        s = "N/A";
    else
        s = string(sprintf(f, x));
    end
end

function s = fmt_range(a, b, f)
    if isnan(a) || isnan(b)
        s = "N/A";
    else
        s = string(sprintf(f, a)) + "–" + string(sprintf(f, b));
    end
end
