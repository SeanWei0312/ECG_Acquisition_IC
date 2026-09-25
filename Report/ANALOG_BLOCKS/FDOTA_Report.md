# FDOTA Design and Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Result |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45/45 PVT corners pass |
| Statistical coverage | MM, GL, and FULL: 200/200 valid runs each |
| Overall status | **Pass** |

## 1. Architecture

The FDOTA separates differential amplification from output common-mode regulation.

- **FDC:** a symmetric two-stage differential signal path with one compensation branch per output.
- **CMFB amplifier:** compares the sensed output common mode with `REF` and drives `VCMFB`.
- **Output sensor:** matched resistors average `OUTP` and `OUTN`; matched capacitors preserve high-frequency symmetry.

Schematic sources: [FDOTA](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.sch>), [FDC](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDC/FDC.sch>), and [CMFB](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/CMFB/CMFB.sch>).

The top-level schematic shows the FDC, output common-mode sensor, and CMFB loop as one closed system.

![FDOTA top-level circuit schematic](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDOTA/FDOTA.png>)

## 2. $g_m/I_D$ design basis

The design uses simulator-generated lookup tables. The core sizing relations are

$$
g_m=\left(\frac{g_m}{I_D}\right)I_D,
\qquad
J_D=\frac{I_D}{W_{eff}},
\qquad
W_{eff}=\frac{I_D}{J_D},
\qquad
A_{v,int}=\frac{g_m}{g_{ds}}.
$$

The sizing flow is short:

1. Derive the required transconductance and current from gain, bandwidth, noise, load, and slew targets.
2. Select channel length and $g_m/I_D$ from current-density, intrinsic-gain, and speed data.
3. Calculate width from $W_{eff}=I_D/J_D$ and preserve matched geometry.
4. Close the differential and CMFB loops with AC, transient, PVT, and Monte Carlo verification.

The local 180-nm tables use `nfet_03v3` and `pfet_03v3` devices at a 1.65-V drain-to-source magnitude. Representative values at $g_m/I_D=10\ \text{V}^{-1}$ are:

| $L$ (µm) | NMOS $I_D/W$ (µA/µm) | NMOS $g_m/g_{ds}$ (dB) | NMOS $(g_m/I_D)f_T$ (GHz/V) | PMOS $I_D/W$ (µA/µm) | PMOS $g_m/g_{ds}$ (dB) | PMOS $(g_m/I_D)f_T$ (GHz/V) |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0.5 | 4.381 | 44.80 | 54.34 | 1.265 | 48.34 | 12.62 |
| 1.0 | 2.257 | 51.75 | 13.75 | 0.5309 | 56.26 | 2.668 |
| 2.0 | 1.055 | 55.27 | 3.067 | 0.2390 | 61.99 | 0.6172 |
| 4.0 | 0.4959 | 58.41 | 0.7020 | 0.1128 | 67.40 | 0.1501 |

At $g_m/I_D=10\ \text{V}^{-1}$, NMOS current density falls from 4.381 to 0.4959 µA/µm as length increases from 0.5 to 4 µm.

![NMOS current density versus gm/ID](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_current_density_vs_gmid.png)

Over the same length change, NMOS intrinsic gain rises from 44.80 to 58.41 dB.

![NMOS intrinsic gain versus gm/ID](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_intrinsic_gain_db_vs_gmid.png)

At $g_m/I_D=10\ \text{V}^{-1}$, PMOS current density falls from 1.265 to 0.1128 µA/µm as length increases from 0.5 to 4 µm.

![PMOS current density versus gm/ID](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_current_density_vs_gmid.png)

PMOS intrinsic gain rises from 48.34 to 67.40 dB over the same length range.

![PMOS intrinsic gain versus gm/ID](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_intrinsic_gain_db_vs_gmid.png)

These tables guide sizing; they do not replace final-hierarchy operating-point data. Exact device $g_m/I_D$ depends on its in-circuit terminal and body voltages.

## 3. Fully differential core

The FDC schematic shows the symmetric signal paths and the matched compensation networks.

![FDC circuit schematic](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/FDC/FDC.png>)

### 3.1 Device sizing

`W_eff` is $W\times m$ because the listed devices use `nf=1`.

| Function | Devices | Type | $L$ (µm) | $W$ (µm) | $m$ | $W_{eff}$ (µm) |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| Input pair | M1, M2 | NMOS | 2.0 | 100 | 2 | 200 |
| CMFB-controlled load | M3, M4 | PMOS | 2.0 | 50 | 4 | 200 |
| Tail source | M5 | NMOS | 2.0 | 10 | 1 | 10 |
| Bias reference | M10 | NMOS | 2.0 | 20 | 1 | 20 |
| Output pull-ups | M6, M7 | PMOS | 0.5 | 50 | 10 | 500 |
| Output pull-downs | M8, M9 | NMOS | 0.5 | 100 | 1 | 100 |

