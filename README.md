# Web To App Builder

Plantilla para convertir una aplicacion web en paquetes Linux de escritorio usando Pake/Tauri y GitHub Actions.

La primera aplicacion configurada por defecto es:

```text
https://web.whatsapp.com/
```

Artefactos generados:

```text
.AppImage
.deb
```

## Archivos

```text
inject.js
.github/workflows/build.yml
README.md
```

## Como Funciona

El workflow de GitHub Actions compila la app en `ubuntu-22.04` usando `pake-cli`.

Puedes construir cualquier portal web cambiando los inputs manuales del workflow:

```text
app_url
package_name
width
height
targets
user_agent
```

## Build Manual Desde GitHub Actions

1. Sube este repositorio a GitHub.

2. Ve a:

```text
Repository -> Actions -> Build Web App Desktop Linux -> Run workflow
```

3. Completa los campos. Para WhatsApp Web usa:

```text
app_url: https://web.whatsapp.com/
package_name: WhatsAppDesktop
width: 1280
height: 800
targets: deb,appimage
user_agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36
```

4. Descarga los artefactos desde:

```text
Repository -> Actions -> build run -> Artifacts
```

## Build Por Tag / Release

Si haces push de un tag `v*`, el workflow crea una GitHub Release con los artefactos adjuntos.

```bash
git tag v1.0.0
git push origin v1.0.0
```

Luego descarga desde:

```text
Repository -> Releases -> v1.0.0
```

## Primer Push A GitHub

```bash
git init
git add .
git commit -m "feat: add generic web to app builder"
git branch -M main
git remote add origin git@github.com:TU_USUARIO/TU_REPO.git
git push -u origin main
```

## Probar AppImage

```bash
chmod +x WhatsAppDesktop*.AppImage
./WhatsAppDesktop*.AppImage
```

El nombre exacto del archivo puede variar segun Pake. Si no coincide, lista los artefactos:

```bash
ls -lah *.AppImage
```

## Instalar DEB

En Debian/Ubuntu:

```bash
sudo apt install ./WhatsAppDesktop*.deb
```

No se recomienda instalar `.deb` directamente en Arch/CachyOS.

## Build Local Opcional

Para construir localmente WhatsApp Web:

```bash
npx pake-cli https://web.whatsapp.com/ \
  --name "WhatsAppDesktop" \
  --width 1280 \
  --height 800 \
  --user-agent "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
  --inject inject.js \
  --targets deb,appimage
```

## Notas

Pake usa WebKitGTK en Linux. Algunas aplicaciones web con WebRTC avanzado pueden ser inestables en WebKitGTK. Para apps muy dependientes de Chromium, Electron puede ser una alternativa mas compatible.
