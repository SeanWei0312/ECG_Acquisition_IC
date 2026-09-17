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
| Bias-network current | 83.192 µA | 103.971 µA maximum |
| Bias-network power | 274.532 µW | 374.297 µW maximum |
| Startup settling | 807.362 µs | 1180.281 µs maximum |
| Startup failures | 0 | 0 of 35 |
| Reference error | −4.170 µV | 6.154 µV maximum absolute error |
| Mirror tracking error | −0.0028% | 0.149% maximum absolute error |
| Selector transmission error | — | 25.466 nV maximum |

<details>
<summary>Complete BIAS/SEL worst-case results</summary>

| Parameter | Value | Corner / condition |
| :--- | ---: | :---: |
| Minimum bias current | 31.054 µA | `SS`, −40°C, 3.0 V |
| Maximum bias current | 49.441 µA | `FF`, +125°C, 3.6 V |
| Maximum absolute bias-current error | 23.603% | `FF`, +125°C, 3.6 V |
| Minimum BP voltage | 1.138 V | `FS`, +125°C, 3.0 V |
| Maximum BP voltage | 2.146 V | `SF`, −40°C, 3.6 V |
| Maximum absolute reference error | 6.154 µV | `SS`, −40°C, 3.6 V |
| Maximum absolute mirror error | 0.149% | `FS`, +125°C, 3.0 V |
| Minimum startup-device margin | 0.7415 V | `FF`, +125°C, 3.6 V |
| Maximum supply current | 103.971 µA | `FF`, +125°C, 3.6 V |
| Maximum power | 374.297 µW | `FF`, +125°C, 3.6 V |
| Maximum startup time | 1180.281 µs | `SS`, −40°C, 3.0 V |
| Startup failures | 0 of 35 | All startup cases |
| Maximum BP internal-selector error | 12.495 nV | `SFVH` |
| Maximum BP external-selector error | 25.466 nV | `SSTH` |
| Maximum VREF internal-selector error | 18.749 nV | `SSVL` |
| Maximum VREF external-selector error | 10.951 nV | `SSVL` |

</details>

<details>
<summary>All generated BIAS/SEL plots</summary>

![BIAS 2D voltage-temperature surface](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_2D.png)

![BIAS selector verification](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_SEL.png)

![BIAS startup current](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_STARTUP.png)

![BIAS startup voltage](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_STARTUP_VOLTAGE.png)

![BIAS temperature sweep](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_TEMP.png)

![BIAS supply sweep](Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_VDD.png)

</details>

### 5.2 Single-ended OTA

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current | ≤1.25 mA | 0.825 mA | 1.106 mA | `FFVHTH` |
| DC gain | ≥88 dB | 96.522 dB | 93.988 dB | `FSVLTH` |
| UGF | ≥8 MHz | 12.835 MHz | 8.762 MHz | `SSVLTH` |
| Phase margin | ≥55° | 67.767° | 56.368° | `FFVLTH` |
| Input offset | ±2 mV | 3.193 µV | 12.092 µV | `FSVLTH` |
| CMRR at 60 Hz | ≥105 dB | 111.957 dB | 109.711 dB | `SSVLTH` |
| PSRR+ at 60 / 150 Hz | ≥100 / 95 dB | 103.379 / 99.232 dB | 101.385 / 96.565 dB | `SSVLTL` / `SSVLTH` |
| Input noise, 0.05–150 Hz | ≤2.5 µVrms | 1.873 µVrms | 2.189 µVrms | `SSVLTH` |
| Slew rate, rise / fall | ≥6.5 / 5.0 V/µs | 9.814 / 7.966 V/µs | 6.927 / 5.636 V/µs | `SSVLTL` |
| Settling time | ≤225 ns | 163.4 ns | 213.4 ns | `SSVLTL` |

The 200-run FULL Monte Carlo set also passes every formal limit. Observed input offset spans −970.439 to +1177.630 µV, DC gain remains above 95.488 dB, UGF remains above 11.764 MHz, and phase margin remains above 64.231°. The fitted input-offset interval is approximately −1.234 to +1.243 mV at $\mu\pm3\sigma$, within the ±2 mV requirement.

<details>
<summary>Complete SE OTA FULL Monte Carlo results</summary>

| Parameter | Unit | Spec | Minimum | Mean | Maximum | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| Bias current | µA | 40±10 | 38.595 | 40.056 | 41.411 | 100% |
| Total current | mA | ≤1.25 | 0.789 | 0.833 | 0.895 | 100% |
| Total power | mW | ≤4.5 | 2.603 | 2.749 | 2.954 | 100% |
| DC gain | dB | ≥88 | 95.488 | 96.416 | 97.396 | 100% |
| UGF | MHz | ≥8 | 11.764 | 12.835 | 13.961 | 100% |
| Phase margin | deg | ≥55 | 64.231 | 67.829 | 73.006 | 100% |
| Input offset | µV | ±2000 | −970.439 | 4.135 | 1177.630 | 100% |
| Gain error | % | ±0.01 | −0.0025 | −0.0012 | 0.0000 | 100% |

</details>

<details>
<summary>Complete SE OTA PVT results</summary>

