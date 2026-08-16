# SSCS Chipathon 2026 Docker Instructions

Use these commands to start, check, stop, and delete the SSCS Chipathon 2026 Docker containers.

The `DESIGNS` folder is shared into Docker as:

```text
/foss/designs
```

## 1. Start

### Windows PowerShell

```powershell
cd "D:\Documents\GitHub\ECG_Acquisition_IC\2026-sscs-chipathon\resources\IIC-OSIC-TOOLS"
$env:DESIGNS="D:\Documents\GitHub"
.\start_chipathon_vnc.bat
```

### Mac Terminal

```bash
cd /Users/sean/Documents/GitHub/ECG_Acquisition_IC/2026-sscs-chipathon/resources/IIC-OSIC-TOOLS
export DESIGNS="/Users/sean/Documents/GitHub"
./start_chipathon_vnc.sh
```

### Open the Docker Desktop

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

## 2. Check All

### Windows or Mac

```bash
docker ps -a
```

This shows all Docker containers, including running and stopped containers.

## 3. Stop All

### Windows or Mac

```bash
docker stop $(docker ps -q)
```

This stops all running Docker containers.

## 4. Delete All Containers

### Windows or Mac

```bash
docker rm -f $(docker ps -aq)
```

This deletes all Docker containers. It does not delete files saved in your GitHub project folder.
