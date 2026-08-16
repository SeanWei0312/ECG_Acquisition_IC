# ECG Acquisition IC

This repository contains a pre-layout GF180 ECG acquisition IC design developed for the SSCS Chipathon 2026 flow. It includes schematic building blocks, Xschem/ngspice testbenches, MATLAB post-processing, generated circuit reports, and transistor gm/Id characterization data.

The strongest current verification coverage is:

- BIAS/SEL process, supply, temperature, startup, selector, and two-dimensional DC characterization.
- Single-ended OTA open-loop and closed-loop characterization over 45 process/voltage/temperature points.
- Nominal fully differential OTA, differential core, and common-mode feedback characterization.

The integrated AFE schematic and nominal testbenches are present, but their generated CSV reports and plots are not currently in the repository. Layout, extraction, mismatch/Monte Carlo, ADC integration, PCB implementation, and laboratory measurement remain future work.

For methodology, results, limitations, and reproducibility details, see [Project_Report.md](Project_Report.md).

## Architecture

![ECG acquisition IC system block diagram](<Design_Files/System Design/System_Block.png>)

Project-owned schematic blocks include:

| Area | Blocks |
| --- | --- |
| References and selection | BIAS, MIRROR, SEL |
| Amplification and filtering | INA, SE OTA, FD OTA, LPF, PGA, BUFFER |
| Control and support | CMFB, RLD, transmission gates, inverter |
| Integration | AFE top-level schematic |

The 10-bit SAR ADC shown in the system specification is not yet implemented in the verified design.

## Verification Status

| Area | Current evidence |
| --- | --- |
| BIAS/SEL | Generated process/environment tables, 35 startup runs, selector extrema, five process DC surfaces, and six nominal plots |
| SE OTA | Complete 45-point PVT dataset: five processes, nine environmental cases, 450 raw TXT files, compact comparison CSV, full-PVT worst-case CSV, and eight nominal plots |
| FD OTA | Nominal open-loop, closed-loop, CMRR, PSRR, noise, input range, output swing, slew, and settling summary and plots |
| FDC | Nominal differential AC, plant, CMFB sweep, noise, and offset summary and plots |
| CMFB | Nominal open-loop and closed-loop summary and plots |
| AFE | Schematic, AC/noise/transient testbenches, and analyzer source present; generated reports and plots absent |
| gm/Id | NMOS and PMOS sizing scripts plus generated characterization plots |
| Physical verification | Layout, DRC, LVS, extraction, mismatch, and Monte Carlo not completed |

## Headline Results

All values below are deterministic pre-layout schematic simulation results.

| Metric | Result |
| --- | ---: |
| NOM BIAS current | 39.997 uA |
| BIAS full-grid current range | 31.054-49.441 uA |
| Worst BIAS startup / failures | 1180.281 us / 0 of 35 |
| Maximum selector error | 25.466 nV |
| SE OTA NOM gain / UGF / phase margin | 93.850 dB / 12.103 MHz / 70.811 deg |
| SE OTA full-PVT minimum gain | 89.687 dB at FSVLTH |
| SE OTA full-PVT minimum phase margin | 64.399 deg at SSVLTH |
| SE OTA full-PVT maximum input noise, 0.05-150 Hz | 2.188 uVrms at SSVLTH |
| FD OTA NOM gain / UGF / phase margin | 87.191 dB / 12.188 MHz / 72.989 deg |
| FDC NOM gain / UGF / phase margin | 88.362 dB / 12.236 MHz / 72.894 deg |
| CMFB NOM gain / UGF / phase margin | 43.912 dB / 800.932 MHz / 86.428 deg |

## Main Entry Points

| Path | Purpose |
| --- | --- |
| `Design_Files/System Design/ECG Acquisition IC with 10-bit SAR ADC SPEC.xlsx` | System-level specification |
| `Design_Files/System Design/System_Block.png` | Architecture diagram |
| `Design_Files/IC Design/Schematic/` | Project schematic blocks |
| `Design_Files/IC Design/Testbench/` | Xschem/ngspice verification testbenches |
| `Measurement_Results/IC_Simulation/BIAS/BIAS_Analyze.m` | BIAS/SEL characterization and reports |
| `Measurement_Results/IC_Simulation/SE_OTA/SEOTA_Analyze.m` | SE OTA 45-point analysis, reports, and nominal plots |
| `Measurement_Results/IC_Simulation/FD_OTA/` | CMFB, FDC, and FD OTA analyzers and results |
| `Measurement_Results/IC_Simulation/AFE/AFE_Analyze.m` | Integrated AFE analyzer source |
| `Measurement_Results/IC_Simulation/Gm_Id/` | NMOS/PMOS gm/Id sizing data and plots |

## Running MATLAB Analysis

Run the corresponding Xschem/ngspice testbenches before MATLAB. From the repository root:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"
```

```bash
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','SE_OTA','SEOTA_Analyze.m'))"
```

```bash
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','CMFB','CMFB_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDC','FDC_Analyze.m'))"
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA','FDOTA','FDOTA_Analyze.m'))"
```

The current SE OTA analysis has been verified with MATLAB R2026a.

## Generated Data

- Raw ngspice TXT exports are local simulation inputs and may be ignored by Git.
- Generated CSV reports and selected PNG figures provide the reviewable result set.
- Regenerate simulator outputs and MATLAB artifacts together after changing a schematic, model, stimulus, or condition.
- Record schematic revision and report timestamps for formal reviews.

## Current Limitations

- Results are schematic-level and deterministic.
- No mismatch, Monte Carlo, extracted-parasitic, package, or pad verification is included.
- The AFE analyzer has no current generated report set in the repository.
- The SAR ADC is specified but not integrated.
- Layout, PCB, and laboratory validation are not available.

## Upstream Chipathon Material

`2026-sscs-chipathon/` is a vendored reference snapshot of the SSCS Chipathon repository. Project-specific schematics, analyzers, and results are outside that directory. Upstream files retain their original license and attribution; see the bundled `LICENSE` and `NOTICE`.
