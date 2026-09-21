# ECG Acquisition IC

A self-directed, independent pre-layout ECG acquisition IC combining an analog front end (AFE) and SAR ADC, implemented in the GlobalFoundries 180 nm MCU process.

The repository contains transistor-level Xschem designs, ngspice verification testbenches, MATLAB analysis scripts, generated PVT/Monte Carlo reports, and $g_m/I_D$ characterization utilities.

> [!IMPORTANT]
> This project uses the IEEE SSCS 2026 Chipathon simulation environment and design flow only as a technical reference. It is not an official program submission, is not affiliated with the program, and will not be taped out through it.

> [!NOTE]
> Results in this repository are schematic-level simulations. Layout, LVS/DRC, parasitic extraction, top-level post-layout verification, and silicon measurements remain future work.

## Architecture

![ECG analog front end](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

| Stage | Block | Function | Nominal transfer |
| :--- | :--- | :--- | :---: |
| 1 | [`INA`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/INA/) | Three-amplifier instrumentation front end | $240\text{ V/V}$ |
| 2 | [`LPF`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/LPF/) | Fully differential, unity-gain active low-pass filter | $1\text{ V/V}$; $f_{-1\mathrm{dB}} \ge 150\text{ Hz}$ |
| 3 | [`PGA`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/PGA/) | Digitally programmable differential gain | $2/4/8/16\text{ V/V}$ |
| 4 | [`FDBUF`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/FDBUF/) | Differential output driver | $1\text{ V/V}$ |
| 5 | [`SAR_ADC`](Design_Files/IC%20Design/Schematic/SAR_ADC_BLOCKS/SAR_ADC/) | Differential successive-approximation data conversion | Verification pending |
| Feedback | [`RLD`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/RLD/) | Input common-mode suppression | $55.1\text{ dB}$ at 60 Hz nominal |
| Support | [`BIAS`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/BIAS/) / [`MIRROR`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/MIRROR/) | Master reference and bias distribution | $40\,\mu\text{A}$ target |

The verified block-level gain plan gives nominal signal-path gains from $480$ to $3840\text{ V/V}$ ($53.6$ to $71.7\text{ dB}$) before ADC integration.

## Verification status

Deterministic verification uses 45 corners: five process models (`NOM`, `FF`, `SS`, `FS`, and `SF`) across nine voltage/temperature conditions. Statistical verification uses 200-run mismatch-only (MM), global-only (GL), and combined (FULL) Monte Carlo sets.

| Block | Deterministic verification | Monte Carlo | Status |
| :--- | :--- | :--- | :---: |
| [BIAS / SEL](Report/AFE_BLOCKS/BIAS_Report.md) | PVT, voltage/temperature surface, startup, selector transient | — | Complete |
| [SE OTA](Report/AFE_BLOCKS/SEOTA_Report.md) | 45-corner PVT | MM / GL / FULL | Pass |
| [FD OTA](Report/AFE_BLOCKS/FDOTA_Report.md) | 45-corner PVT | MM / GL / FULL | Pass |
| [INA + RLD](Report/AFE_BLOCKS/INA_RLD_Report.md) | 45-corner balanced PVT, mismatch stress, selector transient | MM / GL / FULL | Pass |
| [LPF](Report/AFE_BLOCKS/LPF_Report.md) | 45-corner PVT, selector transient | MM / GL / FULL | Pass |
| [PGA](Report/AFE_BLOCKS/PGA_Report.md) | 45-corner PVT, selector and gain-code transients | MM / GL / FULL | Pass |
| [FDBUF](Report/AFE_BLOCKS/FDBUF_Report.md) | Raw simulation exports available | MM export available | Analysis pending |
| [Integrated AFE](Report/AFE_BLOCKS/AFE_Report.md) | Top-level schematic and analyzer scaffold | — | Integration pending |
| [SAR ADC](Report/SAR_ADC_BLOCKS/SAR_ADC_Report.md) | Complete schematic hierarchy | — | Verification pending |

All completed MM, GL, and FULL analyses contain 200 valid runs, zero failed runs, and 100% joint yield against the current pre-layout specifications.

## Headline results

| Block | Metric | Nominal | Full 45-corner range | Specification |
| :--- | :--- | ---: | ---: | ---: |
| SE OTA | DC gain | 96.522 dB | 93.988–97.180 dB | $\ge 88\text{ dB}$ |
|  | UGF | 12.835 MHz | 8.762–16.895 MHz | $\ge 8\text{ MHz}$ |
|  | Phase margin | 67.767° | 56.368–77.712° | $\ge 55°$ |
|  | Input noise, 0.05–150 Hz | 1.873 µVrms | 1.687–2.189 µVrms | $\le 2.5\text{ µVrms}$ |
| FD OTA | Differential gain | 88.699 dB | 86.753–89.804 dB | $\ge 85\text{ dB}$ |
|  | Differential UGF | 12.447 MHz | 8.435–16.195 MHz | $\ge 8\text{ MHz}$ |
|  | Differential phase margin | 72.649° | 63.377–79.898° | $\ge 60°$ |
|  | Input noise, 0.05–150 Hz | 3.086 µVrms | 2.815–3.514 µVrms | $\le 4\text{ µVrms}$ |
| INA + RLD | INA gain error | 0.011% | −0.215% to +0.140% | ±0.5% |
|  | INA bandwidth | 259.286 kHz | 176.996–346.567 kHz | $\ge 150\text{ kHz}$ |
|  | Input noise, 0.05–150 Hz | 2.667 µVrms | 2.402–3.117 µVrms | $\le 4\text{ µVrms}$ |
|  | CM suppression, 60 / 150 Hz | 55.072 / 53.257 dB | 54.644–55.305 / 51.676–54.363 dB | $\ge 50/45\text{ dB}$ |
| LPF | Passband gain error | −0.027% | −0.050% to −0.016% | ±0.5% |
|  | −1 dB frequency | 258.691 Hz | 174.135–410.798 Hz | $\ge 150\text{ Hz}$ |
|  | Input noise, 0.05–150 Hz | 6.176 µVrms | 5.632–7.036 µVrms | $\le 10\text{ µVrms}$ |
| PGA | Gain error, all codes | 0.751 / −0.236 / −0.522 / −0.878% | −0.932% to +2.502% | ±5% |
|  | Bandwidth, all codes | 0.907–5.053 MHz | 0.595–6.988 MHz | $\ge 0.15\text{ MHz}$ |
|  | Input noise, all codes | 3.280–4.617 µVrms | 2.992–5.250 µVrms | $\le 10\text{ µVrms}$ |

The block reports include selected results for all 45 PVT corners; their long-form CSV files remain the authoritative source for every reported parameter. See the [system report](Project_Report.md) for architecture, verification methodology, AFE–ADC integration status, and the complete report index.

## Repository layout

```text
ECG_Acquisition_IC/
├── README.md
├── Docker_Instructions.md
├── Project_Report.md                    # System-level AFE and ADC report
├── Report/                              # Detailed block reports
│   ├── AFE_BLOCKS/
│   │   ├── AFE_Report.md
│   │   ├── BIAS_Report.md
│   │   ├── FDBUF_Report.md
│   │   ├── FDOTA_Report.md
│   │   ├── INA_RLD_Report.md
│   │   ├── LPF_Report.md
│   │   ├── PGA_Report.md
│   │   └── SEOTA_Report.md
│   ├── SAR_ADC_BLOCKS/
│   │   └── SAR_ADC_Report.md
│   └── SIZING/
│       └── Gm_Id_Report.md
├── Design_Files/
│   └── IC Design/
│       ├── Layout/                         # Physical-design workspace
│       ├── Schematic/
│       │   ├── AFE_BLOCKS/                 # Analog-front-end hierarchy
│       │   │   ├── AFE/
│       │   │   ├── BIAS/
│       │   │   ├── FDBUF/
│       │   │   ├── INA/
│       │   │   ├── LPF/
│       │   │   ├── MIRROR/
│       │   │   ├── PGA/
│       │   │   └── RLD/
│       │   ├── ANALOG_BLOCKS/
│       │   │   ├── FDOTA/
│       │   │   └── SEOTA/
│       │   ├── DIGITAL_BLOCKS/
│       │   │   ├── INV/
│       │   │   ├── MUX/
│       │   │   ├── MUXD/
│       │   │   └── TG/
│       │   └── SAR_ADC_BLOCKS/             # SAR ADC hierarchy
│       │       ├── BSW/
│       │       ├── CDAC/
│       │       ├── CLK_GEN/
│       │       ├── COMP/
│       │       ├── DLY_CELL/
│       │       ├── INV/
│       │       ├── INV2/
│       │       ├── MUX/
│       │       ├── NAND/
│       │       ├── OUT_REG/
│       │       ├── RS_LATCH/
│       │       ├── SAR_ADC/
│       │       ├── SAR_LOGIC/
│       │       ├── SA_LATCH/
│       │       ├── SW_NW/
│       │       ├── TG_SW/
│       │       ├── TSPC_FF/
│       │       └── XOR/
│       └── Testbench/
│           ├── AFE_BLOCKS/                 # AFE PVT and Monte Carlo benches
│           │   ├── BIAS/
│           │   ├── FDBUF/
│           │   ├── INA_RLD/
│           │   ├── LPF/
│           │   └── PGA/
│           ├── ANALOG_BLOCKS/
│           │   ├── FDOTA/
│           │   └── SEOTA/
│           ├── SAR_ADC_BLOCKS/
│           └── SIZING/
│               └── Gm_Id/
├── Measurement_Results/
│   └── IC_Simulation/                     # Per-block raw data, reports, and plots
│       ├── AFE_BLOCKS/
│       │   ├── AFE/
│       │   ├── BIAS/
│       │   ├── FDBUF/
│       │   ├── INA_RLD/
│       │   ├── LPF/
│       │   └── PGA/
│       ├── ANALOG_BLOCKS/
│       │   ├── FDOTA/
│       │   └── SEOTA/
│       └── SIZING/
│           └── Gm_Id/
└── Simulation_Environment/                  # Minimal IIC-OSIC-TOOLS launch environment
    ├── IIC-OSIC-TOOLS/
    ├── LICENSE
    ├── NOTICE
    └── README.md
```

## Reproducing the reports

Run the analyzers from the repository root after generating the corresponding ngspice TXT exports:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','AFE_BLOCKS','BIAS')); BIAS_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','ANALOG_BLOCKS','SEOTA')); SEOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','ANALOG_BLOCKS','FDOTA')); FDOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','AFE_BLOCKS','INA_RLD')); INA_RLD_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','AFE_BLOCKS','LPF')); LPF_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','AFE_BLOCKS','PGA')); PGA_Analyze"
```

Device-characterization utilities:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','SIZING','Gm_Id','NMOS_Gm_Id')); NMOS_Gm_Id"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','SIZING','Gm_Id','PMOS_Gm_Id')); PMOS_Gm_Id"
```

Each analyzer keeps calculations in double precision and applies unit scaling only when reports and plots are produced.

## Next steps

1. Complete FDBUF reporting and full-chain AFE verification.
2. Implement matching-critical layout, followed by DRC and LVS.
3. Run extracted PVT and selected FULL Monte Carlo verification.
4. Integrate the SAR ADC, pad ring, and mixed-signal top level.
5. Prepare the evaluation PCB and laboratory characterization plan.
