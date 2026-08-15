# ECG Acquisition IC

This repository contains the design and verification work for a GF180 ECG acquisition integrated circuit developed for the SSCS Chipathon 2026 flow. The current focus is the fully differential analog signal path (`PATH`): device characterization, amplifier and common-mode building blocks, the integrated ECG front end, Xschem/ngspice testbenches, MATLAB post-processing, and nominal schematic-level results.

> Current status: nominal, pre-layout schematic verification. Layout, extracted verification, PVT/Monte Carlo coverage, PCB implementation, ADC integration, and laboratory measurements are still pending.

## Signal Path

The integrated path contains the INA, switched filter/selection network, PGA, output buffer, and right-leg-drive feedback:

```text
VINP/VINN -> INA -> selection/filter path -> PGA -> output buffer -> OUTP/OUTN
     |                                                               |
     +-------------------------- RLD feedback ------------------------+
```

The nominal differential gain used by the testbench and analyzer is:

```text
Aexpected = 60 x 4 x PGA gain
```

| Gain mode | PGA gain | Expected path gain | Expected gain |
| --- | ---: | ---: | ---: |
| G2 | 2 | 480 V/V | 53.625 dB |
| G16 | 16 | 3840 V/V | 71.687 dB |

The testbenches use a 3.3 V supply, 1.65 V input/output common-mode target, 40 uA bias parameter, 10 pF load per output, and a 500 Hz switched-capacitor clock.

## Current Design Status

| Area | Status | Evidence in this repository |
| --- | --- | --- |
| System architecture | In progress | ECG block diagram and specification workbook are present. |
| GF180 device characterization | Implemented | NMOS/PMOS Gm/Id testbenches, MATLAB scripts, and plots are present. |
| Single-ended OTA | Nominal simulation complete | Open-loop, closed-loop, noise, CMRR, and PSRR results are present. |
| Fully differential OTA and CMFB | Nominal simulation complete | FDC, CMFB, and FDOTA schematics, analyzers, summaries, and plots are present. |
| Integrated ECG path | Nominal simulation in progress | AC, noise, transient, offset, startup, RLD, THD, and SNR tests are implemented. |
| IC layout and extracted simulation | Not started | Layout directory exists; no completed PATH layout is reported. |
| SAR ADC integration | Planned | System specification references a 10-bit SAR ADC; circuit integration is pending. |
| PCB and measurement | Not started | PCB and measurement directories are placeholders for later work. |

## Repository Structure

```text
.
├── 2026-sscs-chipathon/            # Upstream workshop material
├── Design_Files/
│   ├── System Design/              # Specification and block diagram
│   ├── IC Design/
│   │   ├── Schematic/              # INA, LPF, PGA, OTAs, CMFB, RLD, etc.
│   │   ├── Testbench/              # Device, block, and integrated PATH tests
│   │   └── Layout/
│   └── PCB Design/
├── Measurement_Results/
│   ├── IC_Simulation/              # MATLAB analyzers, CSV summaries, and plots
│   ├── PCB_Simulation/
│   └── Test_Measurement/
├── Docker_Instructions.md
├── Project_Report.md
└── README.md
```

## Key Files

| Path | Purpose |
| --- | --- |
| `Design_Files/System Design/System_Block.drawio` | Editable system block diagram. |
| `Design_Files/System Design/ECG Acquisition IC with 10-bit SAR ADC SPEC.xlsx` | System-level specification workbook. |
| `Design_Files/IC Design/Schematic/` | Analog building-block schematics and symbols. |
| `Design_Files/IC Design/Testbench/PATH/AC/PATH_TB_AC.sch` | PATH operating-point, differential AC, CMRR, and PSRR testbench. |
| `Design_Files/IC Design/Testbench/PATH/NOISE/PATH_TB_NOISE.sch` | PATH input/output-noise testbench. |
| `Design_Files/IC Design/Testbench/PATH/TRAN/PATH_TB_TRAN.sch` | PATH differential, rejection, offset, startup, RLD, and THD transient testbench. |
| `Measurement_Results/IC_Simulation/PATH/PATH_Analyze.m` | Main MATLAB analyzer, plot generator, and report generator. |
| `Measurement_Results/IC_Simulation/PATH/PATH_summary.csv` | Complete machine-readable PATH result summary. |
| `Measurement_Results/IC_Simulation/PATH/PATH_table_report.csv` | Compact G2/G16/RLD/THD report without a category column. |
| `Measurement_Results/IC_Simulation/PATH/Plots/` | Current generated PATH figures. |
| `Project_Report.md` | Verification methodology, current results, limitations, and next steps. |

