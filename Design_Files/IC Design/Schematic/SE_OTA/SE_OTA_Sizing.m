%% SE_OTA_Sizing
% 2-stage Miller compensated single-ended OTA sizing
%
% M1, M2 = PMOS 1st-stage differential input pair
% M3, M4 = NMOS 1st-stage current-source loads
% M5     = PMOS 1st-stage tail current source
% M6     = NMOS 2nd-stage common-source amplifier
% M7     = PMOS 2nd-stage current-source load
% M8     = PMOS bias current mirror device

clear; clc;

%% ============================================================
% SPEC
% ============================================================

VDD = 3.3;          % V
kp2 = 3.5;            % pole-splitting ratio
GBW_MHz  = 15;      % MHz
Cc_pF    = 2;       % pF
CL_pF    = 10;      % pF
Ibias_uA = 40;      % uA
W_unit   = 4;        % uA

% M1, M2 PMOS 1st-stage differential input pair
L12_um          = 1.00;
gmid12_1perV    = 16.00;
idw12_uA_per_um = 0.1264;
gmgds12         = 861.69;

% M3, M4 NMOS 1st-stage current-source loads
L34_um          = 2.00;
gmid34_1perV    = 8.00;
idw34_uA_per_um = 1.796;
gmgds34         = 561.04;

% M5 PMOS tail 1st-stage tail current source
L5_um          = 2.00;
gmid5_1perV    = 8.00;
idw5_uA_per_um = 0.397;
gmgds5         = 1066.90;

% M6 NMOS 2nd-stage common-source amplifier
L6_um          = 0.50;
gmid6_1perV    = 8.00;
idw6_uA_per_um = 7.241;
gmgds6         = 165.52;

% M7 PMOS 2nd-stage current-source load
L7_um          = 0.50;
gmid7_1perV    = 8.00;
idw7_uA_per_um = 2.067;
gmgds7         = 225.52;

% M8 PMOS bias current mirror device
L8_um          = 2.00;
gmid8_1perV    = 8.00;
idw8_uA_per_um = 0.397;
gmgds8         = 1066.90;


%% STAGE 1 SIZING
gm12_uS = 2*pi*GBW_MHz*Cc_pF;
Id12_uA = gm12_uS / gmid12_1perV;
W12_um = Id12_uA / idw12_uA_per_um;

Id34_uA = Id12_uA;
gm34_uS = Id34_uA * gmid34_1perV;
W34_um  = Id34_uA / idw34_uA_per_um;

Id5_uA = 2 * Id12_uA;
gm5_uS = Id5_uA * gmid5_1perV;
W5_um  = Id5_uA / idw5_uA_per_um;


%% STAGE 2 SIZING
gm6_uS = kp2 * gm12_uS * (CL_pF / Cc_pF);
Id6_uA = gm6_uS / gmid6_1perV;
W6_um  = Id6_uA / idw6_uA_per_um;

Id7_uA = Id6_uA;
gm7_uS = Id7_uA * gmid7_1perV;
W7_um  = Id7_uA / idw7_uA_per_um;

Rz_ohm  = 1 / (gm6_uS * 1e-6);
Rz_kohm = Rz_ohm / 1e3;


%% BIAS MIRROR DEVICE
Id8_uA = Ibias_uA;
gm8_uS = Id8_uA * gmid8_1perV;
W8_um  = Id8_uA / idw8_uA_per_um;


%% GAIN ESTIMATE
gds12_uS = gm12_uS / gmgds12;
gds34_uS = gm34_uS / gmgds34;
gds5_uS  = gm5_uS  / gmgds5;
gds6_uS  = gm6_uS  / gmgds6;
gds7_uS  = gm7_uS  / gmgds7;
gds8_uS  = gm8_uS  / gmgds8;

ro12_kohm = 1000 / gds12_uS;
ro34_kohm = 1000 / gds34_uS;
ro5_kohm  = 1000 / gds5_uS;
ro6_kohm  = 1000 / gds6_uS;
ro7_kohm  = 1000 / gds7_uS;
ro8_kohm  = 1000 / gds8_uS;

A1 = gm12_uS / (gds12_uS + gds34_uS);
A2 = gm6_uS  / (gds6_uS  + gds7_uS);
Av_total = A1 * A2;
Av_dB    = 20*log10(Av_total);


%% OUTPUT SWING ESTIMATE
Vov6_V = 2 / gmid6_1perV;
Vov7_V = 2 / gmid7_1perV;
Vmin_V = Vov6_V;
Vmax_V = VDD - Vov7_V;
Vswing_V  = Vmax_V - Vmin_V;


