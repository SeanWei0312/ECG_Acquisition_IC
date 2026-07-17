% SE OTA nominal analysis
clear; clc; close all;

annotationColor = [1 0 0];
annotationTextColor = [0 0 0];
annotationBackgroundColor = [1 1 1];
format shortEng;

scriptDir = fileparts(mfilename('fullpath'));
baseDir = scriptDir;
plotDir = fullfile(baseDir, "Plots");

if ~exist(plotDir, "dir")
    mkdir(plotDir);
end

tag = "NOM";

swingErrLimit = 2e-3;      % valid unity-gain range: |Vout - Vin| <= 2 mV
icmrOffsetLimit = 5e-3;    % valid ICMR point: required |Vin,diff| <= 5 mV
icmrCurrentTol = 0.10;     % valid ICMR point: IDD/Ibias within +/-10% of nominal
icmrGainDrop_dB = 3;       % valid ICMR point: local gain no more than 3 dB below nominal
settleErr = 5e-3;          % settling band around final output value
settleStart_s = 1e-6;      % rising step starts at 1 us
settleFinal_V = NaN;       % NaN means use final waveform average
settleEnd_s = 10e-6;
CLoad_pF = 10;

fprintf("Analyzing %s...\n", tag);
N = analyze_one_safe(baseDir, tag, swingErrLimit, ...
                     icmrOffsetLimit, icmrCurrentTol, icmrGainDrop_dB, ...
                     settleErr, settleStart_s, settleFinal_V, settleEnd_s);

%% =========================================================
% Summary table
% =========================================================
rows = [
    "Set conditions",          "",      ""
    "AVDD",                    "V",     fmt(N.AVDD, "%.3f")
    "Bias current",            "uA",    fmt(N.Ibias_uA, "%.3f")
    "CLoad",                   "pF",    fmt(CLoad_pF, "%.0f")
    "Vin,cm",                  "V",     fmt(N.Vin_cm, "%.4f")
    "Vout target",             "V",     fmt(N.AVDD/2, "%.4f")
    "Closed-loop gain",        "V/V",   "1"
    "",                        "",      ""
    "Operating",               "",      ""
    "Total current",           "uA",    fmt(N.Idd_uA, "%.3f")
    "Total power",             "mW",    fmt(N.Power_mW, "%.4f")
    "Vout,DC",                 "V",     fmt(N.Vout_DC, "%.4f")
    "",                        "",      ""
    "Open-loop",               "",      ""
    "DC gain",                 "dB",    fmt(N.DC_gain_dB, "%.2f")
    "UGF",                     "MHz",   fmt(N.UGF_MHz, "%.4f")
    "Phase margin",            "deg",   fmt(N.PM_deg, "%.2f")
    "",                        "",      ""
    "Noise/Offset",            "",      ""
    "Input offset",            "mV",    fmt(N.Input_offset_mV, "%.3f")
    "Input noise",             "uVrms", fmt(N.Input_noise_uVrms, "%.3f")
    "",                        "",      ""
    "Rejection",               "",      ""
    "CMRR @ 1 Hz",             "dB",    fmt(N.CMRR_1, "%.2f")
    "CMRR @ 60 Hz",            "dB",    fmt(N.CMRR_60, "%.2f")
    "CMRR @ 150 Hz",           "dB",    fmt(N.CMRR_150, "%.2f")
    "CMRR @ 1 kHz",            "dB",    fmt(N.CMRR_1k, "%.2f")
    "PSRR+ @ 1 Hz",            "dB",    fmt(N.PSRRP_1, "%.2f")
    "PSRR+ @ 60 Hz",           "dB",    fmt(N.PSRRP_60, "%.2f")
    "PSRR+ @ 150 Hz",          "dB",    fmt(N.PSRRP_150, "%.2f")
    "PSRR+ @ 1 kHz",           "dB",    fmt(N.PSRRP_1k, "%.2f")
    "PSRR- @ 1 Hz",            "dB",    fmt(N.PSRRN_1, "%.2f")
    "PSRR- @ 60 Hz",           "dB",    fmt(N.PSRRN_60, "%.2f")
    "PSRR- @ 150 Hz",          "dB",    fmt(N.PSRRN_150, "%.2f")
    "PSRR- @ 1 kHz",           "dB",    fmt(N.PSRRN_1k, "%.2f")
    "",                        "",      ""
    "Closed-loop",             "",      ""
    "Input CM low",            "V",     fmt(N.Input_cm_min, "%.3f")
    "Input CM high",           "V",     fmt(N.Input_cm_max, "%.3f")
    "Output swing low",        "V",     fmt(N.Output_swing_min, "%.3f")
    "Output swing high",       "V",     fmt(N.Output_swing_max, "%.3f")
    "Slew rate rising",        "V/us",  fmt(N.SR_rise_Vus, "%.3f")
    "Slew rate falling",       "V/us",  fmt(N.SR_fall_Vus, "%.3f")
    "Settling time",           "ns",    fmt(N.Settling_ns, "%.2f")
];

