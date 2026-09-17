# ECG Acquisition IC System Report

[← Repository overview](README.md)

| Item | Description |
| :--- | :--- |
| Project stage | Pre-layout schematic design and block-level verification |
| Process | GlobalFoundries 180 nm MCU (`gf180mcu`, 3.3 V, 1P6M) |
| Application | Low-power ECG and biopotential acquisition |
| Design flow | Xschem, ngspice, and MATLAB |
| Main subsystems | Analog front end and SAR ADC |

## 1. Executive summary

The project combines a low-noise differential analog front end (AFE) with a successive-approximation-register ADC. The AFE signal chain contains an instrumentation amplifier with right-leg drive, an active low-pass filter, programmable gain, and a differential output buffer. A master bias network supplies the analog blocks. The SAR ADC contains differential bootstrapped sampling, a capacitive DAC, a dynamic comparator, conversion-clock generation, SAR logic, and an output register.

Block-level schematic verification is complete for the bias network, SE OTA, FD OTA, INA+RLD, LPF, and PGA. These completed signal-processing blocks pass their 45-corner PVT campaigns and their available 200-run MM, GL, and FULL Monte Carlo campaigns. Buffer reporting, full-chain AFE verification, and ADC performance verification remain pending.

> [!IMPORTANT]
> All reported performance values are pre-layout schematic results. They do not include extracted parasitics, package effects, ADC loading unless explicitly stated, or measured-silicon behavior.

## 2. System architecture

### 2.1 Analog front end

