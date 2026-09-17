# Output Buffer Verification Report

[← System-level project report](../../Project_Report.md)

## Status

| Item | Status |
| :--- | :---: |
| Schematic | Available |
| Nominal-process voltage/temperature exports | Available |
| Mismatch Monte Carlo export | Available |
| Block analyzer | Pending |
| Formal PVT/MC signoff tables | Pending |
| Generated plots | Pending |

The buffer has raw schematic-level simulation exports, but it does not yet have a block analyzer or formal report. Numerical results are therefore not inferred from the unprocessed files.

## Available deterministic data

The `nom.Result_txt/` directory contains the nine environmental cases `nom`, `vl`, `vh`, `tl`, `th`, `vltl`, `vlth`, `vhtl`, and `vhth` for:

| Analysis | Available quantity |
| :--- | :--- |
| Operating point | Supply, bias, output common mode, and current data |
| Offset sweep | Input-offset zero crossing |
| Differential AC | Closed-loop gain and bandwidth |
| CMRR AC | Common-mode rejection versus frequency |
| PSRR+ / PSRR− AC | Supply rejection versus frequency |
| Noise | Input-referred noise density |
| Selector transient | Functional selector behavior at nominal conditions |

## Available statistical data

The mismatch export [`mm.buffer_mc_summary.txt`](../../Measurement_Results/IC_Simulation/BUFFER/mm.Result_txt/mm.buffer_mc_summary.txt) is present. Global-only and combined FULL Monte Carlo reports have not been generated.

## Design files

- [Buffer schematic image](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/BUFFER/BUFFER.png)
- [Buffer schematic](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/BUFFER/BUFFER.sch)
- [Nominal-process raw exports](../../Measurement_Results/IC_Simulation/BUFFER/nom.Result_txt/)

## Required completion work

1. Implement `BUFFER_Analyze.m` with the same reporting style as LPF and PGA.
2. Run all five process corners across the nine environmental cases.
3. Generate MM, GL, and FULL Monte Carlo summaries.
4. Produce formal comparison, full-PVT, worst-case, and MC tables.
5. Generate differential response, rejection, noise, selector, and MC plots.

No buffer pass/fail claim is made until this work is complete.
