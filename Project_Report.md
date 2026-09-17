# ECG Acquisition IC Project Report

| Item | Description |
| :--- | :--- |
| Project stage | Pre-layout schematic design and block-level verification |
| Process | GlobalFoundries 180 nm MCU (`gf180mcu`, 3.3 V, 1P6M) |
| Application | Low-power ECG and biopotential acquisition |
| Design flow | Xschem, ngspice, and MATLAB |
| Program | IEEE SSCS Chipathon 2026 |

## 1. Executive summary

This project implements a low-noise, high-common-mode-rejection analog front end for ECG acquisition. The signal path combines a three-amplifier instrumentation amplifier, right-leg-drive feedback, a low-pass filter, programmable gain, and a differential output buffer. A master bias network supplies the analog blocks.

The completed SE OTA, FD OTA, INA+RLD, LPF, and PGA analyzers each cover 45 deterministic PVT corners. Each block also has 200-run mismatch-only (MM), global-only (GL), and combined (FULL) Monte Carlo reporting. All completed Monte Carlo sets currently contain 200 valid runs, zero failed runs, and 100% joint yield against their formal pre-layout specifications.

Key verified results include:

- INA gain error within ±0.215% across PVT, against a ±0.5% specification.
- INA bandwidth of at least 176.996 kHz and integrated input noise no greater than 3.117 µVrms.
- RLD common-mode suppression of at least 54.644 dB at 60 Hz and 51.676 dB at 150 Hz.
- LPF −1 dB frequency of at least 174.135 Hz, protecting the 150 Hz signal-band edge.
- PGA gain error within 2.502% across all gain codes and PVT corners, against a ±5% specification.

> [!IMPORTANT]
> These are schematic-level results. They do not include layout parasitics, package effects, electrode models beyond the stated testbenches, ADC loading, or measured silicon behavior.

## 2. System architecture

![ECG analog front end](Design_Files/IC%20Design/Schematic/AFE/AFE.png)

| Stage | Block | Implementation | Nominal behavior |
| :--- | :--- | :--- | :---: |
| 1 | Instrumentation amplifier (`INA`) | Two SE OTA input stages followed by an FD OTA difference stage | $60\times4=240\text{ V/V}$ |
| 2 | Low-pass filter (`LPF`) | Fully differential, unity-gain active RC filter | $1\text{ V/V}$; $f_{-1\mathrm{dB}} \ge 150\text{ Hz}$ |
| 3 | Programmable gain amplifier (`PGA`) | FD OTA with switched resistor network and transmission gates | $2/4/8/16\text{ V/V}$ |
| 4 | Output buffer (`BUFFER`) | Closed-loop differential unity-gain driver | $1\text{ V/V}$ |
| Feedback | Right-leg drive (`RLD`) | Active input-common-mode feedback | $55.1\text{ dB}$ suppression at 60 Hz nominal |
| Support | Bias and mirror network | β-multiplier reference and cascode current distribution | $40\,\mu\text{A}$ target |

The verified programmable signal-path gain spans $480$ to $3840\text{ V/V}$, or approximately $53.6$ to $71.7\text{ dB}$.

### 2.1 Schematic hierarchy

The principal design schematics are:

- [AFE top level](Design_Files/IC%20Design/Schematic/AFE/AFE.png)
- [Bias generator](Design_Files/IC%20Design/Schematic/BIAS/BIAS.png) and [mirror tree](Design_Files/IC%20Design/Schematic/MIRROR/MIRROR.png)
- [Single-ended OTA](Design_Files/IC%20Design/Schematic/SE_OTA/SE_OTA.png)
- [Fully differential OTA](Design_Files/IC%20Design/Schematic/FD_OTA/FDOTA/FD_OTA.png), including the [differential core](Design_Files/IC%20Design/Schematic/FD_OTA/FDC/FDC.png) and [CMFB loop](Design_Files/IC%20Design/Schematic/FD_OTA/CMFB/CMFB.png)
- [Instrumentation amplifier](Design_Files/IC%20Design/Schematic/INA/INA.png) and [right-leg drive](Design_Files/IC%20Design/Schematic/RLD/RLD.png)
- [Low-pass filter](Design_Files/IC%20Design/Schematic/LPF/LPF.png), [programmable gain amplifier](Design_Files/IC%20Design/Schematic/PGA/PGA.png), and [output buffer](Design_Files/IC%20Design/Schematic/BUFFER/BUFFER.png)
- [Selector](Design_Files/IC%20Design/Schematic/SEL/SEL.png), [transmission gate](Design_Files/IC%20Design/Schematic/TG/TG.png), and [inverter](Design_Files/IC%20Design/Schematic/INV/INV.png)

