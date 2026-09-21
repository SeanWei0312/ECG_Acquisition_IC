# FD OTA Detailed Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Value |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45 PVT corners |
| Statistical coverage | 200-run MM, GL, and FULL |
| Status | Pass |

## Detailed results

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

## Monte Carlo results

MM applies local mismatch, GL applies global process variation, and FULL combines both. Each campaign requested 200 runs, produced 200 valid runs with zero failed runs, and achieved 100% joint yield. The tables include every metric exported in the corresponding MC summary CSV.

### MM Monte Carlo — complete statistics

| Parameter | Unit | Spec | Min | μ−3σ | μ−σ | Mean | μ+σ | μ+3σ | Max | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| FDC bias current | µA | 40±10 | 38.852 | 38.414 | 39.515 | 40.065 | 40.615 | 41.716 | 41.496 | 100% |
| CMFB bias current | µA | 40±10 | 38.907 | 38.439 | 39.528 | 40.073 | 40.617 | 41.707 | 41.524 | 100% |
| Total current | mA | ≤2.5 | 1.541 | 1.524 | 1.577 | 1.603 | 1.629 | 1.681 | 1.682 | 100% |
| Total power | mW | ≤9 | 5.085 | 5.031 | 5.203 | 5.290 | 5.376 | 5.549 | 5.550 | 100% |
| Differential DC gain | dB | ≥85 | 88.639 | 88.647 | 88.683 | 88.700 | 88.718 | 88.753 | 88.739 | 100% |
| Differential UGF | MHz | ≥8 | 11.905 | 11.782 | 12.223 | 12.443 | 12.664 | 13.105 | 13.294 | 100% |
| Differential phase margin | ° | ≥60 | 72.273 | 72.259 | 72.514 | 72.641 | 72.769 | 73.023 | 73.059 | 100% |
| Input differential offset | µV | ±3000 | −2097.010 | −2276.450 | −738.365 | 30.677 | 799.720 | 2337.805 | 2355.490 | 100% |
| Gain error | % | ±0.01 | −0.003700 | −0.003697 | −0.003681 | −0.003673 | −0.003665 | −0.003648 | −0.003660 | 100% |
| Output CM error | mV | ±25 | −9.632 | −11.905 | −3.912 | 0.0842 | 4.081 | 12.073 | 11.463 | 100% |

### GL Monte Carlo — complete statistics

| Parameter | Unit | Spec | Min | μ−3σ | μ−σ | Mean | μ+σ | μ+3σ | Max | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| FDC bias current | µA | 40±10 | 39.253 | 39.101 | 39.771 | 40.107 | 40.442 | 41.112 | 40.929 | 100% |
| CMFB bias current | µA | 40±10 | 39.253 | 39.101 | 39.771 | 40.107 | 40.442 | 41.112 | 40.929 | 100% |
| Total current | mA | ≤2.5 | 1.547 | 1.534 | 1.582 | 1.607 | 1.631 | 1.680 | 1.680 | 100% |
| Total power | mW | ≤9 | 5.106 | 5.062 | 5.222 | 5.302 | 5.383 | 5.543 | 5.544 | 100% |
| Differential DC gain | dB | ≥85 | 87.799 | 87.629 | 88.320 | 88.666 | 89.011 | 89.702 | 89.613 | 100% |
| Differential UGF | MHz | ≥8 | 11.411 | 11.263 | 12.071 | 12.475 | 12.878 | 13.686 | 13.603 | 100% |
| Differential phase margin | ° | ≥60 | 69.206 | 68.362 | 71.234 | 72.670 | 74.105 | 76.977 | 77.492 | 100% |
| Input differential offset | µV | ±3000 | −0.000482 | −0.000238 | −0.000080 | −0.000001 | 0.000078 | 0.000236 | 0.000445 | 100% |
| Gain error | % | ±0.01 | −0.004070 | −0.004131 | −0.003837 | −0.003690 | −0.003543 | −0.003249 | −0.003310 | 100% |
| Output CM error | mV | ±25 | −3.511 | −4.594 | −1.279 | 0.3791 | 2.037 | 5.353 | 5.374 | 100% |

### FULL Monte Carlo — complete statistics

