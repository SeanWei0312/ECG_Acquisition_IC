# SE OTA Detailed Verification Report

[← System-level project report](Project_Report.md)

| Item | Value |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45 PVT corners |
| Statistical coverage | 200-run MM, GL, and FULL |
| Status | Pass |

## Detailed results

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
<summary>SE OTA comparison: NOM, FF, SS, FS, SF, VL, VH, TL, TH</summary>

| Parameter | Unit | Spec | NOM | FF | SS | FS | SF | VL | VH | TL | TH |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| **SET CONDITIONS** | — | — | — | — | — | — | — | — | — | — | — |
| AVDD | V | — | 3.300 | 3.300 | 3.300 | 3.300 | 3.300 | 3.000 | 3.600 | 3.300 | 3.300 |
| CLoad | pF | — | 10.000 | 10.000 | 10.000 | 10.000 | 10.000 | 10.000 | 10.000 | 10.000 | 10.000 |
| Vin,cm | V | — | 1.650 | 1.650 | 1.650 | 1.650 | 1.650 | 1.500 | 1.800 | 1.650 | 1.650 |
| Closed-loop target gain | V/V | — | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |
| **OPERATING POINT** | — | — | — | — | — | — | — | — | — | — | — |
| Bias current | uA | 40±10 | 40.092 | 45.286 | 35.875 | 40.727 | 39.434 | 39.479 | 40.525 | 35.435 | 43.278 |
| Total current | mA | ≤1.25 | 0.825 | 0.942 | 0.730 | 0.841 | 0.808 | 0.806 | 0.839 | 0.680 | 0.948 |
| Total power | mW | ≤4.5 | 2.721 | 3.109 | 2.408 | 2.774 | 2.665 | 2.419 | 3.020 | 2.244 | 3.128 |
| **OPEN-LOOP SIMULATION** | — | — | — | — | — | — | — | — | — | — | — |
| DC gain | dB | ≥88 | 96.522 | 96.345 | 96.324 | 96.190 | 96.634 | 95.934 | 97.023 | 96.599 | 95.678 |
| UGF | MHz | ≥8 | 12.835 | 15.068 | 11.066 | 13.115 | 12.548 | 12.566 | 13.041 | 14.448 | 10.616 |
| Phase margin | deg | ≥55 | 67.767 | 61.737 | 72.737 | 67.661 | 67.832 | 67.337 | 68.117 | 72.157 | 62.054 |
| Input offset | uV | ±2000 | 3.193 | 7.450 | -1.468 | 6.456 | -0.088 | 3.235 | 3.169 | -1.045 | 6.918 |
| CMRR @ 60 Hz | dB | ≥105 | 111.957 | 112.400 | 111.313 | 112.118 | 111.684 | 110.932 | 112.777 | 111.742 | 111.777 |
| CMRR @ 150 Hz | dB | ≥105 | 111.957 | 112.400 | 111.313 | 112.118 | 111.684 | 110.932 | 112.777 | 111.742 | 111.777 |
| PSRR+ @ 60 Hz | dB | ≥100 | 103.379 | 104.391 | 102.078 | 103.983 | 102.630 | 103.109 | 103.712 | 103.261 | 102.744 |
| PSRR+ @ 150 Hz | dB | ≥95 | 99.232 | 100.834 | 97.580 | 99.597 | 98.795 | 99.048 | 99.422 | 99.397 | 98.271 |
| PSRR- @ 60 Hz | dB | ≥100 | 103.379 | 104.390 | 102.078 | 103.983 | 102.631 | 103.109 | 103.712 | 103.261 | 102.743 |
| PSRR- @ 150 Hz | dB | ≥95 | 99.232 | 100.834 | 97.581 | 99.597 | 98.796 | 99.048 | 99.422 | 99.397 | 98.271 |
| Input-referred noise 0.05-150 Hz | uVrms | ≤2.5 | 1.873 | 1.780 | 1.969 | 1.849 | 1.898 | 1.874 | 1.874 | 1.774 | 2.074 |
| **CLOSED-LOOP SIMULATION** | — | — | — | — | — | — | — | — | — | — | — |
| Closed-loop gain | dB | — | -1.042e-04 | -1.051e-04 | -1.129e-04 | -1.131e-04 | -1.091e-04 | -1.111e-04 | -1.012e-04 | -1.073e-04 | -1.062e-04 |
| Gain error | % | ±0.01 | -0.001 | -0.001 | -0.001 | -0.001 | -0.001 | -0.001 | -0.001 | -0.001 | -0.001 |
| Vout,DC error | uV | ±2000 | -3.192 | -7.419 | 1.504 | -6.455 | 0.088 | -3.204 | -3.131 | 1.045 | -6.919 |
| Input low | mV | ≤600 | 106.000 | 24.000 | 255.000 | 40.000 | 203.000 | 148.000 | 157.000 | 292.000 | 0.000 |
| Input high | V | ≥2.75 | 3.237 | 3.235 | 3.238 | 3.186 | 3.259 | 2.929 | 3.542 | 3.259 | 3.207 |
| Input high headroom | mV | ≤250 | 63.000 | 65.000 | 62.000 | 114.000 | 41.000 | 71.000 | 58.000 | 41.000 | 93.000 |
| Output low | mV | ≤600 | 107.816 | 25.948 | 256.895 | 41.868 | 203.702 | 149.951 | 158.980 | 293.880 | 0.100 |
| Output high | V | ≥2.75 | 3.235 | 3.233 | 3.236 | 3.184 | 3.257 | 2.927 | 3.540 | 3.257 | 3.205 |
| Output high headroom | mV | ≤250 | 64.870 | 66.875 | 63.741 | 115.860 | 42.653 | 72.717 | 59.744 | 42.636 | 94.944 |
| SR rise | V/us | ≥6.5 | 9.814 | 12.563 | 7.852 | 9.980 | 9.640 | 9.655 | 9.927 | 8.855 | 10.248 |
| SR fall | V/us | ≥5.0 | 7.966 | 9.902 | 6.533 | 8.093 | 7.834 | 7.803 | 8.091 | 7.040 | 8.628 |
| Settling time | ns | ≤225 | 163.400 | 129.900 | 199.900 | 160.900 | 165.900 | 165.400 | 161.400 | 171.400 | 163.900 |