Result = table(rows(:,1),rows(:,2),rows(:,3), ...
    'VariableNames',{'Parameter','Unit','Value'});

fprintf("\n================ SE OTA NOMINAL SUMMARY ================\n");
disp(Result);
writetable(Result,fullfile(scriptDir,'NOM.SE_OTA_summary.csv'));
fprintf("\nSaved table:\n%s\n", fullfile(scriptDir,'NOM.SE_OTA_summary.csv'));

%% =========================================================
% Plot nominal results
% =========================================================
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
    set(gca, "Layer", "bottom");
    title("SE OTA Open-Loop Gain and Phase");

    if isfinite(N.UGF_Hz)
        ugf_MHz = N.UGF_Hz / 1e6;
        phaseAtUGF = interp_log(N.f, N.phase_rel, N.UGF_Hz);

        yyaxis left;
        xline(N.UGF_Hz, "--", "fu", "HandleVisibility", "off");
        plot(N.UGF_Hz, 0, "o", "Color", annotationColor, ...
             "MarkerFaceColor", annotationColor, "HandleVisibility", "off");
        hText = text(N.UGF_Hz, 0, sprintf(" fu: %.3fMHz", ugf_MHz), ...
             "VerticalAlignment", "bottom", ...
             "Color", annotationTextColor);
        styleAnnotationText(hText, annotationBackgroundColor);

        yyaxis right;
        plot(N.UGF_Hz, phaseAtUGF, "s", "Color", annotationColor, ...
             "MarkerFaceColor", annotationColor, "HandleVisibility", "off");
        hText = text(N.UGF_Hz, phaseAtUGF, sprintf(" PM: %.1fdeg", N.PM_deg), ...
             "VerticalAlignment", "top", ...
             "Color", annotationTextColor);
        styleAnnotationText(hText, annotationBackgroundColor);
    end
else
    text(0.1, 0.5, "NOM AC data missing");
    axis off;
    title("SE OTA Open-Loop Gain and Phase");
end
saveas(gcf, fullfile(plotDir, "NOM.open_loop_gain_phase.png"));

% 2 Closed-loop step response
figure;
if ~isempty(N.t_slew)
    plot(N.t_slew*1e6, N.slew_inp, "--", "LineWidth", 1.2);
    hold on;
    plot(N.t_slew*1e6, N.slew_out, "LineWidth", 1.5);
    grid on;
    xlabel("Time (us)");
    ylabel("Voltage (V)");
    title("SE OTA Closed-Loop Step Response");
    legend("Vin", "Vout", "Location", "best");

    if isfinite(N.Settling_ns)
        settleTime_us = settleStart_s * 1e6 + N.Settling_ns / 1e3;
        settleV = interp1(N.t_slew*1e6, N.slew_out, settleTime_us, "linear", "extrap");
        plot(settleTime_us, settleV, "o", "Color", annotationColor, ...
             "MarkerFaceColor", annotationColor, "HandleVisibility", "off");
        hText = text(settleTime_us, settleV, sprintf(" Ts: %.1fns", N.Settling_ns), ...
             "VerticalAlignment", "bottom", ...
             "Color", annotationTextColor);
        styleAnnotationText(hText, annotationBackgroundColor);
    end

    labelSlewSegment(N.t_slew, N.slew_out, N.t10r, N.t90r, ...
                     N.SR_rise_Vus, "SR+");
    labelSlewSegment(N.t_slew, N.slew_out, N.t90f, N.t10f, ...
                     N.SR_fall_Vus, "SR-");
else
    text(0.1, 0.5, "NOM slew data missing");
    axis off;
    title("SE OTA Closed-Loop Step Response");
end
saveas(gcf, fullfile(plotDir, "NOM.closed_loop_step_response.png"));

% 3 Output swing / DC transfer
figure;
if ~isempty(N.sw_inp)
    plot(N.sw_inp, N.sw_err*1e3, "LineWidth", 1.5);
    hold on;
    yline(swingErrLimit*1e3, "--", "+2mV", "HandleVisibility", "off");
    yline(-swingErrLimit*1e3, "--", "-2mV", "HandleVisibility", "off");
    grid on;
    xlabel("Vin (V)");
    ylabel("Vout - Vin (mV)");
    title("SE OTA Output Swing / DC Tracking Error");

    if isfinite(N.CL_input_min) && isfinite(N.CL_input_max)
        xline(N.CL_input_min, "--", sprintf("Vin,min: %.3fV", N.CL_input_min), ...
              "HandleVisibility", "off");
        xline(N.CL_input_max, "--", sprintf("Vin,max: %.3fV", N.CL_input_max), ...
              "HandleVisibility", "off");
    end
else
    text(0.1, 0.5, "NOM closed-loop DC data missing");
    axis off;
    title("SE OTA Output Swing / DC Tracking Error");
