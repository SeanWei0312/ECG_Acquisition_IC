# ECG Acquisition IC Simulation Environment

Use these commands to start, inspect, stop, and remove the IIC-OSIC-TOOLS Docker containers used by this project. Replace the example host paths with the location of your local checkout.

The `DESIGNS` folder is shared into Docker as:

```text
/foss/designs
```

## 1. Start the environment

### Windows PowerShell

```powershell
cd "D:\path\to\GitHub\ECG_Acquisition_IC\Simulation_Environment\IIC-OSIC-TOOLS"
$env:DESIGNS="D:\path\to\GitHub"
.\start_chipathon_vnc.bat
```

### Mac Terminal

```bash
cd "/Users/sean/Documents/GitHub/ECG_Acquisition_IC/Simulation_Environment/IIC-OSIC-TOOLS"
export DESIGNS="/Users/sean/Documents/GitHub"
./start_chipathon_vnc.sh
```

These Mac commands use Sean's local checkout. On another Mac, replace `/Users/sean/Documents/GitHub` with your GitHub directory in both commands.

Verify the paths before starting Docker:

```bash
ls -ld "/Users/sean/Documents/GitHub"
ls -l "/Users/sean/Documents/GitHub/ECG_Acquisition_IC/Simulation_Environment/IIC-OSIC-TOOLS/start_chipathon_vnc.sh"
```

If an existing container has the wrong mount, changing `DESIGNS` will not update it. Inspect its mounts:

```bash
docker inspect --format '{{json .Mounts}}' "iic-osic-tools_chipathon_xvnc_uid_$(id -u)"
```

To recreate that container, first save any files stored only inside it, then remove it and rerun the Mac startup commands above. Removal deletes the container's internal files; files in the bind-mounted Mac directory remain.

```bash
docker rm -f "iic-osic-tools_chipathon_xvnc_uid_$(id -u)"
```

### Access the desktop

TigerVNC Viewer:

```text
localhost:5901
```

Password:

```text
abc123
```

Web browser / noVNC:

```text
http://localhost:80/?password=abc123
```

## 2. Inspect containers

```bash
docker ps -a
```

This shows all Docker containers, including running and stopped containers.

## 3. Stop running containers

> [!CAUTION]
> This command stops every running Docker container on the host, not only this project's containers.

```bash
docker stop $(docker ps -q)
```

This stops all running Docker containers.

## 4. Remove containers

> [!CAUTION]
> This command removes every Docker container on the host. It does not delete files in the repository or other bind-mounted host directories.

```bash
docker rm -f $(docker ps -aq)
```

Use this only when a complete container reset is intended.
