# ECG Acquisition IC

This repository contains a pre-layout GF180 integrated circuit design for electrocardiogram (ECG) acquisition developed for the IEEE SSCS Chipathon 2026 flow. It provides a complete biopotential analog frontend (AFE), transistor-level schematics in Xschem, ngspice verification testbenches, MATLAB post-processing analyzers, characterization CSV reports, and transistor $g_m/I_D$ sizing automation.

---

## Analog Frontend (AFE) Architecture

![ECG Analog Frontend (AFE) Top-Level Schematic](Design_Files/IC%20Design/Schematic/AFE/AFE.png)

### Circuit Subsystems & Sizing Specifications

| Stage | Subsystem | Circuit Topology & Key Components | Stage Gain & Bandwidth |
| :--- | :--- | :--- | :---: |
| **Stage 1** | **Instrumentation Amp (`INA`)** | 3-opamp topology ($2\times$ `SE_OTA` input buffers, $1\times$ `FD_OTA` difference stage, $R_1 = 118\text{ k}\Omega$, $R_{\text{gain}} = 4\text{ k}\Omega$, $R_{2\text{--}5} = 10\text{--}40\text{ k}\Omega$) | $60\text{ V/V}$ stage setting; integrated INA+SEL target $240\text{ V/V}$ |
| **Stage 2** | **Active Low-Pass Filter (`LPF`)** | Fully differential active 2nd-order RC filter ($1\times$ `FD_OTA`, $R = 3.7\text{ M}\Omega$, $C = 100\text{ pF}$ MIM) | $4\text{ V/V}$ ($12.0\text{ dB}$)<br>$f_c \approx 150\text{ Hz}$ |
| **Stage 3** | **Programmable Gain Amp (`PGA`)** | Fully differential switched-resistor ladder ($1\times$ `FD_OTA`, $6\times$ `TG`, $R = 20\text{--}120\text{ k}\Omega$) | $1\times, 2\times, 4\times, 8\times, 16\times$<br>($0\text{ to }24.1\text{ dB}$) |
| **Stage 4** | **Output Driver (`BUFFER`)** | Closed-loop differential unity follower ($1\times$ `FD_OTA`, $4\times 20\text{ k}\Omega$) driving sampling cap | $1\text{ V/V}$ ($0\text{ dB}$)<br>$C_L = 10\text{ pF}$ |
| **Support** | **Right-Leg Drive (`RLD`)** | Active integrator sensing input CM ($1\times$ `SE_OTA`, $R_{\text{in}} = 4\text{ M}\Omega$, $R_f = 20\text{ M}\Omega$, $C_f = 80\text{ pF}$) | Combined INA+RLD input-CM suppression: $55.1\text{ dB}$ @ 60 Hz nominal |
| **Reference** | **Master Bias (`BIAS`/`MIRROR`)** | $\beta$-Multiplier reference ($40\text{ }\mu\text{A}$ target) with startup device and 11-channel cascode mirror tree | $\Delta I_{\text{bias}} < 0.15\%$ mirror tracking |
| **Total Chain** | **Full AFE Performance** | Cascaded multi-stage biopotential recording path with analog channel selection (`SEL`) | **$240\text{ to }3840\text{ V/V}$**<br>($47.6\text{ to }71.7\text{ dB}$)<br>**$0.05\text{--}150\text{ Hz}$** |

---

## Verification & Characterization Status

