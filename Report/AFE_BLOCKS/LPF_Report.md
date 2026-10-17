# LPF Design and Verification Report

[← Project report](../../Project_Report.md)

## Circuit and role

The unity-gain differential LPF preserves the ECG passband through 150 Hz. Its −1 dB frequency is the passband acceptance metric.

[Circuit schematic](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/LPF/LPF.sch)

![LPF](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/LPF/LPF.png)

## Design requirements and sequence

The LPF must retain unity differential gain while limiting attenuation through 150 Hz. Its frequency requirement is \(f_{-1\mathrm{dB}}\ge150\) Hz. Gain error is limited to ±0.5%; THD remains ≤0.05%.

The implemented circuit is a first-order active low-pass stage, not a higher-order Butterworth filter. The following calculations reconstruct its passive sizing from the actual schematic.

### 1. Use equal input and feedback resistances for unity gain

Each FDOTA feedback branch contains a resistor in parallel with a capacitor. For matched branches and an ideal amplifier,

$$
H_d(s)\approx\frac{R_F/R_{\mathrm{IN}}}{1+sR_FC_F}.
$$

Choose \(R_F=R_{\mathrm{IN}}\). This sets the low-frequency gain magnitude to one while preserving differential symmetry. The cross-connected output labels determine the positive differential transfer reported by the analyzer. [TI fully differential feedback analysis](https://www.ti.com/lit/pdf/SLOA054)

### 2. Convert the passband requirement into a pole target

For a first-order low-pass response,

$$
|H(f)|=\frac{1}{\sqrt{1+(f/f_p)^2}},
\qquad
f_{-1\mathrm{dB}}=f_p\sqrt{10^{0.1}-1}=0.50885f_p.
$$

The 150-Hz acceptance boundary therefore requires

$$
f_p\ge\frac{150}{0.50885}=294.8\ \mathrm{Hz}.
$$

A nominal pole near 500 Hz provides margin for RC variation. Its expected −1 dB frequency is 254.4 Hz, close to the simulated nominal 258.688 Hz. This nominal target is reconstructed from the implemented network; it is not an additional specification.

### 3. Allocate capacitance, then calculate resistance

Use approximately 60 pF per feedback branch. At a 500-Hz pole,

$$
R_{F,\mathrm{calc}}
=\frac{1}{2\pi(500)(60\ \mathrm{pF})}
=5.305\ \mathrm{M\Omega}.
$$

Using the 2-kΩ/square poly resistor, a first-order 5-MΩ rectangle at W = 1 µm requires L = 2500 µm. Its corrected PDK resistance is about 5.219 MΩ at 27°C.

Consequently,

$$
f_{p,\mathrm{model}}
\approx\frac{1}{2\pi(5.219\ \mathrm{M\Omega})(60\ \mathrm{pF})}
=508.2\ \mathrm{Hz}.
$$

The resulting design is close to the 500-Hz starting target. Exact geometry and terminal terms matter more than rounding a nominal resistance to a preferred value. [GF180 resistor models](https://gf180mcu-pdk.readthedocs.io/en/latest/analog/model_parameters/LV/LV_4.html)

### 4. Convert resistance and capacitance into implemented dimensions

| Components | Calculation | Rounded starting size | Implemented size |
| :--- | :--- | :--- | :--- |
| RINP/RINN | Same R as feedback for unity gain | W/L = 1/2500 µm | W/L = 1/2500 µm |
| RFBP/RFBN | 5 MΩ × 1 µm / 2 kΩ | L = 2500 µm | W/L = 1/2500 µm |
| CLPFP/CLPFN | 60 pF / (2 fF/µm²) = 30000 µm² total | Four 7500-µm² units | W/L = 75/100 µm, m = 4 per branch |

The strict 500-Hz/60-pF resistance calculation would give a raw sheet-resistance length of 2653 µm. The implemented 2500 µm is justified by the model-corrected RC result, not by claiming the uncorrected rectangle is exact.

The 1-µm resistor width limits the area of a multi-megaohm element. Increasing width at constant resistance requires proportional length and greater substrate capacitance. Decreasing resistance reduces thermal-noise voltage but requires a larger feedback capacitor for the same pole.

Each capacitor uses a 75 × 100 µm unit. Four equal units supply the required area without introducing a new capacitor ratio. Both sides use the same geometry and multiplicity to control differential imbalance. MIM device conventions follow the [GF180 capacitor models](https://gf180mcu-pdk.readthedocs.io/en/latest/analog/model_parameters/LV/LV_7.html).

### 5. Verify amplifier loading, noise, and linearity

The stage reuses the FDOTA without changing its internal transistor sizes or Miller compensation. Those sizes are explained in the [FDOTA report](../ANALOG_BLOCKS/FDOTA_Report.md).

Large feedback resistors avoid heavy resistive loading. Their thermal noise and substrate capacitance remain important; a single-resistor density is \(\sqrt{4kTR}\), but total input-referred noise requires the complete transfer from every noise source.

The nominal integrated input noise is 6.173 µVrms and is report-only. THD is 0.004% nominal and 0.006% worst PVT under the specified 60-Hz test. These measurements support linear operation; they do not prove that resistance or capacitor area is globally optimal.

### 6. Close the calculation with the simulated response

The model-based pole estimate is 508.2 Hz; simulation gives \(f_{-3\mathrm{dB}}=506.908\) Hz, about 0.26% lower. The first-order −1 dB estimate is 258.6 Hz, consistent with the measured 258.688 Hz.

At 150 Hz, the same model predicts approximately 0.36 dB attenuation. Simulation gives 0.361 dB nominal and 0.762 dB worst PVT.

The worst measured −1 dB frequency is 174.134 Hz, above the 150-Hz limit. RC variation therefore consumes a meaningful part of the nominal margin. Keep the frequency requirement unchanged for extracted-layout verification.

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
| FDC bias current | uA | 40±10 | 40.113 | 49.606 | FFVHTH |
| CMFB bias current | uA | 40±10 | 40.113 | 49.606 | FFVHTH |
| Total current | mA | ≤2.5 | 1.605 | 2.196 | FFVHTH |
| Total power | mW |  | 5.296 | 7.904 | FFVHTH |
| Output CM error | mV | ±20 | -0.132 | 11.997 | SSVHTH |

### Accuracy and usable range

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| LPF input offset | mV | ±6 | 0 | 0 | FFNOMTH |
| Passband gain error | % | ±0.5 | -0.024 | -0.048 | SSVLTL |
| Input range low | V | ≤-1.2 | -3.158 | -2.798 | FSVLTH |
| Input range high | V | ≥1.2 | 3.158 | 2.798 | FSVLTH |
| Output range low | V | ≤-1.2 | -3.157 | -2.797 | FSVLTH |
| Output range high | V | ≥1.2 | 3.157 | 2.797 | FSVLTH |

Input range high: nominal 3.158 V; full-PVT worst 2.798 V at `FSVLTH`.

![NOM.LPF vtc](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/NOM.LPF_vtc.png)

### Frequency response

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Passband gain | V/V |  | 1 | 1 | SSVLTL |
| Loss @ 150 Hz | dB |  | 0.361 | 0.762 | SSVHTL |
| LPF -1 dB frequency | Hz | ≥150 | 258.688 | 174.134 | SSVHTL |
| LPF -3 dB frequency | Hz |  | 506.908 | 340.983 | SSVHTL |

LPF -1 dB frequency: nominal 258.688 Hz; full-PVT worst 174.134 Hz at `SSVHTL`.

![NOM.LPF differential ac](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/NOM.LPF_differential_ac.png)

### Common-mode and supply rejection

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| CMRR @ 60 Hz | dB | ≥80 | 246.296 | 215 | FFVLTH |
| CMRR @ 150 Hz | dB | ≥80 | 246.284 | 214.997 | FFVLTH |
| PSRR+ @ 60 Hz | dB | ≥80 | 191.531 | 184.861 | SSNOMTL |
| PSRR+ @ 150 Hz | dB | ≥80 | 260.999 | 184.686 | SSNOMTL |
| PSRR- @ 60 Hz | dB | ≥80 | 236.995 | 205.247 | FFVLTH |
| PSRR- @ 150 Hz | dB | ≥80 | 237.817 | 205.217 | FFVLTH |

CMRR @ 60 Hz: nominal 246.296 dB; full-PVT worst 215 dB at `FFVLTH`.

![LPF PVT CMRR AC](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/LPF_PVT_CMRR_AC.png)

### Noise and distortion

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Input-referred noise 0.05-150 Hz | uVrms |  | 6.173 | 7.033 | SSVHTH |
| THD @ 60 Hz, 1.2 Vpp | % | ≤0.05 | 0.004 | 0.006 | SSVHTL |

Input-referred noise 0.05-150 Hz: nominal 6.173 uVrms; full-PVT worst 7.033 uVrms at `SSVHTH`.

![NOM.LPF noise](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/NOM.LPF_noise.png)

### Functional checks

Nominal functional trace; selector or gain-control behavior is separate from static gain accuracy.

![NOM.LPF SEL functional check](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/NOM.LPF_SEL_functional_check.png)

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
| FDC bias current | uA | 40±10 | 38.54 | 40.127 | 41.844 | 100% |
| CMFB bias current | uA | 40±10 | 38.552 | 40.121 | 41.793 | 100% |
| Total current | mA | ≤2.5 | 1.523 | 1.608 | 1.695 | 100% |
| Total power | mW |  | 5.026 | 5.308 | 5.593 |  |
| Output CM error | mV | ±20 | -11.911 | -0.194 | 14.858 | 100% |
| LPF input offset | mV | ±6 | -4.611 | -0.091 | 5.066 | 100% |
| Passband gain | V/V |  | 1 | 1 | 1 |  |
| Passband gain error | % | ±0.5 | -0.031 | -0.025 | -0.02 | 100% |
| LPF -1 dB frequency | Hz | ≥150 | 224.387 | 259.343 | 297.067 | 100% |
| LPF -3 dB frequency | Hz |  | 439.604 | 508.181 | 582.181 |  |
| CMRR @ 60 Hz | dB | ≥80 | 91.179 | 107.885 | 154.616 | 100% |
| CMRR @ 150 Hz | dB | ≥80 | 91.169 | 107.835 | 154.675 | 100% |

The source CSVs retain μ±σ and μ±3σ. Those statistical extrapolations are not additional simulated extrema.

FULL Passband gain: 1 to 1 V/V; mean 1 V/V.

![Fig MC 01 LPF 1dB Frequency Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/Fig_MC_01_LPF_1dB_Frequency_Histogram.png)

FULL LPF input offset: -4.611 to 5.066 mV; mean -0.091 mV.

![Fig MC 02 Input Offset Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/Fig_MC_02_Input_Offset_Histogram.png)

FULL CMRR @ 60 Hz: 91.179 to 154.616 dB; mean 107.885 dB.

![Fig MC 03 CMRR Histogram](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Plots/Fig_MC_03_CMRR_Histogram.png)

## Measurement sources

- [MATLAB analyzer](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/LPF_Analyze.m)
- [Representative-corner comparison](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Reports/LPF_table_report.csv)
- [Full-PVT worst cases](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Reports/LPF_worst_case_report.csv)
- [All exported PVT measurements](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Reports/LPF_full_pvt_report.csv)
- [MM statistics](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Reports/MM_MC_Summary.csv)
- [GL statistics](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Reports/GL_MC_Summary.csv)
- [FULL statistics](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Reports/FULL_MC_Summary.csv)
- [MC coverage and yield](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/LPF/Reports/MC_Run_Summary.csv)
- [Xschem testbenches](../../Design_Files/IC%20Design/Testbench/AFE_BLOCKS/LPF)

## Limitations and next steps

These results exclude extracted parasitics, package effects, switched-ADC loading, and silicon measurements. Repeat the same limits after layout; do not infer integrated AFE signoff from individual block passes.
