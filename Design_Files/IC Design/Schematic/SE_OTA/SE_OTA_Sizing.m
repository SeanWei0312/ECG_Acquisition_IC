%% SE_OTA_Sizing
% 2-stage Miller compensated single-ended OTA sizing
%
% Topology assumed:
% M1, M2 = PMOS differential input pair
% M3, M4 = NMOS active load / current mirror load
% M5     = PMOS tail current source for input pair
% M6     = NMOS 2nd-stage common-source amplifier
% M7     = PMOS 2nd-stage current-source load
% M8     = bias current mirror/reference device
%
% Units for inputs:
% GBW: MHz
% Cc, CL: pF
% Ibias: uA
% L: um
% gm/Id: 1/V
% Id/W: uA/um
% gm/gds: unitless

clear; clc;

%% ============================================================
%  USER INPUTS
% ============================================================

VDD = 3.3;          % V

GBW_MHz  = 10;      % MHz
Cc_pF    = 2;       % pF
CL_pF    = 10;      % pF
Ibias_uA = 40;      % uA, current through M8

% -------------------------
% M1, M2 PMOS input pair
% -------------------------
L12_um          = 1.00;
gmid12_1perV    = 16.00;
idw12_uA_per_um = 0.1264;
gmgds12         = 861.69;

% -------------------------
% M3, M4 NMOS load
% -------------------------
L34_um          = 2.00;
gmid34_1perV    = 8.00;
idw34_uA_per_um = 1.796;
gmgds34         = 561.04;

% -------------------------
% M5 PMOS tail current source
% -------------------------
L5_um          = 2.00;
gmid5_1perV    = 8.00;
idw5_uA_per_um = 0.397;
gmgds5         = 1066.90;

% -------------------------
% M6 NMOS 2nd-stage common source
% -------------------------
L6_um          = 0.50;
gmid6_1perV    = 8.00;
idw6_uA_per_um = 7.241;
gmgds6         = 165.52;

% -------------------------
% M7 PMOS 2nd-stage current-source load
% -------------------------
L7_um          = 0.50;
gmid7_1perV    = 8.00;
idw7_uA_per_um = 2.067;
gmgds7         = 225.52;

% -------------------------
% M8 bias current mirror device
% -------------------------
L8_um          = 2.00;
gmid8_1perV    = 8.00;
idw8_uA_per_um = 0.397;
gmgds8         = 1066.90;


%% ============================================================
%  STAGE 1 SIZING
% ============================================================

% gm1,2 = 2*pi*GBW*Cc
% Because MHz*pF gives uS numerically:
gm12_uS = 2*pi*GBW_MHz*Cc_pF;

% Id1,2 = gm1,2 / (gm/Id)
Id12_uA = gm12_uS / gmid12_1perV;

% W1,2 = Id1,2 / (Id/W)
W12_um = Id12_uA / idw12_uA_per_um;

% M3, M4 carry same branch current as M1, M2
Id34_uA = Id12_uA;
gm34_uS = Id34_uA * gmid34_1perV;
W34_um  = Id34_uA / idw34_uA_per_um;

% Tail current source M5
Id5_uA = 2 * Id12_uA;
gm5_uS = Id5_uA * gmid5_1perV;
W5_um  = Id5_uA / idw5_uA_per_um;


%% ============================================================
%  STAGE 2 SIZING
% ============================================================

% gm6 = 3 * gm1 * CL/Cc
% This is a conservative stability rule.
gm6_uS = 3 * gm12_uS * (CL_pF / Cc_pF);

% Nulling resistor
Rz_ohm  = 1 / (gm6_uS * 1e-6);
Rz_kohm = Rz_ohm / 1e3;

% Id6 = gm6 / (gm/Id)
Id6_uA = gm6_uS / gmid6_1perV;
W6_um  = Id6_uA / idw6_uA_per_um;

% M7 carries same current as M6
Id7_uA = Id6_uA;
gm7_uS = Id7_uA * gmid7_1perV;
W7_um  = Id7_uA / idw7_uA_per_um;


%% ============================================================
%  BIAS MIRROR DEVICE M8
% ============================================================

Id8_uA = Ibias_uA;
gm8_uS = Id8_uA * gmid8_1perV;
W8_um  = Id8_uA / idw8_uA_per_um;

