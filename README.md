# ECG Acquisition IC

A pre-layout analog front end (AFE) for electrocardiogram and other low-frequency biopotential signals, implemented in the GlobalFoundries 180 nm MCU process for the IEEE SSCS Chipathon 2026 flow.

The repository contains transistor-level Xschem designs, ngspice verification testbenches, MATLAB analysis scripts, generated PVT/Monte Carlo reports, and $g_m/I_D$ characterization utilities.

> [!NOTE]
> Results in this repository are schematic-level simulations. Layout, LVS/DRC, parasitic extraction, top-level post-layout verification, and silicon measurements remain future work.

## Architecture

![ECG analog front end](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/AFE/AFE.png)

| Stage | Block | Function | Nominal transfer |
| :--- | :--- | :--- | :---: |
| 1 | [`INA`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/INA/) | Three-amplifier instrumentation front end | $240\text{ V/V}$ |
| 2 | [`LPF`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/LPF/) | Fully differential, unity-gain active low-pass filter | $1\text{ V/V}$; $f_{-1\mathrm{dB}} \ge 150\text{ Hz}$ |
| 3 | [`PGA`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/PGA/) | Digitally programmable differential gain | $2/4/8/16\text{ V/V}$ |
| 4 | [`BUFFER`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/BUFFER/) | Differential output driver | $1\text{ V/V}$ |
| Feedback | [`RLD`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/RLD/) | Input common-mode suppression | $55.1\text{ dB}$ at 60 Hz nominal |
| Support | [`BIAS`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/BIAS/) / [`MIRROR`](Design_Files/IC%20Design/Schematic/AFE_BLOCKS/MIRROR/) | Master reference and bias distribution | $40\,\mu\text{A}$ target |

The verified signal-path gain range is $480$ to $3840\text{ V/V}$ ($53.6$ to $71.7\text{ dB}$), before ADC integration.

## Verification status

Deterministic verification uses 45 corners: five process models (`NOM`, `FF`, `SS`, `FS`, and `SF`) across nine voltage/temperature conditions. Statistical verification uses 200-run mismatch-only (MM), global-only (GL), and combined (FULL) Monte Carlo sets.

| Block | Deterministic verification | Monte Carlo | Status |
| :--- | :--- | :--- | :---: |
| BIAS / SEL | PVT, voltage/temperature surface, startup, selector transient | — | Complete |
| SE OTA | 45-corner PVT | MM / GL / FULL | Pass |
| FD OTA | 45-corner PVT | MM / GL / FULL | Pass |
| INA + RLD | 45-corner balanced PVT, mismatch stress, selector transient | MM / GL / FULL | Pass |
| LPF | 45-corner PVT, selector transient | MM / GL / FULL | Pass |
| PGA | 45-corner PVT, selector and gain-code transients | MM / GL / FULL | Pass |
| BUFFER | Raw simulation exports available | MM export available | Analysis pending |
| Integrated AFE | Top-level schematic and analyzer scaffold | — | Integration pending |

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

The detailed report lists selected results for every one of the 45 PVT corners. The long-form block CSV files remain the authoritative source for every reported parameter.

See [Project_Report.md](Project_Report.md) for the verification methodology, detailed block results, plots, artifact links, and limitations.

## Repository layout

```text
ECG_Acquisition_IC/
├── README.md
├── Project_Report.md
├── Docker_Instructions.md
├── Design_Files/
│   └── IC Design/
│       ├── Schematic/              # Xschem hierarchy and sizing scripts
│       └── Testbench/              # PVT and Monte Carlo testbenches
├── Measurement_Results/
│   └── IC_Simulation/
│       ├── BIAS/
│       ├── SE_OTA/
│       ├── FD_OTA/
│       ├── INA_RLD/
│       ├── LPF/
│       ├── PGA/
│       ├── BUFFER/
│       ├── AFE/
│       └── Gm_Id/
└── 2026-sscs-chipathon/             # Upstream Chipathon reference snapshot
```

## Reproducing the reports

Run the analyzers from the repository root after generating the corresponding ngspice TXT exports:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','BIAS')); BIAS_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','SE_OTA')); SEOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','FD_OTA')); FDOTA_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','INA_RLD')); INA_RLD_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','LPF')); LPF_Analyze"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','PGA')); PGA_Analyze"
```

Device-characterization utilities:

```bash
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','Gm_Id','NMOS_Gm_Id')); NMOS_Gm_Id"
matlab -batch "addpath(fullfile(pwd,'Measurement_Results','IC_Simulation','Gm_Id','PMOS_Gm_Id')); PMOS_Gm_Id"
```

Each analyzer keeps calculations in double precision and applies unit scaling only when reports and plots are produced.

## Next steps

1. Complete BUFFER reporting and full-chain AFE verification.
2. Implement matching-critical layout, followed by DRC and LVS.
3. Run extracted PVT and selected FULL Monte Carlo verification.
4. Integrate the SAR ADC, pad ring, and mixed-signal top level.
5. Prepare the evaluation PCB and laboratory characterization plan.