| Parameter | Unit | Spec | Min | μ−3σ | μ−σ | Mean | μ+σ | μ+3σ | Max | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| FDC bias current | µA | 40±10 | 38.723 | 38.176 | 39.445 | 40.080 | 40.715 | 41.984 | 41.716 | 100% |
| CMFB bias current | µA | 40±10 | 38.712 | 38.201 | 39.459 | 40.088 | 40.717 | 41.974 | 41.605 | 100% |
| Total current | mA | ≤2.5 | 1.519 | 1.497 | 1.570 | 1.606 | 1.642 | 1.715 | 1.745 | 100% |
| Total power | mW | ≤9 | 5.013 | 4.940 | 5.179 | 5.299 | 5.419 | 5.658 | 5.758 | 100% |
| Differential DC gain | dB | ≥85 | 87.784 | 87.623 | 88.319 | 88.667 | 89.015 | 89.710 | 89.621 | 100% |
| Differential UGF | MHz | ≥8 | 11.307 | 11.183 | 12.040 | 12.469 | 12.898 | 13.755 | 13.686 | 100% |
| Differential phase margin | ° | ≥60 | 68.996 | 68.280 | 71.203 | 72.665 | 74.127 | 77.051 | 77.849 | 100% |
| Input differential offset | µV | ±3000 | −2096.150 | −2276.341 | −738.306 | 30.711 | 799.728 | 2337.763 | 2354.430 | 100% |
| Gain error | % | ±0.01 | −0.004080 | −0.004133 | −0.003838 | −0.003690 | −0.003542 | −0.003246 | −0.003300 | 100% |
| Output CM error | mV | ±25 | −9.947 | −13.783 | −4.546 | 0.0726 | 4.691 | 13.928 | 13.681 | 100% |

## Corner comparison

### FD OTA comparison: NOM, FF, SS, FS, SF, VL, VH, TL, TH

