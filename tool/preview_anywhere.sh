#!/usr/bin/env bash
set -euo pipefail

RENDERER="${RENDERER:-html}"   # html | canvaskit

PORT="${PORT:-3020}"

echo "1) Flutter build (release web)"
flutter clean >/dev/null 2>&1 || true
flutter pub get

# Older Flutter versions may not support --web-renderer flag; fall back to defines
SKIA_DEFINE="--dart-define=FLUTTER_WEB_USE_SKIA=true --dart-define=FLUTTER_WEB_USE_SKWASM=false"
case "$RENDERER" in
  html|HTML)
    SKIA_DEFINE="--dart-define=FLUTTER_WEB_USE_SKIA=false --dart-define=FLUTTER_WEB_USE_SKWASM=false"
    ;;
  canvaskit|CANVASKIT)
    SKIA_DEFINE="--dart-define=FLUTTER_WEB_USE_SKIA=true --dart-define=FLUTTER_WEB_USE_SKWASM=false"
    ;;
  *) ;;
esac

flutter build web --no-tree-shake-icons --release \
  $SKIA_DEFINE \
  --dart-define=FORCE_MOBILE_FLOW=true \
  --dart-define=FLOW_QUARANTINE=true

echo "2) Local HTTP server on :$PORT"
cd build/web
echo "Serving from: $(pwd)"
python3 -m http.server "$PORT" --bind 0.0.0.0 >/tmp/preview_http.log 2>&1 &
HTTP_PID=$!

cleanup() {
  kill $HTTP_PID 2>/dev/null || true
  if [[ -n "${NGROK_PID:-}" ]]; then kill $NGROK_PID 2>/dev/null || true; fi
}
trap cleanup EXIT

LAN_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "127.0.0.1")

QS='?preview=mobile&skipSetup=1#/home'
LOCAL_URL="http://localhost:${PORT}/${QS}"
LAN_URL="http://${LAN_IP}:${PORT}/${QS}"

echo "3) ngrok http $PORT"
if ! command -v ngrok >/dev/null 2>&1; then
  echo "ngrok not found. Install and re-run for public URL."
  echo
  echo "Local:   $LOCAL_URL"
  echo "LAN:     $LAN_URL"
  wait
fi

ngrok http --log=stdout "$PORT" >/tmp/ngrok.log 2>&1 &
NGROK_PID=$!

PUB_URL=""
for i in {1..60}; do
  PUB_URL=$(grep -Eo 'https://[a-z0-9-]+\.ngrok(-free)?\.app' /tmp/ngrok.log | head -1 || true)
  [[ -n "$PUB_URL" ]] && break
  sleep 0.5
done

PUB_FULL="${PUB_URL}/${QS}"

echo
echo "================= PREVIEW LINKS ================="
echo "Renderer: $RENDERER"
echo "Desktop: $LOCAL_URL"
echo "LAN:     $LAN_URL"
if [[ -n "$PUB_URL" ]]; then
  echo "Public:  $PUB_FULL"
else
  echo "Public:  (ngrok not ready)"
fi
echo "================================================="
echo
wait


