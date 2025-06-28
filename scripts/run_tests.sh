#!/bin/bash
set -e
MODE="$1"

case "$MODE" in
  unit)
    export FIREBASE_STORAGE_EMULATOR_HOST="localhost:9199"
    if command -v dart >/dev/null 2>&1; then
      dart test --coverage
    else
      flutter test --coverage
    fi
    ;;
  integration)
    export FIREBASE_STORAGE_EMULATOR_HOST="localhost:9199"
    npx firebase emulators:start --only firestore,functions,storage --project "$FIREBASE_PROJECT" --import=./emulator_data &
    EMULATOR_PID=$!
    sleep 5
    if command -v dart >/dev/null 2>&1; then
      dart test integration_test/app_test.dart
    else
      flutter test integration_test
    fi
    kill $EMULATOR_PID
    ;;
  all|*)
    export FIREBASE_STORAGE_EMULATOR_HOST="localhost:9199"
    npx firebase emulators:start --only firestore,functions,storage --project "$FIREBASE_PROJECT" --import=./emulator_data &
    EMULATOR_PID=$!
    sleep 5
    if command -v dart >/dev/null 2>&1; then
      dart test --coverage
      dart test integration_test/app_test.dart
    else
      flutter test --coverage
      flutter test integration_test
    fi
    kill $EMULATOR_PID
    ;;
esac