| Parameter | Unit | Spec | Nominal | Full-PVT worst | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| Bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| Total current | mA | ≤1.25 | 0.825 | 1.106 | `FFVHTH` |
| Total power | mW | ≤4.5 | 2.721 | 3.982 | `FFVHTH` |
| DC gain | dB | ≥88 | 96.522 | 93.988 | `FSVLTH` |
| UGF | MHz | ≥8 | 12.835 | 8.762 | `SSVLTH` |
| Phase margin | deg | ≥55 | 67.767 | 56.368 | `FFVLTH` |
| Input offset | µV | ±2000 | 3.193 | 12.092 | `FSVLTH` |
| CMRR @ 60 Hz | dB | ≥105 | 111.957 | 109.711 | `SSVLTH` |
| CMRR @ 150 Hz | dB | ≥105 | 111.957 | 109.711 | `SSVLTH` |
| PSRR+ @ 60 Hz | dB | ≥100 | 103.379 | 101.385 | `SSVLTL` |
| PSRR+ @ 150 Hz | dB | ≥95 | 99.232 | 96.565 | `SSVLTH` |
| PSRR− @ 60 Hz | dB | ≥100 | 103.379 | 101.385 | `SSVLTL` |
| PSRR− @ 150 Hz | dB | ≥95 | 99.232 | 96.565 | `SSVLTH` |
| Input-referred noise, 0.05–150 Hz | µVrms | ≤2.5 | 1.873 | 2.189 | `SSVLTH` |
| Closed-loop gain | dB | Report | $-1.042\times10^{-4}$ | $-9.346\times10^{-5}$ | `FFVHNOM` |
| Gain error | % | ±0.01 | −0.001 | −0.001 | `FSVLTH` |
| Output DC error | µV | ±2000 | −3.192 | −12.092 | `FSVLTH` |
| Input low | mV | ≤600 | 106.000 | 429.000 | `SSVHTL` |
| Input high | V | ≥2.75 | 3.237 | 2.815 | `FSVLTH` |
| Input high headroom | mV | ≤250 | 63.000 | 185.000 | `FSVLTH` |
| Output low | mV | ≤600 | 107.816 | 430.970 | `SSVHTL` |
| Output high | V | ≥2.75 | 3.235 | 2.813 | `FSVLTH` |
| Output high headroom | mV | ≤250 | 64.870 | 187.000 | `FSVLTH` |
| Slew rate, rise | V/µs | ≥6.5 | 9.814 | 6.927 | `SSVLTL` |
| Slew rate, fall | V/µs | ≥5.0 | 7.966 | 5.636 | `SSVLTL` |
| Settling time | ns | ≤225 | 163.400 | 213.400 | `SSVLTL` |

</details>

<details>
<summary>All generated SE OTA plots</summary>

![SE OTA open-loop gain and phase](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.open_loop_gain_phase.png)

![SE OTA open-loop transfer curve](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.open_loop_vtc.png)

![SE OTA CMRR](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.cmrr.png)

![SE OTA PSRR](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.psrr.png)

![SE OTA input-referred noise](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.input_referred_noise_density.png)

![SE OTA closed-loop usable range](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.closed_loop_usable_range.png)

![SE OTA closed-loop step response](Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.closed_loop_step_response.png)

![SE OTA MC input offset](Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_01_Vos_Histogram.png)

![SE OTA MC DC gain](Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_02_DC_Gain_Histogram.png)

![SE OTA MC UGF](Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_03_UGF_Histogram.png)

![SE OTA MC phase margin](Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_04_Phase_Margin_Histogram.png)

![SE OTA MC gain error](Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_05_Gain_Error_Histogram.png)

</details>

### 5.3 Fully differential OTA

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current | ≤2.5 mA | 1.604 mA | 2.194 mA | `FFVHTH` |
| Differential gain | ≥85 dB | 88.699 dB | 86.753 dB | `FSVLTH` |
| Differential UGF | ≥8 MHz | 12.447 MHz | 8.435 MHz | `SSVLTH` |
| Differential phase margin | ≥60° | 72.649° | 63.377° | `FFVLTH` |
| Differential input offset | ±3 mV | −0.000 µV | 0.000 µV | `SFVHNOM` |
| Output CM error | ±25 mV | 0.395 mV | 12.643 mV | `SSVHTH` |
| CMRR at 60 / 150 Hz | ≥80 / 80 dB | 285.310 / 285.322 dB | 206.691 / 206.691 dB | `SFNOMTL` |
| PSRR+ at 60 / 150 Hz | ≥80 / 80 dB | 266.685 / 258.182 dB | 193.356 / 193.357 dB | `SFNOMTL` |
| Input noise, 0.05–150 Hz | ≤4 µVrms | 3.086 µVrms | 3.514 µVrms | `SSVHTH` |
| Differential output swing | ≥±1.8 V | ±3.188 V | ±2.803 V | `FSVLTH` |
| Differential slew rate | ≥4 V/µs | 7.232 V/µs | 5.135 V/µs | `SSVLTL` |
| Differential settling | ≤300 ns | 149.7 ns | 234.9 ns | `SSVLTL` |
| Differential-step CM disturbance | ≤60 mV | 30.247 mV | 40.985 mV | `SSVLTH` |
| CMFB settling | ≤1000 ns | 329.7 ns | 404.1 ns | `SSVLTL` |

The 200-run FULL Monte Carlo set passes every formal limit. Observed differential input offset spans −2.096 to +2.354 mV against the ±3 mV specification. Differential gain remains above 87.784 dB, UGF above 11.307 MHz, phase margin above 68.996°, and output common-mode error remains between −9.947 and +13.681 mV.

Nominal internal checks place the standalone differential core at 90.090 dB gain, 12.489 MHz UGF, and 72.529° phase margin. The CMFB amplifier has 45.128 dB gain, 966.924 MHz UGF, 71.906° phase margin, and 4.8–5.2 ns closed-loop settling in its dedicated testbench.

