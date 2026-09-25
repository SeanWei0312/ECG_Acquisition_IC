# SE OTA Detailed Verification Report

[← System-level project report](../../Project_Report.md)

| Item | Value |
| :--- | :--- |
| Verification level | Pre-layout schematic |
| Deterministic coverage | 45 PVT corners |
| Statistical coverage | 200-run MM, GL, and FULL |
| Status | Pass |

## Architecture and design intent

The SE OTA is a two-stage, Miller-compensated voltage amplifier. The first stage uses the NMOS differential pair M1/M2, the PMOS active-load pair M3/M4, and the NMOS tail source M5. Its single-ended high-impedance node drives the second stage formed by PMOS M6 and NMOS M7. M8 is the NMOS bias-reference device. The series $R_z$–$C_c$ path provides frequency compensation and controls the feed-forward zero.

Schematic source: [SEOTA.sch](<../../Design_Files/IC Design/Schematic/ANALOG_BLOCKS/SEOTA/SEOTA.sch>).

The table below records the implemented schematic dimensions. `W_eff` is the total electrical width $W\times m$ because every listed device uses `nf=1`.

| Function | Devices | Type | $L$ (µm) | $W$ (µm) | $m$ | $W_{eff}$ per device (µm) | Sizing objective |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | :--- |
| Input differential pair | M1, M2 | NMOS | 4.0 | 100 | 4 | 400 | High $g_m/I_D$, low input-referred noise, matching, and first-stage gain |
| First-stage active load | M3, M4 | PMOS | 4.0 | 30 | 2 | 60 | High output resistance and mirror accuracy |
| Tail source | M5 | NMOS | 2.0 | 10 | 1 | 10 | Establish the input-stage current |
| Bias reference | M8 | NMOS | 2.0 | 20 | 1 | Generate the current-mirror reference |
| Second-stage pull-up | M6 | PMOS | 0.5 | 50 | 8 | Output current, slew rate, and capacitive-load drive |
| Second-stage pull-down | M7 | NMOS | 0.5 | 100 | 1 | Output current, slew rate, and capacitive-load drive |

The MIM capacitor has $W=L=31.623\,\mu\text{m}$ in the 2 fF/µm² model, giving approximately $C_c=2.00$ pF. The poly resistor uses the 2 kΩ/square model with $L/W=7.6/4$, giving a first-order value of approximately $R_z=3.8$ kΩ before model end and contact corrections.

## $g_m/I_D$ sizing methodology

The design uses the lookup-table form of the $g_m/I_D$ method. Silveira, Flandre, and Jespers introduced $g_m/I_D$ as a unified design variable across weak, moderate, and strong inversion; it simultaneously measures transconductance efficiency, indicates inversion level, and enables device sizing. The later lookup-table flow of Jespers and Murmann retains compact-model accuracy by characterizing each device once and then interpolating the stored data during circuit design.

The essential relations are

$$
g_m=\left(\frac{g_m}{I_D}\right)I_D,
\qquad
J_D=\frac{I_D}{W_{eff}},
\qquad
W_{eff}=\frac{I_D}{J_D},
$$

where $J_D=I_D/W$ is read from the characterization table at the selected channel length, drain voltage, and $g_m/I_D$. The same lookup point supplies the intrinsic-gain indicator

$$
A_{v,int}=\frac{g_m}{g_{ds}},
$$

and the speed indicators $f_T$ and $(g_m/I_D)f_T$. A larger $g_m/I_D$ produces more $g_m$ for a fixed current and generally reduces overdrive and improves input-stage noise efficiency, but it also lowers current density and therefore increases required device area. Increasing channel length generally improves $g_m/g_{ds}$ and matching while reducing $f_T$ and increasing parasitic capacitance. Sizing is therefore a constrained gain–noise–speed–headroom–area tradeoff, not a single optimum $g_m/I_D$ value.

For this OTA, the practical flow is:

1. Derive the required input-stage $g_m$ from UGF, compensation capacitance, load, noise, and settling targets. The familiar $f_u\approx g_{m1}/(2\pi C_c)$ relation is useful for a first estimate, but the two-stage loop is closed only by transistor-level AC and transient verification.
2. Choose $L$ and $g_m/I_D$ for each device group. Long input and load devices prioritize intrinsic gain and matching; short output devices prioritize current density and speed.
3. Compute current from $I_D=g_m/(g_m/I_D)$, then obtain width from $W_{eff}=I_D/J_D$.
4. Realize the required total width with multiplicity, preserving matched geometry for differential and mirror devices.
5. Select $C_c$ and $R_z$ from the required pole splitting and zero placement, then recheck UGF, phase margin, slew rate, settling, PVT, and mismatch.

