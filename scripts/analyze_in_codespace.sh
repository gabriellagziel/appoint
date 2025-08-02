#!/bin/bash
echo "🧼 Cleaning..."
flutter clean

echo "📦 Packages preloaded via Docker cache"

echo "🛠️ Running build_runner..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "🔍 Analyzing..."
flutter analyze | tee fresh_reindex.txt
