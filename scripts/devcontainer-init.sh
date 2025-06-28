#!/bin/bash
set -e
flutter pub get --offline
flutter pub run build_runner build --delete-conflicting-outputs --offline
