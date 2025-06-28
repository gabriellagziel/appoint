#!/bin/bash
set -e
MODE="$1"

case "$MODE" in
  unit)
    if command -v dart >/dev/null 2>&1; then
      dart test --coverage
    else
      flutter test --coverage
    fi
    ;;
  integration)
    npx firebase emulators:start --only firestore,functions --project "$FIREBASE_PROJECT" --import=./emulator_data &
    EMULATOR_PID=$!
    sleep 5
    if command -v dart >/dev/null 2>&1; then
      dart test integration_test/app_test.dart
    else
      flutter test integration_test/app_test.dart
    fi
    kill $EMULATOR_PID
    ;;
  all|*)
    npx firebase emulators:start --only firestore,functions --project "$FIREBASE_PROJECT" --import=./emulator_data &
    EMULATOR_PID=$!
    sleep 5
    if command -v dart >/dev/null 2>&1; then
      dart test --coverage
      dart test integration_test/app_test.dart
    else
      flutter test --coverage
      flutter test integration_test/app_test.dart
    fi
    kill $EMULATOR_PID
    ;;
esac
