#!/bin/bash
echo "🧼 Cleaning..."
flutter clean

echo "📦 Getting packages..."
dart pub get
flutter pub get

echo "🛠️ Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "🔍 Analyzing..."
flutter analyze | tee fresh_reindex.txt
