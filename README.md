# ECG Acquisition IC

This repository contains the working files for an ECG acquisition integrated circuit developed for the SSCS Chipathon 2026 flow. The project combines system-level planning, GF180 analog IC schematics, device characterization data, simulation results, PCB planning, Docker setup notes, and the project report.

## Project Focus

The current design work is centered on the analog front end for ECG acquisition:

- System-level ECG acquisition architecture and specifications.
- Gm/Id characterization for GF180 NMOS and PMOS devices.
- Single-ended two-stage OTA schematic development.
- Planned expansion toward full differential OTA blocks, ADC integration, layout, PCB support, and measurement.

## Upstream Chipathon Files

The official Chipathon files are included under `2026-sscs-chipathon/` and were cloned from:

[sscs-ose/sscs-chipathon-2026](https://github.com/sscs-ose/sscs-chipathon-2026)

These files provide the workshop documentation, examples, resources, and IIC-OSIC-TOOLS Docker setup used for the design environment.

## Repository Structure

```text
.
├── 2026-sscs-chipathon/
│   ├── docs/
│   ├── examples/
│   ├── resources/
│   └── schedule/
├── Design_Files/
│   ├── System Design/
│   │   ├── ECG Acquisition IC with 10-bit SAR ADC SPEC.xlsx
│   │   ├── System_Block.drawio
│   │   └── System_Block.png
│   ├── IC Design/
│   │   ├── Schematic/
│   │   │   ├── Gm_Id/
│   │   │   └── Single_ended_OTA/
│   │   ├── Testbench/
│   │   └── Layout/
│   └── PCB Design/
├── Measurement_Results/
│   └── IC_Simulation/
│       └── Gm_Id/
├── Docker_Instructions.md
├── Project_Report.md
└── README.md
```

## Key Files

| Path | Purpose |
| --- | --- |
| `Design_Files/System Design/System_Block.drawio` | Editable system block diagram. |
| `Design_Files/System Design/System_Block.png` | Exported system block diagram image. |
| `Design_Files/System Design/ECG Acquisition IC with 10-bit SAR ADC SPEC.xlsx` | System-level specification spreadsheet. |
| `Design_Files/IC Design/Schematic/Gm_Id/NMOS_Gm_Id.sch` | Xschem/ngspice NMOS Gm/Id characterization sweep. |
| `Design_Files/IC Design/Schematic/Gm_Id/PMOS_Gm_Id.sch` | Xschem/ngspice PMOS Gm/Id characterization sweep. |
| `Design_Files/IC Design/Schematic/Single_ended_OTA/Single_ended_OTA.sch` | Single-ended two-stage OTA schematic in progress. |
| `Measurement_Results/IC_Simulation/Gm_Id/` | Raw and processed Gm/Id simulation outputs. |
| `Docker_Instructions.md` | Commands for starting, accessing, stopping, and deleting the Chipathon Docker container. |
| `Project_Report.md` | Project report draft and running design log. |

## Current Design Status

| Area | Status | Notes |
| --- | --- | --- |
| System architecture | In progress | Block diagram and ECG acquisition specification files are present. |
| Device characterization | In progress | NMOS and PMOS Gm/Id xschem sweeps and result files are present. |
| Single-ended OTA schematic | In progress | Initial GF180 3.3 V MOS schematic exists in `Single_ended_OTA.sch`. |
| Fully differential OTA | Planned | Represented in the system diagram; schematic implementation still to be added. |
| IC testbenches | Planned | `Design_Files/IC Design/Testbench/` is available for future OTA and system simulations. |
| IC layout | Not started | Layout directory is present for future physical design and verification files. |
| PCB design | Not started | PCB design folders are available for later board-level support. |
| Measurements | Not started | Measurement folder should be added once lab or post-silicon data is available. |

## Docker Environment

Use `Docker_Instructions.md` to start the Chipathon Docker environment.

Main access options:

- TigerVNC Viewer: `localhost:5901`
- Web browser / noVNC: `http://localhost:80/?password=abc123`

Inside Docker, the shared design folder is mounted at:

```text
/foss/designs
```

The current xschem Gm/Id simulation files write results under:

```text
/foss/designs/ecg_acquisition_ic/Measurement_Results/IC_Simulation/Gm_Id/
```

## Suggested Workflow

1. Start the Docker environment using `Docker_Instructions.md`.
2. Open or edit system-level files in `Design_Files/System Design/`.
3. Use the Gm/Id schematics in `Design_Files/IC Design/Schematic/Gm_Id/` to regenerate device characterization data.
4. Store raw and processed IC simulation outputs under `Measurement_Results/IC_Simulation/`.
5. Continue OTA development in `Design_Files/IC Design/Schematic/Single_ended_OTA/`.
6. Add OTA testbenches under `Design_Files/IC Design/Testbench/`.
7. Update `Project_Report.md` when requirements, design decisions, simulation results, or measurement results change.

## Notes

- Xschem files currently reference GF180 3.3 V transistor symbols and the `$::180MCU_MODELS` ngspice model path provided by the Chipathon/IIC-OSIC-TOOLS environment.
- Keep generated data in `Measurement_Results/` and source design files in `Design_Files/` so the repository stays easy to navigate.
- Avoid committing temporary OS files such as `.DS_Store` when possible.