## 3. Circuit-design methodology

### 3.1 $g_m/I_D$ sizing

The OTA and bias circuits use a $g_m/I_D$-based sizing flow. Device lookup data provide transconductance efficiency, current density, transit frequency, and intrinsic gain versus channel length and operating point.

The portable characterization scripts are:

- [`NMOS_Gm_Id.m`](Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/NMOS_Gm_Id.m)
- [`PMOS_Gm_Id.m`](Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/PMOS_Gm_Id.m)

![NMOS intrinsic gain versus gm/Id](Measurement_Results/IC_Simulation/Gm_Id/NMOS_Gm_Id/Plots/nmos_intrinsic_gain_db_vs_gmid.png)

![PMOS intrinsic gain versus gm/Id](Measurement_Results/IC_Simulation/Gm_Id/PMOS_Gm_Id/Plots/pmos_intrinsic_gain_db_vs_gmid.png)

### 3.2 OTA implementation

The SE OTA is a two-stage Miller-compensated amplifier optimized for low-frequency noise, high gain, and adequate output swing. Its PMOS input pair uses long-channel devices in moderate inversion; the second stage supplies load-driving capability for a nominal 10 pF load.

The FD OTA uses a differential core and continuous-time common-mode feedback. The same FD OTA architecture is reused in the INA difference stage, LPF, PGA, and output buffer, reducing design duplication and keeping biasing consistent across the AFE.

## 4. Verification methodology

### 4.1 Nominal conditions

| Parameter | Nominal value | Verification range |
| :--- | :---: | :---: |
| Supply | 3.30 V | 3.0–3.6 V |
| Temperature | 27°C | −40°C to +125°C |
| Input common mode | 1.65 V | Testbench dependent |
| Reference voltage | 1.65 V | Normally $V_{DD}/2$ |
| Master bias | 40 µA | 40 ±10 µA specification |
| Output load | 10 pF | Block dependent |
| Integrated-noise band | 0.05–150 Hz | ECG signal band |

### 4.2 PVT matrix

The deterministic matrix contains five process corners and nine voltage/temperature cases, for 45 total simulations:

- Processes: `NOM`, `FF`, `SS`, `FS`, and `SF`.
- Environmental cases: `nom`, `vl`, `vh`, `tl`, `th`, `vltl`, `vlth`, `vhtl`, and `vhth`.

Corner names combine both codes. For example, `SSVLTH` denotes slow-slow devices at 3.0 V and +125°C.

Worst-case selection follows the direction of each specification: maxima for upper limits, minima for lower limits, and maximum absolute magnitude for symmetric limits. Descriptive quantities—such as target gain, measured gain, and report-only corner frequencies—do not receive artificial pass/fail limits.

### 4.3 Monte Carlo methodology

Statistical analyses use three 200-run modes:

- `MM`: local mismatch.
- `GL`: global process variation.
- `FULL`: combined global and mismatch variation.

Runs are joined by run number when a block uses multiple summary files. A run is counted as valid when every formal yield metric is finite; a missing report-only value does not invalidate the entire run. Statistics use finite samples for each metric and the sample standard deviation ($N-1$ normalization).

## 5. Verification results

### 5.1 Bias and selector

The master bias network targets 40 µA and has been characterized over process, supply, and temperature. The startup campaign contains 35 runs with zero failures. The analog selector is verified with a dedicated transient and transmission-error report.

| Metric | Nominal | Verified range / worst case |
| :--- | ---: | ---: |
| Reference current | 39.997 µA | 31.054–49.441 µA |
| Startup settling | 158.4 µs | 1180.28 µs maximum |
| Startup failures | 0 | 0 of 35 |
| Selector transmission error | 0.025 µV | 25.466 nV maximum |

