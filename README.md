# Práctica: Verificador de Puertos — Linux (Bash + Docker) vs Windows (PowerShell)

Práctica del tema **PowerShell** (con parte previa en Linux).

El ejercicio consiste en crear un script que **reciba un puerto como argumento** y diga si está **abierto o cerrado**, primero en **Linux con Bash (probado con Docker)** y después su **equivalente en Windows con PowerShell**.

## Estructura del repo (lo que pide la práctica: 2 carpetas + 1 README)

```text
ActividadPS/
├── linux/
│   ├── check_port.sh   # Script Bash: revisa puerto TCP
│   └── Dockerfile      # Imagen Linux para probar el script con Docker
├── windows/
│   └── Check-Port.ps1  # Script PowerShell equivalente
└── README.md           # Este archivo
```

## Requisitos

* Docker Desktop instalado y corriendo
* Windows PowerShell 5.1 o PowerShell 7+
* Para PowerShell, permitir ejecución de scripts (solo una vez, como admin si hace falta):
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  ```

## 1. Parte Linux (Bash + Docker)

Script: `linux/check_port.sh`

```bash
./check_port.sh <puerto> [host]
```

* `<puerto>`: obligatorio, 1-65535
* `[host]`: opcional, por defecto `127.0.0.1`
* Sale con código `0` si ABIERTO, `1` si CERRADO, `2` si uso incorrecto.

### Probar con Docker

```bash
# 1. Construir la imagen (desde la raíz del repo)
docker build -t port-checker ./linux

# 2. Revisar un puerto (ej. 80 en localhost del contenedor)
docker run --rm port-checker 80

# 3. Revisar otro host + puerto
docker run --rm port-checker 443 google.com

# 4. Probar uso incorrecto (sin argumentos)
docker run --rm port-checker
```

### Probar un puerto ABIERTO vs CERRADO

Dentro de un contenedor, casi todos los puertos están cerrados por defecto. Para ver un ABIERTO:

```bash
# Terminal 1: levantar un servidor de prueba que abre el puerto 8000
docker run --rm -p 8000:8000 python:3-alpine python -m http.server 8000

# Terminal 2: en Linux local o en otro contenedor en la misma red,
# revisar ese puerto. Ejemplo más simple sin Docker, en Git Bash / WSL:
./linux/check_port.sh 8000 127.0.0.1
# -> Puerto 8000 en 127.0.0.1 está ABIERTO

./linux/check_port.sh 9999 127.0.0.1
# -> Puerto 9999 en 127.0.0.1 está CERRADO
```

> Nota Docker Desktop (Windows/Mac): `docker run --rm port-checker 80` revisa el
> localhost **del contenedor**, no el de tu PC. Para revisar tu PC desde el
> contenedor usa el host especial `host.docker.internal`:
> ```bash
> docker run --rm port-checker 8000 host.docker.internal
> ```
> En Linux nativo puedes usar `--network host`:
> ```bash
> docker run --rm --network host port-checker 8000
> ```

## 2. Parte Windows (PowerShell)

Script: `windows/Check-Port.ps1`

```powershell
.\Check-Port.ps1 -Port <puerto> [-TargetHost <host>] [-TimeoutMs <ms>]
```

### Ejemplos

```powershell
# Ir a la carpeta
cd windows

# Puerto cerrado (casi seguro)
.\Check-Port.ps1 -Port 9999

# Puerto abierto: primero abre uno de prueba en otra terminal
# Terminal A:
python -m http.server 8000
# Terminal B:
.\Check-Port.ps1 -Port 8000

# Contra otro host
.\Check-Port.ps1 -Port 443 -TargetHost "google.com"
```

Salida esperada:

```text
Puerto 8000 en 127.0.0.1 está ABIERTO   # en verde
Puerto 9999 en 127.0.0.1 está CERRADO   # en rojo
```

## Equivalencia Bash <-> PowerShell

| Concepto | Linux (`check_port.sh`) | Windows (`Check-Port.ps1`) |
|---|---|---|
| Recibir puerto | `$1` | `param([int]$Port)` |
| Validar 1-65535 | `[[ "$PORT" =~ ^[0-9]+$ ]]` | `[ValidateRange(1,65535)]` |
| Conexión TCP | `> /dev/tcp/$HOST/$PORT` | `TcpClient.BeginConnect()` |
| Timeout | `timeout 2 bash -c ...` | `WaitOne(2000)` |
| Salida | `echo ... ABIERTO/CERRADO` | `Write-Host ...` con color |

## Subir a GitHub

```bash
git init
git add linux/ windows/ README.md
git commit -m "Practica PS: checker de puertos Linux + Windows"
git branch -M main
git remote add origin https://github.com/TU-USUARIO/TU-REPO.git
git push -u origin main
```

## Autor

Práctica escolar — tema PowerShell.