end
saveas(gcf, fullfile(plotDir, "NOM.output_swing_tracking_error.png"));

% 4 Input common-mode range
figure;
if ~isempty(N.icmr_line_vcm)
    isForcedIcmr = startsWith(N.icmr_line_mode, "forced_vout");
    icmrAll = isfinite(N.icmr_line_vcm) & isfinite(N.icmr_line_idd);
    icmrGain = icmrAll & isfinite(N.icmr_line_gain);
    icmrValid = icmrAll & N.icmr_line_valid;

    tiledlayout(3,1);

    ax1 = nexttile;
    if isForcedIcmr
        plot(N.icmr_line_vcm(icmrAll), N.icmr_line_vid(icmrAll)*1e3, "LineWidth", 1.2);
        hold on;
        plot(N.icmr_line_vcm(icmrValid), N.icmr_line_vid(icmrValid)*1e3, ...
             "Color", annotationColor, "LineWidth", 2.0);
        ylabel("Req. Vin,diff (mV)");
    else
        plot(N.icmr_line_vcm(icmrAll), N.icmr_line_out(icmrAll), "LineWidth", 1.2);
        hold on;
        yline(N.AVDD/2, "--", sprintf("VDD/2: %.3fV", N.AVDD/2), ...
              "HandleVisibility", "off");
        ylabel("Vout,DC (V)");
    end
    grid on;
    title("SE OTA Input Common-Mode Range");
    labelCmRange(N);
    labelNoValidIcmr(N, icmrValid);

    ax2 = nexttile;
    plot(N.icmr_line_vcm(icmrAll), N.icmr_line_idd(icmrAll)*1e6, ...
         "LineWidth", 1.2, "DisplayName", "IDD");
    hold on;
    plot(N.icmr_line_vcm(icmrValid), N.icmr_line_idd(icmrValid)*1e6, ...
         "Color", annotationColor, "LineWidth", 2.0, "HandleVisibility", "off");
    if any(isfinite(N.icmr_line_ibias))
        plot(N.icmr_line_vcm(icmrAll), N.icmr_line_ibias(icmrAll)*1e6, ...
             "--", "LineWidth", 1.2, "DisplayName", "Ibias");
    end
    grid on;
    ylabel("Current (uA)");
    legend("Location", "best");
    labelCmRange(N);

    ax3 = nexttile;
    if any(icmrGain)
        plot(N.icmr_line_vcm(icmrGain), abs(N.icmr_line_gain(icmrGain)), "LineWidth", 1.2);
        hold on;
        plot(N.icmr_line_vcm(icmrValid & icmrGain), abs(N.icmr_line_gain(icmrValid & icmrGain)), ...
             "Color", annotationColor, "LineWidth", 2.0);
        grid on;
        xlabel("Vin,cm (V)");
        ylabel("Diff gain (V/V)");
        labelCmRange(N);
    else
        text(0.5, 0.5, "Local gain data missing", ...
             "HorizontalAlignment", "center", ...
             "Units", "normalized");
        axis off;
        xlabel("Vin,cm (V)");
        ylabel("Diff gain (V/V)");
    end
    linkaxes([ax1 ax2 ax3], "x");
else
    text(0.1, 0.5, "NOM ICMR data missing");
    axis off;
    title("SE OTA Input Common-Mode Range");
end
saveas(gcf, fullfile(plotDir, "NOM.input_common_mode_range.png"));

% 5 CMRR
figure;
if ~isempty(N.f)
    semilogx(N.f, N.CMRR_curve, "LineWidth", 1.5);
    hold on;
    grid on;
    xlabel("Frequency (Hz)");
    ylabel("CMRR (dB)");
    title("SE OTA CMRR");
    labelLogCursor(N.f, N.CMRR_curve, 1, "1Hz");
    labelLogCursor(N.f, N.CMRR_curve, 60, "60Hz");
    labelLogCursor(N.f, N.CMRR_curve, 150, "150Hz");
    labelLogCursor(N.f, N.CMRR_curve, 1e3, "1kHz");
else
    text(0.1, 0.5, "NOM CMRR data missing");
    axis off;
    title("SE OTA CMRR");
end
saveas(gcf, fullfile(plotDir, "NOM.cmrr.png"));

