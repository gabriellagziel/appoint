#!/bin/bash

# Load environment variables
if [ -f .env.production ]; then
    export $(cat .env.production | grep -v '^#' | xargs)
fi

echo "🔨 Building iOS Production IPA..."

# Clean build
flutter clean
flutter pub get

# Build iOS release
flutter build ios --release

echo "✅ iOS production build complete!"
echo "📱 IPA location: build/ios/iphoneos/Runner.app"