| Block | PVT Coverage | Simulation Deliverables & Evidence |
| :--- | :---: | :--- |
| **BIAS / SEL** | 45-point PVT + 2D Grid | 7 CSV reports (`table`, `startup`, `sel`, `dc2d`, `global_worst_case`, `reference`), 35 startup transient runs (**0 failures**), 6 nominal plots |
| **SE OTA** | **45-point PVT** (5 processes $\times$ 9 V-T) | 450 raw ngspice exports, 9-column comparison CSV (`SEOTA_table_report.csv`), 45-point worst-case CSV (`SEOTA_worst_case_report.csv`), 8 nominal plots |
| **FD OTA** | **45-point PVT** (5 processes $\times$ 9 V-T) | 9-column comparison CSV (`FDOTA_table_report.csv`), 45-point worst-case CSV (`FDOTA_worst_case_report.csv`), 9 nominal plots |
| **INA + RLD** | **45-point PVT** (BAL report) + 45-corner MIS stress audit | 9-column BAL comparison CSV, full-PVT BAL CSV, worst-case CSV, 7 nominal plots including switching SEL transient |
| **Integrated AFE** | Multi-Stage Chain | Complete top-level schematic, AC/noise/transient testbenches, and multi-stage analyzer source (`AFE_Analyze.m`) |
| **$g_m/I_D$ Sizing** | Device Characterization | Continuous $g_m/I_D$, $f_T$, $I_D/W$, and $g_m/g_{ds}$ lookup curves for 3.3 V NMOS and PMOS in GF180 |

---

## Headline Performance Summary

All results represent deterministic pre-layout schematic simulations on the GlobalFoundries 180 nm MCU PDK (`gf180mcu`).

| Circuit Block | Key Metric | Nominal Value | Full-PVT Worst Case | Worst-Case Corner |
| :--- | :--- | :---: | :---: | :---: |
| **BIAS Network** | Reference Output Current ($I_{\text{BIAS}}$) | 39.997 µA | 31.054 – 49.441 µA | SSVLTL / FFVHTH |
| | Startup Time / Failures | 158.4 µs | 1180.28 µs / **0 of 35** | SSVLTL |
| | Output Error ($V_{\text{REF}} - V_{DD}/2$) | 0.057 mV | 6.154 µV | SSVHNOM |
| | Multiplexer Transmission Error | 0.025 µV | $\le 25.466\text{ nV}$ | SSTH |
| **Single-Ended OTA** | DC Open-Loop Gain | 93.855 dB | **89.697 dB** | FSVLTH |
| | Unity-Gain Frequency ($C_L = 10\text{ pF}$) | 12.144 MHz | **8.417 MHz** | SSVLTH |
| | Phase Margin | 71.975° | **59.932°** | FFVLTH |
| | Input Noise ($0.05\text{--}150\text{ Hz}$) | 1.876 µVrms | **2.188 µVrms** | SSVLTH |
| | CMRR / PSRR+ (@ 60 Hz) | 110.809 dB / 103.738 dB | 108.150 dB / 101.557 dB | SSVLTH / SSNOMTH |
| | Closed-Loop Slew Rate (Rise / Fall) | 9.968 / 7.763 V/µs | 7.034 / 5.522 V/µs | SSVLTL |
| | Closed-Loop Settling Time ($2\text{ mV}$) | 164.9 ns | 214.4 ns | SSVLTL |
| **Fully Differential OTA** | Differential DC Gain | 86.391 dB | **83.594 dB** | FSVLTH |
| | Differential UGF ($C_L = 10\text{ pF}$) | 12.256 MHz | **8.306 MHz** | SSVLTH |
| | Differential Phase Margin | 73.795° | **64.167°** | FFVLTH |
| | Input Noise ($0.05\text{--}150\text{ Hz}$) | 3.111 µVrms | **3.545 µVrms** | SSVHTH |
| | Symmetrical Output Swing | $\pm 3.158\text{ V}$ | $\mathbf{\pm 2.730\text{ V}}$ | FSVLTH |
| | Differential Slew Rate (Rise / Fall) | 7.238 / 7.140 V/µs | 5.138 / 5.073 V/µs | SSVLTL |
| | Differential Settling Time ($2\text{ mV}$) | 153.6 ns | 236.6 ns | SSVLTL |
| | CMFB Phase Margin / Settling | 86.428° / 313.6 ns | 84.1° / 507.1 ns | FFVLTH / SSVLTH |
| **INA + RLD (BAL)** | Total current / power | 4.441 mA / 14.655 mW | 5.937 mA / 21.373 mW | FFVHTH |
| | S1 / S2 gain @ 10 Hz | 58.330 / 3.966 V/V | -2.783% / -0.842% error | — |
| | INA gain @ 10 Hz | 231.355 V/V (47.286 dB) | 3.815% gain error | FFVLTL |
| | S1 / S2 / INA -3 dB bandwidth | 263.040 / 2581.724 / 260.399 kHz | 178.714 kHz total | SSVLTH |
| | RLD loop UGF | 0.946 kHz | 0.717 kHz | SSVLTL |
| | RLD phase margin | 100.673° | 100.083° | FFVLTH |
| | Input CM suppression @ 60 Hz | 55.072 dB | 54.646 dB | SSVLTL |
| | Input CM suppression @ 150 Hz | 53.260 dB | 51.686 dB | SSVLTL |
| | Input-referred noise (0.05–150 Hz) | 2.671 µVrms | 3.116 µVrms | SSVLTH |
| | RLD output peak-to-peak excursion | 2.743 mV | 2.743 mV | FFVHNOM |
| | Peak \|I<sub>RLD</sub>\| during CM interference | 3.069 nA | 3.095 nA | FFVLTH |