% 6 PSRR+ and PSRR-
figure;
if ~isempty(N.f)
    tiledlayout(2,1);

    ax1 = nexttile;
    semilogx(N.f, N.PSRRP_curve, "LineWidth", 1.5);
    hold on;
    grid on;
    ylabel("PSRR+ (dB)");
    title("SE OTA PSRR+");
    labelLogCursor(N.f, N.PSRRP_curve, 1, "1Hz");
    labelLogCursor(N.f, N.PSRRP_curve, 60, "60Hz");
    labelLogCursor(N.f, N.PSRRP_curve, 150, "150Hz");
    labelLogCursor(N.f, N.PSRRP_curve, 1e3, "1kHz");

    ax2 = nexttile;
    semilogx(N.f, N.PSRRN_curve, "LineWidth", 1.5);
    hold on;
    grid on;
    xlabel("Frequency (Hz)");
    ylabel("PSRR- (dB)");
    title("SE OTA PSRR-");
    labelLogCursor(N.f, N.PSRRN_curve, 1, "1Hz");
    labelLogCursor(N.f, N.PSRRN_curve, 60, "60Hz");
    labelLogCursor(N.f, N.PSRRN_curve, 150, "150Hz");
    labelLogCursor(N.f, N.PSRRN_curve, 1e3, "1kHz");
    linkaxes([ax1 ax2], "x");
else
    text(0.1, 0.5, "NOM PSRR data missing");
    axis off;
    title("SE OTA PSRR");
end
saveas(gcf, fullfile(plotDir, "NOM.psrr.png"));

% 7 Input-referred noise density
figure;
if ~isempty(N.noise_f)
    loglog(N.noise_f, N.noise_in, "LineWidth", 1.5);
    hold on;
    grid on;
    xlabel("Frequency (Hz)");
    ylabel("Input noise (V/sqrt(Hz))");
    title("SE OTA Input-Referred Noise Density");
    labelLogNoiseCursor(N.noise_f, N.noise_in, 1, "1Hz");
    labelLogNoiseCursor(N.noise_f, N.noise_in, 60, "60Hz");
    labelLogNoiseCursor(N.noise_f, N.noise_in, 150, "150Hz");
else
    text(0.1, 0.5, "NOM noise spectrum data missing");
    axis off;
    title("SE OTA Input-Referred Noise Density");
end
saveas(gcf, fullfile(plotDir, "NOM.input_referred_noise_density.png"));

% 8 Open-loop VTC
figure;
if ~isempty(N.vtc_vid)
    plot(N.vtc_vid*1e3, N.vtc_out, "LineWidth", 1.5);
    hold on;
    if isfinite(N.offset_vid)
        xline(N.offset_vid*1e3, "--", sprintf("Vos: %.3fmV", N.Input_offset_mV), ...
              "HandleVisibility", "off");
    end
    yline(N.AVDD/2, "--", sprintf("Vo=VDD/2: %.3fV", N.AVDD/2), ...
          "HandleVisibility", "off");
    grid on;
    xlabel("Vin,diff (mV)");
    ylabel("Vout (V)");
    title("SE OTA Open-Loop VTC");
else
    text(0.1, 0.5, "NOM open-loop VTC data missing");
    axis off;
    title("SE OTA Open-Loop VTC");
end
saveas(gcf, fullfile(plotDir, "NOM.open_loop_vtc.png"));

% 9 Closed-loop VTC
figure;
if ~isempty(N.sw_inp)
    plot(N.sw_inp, N.sw_out, "LineWidth", 1.5);
    hold on;
    plot(N.sw_inp, N.sw_inp, "--", "LineWidth", 1.0);
    grid on;
    xlabel("Vin (V)");
    ylabel("Vout (V)");
    title("SE OTA Closed-Loop VTC");
    labelOutputSwingRange(N);
    legend("Vout", "Ideal Vout = Vin", "Location", "best");
else
    text(0.1, 0.5, "NOM closed-loop DC data missing");
    axis off;
    title("SE OTA Closed-Loop VTC");
end
saveas(gcf, fullfile(plotDir, "NOM.closed_loop_vtc.png"));

fprintf("\nSaved plots in:\n%s\n", plotDir);

%% =========================================================
% Functions
% =========================================================
function R = analyze_one_safe(baseDir, tag, swingErrLimit, ...
                              icmrOffsetLimit, icmrCurrentTol, icmrGainDrop_dB, settleErr, ...
                              settleStart_s, settleFinal_V, settleEnd_s)
    try
        R = analyze_one(baseDir, tag, swingErrLimit, ...
                        icmrOffsetLimit, icmrCurrentTol, icmrGainDrop_dB, settleErr, ...
                        settleStart_s, settleFinal_V, settleEnd_s);
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
    R.CL_input_min = NaN;
    R.CL_input_max = NaN;
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
    R.noise_f = [];
    R.noise_in = [];
    R.vtc_vid = [];
    R.vtc_out = [];
    R.t_slew = [];
    R.slew_inp = [];
    R.slew_out = [];

    R.icmr_line_vcm = [];
    R.icmr_line_vid = [];
    R.icmr_line_out = [];
    R.icmr_line_idd = [];
    R.icmr_line_ibias = [];
    R.icmr_line_gain = [];
    R.icmr_line_valid = [];
    R.icmr_line_mode = "";

    R.sw_inp = [];
    R.sw_out = [];
    R.sw_err = [];
    R.sw_idd = [];
    R.sw_ivss = [];
    R.sw_gain = [];

end

