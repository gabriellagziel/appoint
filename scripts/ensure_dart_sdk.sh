#!/bin/bash
set -e
REQUIRED_DART="3.4.0"
PUB_FLAGS=""
version_lt() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]
}
install_from_local() {
  local archive=".devcontainer/sdk_archives/dartsdk-linux-x64-release.zip"
  if [ -f "$archive" ]; then
    echo "Installing Dart $REQUIRED_DART from local archive..."
    rm -rf "$HOME/dart-sdk"
    unzip -q "$archive" -d "$HOME/dart-sdk"
    export PATH="$HOME/dart-sdk/dart-sdk/bin:$PATH"
    return 0
  fi
  return 1
}
if command -v dart >/dev/null 2>&1; then
  INSTALLED=$(dart --version 2>&1 | awk '{print $4}')
  if version_lt "$INSTALLED" "$REQUIRED_DART"; then
    install_from_local || PUB_FLAGS="--ignore-sdk-constraints"
  fi
else
  install_from_local || PUB_FLAGS="--ignore-sdk-constraints"
fi
if [ -n "$PUB_FLAGS" ]; then
  echo "Using pub flags: $PUB_FLAGS"
fi
echo "$PUB_FLAGS"
