clear; clc; close all;

%% User settings and output paths
baseDir = "/Users/sean/Documents/GitHub/ECG_Acquisition_IC/Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id";
outCsv  = fullfile(baseDir, "nmos_gmid_all_results.csv");
plotDir = fullfile(baseDir, "Plots");
terminalTablePath = fullfile(baseDir, "nmos_gmid_terminal_table.txt");

targetVDS  = 1.65;
targetGmId = 4:1:20;
gmIdMin = 2.00;

files = dir(fullfile(baseDir, "nmos_L*u_W*u.txt"));

if ~exist(plotDir, "dir")
    mkdir(plotDir);
end

if isempty(files)
    error("No NMOS simulation .txt files found in: %s", baseDir);
end

%% Read all ngspice text files and build one data table
allData = table();

for k = 1:numel(files)

    filePath = fullfile(files(k).folder, files(k).name);

    L_um = parseLengthUm(files(k).name);
    W_um = parseWidthUm(files(k).name);

    [raw, columnNames] = readNgspiceWrdata(filePath);

    hasSmallSignalData = false;

    % Newer files include sweep, gm, gds, capacitance, and fT columns.
    % Older files only include VGS, VDS, ID, and Id/W.
    if hasColumn(columnNames, "vgs_out") && hasColumn(columnNames, "vds_out")
        VGS = getColumn(raw, columnNames, "vgs_out", 2, files(k).name);
        VDS = getColumn(raw, columnNames, "vds_out", 3, files(k).name);
        ID  = abs(getColumn(raw, columnNames, "id", 4, files(k).name));

        if hasColumn(columnNames, "gm") && hasColumn(columnNames, "gds") && hasColumn(columnNames, "ft_hz")
            gmInput = abs(getColumn(raw, columnNames, "gm", 6, files(k).name));
            gdsInput = abs(getColumn(raw, columnNames, "gds", 7, files(k).name));
            fTInput = abs(getColumn(raw, columnNames, "ft_hz", 12, files(k).name));
            hasSmallSignalData = true;
        end
    elseif size(raw,2) >= 13
        VGS = raw(:,2);
        VDS = raw(:,3);
        ID  = abs(raw(:,4));
        gmInput = abs(raw(:,6));
        gdsInput = abs(raw(:,7));
        fTInput = abs(raw(:,12));
        hasSmallSignalData = true;
    elseif size(raw,2) >= 5
        raw = raw(:, end-3:end);
        VGS = raw(:,1);
        VDS = raw(:,2);
        ID  = abs(raw(:,3));
    elseif size(raw,2) ~= 4
        error("Unexpected column count in %s", files(k).name);
    else
        VGS = raw(:,1);
        VDS = raw(:,2);
        ID  = abs(raw(:,3));
    end

    % Convert vector sweep data into VGS-by-VDS grids.
    [vgList, ~, ig] = unique(VGS);
    [vdList, ~, idv] = unique(VDS);

    IdGrid = accumarray([ig idv], ID, [numel(vgList) numel(vdList)], @mean, NaN);

    gmGrid  = nan(size(IdGrid));
    gdsGrid = nan(size(IdGrid));
    fTGrid  = nan(size(IdGrid));

    if hasSmallSignalData
        % Prefer gm/gds/fT directly from ngspice when available.
        gmGrid = accumarray([ig idv], gmInput, [numel(vgList) numel(vdList)], @mean, NaN);
        gdsGrid = accumarray([ig idv], gdsInput, [numel(vgList) numel(vdList)], @mean, NaN);
        fTGrid = accumarray([ig idv], fTInput, [numel(vgList) numel(vdList)], @mean, NaN);
    else
        % Fall back to numerical derivatives for older DC-only files.
        for j = 1:numel(vdList)
            gmGrid(:,j) = gradient(IdGrid(:,j), vgList);
        end

        for i = 1:numel(vgList)
            gdsGrid(i,:) = gradient(IdGrid(i,:), vdList);
        end
    end

    [VGmesh, VDmesh] = ndgrid(vgList, vdList);

    Idv  = IdGrid(:);
    gmv  = gmGrid(:);
    gdsv = gdsGrid(:);
    fTv  = fTGrid(:);

    gm_Id  = gmv ./ Idv;
    gm_gds = gmv ./ gdsv;
    gain_dB = 20*log10(abs(gm_gds));

    Id_per_W_uA_per_um  = Idv ./ W_um * 1e6;
    gm_per_W_uS_per_um  = gmv ./ W_um * 1e6;
    gds_per_W_uS_per_um = gdsv ./ W_um * 1e6;

    mainBranch = false(size(IdGrid));

    for j = 1:numel(vdList)
        gmIdCol = gmGrid(:,j) ./ IdGrid(:,j);

        good = isfinite(gmIdCol) & isfinite(IdGrid(:,j)) & IdGrid(:,j) > 0;

        if any(good)
            idxGood = find(good);
            [~, idxLocalMax] = max(gmIdCol(good));
            idxStart = idxGood(idxLocalMax);

            mainBranch(idxStart:end, j) = true;
        end
    end

    T = table();
    T.L_um = repmat(L_um, numel(Idv), 1);
    T.W_um = repmat(W_um, numel(Idv), 1);
    T.VGS_V = VGmesh(:);
    T.VDS_V = VDmesh(:);
    T.Id_A = Idv;
    T.Id_per_W_uA_per_um = Id_per_W_uA_per_um;
    T.gm_S = gmv;
    T.gm_per_W_uS_per_um = gm_per_W_uS_per_um;
    T.gds_S = gdsv;
    T.gds_per_W_uS_per_um = gds_per_W_uS_per_um;
    T.fT_Hz = fTv;
    T.gm_Id_1_per_V = gm_Id;
    T.gm_gds = gm_gds;
    T.intrinsic_gain_dB = gain_dB;
    T.main_branch = mainBranch(:);

    allData = [allData; T];

