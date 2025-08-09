#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Starting Firestore emulator…"
# Run emulator in the background
npx firebase emulators:start --only firestore --project demo-app --import=./seeddata >/tmp/emulator.log 2>&1 &
EMULATOR_PID=$!

# Give it a moment
sleep 5

echo "✅ Running happy-path smoke tests…"
flutter test test/smoke/ || { echo "❌ Smoke tests failed before chaos"; kill $EMULATOR_PID; exit 1; }

echo "💥 Killing Firestore emulator to simulate outage…"
kill $EMULATOR_PID || true
sleep 2

echo "🧪 Running app healthcheck under outage (expected to handle gracefully)…"
# Replace with a very lightweight test that should not hard-crash (expects graceful error handling)
flutter test test/smoke/offline_resilience_smoke_test.dart && echo "✅ Graceful handling confirmed" || {
  echo "⚠️ Resilience test failed — investigate error handling paths."
  exit 2
}

echo "🔄 Restarting emulator for cleanup…"
npx firebase emulators:start --only firestore --project demo-app --import=./seeddata >/tmp/emulator.log 2>&1 &
CLEANUP_PID=$!
sleep 3

echo "🧹 Running cleanup tests…"
flutter test test/smoke/ || { echo "❌ Cleanup tests failed"; kill $CLEANUP_PID; exit 3; }

kill $CLEANUP_PID || true
echo "✅ Chaos drill completed successfully"

