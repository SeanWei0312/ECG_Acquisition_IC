# INA + RLD Design and Verification Report

[← Project report](../../Project_Report.md)

## Circuit and role

The INA provides nominal gain of 240 V/V. RLD senses common mode and drives the body model through the safety network.

[Circuit schematic](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/INA/INA.sch)

![INA](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/INA/INA.png)

## Design requirements and sequence

The INA must amplify a differential ECG input while rejecting electrode common mode. The gain target is 240 V/V. The retained limits include ±0.5% total gain error, input-referred noise ≤4 µVrms, THD ≤0.05%, and input range extending to at least ±5 mV.

RLD is designed with the INA, because common-mode suppression depends on the complete electrode/body feedback path. Its required phase margin is ≥60°, with suppression ≥35 dB at 60 Hz and ≥25 dB at 150 Hz.

This sequence reconstructs the circuit choices from the schematic. First-order resistor calculations are starting points; the implemented dimensions include device-model and circuit corrections.

### 1. Split gain between a high-impedance input stage and a differential stage

Two SEOTAs provide the input stage. One FDOTA converts their differential outputs to the final differential signal. The gain allocation is

$$
G_1=60,\qquad G_2=4,\qquad G_{\mathrm{INA}}=G_1G_2=240.
$$

For the symmetric first stage and second-stage resistor network,

$$
G_1=1+\frac{2R_{\mathrm{SEF}}}{R_{\mathrm{SEG}}},
\qquad
G_2=\frac{R_{\mathrm{FDFB}}}{R_{\mathrm{FDIN}}}.
$$