end

%% Save combined CSV and select the requested VDS slice
allData = sortrows(allData, ["L_um", "VDS_V", "VGS_V"]);
csvData = allData(:, ["L_um", ...
                      "W_um", ...
                      "VGS_V", ...
                      "VDS_V", ...
                      "Id_per_W_uA_per_um", ...
                      "fT_Hz", ...
                      "gm_Id_1_per_V", ...
                      "gm_gds", ...
                      "intrinsic_gain_dB", ...
                      "main_branch"]);
writetable(csvData, outCsv);

fprintf("\nSaved CSV:\n%s\n", outCsv);
fprintf("Total points saved: %d\n", height(allData));

vdsList = unique(allData.VDS_V);
[~, idxVDS] = min(abs(vdsList - targetVDS));
useVDS = vdsList(idxVDS);

fprintf("\nUsing VDS = %.3f V\n", useVDS);

slice = allData(abs(allData.VDS_V - useVDS) < 1e-12, :);
Ls = unique(slice.L_um);

%% Print and save the target gm/Id design table
nmosGmIdTable = buildNmosGmIdTable(slice, Ls, useVDS, targetGmId);

fprintf("\nNMOS target gm/Id summary, VDS = %.3f V:\n", useVDS);
fprintf("Effective Vov is estimated from gm/Id using Vov = 2/(gm/Id), then Vt = VGS - Vov.\n");
printGmIdTable("NMOS", nmosGmIdTable, "VGS_V", "Vt_V", terminalTablePath);

%% Plot current density vs gm/Id
figure;
hold on; grid on; box on;
leg = strings(0);
for i = 1:numel(Ls)
    D = slice(slice.L_um == Ls(i) & slice.main_branch == true, :);
    D = D(isfinite(D.gm_Id_1_per_V) & ...
          isfinite(D.Id_per_W_uA_per_um) & ...
          D.Id_A > 0 & D.gm_S > 0, :);
    D = sortrows(D, "gm_Id_1_per_V");

    if ~isempty(D)
        semilogy(D.gm_Id_1_per_V, D.Id_per_W_uA_per_um, "LineWidth", 1.5);
        leg(end+1) = "L = " + string(Ls(i)) + " \mum";
    end
end
xlabel("gm/Id  (1/V)");
ylabel("Id/W  (\muA/\mum)");
title(sprintf("NMOS Current Density vs gm/Id, VDS = %.3f V", useVDS));
xlim([gmIdMin Inf]);
legend(leg, "Location", "best");
saveCurrentFigure(plotDir, "nmos_current_density_vs_gmid");

