# LPF Detailed Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Value |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45 PVT corners |
| Statistical coverage | 200-run MM, GL, and FULL |
| Status | Pass |

## Detailed results

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
<summary>LPF comparison: NOM, FF, SS, FS, SF, VL, VH, TL, TH</summary>

| Parameter | Unit | Spec | NOM | FF | SS | FS | SF | VL | VH | TL | TH |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| **SET CONDITIONS** | — | — | — | — | — | — | — | — | — | — | — |
| AVDD | V | — | 3.300 | 3.300 | 3.300 | 3.300 | 3.300 | 3.000 | 3.600 | 3.300 | 3.300 |
| Temperature | C | — | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | 27.000 | -40.000 | 125.000 |
| LPF target gain | V/V | — | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |
| **OPERATING POINT** | — | — | — | — | — | — | — | — | — | — | — |
| FDC bias current | uA | 40±10 | 40.092 | 45.286 | 35.875 | 40.727 | 39.434 | 39.479 | 40.525 | 35.435 | 43.278 |
| CMFB bias current | uA | 40±10 | 40.092 | 45.286 | 35.875 | 40.727 | 39.434 | 39.479 | 40.525 | 35.435 | 43.278 |
| Total current | mA | ≤2.5 | 1.604 | 1.857 | 1.400 | 1.652 | 1.556 | 1.568 | 1.633 | 1.302 | 1.861 |
| Total power | mW | ≤9 | 5.293 | 6.129 | 4.620 | 5.451 | 5.133 | 4.703 | 5.878 | 4.296 | 6.143 |
| Output CM error | mV | ±25 | 0.395 | -1.841 | 2.752 | 1.749 | -1.019 | 0.365 | 0.415 | -6.740 | 10.550 |
| LPF input offset | mV | ±6 | 0.000 | 0.000 | 0.000 | -0.000 | -0.000 | 0.000 | -0.000 | 0.000 | 0.000 |
| **LPF** | — | — | — | — | — | — | — | — | — | — | — |
| Passband gain | V/V | — | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |
| Passband gain error | % | ±0.5 | -0.027 | -0.018 | -0.041 | -0.027 | -0.027 | -0.027 | -0.026 | -0.032 | -0.023 |
| Loss @ 150 Hz | dB | — | 0.361 | 0.191 | 0.611 | 0.361 | 0.361 | 0.361 | 0.361 | 0.454 | 0.279 |
| LPF -1 dB frequency | Hz | ≥150 | 258.691 | 359.135 | 196.115 | 258.691 | 258.690 | 258.691 | 258.690 | 229.654 | 295.879 |
| LPF -3 dB frequency | Hz | — | 506.912 | 703.898 | 384.135 | 506.914 | 506.911 | 506.913 | 506.912 | 449.936 | 579.847 |
| CMRR @ 60 Hz | dB | ≥80 | 245.253 | 224.162 | 220.057 | 247.019 | 243.716 | 246.290 | 244.236 | 222.335 | 245.124 |
| CMRR @ 150 Hz | dB | ≥80 | 245.225 | 224.157 | 220.675 | 246.979 | 243.685 | 246.266 | 244.200 | 224.269 | 245.163 |
| PSRR+ @ 60 Hz | dB | ≥80 | 191.538 | 192.668 | 190.631 | 191.774 | 191.298 | 191.457 | 191.625 | 233.076 | 252.607 |
| PSRR+ @ 150 Hz | dB | ≥80 | 257.637 | 192.627 | 190.492 | 257.089 | 254.286 | 240.823 | 254.961 | 191.733 | 190.298 |
| PSRR- @ 60 Hz | dB | ≥80 | 234.605 | 215.375 | 212.133 | 234.660 | 233.753 | 228.572 | 236.436 | 213.278 | 238.788 |
| PSRR- @ 150 Hz | dB | ≥80 | 236.558 | 215.346 | 210.355 | 237.874 | 236.146 | 233.752 | 237.079 | 214.256 | 236.197 |
| Input-referred noise 0.05-150 Hz | uVrms | ≤10 | 6.176 | 5.903 | 6.452 | 6.077 | 6.274 | 6.164 | 6.187 | 5.895 | 6.715 |

</details>


## Plots

<details>
<summary>All generated LPF plots</summary>

![LPF differential frequency response](../../Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_differential_ac.png)

![LPF input-referred noise](../../Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_noise.png)

