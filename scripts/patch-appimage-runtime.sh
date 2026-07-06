#!/usr/bin/env bash
set -euo pipefail

INPUT_APPIMAGE="${1:?Usage: patch-appimage-runtime.sh INPUT.AppImage OUTPUT.AppImage}"
OUTPUT_APPIMAGE="${2:?Usage: patch-appimage-runtime.sh INPUT.AppImage OUTPUT.AppImage}"
APPIMAGETOOL="${APPIMAGETOOL:-appimagetool}"

if [[ ! -f "$INPUT_APPIMAGE" ]]; then
  echo "Input AppImage not found: $INPUT_APPIMAGE" >&2
  exit 1
fi

if ! command -v "$APPIMAGETOOL" >/dev/null 2>&1 && [[ ! -x "$APPIMAGETOOL" ]]; then
  echo "appimagetool not found. Set APPIMAGETOOL=/path/to/appimagetool" >&2
  exit 1
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

cp "$INPUT_APPIMAGE" "$WORKDIR/input.AppImage"
chmod +x "$WORKDIR/input.AppImage"

(
  cd "$WORKDIR"
  ./input.AppImage --appimage-extract >/dev/null
)

APPDIR="$WORKDIR/squashfs-root"
APPRUN="$APPDIR/AppRun"
REAL_APPRUN="$APPDIR/AppRun.real"

if [[ ! -e "$APPRUN" ]]; then
  echo "AppRun not found inside AppImage" >&2
  exit 1
fi

mv "$APPRUN" "$REAL_APPRUN"

cat > "$APPRUN" <<'EOF'
#!/usr/bin/env bash
set -e

# Runtime mitigations for WebKitGTK AppImage on rolling-release systems.
# Scoped to this AppImage process only.
export GDK_BACKEND=x11
export WEBKIT_DISABLE_DMABUF_RENDERER=1
export WEBKIT_DISABLE_COMPOSITING_MODE=1
export WEBKIT_FORCE_SANDBOX=0
export WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS=1

HERE="$(dirname "$(readlink -f "$0")")"
exec "$HERE/AppRun.real" "$@"
EOF

chmod +x "$APPRUN" "$REAL_APPRUN"

ARCH=x86_64 "$APPIMAGETOOL" "$APPDIR" "$OUTPUT_APPIMAGE"
chmod +x "$OUTPUT_APPIMAGE"
