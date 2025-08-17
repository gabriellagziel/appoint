#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

flutter clean
flutter pub get
flutter build web --no-tree-shake-icons --release --dart-define=FORCE_MOBILE_FLOW=true
echo "✅ Build done at build/web"