## PATH Transient Settings

The normal clock is 500 Hz (`T = 2 ms`) with 80 us rise/fall times and a 920 us pulse width. THD uses the same clock frequency with 20 us rise/fall times and a 980 us pulse width. The differential sweep uses a 10 uV peak differential sine input.

| Differential frequency | Simulated cycles after the 100 ms signal delay | MATLAB window |
| ---: | ---: | ---: |
| 0.05 Hz | 2 | final 1 cycle |
| 0.1 Hz | 4 | final 1 cycle |
| 0.5 Hz | 4 | final 1 cycle |
| 1 Hz | 4 | final 3 cycles |
| 10 Hz | 4 | final 3 cycles |
| 60 Hz | 11 | final 10 cycles |
| 150 Hz | 11 | final 10 cycles |
| 250 Hz | 11 | final 10 cycles |
| 500 Hz | 21 | final 20 cycles |
| 1 kHz | 21 | final 20 cycles |

| Test | Frequencies | Simulated cycles | MATLAB window |
| --- | --- | ---: | ---: |
| CMRR | 60, 150, 250, 500 Hz, 1 kHz | 31 | final 20 cycles |
| PSRR+ / PSRR- | 60, 150, 250, 500 Hz, 1 kHz | 31 | final 20 cycles |
| VCM and differential offset | 60 Hz | 12 driven cycles | final 10 cycles |
| RLD off/on | 60 Hz | 12 driven cycles | final 10 cycles |
| THD | 60 and 150 Hz | 31 | final 30 cycles |
| Startup with/without reset | No sine-cycle rule | 200 ms time-domain run | settling criteria |

## Run the Verification Flow

1. Start the IIC-OSIC-TOOLS environment using [Docker_Instructions.md](Docker_Instructions.md). The repository is expected under `/foss/designs/ECG_Acquisition_IC/` inside the container.
2. Run the PATH AC, noise, and transient Xschem/ngspice testbenches. They write raw data under `Measurement_Results/IC_Simulation/PATH/NOM.Result_txt/`.
3. From the repository root, run the MATLAB post-processor:

```bash
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','PATH','PATH_Analyze.m'))"
```

The MATLAB flow has been verified with R2025b. It prints a compact terminal table and regenerates:

- `PATH_summary.csv`: full operating-point, AC, noise, transient, offset, startup, RLD, and THD metrics.
- `PATH_table_report.csv`: concise G2, G16, RLD, and 60 Hz THD/SNR rows.
- `Plots/*.png`: differential response, CMRR, PSRR, noise, offset, startup, RLD, and THD figures.

## Latest Nominal PATH Highlights

These values come from the checked-in `PATH_table_report.csv` and are schematic-level nominal results, not silicon specifications.

| Metric | G2 | G16 |
| --- | ---: | ---: |
| Total current | 8.857 mA | 8.857 mA |
| Total power | 29.23 mW | 29.23 mW |
| AC gain error at 60 Hz | -6.87% | -11.74% |
| Transient gain error at 60 Hz | -7.14% | -11.97% |
| AC CMRR at 60 Hz | 147.64 dB | 153.45 dB |
| AC PSRR+ at 60 Hz | 110.20 dB | 110.52 dB |
| AC PSRR- at 60 Hz | 110.20 dB | 110.52 dB |
| Input-referred noise, 0.05-150 Hz | 3.245 uVrms | 3.245 uVrms |

Additional current results include 20.25 dB RLD input-common-mode suppression and 60 Hz THD/SNR of 0.09545% / 34.24 dB for 0.5 mVpp at G16 and 0.08572% / 54.48 dB for 5 mVpp at G2.

The 0.05 Hz transient gain is currently much lower than the ordinary AC result (approximately -99.7% gain error for both gains). Because the PATH is periodically switched, ordinary AC analysis and transient sine fitting do not represent the same system. This low-frequency discrepancy remains an open validation item and must not be treated as final performance.

## Generated Data and Git

- Raw `*.txt` simulator exports are intentionally ignored by Git and remain local.
- MATLAB source, compact CSV summaries, and selected PNG plots are retained as reproducible project artifacts.
- `.DS_Store` is ignored; macOS Finder may recreate it locally without affecting Git.
- Re-run the testbenches before MATLAB whenever the schematic, clock, stimulus, or cycle schedule changes.

## Upstream Chipathon Files

The workshop material under `2026-sscs-chipathon/` comes from [sscs-ose/sscs-chipathon-2026](https://github.com/sscs-ose/sscs-chipathon-2026) and provides the examples, resources, and IIC-OSIC-TOOLS environment used by this project.
