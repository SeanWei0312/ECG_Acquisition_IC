# INA + RLD Detailed Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Value |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45 PVT corners |
| Statistical coverage | 200-run MM, GL, and FULL |
| Status | Pass |

## Detailed results

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
<summary>INA+RLD comparison: NOM, FF, SS, FS, SF, VL, VH, TL, TH</summary>

| Parameter | Unit | Spec | NOM | FF | SS | FS | SF | VL | VH | TL | TH |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| **SET CONDITIONS** | — | — | — | — | — | — | — | — | — | — | — |
| AVDD | V | — | 3.300 | 3.300 | 3.300 | 3.300 | 3.300 | 3.000 | 3.600 | 3.300 | 3.300 |
| Temperature | C | — | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | -40.000 | 125.000 |
| S1 target gain | V/V | — | 60.000 | 60.000 | 60.000 | 60.000 | 60.000 | 60.000 | 60.000 | 60.000 | 60.000 |
| S2 target gain | V/V | — | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 |
| INA target gain | V/V | — | 240.000 | 240.000 | 240.000 | 240.000 | 240.000 | 240.000 | 240.000 | 240.000 | 240.000 |
| **OPERATING POINT** | — | — | — | — | — | — | — | — | — | — | — |
| Total current | mA | ≤6.2 | 3.860 | 4.474 | 3.366 | 3.977 | 3.742 | 3.771 | 3.930 | 3.123 | 4.491 |
| Total power | mW | ≤22 | 12.738 | 14.765 | 11.108 | 13.124 | 12.348 | 11.314 | 14.149 | 10.307 | 14.819 |
| Output CM error | mV | ±40 | 0.395 | -1.839 | 2.750 | 1.748 | -1.018 | 0.365 | 0.415 | -6.736 | 10.542 |
| Input-referred offset | uV | ±2000 | 0.000 | -0.000 | -0.000 | 0.001 | -0.001 | 0.001 | -0.001 | 0.001 | 0.001 |
| **INA** | — | — | — | — | — | — | — | — | — | — | — |
| S1 gain | V/V | — | 60.006 | 59.940 | 60.047 | 60.005 | 60.005 | 59.997 | 60.012 | 59.982 | 60.017 |
| S1 gain dB | dB | — | 35.564 | 35.554 | 35.570 | 35.564 | 35.564 | 35.563 | 35.565 | 35.560 | 35.566 |
| S1 gain error | % | ±0.5 | 0.009 | -0.100 | 0.079 | 0.008 | 0.009 | -0.004 | 0.020 | -0.030 | 0.029 |
| S1 -3 dB bandwidth | kHz | ≥150 | 261.757 | 330.834 | 211.064 | 268.045 | 255.398 | 257.167 | 265.190 | 273.784 | 227.570 |
| S2 gain | V/V | — | 4.000 | 3.999 | 4.001 | 4.000 | 4.000 | 4.000 | 4.000 | 3.999 | 4.001 |
| S2 gain dB | dB | — | 12.041 | 12.039 | 12.043 | 12.041 | 12.041 | 12.041 | 12.041 | 12.040 | 12.043 |
| S2 gain error | % | ±0.25 | 0.002 | -0.030 | 0.023 | 0.001 | 0.002 | 1.915e-04 | 0.003 | -0.015 | 0.019 |
| S2 -3 dB bandwidth | MHz | ≥1.5 | 2.647 | 3.409 | 2.100 | 2.717 | 2.578 | 2.597 | 2.683 | 2.752 | 2.321 |
| INA gain | V/V | — | 240.027 | 239.689 | 240.243 | 240.021 | 240.026 | 239.990 | 240.055 | 239.892 | 240.113 |
| INA gain dB | dB | — | 47.605 | 47.593 | 47.613 | 47.605 | 47.605 | 47.604 | 47.606 | 47.600 | 47.608 |
| INA gain error | % | ±0.5 | 0.011 | -0.130 | 0.101 | 0.009 | 0.011 | -0.004 | 0.023 | -0.045 | 0.047 |
| Gain flatness 0.05-150 Hz | dB | ≤0.1 | 1.432e-06 | 8.999e-07 | 2.208e-06 | 1.368e-06 | 1.505e-06 | 1.483e-06 | 1.395e-06 | 1.312e-06 | 1.894e-06 |
| INA -3 dB bandwidth | kHz | ≥150 | 259.286 | 327.841 | 209.004 | 265.524 | 252.978 | 254.746 | 262.678 | 271.141 | 225.472 |
| INA CMRR @ 60 Hz | dB | ≥80 | 225.384 | 218.695 | 239.259 | 210.445 | 234.189 | 219.116 | 216.820 | 220.541 | 224.778 |
| INA CMRR @ 150 Hz | dB | ≥80 | 225.265 | 218.650 | 238.714 | 210.430 | 233.703 | 219.124 | 216.476 | 220.533 | 224.856 |
| INA PSRR+ @ 60 Hz | dB | ≥80 | 200.677 | 196.205 | 194.996 | 190.667 | 195.734 | 194.571 | 198.889 | 198.572 | 197.597 |
| INA PSRR+ @ 150 Hz | dB | ≥80 | 200.748 | 196.207 | 182.098 | 210.536 | 198.848 | 194.607 | 198.945 | 198.522 | 197.661 |
| INA PSRR- @ 60 Hz | dB | ≥80 | 216.490 | 219.881 | 220.373 | 244.774 | 228.583 | 221.746 | 239.552 | 212.358 | 210.978 |
| INA PSRR- @ 150 Hz | dB | ≥80 | 216.000 | 219.821 | 221.122 | 255.255 | 228.819 | 221.743 | 243.891 | 212.540 | 210.978 |
| Input-referred noise 0.05-150 Hz | uVrms | ≤4 | 2.667 | 2.536 | 2.803 | 2.633 | 2.703 | 2.668 | 2.668 | 2.524 | 2.954 |
| **RLD** | — | — | — | — | — | — | — | — | — | — | — |
| RLD loop UGF | kHz | 1.05±0.55 | 0.946 | 1.313 | 0.717 | 0.946 | 0.946 | 0.946 | 0.946 | 0.839 | 1.082 |
| RLD phase margin | deg | ≥60 | 100.672 | 100.310 | 100.899 | 100.689 | 100.655 | 100.644 | 100.697 | 100.779 | 100.540 |
| Input CM suppression @ 60 Hz | dB | ≥50 | 55.072 | 55.254 | 54.807 | 55.074 | 55.070 | 55.068 | 55.075 | 54.973 | 55.160 |
| Input CM suppression @ 150 Hz | dB | ≥45 | 53.257 | 54.098 | 52.233 | 53.269 | 53.245 | 53.237 | 53.275 | 52.853 | 53.651 |
| RLD output rail headroom | V | ≥0.1 | 1.647 | 1.647 | 1.647 | 1.647 | 1.647 | 1.497 | 1.797 | 1.647 | 1.647 |
| CM Interference Gain Change | % | ±0.1 | -3.724e-05 | -5.156e-04 | -3.258e-04 | -2.836e-04 | -2.270e-04 | -5.445e-04 | -3.291e-04 | -1.896e-04 | -4.596e-04 |

