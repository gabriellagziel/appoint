#!/bin/bash

echo "🔍 Validating Production Security..."
echo "=================================="

# Check for cleartext traffic
echo "Checking Android cleartext traffic..."
if grep -q "usesCleartextTraffic=\"true\"" android/app/src/main/AndroidManifest.xml; then
    echo "❌ WARNING: Cleartext traffic still enabled!"
else
    echo "✅ Android cleartext traffic disabled"
fi

# Check for arbitrary loads in iOS
echo "Checking iOS arbitrary loads..."
if grep -q "NSAllowsArbitraryLoads" ios/Runner/Info.plist; then
    echo "❌ WARNING: Arbitrary loads still enabled!"
else
    echo "✅ iOS arbitrary loads disabled"
fi

# Check for exposed API keys
echo "Checking for exposed API keys..."
if grep -q "AIzaSy" android/app/google-services.json; then
    echo "❌ WARNING: API keys found in google-services.json"
else
    echo "✅ No API keys found in google-services.json"
fi

if grep -q "AIzaSy" ios/Runner/GoogleService-Info.plist; then
    echo "❌ WARNING: API keys found in GoogleService-Info.plist"
else
    echo "✅ No API keys found in GoogleService-Info.plist"
fi

# Check permissions
echo "Checking Android permissions..."
grep "uses-permission" android/app/src/main/AndroidManifest.xml | wc -l | xargs echo "📱 Android permissions count:"

echo "Checking iOS permissions..."
grep "UsageDescription" ios/Runner/Info.plist | wc -l | xargs echo "📱 iOS permissions count:"

echo "✅ Security validation complete!"
