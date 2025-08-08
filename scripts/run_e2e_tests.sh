#!/bin/bash

# Script to run E2E tests with Firestore emulator
# Usage: ./scripts/run_e2e_tests.sh

set -e

echo "🚀 Starting Playtime E2E Tests with Firestore Emulator"

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found. Please install it first:"
    echo "npm install -g firebase-tools"
    exit 1
fi

# Set emulator configuration
export FIRESTORE_EMULATOR_HOST=localhost
export FIRESTORE_EMULATOR_PORT=8081

# Start Firestore emulator in background
echo "📦 Starting Firestore emulator on localhost:8081..."
firebase emulators:start --only firestore &
EMULATOR_PID=$!

# Wait for emulator to start
echo "⏳ Waiting for emulator to initialize..."
sleep 5

# Function to cleanup on exit
cleanup() {
    echo "🧹 Cleaning up..."
    kill $EMULATOR_PID 2>/dev/null || true
    wait $EMULATOR_PID 2>/dev/null || true
    echo "✅ Cleanup complete"
}

# Set trap to cleanup on script exit
trap cleanup EXIT

# Run the E2E tests
echo "🧪 Running E2E tests..."
flutter test test/e2e/playtime_e2e_test.dart \
    --dart-define=FIRESTORE_EMULATOR_HOST=localhost \
    --dart-define=FIRESTORE_EMULATOR_PORT=8081

echo "🎉 All tests completed!"
