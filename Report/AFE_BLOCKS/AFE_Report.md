# Integrated AFE Verification Report

[← System-level project report](Project_Report.md)

## Architecture

![Integrated analog front end](../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

The integrated analog signal path is:

```text
Electrode input → INA + RLD → LPF → PGA → BUFFER → ADC interface
```

| Stage | Nominal behavior | Detailed report |
| :--- | :---: | :--- |
| INA + RLD | 240 V/V plus input common-mode feedback | [INA + RLD report](INA_RLD_Report.md) |
| LPF | Unity gain; −1 dB frequency ≥150 Hz | [LPF report](LPF_Report.md) |
| PGA | 2/4/8/16 V/V | [PGA report](PGA_Report.md) |
| Buffer | Unity-gain differential output driver | [Buffer report](BUFFER_Report.md) |

The programmed signal-path gain is nominally 480, 960, 1920, or 3840 V/V before the ADC interface.

## Verification status

| Item | Status |
| :--- | :---: |
| Top-level schematic | Available |
| Analyzer scaffold | Available |
| Full-chain PVT results | Pending |
| Full-chain Monte Carlo | Pending |
| Generated tables and plots | Pending |
| ADC-load settling verification | Pending |

The analyzer scaffold is [`AFE_Analyze.m`](../Measurement_Results/IC_Simulation/AFE/AFE_Analyze.m). No formal integrated result is reported until full-chain simulations are available.

## Required system-level measurements

- Programmable differential gain and gain error for every PGA code.
- Passband response, −1 dB frequency, and overall bandwidth.
- Integrated input-referred noise over 0.05–150 Hz.
- CMRR and PSRR at 60 Hz and 150 Hz.
- Output common mode, output swing, and transient settling.
- RLD stability and common-mode suppression in the integrated loop.
- Selector behavior and gain-code switching.
- Settling while driving the SAR ADC input capacitance.

## Design files

- [AFE schematic](../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.sch)
- [AFE schematic image](../Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

This report intentionally contains no fabricated tables or plots; integrated verification remains pending.
