#!/usr/bin/env bash
set -euo pipefail

# Bootstrap Flutter and Dart environment
# Installs Flutter 3.32.0 and Dart 3.4.0, then runs checks.

FLUTTER_VERSION="3.32.0"
DART_VERSION="3.4.0"

# Install Flutter if missing
if ! command -v flutter >/dev/null 2>&1; then
  echo "Downloading Flutter $FLUTTER_VERSION..."
  curl -L "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
  mkdir -p "$HOME"
  tar xf flutter.tar.xz -C "$HOME"
  rm flutter.tar.xz
  export PATH="$HOME/flutter/bin:$PATH"
fi

# Install Dart SDK
if ! command -v dart >/dev/null 2>&1 || ! dart --version 2>&1 | grep -q "$DART_VERSION"; then
  echo "Installing Dart $DART_VERSION..."
  curl -L "https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip" -o dartsdk.zip
  unzip -q dartsdk.zip -d "$HOME/dart-sdk"
  rm dartsdk.zip
  export PATH="$HOME/dart-sdk/dart-sdk/bin:$PATH"
fi

# Accept Android licenses if needed
if command -v flutter >/dev/null 2>&1; then
  yes | flutter doctor --android-licenses
fi

# Fetch dependencies and run checks
flutter pub get

dart pub get

flutter analyze
dart test
