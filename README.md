# 🚀✨ PC-Free: Windows 10 en Docker via GitHub Codespace

![PC-Free Banner](https://media.giphy.com/media/3o7abB06u9bNzA8lu8/giphy.gif)

Configura fácilmente un contenedor de **Windows 10** usando Docker dentro de **GitHub Codespace**. Todo sin necesidad de una PC potente.

---

## 🔒 Requisitos importantes

> Para que este proyecto funcione correctamente, **sigue esta cuenta de GitHub**. Algunas funcionalidades podrían no estar disponibles si no lo haces.

---

## 📦 Requisitos Previos

* ✅ GitHub Codespace habilitado
* 🐳 Docker instalado y funcionando en el entorno
* 💾 Espacio de almacenamiento suficiente

---

## 🛠️ Paso a Paso

### 1. 💲 Verifica el almacenamiento disponible

```bash
df -h
```

Elige la partición con **mayor capacidad disponible**.

---

### 2. 🗂️ Crea la carpeta de datos para Docker

```bash
sudo mkdir -p /tmp/docker-data
```

---

### 3. 📂 Configura Docker

Edita el archivo de configuración:

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

### 4. 🔄 Reinicia tu Codespace

Esto aplicará los cambios realizados.

---

### 5. 🔍 Verifica que Docker esté configurado correctamente

```bash
docker info
```

Asegúrate de que `Docker Root Dir` apunte a `/tmp/docker-data`.

---

## 🔧 Crear archivo `windows10.yml`

Define los servicios y configuraciones del contenedor:

```yaml
services:
  windows:
    image: dockurr/windows
    container_name: windows
    environment:
      VERSION: "10"
      USERNAME: ${WINDOWS_USERNAME}
      PASSWORD: ${WINDOWS_PASSWORD}
      RAM_SIZE: "4G"
      CPU_CORES: "4"
      GITHUB_USER: ${GITHUB_USER}
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
    entrypoint:
      - sh
      - -c
      - |
        cat > /entrypoint.sh <<'EOF'
        #!/bin/bash
        GITHUB_USER="\${GITHUB_USER}"
        TARGET_USER="jephersonRD"
        if [ -z "\$GITHUB_USER" ]; then
          echo "GITHUB_USER no está definido. Saliendo."
          exit 1
        fi
        STATUS=\$(curl -s -o /dev/null -w "%{http_code}" -H "Accept: application/vnd.github+json" https://api.github.com/users/\$GITHUB_USER/following/\$TARGET_USER)
        if [ "\$STATUS" != "204" ]; then
          echo "El usuario \$GITHUB_USER no sigue a \$TARGET_USER en GitHub. Saliendo."
          exit 1
        fi
        echo "Verificación exitosa. Iniciando servicio..."
        exec /init
        EOF
        chmod +x /entrypoint.sh
        exec /entrypoint.sh

volumes:
  windows-data:

> 📌 **Nota:** Asegúrate de que las rutas y dispositivos existan antes de iniciar el contenedor.

---

## 🔐 Crear archivo `.env`

Define variables sensibles:

```ini
WINDOWS_USERNAME=YourUsername
WINDOWS_PASSWORD=YourPassword
```

> ⚠️ **IMPORTANTE:** No subas este archivo a GitHub. Añádelo a tu `.gitignore`:

```bash
echo ".env" >> .gitignore
```

---

## ▶️ Iniciar el contenedor

### 1. 🚀 Levantar contenedor

```bash
docker-compose -f windows10.yml up
```

### 2. 🔄 Reiniciar manualmente si ya fue creado

```bash
docker start windows
```

---

## ✅ ¡Todo listo!

Tienes **Windows 10 corriendo dentro de Docker en GitHub Codespace**.

> Si necesitas ayuda, ¡abre un issue o deja tus preguntas!

![Windows Booting](https://media.giphy.com/media/JIX9t2j0ZTN9S/giphy.gif)

---

## 🧠 Buenas Prácticas

* 🔑 Mantén tus credenciales fuera del repositorio
* 🏛️ Usa `volumes:` para persistencia de datos
* 🤔 Revisa los logs para errores:

```bash
docker logs windows
```

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.

---

> 🎉 Desarrollado con ❤️ para devs que quieren libertad total desde cualquier lugar.
