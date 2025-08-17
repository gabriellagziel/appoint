#!/usr/bin/env bash
set -euo pipefail
port="${1:-3010}"
cd appoint
# Prefer web-server so it doesn't try to pick Chrome device
flutter clean >/dev/null 2>&1 || true
flutter pub get
flutter run -d web-server --web-port "$port" --web-hostname localhost \
  --dart-define=FEATURE_ADS=0 \
  --dart-define=ADS_PROVIDER=""




