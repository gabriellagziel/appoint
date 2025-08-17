#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-3020}"
RENDERER="${RENDERER:-html}"  # html | canvaskit

cd "$(dirname "$0")/.."  # project root /appoint

flutter clean >/dev/null 2>&1 || true
flutter pub get

# Some Flutter versions lack --web-renderer; toggle renderer via defines instead
EXTRA_RENDER_DEFINES="--dart-define=FLUTTER_WEB_USE_SKIA=false --dart-define=FLUTTER_WEB_USE_SKWASM=false"
if [[ "$RENDERER" == "canvaskit" ]]; then
  EXTRA_RENDER_DEFINES="--dart-define=FLUTTER_WEB_USE_SKIA=true --dart-define=FLUTTER_WEB_USE_SKWASM=false"
fi

flutter build web --no-tree-shake-icons --release \
  $EXTRA_RENDER_DEFINES \
  --dart-define=FORCE_MOBILE_FLOW=true

cd build/web
echo "Serving from: $(pwd)"
python3 -m http.server "$PORT" --bind 0.0.0.0 >/tmp/appoint_preview_http.log 2>&1 &
HTTP_PID=$!
trap 'kill $HTTP_PID 2>/dev/null || true; kill ${NGROK_PID:-0} 2>/dev/null || true' EXIT

LAN_IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "127.0.0.1")

echo "================= PREVIEW LINKS ================="
echo "Renderer: $RENDERER"
echo "Desktop:  http://localhost:${PORT}/#/home"
echo "Preview:  http://localhost:${PORT}/?preview=mobile&skipSetup=1#/home"
echo "LAN:      http://${LAN_IP}:${PORT}/?preview=mobile&skipSetup=1#/home"
if command -v ngrok >/dev/null 2>&1; then
  ngrok http --log=stdout "$PORT" >/tmp/appoint_ngrok.log 2>&1 &
  NGROK_PID=$!
  for i in {1..60}; do
    PUB=$(grep -Eo 'https://[a-z0-9-]+\.ngrok(-free)?\.app' /tmp/appoint_ngrok.log | head -1 || true)
    [[ -n "$PUB" ]] && break
    sleep 0.2
  done
  if [[ -n "$PUB" ]]; then
    echo "Public:   ${PUB}/?preview=mobile&skipSetup=1#/home"
  else
    echo "Public:   (install ngrok)"
  fi
else
  echo "Public:   (install ngrok)"
fi
echo "================================================="
wait


