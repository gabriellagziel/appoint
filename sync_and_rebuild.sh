#!/bin/bash
echo "🔄 Pulling latest from GitHub..."
git pull origin main

echo "🧹 Cleaning project..."
flutter clean
dart pub get

echo "🔁 Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "🧪 Analyzing project..."
flutter analyze | tee fresh_reindex.txt