<details>
<summary>Complete FD OTA FULL Monte Carlo results</summary>

| Parameter | Unit | Spec | Minimum | Mean | Maximum | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| FDC bias current | µA | 40±10 | 38.723 | 40.080 | 41.716 | 100% |
| CMFB bias current | µA | 40±10 | 38.712 | 40.088 | 41.605 | 100% |
| Total current | mA | ≤2.5 | 1.519 | 1.606 | 1.745 | 100% |
| Total power | mW | ≤9 | 5.013 | 5.299 | 5.758 | 100% |
| Differential DC gain | dB | ≥85 | 87.784 | 88.667 | 89.622 | 100% |
| Differential UGF | MHz | ≥8 | 11.307 | 12.469 | 13.686 | 100% |
| Differential phase margin | deg | ≥60 | 68.996 | 72.665 | 77.849 | 100% |
| Input differential offset | µV | ±3000 | −2096.150 | 30.711 | 2354.430 | 100% |
| Gain error | % | ±0.01 | −0.0041 | −0.0037 | −0.0033 | 100% |
| Output CM error | mV | ±25 | −9.947 | 0.073 | 13.681 | 100% |

</details>

<details>
<summary>Complete FD OTA PVT results</summary>

| Parameter | Unit | Spec | Nominal | Full-PVT worst | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| FDC bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| CMFB bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| Total current | mA | ≤2.5 | 1.604 | 2.194 | `FFVHTH` |
| Total power | mW | ≤9 | 5.293 | 7.900 | `FFVHTH` |
| Differential DC gain | dB | ≥85 | 88.699 | 86.753 | `FSVLTH` |
| Differential UGF | MHz | ≥8 | 12.447 | 8.435 | `SSVLTH` |
| Differential phase margin | deg | ≥60 | 72.649 | 63.377 | `FFVLTH` |
| Input differential offset | µV | ±3000 | −0.000 | 0.000 | `SFVHNOM` |
| CMRR @ 60 Hz | dB | ≥80 | 285.310 | 206.691 | `SFNOMTL` |
| CMRR @ 150 Hz | dB | ≥80 | 285.322 | 206.691 | `SFNOMTL` |
| PSRR+ @ 60 Hz | dB | ≥80 | 266.685 | 193.356 | `SFNOMTL` |
| PSRR+ @ 150 Hz | dB | ≥80 | 258.182 | 193.357 | `SFNOMTL` |
| PSRR− @ 60 Hz | dB | ≥80 | 282.569 | 204.631 | `SFNOMTL` |
| PSRR− @ 150 Hz | dB | ≥80 | 277.076 | 204.630 | `SFNOMTL` |
| Input-referred noise, 0.05–150 Hz | µVrms | ≤4 | 3.086 | 3.514 | `SSVHTH` |
| Closed-loop differential gain | dB | Report | $-3.190\times10^{-4}$ | $-2.802\times10^{-4}$ | `SFVHTL` |
| Gain error | % | ±0.01 | −0.004 | −0.005 | `FSVLTH` |
| Output common mode, DC | V | Report | 1.650 | 1.813 | `SSVHTH` |
| Output CM error | mV | ±25 | 0.395 | 12.643 | `SSVHTH` |
| Input CM low | mV | ≤1000 | 870.000 | 975.000 | `SSVHNOM` |
| Input CM high | V | ≥2.3 | 3.300 | 2.740 | `FSVLTH` |
| Input CM high headroom | mV | Report | 0.000 | 260.000 | `FSVLTH` |
| Differential output swing low | V | ≤−1.8 | −3.188 | −2.803 | `FSVLTH` |
| Differential output swing high | V | ≥1.8 | 3.188 | 2.803 | `FSVLTH` |
| Differential slew rate, rise | V/µs | ≥4 | 7.232 | 5.135 | `SSVLTL` |
| Differential slew rate, fall | V/µs | ≥4 | 7.232 | 5.135 | `SSVLTL` |
| Differential settling time | ns | ≤300 | 149.698 | 234.856 | `SSVLTL` |
| Differential-step CM disturbance | mV | ≤60 | 30.247 | 40.985 | `SSVLTH` |
| CMFB slew rate, rise | V/µs | ≥2 | 3.589 | 2.499 | `SSVLTL` |
| CMFB slew rate, fall | V/µs | ≥2 | 3.526 | 2.613 | `SSVLTH` |
| CMFB settling time | ns | ≤1000 | 329.729 | 404.130 | `SSVLTL` |

</details>

<details>
<summary>All generated FD OTA plots</summary>

![FD OTA open-loop gain and phase](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.open_loop_gain_phase.png)

![FD OTA open-loop transfer curve](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.open_loop_vtc.png)

![FD OTA CMRR](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.cmrr.png)

![FD OTA PSRR](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.psrr.png)

![FD OTA input-referred noise](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.input_referred_noise_density.png)

![FD OTA input common-mode range](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.input_common_mode_range.png)

![FD OTA output swing and closed-loop transfer](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.output_swing_and_closed_loop_vtc.png)

![FD OTA closed-loop step response](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.closed_loop_step_response.png)

![FD OTA differential-step common-mode disturbance](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.diff_step_cm_disturbance.png)

![FD OTA output common-mode transient](Measurement_Results/IC_Simulation/FD_OTA/Plots/NOM.output_cm_transient.png)

![FD OTA MC input offset](Measurement_Results/IC_Simulation/FD_OTA/Plots/Fig_MC_01_Input_Offset_Histogram.png)

![FD OTA MC output common-mode error](Measurement_Results/IC_Simulation/FD_OTA/Plots/Fig_MC_02_Output_CM_Error_Histogram.png)

