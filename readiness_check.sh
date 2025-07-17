#!/usr/bin/env bash

# Fail immediately on error, unset variable usage, or failed pipeline member
set -euo pipefail

#############################
# Utility functions
#############################
log() {
  echo -e "\033[1;34m[INFO]\033[0m $1"
}

cleanup() {
  # Kill background server if it is still running
  if [[ -n "${SERVER_PID:-}" ]] && kill -0 "$SERVER_PID" 2>/dev/null; then
    log "Stopping website server (PID: $SERVER_PID)"
    kill "$SERVER_PID" || true
    wait "$SERVER_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT
trap 'echo -e "\033[0;31m[ERROR]\033[0m Checks failed. Exiting."; exit 1' ERR

#############################
# 1. Flutter application
#############################
log "Running Flutter checks"

flutter pub get
flutter analyze
flutter test
flutter build apk --release
flutter build web --release

#############################
# 2. Website
#############################
log "Running website checks"

pushd website >/dev/null

npm ci
npm run lint
npm run test
npm run build

log "Starting website server for health check"
PORT=${PORT:-3000}
# Start server in background
npm start &
SERVER_PID=$!

# Give the server time to start
sleep 8

log "Running health check"
curl --fail "http://localhost:${PORT}/healthz"

popd >/dev/null

#############################
# Success message
#############################
log "All checks passed — מוכן לדיפלוימנט! 🎉"