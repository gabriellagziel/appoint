#!/bin/bash
set -e
MODE="$1"

case "$MODE" in
  unit)
    flutter test
    ;;
  integration)
    npx firebase emulators:start --only firestore,functions --project "$FIREBASE_PROJECT" --import=./emulator_data &
    EMULATOR_PID=$!
    sleep 5
    flutter test integration_test/app_test.dart
    kill $EMULATOR_PID
    ;;
  all|*)
    npx firebase emulators:start --only firestore,functions --project "$FIREBASE_PROJECT" --import=./emulator_data &
    EMULATOR_PID=$!
    sleep 5
    flutter test
    flutter test integration_test/app_test.dart
    kill $EMULATOR_PID
    ;;
esac
