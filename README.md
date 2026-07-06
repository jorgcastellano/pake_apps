# Gather Desktop

Wrapper de escritorio para Gather Town usando Pake/Tauri.

URL empaquetada:

```text
https://app.v2.gather.town/app
```

La estrategia final es compilar en GitHub Actions sobre Ubuntu, no en CachyOS/Arch localmente. Esto evita que el AppImage empaquete librerias rolling-release de Arch, que fueron la causa probable de los crashes de `WebKitWebProcess`, GStreamer y PipeWire.

## Archivos Del Proyecto

```text
inject.js
.github/workflows/build.yml
README.md
```

## Por Que Usar GitHub CI

El AppImage construido localmente en CachyOS empaqueta librerias desde `/usr/lib`, incluyendo WebKitGTK, GStreamer y PipeWire del sistema rolling-release. Esa mezcla produjo crashes al cargar Gather.

GitHub Actions construye el AppImage en `ubuntu-22.04`, con un stack mas estable y consistente para AppImage:

```text
Ubuntu 22.04 + Pake CLI + Tauri bundler + linuxdeploy
```

Nota importante para CachyOS/Arch: durante las pruebas, el AppImage generado localmente y el AppImage generado por GitHub CI fallaron dentro del proceso embebido `WebKitWebProcess`. Esto indica una incompatibilidad práctica entre Gather Town, WebRTC y WebKitGTK en este entorno. El workflow conserva AppImage para otras distribuciones, pero no se considera soportado en CachyOS.

## Workflow De GitHub Actions

El workflow ya esta en:

```text
.github/workflows/build.yml
```

Genera dos artefactos Linux:

```text
gatherdesktop.AppImage
gatherdesktop.deb
```

Se ejecuta en estos casos:

```text
push a main/master
tag v*
workflow_dispatch manual
```

Si haces push de un tag como `v1.0.0`, tambien crea un GitHub Release con los artefactos adjuntos.

## Como Lanzar El Build En GitHub

1. Crea un repositorio en GitHub.

2. Inicializa Git si todavia no lo hiciste:

```bash
git init
git add .
git commit -m "feat: build gather desktop linux packages with pake"
```

3. Conecta el remoto:

```bash
git remote add origin git@github.com:TU_USUARIO/TU_REPO.git
```

4. Sube la rama principal:

```bash
git branch -M main
git push -u origin main
```

5. Para crear una release con `.deb` y `.AppImage`:

```bash
git tag v1.0.0
git push origin v1.0.0
```

6. Ve a GitHub:

```text
Repository -> Actions -> Build Gather Desktop Linux
```

O si usaste tag:

```text
Repository -> Releases -> v1.0.0
```

## Como Probar El AppImage

Descarga `gatherdesktop.AppImage` desde GitHub Actions o Releases.

Luego:

```bash
chmod +x gatherdesktop.AppImage
./gatherdesktop.AppImage
```

Si usas CachyOS/Arch y aparece un crash de `WebKitWebProcess`, no hay un workaround estable dentro de Pake/Tauri. Para Gather Town en CachyOS, usa la version web en Chromium/Firefox o considera una implementacion Electron basada en Chromium.

## Como Usar El DEB

El `.deb` es para Debian/Ubuntu:

```bash
sudo apt install ./gatherdesktop.deb
```

No se recomienda instalar el `.deb` en CachyOS/Arch.

## Build Local Opcional

Solo para pruebas locales, puedes compilar con:

```bash
npx pake-cli https://app.v2.gather.town/app \
  --name "GatherDesktop" \
  --width 1280 \
  --height 800 \
  --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  --inject inject.js \
  --targets deb,appimage
```

En CachyOS, el AppImage local puede fallar. Para CachyOS, prueba primero el AppImage generado por GitHub CI.
