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

## 2. Audited sizing method

The supplied FDC and CMFB worksheets provided a useful sequence, but several assumptions did not match the implemented circuits. The FDC uses 2.5-pF compensation per side and 0.5-µm output devices, not the worksheet's 2-pF and 1-µm values. The CMFB amplifier is a single-stage error amplifier, not a two-stage Miller OTA. The calculations below use the implemented topologies and dimensions.

The core $g_m/I_D$ relations are [Silveira, Flandre, and Jespers](https://people.engr.tamu.edu/spalermo/ecen474/gm_ID_methodology_silveira_jssc_1996.pdf):

$$
g_m=\left(\frac{g_m}{I_D}\right)I_D,
\qquad
J_D=\frac{I_D}{W_{eff}},
\qquad
W_{eff}=\frac{I_D}{J_D},
\qquad
A_{v,int}=\frac{g_m}{g_{ds}}.
$$

The corrected flow is:

1. Convert bandwidth, phase-margin, load, and slew specifications into $g_m$ and current bounds.
2. Select $L$ and $g_m/I_D$ from current density, intrinsic gain, and speed.
3. Calculate $W_{eff}=I_D/J_D$ and round to matched layout units.
4. Estimate gain, poles, zero, and slew rate.
5. Close both loops with transistor-level AC, transient, PVT, and Monte Carlo simulation.

For a Miller-compensated two-stage path,

$$
g_{m1}\approx2\pi f_uC_c,
\qquad
f_{p2}\approx\frac{g_{m2}}{2\pi(C_L+C_c)}.
$$

The unity-gain relation is derived in [Berkeley EE 140, Lecture 22](https://www-inst.cs.berkeley.edu/~ee140/sp12/lectures/Lec22w.CMOSOpAmpCompensation.ee140.s12.ctn.pdf). The pole approximation is summarized in [P. E. Allen's two-stage compensation notes](https://www.pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2004/L120-CompOpAmpsI%282UP%29.pdf).

Ignoring higher poles and the compensation zero,

$$
PM\approx90^\circ-\tan^{-1}\left(\frac{f_u}{f_{p2}}\right),
$$

so the second-stage lower bound is

$$
g_{m2}\gtrsim2\pi f_u(C_L+C_c)\tan(PM_{target}).
$$

This replaces the worksheet's fixed `kp2` multiplier, which has no topology-independent derivation.

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

### 3.1 FDC design targets

| Quantity | Value used for sizing | Signoff specification |
| :--- | ---: | ---: |
| Supply, $V_{DD}$ | 3.3 V | 3.0–3.6 V in PVT |
| Load per output, $C_L$ | 10 pF | 10 pF |
| Miller capacitor per side, $C_c$ | 2.50 pF | Implemented value |
| Differential UGF | 15 MHz target | $\ge8$ MHz |
| Differential phase margin | 60° target | $\ge60^\circ$ |
| Differential gain | — | $\ge85$ dB |
| Differential slew rate | — | $\ge4$ V/µs |
| FDC bias reference | 40 µA | $40\pm10$ µA |

### 3.2 M1/M2 input-pair calculation

The formal UGF requirement gives

$$
g_{m1,min}=2\pi(8\ \text{MHz})(2.50\ \text{pF})
=125.7\ \mu\text{S}.
$$

The 15-MHz sizing target gives

$$
g_{m1,target}=2\pi(15\ \text{MHz})(2.50\ \text{pF})
=235.6\ \mu\text{S}.
$$

Select $L=2$ µm and $g_m/I_D=20\ \text{V}^{-1}$. The NMOS table gives $J_D=0.07476\ \mu\text{A}/\mu\text{m}$ and $g_m/g_{ds}=510.58$.

$$
I_{D1}=\frac{235.6\ \mu\text{S}}{20\ \text{V}^{-1}}
=11.78\ \mu\text{A},
$$

$$
W_{1,calc}=\frac{11.78\ \mu\text{A}}
{0.07476\ \mu\text{A}/\mu\text{m}}
=157.6\ \mu\text{m}.
$$

The implemented $W_{eff}=200$ µm adds matching and noise margin.

### 3.3 M3/M4 active-load calculation

For the CMFB-controlled PMOS loads, select $L=2$ µm and $g_m/I_D=16\ \text{V}^{-1}$. The table gives $J_D=0.05669\ \mu\text{A}/\mu\text{m}$.

$$
W_{3,calc}=\frac{11.78\ \mu\text{A}}
{0.05669\ \mu\text{A}/\mu\text{m}}
=207.8\ \mu\text{m}.
$$

The implemented value is 200 µm per device.

### 3.4 First-stage gain estimate

At the selected lookup points,

$$
g_{ds1}=\frac{235.6\ \mu\text{S}}{510.58}
=0.462\ \mu\text{S},
$$

$$
g_{m3}=(16)(11.78\ \mu\text{A})=188.5\ \mu\text{S},
\qquad
g_{ds3}=\frac{188.5}{1608.33}=0.117\ \mu\text{S}.
$$

Therefore

$$
A_1\approx\frac{235.6}{0.462+0.117}
=407.2\ \text{V/V}=52.20\ \text{dB}.
$$

### 3.5 Output-stage calculation

For a 60° design target,

$$
g_{m2,min}=2\pi(15\ \text{MHz})(10\ \text{pF}+2.5\ \text{pF})\tan60^\circ
=2.041\ \text{mS}.
$$

The nominal FDC current budget gives approximately

$$
I_{out,branch}\approx
\frac{1400.48-40.092-20.046}{2}
=670.2\ \mu\text{A}.
$$

This produces 1.340 µA/µm in each 500-µm PMOS and 6.702 µA/µm in each 100-µm NMOS. Interpolation of the $L=0.5$ µm tables gives approximately

$$
\left(\frac{g_m}{I_D}\right)_P\approx9.78\ \text{V}^{-1},
\qquad
\left(\frac{g_m}{I_D}\right)_N\approx8.33\ \text{V}^{-1}.
$$

Thus

$$
g_{mP}\approx6.55\ \text{mS},
\qquad
g_{mN}\approx5.58\ \text{mS},
$$

and the PMOS stage transconductance exceeds the 2.041-mS lower bound.

Using interpolated intrinsic gains gives

$$
A_2\approx111.3\ \text{V/V}=40.93\ \text{dB}.
$$

The estimated total differential gain is

$$
A_0\approx(407.2)(111.3)=4.533\times10^4\ \text{V/V}
=93.13\ \text{dB}.
$$

### 3.6 Compensation and slew-rate check

The non-dominant-pole estimate is

$$
f_{p2}\approx\frac{6.55\ \text{mS}}
{2\pi(12.5\ \text{pF})}=83.45\ \text{MHz},
$$

$$
PM_{2pole}\approx90^\circ-\tan^{-1}\left(\frac{15}{83.45}\right)
=79.81^\circ.
$$

For a series nulling resistor, the signed zero is [Geiger, Allen, and Strader, Chapter 6](https://class.ece.iastate.edu/ee508/GAS_book/chap6.pdf)

$$
\omega_z\approx\frac{1}{C_c(1/g_{mP}-R_z)}.
$$

$1/g_{mP}\approx153\ \Omega$. The implemented $R_z\approx3.5$ kΩ gives $f_z\approx-19.0$ MHz; the negative sign denotes a left-half-plane zero. The final value is simulation-tuned, following the compensation principles established by [Ahuja](https://doi.org/10.1109/JSSC.1983.1052012).

The classical Miller slew estimate is [Johns and Martin, Chapter 6](https://www.d.umn.edu/~htang/ECE5211_doc_files/ECE5211_files/Chapter6.pdf)

$$
SR\approx\frac{I_{tail}}{C_c}
=\frac{20.046\ \mu\text{A}}{2.50\ \text{pF}}
=8.02\ \text{V}/\mu\text{s}.
$$

The output stage needs only $(4\ \text{V}/\mu\text{s})(10\ \text{pF})=40$ µA per output to meet the formal slew requirement, far below the estimated 670-µA branch current.

### 3.7 Implemented FDC sizes

`W_eff` is $W\times m$ because the listed devices use `nf=1`.

| Function | Devices | Type | $L$ (µm) | $W$ (µm) | $m$ | $W_{eff}$ (µm) |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| Input pair | M1, M2 | NMOS | 2.0 | 100 | 2 | 200 |
| CMFB-controlled load | M3, M4 | PMOS | 2.0 | 50 | 4 | 200 |
| Tail source | M5 | NMOS | 2.0 | 10 | 1 | 10 |
| Bias reference | M10 | NMOS | 2.0 | 20 | 1 | 20 |
| Output pull-ups | M6, M7 | PMOS | 0.5 | 50 | 10 | 500 |
| Output pull-downs | M8, M9 | NMOS | 0.5 | 100 | 1 | 100 |

The 2-µm devices favor gain and matching. The 0.5-µm output devices favor current density and speed. Matched 2.50-pF/3.5-kΩ compensation branches preserve differential symmetry.

### 3.8 Estimate-to-simulation comparison

| Metric | First-order estimate | FDC nominal simulation | Integrated nominal | Specification |
| :--- | ---: | ---: | ---: | ---: |
| DC gain | 93.13 dB | 93.377 dB | 92.064 dB | $\ge85$ dB |
| UGF | 15 MHz sizing target | 14.571 MHz | 14.576 MHz | $\ge8$ MHz |
| Phase margin | 79.81° | 77.084° | 77.135° | $\ge60^\circ$ |
| Slew rate | 8.02 V/µs | — | 7.204 V/µs | $\ge4$ V/µs |

The gain and stability estimates track simulation closely. Output swing is not signed off with the square-law shortcut $V_{OV}\approx2/(g_m/I_D)$ because it omits body effect, real saturation voltage, and terminal-voltage dependence.

### 3.9 Nominal block verification

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

### 4.1 CMFB requirements and topology correction

The CMFB signoff requirements are an output common-mode error within ±25 mV and integrated settling within 1 µs. For a first-order 1% response,

$$
t_s\approx\frac{4.6}{2\pi f_{CL}},
$$

so the 1-µs requirement alone implies $f_{CL}\gtrsim0.733$ MHz. The supplied worksheet used a 10-MHz internal error-amplifier target and a 2-pF assumed load. That is a conservative sizing start, not the implemented open-loop load or the complete CMFB-loop bandwidth.

The implemented CMFB is a single-stage NMOS differential pair with a PMOS active load. It does not use Miller compensation.

### 4.2 Input-pair sizing

Using the worksheet's 10-MHz internal target and 2-pF initial load estimate,

$$
g_{m1,req}=2\pi(10\ \text{MHz})(2\ \text{pF})
=125.7\ \mu\text{S}.
$$

With $L=1$ µm and $g_m/I_D=12\ \text{V}^{-1}$, the NMOS table gives $J_D=1.404\ \mu\text{A}/\mu\text{m}$:

$$
I_{D1}=\frac{125.7\ \mu\text{S}}{12\ \text{V}^{-1}}
=10.47\ \mu\text{A},
$$

$$
W_{1,calc}=\frac{10.47\ \mu\text{A}}
{1.404\ \mu\text{A}/\mu\text{m}}
=7.46\ \mu\text{m}.
$$

The selected 15-µm width supports the actual 40-µA tail current. With 19.912 µA per branch,

$$
J_{D1,impl}=\frac{19.912}{15}
=1.327\ \mu\text{A}/\mu\text{m},
$$

which interpolates to $g_m/I_D\approx12.26\ \text{V}^{-1}$ and $g_{m1}\approx244.2\ \mu$S.

### 4.3 PMOS-load sizing

At $L=1$ µm and $g_m/I_D\approx17\ \text{V}^{-1}$, the PMOS table gives $J_D=0.09658\ \mu\text{A}/\mu\text{m}$.

$$
W_{3,calc}=\frac{19.912\ \mu\text{A}}
{0.09658\ \mu\text{A}/\mu\text{m}}
=206.2\ \mu\text{m}.
$$

The implemented $W_{eff}=205.5$ µm matches the lookup result.

### 4.4 Gain estimate

Interpolating the lookup-table intrinsic gains gives $g_m/g_{ds}\approx392.5$ for M1/M2 and 878.8 for M3/M4. Therefore

$$
g_{ds,N}\approx\frac{244.2\ \mu\text{S}}{392.5}
=0.622\ \mu\text{S},
$$

$$
g_{m,P}\approx(16.99)(19.912\ \mu\text{A})
=338.3\ \mu\text{S},
\qquad
g_{ds,P}\approx0.385\ \mu\text{S}.
$$

The first-order gain is

$$
A_{CMFB}\approx\frac{244.2}{0.622+0.385}
=242.5\ \text{V/V}=47.69\ \text{dB}.
$$

### 4.5 Load audit and loop interpretation

If the worksheet's 2-pF load were physically present at the CMFB-amplifier output, the selected transconductance would predict

$$
f_u\approx\frac{244.2\ \mu\text{S}}{2\pi(2\ \text{pF})}
=19.43\ \text{MHz}.
$$

The simulated standalone UGF is 967.213 MHz. Reversing the same first-order relation gives

$$
C_{eff}\approx\frac{244.2\ \mu\text{S}}
{2\pi(967.213\ \text{MHz})}
=40.2\ \text{fF}.
$$

Therefore the worksheet's 2-pF value is not the effective small-signal load in the implemented CMFB open-loop test. The integrated loop is slower because it includes the FDC common-mode plant and the two 10-pF output loads. Its 309.737-ns nominal settling time is the relevant signoff result.

### 4.6 Sensor and implemented sizes

The matched approximately 100-kΩ sensor resistors produce

$$
V_{sense}\approx\frac{V_{OUTP}+V_{OUTN}}{2}.
$$

Matched approximately 50-fF capacitors preserve high-frequency symmetry. Resistor and capacitor mismatch would convert differential output into common-mode error, so the pair geometry must remain matched.

| Function | Devices | Type | $L$ (µm) | $W$ (µm) | $m$ | $W_{eff}$ (µm) |
| :--- | :---: | :---: | ---: | ---: | ---: | ---: |
| Input pair | M1, M2 | NMOS | 1.0 | 15 | 1 | 15 |
| Active load | M3, M4 | PMOS | 1.0 | 41.1 | 5 | 205.5 |
| Tail source | M5 | NMOS | 2.0 | 20 | 1 | 20 |
| Bias reference | M10 | NMOS | 2.0 | 20 | 1 | 20 |

### 4.7 Estimate-to-simulation comparison

| Metric | First-order estimate | Standalone simulation | Integrated result |
| :--- | ---: | ---: | ---: |
| DC gain | 47.69 dB | 45.137 dB | CM error −0.134 mV |
| UGF | 19.43 MHz with assumed 2 pF | 967.213 MHz with actual test load | Closed by full CMFB loop |
| Settling | Must include plant | 5.2 ns | 309.737 ns |

The gain estimate is within 2.56 dB. The frequency discrepancy correctly identifies a load-model mismatch in the worksheet; it is not a transistor-sizing failure.

### 4.8 Nominal block verification

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
- B. K. Ahuja, “An Improved Frequency Compensation Technique for CMOS Operational Amplifiers,” *IEEE Journal of Solid-State Circuits*, 1983. [DOI: 10.1109/JSSC.1983.1052012](https://doi.org/10.1109/JSSC.1983.1052012)
- P. E. Allen, “Compensation of Op Amps—I,” Georgia Institute of Technology, ECE 6412 lecture notes. [PDF](https://www.pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2004/L120-CompOpAmpsI%282UP%29.pdf)
- University of California, Berkeley, “CMOS Op Amp Compensation,” EE 140 Lecture 22. [PDF](https://www-inst.cs.berkeley.edu/~ee140/sp12/lectures/Lec22w.CMOSOpAmpCompensation.ee140.s12.ctn.pdf)
- D. A. Johns and K. Martin, *Analog Integrated Circuit Design*, Chapter 6 course copy hosted by the University of Minnesota Duluth. [PDF](https://www.d.umn.edu/~htang/ECE5211_doc_files/ECE5211_files/Chapter6.pdf)

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