![FD OTA MC DC gain](Measurement_Results/IC_Simulation/FD_OTA/Plots/Fig_MC_03_DC_Gain_Histogram.png)

![FD OTA MC UGF](Measurement_Results/IC_Simulation/FD_OTA/Plots/Fig_MC_04_UGF_Histogram.png)

![FD OTA MC phase margin](Measurement_Results/IC_Simulation/FD_OTA/Plots/Fig_MC_05_Phase_Margin_Histogram.png)

![FD OTA MC gain error](Measurement_Results/IC_Simulation/FD_OTA/Plots/Fig_MC_06_Gain_Error_Histogram.png)

</details>

### 5.4 Instrumentation amplifier and right-leg drive

The balanced INA+RLD report contains formal limits for operating point, offset, gain accuracy, bandwidth, rejection, noise, loop stability, common-mode suppression, rail headroom, and interference-induced gain change. Gain values in V/V and dB remain descriptive. RLD swing ratio and peak current are retained only as debug quantities and are not formal signoff rows.

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current / power | ≤6.2 mA / ≤22 mW | 3.860 mA / 12.738 mW | 5.300 mA / 19.079 mW | `FFVHTH` |
| Output CM error | ±40 mV | 0.395 mV | 12.649 mV | `SSVHTH` |
| Input-referred offset | ±2 mV | 0.000 µV | 0.002 µV | `SSVLTH` |
| S1 gain error | ±0.5% | 0.009% | −0.163% | `FFVLTL` |
| S2 gain error | ±0.25% | 0.002% | −0.052% | `FFVLTL` |
| INA gain error | ±0.5% | 0.011% | −0.215% | `FFVLTL` |
| Gain flatness, 0.05–150 Hz | ≤0.1 dB | $1.432\times10^{-6}$ dB | $3.079\times10^{-6}$ dB | `SSVLTH` |
| INA bandwidth | ≥150 kHz | 259.286 kHz | 176.996 kHz | `SSVLTH` |
| INA CMRR, 60 / 150 Hz | ≥80 / 80 dB | 225.384 / 225.265 dB | 204.344 / 203.835 dB | `SSNOMTH` |
| INA PSRR+, 60 / 150 Hz | ≥80 / 80 dB | 200.677 / 200.748 dB | 185.924 / 182.098 dB | `NOMVHTL` / `SSNOMNOM` |
| INA PSRR−, 60 / 150 Hz | ≥80 / 80 dB | 216.490 / 216.000 dB | 201.470 / 201.309 dB | `SSVLTH` |
| Input noise, 0.05–150 Hz | ≤4 µVrms | 2.667 µVrms | 3.117 µVrms | `SSVLTH` |
| RLD UGF | 0.5–1.6 kHz | 0.946 kHz | 1.502 kHz | `FFVHTH` |
| RLD phase margin | ≥60° | 100.672° | 100.092° | `FFVLTH` |
| CM suppression, 60 / 150 Hz | ≥50 / 45 dB | 55.072 / 53.257 dB | 54.644 / 51.676 dB | `SSVLTL` |
| RLD rail headroom | ≥0.1 V | 1.647 V | 1.497 V | `FFVLTH` |
| CM-interference gain change | ±0.1% | $-3.724\times10^{-5}$% | $6.725\times10^{-4}$% | `SSVHTL` |

The 200-run FULL Monte Carlo set passes every formal limit. Observed input-referred offset spans −1.448 to +1.849 mV, INA gain error spans −0.378% to +0.324%, and the minimum sampled CMRR is 95.303 dB. RLD UGF spans 0.820–1.086 kHz, phase margin remains above 100.504°, and common-mode suppression remains above 54.959 dB at 60 Hz and 52.789 dB at 150 Hz.

<details>
<summary>Complete INA+RLD FULL Monte Carlo results</summary>

| Parameter | Unit | Spec | Minimum | Mean | Maximum | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| Total current | mA | ≤6.2 | 3.701 | 3.870 | 4.109 | 100% |
| Total power | mW | ≤22 | 12.212 | 12.769 | 13.558 | 100% |
| Output CM error | mV | ±40 | −9.988 | 0.095 | 13.891 | 100% |
| Input-referred offset | µV | ±2000 | −1447.910 | −2.212 | 1848.980 | 100% |
| S1 gain | V/V | Report | 59.829 | 60.003 | 60.146 | — |
| S1 gain error | % | ±0.5 | −0.285 | 0.005 | 0.244 | 100% |
| S2 gain | V/V | Report | 3.996 | 4.000 | 4.003 | — |
| S2 gain error | % | ±0.25 | −0.094 | 0.001 | 0.080 | 100% |
| INA gain | V/V | Report | 239.092 | 240.014 | 240.777 | — |
| INA gain error | % | ±0.5 | −0.378 | 0.006 | 0.324 | 100% |
| INA CMRR @ 60 Hz | dB | ≥80 | 95.303 | 110.832 | 163.076 | 100% |
| INA CMRR @ 150 Hz | dB | ≥80 | 95.302 | 110.717 | 162.638 | 100% |
| RLD loop UGF | kHz | 0.5–1.6 | 0.820 | 0.948 | 1.086 | 100% |
| RLD phase margin | deg | ≥60 | 100.504 | 100.669 | 100.817 | 100% |
| Input CM suppression @ 60 Hz | dB | ≥50 | 54.959 | 55.075 | 55.164 | 100% |
| Input CM suppression @ 150 Hz | dB | ≥45 | 52.789 | 53.259 | 53.646 | 100% |

