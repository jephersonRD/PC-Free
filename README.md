# 🚀✨ PC-Free: Windows 10 en Docker vía GitHub Codespace

## 📸 Capturas de Pantalla del Sistema

<div align="center">
  <img src="./images/windows10-desktop.png" alt="Windows 10 Desktop" width="45%" />
  <img src="./images/windows11-about.png" alt="Windows 11 About Dialog" width="45%" />
</div>

*Izquierda: Windows 10 ejecutándose en el navegador | Derecha: Información del sistema Windows*

> **Ejecuta Windows 10 en la nube sin una PC potente.**  
> Todo directamente desde GitHub Codespace + Docker. 🔥

---

## 🔐 Requisitos importantes

📌 Para que este proyecto funcione correctamente:

- **Debes seguir esta cuenta de GitHub**: algunas funcionalidades no se activarán si no lo haces.

---

## ⚙️ Requisitos Previos

- ✅ GitHub Codespace habilitado  
- 🐳 Docker instalado y funcionando  
- 💾 Espacio de almacenamiento suficiente  

---

## 🛠️ Guía Rápida

### 1️⃣ Verifica el almacenamiento disponible

```bash
df -h
```
Escoge la partición con más espacio libre.

---

### 2️⃣ Crea la carpeta de datos para Docker

```bash
sudo mkdir -p /tmp/docker-data
```

---

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

---

### 4️⃣ Reinicia tu Codespace

> Para aplicar los cambios de configuración.

---

### 5️⃣ Verifica Docker

```bash
docker info
```
Asegúrate de que `Docker Root Dir` sea `/tmp/docker-data`.

---

## 🧱 Archivo `windows10.yml`

```yaml
# Antes de ejecutar docker-compose up, ejecuta:
# bash check_github_follow.sh || exit 1
# Si no sigues a https://github.com/jephersonRD, el entorno no se iniciará.
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "10"
      USERNAME: ${WINDOWS_USERNAME}
      PASSWORD: ${WINDOWS_PASSWORD}
      RAM_SIZE: "16G"
      CPU_CORES: "4"
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

🛑 **Agrega este archivo a tu `.gitignore`:**

```bash
echo ".env" >> .gitignore
```

---

## ▶️ Inicia el contenedor

### Iniciar por primera vez

```bash
docker-compose -f windows10.yml up
```

---

## 🔌 Apagar la PC

```bash
docker stop windows
```

---

## 🔁 Reiniciar la PC

```bash
docker restart windows
```
## 💡 Encender la "PC" otra vez
```bash
docker start windows
```
---

## ✅ ¡Windows corriendo en Codespace!

🎉 Felicidades, ya tienes **Windows 10 en Docker** corriendo directamente desde tu navegador.

![Windows Booting](https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif)

---

## 🧠 Buenas prácticas

- 🔐 Mantén tus credenciales fuera del repositorio
- 💾 Usa volúmenes para persistencia de datos
- 🧰 Revisa errores con:

```bash
docker logs windows
```

---

## 📜 Licencia

Distribuido bajo la licencia MIT. Consulta el archivo `LICENSE`.

> ✨ Desarrollado con ❤️ para devs que quieren **una PC completa sin tener una.**
