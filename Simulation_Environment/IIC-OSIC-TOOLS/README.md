# IIC-OSIC-TOOLS Launchers

This directory contains the retained Linux, macOS, and Windows launchers for the project's preconfigured IIC-OSIC-TOOLS Docker image. The image supports x86-64 and ARM64 hosts.

## Operating modes

| Mode | Interface | Best suited for | Limitation |
| :--- | :--- | :--- | :--- |
| X11 / Wayland | Applications displayed on the host desktop | Lowest-latency local graphical use | Requires a compatible host display server |
| VNC | Complete remote desktop through VNC or a browser | Simple local or remote desktop access | Lower graphical performance than native display forwarding |
| JupyterLab | Browser-based notebook environment | Interactive scripts and notebooks | No complete graphical desktop |

## Launchers

| Mode | Linux / macOS | Windows |
| :--- | :--- | :--- |
| X11 / Wayland | `start_chipathon_x.sh` | `start_chipathon_x.bat` |
| VNC desktop | `start_chipathon_vnc.sh` | `start_chipathon_vnc.bat` |
| JupyterLab | `start_chipathon_jupyter.sh` | `start_chipathon_jupyter.bat` |

Run the shell scripts with Bash or another compatible shell. Run the batch files from Command Prompt, PowerShell, or Windows Explorer.

## Design-directory mount

The host design directory is mounted inside the container at:

```text
/foss/designs
```

Set the host directory with the `DESIGNS` environment variable before running a launcher. If `DESIGNS` is not set, the launchers use their platform-specific default design directory.

## Service endpoints

| Service | Address | Default credential |
| :--- | :--- | :--- |
| VNC | `localhost:5901` | Password: `abc123` |
| Browser VNC | <http://localhost:80> | Password: `abc123` |
| JupyterLab | <http://localhost:8888> | Launcher-configured access |

## Platform notes

### Linux

Docker CE can forward the local X11 or Wayland display directly and may also expose a compatible GPU. Docker Desktop uses a local TCP-forwarding path for X11; the X-mode launcher uses `socat` for this connection.

Install `socat` with the package manager for the host distribution when it is required:

- Ubuntu or Debian: `sudo apt-get -y install socat`
- Arch or Manjaro: `sudo pacman -S socat`
- Fedora, RHEL, Rocky Linux, or AlmaLinux: `sudo dnf -y install socat`
- SUSE or openSUSE: `sudo zypper install socat`

### macOS

X11 mode requires a separately installed X server such as [XQuartz](https://www.xquartz.org/). VNC mode does not require XQuartz.

### Windows

X11 / Wayland mode uses WSL2 with WSLg. Windows 11 includes WSLg by default; Windows 10 installations may require a WSL update. VNC and JupyterLab modes do not require a separate Windows X server.

See the [project Docker instructions](../../Docker_Instructions.md) for the repository-specific startup and container-management commands.
