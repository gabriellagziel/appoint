#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-3020}"

# Ensure we run from the Flutter project root (this script lives in project_root/scripts)
cd "$(dirname "$0")/.."

banner() { printf "\n\033[1m==> %s\033[0m\n" "$*"; }
ok()     { printf "\033[32m✔ %s\033[0m\n" "$*"; }
warn()   { printf "\033[33m⚠ %s\033[0m\n" "$*"; }
err()    { printf "\033[31m✖ %s\033[0m\n" "$*"; }

# 0) Kill anything on common ports / old serve
banner "Killing old servers on $PORT (and friends)"
for p in "$PORT" 3010 3000 5500; do
  lsof -ti :$p | xargs -I{} kill -9 {} 2>/dev/null || true
done
pkill -f "npx serve" 2>/dev/null || true
pkill -f "python3 -m http.server" 2>/dev/null || true
ok "Ports cleared"

# 1) Clean & build
banner "Flutter clean + get + release build"
flutter clean >/dev/null 2>&1 || true
flutter pub get
flutter build web --release

# 2) Verify build artifacts exist & non-empty
banner "Verifying build artifacts"
ls -lh build/web | grep -E 'index.html|flutter.js|main.dart.js' || {
  err "Missing core artifacts in build/web"; exit 1; }
SZ="$(stat -f%z build/web/main.dart.js 2>/dev/null || stat -c%s build/web/main.dart.js)"
if [[ -z "$SZ" || "$SZ" -lt 100000 ]]; then
  err "main.dart.js seems too small ($SZ bytes) — build likely failed"; exit 1;
fi
ok "Artifacts look good (main.dart.js: ${SZ} bytes)"

# 3) Serve from *correct* root (build/web)
banner "Starting static server from build/web on :$PORT"
pushd build/web >/dev/null
if command -v npx >/dev/null 2>&1; then
  npx serve -s -l $PORT > /tmp/serve_$PORT.log 2>&1 &
  SRV_PID=$!
else
  warn "npx not found; falling back to python http.server"
  python3 -m http.server $PORT > /tmp/serve_$PORT.log 2>&1 &
  SRV_PID=$!
fi
sleep 2

# 4) Sanity HTTP checks (200s for core files)
banner "Sanity HTTP checks"
for u in / /index.html /flutter.js /main.dart.js; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:$PORT$u")
  [[ "$code" == "200" ]] || { err "$u → HTTP $code (should be 200)"; kill $SRV_PID; exit 1; }
  ok "$u → 200"
done

# 5) Open in the right order (bypass SW + force hash routing)
banner "Opening app (bypass SW on first load)"
URL_ROOT="http://localhost:$PORT"
OPEN_CMD="open"; command -v xdg-open >/dev/null && OPEN_CMD="xdg-open"

$OPEN_CMD "$URL_ROOT/?noSW=1" >/dev/null 2>&1 || true
sleep 1
$OPEN_CMD "$URL_ROOT/#/?noSW=1" >/dev/null 2>&1 || true
sleep 1
$OPEN_CMD "$URL_ROOT/#/home?noSW=1" >/dev/null 2>&1 || true

cat <<'MSG'

REDACTED_TOKEN
If you see a white page:

1) Chrome DevTools → Console → copy the FIRST red error line to me.
2) DevTools → Application → Service Workers → Unregister (if any).
   Application → Clear storage → Clear site data → Hard reload.
3) Reload these in order:
   - /           (with ?noSW=1)
   - #/          (with ?noSW=1)
   - #/home      (with ?noSW=1)

Server log (tail) →  /tmp/serve_3020.log (or port you used)
Stop server:        kill -9 $SRV_PID
REDACTED_TOKEN

MSG

wait $SRV_PID || true
popd >/dev/null