% Useful mirror ratios
mirror_ratio_M5_to_M8_Id = Id5_uA / Id8_uA;
mirror_ratio_M5_to_M8_W  = W5_um  / W8_um;


%% ============================================================
%  ESTIMATE GAIN
% ============================================================

% gds = gm / (gm/gds)
gds12_uS = gm12_uS / gmgds12;
gds34_uS = gm34_uS / gmgds34;
gds5_uS  = gm5_uS  / gmgds5;
gds6_uS  = gm6_uS  / gmgds6;
gds7_uS  = gm7_uS  / gmgds7;
gds8_uS  = gm8_uS  / gmgds8;

% ro in kOhm
ro12_kohm = 1000 / gds12_uS;
ro34_kohm = 1000 / gds34_uS;
ro5_kohm  = 1000 / gds5_uS;
ro6_kohm  = 1000 / gds6_uS;
ro7_kohm  = 1000 / gds7_uS;
ro8_kohm  = 1000 / gds8_uS;

% Stage gain:
% A1 = gm1 * (ro1 || ro3)
% Since gm and gds are both in uS:
A1 = gm12_uS / (gds12_uS + gds34_uS);
A2 = gm6_uS  / (gds6_uS  + gds7_uS);

Av_total = A1 * A2;
Av_dB    = 20*log10(Av_total);


%% ============================================================
%  OUTPUT SWING ESTIMATE
% ============================================================

% Long-channel strong-inversion approximation:
% Vov ~= 2 / (gm/Id)
Vov6_V = 2 / gmid6_1perV;
Vov7_V = 2 / gmid7_1perV;

% For NMOS M6 pull-down and PMOS M7 pull-up:
Vmin_V = Vov6_V;
Vmax_V = VDD - Vov7_V;

Vswing_V  = Vmax_V - Vmin_V;
VoutDC_V  = (Vmax_V + Vmin_V) / 2;


%% ============================================================
%  FREQUENCY ESTIMATES
% ============================================================

GBW_calc_MHz = gm12_uS / (2*pi*Cc_pF);

Rout1_ohm = 1 / ((gds12_uS + gds34_uS) * 1e-6);
Rout2_ohm = 1 / ((gds6_uS  + gds7_uS)  * 1e-6);
Cc_F      = Cc_pF * 1e-12;
CL_F      = CL_pF * 1e-12;
gm6_S     = gm6_uS * 1e-6;

fp1_est_Hz  = 1 / (2*pi*Rout1_ohm*Cc_F*gm6_S*Rout2_ohm);
fp1_cal_Hz  = (GBW_calc_MHz * 1e6) / Av_total;
fp1_kHz     = fp1_est_Hz / 1e3;

fp2_MHz = gm6_S / (2*pi*CL_F) / 1e6;

fz_RHP_MHz = gm6_S / (2*pi*Cc_F) / 1e6;

p2_over_GBW = fp2_MHz / GBW_calc_MHz;


%% ============================================================
%  PRINT RESULTS
% ============================================================

fprintf('\n============================================================\n');
fprintf('2-STAGE MILLER OTA SIZING RESULTS\n');
fprintf('============================================================\n');

fprintf('\nTarget / calculated GBW:\n');
fprintf('GBW target      = %.3f MHz\n', GBW_MHz);
fprintf('GBW calculated  = %.3f MHz\n', GBW_calc_MHz);
fprintf('Cc              = %.3f pF\n', Cc_pF);
fprintf('CL              = %.3f pF\n', CL_pF);

fprintf('\nStage 1:\n');
fprintf('gm1,2           = %.3f uS\n', gm12_uS);
fprintf('Id1,2 each      = %.3f uA\n', Id12_uA);
fprintf('W1,2 each       = %.3f um\n', W12_um);
fprintf('L1,2            = %.3f um\n', L12_um);

fprintf('\nM3, M4 load:\n');
fprintf('Id3,4 each      = %.3f uA\n', Id34_uA);
fprintf('gm3,4 each      = %.3f uS\n', gm34_uS);
fprintf('W3,4 each       = %.3f um\n', W34_um);
fprintf('L3,4            = %.3f um\n', L34_um);

fprintf('\nM5 tail current source:\n');
fprintf('Id5             = %.3f uA\n', Id5_uA);
fprintf('W5              = %.3f um\n', W5_um);
fprintf('L5              = %.3f um\n', L5_um);

