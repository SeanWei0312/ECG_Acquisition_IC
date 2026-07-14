%% FDC_Sizing
% 2-stage Miller-compensated fully differential OTA core sizing
%
% M1, M2 = NMOS 1st-stage differential input pair
% M3, M4 = PMOS 1st-stage current-source loads controlled by VCMFB
% M5     = NMOS 1st-stage tail current source
% M6, M7 = PMOS 2nd-stage common-source amplifiers
% M8, M9 = NMOS 2nd-stage current-source loads
% M10    = NMOS bias current mirror

clear; clc;

%% ============================================================
% SPEC
% ============================================================

VDD = 3.3;          % V
kp2 = 5;            % pole-splitting ratio
GBW_MHz  = 15;      % MHz
Cc_pF    = 2;       % pF
CL_pF    = 10;      % pF
Ibias_uA = 40;      % uA
W_unit   = 1;       % uA


% M1, M2 NMOS 1st-stage differential input pair
L12_um          = 2.00;
gmid12_1perV    = 20.00;
idw12_uA_per_um = 0.07476;
gmgds12         = 510.58;

% M3, M4 PMOS 1st-stage current-source loads controlled by VCMFB
L34_um          = 2.00;
gmid34_1perV    = 20.00;
idw34_uA_per_um = 0.01569;
gmgds34         = 1620.48;

% M5 NMOS 1st-stage tail current source
L5_um           = 2.00;
gmid5_1perV     = 10.00;
idw5_uA_per_um  = 1.055;
gmgds5          = 580.15;

% M6, M7 PMOS 2nd-stage common-source amplifiers
L67_um          = 1.00;
gmid67_1perV    = 4.00;
idw67_uA_per_um = 3.409;
gmgds67         = 284.18;

% M8, M9 NMOS 2nd-stage current-source loads
L89_um          = 1.00;
gmid89_1perV    = 4.00;
idw89_uA_per_um = 14.18;
gmgds89         = 289.76;

% M10 NMOS bias current mirror
L10_um          = 2.00;
gmid10_1perV    = 10.00;
idw10_uA_per_um = 1.055;
gmgds10         = 580.15;

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
gm67_uS = kp2 * gm12_uS * (1 + CL_pF / Cc_pF);
Id67_uA = gm67_uS / gmid67_1perV;
W67_um  = Id67_uA / idw67_uA_per_um;

Id89_uA = Id67_uA;
gm89_uS = Id89_uA * gmid89_1perV;
W89_um  = Id89_uA / idw89_uA_per_um;

Rz_ohm  = 1 / (gm67_uS * 1e-6);
Rz_kohm = Rz_ohm / 1e3;


%% BIAS MIRROR DEVICE
Id10_uA = Ibias_uA;
gm10_uS = Id10_uA * gmid10_1perV;
W10_um  = Id10_uA / idw10_uA_per_um;


%% GAIN ESTIMATE
gds12_uS = gm12_uS / gmgds12;
gds34_uS = gm34_uS / gmgds34;
gds5_uS  = gm5_uS  / gmgds5;
gds67_uS = gm67_uS  / gmgds67;
gds89_uS = gm89_uS  / gmgds89;
gds10_uS = gm10_uS  / gmgds10;

ro12_kohm = 1000 / gds12_uS;
ro34_kohm = 1000 / gds34_uS;
ro5_kohm  = 1000 / gds5_uS;
ro67_kohm = 1000 / gds67_uS;
ro89_kohm = 1000 / gds89_uS;
ro10_kohm = 1000 / gds10_uS;

A1 = gm12_uS / (gds12_uS + gds34_uS);
A2 = gm67_uS / (gds67_uS + gds89_uS);
Av_total = A1 * A2;
Av_dB    = 20*log10(Av_total);


%% OUTPUT SWING ESTIMATE
Vov67_V = 2 / gmid67_1perV;
Vov89_V = 2 / gmid89_1perV;
Vmin_V = Vov67_V;
Vmax_V = VDD - Vov89_V;
Vswing_V  = Vmax_V - Vmin_V;


%% FREQUENCY ESTIMATES
Rout1_ohm = 1 / ((gds12_uS + gds34_uS) * 1e-6);
Rout2_ohm = 1 / ((gds67_uS + gds89_uS) * 1e-6);
Cc_F      = Cc_pF * 1e-12;
CL_F      = CL_pF * 1e-12;
gm67_S    = gm67_uS * 1e-6;

GBW_calc_MHz = gm12_uS / (2*pi*Cc_pF);
fp1_kHz  = 1 / ((2*pi*Rout1_ohm*Cc_F*gm67_S*Rout2_ohm) * 1e3);
fp2_MHz = gm67_S / ((2*pi*CL_F) * 1e6);
fp2_eff_MHz = gm67_S / ((2*pi*(CL_F + Cc_F)) * 1e6);

fz_RHP_MHz = gm67_S / ((2*pi*Cc_F) * 1e6);
p2_over_GBW = fp2_MHz / GBW_calc_MHz;
p2_eff_over_GBW = fp2_eff_MHz / GBW_calc_MHz;
PM_est_deg = 90 - atand(GBW_calc_MHz / fp2_eff_MHz);


%% PRINT RESULTS
fprintf('\n============================================================\n');
fprintf('FDC OTA SIZING RESULTS\n');
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
fprintf('VovL            = %.3f V\n', Vov67_V);
fprintf('VovH            = %.3f V\n', Vov89_V);
fprintf('Vmin            = %.3f V\n', Vmin_V);
fprintf('Vmax            = %.3f V\n', Vmax_V);
fprintf('Output swing    = %.3f Vpp\n', Vswing_V);

fprintf('\nMiller compensation:\n');
fprintf('Cc              = %.3f pF\n', Cc_pF);
fprintf('CL              = %.3f pF\n', CL_pF);
fprintf('Rz_kohm         = %.3f kohm\n', Rz_kohm);

%% DEVICE TABLE
device = ["M1"; "M2"; "M3"; "M4"; "M5"; "M6"; "M7"; "M8"; "M9"; "M10"];

role = [
    "NMOS 1st-stage amplifier";
    "NMOS 1st-stage amplifier";
    "PMOS 1st-stage load";
    "PMOS 1st-stage load";
    "NMOS 1st-stage tail current";
    "PMOS 2nd-stage amplifier";
    "PMOS 2nd-stage amplifier";
    "NMOS 2nd-stage load";
    "NMOS 2nd-stage load";
    "NMOS bias mirror"
];

Id_uA   = [Id12_uA; Id12_uA; Id34_uA; Id34_uA; Id5_uA; Id67_uA; Id67_uA; Id89_uA; Id89_uA; Id10_uA];
gm_uS   = [gm12_uS; gm12_uS; gm34_uS; gm34_uS; gm5_uS; gm67_uS; gm67_uS; gm89_uS; gm89_uS; gm10_uS];
gds_uS  = [gds12_uS; gds12_uS; gds34_uS; gds34_uS; gds5_uS; gds67_uS; gds67_uS; gds89_uS; gds89_uS; gds10_uS];
ro_kohm = [ro12_kohm; ro12_kohm; ro34_kohm; ro34_kohm; ro5_kohm; ro67_kohm; ro67_kohm; ro89_kohm; ro89_kohm; ro10_kohm];
W_um    = [W12_um; W12_um; W34_um; W34_um; W5_um; W67_um; W67_um; W89_um; W89_um; W10_um];
L_um    = [L12_um; L12_um; L34_um; L34_um; L5_um; L67_um; L67_um; L89_um; L89_um; L10_um];

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