</details>

<details>
<summary>Complete INA+RLD PVT results</summary>

| Parameter | Unit | Spec | Nominal | Full-PVT worst | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| Total current | mA | ≤6.2 | 3.860 | 5.300 | `FFVHTH` |
| Total power | mW | ≤22 | 12.738 | 19.079 | `FFVHTH` |
| Output CM error | mV | ±40 | 0.395 | 12.649 | `SSVHTH` |
| Input-referred offset | µV | ±2000 | 0.000 | 0.002 | `SSVLTH` |
| S1 gain | V/V | Report | 60.006 | 59.902 | `FFVLTL` |
| S1 gain | dB | Report | 35.564 | 35.549 | `FFVLTL` |
| S1 gain error | % | ±0.5 | 0.009 | −0.163 | `FFVLTL` |
| S1 −3 dB bandwidth | kHz | ≥150 | 261.757 | 178.688 | `SSVLTH` |
| S2 gain | V/V | Report | 4.000 | 3.998 | `FFVLTL` |
| S2 gain | dB | Report | 12.041 | 12.037 | `FFVLTL` |
| S2 gain error | % | ±0.25 | 0.002 | −0.052 | `FFVLTL` |
| S2 −3 dB bandwidth | MHz | ≥1.5 | 2.647 | 1.793 | `SSVLTH` |
| INA gain | V/V | Report | 240.027 | 239.484 | `FFVLTL` |
| INA gain | dB | Report | 47.605 | 47.586 | `FFVLTL` |
| INA gain error | % | ±0.5 | 0.011 | −0.215 | `FFVLTL` |
| Gain flatness, 0.05–150 Hz | dB | ≤0.1 | $1.432\times10^{-6}$ | $3.079\times10^{-6}$ | `SSVLTH` |
| INA −3 dB bandwidth | kHz | ≥150 | 259.286 | 176.996 | `SSVLTH` |
| INA CMRR @ 60 Hz | dB | ≥80 | 225.384 | 204.344 | `SSNOMTH` |
| INA CMRR @ 150 Hz | dB | ≥80 | 225.265 | 203.835 | `SSNOMTH` |
| INA PSRR+ @ 60 Hz | dB | ≥80 | 200.677 | 185.924 | `NOMVHTL` |
| INA PSRR+ @ 150 Hz | dB | ≥80 | 200.748 | 182.098 | `SSNOMNOM` |
| INA PSRR− @ 60 Hz | dB | ≥80 | 216.490 | 201.470 | `SSVLTH` |
| INA PSRR− @ 150 Hz | dB | ≥80 | 216.000 | 201.309 | `SSVLTH` |
| Input-referred noise, 0.05–150 Hz | µVrms | ≤4 | 2.667 | 3.117 | `SSVLTH` |
| RLD loop UGF | kHz | 0.5–1.6 | 0.946 | 1.502 | `FFVHTH` |
| RLD phase margin | deg | ≥60 | 100.672 | 100.092 | `FFVLTH` |
| Input CM suppression @ 60 Hz | dB | ≥50 | 55.072 | 54.644 | `SSVLTL` |
| Input CM suppression @ 150 Hz | dB | ≥45 | 53.257 | 51.676 | `SSVLTL` |
| RLD output rail headroom | V | ≥0.1 | 1.647 | 1.497 | `FFVLTH` |
| CM-interference gain change | % | ±0.1 | $-3.724\times10^{-5}$ | $6.725\times10^{-4}$ | `SSVHTL` |

</details>

<details>
<summary>All generated INA+RLD plots</summary>

![INA differential frequency response](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_differential_ac.png)

![RLD loop gain and phase](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_loop_gain.png)

![INA CMRR and PSRR](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_rejection_response.png)

![INA and RLD common-mode rejection](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_cm_rejection.png)

![INA common-mode interference transient](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_transient.png)

![INA input-referred noise](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_noise.png)

![INA selector functional check](Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_sel_functional_check.png)

![INA MC input-referred offset](Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_01_Vos_Histogram.png)

![INA MC gain error](Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_02_INA_Gain_Error_Histogram.png)

![INA MC RLD UGF](Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_03_RLD_UGF_Histogram.png)

![INA MC RLD phase margin](Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_04_RLD_PM_Histogram.png)

![INA MC CMRR](Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_05_INA_CMRR_Histogram.png)

![INA MC input common-mode suppression](Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_06_Input_CM_Suppression_Histogram.png)

</details>

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
| CMRR, 60 / 150 Hz | ≥80 / 80 dB | 245.253 / 245.225 dB | 218.616 / 218.582 dB | `SSVHNOM` / `SSVLNOM` |
| PSRR+, 60 / 150 Hz | ≥80 / 80 dB | 191.538 / 257.637 dB | 190.541 / 189.146 dB | `SSVHNOM` / `SSVLTH` |
| PSRR−, 60 / 150 Hz | ≥80 / 80 dB | 234.605 / 236.558 dB | 204.439 / 204.885 dB | `SSVLNOM` |
| Input noise, 0.05–150 Hz | ≤10 µVrms | 6.176 µVrms | 7.036 µVrms | `SSVHTH` |

The 200-run FULL Monte Carlo set passes every formal limit. Observed LPF input offset spans −4.612 to +5.068 mV against the ±6 mV limit. Passband gain error stays between −0.0335% and −0.0219%, the −1 dB frequency remains above 224.388 Hz, and sampled CMRR remains above 91.208 dB at both 60 Hz and 150 Hz.

<details>
<summary>Complete LPF FULL Monte Carlo results</summary>

