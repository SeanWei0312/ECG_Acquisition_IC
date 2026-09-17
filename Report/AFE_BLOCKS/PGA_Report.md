# PGA Detailed Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Value |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45 PVT corners |
| Statistical coverage | 200-run MM, GL, and FULL |
| Status | Pass |

## Detailed results

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
<summary>PGA comparison: NOM, FF, SS, FS, SF, VL, VH, TL, TH</summary>

| Parameter | Unit | Spec | NOM | FF | SS | FS | SF | VL | VH | TL | TH |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| **SET CONDITIONS** | — | — | — | — | — | — | — | — | — | — | — |
| AVDD | V | — | 3.300 | 3.300 | 3.300 | 3.300 | 3.300 | 3.000 | 3.600 | 3.300 | 3.300 |
| Temperature | C | — | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | -40.000 | 125.000 |
| Shared OP gain code | code | — | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 |
| **OPERATING POINT** | — | — | — | — | — | — | — | — | — | — | — |
| FDC bias current | uA | 40±10 | 40.092 | 45.286 | 35.875 | 40.727 | 39.434 | 39.479 | 40.525 | 35.435 | 43.278 |
| CMFB bias current | uA | 40±10 | 40.092 | 45.286 | 35.875 | 40.727 | 39.434 | 39.479 | 40.525 | 35.435 | 43.278 |
| Total current | mA | ≤2.5 | 1.604 | 1.857 | 1.400 | 1.652 | 1.556 | 1.568 | 1.633 | 1.302 | 1.862 |
| Total power | mW | ≤9 | 5.293 | 6.129 | 4.621 | 5.451 | 5.133 | 4.703 | 5.878 | 4.296 | 6.144 |
| Output CM error | mV | ±20 | 0.395 | -1.840 | 2.750 | 1.748 | -1.018 | 0.365 | 0.415 | -6.738 | 10.545 |
| **G2** | — | — | — | — | — | — | — | — | — | — | — |
| G2 target gain | V/V | — | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 | 2.000 |
| G2 input offset | mV | ±5 | 2.329e-08 | 8.015e-08 | 4.844e-08 | -6.433e-08 | 2.144e-08 | 2.133e-08 | -3.856e-08 | -1.035e-07 | -5.205e-07 |
| G2 gain @ 10 Hz | V/V | — | 2.015 | 2.012 | 2.022 | 2.013 | 2.017 | 2.023 | 2.010 | 2.008 | 2.026 |
| G2 gain @ 150 Hz | V/V | — | 2.015 | 2.012 | 2.022 | 2.013 | 2.017 | 2.023 | 2.010 | 2.008 | 2.026 |
| G2 gain error | % | ±5 | 0.751 | 0.604 | 1.115 | 0.660 | 0.832 | 1.152 | 0.515 | 0.375 | 1.317 |
| G2 -3 dB bandwidth | MHz | ≥0.15 | 5.053 | 6.637 | 3.941 | 5.203 | 4.904 | 4.958 | 5.116 | 5.276 | 4.367 |
| G2 CMRR @ 60 Hz | dB | ≥80 | 256.698 | 250.023 | 245.010 | 250.810 | 259.482 | 253.215 | 259.071 | 245.176 | 231.207 |
| G2 CMRR @ 150 Hz | dB | ≥80 | 256.479 | 250.049 | 245.074 | 250.896 | 259.210 | 252.989 | 259.288 | 245.160 | 231.199 |
| G2 PSRR+ @ 60 Hz | dB | ≥80 | 246.395 | 233.145 | 230.213 | 226.573 | 232.478 | 216.133 | 230.555 | 228.383 | 235.708 |
| G2 PSRR+ @ 150 Hz | dB | ≥80 | 246.262 | 233.122 | 230.226 | 226.569 | 232.525 | 216.137 | 230.546 | 228.413 | 235.697 |
| G2 PSRR- @ 60 Hz | dB | ≥80 | 234.094 | 240.760 | 227.492 | 223.465 | 228.057 | 219.275 | 230.377 | 234.734 | 234.005 |
| G2 PSRR- @ 150 Hz | dB | ≥80 | 232.714 | 241.502 | 226.906 | 223.061 | 228.875 | 218.935 | 229.597 | 235.232 | 234.710 |
| G2 input-referred noise 0.05-150 Hz | uVrms | ≤10 | 4.617 | 4.417 | 4.815 | 4.545 | 4.689 | 4.602 | 4.629 | 4.412 | 5.012 |
| **G4** | — | — | — | — | — | — | — | — | — | — | — |
| G4 target gain | V/V | — | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 | 4.000 |
| G4 input offset | mV | ±5 | -6.921e-08 | -1.865e-07 | -4.575e-07 | -3.246e-08 | 1.916e-09 | 9.768e-09 | -6.398e-08 | 4.504e-08 | -6.418e-08 |
| G4 gain @ 10 Hz | V/V | — | 3.991 | 3.988 | 3.995 | 3.990 | 3.991 | 3.995 | 3.988 | 3.986 | 3.997 |
| G4 gain @ 150 Hz | V/V | — | 3.991 | 3.988 | 3.995 | 3.990 | 3.991 | 3.995 | 3.988 | 3.986 | 3.997 |
| G4 gain error | % | ±5 | -0.236 | -0.288 | -0.134 | -0.259 | -0.215 | -0.136 | -0.294 | -0.339 | -0.085 |
| G4 -3 dB bandwidth | MHz | ≥0.15 | 3.025 | 3.920 | 2.385 | 3.112 | 2.938 | 2.973 | 3.061 | 3.178 | 2.596 |
| G4 CMRR @ 60 Hz | dB | ≥80 | 226.805 | 221.833 | 225.787 | 226.660 | 226.573 | 226.484 | 226.693 | 221.370 | 222.254 |
| G4 CMRR @ 150 Hz | dB | ≥80 | 220.287 | 220.389 | 234.813 | 220.186 | 220.212 | 220.182 | 220.186 | 218.996 | 220.377 |
| G4 PSRR+ @ 60 Hz | dB | ≥80 | 236.682 | 248.435 | 234.280 | 235.694 | 234.083 | 232.469 | 246.321 | 241.288 | 242.240 |
| G4 PSRR+ @ 150 Hz | dB | ≥80 | 236.710 | 248.511 | 234.296 | 235.717 | 234.059 | 232.462 | 246.444 | 241.173 | 242.205 |
| G4 PSRR- @ 60 Hz | dB | ≥80 | 217.577 | 213.931 | 214.805 | 217.371 | 216.518 | 216.107 | 217.568 | 213.703 | 213.188 |
| G4 PSRR- @ 150 Hz | dB | ≥80 | 211.726 | 212.488 | 220.065 | 211.590 | 211.203 | 210.994 | 211.674 | 211.274 | 211.531 |
| G4 input-referred noise 0.05-150 Hz | uVrms | ≤10 | 3.859 | 3.690 | 4.028 | 3.797 | 3.920 | 3.851 | 3.866 | 3.684 | 4.195 |
| **G8** | — | — | — | — | — | — | — | — | — | — | — |
| G8 target gain | V/V | — | 8.000 | 8.000 | 8.000 | 8.000 | 8.000 | 8.000 | 8.000 | 8.000 | 8.000 |
| G8 input offset | mV | ±5 | 9.462e-07 | 2.456e-07 | 1.373e-07 | -1.905e-07 | 4.265e-07 | 8.312e-07 | 7.111e-07 | 2.143e-07 | 2.164e-07 |
| G8 gain @ 10 Hz | V/V | — | 7.958 | 7.953 | 7.967 | 7.956 | 7.960 | 7.966 | 7.954 | 7.950 | 7.970 |
| G8 gain @ 150 Hz | V/V | — | 7.958 | 7.953 | 7.967 | 7.956 | 7.960 | 7.966 | 7.954 | 7.950 | 7.970 |
| G8 gain error | % | ±5 | -0.522 | -0.585 | -0.416 | -0.547 | -0.501 | -0.425 | -0.580 | -0.628 | -0.370 |
| G8 -3 dB bandwidth | MHz | ≥0.15 | 2.070 | 2.668 | 1.629 | 2.137 | 2.003 | 2.026 | 2.101 | 2.253 | 1.682 |
| G8 CMRR @ 60 Hz | dB | ≥80 | 211.955 | 207.973 | 193.428 | 202.563 | 191.621 | 207.828 | 184.741 | 197.365 | 199.520 |
| G8 CMRR @ 150 Hz | dB | ≥80 | 218.025 | 207.221 | 193.767 | 201.187 | 191.213 | 205.489 | 184.550 | 197.801 | 199.904 |
| G8 PSRR+ @ 60 Hz | dB | ≥80 | 231.664 | 241.701 | 238.711 | 237.793 | 243.735 | 232.343 | 239.790 | 241.993 | 234.689 |
| G8 PSRR+ @ 150 Hz | dB | ≥80 | 231.658 | 241.733 | 238.691 | 237.815 | 243.716 | 232.326 | 239.764 | 241.958 | 234.681 |
| G8 PSRR- @ 60 Hz | dB | ≥80 | 207.945 | 204.315 | 189.887 | 199.006 | 188.105 | 204.547 | 181.216 | 193.844 | 196.077 |
| G8 PSRR- @ 150 Hz | dB | ≥80 | 213.545 | 203.576 | 190.226 | 197.634 | 187.698 | 202.152 | 181.026 | 194.280 | 196.463 |
| G8 input-referred noise 0.05-150 Hz | uVrms | ≤10 | 3.473 | 3.321 | 3.626 | 3.418 | 3.529 | 3.466 | 3.480 | 3.315 | 3.777 |
| **G16** | — | — | — | — | — | — | — | — | — | — | — |
| G16 target gain | V/V | — | 16.000 | 16.000 | 16.000 | 16.000 | 16.000 | 16.000 | 16.000 | 16.000 | 16.000 |
| G16 input offset | mV | ±5 | 3.383e-07 | -3.840e-08 | -6.553e-08 | 3.272e-07 | 3.459e-07 | 3.446e-07 | -1.212e-07 | -5.861e-09 | -6.413e-08 |
| G16 gain @ 10 Hz | V/V | — | 15.860 | 15.854 | 15.863 | 15.859 | 15.860 | 15.859 | 15.860 | 15.857 | 15.862 |
| G16 gain @ 150 Hz | V/V | — | 15.860 | 15.854 | 15.863 | 15.859 | 15.860 | 15.859 | 15.860 | 15.857 | 15.862 |
| G16 gain error | % | ±5 | -0.878 | -0.910 | -0.857 | -0.880 | -0.876 | -0.882 | -0.874 | -0.892 | -0.866 |
| G16 -3 dB bandwidth | MHz | ≥0.15 | 0.907 | 1.153 | 0.725 | 0.933 | 0.880 | 0.891 | 0.918 | 0.969 | 0.765 |
| G16 CMRR @ 60 Hz | dB | ≥80 | 188.992 | 215.201 | 215.186 | 188.992 | 188.993 | 194.854 | 188.991 | 207.016 | 206.727 |
| G16 CMRR @ 150 Hz | dB | ≥80 | 188.555 | 212.944 | 224.785 | 188.551 | 188.559 | 194.026 | 188.549 | 205.345 | 205.577 |
| G16 PSRR+ @ 60 Hz | dB | ≥80 | 269.035 | 282.154 | 278.364 | 269.534 | 272.115 | 275.565 | 261.675 | 280.825 | 283.703 |
| G16 PSRR+ @ 150 Hz | dB | ≥80 | 267.726 | 284.635 | 278.579 | 268.605 | 271.356 | 273.408 | 261.655 | 284.969 | 283.341 |
| G16 PSRR- @ 60 Hz | dB | ≥80 | 186.022 | 210.506 | 229.112 | 186.021 | 186.022 | 191.939 | 186.021 | 204.883 | 202.889 |
| G16 PSRR- @ 150 Hz | dB | ≥80 | 185.643 | 208.856 | 219.476 | 185.639 | 185.646 | 191.214 | 185.637 | 203.294 | 201.982 |
| G16 input-referred noise 0.05-150 Hz | uVrms | ≤10 | 3.280 | 3.136 | 3.425 | 3.228 | 3.332 | 3.274 | 3.286 | 3.131 | 3.567 |

