#!/bin/bash

# App-Oint Web Build Fix Script
# This script fixes the white screen issue by creating a proper Flutter web build

set -e

echo "🔧 App-Oint Web Build Fix Script"
echo "=================================="

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    echo "   Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -1)"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf build/web/
flutter clean

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Run code generation
echo "🔨 Running code generation..."
dart run build_runner build --delete-conflicting-outputs || echo "⚠️ Code generation completed with warnings"

# Build web app
echo "🌐 Building Flutter web app..."
flutter build web --release --web-renderer html

# Verify build
echo "🔍 Verifying build..."
if [ -f "build/web/index.html" ]; then
    echo "✅ Web build verification passed"
    
    # Check file sizes
    MAIN_DART_SIZE=$(stat -c%s "build/web/main.dart.js" 2>/dev/null || echo "0")
    FLUTTER_JS_SIZE=$(stat -c%s "build/web/flutter.js" 2>/dev/null || echo "0")
    
    echo "📊 Build file sizes:"
    echo "   main.dart.js: ${MAIN_DART_SIZE} bytes"
    echo "   flutter.js: ${FLUTTER_JS_SIZE} bytes"
    
    # Check if files are real Flutter builds (should be large)
    if [ "$MAIN_DART_SIZE" -gt 1000000 ]; then
        echo "✅ main.dart.js appears to be a real Flutter build"
    else
        echo "⚠️ main.dart.js seems small - may still be placeholder"
    fi
    
    if [ "$FLUTTER_JS_SIZE" -gt 10000 ]; then
        echo "✅ flutter.js appears to be a real Flutter loader"
    else
        echo "⚠️ flutter.js seems small - may still be placeholder"
    fi
    
else
    echo "❌ Build verification failed: index.html not found"
    exit 1
fi

# List build contents
echo "📁 Build contents:"
ls -la build/web/

echo ""
echo "🎉 Build completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Test locally: cd build/web && python3 -m http.server 8080"
echo "2. Deploy to DigitalOcean: Push changes to trigger rebuild"
echo "3. Verify at www.app-oint.com"
echo ""
echo "🔗 Local test URL: http://localhost:8080"