### Local 180 nm characterization data

The project characterization sweeps 10-µm-wide `nfet_03v3` and `pfet_03v3` devices over $L=0.28$–5 µm. The terminal tables interpolate $g_m/I_D=4$–20 V⁻¹ at $V_{DS}=1.65$ V for NMOS and $V_{SD}=1.65$ V for PMOS. The simulator supplies $g_m$, $g_{ds}$, capacitances, and $f_T$ directly; the MATLAB postprocessor forms $g_m/I_D$, $I_D/W$, $g_m/g_{ds}$, and $(g_m/I_D)f_T$ on the physical monotonic branch.

The table's $V_{OV}$ and threshold-voltage columns are diagnostic only: the postprocessor estimates $V_{OV}\approx2/(g_m/I_D)$ and derives threshold voltage from that estimate. Width selection in this report relies on simulator-derived current density and small-signal quantities, not on treating the square-law $V_{OV}$ estimate as an exact compact-model result.

Representative values at $g_m/I_D=10$ V⁻¹ show the channel-length tradeoff used in this design:

| $L$ (µm) | NMOS $I_D/W$ (µA/µm) | NMOS $g_m/g_{ds}$ (dB) | NMOS $(g_m/I_D)f_T$ (GHz/V) | PMOS $I_D/W$ (µA/µm) | PMOS $g_m/g_{ds}$ (dB) | PMOS $(g_m/I_D)f_T$ (GHz/V) |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0.5 | 4.381 | 44.80 | 54.34 | 1.265 | 48.34 | 12.62 |
| 1.0 | 2.257 | 51.75 | 13.75 | 0.5309 | 56.26 | 2.668 |
| 2.0 | 1.055 | 55.27 | 3.067 | 0.2390 | 61.99 | 0.6172 |
| 4.0 | 0.4959 | 58.41 | 0.7020 | 0.1128 | 67.40 | 0.1501 |

The numerical trend is the key design result: moving from 0.5 to 4 µm substantially raises intrinsic gain while sharply reducing current density and speed. This directly supports the use of 4-µm devices in the first-stage gain path and 0.5-µm devices in the output stage.

- [NMOS $g_m/I_D$ current-density plot](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_current_density_vs_gmid.png)
- [NMOS intrinsic-gain plot](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/NMOS_Gm_Id/Plots/nmos_intrinsic_gain_db_vs_gmid.png)
- [PMOS $g_m/I_D$ current-density plot](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_current_density_vs_gmid.png)
- [PMOS intrinsic-gain plot](../../Measurement_Results/IC_Simulation/SIZING/Gm_Id/PMOS_Gm_Id/Plots/pmos_intrinsic_gain_db_vs_gmid.png)

### Interpretation of the implemented SE OTA sizing

The nominal bias current is 40.092 µA. M5 and M8 share $L=2$ µm, while the M5 width is one half of the M8 width. A first-order mirror estimate therefore places the input-stage tail current near 20 µA and each balanced input branch near 10 µA. With $W_{eff}=400$ µm per input transistor, the implied current density is approximately 0.025 µA/µm. At $L=4$ µm the NMOS table gives 0.0327 µA/µm even at $g_m/I_D=20$ V⁻¹, so this geometry intentionally places M1/M2 at the high-efficiency end of the characterized range. That choice is consistent with the large input devices, low 0.05–150 Hz input-noise target, and high first-stage gain.

The same branch estimate gives approximately 0.167 µA/µm in each 60-µm PMOS load. At $L=4$ µm, the PMOS table gives 0.1875 µA/µm at 8 V⁻¹ and 0.1444 µA/µm at 9 V⁻¹. M3/M4 therefore occupy a more current-dense moderate-inversion region than M1/M2 while retaining the large intrinsic gain of a 4-µm channel. This is appropriate for a mirror load whose output resistance and matching directly affect first-stage gain and systematic offset.

M6/M7 instead use $L=0.5$ µm and large effective widths. The lookup table shows why: at $g_m/I_D=10$ V⁻¹, the 0.5-µm devices provide much greater current density and $(g_m/I_D)f_T$ than their 4-µm counterparts. These devices can therefore supply the output current required for the 10-pF load and slew-rate target without the excessive area and capacitance that a 4-µm output pair would impose. The resulting topology deliberately assigns efficiency and gain to the first stage, then assigns speed and drive to the second stage.