function R = analyze_one(baseDir, tag, swingErrLimit, ...
                         icmrOffsetLimit, icmrCurrentTol, icmrGainDrop_dB, settleErr, ...
                         settleStart_s, settleFinal_V, settleEnd_s)

    ol_op    = parse_file(baseDir, tag + ".op.txt", 10);
    ol_vtc   = parse_file(baseDir, tag + ".ol_vtc.txt", 7);
    ol_ac    = parse_file(baseDir, tag + ".ol_ac.txt", 5);
    cm_ac    = parse_file(baseDir, tag + ".cm_ac.txt", 2);
    psrrp_ac = parse_file(baseDir, tag + ".psrrp_ac.txt", 2);
    psrrn_ac = parse_file(baseDir, tag + ".psrrn_ac.txt", 2);

    cl_dc   = parse_file(baseDir, tag + ".cl_dc.txt", 5);
    cl_tran = parse_file(baseDir, tag + ".cl_tran.txt", 4);

    R = empty_result(tag);

    %% OP
    op = ol_op.data(end,:);

    vdd = op(1);
    vss = op(2);
    op_vcm = op(3);
    ol_inp = op(5);
    ol_inn = op(6);
    R.Ibias = abs(op(8));
    R.Idd_OL = abs(op(9));
    R.AVDD = vdd - vss;

    cl_vin = cl_dc.data(:,1);
    cl_out = cl_dc.data(:,2);
    cl_idd = abs(cl_dc.data(:,4));
    vcm = op_vcm;
    cl_idd_nom = interp1(cl_vin, cl_idd, vcm, "linear", "extrap");

    R.Ibias_uA = R.Ibias * 1e6;
    R.Idd_uA = cl_idd_nom * 1e6;
    R.Power_mW = R.AVDD * cl_idd_nom * 1e3;

    R.Vin_cm = 0.5 * (ol_inp + ol_inn);
    R.vtc_vid = ol_vtc.data(:,1);
    R.vtc_out = ol_vtc.data(:,4);
    R.Vout_DC = interp1(cl_vin, cl_out, vss + R.AVDD/2, "linear", "extrap");

    %% Open-loop ICMR and differential DC sweeps
    icmrLine = read_icmr_line(baseDir, tag, R.AVDD/2);

    R.icmr_line_vcm = icmrLine.vcm;
    R.icmr_line_vid = icmrLine.vid;
    R.icmr_line_out = icmrLine.vout;
    R.icmr_line_idd = icmrLine.idd;
    R.icmr_line_ibias = icmrLine.ibias;
    R.icmr_line_gain = icmrLine.gain;
    R.icmr_line_mode = icmrLine.mode;

    offsetIdx = nearest_index(icmrLine.vcm, vcm, icmrLine.valid);

    if isfinite(offsetIdx)
        R.Input_offset_V = icmrLine.vid(offsetIdx);
        R.offset_vid = R.Input_offset_V;
        R.offset_out = icmrLine.vout(offsetIdx);
    end

    R.Input_offset_mV = abs(R.Input_offset_V) * 1e3;

    nominalIdx = nominal_icmr_index(icmrLine.vcm, icmrLine.idd, ...
                                    icmrLine.gain, vcm);
    icmrValid = false(size(icmrLine.valid));

    isForcedIcmr = startsWith(icmrLine.mode, "forced_vout");

    if isForcedIcmr && isfinite(nominalIdx)
        iddNom = icmrLine.idd(nominalIdx);
        minIdd = iddNom * (1 - icmrCurrentTol);
        maxIdd = iddNom * (1 + icmrCurrentTol);

        icmrValid = icmrLine.valid & ...
                    abs(icmrLine.vid) <= icmrOffsetLimit & ...
                    icmrLine.idd >= minIdd & icmrLine.idd <= maxIdd;

        if isfinite(icmrLine.ibias(nominalIdx))
            ibiasNom = icmrLine.ibias(nominalIdx);
            minIbias = ibiasNom * (1 - icmrCurrentTol);
            maxIbias = ibiasNom * (1 + icmrCurrentTol);
            icmrValid = icmrValid & ...
                        icmrLine.ibias >= minIbias & icmrLine.ibias <= maxIbias;
        end

        if isfinite(icmrLine.gain(nominalIdx))
            gainNom = abs(icmrLine.gain(nominalIdx));
            minGain = gainNom * 10^(-icmrGainDrop_dB/20);
            icmrValid = icmrValid & abs(icmrLine.gain) >= minGain;
        end

        icmrValid = true_run_containing_x(icmrValid, icmrLine.vcm, vcm);
    end

    R.icmr_line_valid = icmrValid;

    if any(icmrValid)
        R.Input_cm_min = min(R.icmr_line_vcm(icmrValid));
        R.Input_cm_max = max(R.icmr_line_vcm(icmrValid));
    end

    %% Gain and phase
    R.f = ol_ac.scale;
    ad = complex(ol_ac.data(:,1), ol_ac.data(:,2));
    R.gain_dB = complex_db(real(ad), imag(ad));
    phase_deg = unwrap(angle(ad)) * 180/pi;

    R.DC_gain_dB = interp_log(R.f, R.gain_dB, 1);

    R.phase_rel = phase_deg - phase_deg(1);

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
    cmDB = complex_db(cm_ac.data(:,1), cm_ac.data(:,2));
    cmInterp = interp1(log10(cm_ac.scale), cmDB, log10(R.f), "linear", "extrap");
    R.CMRR_curve = R.gain_dB - cmInterp;

    R.CMRR_1   = interp_log(R.f, R.CMRR_curve, 1);
    R.CMRR_60  = interp_log(R.f, R.CMRR_curve, 60);
    R.CMRR_150 = interp_log(R.f, R.CMRR_curve, 150);
    R.CMRR_1k  = interp_log(R.f, R.CMRR_curve, 1e3);

    %% PSRR+
    pspDB = complex_db(psrrp_ac.data(:,1), psrrp_ac.data(:,2));
    pspInterp = interp1(log10(psrrp_ac.scale), pspDB, log10(R.f), "linear", "extrap");
    R.PSRRP_curve = R.gain_dB - pspInterp;

    R.PSRRP_1   = interp_log(R.f, R.PSRRP_curve, 1);
    R.PSRRP_60  = interp_log(R.f, R.PSRRP_curve, 60);
    R.PSRRP_150 = interp_log(R.f, R.PSRRP_curve, 150);
    R.PSRRP_1k  = interp_log(R.f, R.PSRRP_curve, 1e3);

    %% PSRR-
    psnDB = complex_db(psrrn_ac.data(:,1), psrrn_ac.data(:,2));
    psnInterp = interp1(log10(psrrn_ac.scale), psnDB, log10(R.f), "linear", "extrap");
    R.PSRRN_curve = R.gain_dB - psnInterp;

    R.PSRRN_1   = interp_log(R.f, R.PSRRN_curve, 1);
    R.PSRRN_60  = interp_log(R.f, R.PSRRN_curve, 60);
    R.PSRRN_150 = interp_log(R.f, R.PSRRN_curve, 150);
    R.PSRRN_1k  = interp_log(R.f, R.PSRRN_curve, 1e3);

    %% Noise total
    noiseTotalFile = find_file(baseDir, tag + ".noise_total.txt");

    if noiseTotalFile ~= ""
        nt = parse_file(baseDir, tag + ".noise_total.txt", 4);
        R.Input_noise_Vrms = abs(nt.data(end,3));
    else
        R.Input_noise_Vrms = NaN;
    end

    R.Input_noise_uVrms = R.Input_noise_Vrms * 1e6;

    noiseSpectrumFile = find_file(baseDir, tag + ".noise_spectrum.txt");

    if noiseSpectrumFile ~= ""
        ns = parse_file(baseDir, tag + ".noise_spectrum.txt", 2);
        R.noise_f = ns.scale;
        R.noise_in = abs(ns.data(:,1));
    end

    %% Closed-loop linear tracking range
    R.sw_inp = cl_dc.data(:,1);
    R.sw_out = cl_dc.data(:,2);
    R.sw_err = R.sw_out - R.sw_inp;
    R.sw_idd = abs(cl_dc.data(:,4));
    R.sw_ivss = NaN(size(R.sw_idd));

    % This range is defined by unity-follower tracking error, not MOS saturation.
    valid = abs(R.sw_err) <= swingErrLimit;
    valid = true_run_containing_x(valid, R.sw_inp, vcm);

    if any(valid)
        R.CL_input_min = min(R.sw_inp(valid));
        R.CL_input_max = max(R.sw_inp(valid));
        R.Output_swing_min = min(R.sw_out(valid));
        R.Output_swing_max = max(R.sw_out(valid));
    else
        R.CL_input_min = NaN;
        R.CL_input_max = NaN;
        R.Output_swing_min = NaN;
        R.Output_swing_max = NaN;
    end

    R.sw_gain = gradient(R.sw_out) ./ gradient(R.sw_inp);

    %% Slew and settling
    R.t_slew = cl_tran.scale;
    R.slew_inp = cl_tran.data(:,1);
    R.slew_out = cl_tran.data(:,2);

    [slewLow_V, slewHigh_V] = slew_levels(R.slew_out);
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

    sub = dir(baseDir);

    for i = 1:numel(sub)
        if ~sub(i).isdir || startsWith(sub(i).name, ".")
            continue;
        end

        fp2 = fullfile(baseDir, sub(i).name, filename);

        if isfile(fp2)
            fp = fp2;
            return;
        end
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