![Bias startup](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_STARTUP.png)

![Bias voltage-temperature surface](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_2D.png)

### 5.2 Single-ended OTA

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current | ≤1.25 mA | 0.825 mA | 1.106 mA | `FFVHTH` |
| DC gain | ≥88 dB | 96.522 dB | 93.988 dB | `FSVLTH` |
| UGF | ≥8 MHz | 12.835 MHz | 8.762 MHz | `SSVLTH` |
| Phase margin | ≥55° | 67.767° | 56.368° | `FFVLTH` |
| CMRR at 60 Hz | ≥105 dB | 111.957 dB | 109.711 dB | `SSVLTH` |
| Input noise, 0.05–150 Hz | ≤2.5 µVrms | 1.873 µVrms | 2.189 µVrms | `SSVLTH` |
| Slew rate, rise / fall | ≥6.5 / 5.0 V/µs | 9.814 / 7.966 V/µs | 6.927 / 5.636 V/µs | `SSVLTL` |
| Settling time | ≤225 ns | 163.4 ns | 213.4 ns | `SSVLTL` |

![SE OTA open-loop response](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.open_loop_gain_phase.png)

![SE OTA input-referred noise](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.input_referred_noise_density.png)

### 5.3 Fully differential OTA

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current | ≤2.5 mA | 1.604 mA | 2.194 mA | `FFVHTH` |
| Differential gain | ≥85 dB | 88.699 dB | 86.753 dB | `FSVLTH` |
| Differential UGF | ≥8 MHz | 12.447 MHz | 8.435 MHz | `SSVLTH` |
| Differential phase margin | ≥60° | 72.649° | 63.377° | `FFVLTH` |
| Output CM error | ±25 mV | 0.395 mV | 12.643 mV | `SSVHTH` |
| Input noise, 0.05–150 Hz | ≤4 µVrms | 3.086 µVrms | 3.514 µVrms | `SSVHTH` |
| Differential output swing | ≥±1.8 V | ±3.188 V | ±2.803 V | `FSVLTH` |
| Differential settling | ≤300 ns | 149.7 ns | 234.9 ns | `SSVLTL` |
| CMFB settling | ≤1000 ns | 329.7 ns | 404.1 ns | `SSVLTL` |

![FD OTA open-loop response](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.open_loop_gain_phase.png)

![FD OTA output swing](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.output_swing_and_closed_loop_vtc.png)

### 5.4 Instrumentation amplifier and right-leg drive

The balanced INA+RLD report contains formal limits for operating point, offset, gain accuracy, bandwidth, rejection, noise, loop stability, common-mode suppression, rail headroom, and interference-induced gain change. Gain values in V/V and dB remain descriptive. RLD swing ratio and peak current are retained only as debug quantities and are not formal signoff rows.

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current / power | ≤6.2 mA / ≤22 mW | 3.860 mA / 12.738 mW | 5.300 mA / 19.079 mW | `FFVHTH` |
| Input-referred offset | ±2 mV | 0.000 µV | 0.002 µV | `SSVLTH` |
| S1 gain error | ±0.5% | 0.009% | −0.163% | `FFVLTL` |
| S2 gain error | ±0.25% | 0.002% | −0.052% | `FFVLTL` |
| INA gain error | ±0.5% | 0.011% | −0.215% | `FFVLTL` |
| INA bandwidth | ≥150 kHz | 259.286 kHz | 176.996 kHz | `SSVLTH` |
| INA CMRR, 60 / 150 Hz | ≥80 / 80 dB | 225.384 / 225.265 dB | 204.344 / 203.835 dB | `SSNOMTH` |
| Input noise, 0.05–150 Hz | ≤4 µVrms | 2.667 µVrms | 3.117 µVrms | `SSVLTH` |
| RLD UGF | 0.5–1.6 kHz | 0.946 kHz | 1.502 kHz | `FFVHTH` |
| RLD phase margin | ≥60° | 100.672° | 100.092° | `FFVLTH` |
| CM suppression, 60 / 150 Hz | ≥50 / 45 dB | 55.072 / 53.257 dB | 54.644 / 51.676 dB | `SSVLTL` |
| RLD rail headroom | ≥0.1 V | 1.647 V | 1.497 V | `FFVLTH` |