%% Plot gm/Id times fT vs gm/Id
figure;
hold on; grid on; box on;
leg = strings(0);
if any(strcmp(allData.Properties.VariableNames, "fT_Hz"))
    for i = 1:numel(Ls)
        D = slice(slice.L_um == Ls(i) & slice.main_branch == true, :);
        D = D(isfinite(D.gm_Id_1_per_V) & ...
              isfinite(D.fT_Hz) & ...
              D.gm_Id_1_per_V > 0 & ...
              D.fT_Hz > 0 & ...
              D.Id_A > 0 & D.gm_S > 0, :);
        D = sortrows(D, "gm_Id_1_per_V");

        if ~isempty(D)
            plot(D.gm_Id_1_per_V, D.gm_Id_1_per_V .* D.fT_Hz / 1e9, "LineWidth", 1.5);
            leg(end+1) = "L = " + string(Ls(i)) + " \mum";
        end
    end
else
    text(0.5, 0.5, "f_T data not available in current DC sweep", ...
         "Units", "normalized", ...
         "HorizontalAlignment", "center");
end
xlabel("gm/Id  (1/V)");
ylabel("(gm/Id) f_T  (GHz/V)");
title(sprintf("NMOS gm/Id times f_T vs gm/Id, VDS = %.3f V", useVDS));
if ~isempty(leg)
    xlim([gmIdMin Inf]);
    legend(leg, "Location", "best");
else
    xlim([gmIdMin gmIdMin + 1]);
end
saveCurrentFigure(plotDir, "nmos_gmid_times_ft_vs_gmid");

%% Plot intrinsic gain vs gm/Id
figure;
hold on; grid on; box on;
leg = strings(0);
for i = 1:numel(Ls)
    D = slice(slice.L_um == Ls(i) & slice.main_branch == true, :);
    D = D(isfinite(D.gm_Id_1_per_V) & ...
          isfinite(D.gm_gds) & ...
          D.Id_A > 0 & D.gm_S > 0 & D.gds_S > 0, :);
    D = sortrows(D, "gm_Id_1_per_V");

    if ~isempty(D)
        plot(D.gm_Id_1_per_V, abs(D.gm_gds), "LineWidth", 1.5);
        leg(end+1) = "L = " + string(Ls(i)) + " \mum";
    end
end
xlabel("gm/Id  (1/V)");
ylabel("g_m/g_{ds}");
title(sprintf("NMOS Intrinsic Gain vs gm/Id, VDS = %.3f V", useVDS));
xlim([gmIdMin Inf]);
legend(leg, "Location", "best");
saveCurrentFigure(plotDir, "nmos_intrinsic_gain_vs_gmid");

%% Plot intrinsic gain in dB vs gm/Id
figure;
hold on; grid on; box on;
leg = strings(0);
for i = 1:numel(Ls)
    D = slice(slice.L_um == Ls(i) & slice.main_branch == true, :);
    D = D(isfinite(D.gm_Id_1_per_V) & ...
          isfinite(D.intrinsic_gain_dB) & ...
          D.Id_A > 0 & D.gm_S > 0 & D.gds_S > 0, :);
    D = sortrows(D, "gm_Id_1_per_V");

    if ~isempty(D)
        plot(D.gm_Id_1_per_V, D.intrinsic_gain_dB, "LineWidth", 1.5);
        leg(end+1) = "L = " + string(Ls(i)) + " \mum";
    end
end
xlabel("gm/Id  (1/V)");
ylabel("Intrinsic gain (dB)");
title(sprintf("NMOS Intrinsic Gain in dB, VDS = %.3f V", useVDS));
xlim([gmIdMin Inf]);
legend(leg, "Location", "best");
saveCurrentFigure(plotDir, "nmos_intrinsic_gain_db_vs_gmid");

%% Plot current density vs VGS
figure;
hold on; grid on; box on;
leg = strings(0);
for i = 1:numel(Ls)
    D = slice(slice.L_um == Ls(i), :);
    D = D(isfinite(D.VGS_V) & ...
          isfinite(D.Id_per_W_uA_per_um) & ...
          D.Id_A > 0, :);
    D = sortrows(D, "VGS_V");

    if ~isempty(D)
        semilogy(D.VGS_V, D.Id_per_W_uA_per_um, "LineWidth", 1.5);
        leg(end+1) = "L = " + string(Ls(i)) + " \mum";
    end
end
xlabel("VGS (V)");
ylabel("Id/W  (\muA/\mum)");
title(sprintf("NMOS Current Density vs VGS, VDS = %.3f V", useVDS));
legend(leg, "Location", "best");
saveCurrentFigure(plotDir, "nmos_current_density_vs_vgs");