| Parameter | Unit | Spec | Minimum | Mean | Maximum | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| FDC bias current | µA | 40±10 | 38.520 | 40.106 | 41.822 | 100% |
| CMFB bias current | µA | 40±10 | 38.532 | 40.100 | 41.771 | 100% |
| Total current | mA | ≤2.5 | 1.522 | 1.608 | 1.694 | 100% |
| Total power | mW | ≤9 | 5.024 | 5.305 | 5.590 | 100% |
| Output CM error | mV | ±25 | −11.398 | 0.332 | 15.409 | 100% |
| LPF input offset | mV | ±6 | −4.612 | −0.090 | 5.068 | 100% |
| Passband gain | V/V | Report | 0.999665 | 0.999731 | 0.999781 | — |
| Passband gain error | % | ±0.5 | −0.0335 | −0.0269 | −0.0219 | 100% |
| LPF −1 dB frequency | Hz | ≥150 | 224.388 | 259.345 | 297.071 | 100% |
| LPF −3 dB frequency | Hz | Report | 439.608 | 508.186 | 582.188 | — |
| CMRR @ 60 Hz | dB | ≥80 | 91.218 | 107.861 | 151.259 | 100% |
| CMRR @ 150 Hz | dB | ≥80 | 91.208 | 107.775 | 147.169 | 100% |

</details>

<details>
<summary>Complete LPF PVT results</summary>

| Parameter | Unit | Spec | Nominal | Full-PVT worst | Corner |
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
| LPF −1 dB frequency | Hz | ≥150 | 258.691 | 174.135 | `SSVHTL` |
| LPF −3 dB frequency | Hz | Report | 506.912 | 340.986 | `SSVHTL` |
| CMRR @ 60 Hz | dB | ≥80 | 245.253 | 218.616 | `SSVHNOM` |
| CMRR @ 150 Hz | dB | ≥80 | 245.225 | 218.582 | `SSVLNOM` |
| PSRR+ @ 60 Hz | dB | ≥80 | 191.538 | 190.541 | `SSVHNOM` |
| PSRR+ @ 150 Hz | dB | ≥80 | 257.637 | 189.146 | `SSVLTH` |
| PSRR− @ 60 Hz | dB | ≥80 | 234.605 | 204.439 | `SSVLNOM` |
| PSRR− @ 150 Hz | dB | ≥80 | 236.558 | 204.885 | `SSVLNOM` |
| Input-referred noise, 0.05–150 Hz | µVrms | ≤10 | 6.176 | 7.036 | `SSVHTH` |

</details>

<details>
<summary>All generated LPF plots</summary>

![LPF differential frequency response](Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_differential_ac.png)

![LPF input-referred noise](Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_noise.png)

![LPF PVT CMRR response](Measurement_Results/IC_Simulation/LPF/Plots/LPF_PVT_CMRR_AC.png)

![LPF selector functional check](Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_SEL_functional_check.png)

![LPF MC −1 dB frequency](Measurement_Results/IC_Simulation/LPF/Plots/Fig_MC_01_LPF_1dB_Frequency_Histogram.png)

![LPF MC input offset](Measurement_Results/IC_Simulation/LPF/Plots/Fig_MC_02_Input_Offset_Histogram.png)

![LPF MC CMRR](Measurement_Results/IC_Simulation/LPF/Plots/Fig_MC_03_CMRR_Histogram.png)

</details>

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

Nominal gain-code results are:

| Gain code | Gain at 10 Hz | Gain error | −3 dB bandwidth | Input noise, 0.05–150 Hz |
| :---: | ---: | ---: | ---: | ---: |
| G2 | 2.015 V/V | +0.751% | 5.053 MHz | 4.617 µVrms |
| G4 | 3.991 V/V | −0.236% | 3.025 MHz | 3.859 µVrms |
| G8 | 7.958 V/V | −0.522% | 2.070 MHz | 3.473 µVrms |
| G16 | 15.860 V/V | −0.878% | 0.907 MHz | 3.280 µVrms |

The 200-run FULL Monte Carlo set passes every formal limit. The closest rejection margin occurs at G2, where sampled CMRR remains above 85.634 dB. G2 input offset spans −3.450 to +3.790 mV, while the other gain codes have smaller extrema. Across gain codes, sampled bandwidth minima are 4.588 MHz (G2), 2.754 MHz (G4), 1.854 MHz (G8), and 0.826 MHz (G16), all comfortably above 0.15 MHz.

<details>
<summary>Complete PGA FULL Monte Carlo results</summary>

