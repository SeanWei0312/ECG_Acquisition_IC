# SEOTA Design and Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Result |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45/45 PVT corners pass |
| Statistical coverage | MM, GL, and FULL: 200/200 valid runs each |
| Overall status | **Pass** |

## 1. Architecture

The SEOTA is a two-stage, Miller-compensated voltage amplifier.

- M1/M2 form the NMOS differential input pair.
- M3/M4 provide the PMOS first-stage active load; M5 supplies the tail current.
- M6/M7 form the second stage; M8 is the bias-reference device.
- A series $R_z$–$C_c$ path provides pole splitting and zero control.

Schematic source: [SEOTA](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/SEOTA/SEOTA.sch>).

The schematic shows the differential input stage, single-ended second stage, bias path, and Miller compensation network.

![SEOTA circuit schematic](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/SEOTA/SEOTA.png>)

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

The sizing flow is:

1. Derive transconductance and current from bandwidth, noise, load, and slew targets.
2. Select channel length and $g_m/I_D$ from current-density, intrinsic-gain, and speed data.
3. Calculate width from $W_{eff}=I_D/J_D$ and preserve matched geometry.
4. Tune $R_z$ and $C_c$, then verify AC, transient, PVT, and Monte Carlo performance.

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

## 3. Input and gain stage

`W_eff` is $W\times m$ because the listed devices use `nf=1`.

| Function | Devices | Type | $L$ (µm) | $W$ (µm) | $m$ | $W_{eff}$ (µm) |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| Input pair | M1, M2 | NMOS | 4.0 | 100 | 4 | 400 |
| Active load | M3, M4 | PMOS | 4.0 | 30 | 2 | 60 |
| Tail source | M5 | NMOS | 2.0 | 10 | 1 | 10 |
| Bias reference | M8 | NMOS | 2.0 | 20 | 1 | 20 |

The 4-µm input and load devices favor intrinsic gain and matching. Their large widths support low current density and low input-referred noise.

Using the 40.092-µA nominal bias and mirror ratios gives this first-order interpretation:

| Device group | Estimated branch current | Estimated $J_D$ | Interpretation |
| :--- | ---: | ---: | :--- |
| M1/M2 | 10 µA | 0.025 µA/µm | Very high transconductance efficiency |
| M3/M4 | 10 µA | 0.167 µA/µm | Approximately $g_m/I_D=8$–9 V⁻¹ at the lookup bias |

The M1/M2 density is below the printed $g_m/I_D=20\ \text{V}^{-1}$ lookup point. It indicates a very low-current-density operating choice, but an exact $g_m/I_D$ requires saved device operating points.

## 4. Second stage and compensation

| Function | Device or element | Type | Implemented value |
| :--- | :---: | :---: | ---: |
| Second-stage pull-up | M6 | PMOS | $L=0.5$ µm, $W=50$ µm, $m=8$ |
| Second-stage pull-down | M7 | NMOS | $L=0.5$ µm, $W=100$ µm, $m=1$ |
| Miller capacitor | $C_c$ | MIM | Approximately 2.00 pF |
| Zero-setting resistor | $R_z$ | Poly | Approximately 3.8 kΩ |

The short second-stage devices provide higher current density and speed than the 4-µm gain devices. Their widths support the 10-pF load and the required slew rate.

The series $R_z$–$C_c$ network stabilizes the two-stage loop. Final values are closed by the measured UGF, phase margin, and settling response.

## 5. Integrated SEOTA verification

All 45 process, supply, and temperature corners pass.

| Metric | Specification | Nominal | Full-PVT worst case | Corner |
| :--- | :---: | ---: | ---: | :---: |
| Total current | ≤1.25 mA | 0.825 mA | 1.106 mA | `FFVHTH` |
| Total power | ≤4.5 mW | 2.721 mW | 3.982 mW | `FFVHTH` |
| DC gain | ≥88 dB | 96.522 dB | 93.988 dB | `FSVLTH` |
| UGF | ≥8 MHz | 12.835 MHz | 8.762 MHz | `SSVLTH` |
| Phase margin | ≥55° | 67.767° | 56.368° | `FFVLTH` |
| Input offset | ±2 mV | 3.193 µV | 12.092 µV | `FSVLTH` |
| CMRR, 60 / 150 Hz | ≥105 / 105 dB | 111.957 / 111.957 dB | 109.711 / 109.711 dB | `SSVLTH` |
| PSRR+, 60 / 150 Hz | ≥100 / 95 dB | 103.379 / 99.232 dB | 101.385 / 96.565 dB | `SSVLTL` / `SSVLTH` |
| PSRR−, 60 / 150 Hz | ≥100 / 95 dB | 103.379 / 99.232 dB | 101.385 / 96.565 dB | `SSVLTL` / `SSVLTH` |
| Input noise, 0.05–150 Hz | ≤2.5 µVrms | 1.873 µVrms | 2.189 µVrms | `SSVLTH` |
| Gain error | ±0.01% | −0.001% | −0.001% | `FSVLTH` |
| Input range | Low ≤0.6 V; high ≥2.75 V | 0.106–3.237 V | 0.429–2.815 V | `SSVHTL` / `FSVLTH` |
| Output range | Low ≤0.6 V; high ≥2.75 V | 0.108–3.235 V | 0.431–2.813 V | `SSVHTL` / `FSVLTH` |
| Slew rate, rise / fall | ≥6.5 / 5.0 V/µs | 9.814 / 7.966 V/µs | 6.927 / 5.636 V/µs | `SSVLTL` |
| Settling time | ≤225 ns | 163.4 ns | 213.4 ns | `SSVLTL` |

