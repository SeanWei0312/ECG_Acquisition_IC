# BIAS and Mirror Verification Report

[← Project report](../../Project_Report.md)

## Circuit and role

The master bias core and current mirror provide the reference and distributed bias currents. Their files are maintained under POWER_BLOCKS.

[Circuit schematic](../../Design_Files/IC%20Design/Schematic/POWER_BLOCKS/BIAS/BIAS.sch)

![BIAS](../../Design_Files/IC%20Design/Schematic/POWER_BLOCKS/BIAS/BIAS.png)

[MIRROR schematic](../../Design_Files/IC%20Design/Schematic/POWER_BLOCKS/MIRROR/MIRROR.sch)

![MIRROR](../../Design_Files/IC%20Design/Schematic/POWER_BLOCKS/MIRROR/MIRROR.png)

## Verification snapshot

Updated 2026-10-17 from archived analyzer CSV exports. This documentation update did not rerun simulations.

Blank specification cells mean report-only. Exported worst-case values meet their listed limits; this is pre-layout block verification, not post-layout or silicon signoff.

Startup coverage is 45/45; actual startup failures are 0 among 45 completed cases. The separate DC grid contains 50,630 points.

The BIAS core produces BP; MIRROR distributes the current. VREF is not part of this block. Total current includes the instantiated testbench load.

Nominal columns refer to NOM process, 3.3 V, and 27°C. Compact corner names encode process, supply, and temperature. Sweep labels identify a fixed supply or temperature rather than a single corner.

TC uses the full −40–125°C current range normalized to the 27°C current; line regulation uses the 3.0–3.6 V current range normalized to the 3.3 V current. Comparison TC/LR use 3.3 V/27°C. Worst cases search 15 temperature and 15 supply sweeps.

These are range-over-span metrics, not fitted local derivatives. The normalization is identical for every slice:

$$
TC=\frac{I_{\max,T}-I_{\min,T}}{I(27^\circ\mathrm C)\,(165^\circ\mathrm C)}10^6,
\qquad
LR=\frac{I_{\max,V}-I_{\min,V}}{I(3.3\,\mathrm V)\,(0.6\,\mathrm V)}100.
$$

The Ibias worst case is selected by the greatest absolute deviation from 40 µA, not automatically by the highest current. BP uses the minimum exported voltage; MST margin uses the minimum; mirror error uses the maximum magnitude.

### Operating point and mirroring

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ibias | uA | 40±10 | 40.018 | 49.466 | FFVHTH |
| Total current | uA |  | 119.978 | 148.377 | FFVHTH |
| Total power | uW |  | 395.928 | 534.156 | FFVHTH |
| BP | V |  | 1.642 | 1.137 | FSVLTH |
| Mirror error | % | ±1 | -0.003 | 0.149 | FSVLTH |
| MST margin | V | >0 | 1.541 | 0.742 | FFVHTH |

Nominal schematic response. The adjacent table gives the corresponding exported measurements.

![NOM BIAS 2D](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_2D.png)

### Startup and selector

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Startup time | us |  | 807.522 | 3701.808 | SSVLTL |

Startup time: nominal 807.522 us; full-PVT worst 3701.808 us at `SSVLTL`.

![NOM BIAS STARTUP](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_STARTUP.png)

Startup time: nominal 807.522 us; full-PVT worst 3701.808 us at `SSVLTL`.

![NOM BIAS STARTUP VOLTAGE](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_STARTUP_VOLTAGE.png)

Nominal selector waveform; functional illustration, not a separate electrical pass/fail limit.

![NOM BIAS SEL](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_SEL.png)

### Reference quality

| Parameter | Unit | Spec | NOM | Full-PVT worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Temperature coefficient | ppm/C |  | 1184.733 | 1235.503 | FFVL sweep |
| Line regulation | %/V |  | 4.293 | 5.322 | SSTL sweep |

Temperature coefficient: nominal 1184.733 ppm/C; full-PVT worst 1235.503 ppm/C at `FFVL sweep`.

![NOM BIAS TEMP](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_TEMP.png)

Line regulation: nominal 4.293 %/V; full-PVT worst 5.322 %/V at `SSTL sweep`.

![NOM BIAS VDD](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/NOM_BIAS_VDD.png)

Selector checks are report-only. The current archived extrema are:

| Quantity | Value | Unit | Process | Condition |
| :--- | :--- | :--- | :--- | :--- |
| Maximum \|BP INT SEL error\| | 9.467e-01 | nV | SF | VH |
| Maximum \|BP EXT SEL error\| | 2.445 | nV | SS | VL |

## Monte Carlo verification

MM applies local mismatch; GL applies global variation; FULL combines both. These are nominal-supply/temperature MC campaigns, not combined worst-PVT-plus-mismatch yield.

| Mode | Requested | Valid | Failed | Overall yield |
| :--- | :--- | :--- | :--- | :--- |
| MM | 200 | 200 | 0 | 100% |
| GL | 200 | 200 | 0 | 100% |
| FULL | 200 | 125 | 75 | 62.5% |

“Failed” is the analyzer’s exported non-valid count; it may include missing or invalid measurements and must not automatically be interpreted as demonstrated circuit failures. Sample yield applies only to measured MC metrics, not production yield.

This archived MC report is incomplete. Do not claim full MC signoff; finish or validate the exports and rerun the existing analyzer before regenerating this report.

### FULL sampled statistics

| Parameter | Unit | Spec | Min | Mean | Max | Yield |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Ibias | uA | 40±10 | 38.639 | 40.09 | 41.785 | 62.5% |
| Total current | uA |  | 115.838 | 120.186 | 125.113 |  |
| BP | V |  | 1.554 | 1.643 | 1.73 |  |
| Mirror error | % | ±1 | -0.467 | 0.024 | 0.431 | 62.5% |
| MST margin | V | >0 | 1.356 | 1.535 | 1.735 | 62.5% |
| Startup time | us |  | 784.605 | 808.316 | 849.014 |  |
| Startup success |  | PASS | 1 | 1 | 1 | 62.5% |

The source CSVs retain μ±σ and μ±3σ. Those statistical extrapolations are not additional simulated extrema.

FULL Ibias: 38.639 to 41.785 uA; mean 40.09 uA.

![Fig MC 01 Ibias Histogram](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/Fig_MC_01_Ibias_Histogram.png)

FULL Startup time: 784.605 to 849.014 us; mean 808.316 us.

![Fig MC 02 Startup Histogram](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Plots/Fig_MC_02_Startup_Histogram.png)

## Sources and reproduction

- [MATLAB analyzer](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/BIAS_Analyze.m)
- [Representative-corner comparison](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Reports/BIAS_comparison_report.csv)
- [Full-PVT worst cases](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Reports/BIAS_worst_case_report.csv)
- [MM statistics](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Reports/MM_MC_Summary.csv)
- [GL statistics](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Reports/GL_MC_Summary.csv)
- [FULL statistics](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Reports/FULL_MC_Summary.csv)
- [MC coverage and yield](../../Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS/Reports/MC_Run_Summary.csv)
- [Xschem testbenches](../../Design_Files/IC%20Design/Testbench/POWER_BLOCKS/BIAS)

Regenerate SPICE netlists after schematic edits, finish the simulation jobs, then run the analyzer from its own directory. MATLAB reads exports; it does not launch ngspice.

## Scope and next checks

These results exclude extracted parasitics, package effects, switched-ADC loading, and silicon measurements. Repeat the same limits after layout; do not infer integrated AFE signoff from individual block passes.
