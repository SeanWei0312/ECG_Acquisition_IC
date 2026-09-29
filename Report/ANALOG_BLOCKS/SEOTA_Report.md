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

## 2. Audited sizing method

The supplied sizing worksheet provided the correct overall flow: specification, $g_m$, current, current density, width, estimated performance, and simulation. Its transistor polarities did not match the implemented SEOTA, and its fixed second-stage multiplier was not a general two-stage OTA equation. The calculation below uses the actual NMOS-input topology and treats the second-stage requirement as a pole/phase-margin constraint.

### 2.1 Design targets

The nominal design specification is intentionally tighter than the formal PVT limit. The analytical target is set equal to, or slightly above, the nominal specification; it is not derived from the completed simulation.

| Quantity | Design target | Nominal specification | PVT specification |
| :--- | ---: | ---: | ---: |
| Supply, $V_{DD}$ | 3.3 V | 3.3 V | 3.0–3.6 V |
| Load, $C_L$ | 10 pF | 10 pF | 10 pF |
| Miller capacitor, $C_c$ | 2.00 pF | 2.00 pF | 2.00 pF |
| UGF, $f_u$ | 10 MHz | $\ge10$ MHz | $\ge8$ MHz |
| Phase margin | 65° | $\ge65^\circ$ | $\ge55^\circ$ |
| DC gain | 92 dB | $\ge92$ dB | $\ge88$ dB |
| Slew rate, rise/fall | 8/6 V/µs | $\ge8/6$ V/µs | $\ge6.5/5.0$ V/µs |
| Total current | 1.0 mA | $\le1.0$ mA | $\le1.25$ mA |
| Bias reference | 40 µA | 40 µA nominal | $40\pm10$ µA |

The 10-MHz nominal UGF target gives 25% margin over the 8-MHz PVT requirement. The implemented nominal result is 12.835 MHz, so the design target remains conservative without overstating the required bandwidth.

Each result becomes the input to the next sizing step:

| Step | Starting requirement | Calculated result | Next design decision |
| ---: | :--- | :--- | :--- |
| 1 | Slew rate and 20.046-µA tail current | $C_c\le2.51$ pF | Choose $C_c=2.00$ pF |
| 2 | $C_c$ and 10-MHz UGF | $g_{m1}=125.7$ µS | Set M1/M2 current and width |
| 3 | M1/M2 current, $g_m/I_D$, and $J_D$ | $W_{1,calc}=192.1$ µm | Enlarge to 400 µm for noise and matching |
| 4 | Input-branch current and PMOS $J_D$ | $W_{3,calc}=33.5$ µm | Use 60 µm for matching and final current |
| 5 | Phase margin, $C_L$, and $C_c$ | $g_{m2,min}=1.617$ mS | Allocate 0.75 mA to stage 2 |
| 6 | Stage-2 current and current density | $W_{6,calc}=362.8$ µm; $W_{7,calc}=103.6$ µm | Use 400/100 µm |
| 7 | Implemented $g_{m2}$ and $C_c$ | $1/g_{m2}\approx167\ \Omega$ | Choose 3.8-kΩ $R_z$ for an LHP zero |
| 8 | Complete transistor and passive network | First-order gain, UGF, PM, and slew estimates | Verify the full loop over PVT and Monte Carlo |

The first dependency is fixed before transistor sizing. The nominal slew target and the mirrored 20.046-µA tail require

$$
C_c\le\frac{20.046\ \mu\text{A}}{8\ \text{V}/\mu\text{s}}
=2.51\ \text{pF}.
$$

Selecting $C_c=2.00$ pF leaves slew margin and becomes the input to the UGF calculation below.

### 2.2 Governing equations

