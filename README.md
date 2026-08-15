# ECG Acquisition IC

This repository contains the GF180 design and schematic verification work for an ECG acquisition integrated circuit developed in the SSCS Chipathon 2026 flow. The current verified scope includes the bias/reference and selector (`BIAS`/`SEL`), analog building blocks, and fully differential ECG signal path (`PATH`).

> Current stage: pre-layout schematic verification. BIAS/SEL has process, temperature, supply, startup, and selector coverage. The integrated PATH has nominal verification. Layout, extraction, mismatch/Monte Carlo, ADC integration, PCB implementation, and laboratory measurements remain pending.

Detailed architecture, test conditions, formulas, complete results, limitations, and next steps are maintained in [Project_Report.md](Project_Report.md).

## System Summary

![ECG acquisition IC system block diagram](<Design_Files/System Design/System_Block.png>)

The integrated PATH supports two nominal gain modes:

| Mode | Expected gain |
| --- | ---: |
| G2 | 480 V/V (53.625 dB) |
| G16 | 3840 V/V (71.687 dB) |

## Verification Summary

| Area | Current coverage |
| --- | --- |
| BIAS and SEL | NOM/FF/SS/FS/SF, 35 environmental transients, five temperature/VDD surfaces, startup and selector analysis |
| Integrated PATH | Nominal operating point, AC, noise, transient gain, CMRR, PSRR, offset, reset startup, RLD, THD, and SNR |
| SE OTA | Nominal open-loop, closed-loop, noise, CMRR, and PSRR |
| FD OTA and CMFB | Nominal AC, noise, offset, plant, and loop verification |
| Layout and extracted simulation | Not started |
| SAR ADC, PCB, and laboratory testing | Planned |

Headline schematic results:

| Metric | Current result |
| --- | ---: |
| NOM BIAS current | 39.997 uA |
| BIAS current across the 2-D process grids | 31.054-49.441 uA |
| Worst absolute BIAS-current error | 23.603% |
| Worst BIAS startup / failures | 1180.295 us / 0 of 35 |
| Largest selector error | 25.466 nV |
| Last documented PATH current / power | 8.857 mA / 29.23 mW |
| Last documented PATH input noise, 0.05-150 Hz | 3.245 uVrms |
| Last documented PATH RLD suppression at 60 Hz | 20.25 dB |

The NOM BIAS device-vector export and 14-column DC2D export still require refresh. The generated PATH CSVs and plots are currently absent from the worktree and must be regenerated before formal use. See the project report for the exact impact of these limitations.

## Main Entry Points

| Path | Purpose |
| --- | --- |
| `Design_Files/System Design/ECG Acquisition IC with 10-bit SAR ADC SPEC.xlsx` | System specification |
| `Design_Files/IC Design/Schematic/BIAS/BIAS.sch` | Bias-reference generator |
| `Design_Files/IC Design/Schematic/SEL/SEL.sch` | Internal/external reference selector |
| `Design_Files/IC Design/Testbench/BIAS/` | Five-process BIAS characterization testbenches |
| `Measurement_Results/IC_Simulation/BIAS/BIAS_Analyze.m` | BIAS report and plot generator |
| `Design_Files/IC Design/Testbench/PATH/` | Integrated PATH AC, noise, and transient testbenches |
| `Measurement_Results/IC_Simulation/PATH/PATH_Analyze.m` | PATH report and plot generator |
| `Project_Report.md` | Detailed methodology and results |
| `Docker_Instructions.md` | IIC-OSIC-TOOLS setup |

## Run the MATLAB Analyzers

Run the corresponding Xschem/ngspice testbenches first. From the repository root:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"
```

```bash
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','PATH','PATH_Analyze.m'))"
```

The analysis flow has been verified with MATLAB R2025b.

## Generated Data and Git

- Raw simulator `*.txt` exports remain local and are ignored by Git.
- MATLAB analyzers, compact CSV reports, and selected PNG figures are retained as reproducible artifacts when available.
- `.DS_Store` is ignored.
- Regenerate simulator outputs before MATLAB whenever a schematic, condition, clock, or stimulus changes.

## Upstream Chipathon Files

`2026-sscs-chipathon/` is a vendored snapshot of the official [SSCS Chipathon 2026 repository](https://github.com/sscs-ose/sscs-chipathon-2026). It is retained as reference material, not as part of the ECG design source.

It provides participant documentation, schedules, GF180 examples, analog sizing and integration resources, and IIC-OSIC-TOOLS startup scripts. The ECG schematics, testbenches, MATLAB analyzers, and generated results outside this directory are project-specific work.

The bundled upstream files retain their original Apache-2.0 license and attribution. See the bundled [README](2026-sscs-chipathon/README.md), [LICENSE](2026-sscs-chipathon/LICENSE), and [NOTICE](2026-sscs-chipathon/NOTICE).