%% Plot gm/Id vs VGS
figure;
hold on; grid on; box on;
leg = strings(0);
for i = 1:numel(Ls)
    D = slice(slice.L_um == Ls(i), :);
    D = D(isfinite(D.VGS_V) & ...
          isfinite(D.gm_Id_1_per_V) & ...
          D.Id_A > 0 & D.gm_S > 0, :);
    D = sortrows(D, "VGS_V");

    if ~isempty(D)
        plot(D.VGS_V, D.gm_Id_1_per_V, "LineWidth", 1.5);
        leg(end+1) = "L = " + string(Ls(i)) + " \mum";
    end
end
xlabel("VGS (V)");
ylabel("gm/Id  (1/V)");
title(sprintf("NMOS gm/Id vs VGS, VDS = %.3f V", useVDS));
ylim([gmIdMin Inf]);
legend(leg, "Location", "best");
saveCurrentFigure(plotDir, "nmos_gmid_vs_vgs");


%% Helper functions
function gmIdTable = buildNmosGmIdTable(slice, Ls, useVDS, targetGmId)

    gmIdTable = table();

    for i = 1:numel(Ls)

        Lnow = Ls(i);

        D = slice(slice.L_um == Lnow & slice.main_branch == true, :);
        D = D(isfinite(D.VGS_V) & ...
              isfinite(D.gm_Id_1_per_V) & ...
              isfinite(D.gm_gds) & ...
              isfinite(D.intrinsic_gain_dB) & ...
              isfinite(D.Id_per_W_uA_per_um) & ...
              isfinite(D.fT_Hz) & ...
              D.gm_Id_1_per_V > 0 & ...
              D.Id_A > 0 & ...
              D.gm_S > 0 & ...
              D.gds_S > 0, :);

        if isempty(D)
            continue;
        end

        D = sortrows(D, "gm_Id_1_per_V");
        [xUnique, idxUnique] = unique(D.gm_Id_1_per_V, "stable");
        D = D(idxUnique, :);
        useTargets = targetGmId(targetGmId >= min(xUnique) & targetGmId <= max(xUnique)).';

        if isempty(useTargets)
            continue;
        end

        gateAtTarget = interp1(D.gm_Id_1_per_V, D.VGS_V, useTargets, "linear");
        idWAtTarget = interp1(D.gm_Id_1_per_V, D.Id_per_W_uA_per_um, useTargets, "linear");
        gmGdsAtTarget = interp1(D.gm_Id_1_per_V, abs(D.gm_gds), useTargets, "linear");
        gainDbAtTarget = interp1(D.gm_Id_1_per_V, D.intrinsic_gain_dB, useTargets, "linear");
        fTAtTarget = interp1(D.gm_Id_1_per_V, D.fT_Hz, useTargets, "linear");
        gmIdFtAtTarget = useTargets .* fTAtTarget / 1e9;
        Vov_V = 2 ./ useTargets;

        row = table();
        row.L_um = repmat(Lnow, numel(useTargets), 1);
        row.VDS_V = repmat(useVDS, numel(useTargets), 1);
        row.gm_Id_1_per_V = useTargets;
        row.gm_gds = gmGdsAtTarget;
        row.intrinsic_gain_dB = gainDbAtTarget;
        row.Id_per_W_uA_per_um = idWAtTarget;
        row.gm_Id_times_fT_GHz_per_V = gmIdFtAtTarget;
        row.Vov_V = Vov_V;
        row.Vt_V = gateAtTarget - Vov_V;
        row.VGS_V = gateAtTarget;

        gmIdTable = [gmIdTable; row];

    end
end


