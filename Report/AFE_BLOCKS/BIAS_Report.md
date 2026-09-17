# BIAS / SEL Detailed Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Value |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | Process, voltage, temperature, startup, and selector campaigns |
| Statistical coverage | Not included |
| Status | Complete |

## Detailed results

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

## Worst-case results

### Complete BIAS/SEL worst-case results

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

## Corner comparison

### BIAS comparison: NOM, FF, SS, FS, SF, VL, VH, TL, TH

| Parameter | Unit | NOM | FF | SS | FS | SF | VL | VH | TL | TH |
| :--- | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Ibias | uA | 39.997 | 45.168 | 35.799 | 40.621 | 39.350 | 39.393 | 40.423 | 35.353 | 43.171 |
| Ibias error | % | -7.499e-03 | 12.920 | -10.503 | 1.553 | -1.626 | -1.517 | 1.056 | -11.619 | 7.926 |
| IRS | uA | 39.998 | 45.150 | 35.815 | 40.641 | 39.332 | 39.418 | 40.402 | 35.341 | 43.187 |
| Mirror error | % | -2.826e-03 | 4.073e-02 | -4.456e-02 | -4.869e-02 | 4.598e-02 | -6.296e-02 | 5.137e-02 | 3.385e-02 | -3.796e-02 |
| BP | V | 1.643 | 1.748 | 1.533 | 1.523 | 1.763 | 1.350 | 1.938 | 1.735 | 1.553 |
| VREF | V | 1.650 | 1.650 | 1.650 | 1.650 | 1.650 | 1.500 | 1.800 | 1.650 | 1.650 |
| VREF error | uV | -4.170 | -3.334 | -5.005 | -4.168 | -4.171 | -3.793 | -4.546 | -4.701 | -3.377 |
| IMST | fA | 2.083e-08 | 4.584e-07 | 1.184e-09 | 9.002e-07 | 4.722e-10 | 2.801e-07 | 1.740e-09 | 3.073e-14 | 1.584e-03 |
| MST margin | V | 1.541 | 1.209 | 1.878 | 1.452 | 1.631 | 1.759 | 1.316 | 1.648 | 1.328 |
| IDD | uA | 83.192 | 94.351 | 74.243 | 84.477 | 81.858 | 81.641 | 84.356 | 73.507 | 90.061 |
| Power | uW | 274.532 | 311.359 | 245.001 | 278.773 | 270.131 | 244.924 | 303.680 | 242.575 | 297.202 |
| Startup time | us | 807.362 | 777.960 | 839.330 | 838.091 | 804.620 | 882.469 | 743.647 | 896.695 | 807.833 |

## Monte Carlo results

MM, GL, and FULL Monte Carlo campaigns have not been generated for BIAS/SEL, so no statistical values or yields are reported.

## Plots

### All generated BIAS/SEL plots

![BIAS 2D voltage-temperature surface](../../Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_2D.png)

![BIAS selector verification](../../Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_SEL.png)

![BIAS startup current](../../Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_STARTUP.png)

![BIAS startup voltage](../../Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_STARTUP_VOLTAGE.png)

![BIAS temperature sweep](../../Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_TEMP.png)

![BIAS supply sweep](../../Measurement_Results/IC_Simulation/BIAS/Plots/NOM_BIAS_VDD.png)

## Generated artifacts

- [Analyzer](../../Measurement_Results/IC_Simulation/BIAS/BIAS_Analyze.m)
- [Comparison table](../../Measurement_Results/IC_Simulation/BIAS/BIAS_table_report.csv)
- [Two-dimensional voltage/temperature report](../../Measurement_Results/IC_Simulation/BIAS/BIAS_dc2d_report.csv)
- [Worst-case table](../../Measurement_Results/IC_Simulation/BIAS/BIAS_global_worst_case.csv)
- [Reference report](../../Measurement_Results/IC_Simulation/BIAS/BIAS_reference_report.csv)
- [Startup report](../../Measurement_Results/IC_Simulation/BIAS/BIAS_startup_report.csv)
- [Startup summary](../../Measurement_Results/IC_Simulation/BIAS/BIAS_startup_summary.csv)
- [Selector report](../../Measurement_Results/IC_Simulation/BIAS/BIAS_sel_report.csv)

## Scope limitation

These results are schematic-level simulations. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
