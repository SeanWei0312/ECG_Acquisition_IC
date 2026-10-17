# ECG Analog Front End

A self-directed, independent pre-layout ECG analog front end (AFE), implemented in the GlobalFoundries 180 nm MCU process. The present project covers low-noise ECG amplification, filtering, programmable gain, common-mode control, biasing, and differential output buffering. ADC development is outside the current scope.

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
| Feedback | [`RLD`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/RLD/) | Input common-mode suppression | Mains/common-mode reduction; see current report |
| Support | [`BIAS`](Design_Files/IC%20Design/Schematic/POWER_BLOCKS/BIAS/) / [`MIRROR`](Design_Files/IC%20Design/Schematic/POWER_BLOCKS/MIRROR/) | Master reference and bias distribution | $40\,\mu\text{A}$ target |

The verified block-level gain plan gives nominal AFE signal-path gains from $480$ to $3840\text{ V/V}$ ($53.6$ to $71.7\text{ dB}$).

## Verification status

| Block | Available verification | Report |
| :--- | :--- | :--- |
| BIAS and Mirror | 45-condition PVT; MM/GL/FULL exports | [Details](Report/POWER_BLOCKS/BIAS_Report.md) |
| SEOTA | 45-condition PVT; MM/GL/FULL exports | [Details](Report/ANALOG_BLOCKS/SEOTA_Report.md) |
| FDOTA | 45-condition PVT; MM/GL/FULL exports | [Details](Report/ANALOG_BLOCKS/FDOTA_Report.md) |
| INA + RLD | 45-condition PVT; MM/GL/FULL exports | [Details](Report/AFE_BLOCKS/INA_RLD_Report.md) |
| LPF | 45-condition PVT; MM/GL/FULL exports | [Details](Report/AFE_BLOCKS/LPF_Report.md) |
| PGA | 45-condition PVT; MM/GL/FULL exports | [Details](Report/AFE_BLOCKS/PGA_Report.md) |
| FDBUF | 45-condition PVT; MM/GL/FULL exports | [Details](Report/AFE_BLOCKS/FDBUF_Report.md) |

BIAS additionally includes a 50,630-point DC grid. PGA covers four gains; FDBUF covers four loads. Current archived MC counts and yields are listed in each report; incomplete exports do not establish a circuit failure or a pass. Integrated AFE verification remains pending.

Current values and specifications are summarized in the [project report](Project_Report.md). Blank specification fields are report-only. All results are pre-layout schematic simulations.

## Repository layout

```text
ECG_Acquisition_IC/
├── README.md
├── Docker_Instructions.md
├── Project_Report.md                    # AFE project report
├── Report/                              # Detailed block reports
│   ├── AFE_BLOCKS/
│   │   ├── AFE_Report.md
│   │   ├── FDBUF_Report.md
│   │   ├── INA_RLD_Report.md
│   │   ├── LPF_Report.md
│   │   └── PGA_Report.md
│   ├── ANALOG_BLOCKS/
│   │   ├── FDOTA_Report.md
│   │   └── SEOTA_Report.md
│   ├── POWER_BLOCKS/
│   │   └── BIAS_Report.md
│   └── SIZING/
│       └── Gm_Id_Report.md
├── Design_Files/
│   └── IC Design/
│       ├── Layout/                         # Physical-design workspace
│       ├── Schematic/
│       │   ├── AFE_BLOCKS/                 # Analog-front-end hierarchy
│       │   │   ├── AFE/
│       │   │   ├── FDBUF/
│       │   │   ├── INA/
│       │   │   ├── LPF/
│       │   │   ├── PGA/
│       │   │   └── RLD/
│       │   ├── POWER_BLOCKS/
│       │   │   ├── BIAS/
│       │   │   └── MIRROR/
│       │   ├── ANALOG_BLOCKS/
│       │   │   ├── FDOTA/
│       │   │   └── SEOTA/
│       │   ├── DIGITAL_BLOCKS/
│       │   │   ├── INV/
│       │   │   ├── MUX/
│       │   │   ├── MUXD/
│       │   │   └── TG/
│       └── Testbench/
│           ├── AFE_BLOCKS/                 # AFE PVT and Monte Carlo benches
│           │   ├── FDBUF/
│           │   ├── INA_RLD/
│           │   ├── LPF/
│           │   └── PGA/
│           ├── POWER_BLOCKS/
│           │   └── BIAS/
│           ├── ANALOG_BLOCKS/
│           │   ├── FDOTA/
│           │   └── SEOTA/
│           └── SIZING/
│               └── Gm_Id/
├── Measurement_Results/
│   └── IC_Simulation/                     # Per-block raw data, reports, and plots
│       ├── AFE_BLOCKS/
│       │   ├── AFE/
│       │   ├── FDBUF/
│       │   ├── INA_RLD/
│       │   ├── LPF/
│       │   └── PGA/
│       ├── POWER_BLOCKS/
│       │   └── BIAS/
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
4. Prepare the evaluation PCB and laboratory characterization plan.
5. Complete integrated AFE verification under its intended output load.
