#!/bin/bash
# Upgrade Flutter to latest stable and ensure Dart >=3.4.0.
# If Flutter upgrade fails, install standalone Dart via apt.
set -e

FLUTTER_SDK="/workspace/flutter_sdk"
export PATH="$FLUTTER_SDK/bin:$PATH"

# Ensure Flutter repository is treated as safe by Git
git config --global --add safe.directory "$FLUTTER_SDK"

if [ ! -d "$FLUTTER_SDK" ]; then
  echo "Flutter SDK not found at $FLUTTER_SDK" >&2
  exit 1
fi

cd "$FLUTTER_SDK"

# Switch to the stable channel using git and flutter
git fetch
git checkout stable
flutter channel stable

# Attempt to upgrade Flutter
if flutter upgrade; then
  echo "Flutter upgraded successfully"
else
  echo "Flutter upgrade failed. Installing Dart SDK via apt..."
  sudo apt-get update
  sudo apt-get install -y apt-transport-https wget gnupg
  wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
  sudo apt-get update
  sudo apt-get install -y dart
fi

# Version comparison helper (returns true if $1 >= $2)
version_ge() {
  [ "$(printf '%s\n' "$2" "$1" | sort -V | head -n1)" = "$2" ]
}

flutter_version=$(flutter --version 2>&1 | head -n1 | awk '{print $2}')
# dart --version outputs to stderr
dart_version=$(dart --version 2>&1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

if version_ge "$flutter_version" "3.4.0" && version_ge "$dart_version" "3.4.0"; then
  echo "Flutter $flutter_version and Dart $dart_version meet requirements"
else
  echo "Error: Flutter $flutter_version or Dart $dart_version is < 3.4.0" >&2
  exit 1
fi