</details>


## Plots

<details>
<summary>All generated SE OTA plots</summary>

![SE OTA open-loop gain and phase](../Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.open_loop_gain_phase.png)

![SE OTA open-loop transfer curve](../Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.open_loop_vtc.png)

![SE OTA CMRR](../Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.cmrr.png)

![SE OTA PSRR](../Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.psrr.png)

![SE OTA input-referred noise](../Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.input_referred_noise_density.png)

![SE OTA closed-loop usable range](../Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.closed_loop_usable_range.png)

![SE OTA closed-loop step response](../Measurement_Results/IC_Simulation/SE_OTA/Plots/NOM.closed_loop_step_response.png)

![SE OTA MC input offset](../Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_01_Vos_Histogram.png)

![SE OTA MC DC gain](../Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_02_DC_Gain_Histogram.png)

![SE OTA MC UGF](../Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_03_UGF_Histogram.png)

![SE OTA MC phase margin](../Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_04_Phase_Margin_Histogram.png)

![SE OTA MC gain error](../Measurement_Results/IC_Simulation/SE_OTA/Plots/Fig_MC_05_Gain_Error_Histogram.png)

</details>

## All 45 PVT corners

<details>
<summary>SE OTA: all 45 PVT corners</summary>

| Corner | Current (mA) | Gain (dB) | UGF (MHz) | PM (°) | Offset (µV) | Noise (µVrms) | Status |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :---: |
| `NOMNOMNOM` | 0.825 | 96.522 | 12.835 | 67.767 | 3.193 | 1.873 | Pass |
| `NOMVLNOM` | 0.806 | 95.934 | 12.566 | 67.337 | 3.235 | 1.874 | Pass |
| `NOMVHNOM` | 0.839 | 97.023 | 13.041 | 68.117 | 3.169 | 1.874 | Pass |
| `NOMNOMTL` | 0.680 | 96.599 | 14.448 | 72.157 | -1.045 | 1.774 | Pass |
| `NOMNOMTH` | 0.948 | 95.678 | 10.616 | 62.054 | 6.918 | 2.074 | Pass |
| `NOMVLTL` | 0.664 | 96.080 | 14.105 | 71.686 | -1.168 | 1.772 | Pass |
| `NOMVLTH` | 0.930 | 94.944 | 10.424 | 61.718 | 7.126 | 2.077 | Pass |
| `NOMVHTL` | 0.694 | 97.034 | 14.720 | 72.545 | -0.914 | 1.776 | Pass |
| `NOMVHTH` | 0.962 | 96.294 | 10.761 | 62.330 | 6.735 | 2.072 | Pass |
| `FFNOMNOM` | 0.942 | 96.345 | 15.068 | 61.737 | 7.450 | 1.780 | Pass |
| `FFVLNOM` | 0.923 | 95.698 | 14.807 | 61.377 | 7.602 | 1.780 | Pass |
| `FFVHNOM` | 0.958 | 96.874 | 15.279 | 62.044 | 7.344 | 1.781 | Pass |
| `FFNOMTL` | 0.775 | 96.746 | 16.631 | 65.770 | 3.471 | 1.689 | Pass |
| `FFNOMTH` | 1.090 | 95.026 | 12.727 | 56.643 | 11.054 | 1.967 | Pass |
| `FFVLTL` | 0.758 | 96.227 | 16.314 | 65.370 | 3.456 | 1.687 | Pass |
| `FFVLTH` | 1.071 | 94.151 | 12.527 | 56.368 | 11.377 | 1.969 | Pass |
| `FFVHTL` | 0.790 | 97.180 | 16.895 | 66.113 | 3.517 | 1.691 | Pass |
| `FFVHTH` | 1.106 | 95.725 | 12.885 | 56.883 | 10.793 | 1.966 | Pass |
| `SSNOMNOM` | 0.730 | 96.324 | 11.066 | 72.737 | -1.468 | 1.969 | Pass |
| `SSVLNOM` | 0.710 | 95.741 | 10.755 | 72.191 | -1.551 | 1.971 | Pass |
| `SSVHNOM` | 0.743 | 96.822 | 11.277 | 73.144 | -1.407 | 1.969 | Pass |
| `SSNOMTL` | 0.603 | 96.114 | 12.698 | 77.260 | -5.903 | 1.861 | Pass |
| `SSNOMTH` | 0.834 | 95.818 | 8.970 | 66.582 | 2.333 | 2.185 | Pass |
| `SSVLTL` | 0.586 | 95.572 | 12.289 | 76.687 | -6.134 | 1.859 | Pass |
| `SSVLTH` | 0.814 | 95.150 | 8.762 | 66.160 | 2.404 | 2.189 | Pass |
| `SSVHTL` | 0.616 | 96.543 | 12.994 | 77.712 | -5.684 | 1.863 | Pass |
| `SSVHTH` | 0.847 | 96.397 | 9.110 | 66.901 | 2.232 | 2.182 | Pass |
| `FSNOMNOM` | 0.841 | 96.190 | 13.115 | 67.661 | 6.456 | 1.849 | Pass |
| `FSVLNOM` | 0.821 | 95.552 | 12.816 | 67.205 | 6.464 | 1.850 | Pass |
| `FSVHNOM` | 0.855 | 96.757 | 13.330 | 68.019 | 6.424 | 1.849 | Pass |
| `FSNOMTL` | 0.696 | 96.379 | 14.808 | 72.036 | 0.735 | 1.753 | Pass |
| `FSNOMTH` | 0.963 | 94.878 | 10.804 | 61.900 | 11.876 | 2.047 | Pass |
| `FSVLTL` | 0.679 | 95.837 | 14.441 | 71.553 | 0.538 | 1.751 | Pass |
| `FSVLTH` | 0.941 | 93.988 | 10.577 | 61.536 | 12.092 | 2.050 | Pass |
| `FSVHTL` | 0.709 | 96.863 | 15.093 | 72.428 | 0.926 | 1.755 | Pass |
| `FSVHTH` | 0.977 | 95.646 | 10.958 | 62.185 | 11.612 | 2.045 | Pass |
| `SFNOMNOM` | 0.808 | 96.634 | 12.548 | 67.832 | -0.088 | 1.898 | Pass |
| `SFVLNOM` | 0.789 | 96.100 | 12.281 | 67.404 | -0.006 | 1.899 | Pass |
| `SFVHNOM` | 0.822 | 97.026 | 12.750 | 68.180 | -0.153 | 1.899 | Pass |
| `SFNOMTL` | 0.664 | 96.715 | 14.085 | 72.234 | -2.796 | 1.796 | Pass |
| `SFNOMTH` | 0.932 | 95.905 | 10.415 | 62.169 | 1.806 | 2.103 | Pass |
| `SFVLTL` | 0.647 | 96.237 | 13.741 | 71.758 | -2.825 | 1.794 | Pass |
| `SFVLTH` | 0.914 | 95.285 | 10.230 | 61.842 | 1.999 | 2.105 | Pass |
| `SFVHTL` | 0.677 | 97.052 | 14.350 | 72.621 | -2.766 | 1.799 | Pass |
| `SFVHTH` | 0.946 | 96.369 | 10.556 | 62.440 | 1.645 | 2.101 | Pass |

</details>

## Generated artifacts

- [Analyzer](../Measurement_Results/IC_Simulation/SE_OTA/SEOTA_Analyze.m)
- [Comparison table](../Measurement_Results/IC_Simulation/SE_OTA/Reports/SEOTA_table_report.csv)
- [Nominal summary](../Measurement_Results/IC_Simulation/SE_OTA/Reports/NOM.SEOTA_summary.csv)
- [Worst-case table](../Measurement_Results/IC_Simulation/SE_OTA/Reports/SEOTA_worst_case_report.csv)
- [MC run summary](../Measurement_Results/IC_Simulation/SE_OTA/Reports/SEOTA_MC_Run_Summary.csv)
- [MM summary](../Measurement_Results/IC_Simulation/SE_OTA/Reports/MM_SEOTA_MC_Summary.csv)
- [GL summary](../Measurement_Results/IC_Simulation/SE_OTA/Reports/GL_SEOTA_MC_Summary.csv)
- [FULL summary](../Measurement_Results/IC_Simulation/SE_OTA/Reports/FULL_SEOTA_MC_Summary.csv)

## Scope limitation

These results are schematic-level simulations. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
