# ECG Acquisition IC

This repository contains the design and verification work for a GF180 ECG acquisition integrated circuit developed for the SSCS Chipathon 2026 flow. The current verified scope includes the bias/reference and internal/external selection block (`BIAS`) and the fully differential analog signal path (`PATH`), together with device characterization, amplifier and common-mode building blocks, Xschem/ngspice testbenches, MATLAB post-processing, and schematic-level results.

> Current status: pre-layout schematic verification. BIAS has process, temperature, supply, startup, and selector coverage; PATH remains nominal. Extracted verification, Monte Carlo coverage, PCB implementation, ADC integration, and laboratory measurements are still pending.

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
| Bias reference and selector | PVT simulation implemented | Five process corners, 35 environmental transients, five temperature/supply grids, MATLAB reports, and NOM plots are present; the NOM device-vector export still needs refresh. |
| Integrated ECG path | Nominal simulation flow implemented | AC, noise, transient, offset, startup, RLD, THD, and SNR testbenches/analyzers are implemented; generated PATH CSVs and plots currently need regeneration. |
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
| `Design_Files/IC Design/Schematic/BIAS/BIAS.sch` | Bias-reference generator; produces internal BP and VREF references. |
| `Design_Files/IC Design/Testbench/BIAS/BIAS_TB_{NOM,FF,SS,FS,SF}.sch` | BIAS process, environmental transient, selector, and 2-D temperature/supply testbenches. |
| `Measurement_Results/IC_Simulation/BIAS/BIAS_Analyze.m` | Five-process BIAS analyzer, report generator, and NOM plot generator. |
| `Measurement_Results/IC_Simulation/BIAS/BIAS_table_report.csv` | Compact BIAS operating-point and startup table for process and NOM environmental cases. |
| `Measurement_Results/IC_Simulation/BIAS/BIAS_global_worst_case.csv` | Global BIAS extrema with process, temperature, and supply locations. |
| `Measurement_Results/IC_Simulation/BIAS/Plots/` | Six current NOM BIAS figures, including startup, selector, sweeps, and the 2-D error heat map. |
| `Design_Files/IC Design/Testbench/PATH/AC/PATH_TB_AC.sch` | PATH operating-point, differential AC, CMRR, and PSRR testbench. |
| `Design_Files/IC Design/Testbench/PATH/NOISE/PATH_TB_NOISE.sch` | PATH input/output-noise testbench. |
| `Design_Files/IC Design/Testbench/PATH/TRAN/PATH_TB_TRAN.sch` | PATH differential, rejection, offset, startup, RLD, and THD transient testbench. |
| `Measurement_Results/IC_Simulation/PATH/PATH_Analyze.m` | Main MATLAB analyzer, plot generator, and report generator. |
| `Measurement_Results/IC_Simulation/PATH/PATH_summary.csv` | Generated complete machine-readable PATH result summary. |
| `Measurement_Results/IC_Simulation/PATH/PATH_table_report.csv` | Generated compact G2/G16/RLD/THD report without a category column. |
| `Measurement_Results/IC_Simulation/PATH/Plots/` | Generated PATH figure directory. |
| `Project_Report.md` | Verification methodology, current results, limitations, and next steps. |

## BIAS Characterization

`BIAS` generates `BPINT` and `VREFINT`. The separate selector chooses the internal or external references presented at `BP` and `VREF`:

```text
BIAS: BPINT/VREFINT ----+
                        +--> SEL --> BP/VREF
External: BPEXT/VREFEXT +
```

The automated flow analyzes five process corners (`NOM`, `FF`, `SS`, `FS`, and `SF`). Each process has seven 10 ms transient conditions:

| Condition | Temperature | VDD |
| --- | ---: | ---: |
| NOM | 27 C | 3.3 V |
| VL | 27 C | 3.0 V |
| VH | 27 C | 3.6 V |
| TL | -40 C | 3.3 V |
| TH | 125 C | 3.3 V |
| TLVL | -40 C | 3.0 V |
| THVH | 125 C | 3.6 V |

This produces 35 startup and selector runs. Every process also has a 2-D DC sweep from -40 C to 125 C in 1 C steps and from 3.0 V to 3.6 V in 10 mV steps, for 10,126 coordinate pairs per process. The analyzer uses the final 10% of the initial internal-selection plateau for settled values. Startup is measured from the 100 us VDD-ramp start to permanent entry within 90-110% of the run's own settled bias current before the first selector transition.