The 2-µm input and load devices favor efficiency, gain, and matching. The 0.5-µm output devices favor current density, speed, and 10-pF load drive.

Each output uses approximately 2.50 pF of Miller compensation in series with 3.5 kΩ. The matched branches preserve differential symmetry.

Using the 40.092-µA nominal bias and mirror ratios gives this first-order interpretation:

| Device group | Estimated branch current | Estimated $J_D$ | Interpretation |
| :--- | ---: | ---: | :--- |
| M1/M2 | 10 µA | 0.050 µA/µm | Very high transconductance efficiency |
| M3/M4 | 10 µA | 0.050 µA/µm | Approximately $g_m/I_D=16$–17 V⁻¹ at the lookup bias |
| M6–M9 | Circuit dependent | — | Short-channel devices selected for output drive |

The mirror-current values are estimates. The M1/M2 density is below the printed $g_m/I_D=20\ \text{V}^{-1}$ lookup point, so no exact inversion level is claimed without saved device operating points.

### 3.2 Nominal block verification

| Metric | Nominal result |
| :--- | ---: |
| Total current | 1.400 mA |
| Total power | 4.622 mW |
| Differential gain | 93.377 dB |
| Differential UGF | 14.571 MHz |
| Phase margin | 77.084° |
| Input noise, 1–150 Hz | 2.439 µVrms |
| Required `VCMFB` | 2.483 V |
| Common-mode plant gain | 762.583 V/V |

The isolated FDC achieves 93.377 dB gain, 14.571 MHz UGF, and 77.084° phase margin.

![FDC differential gain and phase](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.diff_ac.png)

The input offset is below reporting resolution.

![FDC input-offset extraction](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.offset.png)

Integrated input noise is 2.439 µVrms from 1 to 150 Hz.

![FDC input-referred noise](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.noise.png)

The common-mode plant gain is 762.583 V/V.

![FDC common-mode plant AC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.plant_ac.png)

The nominal operating point requires `VCMFB = 2.483 V` for a 1.650-V output common mode.

![FDC common-mode plant DC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.plant_dc.png)

The `VCMFB` sweep confirms the control polarity and the 2.483-V nominal control point.

![FDC VCMFB sweep](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.vcmfb_sweep.png)

With CMFB open, a differential step creates a 2.383-V common-mode excursion. The integrated closed-loop FDOTA reduces it to 37.043 mV.

![FDC differential-step common-mode disturbance](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/Plots/NOM.diff_step_cm_disturbance.png)

## 4. Common-mode feedback block

The CMFB schematic shows the error amplifier that converts sensed common-mode error into the `VCMFB` control voltage.

![CMFB circuit schematic](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/FDOTA/CMFB/CMFB.png>)

### 4.1 Error-amplifier and sensor sizing

| Function | Devices | Type | $L$ (µm) | $W$ (µm) | $m$ | $W_{eff}$ (µm) |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| Input pair | M1, M2 | NMOS | 1.0 | 15 | 1 | 15 |
| Active load | M3, M4 | PMOS | 1.0 | 41.1 | 5 | 205.5 |
| Tail source | M5 | NMOS | 2.0 | 20 | 1 | 20 |
| Bias reference | M10 | NMOS | 2.0 | 20 | 1 | 20 |

The 1-µm signal devices trade some intrinsic gain for loop speed. A first-order 20-µA branch estimate gives 1.33 µA/µm for M1/M2 and 0.0973 µA/µm for M3/M4, corresponding approximately to $g_m/I_D=12$–13 and 17 V⁻¹ at the lookup bias.

The output sensor uses two approximately 100-kΩ resistors and two approximately 50-fF capacitors. Matching prevents differential output signal from becoming a false common-mode error.

### 4.2 Nominal block verification

| Metric | Nominal result |
| :--- | ---: |
| Total current | 39.824 µA |
| Total power | 0.131 mW |
| DC gain | 45.137 dB |
| UGF | 967.213 MHz |
| Phase margin | 71.900° |
| Valid reference range | 1.05–3.01 V |
| Closed-loop settling | 5.2 ns |

The CMFB amplifier provides 45.137 dB gain, 967.213 MHz UGF, and 71.900° phase margin.

![CMFB open-loop gain and phase](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/Plots/NOM.ol_ac.png)

The valid reference range is 1.05–3.01 V. Nominal input error is −0.0586 mV.

