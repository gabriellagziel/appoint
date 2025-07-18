#!/usr/bin/env bash
set -euo pipefail

log() { echo -e "\033[1;34m[INFO]\033[0m $1";}
error() { echo -e "\033[0;31m[ERROR]\033[0m $1" >&2;}
trap 'error "Checks failed."' ERR

PROJECT_DIR="/workspace"
cd "$PROJECT_DIR"

log "Installing system packages"
sudo apt-get update -yq
sudo apt-get install -yq git curl unzip xz-utils openjdk-11-jdk ninja-build libgtk-3-dev libstdc++6 libglu1-mesa

# Install Android SDK cmdline tools if not existing
ANDROID_SDK_ROOT="$HOME/Android/Sdk"
if [ ! -d "$ANDROID_SDK_ROOT/cmdline-tools/latest" ]; then
  log "Installing Android SDK command-line tools"
  mkdir -p "$ANDROID_SDK_ROOT"
  cd "$ANDROID_SDK_ROOT"
  curl -L -o cmdline-tools.zip https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
  unzip -q cmdline-tools.zip
  mkdir -p cmdline-tools/latest
  mv cmdline-tools/* cmdline-tools/latest/ || true
  rm cmdline-tools.zip
fi

export ANDROID_SDK_ROOT
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$PATH"

# Install Flutter if not present
if ! command -v flutter &>/dev/null; then
  log "Installing Flutter SDK"
  cd "$HOME"
  curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz -o flutter.tar.xz
  tar xf flutter.tar.xz
  rm flutter.tar.xz
  export PATH="$HOME/flutter/bin:$PATH"
  flutter --version
  flutter precache --web --linux --android
fi

# Accept Android licenses via Flutter helper (more reliable than sdkmanager)
yes | flutter doctor --android-licenses || true

# Install required Android platforms/build-tools
yes | sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.2" || true

cd "$PROJECT_DIR"
# Run readiness script if exists
if [ -f "./readiness_check.sh" ]; then
  log "Running readiness_check.sh"
  chmod +x readiness_check.sh
  ./readiness_check.sh all 2>&1 | tee readiness_run.log
else
  log "Fallback to inline checks"
  flutter pub get 2>&1 | tee flutter_pub_get.log
  flutter analyze --no-fatal-infos 2>&1 | tee flutter_analyze.log
  flutter test --machine 2>&1 | tee flutter_test.log
  flutter build apk --release 2>&1 | tee flutter_build_apk.log
  flutter build web --release 2>&1 | tee flutter_build_web.log
fi

# Generate readiness report if script available
if [ -f "./generate_readiness_report.py" ]; then
  log "Generating readiness_report.md via Python"
  python3 generate_readiness_report.py
fi

log "✅ Finished all checks"