The first report table uses the columns `NOM FF SS FS SF VL VH TL TH`. The process columns use nominal conditions; VL/VH/TL/TH use the corresponding NOM-process transient runs. TLVL and THVH remain in the complete startup matrix and selector search.

Current BIAS highlights from the generated CSV reports are:

| Metric | Result |
| --- | ---: |
| NOM bias current | 39.997 uA |
| NOM bias-current error | -0.007499% |
| Worst startup time | 1180.295 us, SS/TLVL (-40 C, 3.0 V) |
| Startup failures | 0 / 35 |
| 2-D bias-current range | 31.054-49.441 uA |
| Worst absolute bias-current error | 23.603%, FF/125 C/3.6 V |
| Maximum absolute VREF error | 6.155 uV |
| Maximum absolute mirror error | 0.149% |
| Minimum reported MST margin | 0.7415 V |
| Maximum BIAS+SEL current / power | 103.971 uA / 374.297 uW |
| Largest selector error | 25.466 nV |

Two NOM export limitations remain visible by design. The seven NOM transient files contain constant `IRS`, `IMST`, `VGS_MST`, and `VTH_MST` exports, so their final scalar values can be reported but the NOM IMST startup waveform cannot. `NOM.dc2d.txt` is still the legacy 12-column format, so NOM mirror-error, IMST, and MST-margin sweep extrema are unavailable; the corresponding global extrema currently come from FF/SS/FS/SF only.

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

## Run the Verification Flows

### BIAS

1. Run `BIAS_TB_NOM.sch`, `BIAS_TB_FF.sch`, `BIAS_TB_SS.sch`, `BIAS_TB_FS.sch`, and `BIAS_TB_SF.sch` in Xschem/ngspice. Each testbench writes seven transient files and one 2-D DC file under its process result directory.
2. From the repository root, run the function-based MATLAB analyzer:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"
```

The BIAS analyzer prints the operating-point, 35-run startup, selector, 2-D PVT, global-worst-case, and reference-quality tables. It writes seven CSV reports:

- `BIAS_table_report.csv`
- `BIAS_startup_report.csv`
- `BIAS_startup_summary.csv`
- `BIAS_sel_report.csv`
- `BIAS_dc2d_report.csv`
- `BIAS_global_worst_case.csv`
- `BIAS_reference_report.csv`

It also generates six NOM figures: startup current, startup voltage, selector operation, current versus temperature, current versus VDD, and a signed bias-current-error heat map with contour lines.

### PATH

1. Start the IIC-OSIC-TOOLS environment using [Docker_Instructions.md](Docker_Instructions.md). The repository is expected under `/foss/designs/ECG_Acquisition_IC/` inside the container.
2. Run the PATH AC, noise, and transient Xschem/ngspice testbenches. They write raw data under `Measurement_Results/IC_Simulation/PATH/NOM.Result_txt/`.
3. From the repository root, run the MATLAB post-processor:

```bash
matlab -batch "run(fullfile(pwd,'Measurement_Results','IC_Simulation','PATH','PATH_Analyze.m'))"
```

The MATLAB flows have been verified with R2025b. The PATH analyzer prints a compact terminal table and regenerates:

- `PATH_summary.csv`: full operating-point, AC, noise, transient, offset, startup, RLD, and THD metrics.
- `PATH_table_report.csv`: concise G2, G16, RLD, and 60 Hz THD/SNR rows.
- `Plots/*.png`: differential response, CMRR, PSRR, noise, offset, startup, RLD, and THD figures.

## Latest Nominal PATH Highlights

These values are retained from the last documented `PATH_table_report.csv` result set and are schematic-level nominal results, not silicon specifications. The generated PATH CSVs and plots are currently absent from the worktree and must be regenerated before formal use.

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
- MATLAB source, BIAS CSV summaries, and BIAS PNG plots are retained as current reproducible artifacts; PATH CSVs and figures are regenerated from the local raw data as needed.
- `.DS_Store` is ignored; macOS Finder may recreate it locally without affecting Git.
- Re-run the testbenches before MATLAB whenever the schematic, clock, stimulus, or cycle schedule changes.

## Upstream Chipathon Files

The workshop material under `2026-sscs-chipathon/` comes from [sscs-ose/sscs-chipathon-2026](https://github.com/sscs-ose/sscs-chipathon-2026) and provides the examples, resources, and IIC-OSIC-TOOLS environment used by this project.