![ECG analog front end](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

```text
Electrode input → INA + RLD → LPF → PGA → BUFFER → SAR ADC
```

| Stage | Nominal behavior | Verification | Detailed report |
| :--- | :---: | :---: | :--- |
| BIAS / SEL | 40 µA master bias and analog selection | Complete | [BIAS / SEL](Report/AFE_BLOCKS/BIAS_Report.md) |
| SE OTA | Single-ended gain stage | Pass | [SE OTA](Report/AFE_BLOCKS/SEOTA_Report.md) |
| FD OTA | Fully differential gain stage with CMFB | Pass | [FD OTA](Report/AFE_BLOCKS/FDOTA_Report.md) |
| INA + RLD | 240 V/V instrumentation gain and input common-mode feedback | Pass | [INA + RLD](Report/AFE_BLOCKS/INA_RLD_Report.md) |
| LPF | Unity gain; −1 dB frequency ≥150 Hz | Pass | [LPF](Report/AFE_BLOCKS/LPF_Report.md) |
| PGA | 2/4/8/16 V/V programmable gain | Pass | [PGA](Report/AFE_BLOCKS/PGA_Report.md) |
| BUFFER | Unity-gain differential ADC driver | Analysis pending | [BUFFER](Report/AFE_BLOCKS/BUFFER_Report.md) |
| Integrated AFE | 480–3840 V/V programmed signal-path gain | Verification pending | [AFE](Report/AFE_BLOCKS/AFE_Report.md) |

The verified block-level gain plan gives nominal overall gains of 480, 960, 1920, and 3840 V/V before the buffer and ADC interface.

### 2.2 SAR ADC

The [SAR ADC top level](Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/SAR_ADC/SAR_ADC.sch) directly instantiates two bootstrapped sampling switches, the differential CDAC, clock generator, comparator, SAR logic, and output register.

```text
Differential input → BSW → CDAC ↔ COMP → SAR_LOGIC → OUT_REG
                              ↑
                           CLK_GEN
```

All 18 blocks stored under `SAR_ADC_BLOCKS` are reachable from the top level. Schematic and symbol paths have been audited, but formal ADC simulation results are not yet available. The complete hierarchy and required signoff campaign are documented in the [SAR ADC report](Report/SAR_ADC_BLOCKS/SAR_ADC_Report.md).

## 3. Nominal and worst-case block results

This system report intentionally retains only nominal and limiting full-PVT results. Complete corner tables, all 45 combined PVT cases, MM/GL/FULL Monte Carlo statistics, and plots remain in the linked block reports.

| Block | Metric | Specification | NOM | Worst case | Corner |
| :--- | :--- | :---: | ---: | ---: | :---: |
| BIAS / SEL | Reference current | 40 µA target | 39.997 µA | 49.441 µA (+23.603%) | `FF`, +125°C, 3.6 V |
|  | Startup settling | Report | 807.362 µs | 1180.281 µs | `SS`, −40°C, 3.0 V |
| SE OTA | DC gain | ≥88 dB | 96.522 dB | 93.988 dB | `FSVLTH` |
|  | UGF | ≥8 MHz | 12.835 MHz | 8.762 MHz | `SSVLTH` |
|  | Phase margin | ≥55° | 67.767° | 56.368° | `FFVLTH` |
|  | Input noise, 0.05–150 Hz | ≤2.5 µVrms | 1.873 µVrms | 2.189 µVrms | `SSVLTH` |
| FD OTA | Differential gain | ≥85 dB | 88.699 dB | 86.753 dB | `FSVLTH` |
|  | Differential UGF | ≥8 MHz | 12.447 MHz | 8.435 MHz | `SSVLTH` |
|  | Differential phase margin | ≥60° | 72.649° | 63.377° | `FFVLTH` |
|  | Input noise, 0.05–150 Hz | ≤4 µVrms | 3.086 µVrms | 3.514 µVrms | `SSVHTH` |
| INA + RLD | INA gain error | ±0.5% | 0.011% | −0.215% | `FFVLTL` |
|  | INA bandwidth | ≥150 kHz | 259.286 kHz | 176.996 kHz | `SSVLTH` |
|  | Input noise, 0.05–150 Hz | ≤4 µVrms | 2.667 µVrms | 3.117 µVrms | `SSVLTH` |
|  | CM suppression, 60 / 150 Hz | ≥50 / 45 dB | 55.072 / 53.257 dB | 54.644 / 51.676 dB | `SSVLTL` |
| LPF | Passband gain error | ±0.5% | −0.027% | −0.050% | `SSVLTL` |
|  | −1 dB frequency | ≥150 Hz | 258.691 Hz | 174.135 Hz | `SSVHTL` |
|  | Input noise, 0.05–150 Hz | ≤10 µVrms | 6.176 µVrms | 7.036 µVrms | `SSVHTH` |
| PGA | Gain error | ±5% | +0.751% (G2) | +2.502% (G2) | `SSVLTH` |
|  | −3 dB bandwidth | ≥0.15 MHz | 0.907 MHz (G16) | 0.595 MHz (G16) | `SSVLTH` |
|  | Input noise, 0.05–150 Hz | ≤10 µVrms | 4.617 µVrms (G2) | 5.250 µVrms (G2) | `SSVHTH` |

The buffer, integrated AFE, and SAR ADC are excluded from this result table because formal signoff results are not yet available.

## 4. Verification coverage

### 4.1 Deterministic analysis

Completed block analyzers use five process models (`NOM`, `FF`, `SS`, `FS`, and `SF`) and nine voltage/temperature cases (`nom`, `vl`, `vh`, `tl`, `th`, `vltl`, `vlth`, `vhtl`, and `vhth`), producing 45 combined PVT corners.

The compact comparison columns have these meanings:

| Column | Condition |
| :---: | :--- |
| NOM | Nominal process, supply, and temperature |
| FF / SS / FS / SF | Process-only comparison at nominal supply and temperature |
| VL / VH | Supply-only comparison at nominal process and temperature |
| TL / TH | Temperature-only comparison at nominal process and supply |

### 4.2 Statistical analysis

MM applies local mismatch, GL applies global process variation, and FULL combines both. Complete MM, GL, and FULL statistics are reported only in the detailed block reports, including requested, valid, and failed run counts; minimum, mean, maximum, ±1σ, and ±3σ values; and per-metric yield. Formal yield is based only on required signoff metrics, so missing report-only quantities do not invalidate a run.

## 5. AFE–ADC integration status

| Interface item | Current status | Required verification |
| :--- | :---: | :--- |
| Differential signal range | Block-level only | Verify full-chain output swing for every PGA code |
| Common-mode compatibility | Block-level only | Verify buffer output common mode against ADC sampling input |
| ADC input capacitance | Not signed off | Extract the effective per-side sampling capacitance |
| Acquisition settling | Not tested | Simulate buffer settling during bootstrapped sampling |
| Kickback | Not tested | Measure input kickback from the sampling network and comparator |
| Timing/control | Not integrated | Verify gain selection, sampling, conversion, and output timing |
| Full-chain noise | Not available | Refer ADC noise and quantization noise to the electrode input |
| Full-chain power | Not available | Measure AFE plus ADC operating and conversion power |

No complete-system performance claim is made until the integrated AFE drives the ADC in a common testbench.

## 6. Detailed reports

| Area | Report | Contents |
| :--- | :--- | :--- |
| Device characterization | [$g_m/I_D$ report](Report/SIZING/Gm_Id_Report.md) | NMOS and PMOS characterization plots |
| Bias and selector | [BIAS / SEL report](Report/AFE_BLOCKS/BIAS_Report.md) | Bias sweeps, startup, selector, tables, and plots |
| OTA | [SE OTA report](Report/AFE_BLOCKS/SEOTA_Report.md) | PVT, MC, transient, noise, rejection, and plots |
| OTA | [FD OTA report](Report/AFE_BLOCKS/FDOTA_Report.md) | PVT, MC, CMFB, swing, noise, rejection, and plots |
| Front end | [INA + RLD report](Report/AFE_BLOCKS/INA_RLD_Report.md) | Gain, bandwidth, offset, noise, rejection, RLD stability, MC, and plots |
| Filter | [LPF report](Report/AFE_BLOCKS/LPF_Report.md) | Passband, corner frequencies, offset, noise, rejection, MC, and plots |
| Gain stage | [PGA report](Report/AFE_BLOCKS/PGA_Report.md) | Four gain codes, bandwidth, noise, rejection, transients, MC, and plots |
| Output driver | [BUFFER report](Report/AFE_BLOCKS/BUFFER_Report.md) | Raw-data inventory and pending signoff work |
| AFE system | [Integrated AFE report](Report/AFE_BLOCKS/AFE_Report.md) | Integration scope and pending system measurements |
| Data converter | [SAR ADC report](Report/SAR_ADC_BLOCKS/SAR_ADC_Report.md) | Complete hierarchy and pending ADC signoff work |

## 7. Reproducing completed analyses

Run from the repository root after generating the corresponding ngspice TXT exports:

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

## 8. Next steps

1. Complete the buffer analyzer and MM/GL/FULL campaigns.
2. Complete the integrated AFE testbench and verify all four gain settings while driving the ADC input.
3. Build SAR ADC static, dynamic, timing, power, and PVT/MC verification.
4. Complete matching-aware layout, DRC, and LVS.
5. Repeat selected PVT and FULL Monte Carlo campaigns with extracted parasitics.
6. Integrate the pad ring and prepare the laboratory characterization plan.