These current-density estimates are design interpretations, not direct transistor operating-point measurements. The lookup slice is at 1.65 V drain bias, whereas each in-circuit device has its own $V_{DS}$ or $V_{SD}$ and body bias. Exact per-device $g_m/I_D$ should be reported only from saved nominal operating-point vectors. Here the lookup data explains the sizing choices, while the circuit-level PVT and Monte Carlo results provide the final evidence.

### Sizing-to-verification closure

| Sizing choice | Intended result | Verified evidence |
| :--- | :--- | :--- |
| Large, long-channel M1/M2 | High transconductance efficiency, low input noise, good matching | 96.522 dB nominal gain; 1.873 µVrms nominal integrated noise; FULL-MC offset remains within ±2 mV |
| Long-channel M3/M4 | High first-stage output resistance and gain | Full-PVT gain remains at least 93.988 dB |
| Short, wide M6/M7 | High output current density and fast load drive | 12.835 MHz nominal UGF; 9.814/7.966 V/µs nominal rise/fall slew rate |
| Approximately 2-pF $C_c$ with 3.8-kΩ $R_z$ | Pole splitting and adequate phase margin | 67.767° nominal phase margin; 56.368° full-PVT minimum against the 55° limit |
| Bias and mirror ratios | Controlled power and reproducible operating point | 0.825 mA nominal total current; 1.106 mA full-PVT maximum; all 200 FULL-MC runs pass |

## Design-method references