| Parameter | Unit | Spec | Minimum | Mean | Maximum | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| FDC bias current | µA | 40±10 | 38.520 | 40.106 | 41.822 | 100% |
| CMFB bias current | µA | 40±10 | 38.532 | 40.100 | 41.771 | 100% |
| Total current | mA | ≤2.5 | 1.522 | 1.608 | 1.694 | 100% |
| Total power | mW | ≤9 | 5.023 | 5.305 | 5.590 | 100% |
| Output CM error | mV | ±20 | −11.394 | 0.332 | 15.402 | 100% |
| G2 input offset | mV | ±5 | −3.450 | −0.068 | 3.790 | 100% |
| G2 gain @ 10 Hz | V/V | Report | 2.010 | 2.015 | 2.024 | — |
| G2 gain error | % | ±5 | 0.489 | 0.755 | 1.223 | 100% |
| G2 gain @ 150 Hz | V/V | Report | 2.010 | 2.015 | 2.024 | — |
| G2 −3 dB bandwidth | MHz | ≥0.15 | 4.588 | 5.056 | 5.660 | 100% |
| G2 CMRR @ 60 Hz | dB | ≥80 | 85.634 | 101.150 | 140.705 | 100% |
| G2 CMRR @ 150 Hz | dB | ≥80 | 85.634 | 101.150 | 140.705 | 100% |
| G4 input offset | mV | ±5 | −2.884 | −0.056 | 3.169 | 100% |
| G4 gain @ 10 Hz | V/V | Report | 3.986 | 3.991 | 3.995 | — |
| G4 gain error | % | ±5 | −0.339 | −0.235 | −0.134 | 100% |
| G4 gain @ 150 Hz | V/V | Report | 3.986 | 3.991 | 3.995 | — |
| G4 −3 dB bandwidth | MHz | ≥0.15 | 2.754 | 3.027 | 3.364 | 100% |
| G4 CMRR @ 60 Hz | dB | ≥80 | 92.418 | 105.515 | 134.085 | 100% |
| G4 CMRR @ 150 Hz | dB | ≥80 | 92.418 | 105.515 | 134.085 | 100% |
| G8 input offset | mV | ±5 | −2.596 | −0.051 | 2.852 | 100% |
| G8 gain @ 10 Hz | V/V | Report | 7.947 | 7.958 | 7.967 | — |
| G8 gain error | % | ±5 | −0.657 | −0.523 | −0.409 | 100% |
| G8 gain @ 150 Hz | V/V | Report | 7.947 | 7.958 | 7.967 | — |
| G8 −3 dB bandwidth | MHz | ≥0.15 | 1.854 | 2.072 | 2.324 | 100% |
| G8 CMRR @ 60 Hz | dB | ≥80 | 91.302 | 107.708 | 145.889 | 100% |
| G8 CMRR @ 150 Hz | dB | ≥80 | 91.302 | 107.708 | 145.889 | 100% |
| G16 input offset | mV | ±5 | −2.452 | −0.048 | 2.694 | 100% |
| G16 gain @ 10 Hz | V/V | Report | 15.845 | 15.859 | 15.872 | — |
| G16 gain error | % | ±5 | −0.972 | −0.879 | −0.800 | 100% |
| G16 gain @ 150 Hz | V/V | Report | 15.845 | 15.859 | 15.872 | — |
| G16 −3 dB bandwidth | MHz | ≥0.15 | 0.826 | 0.908 | 1.003 | 100% |
| G16 CMRR @ 60 Hz | dB | ≥80 | 91.226 | 107.909 | 154.493 | 100% |
| G16 CMRR @ 150 Hz | dB | ≥80 | 91.226 | 107.909 | 154.483 | 100% |

</details>

<details>
<summary>Complete PGA PVT results</summary>

