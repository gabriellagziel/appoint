#!/bin/bash

# Mobile Apps Security Fix Script
# Fixes critical security issues identified in the audit

echo "🔒 Mobile Apps Security Fix Script"
echo "=================================="

# Create backup
echo "📦 Creating backup..."
cp android/app/src/main/AndroidManifest.xml android/app/src/main/AndroidManifest.xml.backup
cp ios/Runner/Info.plist ios/Runner/Info.plist.backup

# Fix Android cleartext traffic
echo "🔧 Fixing Android cleartext traffic..."
sed -i '' 's/android:usesCleartextTraffic="true"/android:usesCleartextTraffic="false"/' android/app/src/main/AndroidManifest.xml

# Fix iOS arbitrary loads
echo "🔧 Fixing iOS arbitrary loads..."
sed -i '' '/NSAllowsArbitraryLoads/,+1d' ios/Runner/Info.plist

# Create secure environment configuration
echo "🔧 Creating secure environment configuration..."
cat > android/app/src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Appoint</string>
    <!-- API Keys should be moved to environment variables -->
    <string name="google_maps_api_key">${GOOGLE_MAPS_API_KEY}</string>
    <string name="firebase_api_key">${FIREBASE_API_KEY}</string>
</resources>
EOF

# Create ProGuard rules for better obfuscation
echo "🔧 Creating ProGuard rules..."
cat > android/app/proguard-rules.pro << 'EOF'
# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Obfuscate package names
-repackageclasses ''

# Remove logging
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
}
EOF

# Create environment variables template
echo "🔧 Creating environment variables template..."
cat > .env.mobile.template << 'EOF'
# Mobile App Environment Variables
# Copy this file to .env.mobile and fill in your actual values

# Android
ANDROID_KEY_ALIAS=your_key_alias
ANDROID_KEY_PASSWORD=your_key_password
ANDROID_KEYSTORE_PATH=/path/to/your/keystore.jks
ANDROID_KEYSTORE_PASSWORD=your_keystore_password

# API Keys
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
FIREBASE_API_KEY=your_firebase_api_key
FIREBASE_APP_CHECK_DEBUG_TOKEN=your_firebase_app_check_token

# iOS
IOS_TEAM_ID=your_ios_team_id
IOS_PROVISIONING_PROFILE=your_provisioning_profile
EOF

# Create security checklist
echo "🔧 Creating security checklist..."
cat > MOBILE_SECURITY_CHECKLIST.md << 'EOF'
# Mobile Security Checklist

## Immediate Actions Required

### Android
- [ ] Upgrade to Java 17
- [ ] Remove cleartext traffic (FIXED)
- [ ] Secure API keys using environment variables
- [ ] Review and minimize permissions
- [ ] Implement runtime permission handling
- [ ] Customize ProGuard rules (CREATED)

### iOS
- [ ] Remove arbitrary loads (FIXED)
- [ ] Secure API keys using environment variables
- [ ] Validate URL schemes
- [ ] Review privacy descriptions
- [ ] Implement proper deep link validation

### General
- [ ] Use HTTPS for all connections
- [ ] Implement proper error handling
- [ ] Add security logging
- [ ] Set up crash reporting
- [ ] Regular security audits

## Environment Setup

1. Copy `.env.mobile.template` to `.env.mobile`
2. Fill in your actual API keys and credentials
3. Update build scripts to use environment variables
4. Test builds with new configuration

## Testing Checklist

- [ ] App builds successfully
- [ ] All features work with HTTPS only
- [ ] Permissions work correctly
- [ ] Deep links function properly
- [ ] No sensitive data in logs
- [ ] API keys not exposed in builds

## Monitoring

- [ ] Set up security monitoring
- [ ] Implement crash reporting
- [ ] Monitor for suspicious activities
- [ ] Regular dependency updates
EOF

echo "✅ Security fixes applied!"
echo ""
echo "📋 Next steps:"
echo "1. Review the changes in the backup files"
echo "2. Update .env.mobile with your actual values"
echo "3. Test the builds"
echo "4. Follow the security checklist"
echo ""
echo "📄 Generated files:"
echo "- MOBILE_SECURITY_CHECKLIST.md"
echo "- .env.mobile.template"
echo "- android/app/proguard-rules.pro"
echo "- Backup files: *.backup" 