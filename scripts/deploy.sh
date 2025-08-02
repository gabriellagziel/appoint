#!/bin/bash

# 🚀 APP-OINT DEPLOYMENT SCRIPT
# This script automates the deployment process for the App-Oint system

set -e  # Exit on any error

echo "🚀 Starting App-Oint Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    print_error "Flutter not found. Please ensure Flutter is installed and in PATH."
    exit 1
fi

# Check if Firebase CLI is available
if ! command -v firebase &> /dev/null; then
    print_warning "Firebase CLI not found. Installing..."
    npm install -g firebase-tools
fi

print_status "Building Flutter web application..."
flutter build web --release

if [ $? -eq 0 ]; then
    print_status "✅ Flutter web build successful!"
else
    print_error "❌ Flutter build failed!"
    exit 1
fi

print_status "Installing Firebase Functions dependencies..."
cd functions
npm install
cd ..

print_status "Deploying to Firebase..."
firebase deploy --only hosting

if [ $? -eq 0 ]; then
    print_status "✅ Firebase hosting deployment successful!"
else
    print_error "❌ Firebase deployment failed!"
    exit 1
fi

print_status "Deploying Firebase Functions..."
firebase deploy --only functions

if [ $? -eq 0 ]; then
    print_status "✅ Firebase functions deployment successful!"
else
    print_warning "⚠️ Firebase functions deployment failed (this is optional)"
fi

print_status "🎉 Deployment completed successfully!"
print_status "Your App-Oint application is now live!"

# Display deployment information
echo ""
echo "📋 Deployment Summary:"
echo "  • Web Application: Deployed to Firebase Hosting"
echo "  • Backend Functions: Deployed to Firebase Functions"
echo "  • Build Location: build/web"
echo "  • Firebase Project: app-oint-core"

echo ""
print_warning "Remember to:"
echo "  • Configure production environment variables"
echo "  • Set up custom domain and SSL certificates"
echo "  • Configure monitoring and analytics"
echo "  • Test all functionality in production"

echo ""
print_status "Deployment script completed successfully! 🚀"