#!/usr/bin/env bash
set -euo pipefail

DART_VERSION=3.4.0
FLUTTER_VERSION=3.32.0

mkdir -p "$HOME/sdks"
cd "$HOME/sdks"

# Install Dart
if [ ! -d "dart-sdk" ]; then
  curl -sSL "https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip" -o dartsdk.zip
  unzip -q dartsdk.zip
  rm dartsdk.zip
fi

# Install Flutter
if [ ! -d "flutter" ]; then
  curl -sSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
  tar xf flutter.tar.xz
  rm flutter.tar.xz
fi

export PATH="$HOME/sdks/dart-sdk/bin:$HOME/sdks/flutter/bin:$PATH"

yes | flutter doctor --android-licenses >/dev/null 2>&1 || true

cd "$(git rev-parse --show-toplevel)"

flutter pub get
flutter analyze

dart test --coverage