%% FREQUENCY ESTIMATES
Rout1_ohm = 1 / ((gds12_uS + gds34_uS) * 1e-6);
Rout2_ohm = 1 / ((gds6_uS  + gds7_uS)  * 1e-6);
Cc_F      = Cc_pF * 1e-12;
CL_F      = CL_pF * 1e-12;
gm6_S     = gm6_uS * 1e-6;

GBW_calc_MHz = gm12_uS / (2*pi*Cc_pF);
fp1_kHz  = 1 / ((2*pi*Rout1_ohm*Cc_F*gm6_S*Rout2_ohm) * 1e3);
fp2_MHz = gm6_S / ((2*pi*CL_F) * 1e6);
fp2_eff_MHz = gm6_S / ((2*pi*(CL_F + Cc_F)) * 1e6);

fz_RHP_MHz = gm6_S / ((2*pi*Cc_F) * 1e6);
p2_over_GBW = fp2_MHz / GBW_calc_MHz;
p2_eff_over_GBW = fp2_eff_MHz / GBW_calc_MHz;
PM_est_deg = 90 - atand(GBW_calc_MHz / fp2_eff_MHz);


%% PRINT RESULTS
fprintf('\n============================================================\n');
fprintf('SE OTA SIZING RESULTS\n');
fprintf('============================================================\n');

fprintf('\nTarget GBW:\n');
fprintf('GBW target      = %.3f MHz\n', GBW_MHz);

fprintf('\nGain estimate:\n');
fprintf('A1              = %.3f V/V\n', A1);
fprintf('A2              = %.3f V/V\n', A2);
fprintf('Total gain      = %.3f V/V\n', Av_total);
fprintf('Total gain      = %.3f dB\n', Av_dB);

fprintf('\nPole / zero estimate:\n');
fprintf('fp1             = %.3f kHz\n', fp1_kHz);
fprintf('fp2, CL only    = %.3f MHz\n', fp2_MHz);
fprintf('fp2, CL + Cc    = %.3f MHz\n', fp2_eff_MHz);
fprintf('RHP zero        = %.3f MHz\n', fz_RHP_MHz);
fprintf('fp2 / GBW       = %.3f\n', p2_over_GBW);
fprintf('fp2eff / GBW    = %.3f\n', p2_eff_over_GBW);
fprintf('PM estimate     = %.3f deg\n', PM_est_deg);

fprintf('\nOutput swing estimate:\n');
fprintf('VovL            = %.3f V\n', Vov6_V);
fprintf('VovH            = %.3f V\n', Vov7_V);
fprintf('Vmin            = %.3f V\n', Vmin_V);
fprintf('Vmax            = %.3f V\n', Vmax_V);
fprintf('Output swing    = %.3f Vpp\n', Vswing_V);

fprintf('\nMiller compensation:\n');
fprintf('Cc              = %.3f pF\n', Cc_pF);
fprintf('CL              = %.3f pF\n', CL_pF);
fprintf('Rz_kohm         = %.3f kohm\n', Rz_kohm);

%% DEVICE TABLE
device = ["M1"; "M2"; "M3"; "M4"; "M5"; "M6"; "M7"; "M8"];

role = [
    "PMOS 1st-stage amplifier";
    "PMOS 1st-stage amplifier";
    "NMOS 1st-stage load";
    "NMOS 1st-stage load";
    "PMOS 1st-stage tail current";
    "NMOS 2nd-stage amplifier";
    "PMOS 2nd-stage load";
    "PMOS bias mirror"
];

Id_uA   = [Id12_uA; Id12_uA; Id34_uA; Id34_uA; Id5_uA; Id6_uA; Id7_uA; Id8_uA];
gm_uS   = [gm12_uS; gm12_uS; gm34_uS; gm34_uS; gm5_uS; gm6_uS; gm7_uS; gm8_uS];
gds_uS  = [gds12_uS; gds12_uS; gds34_uS; gds34_uS; gds5_uS; gds6_uS; gds7_uS; gds8_uS];
ro_kohm = [ro12_kohm; ro12_kohm; ro34_kohm; ro34_kohm; ro5_kohm; ro6_kohm; ro7_kohm; ro8_kohm];
W_um    = [W12_um; W12_um; W34_um; W34_um; W5_um; W6_um; W7_um; W8_um];
L_um    = [L12_um; L12_um; L34_um; L34_um; L5_um; L6_um; L7_um; L8_um];

W_round_um = max(W_unit * round(W_um / W_unit), W_unit);
W_layout_um = W_unit * ones(size(W_round_um));
m = W_round_um ./ W_layout_um;
W_over_L = W_round_um ./ L_um;
nf = 1 * ones(size(W_round_um));

result_table = table(device, role, Id_uA, gm_uS, gds_uS, ro_kohm, ...
    W_um, W_round_um, L_um, W_layout_um, nf, m, W_over_L);

disp(' ');
disp(result_table);
fprintf('============================================================\n\n');