fprintf('\nStage 2:\n');
fprintf('gm6             = %.3f uS\n', gm6_uS);
fprintf('Id6             = %.3f uA\n', Id6_uA);
fprintf('W6              = %.3f um\n', W6_um);
fprintf('L6              = %.3f um\n', L6_um);
fprintf('Rz_kohm         = %.3f kohm\n', Rz_kohm);

fprintf('\nM7 current-source load:\n');
fprintf('Id7             = %.3f uA\n', Id7_uA);
fprintf('gm7             = %.3f uS\n', gm7_uS);
fprintf('W7              = %.3f um\n', W7_um);
fprintf('L7              = %.3f um\n', L7_um);

fprintf('\nM8 bias mirror:\n');
fprintf('Id8             = %.3f uA\n', Id8_uA);
fprintf('W8              = %.3f um\n', W8_um);
fprintf('L8              = %.3f um\n', L8_um);
fprintf('M5/M8 current ratio = %.3f\n', mirror_ratio_M5_to_M8_Id);
fprintf('M5/M8 width ratio   = %.3f\n', mirror_ratio_M5_to_M8_W);

fprintf('\nGain estimate:\n');
fprintf('A1              = %.3f V/V\n', A1);
fprintf('A2              = %.3f V/V\n', A2);
fprintf('Total gain      = %.3f V/V\n', Av_total);
fprintf('Total gain      = %.3f dB\n', Av_dB);

fprintf('\nPole / zero estimate:\n');
fprintf('fp1 est         = %.3f kHz\n', fp1_kHz);
fprintf('fp1 GBW/Av      = %.3f kHz\n', fp1_cal_Hz / 1e3);
fprintf('fp2             = %.3f MHz\n', fp2_MHz);
fprintf('RHP zero        = %.3f MHz\n', fz_RHP_MHz);
fprintf('fp2 / GBW       = %.3f\n', p2_over_GBW);

fprintf('\nOutput swing estimate:\n');
fprintf('Vov6            = %.3f V\n', Vov6_V);
fprintf('Vov7            = %.3f V\n', Vov7_V);
fprintf('Vmin            = %.3f V\n', Vmin_V);
fprintf('Vmax            = %.3f V\n', Vmax_V);
fprintf('Output swing    = %.3f Vpp\n', Vswing_V);
fprintf('Vout,DC         = %.3f V\n', VoutDC_V);


%% ============================================================
%  DEVICE TABLE
% ============================================================

device = ["M1"; "M2"; "M3"; "M4"; "M5"; "M6"; "M7"; "M8"];

role = [
    "PMOS input pair";
    "PMOS input pair";
    "NMOS load";
    "NMOS load";
    "PMOS tail current source";
    "NMOS 2nd-stage common source";
    "PMOS 2nd-stage current source";
    "bias mirror"
];

Id_uA = [
    Id12_uA;
    Id12_uA;
    Id34_uA;
    Id34_uA;
    Id5_uA;
    Id6_uA;
    Id7_uA;
    Id8_uA
];

gm_uS = [
    gm12_uS;
    gm12_uS;
    gm34_uS;
    gm34_uS;
    gm5_uS;
    gm6_uS;
    gm7_uS;
    gm8_uS
];

gds_uS = [
    gds12_uS;
    gds12_uS;
    gds34_uS;
    gds34_uS;
    gds5_uS;
    gds6_uS;
    gds7_uS;
    gds8_uS
];

ro_kohm = [
    ro12_kohm;
    ro12_kohm;
    ro34_kohm;
    ro34_kohm;
    ro5_kohm;
    ro6_kohm;
    ro7_kohm;
    ro8_kohm
];

W_um = [
    W12_um;
    W12_um;
    W34_um;
    W34_um;
    W5_um;
    W6_um;
    W7_um;
    W8_um
];

L_um = [
    L12_um;
    L12_um;
    L34_um;
    L34_um;
    L5_um;
    L6_um;
    L7_um;
    L8_um
];

W_over_L = W_um ./ L_um;
nf = max(round(W_um / 4), 1);

result_table = table(device, role, Id_uA, gm_uS, gds_uS, ro_kohm, ...
                     W_um, L_um, nf, W_over_L);

disp(' ');
disp(result_table);
fprintf('============================================================\n\n');
