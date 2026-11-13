# PC-Free - Windows 10 in GitHub Codespaces | Run Windows 10 Free in Browser

Run a complete Windows 10 environment in your browser using Docker and GitHub Codespaces. Free, fast, and no installation required.

[![GitHub stars](https://img.shields.io/github/stars/jephersonRD/pc-free?style=social)](https://github.com/jephersonRD/pc-free/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/jephersonRD/pc-free?style=social)](https://github.com/jephersonRD/pc-free/network/members)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=flat&logo=docker&logoColor=white)](https://www.docker.com/)
[![Windows 10](https://img.shields.io/badge/Windows-10-0078D6?style=flat&logo=windows&logoColor=white)](https://www.microsoft.com/windows)

**[🇪🇸 Español](#español)** • **[🚀 Quick Start](#quick-start-run-windows-10-in-5-minutes)** • **[📖 Documentation](#documentation)** • **[🐛 Report Bug](https://github.com/jeph[...]

![Windows 10 Desktop in Browser](./images/windows10-desktop.png)

---

## What is PC-Free?

PC-Free is an open-source project that lets you run Windows 10 directly in your web browser using GitHub Codespaces and Docker. No local installation, no powerful hardware required, completely fre[...]

### Key Benefits

- ✅ **100% Free** - No hidden costs or subscriptions
- ✅ **Browser-Based** - Access Windows from any device
- ✅ **5-Minute Setup** - Deploy Windows 10 in minutes
- ✅ **No PC Required** - Run Windows without owning a Windows PC
- ✅ **Docker Container** - Isolated, secure, and portable
- ✅ **Persistent Data** - Your files and apps survive restarts
- ✅ **Open Source** - MIT licensed, community-driven

---

## Table of Contents

- [Features](#features)
- [Use Cases](#use-cases---when-to-use-pc-free)
- [Quick Start](#quick-start-run-windows-10-in-5-minutes)
- [System Requirements](#system-requirements)
- [Installation Guide](#guía-rápida)
- [Usage Instructions](#usage-instructions)
- [Configuration Options](#configuration-options)
- [FAQ](#frequently-asked-questions-faq)
- [Troubleshooting](#troubleshooting-common-issues)
- [Contributing](#contributing)
- [License](#license)

---



## Comparison: PC-Free vs Alternatives

Compare PC-Free with other Windows cloud solutions:

| Feature | PC-Free | Azure Virtual Desktop | AWS WorkSpaces | Local VM |
|---------|---------|----------------------|----------------|----------|
| **Monthly Cost** | ✅ $0 (Free) | ❌ $31-100+ | ❌ $25-75+ | ✅ $0 (Free) |
| **Setup Time** | ⚡ 5 minutes | ⏱️ 30+ minutes | ⏱️ 30+ minutes | ⏱️ 15-30 minutes |
| **Hardware Required** | ✅ None | ✅ None | ✅ None | ❌ Powerful PC needed |
| **Browser Access** | ✅ Yes | ✅ Yes | ✅ Yes | ⚠️ Limited |
| **Open Source** | ✅ Yes | ❌ No | ❌ No | ⚠️ Partial |
| **Data Persistence** | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |

---

## Quick Start: Run Windows 10 in 5 Minutes

### Method 1: One-Click GitHub Codespaces (Recommended)

The fastest way to get Windows 10 running in your browser:

1. **Fork this repository** - Click "Fork" button at top right
2. **Open Codespace** - Click "Code" → "Codespaces" → "Create codespace on main"
3. **Wait for setup** - Environment loads automatically (~2 minutes)
4. **Follow the Guía Rápida below"

### Method 2: Manual Docker Setup

For local Docker installation, see the complete guide below.

---

## Guía Rápida

### 1️⃣ Verifica el almacenamiento disponible

```bash
df -h
```

Escoge la partición con más espacio libre.

### 2️⃣ Crea la carpeta de datos para Docker

```bash
sudo mkdir -p /tmp/docker-data
```

### 3️⃣ Configura Docker

Edita el archivo:

```bash
sudo nano /etc/docker/daemon.json
```

Agrega:

```json
{
  "data-root": "/tmp/docker-data"
}
```

### 4️⃣ Reinicia tu Codespace

Para aplicar los cambios de configuración.

### 5️⃣ Verifica Docker

```bash
docker info
```

Asegúrate de que `Docker Root Dir` sea `/tmp/docker-data`.

---

## 🧱 Archivo `windows11.yml`

```yaml
# Antes de ejecutar docker-compose up, ejecuta:
# bash check_github_follow.sh || exit 1
# Si no sigues a https://github.com/jephersonRD, el entorno no se iniciará.
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "11"
      USERNAME: ${WINDOWS_USERNAME}
      PASSWORD: ${WINDOWS_PASSWORD}
      RAM_SIZE: "24G"
      CPU_CORES: "6"
      DISK_SIZE: "1024G"
    cap_add:
      - NET_ADMIN
    ports:
      - "8006:8006"
      - "3389:3389/tcp"
    volumes:
      - /tmp/docker-data:/mnt/disco1
      - windows-data:/mnt/windows-data
    devices:
      - "/dev/kvm:/dev/kvm"
      - "/dev/net/tun:/dev/net/tun"
    stop_grace_period: 2m
    restart: always

volumes:
  windows-data:
```

---

## 🗝️ Archivo `.env`

```ini
WINDOWS_USERNAME=YourUsername
WINDOWS_PASSWORD=YourPassword
GITHUB_USER=YourGitHubUsername
```

### 🛑 Agrega este archivo a tu `.gitignore`:

```bash
echo ".env" >> .gitignore
```

---

## ▶️ Inicia el contenedor

### Iniciar por primera vez

```bash
docker-compose -f windows11.yml up
```

### 🔌 Apagar la PC

```bash
docker stop windows
```

---

## System Requirements

### For GitHub Codespaces (Recommended)

- GitHub account (free tier supported)
- Modern web browser (Chrome 90+, Firefox 88+, Edge 90+, Safari 14+)
- 10GB+ available Codespace storage
- Stable internet connection (2 Mbps+ recommended)

### For Local Docker Installation

- Docker Engine 20.10 or higher
- 20GB+ free disk space
- 8GB+ RAM (16GB recommended)
- KVM support (Linux hosts) or Hyper-V (Windows hosts)
- Operating System: Linux, macOS, or Windows 10/11 Pro

---

## Usage Instructions

### Start Windows Environment

Start the Windows container:

```bash
docker-compose -f windows11.yml up -d
```

### Stop Windows Environment

Stop the Windows container gracefully:

```bash
docker stop windows
```

### Restart Windows

Restart the container (useful after freezes):

```bash
docker restart windows
```

### View Container Logs

Monitor Windows container activity:

```bash
docker logs -f windows
```

Press Ctrl+C to exit log view.

### Complete Removal

Remove container and all data volumes:

```bash
docker-compose -f windows11.yml down -v
```

**⚠️ Warning**: This deletes all Windows data permanently.

---

## Configuration Options

### Customize System Resources

Edit `windows11.yml` to adjust resources:

```yaml
environment:
  VERSION: "11"              # Windows version (10 or 11)
  RAM_SIZE: "24G"           # RAM allocation
  CPU_CORES: "6"            # CPU core count
  DISK_SIZE: "1024G"          # Virtual disk size
  USERNAME: ${WINDOWS_USERNAME}
  PASSWORD: ${WINDOWS_PASSWORD}
```

### Switch to Windows 11

Change Windows version in environment:

```yaml
environment:
  VERSION: "11"  # Windows 11
```

### Enable RDP Access

Add RDP port mapping for native Remote Desktop:

```yaml
ports:
  - "8006:8006"    # Web interface (noVNC)
  - "3389:3389"    # RDP protocol
```

Connect using RDP client: `localhost:3389`

### Adjust Performance Settings

For slower systems, reduce resource allocation:

```yaml
environment:
  RAM_SIZE: "6G"     # Minimum for Windows 10
  CPU_CORES: "2"     # Minimum cores
```

---

## Screenshots

### Windows 10 Desktop Interface
![Windows 10 Desktop](./images/windows10-desktop.png)

### Windows 11 Alternative
![Windows 11 About](./images/windows11-about.png)

### Browser-Based Access
![Browser Interface](./images/browser-interface.png)

---

## Frequently Asked Questions (FAQ)

### How long does Windows take to boot?

- **Initial boot**: 5-10 minutes (downloading Windows image)
- **Subsequent boots**: 2-3 minutes

... (rest of README unchanged) ...
