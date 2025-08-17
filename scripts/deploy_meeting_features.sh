#!/bin/bash

# 🚀 Meeting Features Deployment Script
# This script deploys all meeting features to production

set -e  # Exit on any error

echo "🎯 Starting Meeting Features Deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Step 1: Deploy Firestore Rules
print_status "Deploying Firestore rules..."
firebase deploy --only firestore:rules
print_success "Firestore rules deployed successfully!"

# Step 2: Deploy Cloud Functions (if they exist)
if [ -d "functions" ]; then
    print_status "Deploying Cloud Functions..."
    firebase deploy --only functions
    print_success "Cloud Functions deployed successfully!"
else
    print_warning "No functions directory found, skipping Cloud Functions deployment"
fi

# Step 3: Build Flutter Web App
print_status "Building Flutter web app..."
cd appoint
flutter clean
flutter pub get
flutter build web --no-tree-shake-icons --release
print_success "Flutter web app built successfully!"

# Step 4: Deploy to Hosting (if using Firebase Hosting)
if [ -f "../firebase.json" ]; then
    print_status "Deploying to Firebase Hosting..."
    cd ..
    firebase deploy --only hosting
    print_success "App deployed to Firebase Hosting!"
else
    print_warning "No firebase.json found, skipping hosting deployment"
    print_status "Please deploy the build/web directory to your hosting provider"
fi

# Step 5: Create demo meeting
print_status "Creating demo meeting for testing..."
cd ..
if [ -f "scripts/seed_demo_meeting.js" ]; then
    node scripts/seed_demo_meeting.js
    print_success "Demo meeting created!"
else
    print_warning "Demo meeting script not found"
fi

# Step 6: Health check
print_status "Performing health check..."
# Add your health check logic here
# For example, curl the main page and check for 200 status

print_success "🎉 Deployment completed successfully!"
echo ""
echo "📋 Next steps:"
echo "1. Run manual QA testing with two browsers"
echo "2. Test mobile responsiveness"
echo "3. Verify real-time features work correctly"
echo "4. Check monitoring and analytics"
echo ""
echo "🔗 Demo meeting URL will be shown above"
echo "📊 Monitor logs: firebase functions:log"
echo "🔄 Rollback if needed: firebase deploy --only firestore:rules --message 'rollback'"