function printGmIdTable(deviceName, T, gateColumn, vtColumn, filePath)

    fileId = fopen(char(filePath), "w");

    if fileId < 0
        error("Cannot open terminal table file for writing: %s", char(filePath));
    end

    if isempty(T)
        printLine(1, "\nNo %s target gm/Id rows matched the current data.\n", deviceName);
        printLine(fileId, "\nNo %s target gm/Id rows matched the current data.\n", deviceName);
        fclose(fileId);
        return;
    end

    T = sortrows(T, ["L_um", "gm_Id_1_per_V"]);
    Ls = unique(T.L_um);

    printLine(1, "\n%s terminal gm/Id table:\n", deviceName);
    printLine(fileId, "%s terminal gm/Id table:\n", deviceName);

    for i = 1:numel(Ls)

        Lnow = Ls(i);
        D = T(T.L_um == Lnow, :);
        gateLabel = char(erase(gateColumn, "_V"));

        printLine(1, "\nL = %.2f um\n", Lnow);
        printLine(fileId, "\nL = %.2f um\n", Lnow);
        printLine(1, "  %8s %10s %10s %14s %14s %10s %10s %10s\n", ...
                  "gm/Id", "gm/gds", "Gain", "Id/W", "gm/Id*fT", "Vov", "Vt", gateLabel);
        printLine(fileId, "  %8s %10s %10s %14s %14s %10s %10s %10s\n", ...
                  "gm/Id", "gm/gds", "Gain", "Id/W", "gm/Id*fT", "Vov", "Vt", gateLabel);
        printLine(1, "  %8s %10s %10s %14s %14s %10s %10s %10s\n", ...
                  "(1/V)", "", "(dB)", "(uA/um)", "(GHz/V)", "(V)", "(V)", "(V)");
        printLine(fileId, "  %8s %10s %10s %14s %14s %10s %10s %10s\n", ...
                  "(1/V)", "", "(dB)", "(uA/um)", "(GHz/V)", "(V)", "(V)", "(V)");

        for r = 1:height(D)
            printLine(1, "  %8.2f %10.2f %10.2f %14.4g %14.4g %10.3f %10.3f %10.3f\n", ...
                      D.gm_Id_1_per_V(r), ...
                      D.gm_gds(r), ...
                      D.intrinsic_gain_dB(r), ...
                      D.Id_per_W_uA_per_um(r), ...
                      D.gm_Id_times_fT_GHz_per_V(r), ...
                      D.Vov_V(r), ...
                      D.(vtColumn)(r), ...
                      D.(gateColumn)(r));
            printLine(fileId, "  %8.2f %10.2f %10.2f %14.4g %14.4g %10.3f %10.3f %10.3f\n", ...
                      D.gm_Id_1_per_V(r), ...
                      D.gm_gds(r), ...
                      D.intrinsic_gain_dB(r), ...
                      D.Id_per_W_uA_per_um(r), ...
                      D.gm_Id_times_fT_GHz_per_V(r), ...
                      D.Vov_V(r), ...
                      D.(vtColumn)(r), ...
                      D.(gateColumn)(r));
        end
    end

    fclose(fileId);
    fprintf("\nSaved terminal table: %s\n", char(filePath));
end


function printLine(fileId, varargin)

    fprintf(fileId, varargin{:});

end


function saveCurrentFigure(plotDir, baseName)

    pngPath = fullfile(plotDir, baseName + ".png");
    figPath = fullfile(plotDir, baseName + ".fig");

    saveas(gcf, pngPath);
    savefig(gcf, figPath);

    fprintf("Saved plot: %s\n", pngPath);

end


function [raw, columnNames] = readNgspiceWrdata(filePath)

    lines = readlines(filePath);
    raw = [];
    columnNames = strings(1, 0);

    for i = 1:numel(lines)

        s = strtrim(lines(i));

        if s == ""
            continue;
        end

        nums = sscanf(s, "%f").';

        if isempty(nums)
            columnNames = split(s).';
            columnNames = columnNames(columnNames ~= "");
            continue;
        end

        raw = [raw; nums];

    end
end


function tf = hasColumn(columnNames, columnName)

    tf = any(strcmpi(columnNames, columnName));

end


function values = getColumn(raw, columnNames, columnName, fallbackIndex, fileName)

    idx = find(strcmpi(columnNames, columnName), 1);

    if isempty(idx)
        idx = fallbackIndex;
    end

    if idx > size(raw, 2)
        error("Missing column '%s' in %s", columnName, fileName);
    end

    values = raw(:, idx);

end


function L_um = parseLengthUm(fileName)

    tok = regexp(fileName, "L([0-9p]+)u", "tokens", "once");

    if isempty(tok)
        error("Cannot parse L from filename: %s", fileName);
    end

    L_um = str2double(strrep(tok{1}, "p", "."));

end


function W_um = parseWidthUm(fileName)

    tok = regexp(fileName, "W([0-9p]+)u", "tokens", "once");

    if isempty(tok)
        error("Cannot parse W from filename: %s", fileName);
    end

    W_um = str2double(strrep(tok{1}, "p", "."));

end
