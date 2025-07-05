# 🚀 PC-Free: Windows 10 en Docker via Codespace

¡Configura fácilmente un contenedor de **Windows 10** usando Docker en **GitHub Codespace**!  

##📌 **Nota:** Este proyecto para que funcione debe de suguime en mi cuenta de github de lo
contrario no va a funcionar.

---

## 📦 Requisitos Previos

- GitHub Codespace habilitado
- Docker instalado y funcionando en el entorno
- Almacenamiento suficiente

---

## 🛠️ Paso a paso

### 1. Verifica el almacenamiento disponible

En la terminal, ejecuta:

```bash
df -h
```

Elige la partición con **mayor capacidad disponible**.

---

### 2. Crea la carpeta de datos para Docker

```bash
sudo mkdir -p /tmp/docker-data
```

---

### 3. Configura Docker

Edita el archivo de configuración:

```bash
sudo nano /etc/docker/daemon.json
```

Agrega el siguiente contenido:

```json
{
  "data-root": "/tmp/docker-data"
}
```

---

### 4. Reinicia tu Codespace

Esto aplicará los cambios realizados en Docker.

---

### 5. Verifica que Docker esté configurado

```bash
docker info
```

Confirma que el campo `Docker Root Dir` apunte a `/tmp/docker-data`.

---

## ⚙️ Crear el archivo `windows10.yml`

Este archivo define los servicios y configuraciones del contenedor:

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

> 📌 **Nota:** Asegúrate de que las rutas y dispositivos existan en tu entorno Codespace antes de iniciar el contenedor.

---

## 🔐 Crear archivo `.env`

Define variables sensibles como nombre de usuario y contraseña de forma segura:

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

### 1. Levantar contenedor

```bash
docker-compose -f windows10.yml up
```

### 2. Iniciar manualmente (si ya fue creado)

```bash
docker start windows
```

---

## ✅ ¡Listo!

Ahora tienes **Windows 10 corriendo dentro de Docker** en tu Codespace.  
Si necesitas ayuda o soporte, ¡no dudes en abrir un issue o dejar tus preguntas!

---

## 🧠 Buenas prácticas

- Mantén tus credenciales fuera del repositorio
- Usa `volumes:` para persistencia de datos
- Revisa los logs de Docker para resolver problemas (`docker logs windows`)

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT.  
Consulta el archivo `LICENSE` para más detalles.