| Parameter | Unit | Spec | NOM | FF | SS | FS | SF | VL | VH | TL | TH |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| **SET CONDITIONS** | — | — | — | — | — | — | — | — | — | — | — |
| AVDD | V | — | 3.300 | 3.300 | 3.300 | 3.300 | 3.300 | 3.000 | 3.600 | 3.300 | 3.300 |
| Vin,cm | V | — | 1.650 | 1.650 | 1.650 | 1.650 | 1.650 | 1.500 | 1.800 | 1.650 | 1.650 |
| VREF | V | — | 1.650 | 1.650 | 1.650 | 1.650 | 1.650 | 1.500 | 1.800 | 1.650 | 1.650 |
| Closed-loop target gain | V/V | — | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 | 1.000 |
| **OPERATING POINT** | — | — | — | — | — | — | — | — | — | — | — |
| FDC bias current | uA | 40±10 | 40.092 | 45.286 | 35.875 | 40.727 | 39.434 | 39.479 | 40.525 | 35.435 | 43.278 |
| CMFB bias current | uA | 40±10 | 40.092 | 45.286 | 35.875 | 40.727 | 39.434 | 39.479 | 40.525 | 35.435 | 43.278 |
| Total current | mA | ≤2.5 | 1.604 | 1.857 | 1.400 | 1.652 | 1.556 | 1.568 | 1.633 | 1.302 | 1.861 |
| Total power | mW | ≤9 | 5.293 | 6.129 | 4.620 | 5.451 | 5.133 | 4.703 | 5.878 | 4.296 | 6.142 |
| **OPEN-LOOP SIMULATION** | — | — | — | — | — | — | — | — | — | — | — |
| Differential DC gain | dB | ≥85 | 88.699 | 88.550 | 88.731 | 88.379 | 88.952 | 88.122 | 89.195 | 89.168 | 87.741 |
| Differential UGF | MHz | ≥8 | 12.447 | 14.528 | 10.764 | 12.619 | 12.257 | 12.170 | 12.662 | 13.933 | 10.253 |
| Differential phase margin | deg | ≥60 | 72.649 | 66.886 | 77.375 | 71.851 | 73.436 | 72.365 | 72.892 | 75.290 | 69.080 |
| Input differential offset | uV | ±3000 | -0.000 | -0.000 | 0.000 | 0.000 | 0.000 | -0.000 | 0.000 | -0.000 | -0.000 |
| CMRR @ 60 Hz | dB | ≥80 | 285.310 | 311.336 | 296.211 | 334.082 | 294.280 | 314.786 | 298.385 | 285.922 | 286.303 |
| CMRR @ 150 Hz | dB | ≥80 | 285.322 | 358.824 | 295.776 | 331.726 | 294.428 | 338.284 | 298.865 | 286.211 | 286.341 |
| PSRR+ @ 60 Hz | dB | ≥80 | 266.685 | 272.894 | 259.938 | 276.403 | 271.821 | 276.696 | 273.872 | 272.874 | 259.735 |
| PSRR+ @ 150 Hz | dB | ≥80 | 258.182 | 273.176 | 266.133 | 260.513 | 260.086 | 260.002 | 260.203 | 262.669 | 305.063 |
| PSRR- @ 60 Hz | dB | ≥80 | 282.569 | 291.306 | 279.423 | 278.740 | 292.440 | 294.133 | 297.502 | 309.147 | 274.160 |
| PSRR- @ 150 Hz | dB | ≥80 | 277.076 | 300.965 | 282.441 | 280.892 | 283.131 | 286.933 | 288.764 | 282.124 | 273.993 |
| Input-referred noise 0.05-150 Hz | uVrms | ≤4 | 3.086 | 2.950 | 3.222 | 3.035 | 3.135 | 3.080 | 3.091 | 2.945 | 3.356 |
| **CLOSED-LOOP SIMULATION** | — | — | — | — | — | — | — | — | — | — | — |
| Closed-loop differential gain | dB | — | -3.190e-04 | -3.247e-04 | -3.165e-04 | -3.310e-04 | -3.102e-04 | -3.411e-04 | -3.010e-04 | -3.023e-04 | -3.551e-04 |
| Gain error | % | ±0.01 | -0.004 | -0.004 | -0.004 | -0.004 | -0.004 | -0.004 | -0.003 | -0.003 | -0.004 |
| Output common mode, DC | V | — | 1.650 | 1.648 | 1.653 | 1.652 | 1.649 | 1.500 | 1.800 | 1.643 | 1.661 |
| Output CM error | mV | ±25 | 0.395 | -1.839 | 2.748 | 1.747 | -1.017 | 0.365 | 0.415 | -6.733 | 10.536 |
| Input CM low | mV | ≤1000 | 870.000 | 770.000 | 975.000 | 790.000 | 955.000 | 870.000 | 875.000 | 870.000 | 865.000 |
| Input CM high | V | ≥2.3 | 3.300 | 3.300 | 3.300 | 3.185 | 3.300 | 3.000 | 3.600 | 3.300 | 3.300 |
| Input CM high headroom | mV | — | 0.000 | 0.000 | 0.000 | 115.000 | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 |
| Differential output swing low | V | ≤-1.8 | -3.188 | -3.183 | -3.188 | -3.173 | -3.198 | -2.888 | -3.483 | -3.233 | -3.118 |
| Differential output swing high | V | ≥1.8 | 3.188 | 3.183 | 3.188 | 3.173 | 3.198 | 2.888 | 3.483 | 3.233 | 3.118 |
| Differential SR rise | V/us | ≥4 | 7.232 | 9.031 | 5.903 | 7.360 | 7.103 | 7.101 | 7.334 | 6.443 | 7.706 |
| Differential SR fall | V/us | ≥4 | 7.232 | 9.031 | 5.903 | 7.360 | 7.103 | 7.101 | 7.334 | 6.443 | 7.706 |
| Differential settling time | ns | ≤300 | 149.698 | 149.144 | 200.295 | 165.133 | 154.280 | 154.705 | 149.702 | 174.303 | 180.993 |
| Differential-step CM disturbance | mV | ≤60 | 30.247 | 27.596 | 33.256 | 30.706 | 29.694 | 30.066 | 30.352 | 24.927 | 39.263 |
| CMFB SR rise | V/us | ≥2 | 3.589 | 4.487 | 2.913 | 3.660 | 3.505 | 3.477 | 3.650 | 3.208 | 3.800 |
| CMFB SR fall | V/us | ≥2 | 3.526 | 4.541 | 2.785 | 3.541 | 3.509 | 3.468 | 3.569 | 3.474 | 3.379 |
| CMFB settling time | ns | ≤1000 | 329.729 | 275.711 | 373.846 | 325.534 | 333.998 | 334.052 | 325.742 | 340.681 | 333.963 |

## Plots

### All generated FD OTA plots

![FD OTA open-loop gain and phase](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.open_loop_gain_phase.png)