function y_dB = complex_db(realPart, imagPart)
    y_dB = 20 * log10(abs(complex(realPart, imagPart)));
end

function [v10, v90] = slew_levels(y)
    y = y(isfinite(y));

    if isempty(y)
        v10 = NaN;
        v90 = NaN;
        return;
    end

    vInitial = min(y);
    vFinal = max(y);
    v10 = vInitial + 0.10 * (vFinal - vInitial);
    v90 = vInitial + 0.90 * (vFinal - vInitial);
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

    if ~isfinite(finalVal)
        nTail = max(3, ceil(0.10 * numel(yw)));
        finalVal = mean(yw(end-nTail+1:end));
    end

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

function idxNom = nominal_icmr_index(vcm, idd, gain, targetVcm)
    valid = isfinite(vcm) & isfinite(idd) & idd > 0;

    if ~any(valid)
        idxNom = NaN;
        return;
    end

    idx = find(valid);
    [~, k] = min(abs(vcm(idx) - targetVcm));
    idxNom = idx(k);
end

function idx0 = nearest_index(x, x0, valid)
    if nargin < 3
        valid = isfinite(x);
    else
        valid = valid(:) & isfinite(x(:));
    end

    if ~any(valid)
        idx0 = NaN;
        return;
    end

    idx = find(valid);
    [~, k] = min(abs(x(idx) - x0));
    idx0 = idx(k);
