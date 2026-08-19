# ECG Acquisition IC

This repository contains a pre-layout GF180 integrated circuit design for electrocardiogram (ECG) acquisition developed for the IEEE SSCS Chipathon 2026 flow. It provides a complete biopotential analog frontend (AFE), transistor-level schematics in Xschem, ngspice verification testbenches, MATLAB post-processing analyzers, characterization CSV reports, and transistor $g_m/I_D$ sizing automation.

---

## Analog Frontend (AFE) Architecture

```
[ ECG Electrodes ] ───> [ INA (FD_OTA Core) ] ───> [ LPF (Anti-Aliasing) ] ───> [ PGA (Gain Stage) ] ───> [ BUFFER ] ───> [ ADC Driver Out ]
                              │
                      [ RLD Amplifier ] <── (Common-Mode Feedback)
```

### Top-Level AFE Schematic

![ECG Analog Frontend (AFE) Top-Level Schematic](Design_Files/IC%20Design/Schematic/AFE/AFE.png)

### Circuit Building Blocks

| Subsystem | Circuit Blocks | Topology & Architectural Description |
| :--- | :--- | :--- |
| **Reference & Biasing** | `BIAS`, `MIRROR`, `SEL` | $40\text{ }\mu\text{A}$ $\beta$-multiplier master current reference, cascode distribution mirrors, and low-resistance CMOS analog multiplexers |
| **Preamplification** | `INA`, `FD_OTA` | High-input-impedance instrumentation amplifier built on a 2-stage fully differential folded-cascode core (`FDC`) |
| **Common-Mode Control** | `CMFB`, `RLD` | High-speed continuous-time common-mode feedback loop ($800\text{ MHz}$ loop UGF) and active patient right-leg drive cancellation |
| **Filtering & Gain Scaling**| `LPF`, `PGA`, `SE_OTA` | Active low-pass anti-aliasing filter ($0.05\text{--}150\text{ Hz}$ passband) and programmable gain amplifier driven by single-ended folded-cascode OTAs |
| **Output Stage & Support** | `BUFFER`, `TG`, `INV` | Low-impedance closed-loop output driver for sampling capacitance, CMOS transmission gates, and digital inverter drives |

---

## Verification & Characterization Status

| Block | PVT Coverage | Simulation Deliverables & Evidence |
| :--- | :---: | :--- |
| **BIAS / SEL** | 45-point PVT + 2D Grid | 7 CSV reports (`table`, `startup`, `sel`, `dc2d`, `global_worst_case`, `reference`), 35 startup transient runs (**0 failures**), 6 nominal plots |
| **SE OTA** | **45-point PVT** (5 processes $\times$ 9 V-T) | 450 raw ngspice exports, 9-column comparison CSV (`SEOTA_table_report.csv`), 45-point worst-case CSV (`SEOTA_worst_case_report.csv`), 8 nominal plots |
| **FD OTA** | **45-point PVT** (5 processes $\times$ 9 V-T) | 9-column comparison CSV (`FDOTA_table_report.csv`), 45-point worst-case CSV (`FDOTA_worst_case_report.csv`), 9 nominal plots |
| **FDC Core** | Standalone Nominal | Differential small-signal AC, plant AC/DC, CMFB sweep, noise, and offset summary (`NOM.FDC_summary.csv`), 6 plots |
| **CMFB** | Standalone Nominal | Closed-loop DC, transient settling, and open-loop AC stability summary (`NOM.CMFB_summary.csv`), 3 plots |
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

---

## Repository Hierarchy

```
ECG_Acquisition_IC/
├── README.md                                          # Top-level summary and headline results
├── Project_Report.md                                  # Complete technical verification report
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
│       ├── FD_OTA/                                    # CMFB, FDC, and FDOTA 45-PVT analyzers and plots
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
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','SE_OTA','SEOTA_Analyze.m'))"

# 3. Fully Differential OTA, Core, and CMFB Full Analysis
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','CMFB','CMFB_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDC','FDC_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDOTA','FDOTA_Analyze.m'))"
```

> [!TIP]
> All post-processing analyzers implement a numerical double-precision pipeline (`ngspice TXT -> double -> PVT worst-case selection -> SI scaling -> string format`), preventing intermediate roundoff errors.

---

## Design Methodology & Next Steps

1. **Integrated AFE Verification**: Complete multi-stage transient and noise simulations across the cascaded `INA -> LPF -> PGA -> BUFFER` path.
2. **Monte Carlo & Mismatch Characterization**: Quantify statistical threshold mismatch ($\sigma_{Vth}$) impact on input offset voltage, CMRR floor, and PSRR.
3. **Physical Layout & Extraction (PEX)**: Perform DRC/LVS-clean layout on GF180 1P6M, parasitic $RC$ extraction, and post-layout re-verification.
4. **Mixed-Signal ADC Integration**: Integrate the 10-bit SAR ADC converter macro with the analog frontend core.