![CMFB closed-loop DC response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/Plots/NOM.cl_dc.png)

Both closed-loop CMFB transitions settle in 5.2 ns.

![CMFB closed-loop transient response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/Plots/NOM.cl_tran.png)

## 5. Integrated FDOTA verification

All 45 process, supply, and temperature corners pass.

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current | ≤2.5 mA | 1.604 mA | 2.194 mA | `FFVHTH` |
| Total power | ≤9 mW | 5.293 mW | 7.900 mW | `FFVHTH` |
| Differential gain | ≥85 dB | 92.064 dB | 90.321 dB | `FFVLTH` |
| Differential UGF | ≥8 MHz | 14.576 MHz | 9.409 MHz | `SSVLTH` |
| Differential phase margin | ≥60° | 77.135° | 69.170° | `FFVLTH` |
| Differential input offset | ±3 mV | Below resolution | Below resolution | — |
| CMRR, 60 / 150 Hz | ≥80 / 80 dB | 310.521 / 310.557 dB | 228.347 / 228.347 dB | `NOMVHNOM` |
| PSRR+, 60 / 150 Hz | ≥80 / 80 dB | 307.375 / 307.346 dB | 220.817 / 220.817 dB | `SFNOMNOM` |
| PSRR−, 60 / 150 Hz | ≥80 / 80 dB | 292.936 / 304.677 dB | 232.233 / 232.212 dB | `SFNOMNOM` |
| Input noise, 0.05–150 Hz | ≤4 µVrms | 3.083 µVrms | 3.513 µVrms | `SSVHTH` |
| Gain error | ±0.01% | −0.002% | −0.003% | `FFVLTH` |
| Output CM error | ±25 mV | −0.134 mV | 11.978 mV | `SSVHTH` |
| Input common-mode range | Low ≤1.0 V; high ≥2.3 V | 0.870–3.300 V | 0.975–2.945 V | `SSVHNOM` / `FSVLTH` |
| Differential output swing | ≤−1.8 V; ≥+1.8 V | −3.248 / +3.248 V | −2.898 / +2.898 V | `FSVLTH` |
| Differential slew rate | ≥4 V/µs | 7.204 V/µs | 5.096 V/µs | `SSVLTL` |
| Differential settling | ≤300 ns | 175.868 ns | 246.550 ns | `SSVLTL` |
| Step-induced CM disturbance | ≤60 mV | 37.043 mV | 47.404 mV | `SSNOMTH` |
| CMFB slew, rise / fall | ≥2 / 2 V/µs | 3.555 / 3.496 V/µs | 2.473 / 2.576 V/µs | `SSVLTL` / `SSVLTH` |
| CMFB settling | ≤1000 ns | 309.737 ns | 418.338 ns | `SSVLTH` |

### 5.1 Open-loop response

Nominal gain is 92.064 dB, UGF is 14.576 MHz, and phase margin is 77.135°. Full-PVT minima are 90.321 dB, 9.409 MHz, and 69.170°.

![FDOTA open-loop gain and phase](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.open_loop_gain_phase.png)

The deterministic input offset is below reporting resolution because the PVT models preserve device symmetry; mismatch is covered by Monte Carlo.

![FDOTA open-loop VTC](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.open_loop_vtc.png)

### 5.2 Rejection and noise

Nominal CMRR is 310.521 dB at 60 Hz and 310.557 dB at 150 Hz. The full-PVT minimum is 228.347 dB at both frequencies.

![FDOTA CMRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.cmrr.png)

Nominal PSRR+ is 307.375/307.346 dB at 60/150 Hz; PSRR− is 292.936/304.677 dB. Every PVT result exceeds 220 dB.

![FDOTA PSRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.psrr.png)

These very large rejection values reflect ideal schematic symmetry. Layout mismatch and parasitic imbalance will set practical silicon rejection.

Integrated input noise is 3.083 µVrms nominal and 3.513 µVrms worst case over 0.05–150 Hz.

![FDOTA input-referred noise](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.input_referred_noise_density.png)

### 5.3 Input and output range

The nominal input common-mode range is 0.870–3.300 V. Across PVT, the limiting low and high values are 0.975 V and 2.945 V.

![FDOTA input common-mode range](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.input_common_mode_range.png)

Nominal differential swing is ±3.248 V, with ±2.898 V available at the limiting corner. Nominal closed-loop gain error is −0.002%.

![FDOTA output swing and closed-loop VTC](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.output_swing_and_closed_loop_vtc.png)

### 5.4 Transient response

Nominal differential slew rate is 7.204 V/µs and settling time is 175.868 ns. Worst-case values are 5.096 V/µs and 246.550 ns.