- F. Silveira, D. Flandre, and P. G. A. Jespers, “A $g_m/I_D$ Based Methodology for the Design of CMOS Analog Circuits and Its Application to the Synthesis of a Silicon-on-Insulator Micropower OTA,” *IEEE Journal of Solid-State Circuits*, vol. 31, no. 9, 1996. [DOI: 10.1109/4.535416](https://doi.org/10.1109/4.535416)
- P. G. A. Jespers and B. Murmann, “Basic Sizing Using the $g_m/I_D$ Methodology,” in *Systematic Design of Analog CMOS Circuits: Using Pre-Computed Lookup Tables*, Cambridge University Press, 2017. [DOI: 10.1017/9781108125840.003](https://doi.org/10.1017/9781108125840.003)
- P. G. A. Jespers and B. Murmann, “Lookup Table Generation and Usage,” ibid., 2017. [DOI: 10.1017/9781108125840.008](https://doi.org/10.1017/9781108125840.008)
- A. A. Youssef, B. Murmann, and H. Omran, “Analog IC Design Using Precomputed Lookup Tables: Challenges and Solutions,” *IEEE Access*, 2020. [DOI: 10.1109/ACCESS.2020.3010875](https://doi.org/10.1109/ACCESS.2020.3010875)

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

## Monte Carlo results

MM applies local mismatch, GL applies global process variation, and FULL combines both. Each campaign requested 200 runs, produced 200 valid runs with zero failed runs, and achieved 100% joint yield. The tables include every metric exported in the corresponding MC summary CSV.

### MM Monte Carlo — complete statistics

| Parameter | Unit | Spec | Min | μ−3σ | μ−σ | Mean | μ+σ | μ+3σ | Max | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Bias current | µA | 40±10 | 38.591 | 38.553 | 39.545 | 40.042 | 40.538 | 41.531 | 41.511 | 100% |
| Total current | mA | ≤1.25 | 0.7987 | 0.7923 | 0.8184 | 0.8315 | 0.8446 | 0.8707 | 0.8689 | 100% |
| Total power | mW | ≤4.5 | 2.636 | 2.615 | 2.701 | 2.744 | 2.787 | 2.873 | 2.868 | 100% |
| DC gain | dB | ≥88 | 96.382 | 96.380 | 96.427 | 96.450 | 96.474 | 96.521 | 96.508 | 100% |
| UGF | MHz | ≥8 | 12.285 | 12.173 | 12.603 | 12.818 | 13.033 | 13.463 | 13.388 | 100% |
| Phase margin | ° | ≥55 | 67.374 | 67.313 | 67.643 | 67.808 | 67.973 | 68.303 | 68.232 | 100% |
| Input offset | µV | ±2000 | −976.478 | −1234.498 | −408.750 | 4.124 | 416.997 | 1242.745 | 1182.960 | 100% |
| Gain error | % | ±0.01 | −0.002200 | −0.002410 | −0.001619 | −0.001223 | −0.000828 | −0.000037 | −0.000100 | 100% |

### GL Monte Carlo — complete statistics

| Parameter | Unit | Spec | Min | μ−3σ | μ−σ | Mean | μ+σ | μ+3σ | Max | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Bias current | µA | 40±10 | 39.253 | 39.101 | 39.771 | 40.107 | 40.442 | 41.112 | 40.929 | 100% |
| Total current | mA | ≤1.25 | 0.8033 | 0.7964 | 0.8211 | 0.8335 | 0.8458 | 0.8705 | 0.8706 | 100% |
| Total power | mW | ≤4.5 | 2.651 | 2.628 | 2.710 | 2.750 | 2.791 | 2.873 | 2.873 | 100% |
| DC gain | dB | ≥88 | 95.477 | 95.257 | 96.029 | 96.415 | 96.801 | 97.573 | 97.404 | 100% |
| UGF | MHz | ≥8 | 11.947 | 11.715 | 12.470 | 12.847 | 13.225 | 13.979 | 13.847 | 100% |
| Phase margin | ° | ≥55 | 64.251 | 63.402 | 66.358 | 67.836 | 69.314 | 72.270 | 72.639 | 100% |
| Input offset | µV | ±2000 | −11.636 | −10.904 | −1.399 | 3.354 | 8.107 | 17.613 | 15.683 | 100% |
| Gain error | % | ±0.01 | −0.001500 | −0.001548 | −0.001325 | −0.001214 | −0.001103 | −0.000880 | −0.001000 | 100% |

### FULL Monte Carlo — complete statistics

| Parameter | Unit | Spec | Min | μ−3σ | μ−σ | Mean | μ+σ | μ+3σ | Max | Yield |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Bias current | µA | 40±10 | 38.594 | 38.318 | 39.477 | 40.056 | 40.636 | 41.794 | 41.411 | 100% |
| Total current | mA | ≤1.25 | 0.7889 | 0.7805 | 0.8155 | 0.8329 | 0.8504 | 0.8853 | 0.8952 | 100% |
| Total power | mW | ≤4.5 | 2.603 | 2.576 | 2.691 | 2.749 | 2.806 | 2.921 | 2.954 | 100% |
| DC gain | dB | ≥88 | 95.488 | 95.256 | 96.029 | 96.416 | 96.802 | 97.576 | 97.396 | 100% |
| UGF | MHz | ≥8 | 11.764 | 11.613 | 12.428 | 12.835 | 13.243 | 14.057 | 13.961 | 100% |
| Phase margin | ° | ≥55 | 64.231 | 63.334 | 66.331 | 67.829 | 69.327 | 72.324 | 73.006 | 100% |
| Input offset | µV | ±2000 | −970.439 | −1234.433 | −408.721 | 4.135 | 416.991 | 1242.702 | 1177.630 | 100% |
| Gain error | % | ±0.01 | −0.002500 | −0.002436 | −0.001632 | −0.001229 | −0.000827 | −0.000023 | 0.000 | 100% |

## Corner comparison

### SE OTA comparison: NOM, FF, SS, FS, SF, VL, VH, TL, TH

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

## Plots

### All generated SE OTA plots

![SE OTA open-loop gain and phase](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.open_loop_gain_phase.png)

![SE OTA open-loop transfer curve](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.open_loop_vtc.png)

![SE OTA CMRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.cmrr.png)

![SE OTA PSRR](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.psrr.png)

![SE OTA input-referred noise](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.input_referred_noise_density.png)

![SE OTA closed-loop usable range](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.closed_loop_usable_range.png)

![SE OTA closed-loop step response](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/NOM.closed_loop_step_response.png)

![SE OTA MC input offset](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_01_Vos_Histogram.png)

![SE OTA MC DC gain](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_02_DC_Gain_Histogram.png)

![SE OTA MC UGF](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_03_UGF_Histogram.png)

![SE OTA MC phase margin](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_04_Phase_Margin_Histogram.png)

![SE OTA MC gain error](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Plots/Fig_MC_05_Gain_Error_Histogram.png)

## All 45 PVT corners

### SE OTA: all 45 PVT corners

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

## Generated artifacts

- [Analyzer](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/SEOTA_Analyze.m)
- [Comparison table](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_table_report.csv)
- [Nominal summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/NOM.SEOTA_summary.csv)
- [Worst-case table](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_worst_case_report.csv)
- [MC run summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_MC_Run_Summary.csv)
- [MM summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/MM_SEOTA_MC_Summary.csv)
- [GL summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/GL_SEOTA_MC_Summary.csv)
- [FULL summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/FULL_SEOTA_MC_Summary.csv)

## Scope limitation

These results are schematic-level simulations. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