This is the standard three-amplifier gain decomposition. Large first-stage gain reduces the input-referred contribution of later stages, but also reduces first-stage bandwidth and usable input range. [TI three-amplifier INA theory](https://www.ti.com/video/6216438746001)

### 2. Choose resistance levels, then calculate ratios and lengths

Start with \(R_{\mathrm{SEG}}\approx4\) kΩ and \(R_{\mathrm{FDIN}}\approx10\) kΩ. These avoid excessively low feedback resistances while keeping the short gain-setting elements practical.

$$
R_{\mathrm{SEF,calc}}
=\frac{60-1}{2}(4\ \mathrm{k\Omega})
=118\ \mathrm{k\Omega},
$$

$$
R_{\mathrm{FDFB,calc}}
=4(10\ \mathrm{k\Omega})=40\ \mathrm{k\Omega}.
$$

For a first rectangle estimate, \(R\approx R_\square L/W\), with \(R_\square=2\) kΩ/square. Select W = 4 µm for all INA resistors so matched branches share width and model corrections.

| Components, symmetric pairs grouped | Target R | Calculated L at W = 4 µm | Nearest integer L | Implemented W/L |
| :--- | :--- | :--- | :--- | :--- |
| RSEG | 4 kΩ | 8 µm | 8 µm | 4/8 µm |
| RSEFP/RSEFN | 118 kΩ | 236 µm | 236 µm | 4/242.88 µm |
| RFDINP/RFDINN | 10 kΩ | 20 µm | 20 µm | 4/20 µm |
| RFDFBP/RFDFBN | 40 kΩ | 80 µm | 80 µm | 4/80.68 µm |

Length sets resistance; width provides matching area and a common geometry basis. Increasing both dimensions at fixed L/W improves area-based matching, but increases parasitic capacitance. Lower resistance reduces thermal noise at the cost of amplifier loading.

### 3. Account for model corrections before accepting the gain

The final lengths must not be justified by the drawn L/W ratios alone. Those ratios predict \(G_1=61.72\), \(G_2=4.034\), and total gain 248.98 V/V—not the target.

The installed typical poly model instead includes effective dimensions and two end resistances:

$$
R\approx
\frac{R_\square F_b(T)(L+0.1864\ \mu\mathrm m)
+2(33.16\ \Omega\cdot\mu\mathrm m)F_t(T)}
{W-0.04512\ \mu\mathrm m}.
$$

At 27°C, \(F_b\approx0.996675\) and \(F_t\approx0.992513\). A compact evaluation gives approximately 4.143 kΩ, 122.528 kΩ, 10.191 kΩ, and 40.775 kΩ for the four groups above.

These values predict gains of about 60.15 and 4.001, or 240.67 V/V overall. Simulation gives 60.001, 4.000, and 240.027 V/V. The approximately 0.27% total difference is the residual of a reduced model, not a reason to alter the acceptance limits.

Finite amplifier gain and the complete resistor subcircuits must remain in final verification. The current exports do not isolate the individual contributions to that residual. [GF180 resistor model structure](https://gf180mcu-pdk.readthedocs.io/en/latest/analog/model_parameters/LV/LV_4.html)

### 4. Reuse amplifier sizes according to their circuit roles

The input SEOTAs supply high input impedance and low front-end noise. Their input-pair width, bias current, and compensation are justified in the [SEOTA design report](../ANALOG_BLOCKS/SEOTA_Report.md).

The FDOTA supplies differential output gain and common-mode regulation. Its transistor, compensation-resistor, and compensation-capacitor dimensions are justified in the [FDOTA design report](../ANALOG_BLOCKS/FDOTA_Report.md). They are not independently re-sized inside INA.

For a simplified two-stage noise budget,

$$
e_{\mathrm{RTI}}^2
\approx e_1^2+\frac{e_2^2}{G_1^2}.
$$

The actual budget also includes both input amplifiers, all feedback resistors, and correlations imposed by the circuit. The measured integrated input noise is 2.677 µVrms nominal and 3.107 µVrms worst PVT, below 4 µVrms.

### 5. Set the RLD common-mode gain before selecting its capacitor

The RLD averages the two input-stage outputs through equal resistors. Its feedback is \(R_F\parallel C_F\), giving

$$
v_{\mathrm{RLD}}-V_{\mathrm{REF}}
\approx-\frac{2R_F/R_{\mathrm{IN}}}{1+sR_FC_F}
(v_{\mathrm{CM}}-V_{\mathrm{REF}}).
$$

Choose \(R_{\mathrm{IN}}\approx4\) MΩ per branch and \(R_F\approx10\) MΩ. Equal common-mode inputs then produce low-frequency gain magnitude \(2R_F/R_{\mathrm{IN}}=5\).

A feedback pole near 200 Hz begins reducing loop gain before additional electrode/body and amplifier phase lag becomes dominant. Thus

$$
C_{F,\mathrm{calc}}
=\frac{1}{2\pi(10\ \mathrm{M\Omega})(200\ \mathrm{Hz})}
=79.6\ \mathrm{pF}.
$$

| Components | Calculated size | Rounded choice | Implemented dimensions |
| :--- | :--- | :--- | :--- |
| RRLDP/RRLDN | W = 2 µm; L = 4000 µm for 4 MΩ | L = 4000 µm | W/L = 2/4000 µm |
| RRLDF1 | W = 2 µm; L = 10000 µm for 10 MΩ | L = 10000 µm | W/L = 2/10000 µm |
| CRLDF | 79.6 pF; 39800 µm² at 2 fF/µm² | 80 pF total | Four 100 × 100 µm MIM units |

The large input resistors reduce loading of the INA outputs. Narrow W limits the area needed for megaohm values, but increases matching and parasitic sensitivity. The long resistor shapes require segmented layout and parasitic verification.

The 100-µm square capacitor units give a regular matching geometry. Increasing C improves high-frequency roll-off but reduces mains-frequency loop gain; decreasing C risks insufficient phase margin.

RLD suppression depends on the complete body/electrode loop, not only on this gain-five controller. [TI right-leg-drive analysis](https://www.ti.com/lit/an/sbaa188/sbaa188.pdf)

### 6. Compare the controller estimate with the complete simulation

The model-corrected feedback resistance is approximately 10.197 MΩ. With 80 pF, the controller pole estimate is 195.1 Hz. The reported RLD bandwidth is 182.771 Hz nominal; the complete loop and parasitics explain why the single-RC estimate is not an exact bandwidth prediction.

Simulation gives RLD gain 4.999 V/V, phase margin 64.006° nominal and 62.118° worst PVT. Suppression is 37.121 dB worst at 60 Hz and 27.309 dB worst at 150 Hz. These complete-loop results validate the selected gain/roll-off combination under the tested body model.

The RLD schematic is shown below. Electrical patient-safety certification is not established by these simulations.

![RLD circuit schematic](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/RLD/RLD.png)

## Verification conditions

Checked 2026-10-17 against the latest analyzer CSV exports. No simulations were rerun for this documentation update.

Blank specification cells mean report-only. Exported worst-case values meet their listed limits; this is pre-layout block verification, not post-layout or silicon signoff.

Very large deterministic CMRR/PSRR values reflect schematic symmetry and numerical cancellation. Use mismatch results to assess imbalance sensitivity; neither dataset guarantees extracted-layout or silicon rejection.

The PVT campaign uses NOM/FF/SS/FS/SF, 3.0/3.3/3.6 V, and −40/27/125°C: 45 operating conditions.

Nominal columns refer to NOM process, 3.3 V, and 27°C. Compact corner names encode process, supply, and temperature. Sweep labels identify a fixed supply or temperature rather than a single corner.

VTC ranges use the analyzer’s 1% linearity criterion. A tested boundary without a crossing is a bound, not an exact compression point. THD is checked at 60 Hz against 0.05%; stimulus amplitudes are retained in the metric names.

## Nominal and full-PVT results

### Operating point

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤6.2 | 3.862 | 4.815 | FFVHTH |
| Total power | mW |  | 12.745 | 17.333 | FFVHTH |
| Output CM error | mV | ±20 | -0.132 | 12.617 | SSVHTH |

### Accuracy and usable range

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Input-referred offset | uV | ±2500 | 0 | 0.001 | FFVHTH |
| S1 gain error | % | ±0.5 | 0.001 | -0.068 | SSVLTL |
| S2 gain error | % | ±0.25 | 0.01 | 0.029 | FFVHTH |
| INA gain error | % | ±0.5 | 0.011 | -0.077 | SSVLTL |
| Input range low | mV | ≤-5 | -12.8 | -11.2 | FSVLTH |
| Input range high | mV | ≥5 | 12.8 | 11.2 | SSVLTH |
| Output range low | V | ≤-1.2 | -3.071 | -2.687 | SSVLTH |
| Output range high | V | ≥1.2 | 3.071 | 2.687 | SSVLTH |

Input range high: nominal 12.8 mV; full-PVT worst 11.2 mV at `SSVLTH`.

![NOM.INA RLD vtc](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_vtc.png)

### Frequency response

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| S1 gain | V/V |  | 60.001 | 59.959 | SSVLTL |
| S1 gain dB | dB |  | 35.563 | 35.557 | SSVLTL |
| S1 -3 dB bandwidth | kHz |  | 261.876 | 209.064 | SSVLTH |
| S2 gain | V/V |  | 4 | 4.001 | FFVHTH |
| S2 gain dB | dB |  | 12.042 | 12.044 | FFVHTH |
| S2 -3 dB bandwidth | MHz |  | 2.617 | 2.125 | SSVLTH |
| INA gain | V/V |  | 240.027 | 239.815 | SSVLTL |
| INA gain dB | dB |  | 47.605 | 47.598 | SSVLTL |
| Gain flatness 0.05-150 Hz | dB | ≤0.1 | 1.432e-06 | 2.246e-06 | SSVLTH |
| INA -3 dB bandwidth | kHz |  | 259.251 | 207.051 | SSVLTH |

S1 gain: nominal 60.001 V/V; full-PVT worst 59.959 V/V at `SSVLTL`.

![NOM.INA RLD differential ac](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_differential_ac.png)

### Common-mode and supply rejection

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| INA CMRR @ 60 Hz | dB | ≥80 | 227.801 | 214.902 | NOMVLTH |
| INA CMRR @ 150 Hz | dB | ≥80 | 227.965 | 214.928 | NOMVLTH |
| INA PSRR+ @ 60 Hz | dB | ≥80 | 196.681 | 185.964 | SSVHTH |
| INA PSRR+ @ 150 Hz | dB | ≥80 | 196.681 | 185.964 | SSVHTH |
| INA PSRR- @ 60 Hz | dB | ≥80 | 224.205 | 206.506 | SSVLTH |
| INA PSRR- @ 150 Hz | dB | ≥80 | 224.068 | 206.492 | SSVLTH |

INA CMRR @ 60 Hz: nominal 227.801 dB; full-PVT worst 214.902 dB at `NOMVLTH`.

![NOM.INA RLD rejection response](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_rejection_response.png)

### Noise and distortion

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Input-referred noise 0.05-150 Hz | uVrms | ≤4 | 2.677 | 3.107 | SSVLTH |
| THD @ 60 Hz, 5 mVpp | % | ≤0.05 | 9.267e-05 | 1.025e-04 | SFVLTH |

Input-referred noise 0.05-150 Hz: nominal 2.677 uVrms; full-PVT worst 3.107 uVrms at `SSVLTH`.

![NOM.INA RLD noise](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_noise.png)

### RLD stability and interference rejection

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| RTI residual - BAL | uVpp | ≤1000 | 0.003 | 0.004 | SFVHTH |
| RTI residual - MIS-P | uVpp | ≤1000 | 8.519 | 9.247 | SSVLTL |
| RTI residual - MIS-N | uVpp | ≤1000 | 8.519 | 9.247 | SSVLTL |
| RTI residual - MIS-RLD | uVpp | ≤1000 | 0.003 | 0.004 | SFVHTH |
| RLD gain | V/V |  | 4.999 | 4.999 | FSVLTH |
| RLD -3 dB bandwidth | Hz |  | 182.771 | 163.955 | SSVLTL |
| RLD phase margin | deg | ≥60 | 64.006 | 62.118 | SSVLTH |
| Input CM suppression @ 60 Hz | dB | ≥35 | 37.231 | 37.121 | SSVLTL |
| Input CM suppression @ 150 Hz | dB | ≥25 | 27.735 | 27.309 | SSVLTL |

RLD phase margin: nominal 64.006 deg; full-PVT worst 62.118 deg at `SSVLTH`.

![NOM.INA RLD loop gain](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_loop_gain.png)

Input CM suppression @ 60 Hz: nominal 37.231 dB; full-PVT worst 37.121 dB at `SSVLTL`.

![NOM.INA RLD cm rejection](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_cm_rejection.png)

### Functional checks

Nominal functional trace; selector or gain-control behavior is separate from static gain accuracy.

![NOM.INA RLD sel functional check](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/NOM.INA_RLD_sel_functional_check.png)

## Monte Carlo verification

MM applies local mismatch; GL applies global variation; FULL combines both. These are nominal-supply/temperature MC campaigns, not combined worst-PVT-plus-mismatch yield.

| Mode | Requested | Valid | Failed | Overall yield |
| :--- | :--- | :--- | :--- | :--- |
| MM | 200 | 200 | 0 | 100% |
| GL | 200 | 200 | 0 | 100% |
| FULL | 200 | 200 | 0 | 100% |

Counts and yield apply to the measured MC metrics at nominal supply and temperature. Missing or invalid results prevent a pass; they are not demonstrated circuit failures. Sample yield is not production yield.

### FULL sampled statistics

| Parameter | Unit | Spec | Min | Mean | Max | Yield |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Total current | mA | ≤6.2 | 3.651 | 3.868 | 4.15 | 100% |
| Total power | mW |  | 12.049 | 12.766 | 13.695 |  |
| Output CM error | mV | ±20 | -11.406 | -0.036 | 12.663 | 100% |
| Input-referred offset | uV | ±2500 | -1757.36 | -5.782 | 2412.76 | 100% |
| S1 gain | V/V |  | 59.824 | 59.998 | 60.14 |  |
| S1 gain error | % | ±0.5 | -0.293 | -0.003 | 0.233 | 100% |
| S2 gain | V/V |  | 3.997 | 4 | 4.004 |  |
| S2 gain error | % | ±0.25 | -0.086 | 0.009 | 0.088 | 100% |
| INA gain | V/V |  | 239.092 | 240.014 | 240.772 |  |
| INA gain error | % | ±0.5 | -0.378 | 0.006 | 0.322 | 100% |
| INA CMRR @ 60 Hz | dB | ≥80 | 96.784 | 110.7 | 139.705 | 100% |
| INA CMRR @ 150 Hz | dB | ≥80 | 96.784 | 110.626 | 138.874 | 100% |
| RLD -3 dB bandwidth | Hz |  | 160.929 | 183.614 | 207.221 |  |
| RLD phase margin | deg | ≥60 | 62.028 | 63.968 | 66.135 | 100% |
| Input CM suppression @ 60 Hz | dB | ≥35 | 37.11 | 37.23 | 37.322 | 100% |
| Input CM suppression @ 150 Hz | dB | ≥25 | 27.232 | 27.733 | 28.148 | 100% |

The source CSVs retain μ±σ and μ±3σ. Those statistical extrapolations are not additional simulated extrema.

FULL Input-referred offset: -1757.36 to 2412.76 uV; mean -5.782 uV.

![Fig MC 01 Vos Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/Fig_MC_01_Vos_Histogram.png)

FULL S1 gain error: -0.293 to 0.233 %; mean -0.003 %.

![Fig MC 02 INA Gain Error Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/Fig_MC_02_INA_Gain_Error_Histogram.png)

FULL RLD -3 dB bandwidth: 160.929 to 207.221 Hz; mean 183.614 Hz.

![Fig MC 03 RLD Bandwidth Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/Fig_MC_03_RLD_Bandwidth_Histogram.png)

FULL RLD phase margin: 62.028 to 66.135 deg; mean 63.968 deg.

![Fig MC 04 RLD PM Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/Fig_MC_04_RLD_PM_Histogram.png)

FULL INA CMRR @ 60 Hz: 96.784 to 139.705 dB; mean 110.7 dB.

![Fig MC 05 INA CMRR Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/Fig_MC_05_INA_CMRR_Histogram.png)

FULL S1 gain: 59.824 to 60.14 V/V; mean 59.998 V/V.

![Fig MC 06 Input CM Suppression Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Plots/Fig_MC_06_Input_CM_Suppression_Histogram.png)

## Measurement sources

- [MATLAB analyzer](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/INA_RLD_Analyze.m)
- [Representative-corner comparison](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Reports/INA_RLD_table_report.csv)
- [Full-PVT worst cases](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Reports/INA_RLD_worst_case_report.csv)
- [All exported PVT measurements](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Reports/INA_RLD_full_pvt_report.csv)
- [MM statistics](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Reports/MM_MC_Summary.csv)
- [GL statistics](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Reports/GL_MC_Summary.csv)
- [FULL statistics](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Reports/FULL_MC_Summary.csv)
- [MC coverage and yield](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/INA_RLD/Reports/MC_Run_Summary.csv)
- [Xschem testbenches](../../Design_Files/IC%20Design/Testbench/AFE_BLOCKS/INA_RLD)

## Limitations and next steps

These results exclude extracted parasitics, package effects, switched-ADC loading, and silicon measurements. Repeat the same limits after layout; do not infer integrated AFE signoff from individual block passes.