end

function valid2 = true_run_containing_x(valid, x, x0)
    valid = valid(:);
    x = x(:);

    d = diff([false; valid; false]);
    starts = find(d == 1);
    stops  = find(d == -1) - 1;
    valid2 = false(size(valid));

    if isempty(starts)
        return;
    end

    for k = 1:numel(starts)
        run = starts(k):stops(k);

        if min(x(run)) <= x0 && x0 <= max(x(run))
            valid2(run) = true;
            return;
        end
    end
end

function labelCmRange(R)
    if isfinite(R.Input_cm_min) && isfinite(R.Input_cm_max)
        xline(R.Input_cm_min, "--", sprintf("Vin Lo: %.3fV", R.Input_cm_min), ...
              "HandleVisibility", "off");
        xline(R.Input_cm_max, "--", sprintf("Vin Hi: %.3fV", R.Input_cm_max), ...
              "HandleVisibility", "off");
    end
end

function labelNoValidIcmr(R, valid)
    if any(valid) || isempty(R.icmr_line_vcm)
        return;
    end

    hText = text(0.5, 0.9, " No valid ICMR region", ...
                 "Units", "normalized", ...
                 "HorizontalAlignment", "center", ...
                 "VerticalAlignment", "bottom", ...
                 "Color", [0 0 0]);
    styleAnnotationText(hText, [1 1 1]);
end

function labelOutputSwingRange(R)
    if ~isfinite(R.Output_swing_min) || ~isfinite(R.Output_swing_max)
        return;
    end

    yline(R.Output_swing_min, "--", sprintf("Out Lo: %.3fV", R.Output_swing_min), ...
          "HandleVisibility", "off");
    yline(R.Output_swing_max, "--", sprintf("Out Hi: %.3fV", R.Output_swing_max), ...
          "HandleVisibility", "off");
end

function S = read_icmr_line(baseDir, tag, targetVout)
    lineFile = find_file(baseDir, tag + ".ol_icmr_line.txt");

    if lineFile ~= ""
        M = read_ng(lineFile);

        if size(M,2) >= 8
            S.vcm = M(:,2);
            S.vid = M(:,3);
            S.vout = M(:,4);
            S.idd = abs(M(:,5));
            S.ibias = NaN(size(S.vcm));
            S.gain = M(:,8);
        elseif size(M,2) >= 7
            S.vcm = M(:,2);
            S.vid = M(:,3);
            S.vout = M(:,4);
            S.idd = abs(M(:,5));
            S.ibias = NaN(size(S.vcm));
            S.gain = NaN(size(S.vcm));
        else
            error("Cannot parse %s. Expected scale plus at least 6 vectors.", lineFile);
        end

        hasRequiredVid = any(abs(S.vid(isfinite(S.vid))) > 1e-12);
        voutIsForced = any(isfinite(S.vout)) && ...
                       max(abs(S.vout(isfinite(S.vout)) - targetVout)) < 1e-6;
        hasLocalGain = any(isfinite(S.gain));

        if hasRequiredVid || voutIsForced
            if hasLocalGain
                S.mode = "forced_vout_with_gain";
            else
                S.mode = "forced_vout_no_gain";
            end
        else
            S.mode = "zero_vid_sweep";
        end

        S.valid = isfinite(S.vcm) & isfinite(S.vid) & isfinite(S.vout) & ...
                  isfinite(S.idd) & S.idd > 0;
        return;
    end

    gridFile = find_file(baseDir, tag + ".ol_icmr.txt");

    if gridFile == ""
        error("Missing ICMR file: %s or %s", ...
              fullfile(baseDir, tag + ".ol_icmr_line.txt"), ...
              fullfile(baseDir, tag + ".ol_icmr.txt"));
    end

    ol_icmr_dc = parse_file(baseDir, tag + ".ol_icmr.txt", 6);
    S = input_cm_operating_line(ol_icmr_dc.data(:,1), ol_icmr_dc.data(:,2), ...
                                ol_icmr_dc.data(:,3), abs(ol_icmr_dc.data(:,5)), ...
                                abs(ol_icmr_dc.data(:,4)), targetVout);
    S.mode = "forced_vout_with_gain";
