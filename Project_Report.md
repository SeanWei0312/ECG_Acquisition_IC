# ECG Analog Front-End Project Report

Updated 2026-10-17 from archived schematic-level analysis exports.

## Scope

This independent GF180MCU project implements an ECG analog front end. Block-level schematic results are available; integrated AFE, extracted-layout, and silicon signoff remain separate work. ADC development is outside the current scope. No simulations were rerun for this report update.

## Architecture

Electrodes → INA + RLD → LPF → PGA → FDBUF. BIAS and MIRROR are shared support circuits under `POWER_BLOCKS`.

Nominal gain is 240 × 1 × {2, 4, 8, 16} × 1 = {480, 960, 1920, 3840} V/V. This is a gain plan, not a measured full-chain transfer.

![AFE](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

## Verification coverage

| Block | Deterministic scope | MC exports | Detailed report |
| :--- | :--- | :--- | :--- |
| BIAS and Mirror | 45 conditions + 50,630 DC points | MM 200/200, 100% / GL 200/200, 100% / FULL 125/200, 62.5% | [Report](Report/POWER_BLOCKS/BIAS_Report.md) |
| SEOTA | 45 conditions | MM 200/200, 100% / GL 200/200, 100% / FULL 200/200, 100% | [Report](Report/ANALOG_BLOCKS/SEOTA_Report.md) |
| FDOTA | 45 conditions | MM 200/200, 100% / GL 200/200, 100% / FULL 200/200, 100% | [Report](Report/ANALOG_BLOCKS/FDOTA_Report.md) |
| INA + RLD | 45 conditions | MM 200/200, 100% / GL 200/200, 100% / FULL 200/200, 100% | [Report](Report/AFE_BLOCKS/INA_RLD_Report.md) |
| LPF | 45 conditions | MM 200/200, 100% / GL 200/200, 100% / FULL 200/200, 100% | [Report](Report/AFE_BLOCKS/LPF_Report.md) |
| PGA | 45 conditions × 4 gains | MM 200/200, 100% / GL 200/200, 100% / FULL 200/200, 100% | [Report](Report/AFE_BLOCKS/PGA_Report.md) |
| FDBUF | 45 conditions × 4 loads | MM 200/200, 100% / GL 200/200, 100% / FULL 200/200, 100% | [Report](Report/AFE_BLOCKS/FDBUF_Report.md) |

MM is local mismatch; GL is global process variation; FULL combines both at the nominal environment. These campaigns do not establish mismatch yield at every extreme PVT corner. The documented passes refer to current exported block limits, not post-layout readiness guarantees.

## Current block results

### BIAS and Mirror

| Parameter | Unit | Spec | NOM | Worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ibias | uA | 40±10 | 40.018 | 49.466 | FFVHTH |
| Mirror error | % | ±1 | -0.003 | 0.149 | FSVLTH |
| Startup time | us |  | 807.522 | 3701.808 | SSVLTL |
| Temperature coefficient | ppm/C |  | 1184.733 | 1235.503 | FFVL sweep |
| Line regulation | %/V |  | 4.293 | 5.322 | SSTL sweep |

[Measurements, plots, and sources](Report/POWER_BLOCKS/BIAS_Report.md)

### SEOTA

| Parameter | Unit | Spec | NOM | Worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| DC gain | dB | ≥88 | 96.522 | 93.985 | FSVLTH |
| UGF | MHz | ≥8 | 12.842 | 8.767 | SSVLTH |
| Phase margin | deg | ≥55 | 67.773 | 56.371 | FFVLTH |
| Input-referred noise 0.05-150 Hz | uVrms | ≤2.5 | 1.873 | 2.189 | SSVLTH |

[Measurements, plots, and sources](Report/ANALOG_BLOCKS/SEOTA_Report.md)

### FDOTA

| Parameter | Unit | Spec | NOM | Worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Differential DC gain | dB | ≥85 | 92.064 | 90.321 | FFVLTH |
| Differential UGF | MHz | ≥8 | 14.586 | 9.415 | SSVLTH |
| Differential phase margin | deg | ≥60 | 77.134 | 69.171 | FFVLTH |
| Output CM error | mV | ±20 | -0.132 | 11.982 | SSVHTH |

[Measurements, plots, and sources](Report/ANALOG_BLOCKS/FDOTA_Report.md)

### INA + RLD

| Parameter | Unit | Spec | NOM | Worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| INA gain error | % | ±0.5 | 0.011 | -0.077 | SSVLTL |
| Input-referred noise 0.05-150 Hz | uVrms | ≤4 | 2.677 | 3.107 | SSVLTH |
| RLD phase margin | deg | ≥60 | 64.006 | 62.118 | SSVLTH |
| Input CM suppression @ 60 Hz | dB | ≥35 | 37.231 | 37.121 | SSVLTL |

[Measurements, plots, and sources](Report/AFE_BLOCKS/INA_RLD_Report.md)

### LPF

| Parameter | Unit | Spec | NOM | Worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Passband gain error | % | ±0.5 | -0.024 | -0.048 | SSVLTL |
| LPF -1 dB frequency | Hz | ≥150 | 258.688 | 174.134 | SSVHTL |
| THD @ 60 Hz, 1.2 Vpp | % | ≤0.05 | 0.004 | 0.006 | SSVHTL |

[Measurements, plots, and sources](Report/AFE_BLOCKS/LPF_Report.md)

### PGA

| Parameter | Unit | Spec | NOM | Worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| G2 gain error | % | ±1 | -0.011 | 0.409 | SSVLTH |
| G2 THD @ 60 Hz, 1.20 Vpp | % | ≤0.05 | 0.015 | 0.023 | FSVLTL |
| G16 input range high | V | ≥0.15 | 0.186 | 0.16 | FSVLTH |

[Measurements, plots, and sources](Report/AFE_BLOCKS/PGA_Report.md)

### FDBUF

| Parameter | Unit | Spec | NOM | Worst | Corner |
| :--- | :--- | :--- | :--- | :--- | :--- |
| CL100 -3 dB bandwidth | MHz |  | 7.334 | 4.757 | SSVLTH |
| CL100 0.05% settling time | us | ≤1 | 0.399 | 0.514 | SSVLTH |
| CL100 Overshoot | % |  | 12.768 | 18.495 | FFVHTL |

[Measurements, plots, and sources](Report/AFE_BLOCKS/FDBUF_Report.md)

## Integrated AFE

The integrated AFE analyzer exists, but its folder contains no generated full-chain results. Individual block passes cannot substitute for integrated gain, noise, RLD stability, or output-load testing.

- [Integrated AFE report](Report/AFE_BLOCKS/AFE_Report.md)
- [Device characterization](Report/SIZING/Gm_Id_Report.md)

## Reproduction and next steps

1. Open the intended `*_PVT_*.sch` or combined `*_MC.sch` file. Regenerate its netlist after every schematic change.
2. Run ngspice to completion and confirm exports belong to the intended process and output directory.
3. Run the block analyzer from its current measurement directory. BIAS now uses `Measurement_Results/IC_Simulation/POWER_BLOCKS/BIAS`.
4. Review missing/invalid data before interpreting PASS or yield.
5. Repeat the established limits with extracted layout, then verify the complete AFE with its intended output load.

Blank Spec cells are characterization only. Preserve them as such; do not add arbitrary limits or claim integrated silicon performance from schematic-only results.
