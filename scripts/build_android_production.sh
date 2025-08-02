#!/bin/bash

# Load environment variables
if [ -f .env.production ]; then
    export $(cat .env.production | grep -v '^#' | xargs)
fi

echo "🔨 Building Android Production APK..."

# Clean build
cd android
./gradlew clean

# Build release APK
./gradlew assembleRelease

echo "✅ Android production build complete!"
echo "📱 APK location: android/app/build/outputs/apk/release/app-release.apk"
