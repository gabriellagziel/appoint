#!/bin/bash

# Complete Firebase Deployment Script
# Fixes the broken www.app-oint.com deployment

set -e

echo "🚀 Completing Firebase Hosting Deployment for www.app-oint.com"
echo "=================================================="

# Check if Firebase CLI is available
if ! command -v firebase &> /dev/null; then
    echo "❌ Firebase CLI not found. Installing..."
    npm install -g firebase-tools
fi

echo "✅ Firebase CLI is available"

# Check if build directory exists
if [ ! -d "build/web" ]; then
    echo "❌ build/web directory not found. The Flutter build wasn't completed."
    echo "🔧 Building Flutter web app..."
    
    # Check if Flutter is available
    if ! command -v flutter &> /dev/null; then
        echo "❌ Flutter not found. Please install Flutter first."
        exit 1
    fi
    
    # Build Flutter web
    flutter build web --release
    echo "✅ Flutter web build completed"
fi

# Verify essential files exist
echo "🔍 Verifying build files..."
required_files=("build/web/index.html" "build/web/main.dart.js" "build/web/flutter.js")

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing - build incomplete"
        exit 1
    fi
done

echo "✅ All required files present"

# Authentication options
echo ""
echo "🔐 Firebase Authentication Required"
echo "Choose an authentication method:"
echo "1. Interactive login (recommended for local)"
echo "2. Use existing token"
echo "3. Skip authentication (show commands only)"

read -p "Select option (1-3): " auth_option

case $auth_option in
    1)
        echo "🔑 Starting Firebase login..."
        firebase login
        ;;
    2)
        read -p "Enter your Firebase token: " firebase_token
        export FIREBASE_TOKEN="$firebase_token"
        echo "✅ Token set"
        ;;
    3)
        echo "⚠️ Skipping authentication - will show manual commands"
        MANUAL_MODE=true
        ;;
    *)
        echo "❌ Invalid option. Exiting."
        exit 1
        ;;
esac

# Set Firebase project
echo ""
echo "🎯 Setting Firebase project..."

if [ "$MANUAL_MODE" = true ]; then
    echo "📋 Manual commands to run:"
    echo "firebase use app-oint-core"
    echo "firebase deploy --only hosting"
else
    if [ ! -z "$FIREBASE_TOKEN" ]; then
        firebase use app-oint-core --token "$FIREBASE_TOKEN"
    else
        firebase use app-oint-core
    fi
    echo "✅ Project set to app-oint-core"
fi

# Deploy to Firebase Hosting
echo ""
echo "🚀 Deploying to Firebase Hosting..."

if [ "$MANUAL_MODE" = true ]; then
    echo "📋 Run this command to deploy:"
    echo "firebase deploy --only hosting"
    echo ""
    echo "💡 Or if using a token:"
    echo "firebase deploy --only hosting --token YOUR_TOKEN"
else
    if [ ! -z "$FIREBASE_TOKEN" ]; then
        firebase deploy --only hosting --token "$FIREBASE_TOKEN"
    else
        firebase deploy --only hosting
    fi
    
    echo ""
    echo "🎉 DEPLOYMENT SUCCESSFUL!"
    echo "✅ Your app is now live at: https://www.app-oint.com"
    echo "✅ Default URL: https://app-oint-core.firebaseapp.com"
fi

echo ""
echo "🔍 Next Steps:"
echo "1. Visit https://www.app-oint.com to verify the fix"
echo "2. Check browser console - should be no 'Unexpected token' errors"
echo "3. Verify Flutter app loads and is interactive"
echo ""
echo "📖 For detailed information, see: deploy_firebase_fix.md"