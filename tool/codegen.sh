#!/usr/bin/env bash
set -e
flutter gen-l10n
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