</details>


## Plots

<details>
<summary>All generated INA+RLD plots</summary>

![INA differential frequency response](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_differential_ac.png)

![RLD loop gain and phase](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_loop_gain.png)

![INA CMRR and PSRR](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_rejection_response.png)

![INA and RLD common-mode rejection](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_cm_rejection.png)

![INA common-mode interference transient](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_transient.png)

![INA input-referred noise](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_noise.png)

![INA selector functional check](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/NOM.INA_RLD_sel_functional_check.png)

![INA MC input-referred offset](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_01_Vos_Histogram.png)

![INA MC gain error](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_02_INA_Gain_Error_Histogram.png)

![INA MC RLD UGF](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_03_RLD_UGF_Histogram.png)

![INA MC RLD phase margin](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_04_RLD_PM_Histogram.png)

![INA MC CMRR](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_05_INA_CMRR_Histogram.png)

![INA MC input common-mode suppression](../../Measurement_Results/IC_Simulation/INA_RLD/Plots/Fig_MC_06_Input_CM_Suppression_Histogram.png)

</details>

## All 45 PVT corners

<details>
<summary>INA+RLD: all 45 PVT corners</summary>

| Corner | Current (mA) | Gain error (%) | BW (kHz) | Noise (µVrms) | RLD UGF (kHz) | PM (°) | Supp. 60 (dB) | Supp. 150 (dB) | Status |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | :---: |
| `NOMNOMNOM` | 3.860 | 0.011 | 259.286 | 2.667 | 0.946 | 100.672 | 55.072 | 53.257 | Pass |
| `NOMVLNOM` | 3.771 | -0.004 | 254.746 | 2.668 | 0.946 | 100.644 | 55.068 | 53.237 | Pass |
| `NOMVHNOM` | 3.930 | 0.023 | 262.678 | 2.668 | 0.946 | 100.697 | 55.075 | 53.275 | Pass |
| `NOMNOMTL` | 3.123 | -0.045 | 271.141 | 2.524 | 0.839 | 100.779 | 54.973 | 52.853 | Pass |
| `NOMNOMTH` | 4.491 | 0.047 | 225.472 | 2.954 | 1.082 | 100.540 | 55.160 | 53.651 | Pass |
| `NOMVLTL` | 3.044 | -0.058 | 266.533 | 2.521 | 0.839 | 100.753 | 54.970 | 52.832 | Pass |
| `NOMVLTH` | 4.402 | 0.029 | 221.640 | 2.958 | 1.082 | 100.509 | 55.157 | 53.633 | Pass |
| `NOMVHTL` | 3.189 | -0.035 | 274.684 | 2.527 | 0.839 | 100.803 | 54.976 | 52.872 | Pass |
| `NOMVHTH` | 4.559 | 0.062 | 228.340 | 2.952 | 1.082 | 100.568 | 55.163 | 53.668 | Pass |
| `FFNOMNOM` | 4.474 | -0.130 | 327.841 | 2.536 | 1.313 | 100.310 | 55.254 | 54.098 | Pass |
| `FFVLNOM` | 4.381 | -0.145 | 322.783 | 2.536 | 1.313 | 100.273 | 55.251 | 54.079 | Pass |
| `FFVHNOM` | 4.553 | -0.118 | 331.864 | 2.537 | 1.313 | 100.345 | 55.257 | 54.114 | Pass |
| `FFNOMTL` | 3.624 | -0.202 | 342.319 | 2.405 | 1.166 | 100.455 | 55.200 | 53.833 | Pass |
| `FFNOMTH` | 5.222 | -0.080 | 286.575 | 2.804 | 1.502 | 100.133 | 55.302 | 54.348 | Pass |
| `FFVLTL` | 3.540 | -0.215 | 337.116 | 2.402 | 1.166 | 100.420 | 55.196 | 53.813 | Pass |
| `FFVLTH` | 5.128 | -0.099 | 282.254 | 2.807 | 1.502 | 100.092 | 55.299 | 54.330 | Pass |
| `FFVHTL` | 3.698 | -0.191 | 346.567 | 2.408 | 1.166 | 100.486 | 55.203 | 53.850 | Pass |
| `FFVHTH` | 5.300 | -0.065 | 289.995 | 2.802 | 1.502 | 100.170 | 55.305 | 54.363 | Pass |
| `SSNOMNOM` | 3.366 | 0.101 | 209.004 | 2.803 | 0.717 | 100.899 | 54.807 | 52.233 | Pass |
| `SSVLNOM` | 3.273 | 0.086 | 204.410 | 2.804 | 0.717 | 100.877 | 54.803 | 52.211 | Pass |
| `SSVHNOM` | 3.431 | 0.113 | 212.017 | 2.803 | 0.717 | 100.919 | 54.810 | 52.252 | Pass |
| `SSNOMTL` | 2.722 | 0.056 | 218.975 | 2.646 | 0.636 | 100.983 | 54.648 | 51.699 | Pass |
| `SSNOMTH` | 3.903 | 0.125 | 180.833 | 3.110 | 0.820 | 100.796 | 54.952 | 52.770 | Pass |
| `SSVLTL` | 2.642 | 0.043 | 214.418 | 2.644 | 0.636 | 100.963 | 54.644 | 51.676 | Pass |
| `SSVLTH` | 3.810 | 0.106 | 176.996 | 3.117 | 0.820 | 100.772 | 54.948 | 52.750 | Pass |
| `SSVHTL` | 2.783 | 0.067 | 222.089 | 2.650 | 0.636 | 101.002 | 54.652 | 51.719 | Pass |
| `SSVHTH` | 3.966 | 0.140 | 183.369 | 3.107 | 0.820 | 100.818 | 54.955 | 52.788 | Pass |
| `FSNOMNOM` | 3.977 | 0.009 | 265.524 | 2.633 | 0.946 | 100.689 | 55.074 | 53.269 | Pass |
| `FSVLNOM` | 3.878 | -0.008 | 260.510 | 2.634 | 0.946 | 100.661 | 55.070 | 53.250 | Pass |
| `FSVHNOM` | 4.051 | 0.022 | 269.039 | 2.633 | 0.946 | 100.714 | 55.077 | 53.286 | Pass |
| `FSNOMTL` | 3.218 | -0.049 | 277.561 | 2.494 | 0.839 | 100.794 | 54.975 | 52.865 | Pass |
| `FSNOMTH` | 4.620 | 0.046 | 230.758 | 2.916 | 1.082 | 100.558 | 55.162 | 53.662 | Pass |
| `FSVLTL` | 3.134 | -0.063 | 272.717 | 2.492 | 0.839 | 100.769 | 54.972 | 52.845 | Pass |
| `FSVLTH` | 4.513 | 0.026 | 226.239 | 2.921 | 1.082 | 100.529 | 55.159 | 53.644 | Pass |
| `FSVHTL` | 3.287 | -0.036 | 281.210 | 2.497 | 0.839 | 100.817 | 54.978 | 52.883 | Pass |
| `FSVHTH` | 4.693 | 0.063 | 233.744 | 2.913 | 1.082 | 100.586 | 55.165 | 53.678 | Pass |
| `SFNOMNOM` | 3.742 | 0.011 | 252.978 | 2.703 | 0.946 | 100.655 | 55.070 | 53.245 | Pass |
| `SFVLNOM` | 3.655 | -0.003 | 248.429 | 2.703 | 0.946 | 100.626 | 55.066 | 53.225 | Pass |
| `SFVHNOM` | 3.809 | 0.020 | 256.334 | 2.703 | 0.946 | 100.681 | 55.073 | 53.264 | Pass |
| `SFNOMTL` | 3.028 | -0.044 | 264.634 | 2.555 | 0.839 | 100.764 | 54.971 | 52.841 | Pass |
| `SFNOMTH` | 4.359 | 0.044 | 220.153 | 2.995 | 1.082 | 100.520 | 55.158 | 53.640 | Pass |
| `SFVLTL` | 2.949 | -0.056 | 259.932 | 2.552 | 0.839 | 100.737 | 54.967 | 52.819 | Pass |
| `SFVLTH` | 4.275 | 0.027 | 216.428 | 2.999 | 1.082 | 100.489 | 55.155 | 53.620 | Pass |
| `SFVHTL` | 3.091 | -0.036 | 268.148 | 2.559 | 0.839 | 100.788 | 54.974 | 52.860 | Pass |
| `SFVHTH` | 4.425 | 0.055 | 222.982 | 2.992 | 1.082 | 100.549 | 55.161 | 53.657 | Pass |

</details>

## Generated artifacts

- [Analyzer](../../Measurement_Results/IC_Simulation/INA_RLD/INA_RLD_Analyze.m)
- [Comparison table](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/INA_RLD_table_report.csv)
- [Nominal summary](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/NOM.INA_RLD_summary.csv)
- [Full PVT data](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/INA_RLD_full_pvt_report.csv)
- [Worst-case table](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/INA_RLD_worst_case_report.csv)
- [MC run summary](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/MC_Run_Summary.csv)
- [MM summary](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/MM_MC_Summary.csv)
- [GL summary](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/GL_MC_Summary.csv)
- [FULL summary](../../Measurement_Results/IC_Simulation/INA_RLD/Reports/FULL_MC_Summary.csv)

## Scope limitation

These results are schematic-level simulations. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
