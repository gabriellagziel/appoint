#!/bin/bash
set -e
flutter pub run build_runner build --delete-conflicting-outputs --offline