end

function S = input_cm_operating_line(vcm, vid, vout, idd, ibias, targetVout)
    zeroVidTol = 1e-12;
    zeroVid = abs(vid) <= zeroVidTol & isfinite(vcm);
    vcmList = unique(vcm(zeroVid));

    if isempty(vcmList)
        vcmList = unique(vcm(isfinite(vcm)));
    end

    n = numel(vcmList);

    S.vcm = vcmList(:);
    S.vid = NaN(n,1);
    S.vout = NaN(n,1);
    S.idd = NaN(n,1);
    S.ibias = NaN(n,1);
    S.gain = NaN(n,1);
    S.valid = false(n,1);

    for i = 1:n
        idx = find(vcm == vcmList(i) & isfinite(vid) & isfinite(vout) & isfinite(idd));

        if numel(idx) < 2
            continue;
        end

        [vid_i, order] = sort(vid(idx));
        vout_i = vout(idx(order));
        idd_i = idd(idx(order));
        ibias_i = ibias(idx(order));

        err = vout_i - targetVout;
        crossIdx = find(err(1:end-1).*err(2:end) <= 0);

        if isempty(crossIdx)
            continue;
        end

        bestVid = NaN;
        bestIdd = NaN;
        bestIbias = NaN;
        bestGain = NaN;
        bestAbsVid = Inf;

        for k = 1:numel(crossIdx)
            j = crossIdx(k);
            dvout = vout_i(j+1) - vout_i(j);
            dvid = vid_i(j+1) - vid_i(j);

            if dvid == 0 || dvout == 0
                continue;
            end

            alpha = (targetVout - vout_i(j)) / dvout;

            if alpha < 0 || alpha > 1
                continue;
            end

            vidCross = vid_i(j) + alpha * dvid;
            iddCross = idd_i(j) + alpha * (idd_i(j+1) - idd_i(j));
            ibiasCross = ibias_i(j) + alpha * (ibias_i(j+1) - ibias_i(j));
            gainCross = dvout / dvid;

            if abs(vidCross) < bestAbsVid
                bestVid = vidCross;
                bestIdd = iddCross;
                bestIbias = ibiasCross;
                bestGain = gainCross;
                bestAbsVid = abs(vidCross);
            end
        end

        validPoint = isfinite(bestVid) && isfinite(bestIdd) && bestIdd > 0 && ...
                     isfinite(bestGain) && abs(bestGain) > 1;

        if validPoint
            S.vid(i) = bestVid;
            S.vout(i) = targetVout;
            S.idd(i) = bestIdd;
            S.ibias(i) = bestIbias;
            S.gain(i) = bestGain;
            S.valid(i) = true;
        end
    end
end

function labelLogCursor(f, y, f0, labelText)
    if isempty(f) || isempty(y) || ~isfinite(f0)
        return;
    end

    y0 = interp_log(f, y, f0);

    if ~isfinite(y0)
        return;
    end

    xline(f0, "--", sprintf("%s: %.1fdB", labelText, y0), ...
          "HandleVisibility", "off");
end

function labelLogNoiseCursor(f, y, f0, labelText)
    if isempty(f) || isempty(y) || ~isfinite(f0)
        return;
    end

    y0 = interp_log(f, y, f0);

    if ~isfinite(y0)
        return;
    end

    xline(f0, "--", sprintf("%s: %.2guV/sqrtHz", labelText, y0*1e6), ...
          "HandleVisibility", "off");
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

    plot(t_mid_us, y_mid, "o", "Color", annotationColor, ...
         "MarkerFaceColor", annotationColor, "HandleVisibility", "off");
    label = sprintf(" %s: %.2fV/us", labelText, slewRate);
    label = regexprep(char(label), "\r|\n", " ");

    hText = text(t_mid_us, y_mid, label, ...
         "VerticalAlignment", "bottom", ...
         "HorizontalAlignment", "left", ...
         "Color", annotationTextColor, ...
         "Interpreter", "none");
    styleAnnotationText(hText, annotationBackgroundColor);
end

function styleAnnotationText(h, backgroundColor)
    set(h, ...
        "BackgroundColor", backgroundColor, ...
        "EdgeColor", [0 0 0], ...
        "LineWidth", 0.75, ...
        "Margin", 2, ...
        "Clipping", "off");
end

function s = fmt(x, f)
    if isnan(x) || isinf(x)
        s = "N/A";
    else
        s = string(sprintf(f, x));
    end
end