### 5.1 Open-loop response

At nominal conditions, the SEOTA provides 96.522 dB gain, 12.835 MHz UGF, and 67.767° phase margin. Full-PVT minima are 93.988 dB, 8.762 MHz, and 56.368°.

![SEOTA open-loop gain and phase](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.open_loop_gain_phase.png)

The nominal zero crossing gives 3.193 µV input offset. The largest deterministic offset is 12.092 µV, well inside the ±2-mV limit.

![SEOTA open-loop VTC](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.open_loop_vtc.png)

### 5.2 Rejection and noise

CMRR is 111.957 dB at 60 and 150 Hz nominal, with a 109.711-dB full-PVT minimum.

![SEOTA CMRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.cmrr.png)

Nominal PSRR is 103.379 dB at 60 Hz and 99.232 dB at 150 Hz. The worst PVT values remain 101.385 dB and 96.565 dB for both supply polarities.

![SEOTA PSRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.psrr.png)

Integrated input noise is 1.873 µVrms nominal and 2.189 µVrms worst case over 0.05–150 Hz.

![SEOTA input-referred noise](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.input_referred_noise_density.png)

### 5.3 Closed-loop range

At nominal conditions, the usable input range is 0.106–3.237 V and the output range is 0.108–3.235 V. Every headroom limit passes across PVT.

![SEOTA closed-loop usable range](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.closed_loop_usable_range.png)

### 5.4 Transient response

With a 10-pF load, settling is 163.4 ns nominal and 213.4 ns worst case. Nominal rise/fall slew rates are 9.814/7.966 V/µs; worst-case values are 6.927/5.636 V/µs.

![SEOTA closed-loop step response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.closed_loop_step_response.png)

## 6. Monte Carlo verification

MM applies local mismatch, GL applies global variation, and FULL combines both. All 600 runs are valid and pass the joint limits.

| Mode | Valid runs | Current maximum (mA) | Gain minimum (dB) | UGF minimum (MHz) | PM minimum (°) | Offset range (µV) | Yield |
| :---: | ---: | ---: | ---: | ---: | ---: | :---: | ---: |
| MM | 200/200 | 0.869 | 96.382 | 12.285 | 67.374 | −976.478 to +1182.960 | 100% |
| GL | 200/200 | 0.871 | 95.477 | 11.947 | 64.251 | −11.636 to +15.683 | 100% |
| FULL | 200/200 | 0.895 | 95.488 | 11.764 | 64.231 | −970.439 to +1177.630 | 100% |

FULL-MC offset spans −970.439 to +1177.630 µV. The $\mu\pm3\sigma$ interval is −1.234 to +1.243 mV against the ±2-mV limit.

![SEOTA MC input offset](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_01_Vos_Histogram.png)

FULL-MC gain spans 95.488–97.396 dB. Its $\mu-3\sigma$ value is 95.256 dB against the 88-dB minimum.

![SEOTA MC DC gain](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_02_DC_Gain_Histogram.png)

FULL-MC UGF spans 11.764–13.961 MHz. Its $\mu-3\sigma$ value is 11.613 MHz against the 8-MHz minimum.

![SEOTA MC UGF](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_03_UGF_Histogram.png)

FULL-MC phase margin spans 64.231–73.006°. Its $\mu-3\sigma$ value is 63.334° against the 55° minimum.

![SEOTA MC phase margin](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_04_Phase_Margin_Histogram.png)

FULL-MC gain error spans −0.0025% to 0%, within the ±0.01% limit.

![SEOTA MC gain error](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_05_Gain_Error_Histogram.png)

## 7. References and generated artifacts

### Design-method references

- F. Silveira, D. Flandre, and P. G. A. Jespers, “A $g_m/I_D$ Based Methodology for the Design of CMOS Analog Circuits and Its Application to the Synthesis of a Silicon-on-Insulator Micropower OTA,” *IEEE Journal of Solid-State Circuits*, 1996. [DOI: 10.1109/4.535416](https://doi.org/10.1109/4.535416)
- P. G. A. Jespers and B. Murmann, “Basic Sizing Using the $g_m/I_D$ Methodology,” in *Systematic Design of Analog CMOS Circuits*, Cambridge University Press, 2017. [DOI: 10.1017/9781108125840.003](https://doi.org/10.1017/9781108125840.003)
- P. G. A. Jespers and B. Murmann, “Lookup Table Generation and Usage,” in *Systematic Design of Analog CMOS Circuits*, 2017. [DOI: 10.1017/9781108125840.008](https://doi.org/10.1017/9781108125840.008)
- A. A. Youssef, B. Murmann, and H. Omran, “Analog IC Design Using Precomputed Lookup Tables: Challenges and Solutions,” *IEEE Access*, 2020. [DOI: 10.1109/ACCESS.2020.3010875](https://doi.org/10.1109/ACCESS.2020.3010875)

### Generated artifacts

- [SEOTA analyzer](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/SEOTA_Analyze.m)
- [Nominal and representative-corner results](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/NOM.SEOTA_summary.csv)
- [Full-PVT worst-case results](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_worst_case_report.csv)
- [Representative PVT table](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_table_report.csv)
- [Monte Carlo run summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_MC_Run_Summary.csv)
- [MM](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/MM_SEOTA_MC_Summary.csv), [GL](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/GL_SEOTA_MC_Summary.csv), and [FULL](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/FULL_SEOTA_MC_Summary.csv) statistical summaries

## 8. Scope

These are schematic-level results. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