| Parameter | Unit | Spec | Nominal | Full-PVT worst | Corner |
| :--- | :---: | :---: | ---: | ---: | :---: |
| FDC bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| CMFB bias current | µA | 40±10 | 40.092 | 49.581 | `FFVHTH` |
| Total current | mA | ≤2.5 | 1.604 | 2.195 | `FFVHTH` |
| Total power | mW | ≤9 | 5.293 | 7.901 | `FFVHTH` |
| Output CM error | mV | ±20 | 0.395 | 12.654 | `SSVHTH` |
| G2 input offset | mV | ±5 | $2.329\times10^{-8}$ | $-7.953\times10^{-7}$ | `NOMVLTH` |
| G2 gain @ 10 Hz | V/V | Report | 2.015 | 2.050 | `SSVLTH` |
| G2 gain @ 150 Hz | V/V | Report | 2.015 | 2.050 | `SSVLTH` |
| G2 gain error | % | ±5 | 0.751 | 2.502 | `SSVLTH` |
| G2 −3 dB bandwidth | MHz | ≥0.15 | 5.053 | 3.307 | `SSVLTH` |
| G2 CMRR @ 60 Hz | dB | ≥80 | 256.698 | 222.787 | `NOMVLTH` |
| G2 CMRR @ 150 Hz | dB | ≥80 | 256.479 | 222.782 | `NOMVLTH` |
| G2 PSRR+ @ 60 Hz | dB | ≥80 | 246.395 | 215.788 | `FSVLNOM` |
| G2 PSRR+ @ 150 Hz | dB | ≥80 | 246.262 | 215.788 | `FSVLNOM` |
| G2 PSRR− @ 60 Hz | dB | ≥80 | 234.094 | 214.207 | `FSVLNOM` |
| G2 PSRR− @ 150 Hz | dB | ≥80 | 232.714 | 214.031 | `FSVLNOM` |
| G2 input-referred noise, 0.05–150 Hz | µVrms | ≤10 | 4.617 | 5.250 | `SSVHTH` |
| G4 input offset | mV | ±5 | $-6.921\times10^{-8}$ | $-5.292\times10^{-7}$ | `SFNOMTL` |
| G4 gain @ 10 Hz | V/V | Report | 3.991 | 3.983 | `FFVHTL` |
| G4 gain @ 150 Hz | V/V | Report | 3.991 | 3.983 | `FFVHTL` |
| G4 gain error | % | ±5 | −0.236 | −0.419 | `FFVHTL` |
| G4 −3 dB bandwidth | MHz | ≥0.15 | 3.025 | 1.995 | `SSVLTH` |
| G4 CMRR @ 60 Hz | dB | ≥80 | 226.805 | 215.757 | `SSNOMTH` |
| G4 CMRR @ 150 Hz | dB | ≥80 | 220.287 | 218.204 | `SFNOMTL` |
| G4 PSRR+ @ 60 Hz | dB | ≥80 | 236.682 | 228.453 | `FSVLNOM` |
| G4 PSRR+ @ 150 Hz | dB | ≥80 | 236.710 | 228.462 | `FSVLNOM` |
| G4 PSRR− @ 60 Hz | dB | ≥80 | 217.577 | 207.743 | `SSVHTH` |
| G4 PSRR− @ 150 Hz | dB | ≥80 | 211.726 | 210.543 | `FSVLNOM` |
| G4 input-referred noise, 0.05–150 Hz | µVrms | ≤10 | 3.859 | 4.394 | `SSVHTH` |
| G8 input offset | mV | ±5 | $9.462\times10^{-7}$ | $9.462\times10^{-7}$ | `NOMNOMNOM` |
| G8 gain @ 10 Hz | V/V | Report | 7.958 | 7.942 | `FFVHTL` |
| G8 gain @ 150 Hz | V/V | Report | 7.958 | 7.942 | `FFVHTL` |
| G8 gain error | % | ±5 | −0.522 | −0.721 | `FFVHTL` |
| G8 −3 dB bandwidth | MHz | ≥0.15 | 2.070 | 1.281 | `SSVLTH` |
| G8 CMRR @ 60 Hz | dB | ≥80 | 211.955 | 184.741 | `NOMVHNOM` |
| G8 CMRR @ 150 Hz | dB | ≥80 | 218.025 | 184.550 | `NOMVHNOM` |
| G8 PSRR+ @ 60 Hz | dB | ≥80 | 231.664 | 223.246 | `SSVLTH` |
| G8 PSRR+ @ 150 Hz | dB | ≥80 | 231.658 | 223.229 | `SSVLTH` |
| G8 PSRR− @ 60 Hz | dB | ≥80 | 207.945 | 181.216 | `NOMVHNOM` |
| G8 PSRR− @ 150 Hz | dB | ≥80 | 213.545 | 181.026 | `NOMVHNOM` |
| G8 input-referred noise, 0.05–150 Hz | µVrms | ≤10 | 3.473 | 3.955 | `SSVHTH` |
| G16 input offset | mV | ±5 | $3.383\times10^{-7}$ | $-6.475\times10^{-7}$ | `NOMVHTH` |
| G16 gain @ 10 Hz | V/V | Report | 15.860 | 15.851 | `FFVLTL` |
| G16 gain @ 150 Hz | V/V | Report | 15.860 | 15.851 | `FFVLTL` |
| G16 gain error | % | ±5 | −0.878 | −0.932 | `FFVLTL` |
| G16 −3 dB bandwidth | MHz | ≥0.15 | 0.907 | 0.595 | `SSVLTH` |
| G16 CMRR @ 60 Hz | dB | ≥80 | 188.992 | 188.991 | `NOMVHNOM` |
| G16 CMRR @ 150 Hz | dB | ≥80 | 188.555 | 188.546 | `FSVHNOM` |
| G16 PSRR+ @ 60 Hz | dB | ≥80 | 269.035 | 248.314 | `FFVLTH` |
| G16 PSRR+ @ 150 Hz | dB | ≥80 | 267.726 | 248.353 | `FFVLTH` |
| G16 PSRR− @ 60 Hz | dB | ≥80 | 186.022 | 186.020 | `FSVHNOM` |
| G16 PSRR− @ 150 Hz | dB | ≥80 | 185.643 | 185.634 | `FSVHNOM` |
| G16 input-referred noise, 0.05–150 Hz | µVrms | ≤10 | 3.280 | 3.736 | `SSVHTH` |

</details>

<details>
<summary>All generated PGA plots</summary>

![PGA differential frequency response](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_differential_ac.png)

![PGA input-referred noise](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_noise.png)

![PGA CMRR and PSRR](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_rejection.png)

![PGA selector functional check](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_SEL_functional_check.png)

![PGA gain-code switching](Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_gain_switching.png)

![PGA MC input offset](Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_01_Input_Offset_Histogram.png)

![PGA MC gain error](Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_02_Gain_Error_Histogram.png)

![PGA MC bandwidth](Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_03_Bandwidth_Histogram.png)

![PGA MC CMRR at 60 Hz](Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_04_CMRR_60Hz_Histogram.png)

</details>

### 5.7 Output buffer

The BUFFER directory contains nominal PVT raw exports for operating point, offset, differential response, CMRR, PSRR, noise, and selector transient, together with an MM summary export. A block-level MATLAB analyzer, formal worst-case table, and MM/GL/FULL signoff reports have not yet been completed. Buffer performance is therefore intentionally excluded from the verified-result and yield tables rather than inferred from unprocessed raw files.

### 5.8 Integrated AFE

The complete AFE schematic and an `AFE_Analyze.m` scaffold are present. Formal full-chain results are not yet reported. The remaining integration campaign must verify cascaded gain, passband response, integrated input-referred noise, output swing, selector behavior, and ADC-load settling across PVT before the AFE can be marked complete.

## 6. Monte Carlo summary

| Block | MM | GL | FULL | Runs per mode | Failed runs |
| :--- | ---: | ---: | ---: | ---: | ---: |
| SE OTA | 100% | 100% | 100% | 200 | 0 |
| FD OTA | 100% | 100% | 100% | 200 | 0 |
| INA + RLD | 100% | 100% | 100% | 200 | 0 |
| LPF | 100% | 100% | 100% | 200 | 0 |
| PGA | 100% | 100% | 100% | 200 | 0 |

Every generated Monte Carlo figure is included in its corresponding block section above.

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