![FDOTA closed-loop step response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.closed_loop_step_response.png)

Differential-step common-mode disturbance is 37.043 mV nominal and 47.404 mV worst case.

![FDOTA differential-step common-mode disturbance](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.diff_step_cm_disturbance.png)

The integrated CMFB response settles in 309.737 ns nominal and 418.338 ns worst case.

![FDOTA output common-mode transient](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/NOM.output_cm_transient.png)

## 6. Monte Carlo verification

MM applies local mismatch, GL applies global variation, and FULL combines both. All 600 runs are valid and pass the joint limits.

| Mode | Valid runs | Gain minimum (dB) | UGF minimum (MHz) | PM minimum (°) | Offset range (µV) | CM-error range (mV) | Yield |
| :---: | ---: | ---: | ---: | ---: | :---: | :---: | ---: |
| MM | 200/200 | 92.046 | 13.801 | 76.450 | −2094.94 to +2353.51 | −10.145 to +10.915 | 100% |
| GL | 200/200 | 91.143 | 13.075 | 73.583 | −0.0006 to +0.00004 | −4.023 to +4.823 | 100% |
| FULL | 200/200 | 91.143 | 12.851 | 73.407 | −2094.09 to +2352.45 | −10.459 to +13.114 | 100% |

FULL-MC maximum current is 1.745 mA and maximum power is 5.758 mW. Both remain below specification.

FULL-MC offset has a 30.522-µV mean and spans −2094.09 to +2352.45 µV.

![FDOTA MC input offset](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_01_Input_Offset_Histogram.png)

FULL-MC output common-mode error has a −0.456-mV mean and spans −10.459 to +13.114 mV.

![FDOTA MC output common-mode error](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_02_Output_CM_Error_Histogram.png)

FULL-MC differential gain has a 92.032-dB mean and spans 91.143–93.000 dB.

![FDOTA MC differential gain](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_03_DC_Gain_Histogram.png)

FULL-MC UGF has a 14.618-MHz mean and spans 12.851–16.829 MHz.

![FDOTA MC UGF](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_04_UGF_Histogram.png)

FULL-MC phase margin has a 77.077° mean and spans 73.407–80.552°.

![FDOTA MC phase margin](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_05_Phase_Margin_Histogram.png)

FULL-MC gain error has a −0.002505% mean and spans −0.00277% to −0.00224%.

![FDOTA MC gain error](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Plots/Fig_MC_06_Gain_Error_Histogram.png)

## 7. References and generated artifacts

### Design-method references

- F. Silveira, D. Flandre, and P. G. A. Jespers, “A $g_m/I_D$ Based Methodology for the Design of CMOS Analog Circuits and Its Application to the Synthesis of a Silicon-on-Insulator Micropower OTA,” *IEEE Journal of Solid-State Circuits*, 1996. [DOI: 10.1109/4.535416](https://doi.org/10.1109/4.535416)
- P. G. A. Jespers and B. Murmann, “Basic Sizing Using the $g_m/I_D$ Methodology,” in *Systematic Design of Analog CMOS Circuits*, Cambridge University Press, 2017. [DOI: 10.1017/9781108125840.003](https://doi.org/10.1017/9781108125840.003)
- P. G. A. Jespers and B. Murmann, “Lookup Table Generation and Usage,” in *Systematic Design of Analog CMOS Circuits*, 2017. [DOI: 10.1017/9781108125840.008](https://doi.org/10.1017/9781108125840.008)
- A. A. Youssef, B. Murmann, and H. Omran, “Analog IC Design Using Precomputed Lookup Tables: Challenges and Solutions,” *IEEE Access*, 2020. [DOI: 10.1109/ACCESS.2020.3010875](https://doi.org/10.1109/ACCESS.2020.3010875)

### Generated artifacts

- [FDOTA analyzer](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDOTA_Analyze.m)
- [Nominal and representative-corner results](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/NOM.FDOTA_summary.csv)
- [Full-PVT worst-case results](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FDOTA_worst_case_report.csv)
- [Representative PVT table](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FDOTA_table_report.csv)
- [Monte Carlo run summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FDOTA_MC_Run_Summary.csv)
- [MM](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/MM_FDOTA_MC_Summary.csv), [GL](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/GL_FDOTA_MC_Summary.csv), and [FULL](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/Results/FULL_FDOTA_MC_Summary.csv) statistical summaries
- [FDC block summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/FDC/NOM.FDC_summary.csv)
- [CMFB block summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/FDOTA/CMFB/NOM.CMFB_summary.csv)

## 8. Scope

These are schematic-level results. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
