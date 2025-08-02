#!/bin/bash
set -e

DART_VERSION="3.4.0"
FLUTTER_VERSION="3.32.0"

# Install Dart
echo "Installing Dart $DART_VERSION..."
mkdir -p ~/.local
curl -sSL "https://storage.googleapis.com/dart-archive/channels/stable/release/${DART_VERSION}/sdk/dartsdk-linux-x64-release.zip" -o dart-sdk.zip
unzip -q dart-sdk.zip -d ~/.local
rm dart-sdk.zip
export PATH="${HOME}/.local/dart-sdk/bin:$PATH"

echo "Installing Flutter $FLUTTER_VERSION..."
curl -sSL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
tar xf flutter.tar.xz -C ~/.local
rm flutter.tar.xz
export PATH="${HOME}/.local/flutter/bin:$PATH"

flutter --version
dart --version

# Accept licenses
flutter doctor --android-licenses || true

# Get dependencies and run checks
flutter pub get
flutter analyze
dart test

echo "Setup complete"
