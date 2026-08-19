# ECG Acquisition IC

This repository contains a pre-layout GF180 integrated circuit design for electrocardiogram (ECG) acquisition developed in the IEEE SSCS Chipathon 2026 flow. It provides complete analog building blocks, an integrated AFE top-level schematic, Xschem/ngspice verification testbenches, MATLAB post-processing analyzers, characterization CSV reports, and transistor $g_m/I_D$ sizing data.

The verified analog frontend core consists of:
- **Reference & Bias Network**: Startup-verified $\beta$-multiplier current source, bias distribution mirrors, and analog multiplexers (`BIAS`, `MIRROR`, `SEL`).
- **Single-Ended OTA (`SE_OTA`)**: High-gain, wide-swing operational transconductance amplifier characterized across all 45 PVT corners (5 processes $\times$ 9 voltage/temperature cases).
- **Fully Differential OTA (`FD_OTA`)**: High-CMRR fully differential core (`FDC`) with dynamic common-mode feedback (`CMFB`), characterized across all 45 PVT corners.
- **Signal-Chain Blocks**: Instrumentation amplifier (`INA`), low-pass filter (`LPF`), programmable gain amplifier (`PGA`), output buffer (`BUFFER`), and right-leg drive (`RLD`).

For detailed design methodology, full simulation datasets, worst-case PVT tables, and reproducibility instructions, see [Project_Report.md](Project_Report.md).

---

## System Architecture

![ECG acquisition IC system block diagram](Design_Files/System%20Design/System_Block.png)

### Analog Frontend (AFE) Top-Level Schematic

![ECG Analog Frontend (AFE) Top-Level Schematic](Design_Files/IC%20Design/Schematic/AFE/AFE.png)

### Project Building Blocks

| Area | Blocks | Description |
| :--- | :--- | :--- |
| **Reference & Selection** | `BIAS`, `MIRROR`, `SEL` | 40 µA $\beta$-multiplier reference, current distribution mirrors, and channel/mode multiplexers |
| **Amplification & Filtering** | `INA`, `SE_OTA`, `FD_OTA`, `LPF`, `PGA`, `BUFFER` | Low-noise input stage, high-gain OTAs, anti-aliasing filter, programmable gain, and ADC drive buffer |
| **Common-Mode & Support** | `CMFB`, `FDC`, `RLD`, `TG`, `INV` | Continuous-time common-mode feedback loop, patient common-mode drive, transmission gates, and digital control |
| **Top-Level Integration** | `AFE` | Complete multi-stage analog frontend integration schematic |

> [!NOTE]
> The 10-bit SAR ADC defined in the system specification (`Design_Files/System Design/ECG Acquisition IC with 10-bit SAR ADC SPEC.xlsx`) is specified for future mixed-signal tapeout integration.

---

## Verification & Characterization Status

| Block | PVT Coverage | Verification Evidence & Deliverables |
| :--- | :---: | :--- |
| **BIAS / SEL** | 45-point PVT + 2D grids | 7 CSV reports (`table`, `startup`, `sel`, `dc2d`, `global_worst_case`, `reference`), 35 startup runs (0 failures), 6 nominal plots |
| **SE OTA** | **45-point PVT** (5 processes $\times$ 9 V-T) | 450 ngspice TXT files, compact comparison CSV (`SEOTA_table_report.csv`), full-PVT worst-case CSV (`SEOTA_worst_case_report.csv`), 8 plots |
| **FD OTA** | **45-point PVT** (5 processes $\times$ 9 V-T) | Full PVT dataset, compact comparison CSV (`FDOTA_table_report.csv`), full-PVT worst-case CSV (`FDOTA_worst_case_report.csv`), 9 plots |
| **FDC** | Nominal OL / Plant / CMFB | Open-loop AC, differential plant, CMFB sweep, noise, and offset summary (`NOM.FDC_summary.csv`), 6 plots |
| **CMFB** | Nominal OL / CL | Loop stability, transient settling, valid reference range summary (`NOM.CMFB_summary.csv`), 3 plots |
| **AFE** | Schematic & Testbenches | Multi-stage schematic, AC / noise / transient verification testbenches, and MATLAB analysis scripts |
| **$g_m/I_D$** | Device characterization | Sizing scripts and continuous lookup data for GF180 NMOS and PMOS devices |

---

## Headline Performance Summary

All metrics below represent deterministic pre-layout schematic simulations on the GlobalFoundries 180 nm MCU PDK (`gf180mcu`).

