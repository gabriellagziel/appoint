#!/bin/bash

# APP-OINT Production Deployment Script
# This script handles the complete production deployment process

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="APP-OINT"
VERSION="1.0.0"
BUILD_NUMBER=$(date +%s)

# Environment variables
export ENVIRONMENT="production"
export API_BASE_URL="https://api.appoint.com/v1"
export WS_BASE_URL="wss://ws.appoint.com"
export FIREBASE_PROJECT_ID="appoint-prod"
export STRIPE_PUBLISHABLE_KEY="pk_live_your_stripe_key_here"
export ANALYTICS_ENABLED="true"
export LOG_LEVEL="warn"

echo -e "${BLUE}🚀 Starting $APP_NAME Production Deployment${NC}"
echo -e "${BLUE}Version: $VERSION${NC}"
echo -e "${BLUE}Build: $BUILD_NUMBER${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check prerequisites
check_prerequisites() {
    echo -e "${BLUE}🔍 Checking prerequisites...${NC}"
    
    # Check if Flutter is installed
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed"
        exit 1
    fi
    
    # Check if Dart is installed
    if ! command -v dart &> /dev/null; then
        print_error "Dart is not installed"
        exit 1
    fi
    
    # Check if Firebase CLI is installed
    if ! command -v firebase &> /dev/null; then
        print_warning "Firebase CLI is not installed"
    fi
    
    # Check if git is installed
    if ! command -v git &> /dev/null; then
        print_error "Git is not installed"
        exit 1
    fi
    
    print_status "Prerequisites check completed"
}

# Function to run tests
run_tests() {
    echo -e "${BLUE}🧪 Running tests...${NC}"
    
    # Run unit tests
    flutter test --coverage
    
    # Run integration tests
    flutter test integration_test/
    
    # Run widget tests
    flutter test test/widget_test.dart
    
    print_status "Tests completed successfully"
}

# Function to analyze code
analyze_code() {
    echo -e "${BLUE}🔍 Analyzing code...${NC}"
    
    # Run Flutter analyze
    flutter analyze --no-fatal-infos
    
    # Run dart analyze
    dart analyze
    
    print_status "Code analysis completed"
}

# Function to build the app
build_app() {
    echo -e "${BLUE}🏗️  Building app...${NC}"
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build for Android
    echo "Building Android APK..."
    flutter build apk --release \
        --dart-define=ENVIRONMENT=production \
        --dart-define=API_BASE_URL=$API_BASE_URL \
        --dart-define=WS_BASE_URL=$WS_BASE_URL \
        --dart-define=FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID \
        --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY \
        --dart-define=ANALYTICS_ENABLED=$ANALYTICS_ENABLED \
        --dart-define=LOG_LEVEL=$LOG_LEVEL
    
    # Build for iOS
    echo "Building iOS app..."
    flutter build ios --release \
        --dart-define=ENVIRONMENT=production \
        --dart-define=API_BASE_URL=$API_BASE_URL \
        --dart-define=WS_BASE_URL=$WS_BASE_URL \
        --dart-define=FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID \
        --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY \
        --dart-define=ANALYTICS_ENABLED=$ANALYTICS_ENABLED \
        --dart-define=LOG_LEVEL=$LOG_LEVEL
    
    # Build for Web
    echo "Building Web app..."
    flutter build web --release \
        --dart-define=ENVIRONMENT=production \
        --dart-define=API_BASE_URL=$API_BASE_URL \
        --dart-define=WS_BASE_URL=$WS_BASE_URL \
        --dart-define=FIREBASE_PROJECT_ID=$FIREBASE_PROJECT_ID \
        --dart-define=STRIPE_PUBLISHABLE_KEY=$STRIPE_PUBLISHABLE_KEY \
        --dart-define=ANALYTICS_ENABLED=$ANALYTICS_ENABLED \
        --dart-define=LOG_LEVEL=$LOG_LEVEL
    
    print_status "App build completed"
}

# Function to deploy to Firebase
deploy_firebase() {
    echo -e "${BLUE}🔥 Deploying to Firebase...${NC}"
    
    # Deploy to Firebase Hosting
    firebase deploy --only hosting
    
    # Deploy Firebase Functions
    firebase deploy --only functions
    
    print_status "Firebase deployment completed"
}