![LPF PVT CMRR response](../../Measurement_Results/IC_Simulation/LPF/Plots/LPF_PVT_CMRR_AC.png)

![LPF selector functional check](../../Measurement_Results/IC_Simulation/LPF/Plots/NOM.LPF_SEL_functional_check.png)

![LPF MC −1 dB frequency](../../Measurement_Results/IC_Simulation/LPF/Plots/Fig_MC_01_LPF_1dB_Frequency_Histogram.png)

![LPF MC input offset](../../Measurement_Results/IC_Simulation/LPF/Plots/Fig_MC_02_Input_Offset_Histogram.png)

![LPF MC CMRR](../../Measurement_Results/IC_Simulation/LPF/Plots/Fig_MC_03_CMRR_Histogram.png)

</details>

## All 45 PVT corners

<details>
<summary>LPF: all 45 PVT corners</summary>

| Corner | Current (mA) | Offset (mV) | Gain error (%) | Loss 150 (dB) | −1 dB (Hz) | −3 dB (Hz) | Noise (µVrms) | Status |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | :---: |
| `NOMNOMNOM` | 1.604 | 0.000 | -0.027 | 0.361 | 258.691 | 506.912 | 6.176 | Pass |
| `NOMVLNOM` | 1.568 | 0.000 | -0.027 | 0.361 | 258.691 | 506.913 | 6.164 | Pass |
| `NOMVHNOM` | 1.633 | -0.000 | -0.026 | 0.361 | 258.690 | 506.912 | 6.187 | Pass |
| `NOMNOMTL` | 1.302 | 0.000 | -0.032 | 0.454 | 229.654 | 449.936 | 5.895 | Pass |
| `NOMNOMTH` | 1.861 | 0.000 | -0.023 | 0.279 | 295.879 | 579.847 | 6.715 | Pass |
| `NOMVLTL` | 1.269 | 0.000 | -0.032 | 0.454 | 229.654 | 449.937 | 5.875 | Pass |
| `NOMVLTH` | 1.825 | 0.000 | -0.024 | 0.279 | 295.880 | 579.848 | 6.711 | Pass |
| `NOMVHTL` | 1.329 | 0.000 | -0.031 | 0.454 | 229.653 | 449.936 | 5.913 | Pass |
| `NOMVHTH` | 1.890 | 0.000 | -0.023 | 0.279 | 295.879 | 579.847 | 6.719 | Pass |
| `FFNOMNOM` | 1.857 | 0.000 | -0.018 | 0.191 | 359.135 | 703.898 | 5.903 | Pass |
| `FFVLNOM` | 1.819 | 0.000 | -0.018 | 0.191 | 359.136 | 703.899 | 5.892 | Pass |
| `FFVHNOM` | 1.889 | 0.000 | -0.017 | 0.191 | 359.135 | 703.898 | 5.913 | Pass |
| `FFNOMTL` | 1.509 | -0.000 | -0.020 | 0.241 | 318.777 | 624.764 | 5.650 | Pass |
| `FFNOMTH` | 2.163 | 0.000 | -0.016 | 0.147 | 410.798 | 805.228 | 6.403 | Pass |
| `FFVLTL` | 1.474 | -0.000 | -0.020 | 0.241 | 318.777 | 624.764 | 5.632 | Pass |
| `FFVLTH` | 2.124 | -0.000 | -0.017 | 0.147 | 410.798 | 805.229 | 6.399 | Pass |
| `FFVHTL` | 1.539 | -0.000 | -0.020 | 0.241 | 318.776 | 624.763 | 5.666 | Pass |
| `FFVHTH` | 2.194 | 0.000 | -0.016 | 0.147 | 410.797 | 805.227 | 6.408 | Pass |
| `SSNOMNOM` | 1.400 | 0.000 | -0.041 | 0.611 | 196.115 | 384.135 | 6.452 | Pass |
| `SSVLNOM` | 1.362 | 0.000 | -0.042 | 0.611 | 196.115 | 384.135 | 6.439 | Pass |
| `SSVHNOM` | 1.427 | 0.000 | -0.041 | 0.611 | 196.115 | 384.134 | 6.464 | Pass |
| `SSNOMTL` | 1.136 | 0.000 | -0.050 | 0.762 | 174.135 | 340.986 | 6.142 | Pass |
| `SSNOMTH` | 1.619 | -0.000 | -0.034 | 0.475 | 224.272 | 439.376 | 7.032 | Pass |
| `SSVLTL` | 1.103 | 0.000 | -0.050 | 0.762 | 174.135 | 340.987 | 6.120 | Pass |
| `SSVLTH` | 1.581 | -0.000 | -0.035 | 0.475 | 224.273 | 439.377 | 7.029 | Pass |
| `SSVHTL` | 1.161 | 0.000 | -0.049 | 0.762 | 174.135 | 340.986 | 6.162 | Pass |
| `SSVHTH` | 1.645 | -0.000 | -0.033 | 0.475 | 224.272 | 439.376 | 7.036 | Pass |
| `FSNOMNOM` | 1.652 | -0.000 | -0.027 | 0.361 | 258.691 | 506.914 | 6.077 | Pass |
| `FSVLNOM` | 1.611 | -0.000 | -0.028 | 0.361 | 258.692 | 506.914 | 6.067 | Pass |
| `FSVHNOM` | 1.682 | -0.000 | -0.027 | 0.361 | 258.691 | 506.913 | 6.087 | Pass |
| `FSNOMTL` | 1.341 | 0.000 | -0.032 | 0.454 | 229.654 | 449.937 | 5.808 | Pass |
| `FSNOMTH` | 1.914 | 0.000 | -0.023 | 0.279 | 295.880 | 579.849 | 6.605 | Pass |
| `FSVLTL` | 1.306 | 0.000 | -0.032 | 0.454 | 229.654 | 449.938 | 5.790 | Pass |
| `FSVLTH` | 1.870 | 0.000 | -0.024 | 0.279 | 295.880 | 579.850 | 6.602 | Pass |
| `FSVHTL` | 1.369 | 0.000 | -0.031 | 0.454 | 229.654 | 449.937 | 5.824 | Pass |
| `FSVHTH` | 1.944 | -0.000 | -0.023 | 0.279 | 295.880 | 579.848 | 6.608 | Pass |
| `SFNOMNOM` | 1.556 | -0.000 | -0.027 | 0.361 | 258.690 | 506.911 | 6.274 | Pass |
| `SFVLNOM` | 1.520 | -0.000 | -0.027 | 0.361 | 258.690 | 506.912 | 6.261 | Pass |
| `SFVHNOM` | 1.583 | 0.000 | -0.026 | 0.361 | 258.690 | 506.911 | 6.287 | Pass |
| `SFNOMTL` | 1.263 | 0.000 | -0.031 | 0.454 | 229.653 | 449.935 | 5.983 | Pass |
| `SFNOMTH` | 1.808 | -0.000 | -0.023 | 0.279 | 295.878 | 579.846 | 6.827 | Pass |
| `SFVLTL` | 1.230 | 0.000 | -0.032 | 0.454 | 229.653 | 449.936 | 5.961 | Pass |
| `SFVLTH` | 1.773 | -0.000 | -0.023 | 0.279 | 295.879 | 579.847 | 6.822 | Pass |
| `SFVHTL` | 1.289 | 0.000 | -0.031 | 0.454 | 229.653 | 449.935 | 6.002 | Pass |
| `SFVHTH` | 1.835 | -0.000 | -0.022 | 0.279 | 295.878 | 579.846 | 6.831 | Pass |

</details>

## Generated artifacts

- [Analyzer](../../Measurement_Results/IC_Simulation/LPF/LPF_Analyze.m)
- [Comparison table](../../Measurement_Results/IC_Simulation/LPF/Reports/LPF_table_report.csv)
- [Nominal summary](../../Measurement_Results/IC_Simulation/LPF/Reports/NOM.LPF_summary.csv)
- [Full PVT data](../../Measurement_Results/IC_Simulation/LPF/Reports/LPF_full_pvt_report.csv)
- [Worst-case table](../../Measurement_Results/IC_Simulation/LPF/Reports/LPF_worst_case_report.csv)
- [MC run summary](../../Measurement_Results/IC_Simulation/LPF/Reports/MC_Run_Summary.csv)
- [MM summary](../../Measurement_Results/IC_Simulation/LPF/Reports/MM_MC_Summary.csv)
- [GL summary](../../Measurement_Results/IC_Simulation/LPF/Reports/GL_MC_Summary.csv)
- [FULL summary](../../Measurement_Results/IC_Simulation/LPF/Reports/FULL_MC_Summary.csv)

## Scope limitation

These results are schematic-level simulations. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