| Block | Key Metric | Nominal Value | Full-PVT Worst Case | Worst Corner |
| :--- | :--- | :---: | :---: | :---: |
| **BIAS** | Reference Output Current ($I_{\text{BIAS}}$) | 39.997 µA | 31.054 – 49.441 µA | SSVLTL / FFVHTH |
| | Startup Time / Failures | 158.4 µs | 1180.28 µs / **0 of 35** | SSVLTL |
| | VREF Error / Selector Error | 0.057 mV / 0.025 µV | 6.154 µV / 25.466 nV | SSVHNOM / SSTH |
| **SE OTA** | DC Gain | 93.855 dB | **89.697 dB** | FSVLTH |
| | Unity-Gain Frequency (UGF) | 12.144 MHz | **8.417 MHz** | SSVLTH |
| | Phase Margin ($C_L = 10\text{ pF}$) | 71.975° | **59.932°** | FFVLTH |
| | Input-Referred Noise ($0.05\text{--}150\text{ Hz}$) | 1.876 µVrms | **2.188 µVrms** | SSVLTH |
| | CMRR / PSRR+ (@ 60 Hz) | 110.809 dB / 103.738 dB | 108.150 dB / 101.557 dB | SSVLTH / SSNOMTH |
| | Slew Rate (Rise / Fall) | 9.968 / 7.763 V/µs | 7.034 / 5.522 V/µs | SSVLTL |
| | Settling Time ($2\text{ mV}$ band) | 164.9 ns | 214.4 ns | SSVLTL |
| **FD OTA** | Differential DC Gain | 86.391 dB | **83.594 dB** | FSVLTH |
| | Differential UGF ($C_L = 10\text{ pF}$) | 12.256 MHz | **8.306 MHz** | SSVLTH |
| | Differential Phase Margin | 73.795° | **64.167°** | FFVLTH |
| | Input-Referred Noise ($0.05\text{--}150\text{ Hz}$) | 3.111 µVrms | **3.545 µVrms** | SSVHTH |
| | Differential Output Swing | $\pm 3.158\text{ V}$ | $\mathbf{\pm 2.730\text{ V}}$ | FSVLTH |
| | Differential Slew Rate (Rise / Fall) | 7.238 / 7.140 V/µs | 5.138 / 5.073 V/µs | SSVLTL |
| | Differential Settling Time ($2\text{ mV}$) | 153.6 ns | 236.6 ns | SSVLTL |
| | CMFB Phase Margin / Settling | 86.428° / 313.6 ns | 84.1° / 507.1 ns | FFVLTH / SSVLTH |

---

## Primary Project Structure

```
ECG_Acquisition_IC/
├── README.md                                          # Top-level overview and headline results
├── Project_Report.md                                  # Complete technical verification report
├── Docker_Instructions.md                             # Container environment setup
├── Design_Files/
│   ├── System Design/                                 # Spec sheet and architecture diagrams
│   └── IC Design/
│       ├── Schematic/                                 # Xschem schematic hierarchy
│       └── Testbench/                                 # Open-loop and closed-loop testbenches
├── Measurement_Results/
│   └── IC_Simulation/
│       ├── BIAS/                                      # BIAS_Analyze.m, CSV reports, and startup plots
│       ├── SE_OTA/                                    # SEOTA_Analyze.m, 45-PVT CSV reports, and plots
│       ├── FD_OTA/                                    # CMFB, FDC, and FDOTA 45-PVT analyzers and plots
│       ├── AFE/                                       # Top-level AFE_Analyze.m analyzer
│       └── Gm_Id/                                     # GF180 gm/Id lookup tables and sizing scripts
└── 2026-sscs-chipathon/                               # Upstream SSCS Chipathon reference snapshot
```

---

## Running MATLAB Analysis

Execute the corresponding Xschem/ngspice testbenches to generate simulation exports, then run the MATLAB post-processing pipelines:

```bash
# 1. BIAS / SEL Characterization
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"

# 2. Single-Ended OTA Full-PVT Analysis
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','SE_OTA','SEOTA_Analyze.m'))"

# 3. Fully Differential OTA, Core, and CMFB Full Analysis
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','CMFB','CMFB_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDC','FDC_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDOTA','FDOTA_Analyze.m'))"
```

> [!TIP]
> The analysis scripts use a strict numeric-first architecture (`ngspice TXT -> double -> PVT worst-case selection -> SI unit scaling -> display string formatting`), preserving full double-precision accuracy without intermediate string rounding errors.

---

## Current Scope & Next Steps

1. **Integrated AFE Characterization**: Execute full-chain transient and frequency-domain verification of the cascaded INA + LPF + PGA + Buffer chain.
2. **Monte Carlo & Mismatch Analysis**: Quantify transistor mismatch effects on input offset voltage, effective CMRR, and PSRR beyond ideal schematic symmetry.
3. **Physical Layout & Post-Layout Extraction (PEX)**: Complete DRC/LVS-clean layout on GF180 1P6M, parasitic extraction, and post-layout re-verification.
4. **Mixed-Signal Integration**: Integrate the 10-bit SAR ADC macro with the analog frontend core.