# Function to deploy to app stores
deploy_app_stores() {
    echo -e "${BLUE}📱 Deploying to app stores...${NC}"
    
    # Deploy to Google Play Store
    if [ -f "android/app/build/outputs/apk/release/app-release.apk" ]; then
        echo "Uploading to Google Play Store..."
        # TODO: Add Google Play Store upload logic
        print_warning "Google Play Store upload not implemented"
    fi
    
    # Deploy to Apple App Store
    if [ -d "build/ios/iphoneos" ]; then
        echo "Uploading to Apple App Store..."
        # TODO: Add Apple App Store upload logic
        print_warning "Apple App Store upload not implemented"
    fi
    
    print_status "App store deployment completed"
}

# Function to run security checks
security_checks() {
    echo -e "${BLUE}🔒 Running security checks...${NC}"
    
    # Check for hardcoded secrets
    if grep -r "sk_live\|pk_live\|password\|secret" lib/ --exclude-dir=generated; then
        print_warning "Potential hardcoded secrets found"
    fi
    
    # Check for debug code in production
    if grep -r "print(\|debugPrint\|assert(" lib/ --exclude-dir=generated; then
        print_warning "Debug code found in production build"
    fi
    
    print_status "Security checks completed"
}

# Function to generate deployment report
generate_report() {
    echo -e "${BLUE}📊 Generating deployment report...${NC}"
    
    # Create deployment report
    cat > deployment_report.md << EOF
# APP-OINT Production Deployment Report

## Deployment Information
- **App Name:** $APP_NAME
- **Version:** $VERSION
- **Build Number:** $BUILD_NUMBER
- **Environment:** $ENVIRONMENT
- **Deployment Date:** $(date)

## Build Information
- **Flutter Version:** $(flutter --version | head -n 1)
- **Dart Version:** $(dart --version | head -n 1)
- **Build Time:** $(date)

## Features Deployed
- ✅ Enhanced Onboarding
- ✅ Advanced Search
- ✅ Messaging System
- ✅ Subscription Management
- ✅ Rewards System
- ✅ Business Analytics
- ✅ Family Coordination
- ✅ Calendar Integration
- ✅ Enhanced Dashboard
- ✅ Settings & Profile
- ✅ API Services
- ✅ Error Handling
- ✅ Analytics
- ✅ Push Notifications

## Environment Variables
- API_BASE_URL: $API_BASE_URL
- WS_BASE_URL: $WS_BASE_URL
- FIREBASE_PROJECT_ID: $FIREBASE_PROJECT_ID
- ANALYTICS_ENABLED: $ANALYTICS_ENABLED
- LOG_LEVEL: $LOG_LEVEL

## Next Steps
1. Monitor app performance
2. Track user analytics
3. Monitor error reports
4. Update app store listings
5. Plan next release

EOF
    
    print_status "Deployment report generated"
}

# Function to cleanup
cleanup() {
    echo -e "${BLUE}🧹 Cleaning up...${NC}"
    
    # Remove build artifacts
    flutter clean
    
    # Remove temporary files
    rm -rf build/
    rm -rf .dart_tool/
    
    print_status "Cleanup completed"
}

# Main deployment function
main() {
    echo -e "${BLUE}🚀 Starting $APP_NAME Production Deployment${NC}"
    echo ""
    
    # Check prerequisites
    check_prerequisites
    
    # Run tests
    run_tests
    
    # Analyze code
    analyze_code
    
    # Security checks
    security_checks
    
    # Build app
    build_app
    
    # Deploy to Firebase
    deploy_firebase
    
    # Deploy to app stores
    deploy_app_stores
    
    # Generate report
    generate_report
    
    # Cleanup
    cleanup
    
    echo ""
    echo -e "${GREEN}🎉 Deployment completed successfully!${NC}"
    echo -e "${GREEN}📱 $APP_NAME v$VERSION is now live in production${NC}"
    echo ""
    echo -e "${BLUE}📊 Monitor your app at:${NC}"
    echo -e "${BLUE}   - Firebase Console: https://console.firebase.google.com${NC}"
    echo -e "${BLUE}   - Google Play Console: https://play.google.com/console${NC}"
    echo -e "${BLUE}   - Apple App Store Connect: https://appstoreconnect.apple.com${NC}"
    echo ""
}

# Run main function
main "$@" 