</details>


## Plots

<details>
<summary>All generated PGA plots</summary>

![PGA differential frequency response](../../Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_differential_ac.png)

![PGA input-referred noise](../../Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_noise.png)

![PGA CMRR and PSRR](../../Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_rejection.png)

![PGA selector functional check](../../Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_SEL_functional_check.png)

![PGA gain-code switching](../../Measurement_Results/IC_Simulation/PGA/Plots/NOM.PGA_gain_switching.png)

![PGA MC input offset](../../Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_01_Input_Offset_Histogram.png)

![PGA MC gain error](../../Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_02_Gain_Error_Histogram.png)

![PGA MC bandwidth](../../Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_03_Bandwidth_Histogram.png)

![PGA MC CMRR at 60 Hz](../../Measurement_Results/IC_Simulation/PGA/Plots/Fig_MC_04_CMRR_60Hz_Histogram.png)

</details>

## All 45 PVT corners

<details>
<summary>PGA: all 45 PVT corners</summary>

| Corner | Current (mA) | CM error (mV) | Max abs. gain error (%) | Min BW (MHz) | Min CMRR 60 (dB) | Max noise (µVrms) | Status |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :---: |
| `NOMNOMNOM` | 1.604 | 0.395 | 0.878 | 0.907 | 188.992 | 4.617 | Pass |
| `NOMVLNOM` | 1.568 | 0.365 | 1.152 | 0.891 | 194.854 | 4.602 | Pass |
| `NOMVHNOM` | 1.633 | 0.415 | 0.874 | 0.918 | 184.741 | 4.629 | Pass |
| `NOMNOMTL` | 1.302 | -6.738 | 0.892 | 0.969 | 197.365 | 4.412 | Pass |
| `NOMNOMTH` | 1.862 | 10.545 | 1.317 | 0.765 | 199.520 | 5.012 | Pass |
| `NOMVLTL` | 1.269 | -6.774 | 0.896 | 0.953 | 205.888 | 4.392 | Pass |
| `NOMVLTH` | 1.825 | 10.513 | 1.773 | 0.751 | 201.550 | 5.002 | Pass |
| `NOMVHTL` | 1.329 | -6.707 | 0.889 | 0.981 | 205.046 | 4.428 | Pass |
| `NOMVHTH` | 1.890 | 10.563 | 1.022 | 0.774 | 201.325 | 5.020 | Pass |
| `FFNOMNOM` | 1.857 | -1.840 | 0.910 | 1.153 | 207.973 | 4.417 | Pass |
| `FFVLNOM` | 1.819 | -1.877 | 0.914 | 1.136 | 209.892 | 4.405 | Pass |
| `FFVHNOM` | 1.889 | -1.814 | 0.906 | 1.167 | 216.064 | 4.427 | Pass |
| `FFNOMTL` | 1.509 | -9.074 | 0.928 | 1.230 | 196.994 | 4.232 | Pass |
| `FFNOMTH` | 2.163 | 8.583 | 1.169 | 0.978 | 196.898 | 4.782 | Pass |
| `FFVLTL` | 1.474 | -9.119 | 0.932 | 1.212 | 196.991 | 4.216 | Pass |
| `FFVLTH` | 2.125 | 8.543 | 1.479 | 0.964 | 205.398 | 4.774 | Pass |
| `FFVHTL` | 1.539 | -9.035 | 0.925 | 1.245 | 231.532 | 4.246 | Pass |
| `FFVHTH` | 2.195 | 8.607 | 0.951 | 0.990 | 202.390 | 4.789 | Pass |
| `SSNOMNOM` | 1.400 | 2.750 | 1.115 | 0.725 | 193.428 | 4.815 | Pass |
| `SSVLNOM` | 1.362 | 2.727 | 1.945 | 0.708 | 204.271 | 4.793 | Pass |
| `SSVHNOM` | 1.427 | 2.764 | 0.854 | 0.735 | 195.031 | 4.830 | Pass |
| `SSNOMTL` | 1.136 | -4.291 | 0.869 | 0.776 | 193.893 | 4.588 | Pass |
| `SSNOMTH` | 1.620 | 12.644 | 1.695 | 0.609 | 202.718 | 5.240 | Pass |
| `SSVLTL` | 1.103 | -4.317 | 1.494 | 0.760 | 201.516 | 4.560 | Pass |
| `SSVLTH` | 1.581 | 12.623 | 2.502 | 0.595 | 202.761 | 5.224 | Pass |
| `SSVHTL` | 1.161 | -4.268 | 0.866 | 0.787 | 198.684 | 4.609 | Pass |
| `SSVHTH` | 1.646 | 12.654 | 1.236 | 0.617 | 201.287 | 5.250 | Pass |
| `FSNOMNOM` | 1.652 | 1.748 | 0.880 | 0.933 | 188.992 | 4.545 | Pass |
| `FSVLNOM` | 1.611 | 1.694 | 0.989 | 0.915 | 194.853 | 4.532 | Pass |
| `FSVHNOM` | 1.682 | 1.782 | 0.876 | 0.945 | 188.991 | 4.555 | Pass |
| `FSNOMTL` | 1.341 | -5.143 | 0.895 | 0.998 | 193.103 | 4.347 | Pass |
| `FSNOMTH` | 1.915 | 11.514 | 1.220 | 0.786 | 206.731 | 4.931 | Pass |
| `FSVLTL` | 1.306 | -5.192 | 0.899 | 0.981 | 207.012 | 4.330 | Pass |
| `FSVLTH` | 1.871 | 11.436 | 1.621 | 0.770 | 200.998 | 4.922 | Pass |
| `FSVHTL` | 1.369 | -5.104 | 0.891 | 1.010 | 207.034 | 4.362 | Pass |
| `FSVHTH` | 1.944 | 11.553 | 0.954 | 0.796 | 202.490 | 4.938 | Pass |
| `SFNOMNOM` | 1.556 | -1.018 | 0.876 | 0.880 | 188.993 | 4.689 | Pass |
| `SFVLNOM` | 1.520 | -1.019 | 1.296 | 0.864 | 194.855 | 4.672 | Pass |
| `SFVHNOM` | 1.583 | -1.018 | 0.873 | 0.891 | 188.993 | 4.703 | Pass |
| `SFNOMTL` | 1.263 | -8.399 | 0.891 | 0.940 | 202.057 | 4.476 | Pass |
| `SFNOMTH` | 1.808 | 9.524 | 1.392 | 0.743 | 194.217 | 5.094 | Pass |
| `SFVLTL` | 1.230 | -8.417 | 0.894 | 0.923 | 204.391 | 4.453 | Pass |
| `SFVLTH` | 1.774 | 9.540 | 1.889 | 0.731 | 194.896 | 5.082 | Pass |
| `SFVHTL` | 1.289 | -8.379 | 0.888 | 0.952 | 195.119 | 4.494 | Pass |
| `SFVHTH` | 1.835 | 9.510 | 1.075 | 0.753 | 197.996 | 5.102 | Pass |

</details>

## Generated artifacts

- [Analyzer](../../Measurement_Results/IC_Simulation/PGA/PGA_Analyze.m)
- [Comparison table](../../Measurement_Results/IC_Simulation/PGA/Reports/PGA_table_report.csv)
- [Nominal summary](../../Measurement_Results/IC_Simulation/PGA/Reports/NOM.PGA_summary.csv)
- [Full PVT data](../../Measurement_Results/IC_Simulation/PGA/Reports/PGA_full_pvt_report.csv)
- [Worst-case table](../../Measurement_Results/IC_Simulation/PGA/Reports/PGA_worst_case_report.csv)
- [MC run summary](../../Measurement_Results/IC_Simulation/PGA/Reports/MC_Run_Summary.csv)
- [MM summary](../../Measurement_Results/IC_Simulation/PGA/Reports/MM_MC_Summary.csv)
- [GL summary](../../Measurement_Results/IC_Simulation/PGA/Reports/GL_MC_Summary.csv)
- [FULL summary](../../Measurement_Results/IC_Simulation/PGA/Reports/FULL_MC_Summary.csv)

## Scope limitation

These results are schematic-level simulations. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