![FD OTA open-loop transfer curve](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.open_loop_vtc.png)

![FD OTA CMRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.cmrr.png)

![FD OTA PSRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.psrr.png)

![FD OTA input-referred noise](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.input_referred_noise_density.png)

![FD OTA input common-mode range](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.input_common_mode_range.png)

![FD OTA output swing and closed-loop transfer](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.output_swing_and_closed_loop_vtc.png)

![FD OTA closed-loop step response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.closed_loop_step_response.png)

![FD OTA differential-step common-mode disturbance](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.diff_step_cm_disturbance.png)

![FD OTA output common-mode transient](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.output_cm_transient.png)

![FD OTA MC input offset](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_01_Input_Offset_Histogram.png)

![FD OTA MC output common-mode error](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_02_Output_CM_Error_Histogram.png)

![FD OTA MC DC gain](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_03_DC_Gain_Histogram.png)

![FD OTA MC UGF](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_04_UGF_Histogram.png)

![FD OTA MC phase margin](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_05_Phase_Margin_Histogram.png)

![FD OTA MC gain error](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_06_Gain_Error_Histogram.png)

### All generated FDC and CMFB internal-testbench plots

![FDC differential AC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.diff_ac.png)

![FDC differential-step common-mode disturbance](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.diff_step_cm_disturbance.png)

![FDC input-referred noise](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.noise.png)

![FDC input offset](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.offset.png)

![FDC plant AC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.plant_ac.png)

![FDC plant DC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.plant_dc.png)

![FDC CMFB-control sweep](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.vcmfb_sweep.png)

![CMFB closed-loop DC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/Plots/NOM.cl_dc.png)

![CMFB closed-loop transient](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/Plots/NOM.cl_tran.png)

![CMFB open-loop AC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/Plots/NOM.ol_ac.png)

## All 45 PVT corners

### FD OTA: all 45 PVT corners