![INA differential response](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_differential_ac.png)

![RLD loop response](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_loop_gain.png)

![INA rejection response](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_rejection_response.png)

### 5.5 Low-pass filter

The LPF uses the −1 dB frequency as its formal signal-band criterion. Loss at 150 Hz and the −3 dB frequency are reported for characterization without redundant pass/fail limits.

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current / power | ≤2.5 mA / ≤9 mW | 1.604 mA / 5.293 mW | 2.194 mA / 7.900 mW | `FFVHTH` |
| Output CM error | ±25 mV | 0.395 mV | 12.659 mV | `SSVHTH` |
| Input offset | ±6 mV | 0.000 mV | −0.000 mV | `SFVLTH` |
| Passband gain error | ±0.5% | −0.027% | −0.050% | `SSVLTL` |
| Loss at 150 Hz | Report only | 0.361 dB | 0.762 dB | `SSVHTL` |
| −1 dB frequency | ≥150 Hz | 258.691 Hz | 174.135 Hz | `SSVHTL` |
| −3 dB frequency | Report only | 506.912 Hz | 340.986 Hz | `SSVHTL` |
| Input noise, 0.05–150 Hz | ≤10 µVrms | 6.176 µVrms | 7.036 µVrms | `SSVHTH` |

![LPF differential response](Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_differential_ac.png)

![LPF input-referred noise](Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_noise.png)

![LPF CMRR response](Measurement_Results/IC_Simulation/LPF/Plots/LPF_PVT_CMRR_AC.png)

### 5.6 Programmable gain amplifier

PGA verification covers G2, G4, G8, and G16. Absolute gain is descriptive; gain error carries the ±5% hard limit. The nominal frequency-response and noise figures combine all four gain codes, while rejection uses three subplots for CMRR, PSRR+, and PSRR−.

| Metric | Specification | Full-PVT worst case | Gain / corner |
| :--- | :---: | ---: | :---: |
| Total current / power | ≤2.5 mA / ≤9 mW | 2.195 mA / 7.901 mW | `FFVHTH` |
| Output CM error | ±20 mV | 12.654 mV | `SSVHTH` |
| Input offset | ±5 mV | <1 nV deterministic | All gain codes |
| Gain error | ±5% | 2.502% | G2 / `SSVLTH` |
| −3 dB bandwidth | ≥0.15 MHz | 0.595 MHz | G16 / `SSVLTH` |
| CMRR at 150 Hz | ≥80 dB | 184.550 dB | G8 / `NOMVHNOM` |
| PSRR− at 150 Hz | ≥80 dB | 181.026 dB | G8 / `NOMVHNOM` |
| Input noise, 0.05–150 Hz | ≤10 µVrms | 5.250 µVrms | G2 / `SSVHTH` |

![PGA differential responses](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_differential_ac.png)

![PGA input-referred noise](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_noise.png)

![PGA CMRR and PSRR](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_rejection.png)

![PGA gain switching](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_gain_switching.png)

## 6. Monte Carlo summary

| Block | MM | GL | FULL | Runs per mode | Failed runs |
| :--- | ---: | ---: | ---: | ---: | ---: |
| SE OTA | 100% | 100% | 100% | 200 | 0 |
| FD OTA | 100% | 100% | 100% | 200 | 0 |
| INA + RLD | 100% | 100% | 100% | 200 | 0 |
| LPF | 100% | 100% | 100% | 200 | 0 |
| PGA | 100% | 100% | 100% | 200 | 0 |

Representative statistical plots:

![INA offset Monte Carlo](Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_01_Vos_Histogram.png)

![LPF corner-frequency Monte Carlo](Measurement_Results/IC_Simulation/LPF/Plots/Fig_MC_01_LPF_1dB_Frequency_Histogram.png)

![PGA gain-error Monte Carlo](Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_02_Gain_Error_Histogram.png)