For detailed characterization result plots and full methodology, see [Project_Report.md](Project_Report.md).

---

## Repository Hierarchy

```
ECG_Acquisition_IC/
├── README.md                                          # Top-level summary and headline results
├── Project_Report.md                                  # Complete technical verification report with embedded plots
├── Docker_Instructions.md                             # Container setup instructions
├── Design_Files/
│   └── IC Design/
│       ├── Schematic/                                 # Xschem schematic and symbol hierarchy
│       │   ├── AFE/                                   # Top-level integrated AFE schematic & PNG
│       │   ├── BIAS/, MIRROR/, SEL/                   # Reference and bias generation blocks
│       │   ├── SE_OTA/, FD_OTA/, INA/                 # Amplification sub-blocks and sizing scripts
│       │   └── LPF/, PGA/, BUFFER/, RLD/, TG/, INV/   # Filtering, gain, buffer, and control blocks
│       └── Testbench/                                 # Open-loop and closed-loop SPICE testbenches
├── Measurement_Results/
│   └── IC_Simulation/
│       ├── BIAS/                                      # BIAS_Analyze.m, CSV reports, and startup plots
│       ├── SE_OTA/                                    # SEOTA_Analyze.m, 45-PVT CSV reports, and plots
│       ├── FD_OTA/                                    # FDOTA_Analyze.m, 45-PVT CSV reports, and plots
│       ├── INA_RLD/                                   # INA_RLD_Analyze.m, BAL/MIS reports, and seven plots
│       ├── AFE/                                       # Top-level AFE_Analyze.m analyzer source
│       └── Gm_Id/                                     # GF180 NMOS/PMOS gm/Id sizing scripts and data
└── 2026-sscs-chipathon/                               # Upstream SSCS Chipathon reference snapshot
```

---

## Running Post-Processing Analysis

To execute the verification analysis and regenerate all CSV summary reports and characterization figures:

```bash
# 1. BIAS & Selector Subsystem Analysis
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"

# 2. Single-Ended OTA 45-PVT Analysis
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','SE_OTA')); SEOTA_Analyze"

# 3. Fully Differential OTA 45-PVT Analysis
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA')); FDOTA_Analyze"

# 4. INA + RLD 45-PVT Analysis
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','INA_RLD')); INA_RLD_Analyze"
```

> [!TIP]
> All post-processing analyzers implement a numerical double-precision pipeline (`ngspice TXT -> double -> PVT worst-case selection -> SI scaling -> string format`), preventing intermediate roundoff errors.

---

## Design Methodology & Next Steps

1. **Integrated AFE Verification**: Complete multi-stage transient and noise simulations across the cascaded `INA -> LPF -> PGA -> BUFFER` path.
2. **Monte Carlo & Mismatch Characterization**: Quantify statistical threshold mismatch ($\sigma_{Vth}$) impact on input offset voltage, CMRR floor, and PSRR.
3. **Physical Layout & Extraction (PEX)**: Perform DRC/LVS-clean layout on GF180 1P6M, parasitic $RC$ extraction, and post-layout re-verification.
4. **Mixed-Signal ADC Integration**: Integrate the 10-bit SAR ADC converter macro with the analog frontend core.
