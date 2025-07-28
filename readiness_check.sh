#!/usr/bin/env bash

# Fail immediately on error, unset variable usage, or failed pipeline member
set -euo pipefail

#############################
# Utility functions
#############################
log() {
  echo -e "\033[1;34m[INFO]\033[0m $1"
}

error() {
  echo -e "\033[0;31m[ERROR]\033[0m $1" >&2
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
trap 'error "Checks failed. Exiting."; exit 1' ERR

#############################
# Functions per component
#############################
run_flutter_checks() {
  log "Running Flutter checks"
  flutter pub get
  flutter analyze
  flutter test
  flutter build apk --release
  flutter build web --release
}

run_website_checks() {
  log "Running website checks"
  pushd website >/dev/null

  npm ci
  npm run lint
  npm run test
  npm run build

  log "Starting website server for health check"
  PORT=${PORT:-3000}
  # Ensure PORT is exported so frameworks like CRA pick it up
  export PORT
  npm start &
  SERVER_PID=$!

  # Give the server time to start
  sleep 8

  log "Running health check"
  curl --fail "http://localhost:${PORT}/healthz"

  # Stop server explicitly (cleanup will handle any leftovers)
  kill "$SERVER_PID" || true
  wait "$SERVER_PID" 2>/dev/null || true
  unset SERVER_PID

  popd >/dev/null
}

#############################
# Argument parsing
#############################
usage() {
  cat <<EOF
Usage: $0 [flutter|website|all]
Run readiness checks.
  flutter  – only Flutter checks
  website  – only website checks
  all      – run everything (default)
EOF
}

SECTION="all"
if [[ $# -gt 1 ]]; then
  usage
  exit 1
elif [[ $# -eq 1 ]]; then
  SECTION=$1
fi

case "$SECTION" in
  flutter)
    run_flutter_checks
    ;;
  website)
    run_website_checks
    ;;
  all)
    run_flutter_checks
    run_website_checks
    ;;
  *)
    usage
    exit 1
    ;;
esac

#############################
# Success message
#############################
log "All checks passed — מוכן לדיפלוימנט! 🎉"