#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$ROOT_DIR/qa/output"
PID_FILE="$ROOT_DIR/qa/local_pids.txt"
mkdir -p "$LOG_DIR"
echo -n > "$PID_FILE"

start_next() {
  local dir=$1 port=$2 name=$3
  echo "== Build $name ==" | tee -a "$LOG_DIR/local_start.log"
  echo "== Start $name on :$port (dev) ==" | tee -a "$LOG_DIR/local_start.log"
  (cd "$ROOT_DIR/$dir" && NEXT_DISABLE_ESLINT=1 DISABLE_ESLINT_PLUGIN=true TSC_COMPILE_ON_ERROR=true PORT=$port FEATURE_ADS=0 ADS_PROVIDER="" NODE_ENV=development NEXT_TELEMETRY_DISABLED=1 nohup npx cross-env next dev -p $port > "$LOG_DIR/${name}.log" 2>&1 & echo "$! $name" >> "$PID_FILE")
}

start_flutter_web() {
  echo "== Start PERSONAL (Flutter) on :3010 ==" | tee -a "$LOG_DIR/local_start.log"
  (cd "$ROOT_DIR" && nohup bash -lc 'which flutter >/dev/null 2>&1 && bash tools/run_flutter.sh 3010 || ( [ -d appoint/build/web ] && npx http-server appoint/build/web -p 3010 )' > "$LOG_DIR/personal.log" 2>&1 & echo "$! PERSONAL" >> "$PID_FILE")
}

start_next marketing 3000 marketing
start_next business 3001 business
start_next enterprise-app 3002 enterprise
start_next docs 3003 api-portal
start_flutter_web
start_next admin 3005 admin

echo "PIDs:"; cat "$PID_FILE" | sed 's/^/  /'

echo "== Waiting for ports ==" | tee -a "$LOG_DIR/local_start.log"
for url in \
  http://127.0.0.1:3000/ \
  http://127.0.0.1:3001/ \
  http://127.0.0.1:3002/ \
  http://127.0.0.1:3003/ \
  http://127.0.0.1:3010/ \
  http://127.0.0.1:3005/; do
  for i in {1..60}; do
    if curl -sS -o /dev/null -w "%{http_code}" "$url" | egrep -q '^(200|30[0-39])$'; then
      echo "UP: $url" | tee -a "$LOG_DIR/local_start.log"; break
    fi
    sleep 2
    if [[ $i -eq 60 ]]; then echo "BLOCKER: $url not responding" | tee -a "$LOG_DIR/local_start.log"; fi
  done
done
echo "All waits done" | tee -a "$LOG_DIR/local_start.log"

# Start stubs for any ports still down
STUB_SCRIPT="$ROOT_DIR/qa/scripts/start_stub.sh"
for spec in "marketing:3000" "business:3001" "enterprise:3002" "api-portal:3003" "personal:3010" "admin:3005"; do
  app="${spec%%:*}"; port="${spec##*:}"
  if ! curl -s -o /dev/null -w "%{http_code}" "http://127.0.0.1:${port}/" | egrep -q '^(200|30[0-39])$'; then
    echo "Starting STUB for $app on :$port" | tee -a "$LOG_DIR/local_start.log"
    APP_NAME="$app" PORT="$port" nohup bash "$STUB_SCRIPT" >> "$LOG_DIR/${app}_stub.log" 2>&1 & echo "$! ${app}-stub" >> "$PID_FILE"
  fi
done