## 7. Generated artifacts

| Block | Analyzer | Deterministic reports | Monte Carlo reports |
| :--- | :--- | :--- | :--- |
| BIAS / SEL | [`BIAS_Analyze.m`](Measurement_Results/IC_Simulation/BIAS/BIAS_Analyze.m) | [`BIAS_table_report.csv`](Measurement_Results/IC_Simulation/BIAS/BIAS_table_report.csv), [`BIAS_global_worst_case.csv`](Measurement_Results/IC_Simulation/BIAS/BIAS_global_worst_case.csv) | — |
| SE OTA | [`SEOTA_Analyze.m`](Measurement_Results/IC_Simulation/SE_OTA/SEOTA_Analyze.m) | [`SEOTA_worst_case_report.csv`](Measurement_Results/IC_Simulation/SE_OTA/Reports/SEOTA_worst_case_report.csv) | [`SEOTA_MC_Run_Summary.csv`](Measurement_Results/IC_Simulation/SE_OTA/Reports/SEOTA_MC_Run_Summary.csv) |
| FD OTA | [`FDOTA_Analyze.m`](Measurement_Results/IC_Simulation/FD_OTA/FDOTA_Analyze.m) | [`FDOTA_worst_case_report.csv`](Measurement_Results/IC_Simulation/FD_OTA/Results/FDOTA_worst_case_report.csv) | [`FDOTA_MC_Run_Summary.csv`](Measurement_Results/IC_Simulation/FD_OTA/Results/FDOTA_MC_Run_Summary.csv) |
| INA + RLD | [`INA_RLD_Analyze.m`](Measurement_Results/IC_Simulation/INA_RLD/INA_RLD_Analyze.m) | [`INA_RLD_worst_case_report.csv`](Measurement_Results/IC_Simulation/INA_RLD/Reports/INA_RLD_worst_case_report.csv) | [`MC_Run_Summary.csv`](Measurement_Results/IC_Simulation/INA_RLD/Reports/MC_Run_Summary.csv) |
| LPF | [`LPF_Analyze.m`](Measurement_Results/IC_Simulation/LPF/LPF_Analyze.m) | [`LPF_worst_case_report.csv`](Measurement_Results/IC_Simulation/LPF/Reports/LPF_worst_case_report.csv) | [`MC_Run_Summary.csv`](Measurement_Results/IC_Simulation/LPF/Reports/MC_Run_Summary.csv) |
| PGA | [`PGA_Analyze.m`](Measurement_Results/IC_Simulation/PGA/PGA_Analyze.m) | [`PGA_worst_case_report.csv`](Measurement_Results/IC_Simulation/PGA/Reports/PGA_worst_case_report.csv) | [`MC_Run_Summary.csv`](Measurement_Results/IC_Simulation/PGA/Reports/MC_Run_Summary.csv) |

## 8. Reproducing the analysis

Run from the repository root after the ngspice source files have been generated:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','SE_OTA')); SEOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA')); FDOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','INA_RLD')); INA_RLD_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','LPF')); LPF_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','PGA')); PGA_Analyze"
```

The analyzers follow a numeric-first workflow:

```text
ngspice TXT → double-precision calculations → PVT/MC selection → unit scaling → CSV and plots
```

## 9. Limitations and next steps

| Priority | Work item | Completion criterion |
| :---: | :--- | :--- |
| 1 | BUFFER reporting | Complete PVT/MC analyzer, formal table, worst-case report, and plots |
| 2 | Full AFE verification | Verify cascaded INA → LPF → PGA → BUFFER gain, bandwidth, noise, and transient behavior |
| 3 | Physical implementation | Complete matching-aware layout, DRC, and LVS |
| 4 | Extracted verification | Repeat PVT and selected FULL Monte Carlo simulations with extracted parasitics |
| 5 | Mixed-signal integration | Integrate the SAR ADC, digital control, and pad ring |
| 6 | Silicon validation | Build the evaluation PCB and measure gain, noise, rejection, power, and electrode-interface behavior |

The offset-sensitive input devices, resistor-ratio networks, and RLD loop components are the highest-priority layout matching and parasitic-control targets.