The $g_m/I_D$ method uses transconductance efficiency and normalized current density to convert a circuit requirement into device current and width [Silveira, Flandre, and Jespers](https://people.engr.tamu.edu/spalermo/ecen474/gm_ID_methodology_silveira_jssc_1996.pdf):

$$
I_D=\frac{g_m}{g_m/I_D},
\qquad
J_D=\frac{I_D}{W_{eff}},
\qquad
W_{eff}=\frac{I_D}{J_D}.
$$

For a conventional two-stage Miller-compensated OTA, the first-order unity-gain relation is [Berkeley EE 140, Lecture 22](https://www-inst.cs.berkeley.edu/~ee140/sp12/lectures/Lec22w.CMOSOpAmpCompensation.ee140.s12.ctn.pdf)

$$
\omega_u\approx\frac{g_{m1}}{C_c},
\qquad
g_{m1}\approx2\pi f_uC_c.
$$

The stage gains are estimated from lookup-table $g_m/g_{ds}$ values:

$$
A_1\approx\frac{g_{m1}}{g_{ds,1}+g_{ds,L1}},
\qquad
A_2\approx\frac{g_{m2}}{g_{ds,2}+g_{ds,L2}},
\qquad
A_0\approx A_1A_2.
$$

Ignoring the compensation zero and higher poles gives

$$
f_{p2}\approx\frac{g_{m2}}{2\pi(C_L+C_c)},
\qquad
PM\approx90^\circ-\tan^{-1}\left(\frac{f_u}{f_{p2}}\right).
$$

Therefore a useful lower bound is

$$
g_{m2}\gtrsim2\pi f_u(C_L+C_c)\tan(PM_{target}).
$$

This replaces the worksheet's empirical `kp2` multiplier. The non-dominant-pole approximation follows the classical two-stage model summarized by [P. E. Allen](https://www.pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2004/L120-CompOpAmpsI%282UP%29.pdf).

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

## 3. Input-stage calculation

### 3.1 Required input transconductance

The formal 8-MHz requirement needs

$$
g_{m1,min}=2\pi(8\ \text{MHz})(2.00\ \text{pF})
=100.5\ \mu\text{S}.
$$

Using the 10-MHz nominal design target gives

$$
g_{m1,target}=2\pi(10\ \text{MHz})(2.00\ \text{pF})
=125.7\ \mu\text{S}.
$$

### 3.2 M1/M2 current and width

For M1/M2, select $L=4$ µm and $g_m/I_D=20\ \text{V}^{-1}$. The local NMOS table gives $J_D=0.03271\ \mu\text{A}/\mu\text{m}$ and $g_m/g_{ds}=707.60$.

$$
I_{D1}=\frac{125.7\ \mu\text{S}}{20\ \text{V}^{-1}}
=6.283\ \mu\text{A},
$$

$$
W_{1,calc}=\frac{6.283\ \mu\text{A}}
{0.03271\ \mu\text{A}/\mu\text{m}}
=192.1\ \mu\text{m}.
$$

The nearest whole-micrometre width is 192 µm. This is the minimum first-pass value from the UGF target, not the final noise-optimized width. Input-pair thermal noise decreases as $g_m$ increases, while the MOS flicker-noise contribution scales approximately as

$$
S_{v,1/f}\propto\frac{1}{WLf}.
$$

The input pair is therefore enlarged by approximately

$$
\frac{W_{used}}{W_{calc}}=\frac{400}{192.1}=2.08.
$$

The implemented $W_{eff}=400$ µm lowers current density, supports higher $g_m/I_D$ at the final branch current, reduces flicker noise, and improves mismatch through the area dependence reported by [Pelgrom, Duinmaijer, and Welbers](https://doi.org/10.1109/JSSC.1989.572629). The trade-offs are larger input capacitance, greater first-stage-node capacitance, and more silicon area. The resulting 1.873-µVrms nominal and 2.189-µVrms worst-PVT input-noise values remain below the 2.5-µVrms specification.

The 40.092-µA bias mirror predicts a 20.046-µA tail current and approximately 10.023 µA per input branch. The implemented current density is

$$
J_{D1,impl}\approx\frac{10.023}{400}
=0.0251\ \mu\text{A}/\mu\text{m}.
$$

This density is below the printed $g_m/I_D=20\ \text{V}^{-1}$ row. Exact inversion level must therefore come from the final operating point, not extrapolation.

### 3.3 M3/M4 active-load width

Select $L=4$ µm and $g_m/I_D=8\ \text{V}^{-1}$ for the PMOS load. The table gives $J_D=0.1875\ \mu\text{A}/\mu\text{m}$.

$$
W_{3,calc}=\frac{6.283\ \mu\text{A}}
{0.1875\ \mu\text{A}/\mu\text{m}}
=33.5\ \mu\text{m}.
$$

The nearest integer is 34 µm. The implemented value is 60 µm per device. The larger area improves M3/M4 matching and accommodates the final branch current. Its added node capacitance is accepted because the simulated nominal UGF remains 12.835 MHz.

### 3.4 M5/M8 mirror sizing

Choose $L=2$ µm and a reference current density near $2\ \mu\text{A}/\mu\text{m}$ for the 40-µA bias device:

$$
W_{8,calc}=\frac{40\ \mu\text{A}}{2\ \mu\text{A}/\mu\text{m}}
=20\ \mu\text{m}.
$$

The input tail is one-half of the reference current, so equal-length mirror scaling gives

$$
W_{5,calc}=W_8\frac{20\ \mu\text{A}}{40\ \mu\text{A}}
=10\ \mu\text{m}.
$$

Both values are already whole micrometres and are implemented directly. The 2-µm length improves mirror output resistance and current accuracy; the trade-off is more area and drain capacitance.

### 3.5 First-stage size selection

`W_{calc}` follows the target equations. `W_{round}` is the closest whole-micrometre width. `W_{used}=W\times m$ is the schematic value because every listed device uses `nf=1`.

| Devices | Function | $L_{used}$ (µm) | $W_{calc}$ (µm) | $W_{round}$ (µm) | Schematic $W\times m$ (µm) | $W_{used}$ (µm) |
| :---: | :--- | ---: | ---: | ---: | :---: | ---: |
| M1/M2 | NMOS input pair | 4.0 | 192.1 | 192 | $100\times4$ | 400 |
| M3/M4 | PMOS active load | 4.0 | 33.5 | 34 | $30\times2$ | 60 |
| M5 | NMOS tail source | 2.0 | 10.0 | 10 | $10\times1$ | 10 |
| M8 | NMOS bias reference | 2.0 | 20.0 | 20 | $20\times1$ | 20 |

The $L=4$ µm input and load devices were chosen because the local lookup tables show higher $g_m/g_{ds}$ at longer length. This improves first-stage gain and matching, but reduces $f_T$ and increases area. M5/M8 use $L=2$ µm to improve current-source output resistance without the large area of a 4-µm mirror. A current density near 2 µA/µm gives $W_8\approx40/2=20$ µm; the 1:2 width ratio then gives $W_5=10$ µm and approximately 20 µA tail current.

### 3.6 First-stage gain estimate

At the selected lookup points,

$$
g_{ds1}=\frac{125.7\ \mu\text{S}}{707.60}=0.178\ \mu\text{S},
$$

$$
g_{m3}=(8)(6.283\ \mu\text{A})=50.27\ \mu\text{S},
\qquad
g_{ds3}=\frac{50.27}{2017.65}=0.0249\ \mu\text{S}.
$$

Thus

$$
A_1\approx\frac{125.7}{0.178+0.0249}
=620.5\ \text{V/V}=55.86\ \text{dB}.
$$

## 4. Second-stage and compensation calculation

### 4.1 Transconductance and current

For the 65° nominal design target,

$$
g_{m2,min}=2\pi(10\ \text{MHz})(10\ \text{pF}+2\ \text{pF})\tan65^\circ
=1.617\ \text{mS}.
$$

Allocate approximately 0.75 mA of the 1.0-mA nominal current target to the second stage. This leaves current for the 40-µA reference, the approximately 20-µA input tail, and bias overhead. With $g_m/I_D\approx8\ \text{V}^{-1}$,

$$
g_{m2,target}\approx(8)(750\ \mu\text{A})
=6.00\ \text{mS}>g_{m2,min}.
$$

At $L=0.5$ µm and $g_m/I_D\approx8\ \text{V}^{-1}$, the lookup tables give $J_P=2.067$ and $J_N=7.241$ µA/µm. Therefore

$$
W_{6,calc}=\frac{750}{2.067}=362.8\ \mu\text{m},
\qquad
W_{7,calc}=\frac{750}{7.241}=103.6\ \mu\text{m}.
$$

The closest integer widths are 363 and 104 µm. The implemented 400-µm PMOS and 100-µm NMOS closely bracket these estimates. The nominal operating point later reports approximately 764.9 µA in the stage, validating the original 0.75-mA allocation. Minimum-length 0.5-µm devices provide current density and speed. Their lower intrinsic gain is acceptable because the long-channel first stage supplies most of the DC gain.

### 4.2 Gain estimate

Using the $L=0.5$ µm lookup values $g_m/g_{ds}=225.52$ for PMOS and 165.52 for NMOS,

$$
A_2\approx
\frac{6.00\ \text{mS}}
{6.00\ \text{mS}/225.52+6.00\ \text{mS}/165.52}
=95.46\ \text{V/V}=39.60\ \text{dB}.
$$

The estimated total gain is

$$
A_0\approx(620.5)(95.46)=5.923\times10^4\ \text{V/V}
=95.45\ \text{dB}.
$$

### 4.3 Pole and phase-margin estimate

$$
f_{p2}\approx\frac{6.00\ \text{mS}}
{2\pi(12\ \text{pF})}=79.58\ \text{MHz},
$$

$$
PM_{2pole}\approx90^\circ-\tan^{-1}\left(\frac{10}{79.58}\right)
=82.84^\circ.
$$

This is a screening bound, not a signoff prediction. At the simulated 12.835-MHz crossover, the same two-pole model gives

$$
PM_{2pole,sim\ f_u}=90^\circ-\tan^{-1}\left(\frac{12.835}{79.58}\right)
=80.84^\circ.
$$

The 21.9-MHz LHP zero contributes about $\tan^{-1}(12.835/21.9)=30.4^\circ$ of lead. The simulated phase margin is 67.767°, so the remaining internal poles contribute about $80.84+30.4-67.767=43.5^\circ$ of lag. Their net effect relative to the two-pole model is 13.07° of additional lag. The analytical model therefore sets the initial sizes; the complete transistor-level return ratio provides final stability signoff.

### 4.4 Nulling resistor

For the conventional series-$R_z$ Miller network, the signed zero is [Geiger, Allen, and Strader, Chapter 6](https://class.ece.iastate.edu/ee508/GAS_book/chap6.pdf)

$$
\omega_z\approx\frac{1}{C_c(1/g_{m2}-R_z)}.
$$

$R_z=1/g_{m2}$ moves the feed-forward zero to infinity; $R_z>1/g_{m2}$ moves it to the left half-plane. Here,

$$
\frac{1}{g_{m2}}\approx167\ \Omega,
$$

while the implemented $R_z\approx3.8$ kΩ gives the first-order estimate

$$
f_z\approx-21.9\ \text{MHz}.
$$

The negative sign denotes a left-half-plane zero. The large difference from $1/g_{m2}$ is intentional lead compensation and is closed by loop simulation, consistent with the compensation principles in [Ahuja's original paper](https://doi.org/10.1109/JSSC.1983.1052012).

The poly resistor uses 1.9 squares: $L/W=7.6/4$. With a nominal 2-kΩ/square layer, this implements approximately 3.8 kΩ. A wider resistor would reduce mismatch and current density but consume more area; the selected 4-µm width is a compact, symmetric value.

### 4.5 Slew-rate check

For a classical Miller-compensated two-stage OTA, the first-stage current limits the large-signal charging rate [Johns and Martin, Chapter 6](https://www.d.umn.edu/~htang/ECE5211_doc_files/ECE5211_files/Chapter6.pdf):

$$
SR\approx\frac{I_{tail}}{C_c}.
$$

The required currents are

$$
I_{tail,rise}\ge(6.5\ \text{V}/\mu\text{s})(2\ \text{pF})=13\ \mu\text{A},
$$

$$
I_{tail,fall}\ge(5.0\ \text{V}/\mu\text{s})(2\ \text{pF})=10\ \mu\text{A}.
$$

The mirrored 20.046-µA tail predicts $SR\approx10.02$ V/µs. The 10-pF output load needs only 65 µA to meet the 6.5-V/µs rise specification, well below the estimated second-stage current.

### 4.6 Complete component-size audit

Choosing 2 pF preserves the slew margin established in Section 2.1 while providing pole splitting. A larger capacitor improves robustness but reduces UGF and slew rate; a smaller capacitor saves area but raises the crossover frequency and stability risk.

| Component | Role | $L_{used}$ (µm) | $W_{calc}$ (µm) | $W_{round}$ (µm) | Schematic geometry | Implemented value |
| :---: | :--- | ---: | ---: | ---: | :---: | ---: |
| M1/M2 | Input transconductance, noise, matching | 4.0 | 192.1 | 192 | $100\ \mu\text{m}\times m4$ | $W_{eff}=400$ µm |
| M3/M4 | First-stage active load | 4.0 | 33.5 | 34 | $30\ \mu\text{m}\times m2$ | $W_{eff}=60$ µm |
| M5 | Tail-current mirror | 2.0 | 10.0 | 10 | $10\ \mu\text{m}\times m1$ | $W_{eff}=10$ µm |
| M8 | 40-µA reference mirror | 2.0 | 20.0 | 20 | $20\ \mu\text{m}\times m1$ | $W_{eff}=20$ µm |
| M6 | Second-stage PMOS | 0.5 | 362.8 | 363 | $50\ \mu\text{m}\times m8$ | $W_{eff}=400$ µm |
| M7 | Second-stage NMOS | 0.5 | 103.6 | 104 | $100\ \mu\text{m}\times m1$ | $W_{eff}=100$ µm |
| $C_c$ | Miller compensation | — | — | — | $31.623\times31.623$ µm MIM | 2.00 pF |
| $R_z$ | LHP-zero placement | 7.6 | 4.0 width | — | 1.9 squares, $m=1$ | 3.8 kΩ |

The passive geometries are calculated directly from the process densities:

| Component | Calculation | Calculated geometry | Implemented geometry |
| :---: | :--- | :---: | :---: |
| $C_c$ | $A=C/2\ \text{fF}/\mu\text{m}^2=1000\ \mu\text{m}^2$ | Square side $31.623$ µm | $31.623\times31.623$ µm |
| $R_z$ | $N_\square=3.8\text{k}/2\text{k}=1.9$; choose $W=4$ µm | $L=1.9(4)=7.6$ µm | $W/L=4/7.6$ µm |

M1/M2 and M3/M4 must be laid out as matched pairs. M5/M8 must preserve the 1:2 mirror ratio. The final widths differ from the first-pass rounded widths only where noise, matching, or output-current margin justified the added area. The square MIM geometry avoids an orientation-dependent aspect ratio; the wide poly resistor reduces current density and matching sensitivity at the cost of area.

### 4.7 Estimate-to-simulation comparison

| Metric | First-order estimate | Nominal simulation | Specification |
| :--- | ---: | ---: | ---: |
| DC gain | 95.45 dB | 96.522 dB | $\ge88$ dB |
| UGF | 10 MHz sizing target | 12.835 MHz | $\ge8$ MHz |
| Phase margin | 80.84° at simulated UGF | 67.767° | $\ge55^\circ$ |
| Slew rate | 10.02 V/µs | 9.814 / 7.966 V/µs | $\ge6.5/5.0$ V/µs |
| Output range | Must be simulated | 0.108–3.235 V | Low $\le0.6$ V; high $\ge2.75$ V |

The gain estimate differs from simulation by 1.07 dB, and the slew estimate tracks the simulated edges. The UGF exceeds its nominal design target. The first-order phase model is 13.07° optimistic at the actual crossover because it omits internal poles and the exact compensation path. The transistor-level loop result is therefore the stability signoff value. The square-law shortcut $V_{OV}\approx2/(g_m/I_D)$ is not used for range signoff because it omits body effect and real terminal-voltage dependence.

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
- M. J. M. Pelgrom, A. C. J. Duinmaijer, and A. P. G. Welbers, “Matching Properties of MOS Transistors,” *IEEE Journal of Solid-State Circuits*, 1989. [DOI: 10.1109/JSSC.1989.572629](https://doi.org/10.1109/JSSC.1989.572629)
- B. K. Ahuja, “An Improved Frequency Compensation Technique for CMOS Operational Amplifiers,” *IEEE Journal of Solid-State Circuits*, 1983. [DOI: 10.1109/JSSC.1983.1052012](https://doi.org/10.1109/JSSC.1983.1052012)
- P. E. Allen, “Compensation of Op Amps—I,” Georgia Institute of Technology, ECE 6412 lecture notes. [PDF](https://www.pallen.ece.gatech.edu/Academic/ECE_6412/Spring_2004/L120-CompOpAmpsI%282UP%29.pdf)
- University of California, Berkeley, “CMOS Op Amp Compensation,” EE 140 Lecture 22. [PDF](https://www-inst.cs.berkeley.edu/~ee140/sp12/lectures/Lec22w.CMOSOpAmpCompensation.ee140.s12.ctn.pdf)
- D. A. Johns and K. Martin, *Analog Integrated Circuit Design*, Chapter 6 course copy hosted by the University of Minnesota Duluth. [PDF](https://www.d.umn.edu/~htang/ECE5211_doc_files/ECE5211_files/Chapter6.pdf)

### Generated artifacts

- [SEOTA analyzer](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/SEOTA_Analyze.m)
- [Nominal and representative-corner results](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/NOM.SEOTA_summary.csv)
- [Full-PVT worst-case results](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_worst_case_report.csv)
- [Representative PVT table](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_table_report.csv)
- [Monte Carlo run summary](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/SEOTA_MC_Run_Summary.csv)
- [MM](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/MM_SEOTA_MC_Summary.csv), [GL](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/GL_SEOTA_MC_Summary.csv), and [FULL](../../Measurement_Results/IC_Simulation/ANALOG_BLOCKS/SEOTA/Reports/FULL_SEOTA_MC_Summary.csv) statistical summaries

## 8. Scope

These are schematic-level results. Layout parasitics, package effects, extracted verification, and measured-silicon behavior are not included.
