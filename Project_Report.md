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

The project combines a low-noise differential analog front end (AFE) with a successive-approximation-register ADC. The AFE signal chain contains an instrumentation amplifier with right-leg drive, an active low-pass filter, programmable gain, and a fully differential output buffer (FDBUF). A master bias network supplies the analog blocks. The SAR ADC contains differential bootstrapped sampling, a capacitive DAC, a dynamic comparator, conversion-clock generation, SAR logic, and an output register.

Block-level schematic verification is complete for the bias network, SE OTA, FD OTA, INA+RLD, LPF, and PGA. These completed signal-processing blocks pass their 45-corner PVT campaigns and their available 200-run MM, GL, and FULL Monte Carlo campaigns. FDBUF reporting, full-chain AFE verification, and ADC performance verification remain pending.

> [!IMPORTANT]
> All reported performance values are pre-layout schematic results. They do not include extracted parasitics, package effects, ADC loading unless explicitly stated, or measured-silicon behavior.

## 2. System architecture

### 2.1 Analog front end

![ECG analog front end](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

```text
Electrode input → INA + RLD → LPF → PGA → FDBUF → SAR ADC
```

| Stage | Nominal behavior | Verification | Detailed report |
| :--- | :---: | :---: | :--- |
| BIAS / SEL | 40 µA master bias and analog selection | Complete | [BIAS / SEL](Report/AFE_BLOCKS/BIAS_Report.md) |
| SE OTA | Single-ended gain stage | Pass | [SE OTA](Report/AFE_BLOCKS/SEOTA_Report.md) |
| FD OTA | Fully differential gain stage with CMFB | Pass | [FD OTA](Report/AFE_BLOCKS/FDOTA_Report.md) |
| INA + RLD | 240 V/V instrumentation gain and input common-mode feedback | Pass | [INA + RLD](Report/AFE_BLOCKS/INA_RLD_Report.md) |
| LPF | Unity gain; −1 dB frequency ≥150 Hz | Pass | [LPF](Report/AFE_BLOCKS/LPF_Report.md) |
| PGA | 2/4/8/16 V/V programmable gain | Pass | [PGA](Report/AFE_BLOCKS/PGA_Report.md) |
| FDBUF | Unity-gain differential ADC driver | Analysis pending | [FDBUF](Report/AFE_BLOCKS/FDBUF_Report.md) |
| Integrated AFE | 480–3840 V/V programmed signal-path gain | Verification pending | [AFE](Report/AFE_BLOCKS/AFE_Report.md) |

The verified block-level gain plan gives nominal overall gains of 480, 960, 1920, and 3840 V/V before the FDBUF and ADC interface.

### 2.2 SAR ADC

The [SAR ADC top level](Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/SAR_ADC/SAR_ADC.sch) directly instantiates two bootstrapped sampling switches, the differential CDAC, clock generator, comparator, SAR logic, and output register.

```text
Differential input → BSW → CDAC ↔ COMP → SAR_LOGIC → OUT_REG
                              ↑
                           CLK_GEN
```

All 18 blocks stored under `SAR_ADC_BLOCKS` are reachable from the top level. Schematic and symbol paths have been audited, but formal ADC simulation results are not yet available. The complete hierarchy and required signoff campaign are documented in the [SAR ADC report](Report/SAR_ADC_BLOCKS/SAR_ADC_Report.md).

## 3. Nominal and worst-case block results

Each completed block has one table containing every parameter exported by its analyzer. NOM is the nominal-process, nominal-supply, 27°C result. Worst case is the limiting value selected across all 45 combined PVT corners; descriptive rows retain the analyzer-selected extremum without a pass/fail limit.

### 3.1 BIAS / SEL

[Detailed BIAS / SEL report](Report/AFE_BLOCKS/BIAS_Report.md)

| Parameter | Unit | Specification | NOM | Worst case | Corner / condition |
| :--- | :---: | :---: | ---: | ---: | :--- |
| Reference current, $I_{bias}$ | µA | 40 target | 39.997 | 31.054–49.441 | SS, −40°C, 3.0 V / FF, +125°C, 3.6 V |
| Reference-current error | % | Report | −0.007499 | 23.603 maximum absolute | FF, +125°C, 3.6 V |
| Mirror current, $I_{RS}$ | µA | Report | 39.998 | 31.076–49.413 | SS, −40°C, 3.0 V / FF, +125°C, 3.6 V |
| Mirror tracking error | % | Report | −0.002826 | 0.149 maximum absolute | FS, +125°C, 3.0 V |
| BP voltage | V | Report | 1.643 | 1.138–2.146 | FS, +125°C, 3.0 V / SF, −40°C, 3.6 V |
| VREF | V | Report | 1.650 | 1.500–1.800 | VL / VH |
| VREF error | µV | Report | −4.170 | 6.154 maximum absolute | SS, −40°C, 3.6 V |
| Startup-device current, $I_{MST}$ | fA | Report | 2.083e−08 | 0.7394 maximum | FF, +125°C, 3.6 V |
| Startup-device margin | V | Report | 1.541 | 0.7415 minimum | FF, +125°C, 3.6 V |
| Supply current | µA | Report | 83.192 | 103.971 maximum | FF, +125°C, 3.6 V |
| Power | µW | Report | 274.532 | 374.297 maximum | FF, +125°C, 3.6 V |
| Startup time | µs | Report | 807.362 | 1180.281 maximum | SS, −40°C, 3.0 V |
| Startup failures | count | 0 | 0 | 0 of 35 | All startup cases |
| Temperature coefficient | ppm/°C | Report | 1184.627 | 1223.228 maximum | FF |
| Temperature variation | % | Report | 19.546 | 20.183 maximum | FF |
| Line regulation | %/V | Report | 4.290 | 5.185 maximum | SS |
| Supply variation | % | Report | 2.574 | 3.111 maximum | SS |
| BP internal-selector error | nV | Report | — | 12.495 maximum absolute | SF, VH |
| BP external-selector error | nV | Report | — | 25.466 maximum absolute | SS, TH |
| VREF internal-selector error | nV | Report | — | 18.749 maximum absolute | SS, VL |
| VREF external-selector error | nV | Report | — | 10.951 maximum absolute | SS, VL |

### 3.2 SE OTA

[Detailed SE OTA report](Report/AFE_BLOCKS/SEOTA_Report.md)

| Parameter | Unit | Specification | NOM | Worst case | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| Bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| Total current | mA | ≤1.25 | 0.825 | 1.106 | `FFVHTH` |
| Total power | mW | ≤4.5 | 2.721 | 3.982 | `FFVHTH` |
| DC gain | dB | ≥88 | 96.522 | 93.988 | `FSVLTH` |
| UGF | MHz | ≥8 | 12.835 | 8.762 | `SSVLTH` |
| Phase margin | ° | ≥55 | 67.767 | 56.368 | `FFVLTH` |
| Input offset | µV | ±2000 | 3.193 | 12.092 | `FSVLTH` |
| CMRR @ 60 Hz | dB | ≥105 | 111.957 | 109.711 | `SSVLTH` |
| CMRR @ 150 Hz | dB | ≥105 | 111.957 | 109.711 | `SSVLTH` |
| PSRR+ @ 60 Hz | dB | ≥100 | 103.379 | 101.385 | `SSVLTL` |
| PSRR+ @ 150 Hz | dB | ≥95 | 99.232 | 96.565 | `SSVLTH` |
| PSRR- @ 60 Hz | dB | ≥100 | 103.379 | 101.385 | `SSVLTL` |
| PSRR- @ 150 Hz | dB | ≥95 | 99.232 | 96.565 | `SSVLTH` |
| Input-referred noise 0.05-150 Hz | µVrms | ≤2.5 | 1.873 | 2.189 | `SSVLTH` |
| Closed-loop gain | dB | Report | −1.042e−04 | −9.346e−05 | `FFVHNOM` |
| Gain error | % | ±0.01 | −0.001 | −0.001 | `FSVLTH` |
| Vout,DC error | µV | ±2000 | −3.192 | −12.092 | `FSVLTH` |
| Input low | mV | ≤600 | 106.000 | 429.000 | `SSVHTL` |
| Input high | V | ≥2.75 | 3.237 | 2.815 | `FSVLTH` |
| Input high headroom | mV | ≤250 | 63.000 | 185.000 | `FSVLTH` |
| Output low | mV | ≤600 | 107.816 | 430.970 | `SSVHTL` |
| Output high | V | ≥2.75 | 3.235 | 2.813 | `FSVLTH` |
| Output high headroom | mV | ≤250 | 64.870 | 187.000 | `FSVLTH` |
| SR rise | V/µs | ≥6.5 | 9.814 | 6.927 | `SSVLTL` |
| SR fall | V/µs | ≥5.0 | 7.966 | 5.636 | `SSVLTL` |
| Settling time | ns | ≤225 | 163.400 | 213.400 | `SSVLTL` |

### 3.3 FD OTA

[Detailed FD OTA report](Report/AFE_BLOCKS/FDOTA_Report.md)

| Parameter | Unit | Specification | NOM | Worst case | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| FDC bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| CMFB bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| Total current | mA | ≤2.5 | 1.604 | 2.194 | `FFVHTH` |
| Total power | mW | ≤9 | 5.293 | 7.900 | `FFVHTH` |
| Differential DC gain | dB | ≥85 | 88.699 | 86.753 | `FSVLTH` |
| Differential UGF | MHz | ≥8 | 12.447 | 8.435 | `SSVLTH` |
| Differential phase margin | ° | ≥60 | 72.649 | 63.377 | `FFVLTH` |
| Input differential offset | µV | ±3000 | −0.000 | 0.000 | `SFVHNOM` |
| CMRR @ 60 Hz | dB | ≥80 | 285.310 | 206.691 | `SFNOMTL` |
| CMRR @ 150 Hz | dB | ≥80 | 285.322 | 206.691 | `SFNOMTL` |
| PSRR+ @ 60 Hz | dB | ≥80 | 266.685 | 193.356 | `SFNOMTL` |
| PSRR+ @ 150 Hz | dB | ≥80 | 258.182 | 193.357 | `SFNOMTL` |
| PSRR- @ 60 Hz | dB | ≥80 | 282.569 | 204.631 | `SFNOMTL` |
| PSRR- @ 150 Hz | dB | ≥80 | 277.076 | 204.630 | `SFNOMTL` |
| Input-referred noise 0.05-150 Hz | µVrms | ≤4 | 3.086 | 3.514 | `SSVHTH` |
| Closed-loop differential gain | dB | Report | −3.190e−04 | −2.802e−04 | `SFVHTL` |
| Gain error | % | ±0.01 | −0.004 | −0.005 | `FSVLTH` |
| Output common mode, DC | V | Report | 1.650 | 1.813 | `SSVHTH` |
| Output CM error | mV | ±25 | 0.395 | 12.643 | `SSVHTH` |
| Input CM low | mV | ≤1000 | 870.000 | 975.000 | `SSVHNOM` |
| Input CM high | V | ≥2.3 | 3.300 | 2.740 | `FSVLTH` |
| Input CM high headroom | mV | Report | 0.000 | 260.000 | `FSVLTH` |
| Differential output swing low | V | ≤-1.8 | −3.188 | −2.803 | `FSVLTH` |
| Differential output swing high | V | ≥1.8 | 3.188 | 2.803 | `FSVLTH` |
| Differential SR rise | V/µs | ≥4 | 7.232 | 5.135 | `SSVLTL` |
| Differential SR fall | V/µs | ≥4 | 7.232 | 5.135 | `SSVLTL` |
| Differential settling time | ns | ≤300 | 149.698 | 234.856 | `SSVLTL` |
| Differential-step CM disturbance | mV | ≤60 | 30.247 | 40.985 | `SSVLTH` |
| CMFB SR rise | V/µs | ≥2 | 3.589 | 2.499 | `SSVLTL` |
| CMFB SR fall | V/µs | ≥2 | 3.526 | 2.613 | `SSVLTH` |
| CMFB settling time | ns | ≤1000 | 329.729 | 404.130 | `SSVLTL` |

### 3.4 INA + RLD

[Detailed INA + RLD report](Report/AFE_BLOCKS/INA_RLD_Report.md)

> The INA+RLD common-mode fixture has been revised. Values below are the last available pre-update results and must be regenerated before final signoff.

| Parameter | Unit | Specification | NOM | Worst case | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| Total current | mA | ≤6.2 | 3.860 | 5.300 | `FFVHTH` |
| Total power | mW | ≤22 | 12.738 | 19.079 | `FFVHTH` |
| Output CM error | mV | ±40 | 0.395 | 12.649 | `SSVHTH` |
| Input-referred offset | µV | ±2000 | 0.000 | 0.002 | `SSVLTH` |
| S1 gain | V/V | Report | 60.006 | 59.902 | `FFVLTL` |
| S1 gain dB | dB | Report | 35.564 | 35.549 | `FFVLTL` |
| S1 gain error | % | ±0.5 | 0.009 | −0.163 | `FFVLTL` |
| S1 -3 dB bandwidth | kHz | ≥150 | 261.757 | 178.688 | `SSVLTH` |
| S2 gain | V/V | Report | 4.000 | 3.998 | `FFVLTL` |
| S2 gain dB | dB | Report | 12.041 | 12.037 | `FFVLTL` |
| S2 gain error | % | ±0.25 | 0.002 | −0.052 | `FFVLTL` |
| S2 -3 dB bandwidth | MHz | ≥1.5 | 2.647 | 1.793 | `SSVLTH` |
| INA gain | V/V | Report | 240.027 | 239.484 | `FFVLTL` |
| INA gain dB | dB | Report | 47.605 | 47.586 | `FFVLTL` |
| INA gain error | % | ±0.5 | 0.011 | −0.215 | `FFVLTL` |
| Gain flatness 0.05-150 Hz | dB | ≤0.1 | 1.432e−06 | 3.079e−06 | `SSVLTH` |
| INA -3 dB bandwidth | kHz | ≥150 | 259.286 | 176.996 | `SSVLTH` |
| INA CMRR @ 60 Hz | dB | ≥80 | 225.384 | 204.344 | `SSNOMTH` |
| INA CMRR @ 150 Hz | dB | ≥80 | 225.265 | 203.835 | `SSNOMTH` |
| INA PSRR+ @ 60 Hz | dB | ≥80 | 200.677 | 185.924 | `NOMVHTL` |
| INA PSRR+ @ 150 Hz | dB | ≥80 | 200.748 | 182.098 | `SSNOMNOM` |
| INA PSRR- @ 60 Hz | dB | ≥80 | 216.490 | 201.470 | `SSVLTH` |
| INA PSRR- @ 150 Hz | dB | ≥80 | 216.000 | 201.309 | `SSVLTH` |
| Input-referred noise 0.05-150 Hz | µVrms | ≤4 | 2.667 | 3.117 | `SSVLTH` |
| RLD -3 dB bandwidth | Hz | ≥300 | 390.045 | 131.138 | `SSNOMTL` |
| RLD phase margin | ° | ≥60 | 100.672 | 100.092 | `FFVLTH` |
| Input CM suppression @ 60 Hz | dB | ≥50 | 55.072 | 54.644 | `SSVLTL` |
| Input CM suppression @ 150 Hz | dB | ≥45 | 53.257 | 51.676 | `SSVLTL` |

### 3.5 LPF

[Detailed LPF report](Report/AFE_BLOCKS/LPF_Report.md)

| Parameter | Unit | Specification | NOM | Worst case | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| FDC bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| CMFB bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| Total current | mA | ≤2.5 | 1.604 | 2.194 | `FFVHTH` |
| Total power | mW | ≤9 | 5.293 | 7.900 | `FFVHTH` |
| Output CM error | mV | ±25 | 0.395 | 12.659 | `SSVHTH` |
| LPF input offset | mV | ±6 | 0.000 | −0.000 | `SFVLTH` |
| Passband gain | V/V | Report | 1.000 | 0.999 | `SSVLTL` |
| Passband gain error | % | ±0.5 | −0.027 | −0.050 | `SSVLTL` |
| Loss @ 150 Hz | dB | Report | 0.361 | 0.762 | `SSVHTL` |
| LPF -1 dB frequency | Hz | ≥150 | 258.691 | 174.135 | `SSVHTL` |
| LPF -3 dB frequency | Hz | Report | 506.912 | 340.986 | `SSVHTL` |
| CMRR @ 60 Hz | dB | ≥80 | 245.253 | 218.616 | `SSVHNOM` |
| CMRR @ 150 Hz | dB | ≥80 | 245.225 | 218.582 | `SSVLNOM` |
| PSRR+ @ 60 Hz | dB | ≥80 | 191.538 | 190.541 | `SSVHNOM` |
| PSRR+ @ 150 Hz | dB | ≥80 | 257.637 | 189.146 | `SSVLTH` |
| PSRR- @ 60 Hz | dB | ≥80 | 234.605 | 204.439 | `SSVLNOM` |
| PSRR- @ 150 Hz | dB | ≥80 | 236.558 | 204.885 | `SSVLNOM` |
| Input-referred noise 0.05-150 Hz | µVrms | ≤10 | 6.176 | 7.036 | `SSVHTH` |

### 3.6 PGA

[Detailed PGA report](Report/AFE_BLOCKS/PGA_Report.md)

| Parameter | Unit | Specification | NOM | Worst case | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| FDC bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| CMFB bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| Total current | mA | ≤2.5 | 1.604 | 2.195 | `FFVHTH` |
| Total power | mW | ≤9 | 5.293 | 7.901 | `FFVHTH` |
| Output CM error | mV | ±20 | 0.395 | 12.654 | `SSVHTH` |
| G2 input offset | mV | ±5 | 2.329e−08 | −7.953e−07 | `NOMVLTH` |
| G2 gain @ 10 Hz | V/V | Report | 2.015 | 2.050 | `SSVLTH` |
| G2 gain @ 150 Hz | V/V | Report | 2.015 | 2.050 | `SSVLTH` |
| G2 gain error | % | ±5 | 0.751 | 2.502 | `SSVLTH` |
| G2 -3 dB bandwidth | MHz | ≥0.15 | 5.053 | 3.307 | `SSVLTH` |
| G2 CMRR @ 60 Hz | dB | ≥80 | 256.698 | 222.787 | `NOMVLTH` |
| G2 CMRR @ 150 Hz | dB | ≥80 | 256.479 | 222.782 | `NOMVLTH` |
| G2 PSRR+ @ 60 Hz | dB | ≥80 | 246.395 | 215.788 | `FSVLNOM` |
| G2 PSRR+ @ 150 Hz | dB | ≥80 | 246.262 | 215.788 | `FSVLNOM` |
| G2 PSRR- @ 60 Hz | dB | ≥80 | 234.094 | 214.207 | `FSVLNOM` |
| G2 PSRR- @ 150 Hz | dB | ≥80 | 232.714 | 214.031 | `FSVLNOM` |
| G2 input-referred noise 0.05-150 Hz | µVrms | ≤10 | 4.617 | 5.250 | `SSVHTH` |
| G4 input offset | mV | ±5 | −6.921e−08 | −5.292e−07 | `SFNOMTL` |
| G4 gain @ 10 Hz | V/V | Report | 3.991 | 3.983 | `FFVHTL` |
| G4 gain @ 150 Hz | V/V | Report | 3.991 | 3.983 | `FFVHTL` |
| G4 gain error | % | ±5 | −0.236 | −0.419 | `FFVHTL` |
| G4 -3 dB bandwidth | MHz | ≥0.15 | 3.025 | 1.995 | `SSVLTH` |
| G4 CMRR @ 60 Hz | dB | ≥80 | 226.805 | 215.757 | `SSNOMTH` |
| G4 CMRR @ 150 Hz | dB | ≥80 | 220.287 | 218.204 | `SFNOMTL` |
| G4 PSRR+ @ 60 Hz | dB | ≥80 | 236.682 | 228.453 | `FSVLNOM` |
| G4 PSRR+ @ 150 Hz | dB | ≥80 | 236.710 | 228.462 | `FSVLNOM` |
| G4 PSRR- @ 60 Hz | dB | ≥80 | 217.577 | 207.743 | `SSVHTH` |
| G4 PSRR- @ 150 Hz | dB | ≥80 | 211.726 | 210.543 | `FSVLNOM` |
| G4 input-referred noise 0.05-150 Hz | µVrms | ≤10 | 3.859 | 4.394 | `SSVHTH` |
| G8 input offset | mV | ±5 | 9.462e−07 | 9.462e−07 | `NOMNOMNOM` |
| G8 gain @ 10 Hz | V/V | Report | 7.958 | 7.942 | `FFVHTL` |
| G8 gain @ 150 Hz | V/V | Report | 7.958 | 7.942 | `FFVHTL` |
| G8 gain error | % | ±5 | −0.522 | −0.721 | `FFVHTL` |
| G8 -3 dB bandwidth | MHz | ≥0.15 | 2.070 | 1.281 | `SSVLTH` |
| G8 CMRR @ 60 Hz | dB | ≥80 | 211.955 | 184.741 | `NOMVHNOM` |
| G8 CMRR @ 150 Hz | dB | ≥80 | 218.025 | 184.550 | `NOMVHNOM` |
| G8 PSRR+ @ 60 Hz | dB | ≥80 | 231.664 | 223.246 | `SSVLTH` |
| G8 PSRR+ @ 150 Hz | dB | ≥80 | 231.658 | 223.229 | `SSVLTH` |
| G8 PSRR- @ 60 Hz | dB | ≥80 | 207.945 | 181.216 | `NOMVHNOM` |
| G8 PSRR- @ 150 Hz | dB | ≥80 | 213.545 | 181.026 | `NOMVHNOM` |
| G8 input-referred noise 0.05-150 Hz | µVrms | ≤10 | 3.473 | 3.955 | `SSVHTH` |
| G16 input offset | mV | ±5 | 3.383e−07 | −6.475e−07 | `NOMVHTH` |
| G16 gain @ 10 Hz | V/V | Report | 15.860 | 15.851 | `FFVLTL` |
| G16 gain @ 150 Hz | V/V | Report | 15.860 | 15.851 | `FFVLTL` |
| G16 gain error | % | ±5 | −0.878 | −0.932 | `FFVLTL` |
| G16 -3 dB bandwidth | MHz | ≥0.15 | 0.907 | 0.595 | `SSVLTH` |
| G16 CMRR @ 60 Hz | dB | ≥80 | 188.992 | 188.991 | `NOMVHNOM` |
| G16 CMRR @ 150 Hz | dB | ≥80 | 188.555 | 188.546 | `FSVHNOM` |
| G16 PSRR+ @ 60 Hz | dB | ≥80 | 269.035 | 248.314 | `FFVLTH` |
| G16 PSRR+ @ 150 Hz | dB | ≥80 | 267.726 | 248.353 | `FFVLTH` |
| G16 PSRR- @ 60 Hz | dB | ≥80 | 186.022 | 186.020 | `FSVHNOM` |
| G16 PSRR- @ 150 Hz | dB | ≥80 | 185.643 | 185.634 | `FSVHNOM` |
| G16 input-referred noise 0.05-150 Hz | µVrms | ≤10 | 3.280 | 3.736 | `SSVHTH` |

The FDBUF, integrated AFE, and SAR ADC are not assigned result tables because their formal analyzer outputs are still pending. Their detailed reports list the available design files, raw data, and required completion work.

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
| Common-mode compatibility | Block-level only | Verify FDBUF output common mode against ADC sampling input |
| ADC input capacitance | Not signed off | Extract the effective per-side sampling capacitance |
| Acquisition settling | Not tested | Simulate FDBUF settling during bootstrapped sampling |
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
| Output driver | [FDBUF report](Report/AFE_BLOCKS/FDBUF_Report.md) | Raw-data inventory and pending signoff work |
| AFE system | [Integrated AFE report](Report/AFE_BLOCKS/AFE_Report.md) | Integration scope and pending system measurements |
| Data converter | [SAR ADC report](Report/SAR_ADC_BLOCKS/SAR_ADC_Report.md) | Complete hierarchy and pending ADC signoff work |

## 7. Reproducing completed analyses

Run from the repository root after generating the corresponding ngspice TXT exports:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','SEOTA')); SEOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','FDOTA')); FDOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','INA_RLD')); INA_RLD_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','LPF')); LPF_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','PGA')); PGA_Analyze"
```

The analyzers follow a numeric-first workflow:

```text
ngspice TXT → double-precision calculations → PVT/MC selection → unit scaling → CSV and plots
```

## 8. Next steps

1. Complete the FDBUF analyzer and MM/GL/FULL campaigns.
2. Complete the integrated AFE testbench and verify all four gain settings while driving the ADC input.
3. Build SAR ADC static, dynamic, timing, power, and PVT/MC verification.
4. Complete matching-aware layout, DRC, and LVS.
5. Repeat selected PVT and FULL Monte Carlo campaigns with extracted parasitics.
6. Integrate the pad ring and prepare the laboratory characterization plan.
