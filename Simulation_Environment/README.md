# Simulation Environment

This directory contains the minimal IIC-OSIC-TOOLS launcher environment used to run the ECG Acquisition IC simulations. Unrelated upstream tutorials, examples, schedules, and reference projects have been removed from this repository.

## Contents

```text
Simulation_Environment/
├── IIC-OSIC-TOOLS/    # Linux, macOS, and Windows container launchers
├── LICENSE            # Upstream license
├── NOTICE             # Upstream attribution
└── README.md
```

The launchers use the project's configured IIC-OSIC-TOOLS image and mount the host design directory at `/foss/designs` inside the container.

## Launchers

| Mode | Linux / macOS | Windows |
| :--- | :--- | :--- |
| VNC desktop | `start_chipathon_vnc.sh` | `start_chipathon_vnc.bat` |
| Local X11 / Wayland | `start_chipathon_x.sh` | `start_chipathon_x.bat` |
| JupyterLab | `start_chipathon_jupyter.sh` | `start_chipathon_jupyter.bat` |

See [Docker_Instructions.md](../Docker_Instructions.md) for the project-specific startup, status, and shutdown commands. Additional launcher details are available in [IIC-OSIC-TOOLS/README.md](IIC-OSIC-TOOLS/README.md).

## Attribution

These launcher scripts were retained from the upstream simulation environment. The corresponding license and notice are preserved in this directory.
