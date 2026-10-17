# Integrated AFE Verification Report

[← System-level project report](../../Project_Report.md)

## Architecture

![Integrated analog front end](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

The integrated analog signal path is:

```text
Electrode input → INA + RLD → LPF → PGA → FDBUF
```

| Stage | Nominal behavior | Detailed report |
| :--- | :---: | :--- |
| INA + RLD | 240 V/V plus input common-mode feedback | [INA + RLD report](INA_RLD_Report.md) |
| LPF | Unity gain; −1 dB frequency ≥150 Hz | [LPF report](LPF_Report.md) |
| PGA | 2/4/8/16 V/V | [PGA report](PGA_Report.md) |
| FDBUF | Unity-gain differential output driver | [FDBUF report](FDBUF_Report.md) |

The programmed signal-path gain is nominally 480, 960, 1920, or 3840 V/V at the FDBUF output.

## Verification status

Updated 2026-10-17. The current AFE measurement folder contains the analyzer but no generated full-chain result tables or plots. This is a coverage statement, not a failed circuit result.

| Item | Status |
| :--- | :---: |
| Top-level schematic | Available |
| MATLAB analyzer | Available; integrated exports pending |
| Full-chain PVT results | Pending |
| Full-chain Monte Carlo | Pending |
| Generated tables and plots | Pending |
| Integrated output-load settling | Pending |

The analyzer is [`AFE_Analyze.m`](../../Measurement_Results/IC_Simulation/AFE_BLOCKS/AFE/AFE_Analyze.m). Its existence does not establish that the integrated simulations have completed.

BIAS and MIRROR now reside under `POWER_BLOCKS`. FDBUF has a complete block analyzer and exported PVT/MC reports for static 40/60/80/100-pF loads. ADC development is outside this report's scope.

## Required system-level measurements

- Programmable differential gain and gain error for every PGA code.
- Passband response, −1 dB frequency, and overall bandwidth.
- Integrated input-referred noise over 0.05–150 Hz.
- CMRR and PSRR at 60 Hz and 150 Hz.
- Output common mode, output swing, and transient settling.
- RLD stability and common-mode suppression in the integrated loop.
- Selector behavior and gain-code switching.
- Settling under the intended integrated output load.

## Design files

- [AFE schematic](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.sch)
- [AFE schematic image](../../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

Integrated verification remains pending. Use the individual block reports for current schematic measurements and specifications.