| Corner | Current (mA) | Gain (dB) | UGF (MHz) | PM (°) | CM error (mV) | Noise (µVrms) | Status |
| :--- | ---: | ---: | ---: | ---: | ---: | ---: | :---: |
| `NOMNOMNOM` | 1.604 | 88.699 | 12.447 | 72.649 | 0.395 | 3.086 | Pass |
| `NOMVLNOM` | 1.568 | 88.122 | 12.170 | 72.365 | 0.365 | 3.080 | Pass |
| `NOMVHNOM` | 1.633 | 89.195 | 12.662 | 72.892 | 0.415 | 3.091 | Pass |
| `NOMNOMTL` | 1.302 | 89.168 | 13.933 | 75.290 | -6.733 | 2.945 | Pass |
| `NOMNOMTH` | 1.861 | 87.741 | 10.253 | 69.080 | 10.536 | 3.356 | Pass |
| `NOMVLTL` | 1.269 | 88.659 | 13.588 | 74.999 | -6.769 | 2.935 | Pass |
| `NOMVLTH` | 1.825 | 87.088 | 10.059 | 68.858 | 10.504 | 3.354 | Pass |
| `NOMVHTL` | 1.329 | 89.601 | 14.211 | 75.543 | -6.702 | 2.954 | Pass |
| `NOMVHTH` | 1.890 | 88.308 | 10.402 | 69.273 | 10.555 | 3.358 | Pass |
| `FFNOMNOM` | 1.857 | 88.550 | 14.528 | 66.886 | -1.839 | 2.950 | Pass |
| `FFVLNOM` | 1.819 | 87.973 | 14.261 | 66.636 | -1.875 | 2.945 | Pass |
| `FFVHNOM` | 1.889 | 89.041 | 14.747 | 67.108 | -1.813 | 2.956 | Pass |
| `FFNOMTL` | 1.509 | 89.047 | 15.922 | 69.709 | -9.068 | 2.824 | Pass |
| `FFNOMTH` | 2.163 | 87.531 | 12.277 | 63.557 | 8.577 | 3.200 | Pass |
| `FFVLTL` | 1.474 | 88.537 | 15.600 | 69.419 | -9.112 | 2.815 | Pass |
| `FFVLTH` | 2.124 | 86.877 | 12.079 | 63.377 | 8.536 | 3.198 | Pass |
| `FFVHTL` | 1.539 | 89.474 | 16.195 | 69.968 | -9.030 | 2.832 | Pass |
| `FFVHTH` | 2.194 | 88.094 | 12.437 | 63.721 | 8.601 | 3.203 | Pass |
| `SSNOMNOM` | 1.400 | 88.731 | 10.764 | 77.375 | 2.748 | 3.222 | Pass |
| `SSVLNOM` | 1.362 | 88.152 | 10.448 | 77.055 | 2.724 | 3.215 | Pass |
| `SSVHNOM` | 1.427 | 89.234 | 10.983 | 77.633 | 2.762 | 3.228 | Pass |
| `SSNOMTL` | 1.136 | 89.203 | 12.319 | 79.673 | -4.287 | 3.066 | Pass |
| `SSNOMTH` | 1.619 | 87.784 | 8.645 | 73.673 | 12.633 | 3.512 | Pass |
| `SSVLTL` | 1.103 | 88.692 | 11.920 | 79.407 | -4.313 | 3.055 | Pass |
| `SSVLTH` | 1.581 | 87.126 | 8.435 | 73.396 | 12.610 | 3.511 | Pass |
| `SSVHTL` | 1.161 | 89.643 | 12.610 | 79.898 | -4.265 | 3.076 | Pass |
| `SSVHTH` | 1.645 | 88.358 | 8.788 | 73.895 | 12.643 | 3.514 | Pass |
| `FSNOMNOM` | 1.652 | 88.379 | 12.619 | 71.851 | 1.747 | 3.035 | Pass |
| `FSVLNOM` | 1.611 | 87.775 | 12.319 | 71.548 | 1.692 | 3.031 | Pass |
| `FSVHNOM` | 1.682 | 88.917 | 12.840 | 72.104 | 1.781 | 3.041 | Pass |
| `FSNOMTL` | 1.341 | 88.829 | 14.122 | 74.463 | -5.139 | 2.901 | Pass |
| `FSNOMTH` | 1.914 | 87.441 | 10.390 | 68.299 | 11.505 | 3.299 | Pass |
| `FSVLTL` | 1.306 | 88.295 | 13.765 | 74.159 | -5.189 | 2.892 | Pass |
| `FSVLTH` | 1.870 | 86.753 | 10.166 | 68.053 | 11.426 | 3.299 | Pass |
| `FSVHTL` | 1.369 | 89.304 | 14.405 | 74.723 | -5.100 | 2.909 | Pass |
| `FSVHTH` | 1.944 | 88.050 | 10.544 | 68.501 | 11.544 | 3.302 | Pass |
| `SFNOMNOM` | 1.556 | 88.952 | 12.257 | 73.436 | -1.017 | 3.135 | Pass |
| `SFVLNOM` | 1.520 | 88.413 | 11.978 | 73.161 | -1.018 | 3.128 | Pass |
| `SFVHNOM` | 1.583 | 89.369 | 12.471 | 73.672 | -1.017 | 3.141 | Pass |
| `SFNOMTL` | 1.263 | 89.453 | 13.722 | 76.111 | -8.393 | 2.989 | Pass |
| `SFNOMTH` | 1.808 | 87.953 | 10.106 | 69.853 | 9.515 | 3.411 | Pass |
| `SFVLTL` | 1.230 | 88.981 | 13.369 | 75.826 | -8.411 | 2.978 | Pass |
| `SFVLTH` | 1.773 | 87.337 | 9.916 | 69.642 | 9.530 | 3.409 | Pass |
| `SFVHTL` | 1.289 | 89.804 | 14.000 | 76.358 | -8.373 | 2.999 | Pass |
| `SFVHTH` | 1.835 | 88.443 | 10.254 | 70.037 | 9.502 | 3.414 | Pass |

## Generated artifacts

- [Analyzer](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDOTA_Analyze.m)
- [Comparison table](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FDOTA_table_report.csv)
- [Nominal summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/NOM.FDOTA_summary.csv)
- [Worst-case table](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FDOTA_worst_case_report.csv)
- [MC run summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FDOTA_MC_Run_Summary.csv)
- [MM summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/MM_FDOTA_MC_Summary.csv)
- [GL summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/GL_FDOTA_MC_Summary.csv)
- [FULL summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FULL_FDOTA_MC_Summary.csv)
- [FDC nominal summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/NOM.FDC_summary.csv)
- [CMFB nominal summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/NOM.CMFB_summary.csv)

## Scope limitation

These results are schematic-level simulations. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
