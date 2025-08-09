#!/bin/bash

# Share-in-Groups Feature Deployment Script
# This script deploys the Share-in-Groups feature to production

set -e  # Exit on any error

echo "🚀 Share-in-Groups Feature Deployment"
echo "====================================="

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

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "Not in Flutter project root. Please run from project root."
    exit 1
fi

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    print_error "Firebase CLI not found. Please install: npm install -g firebase-tools"
    exit 1
fi

# Check if we're logged into Firebase
if ! firebase projects:list &> /dev/null; then
    print_error "Not logged into Firebase. Please run: firebase login"
    exit 1
fi

print_status "Starting Share-in-Groups deployment..."

# Step 1: Pre-deployment checks
print_status "Step 1: Pre-deployment checks"
echo "--------------------------------"

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    print_warning "Not on main branch (currently on $CURRENT_BRANCH)"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Deployment cancelled"
        exit 1
    fi
fi

# Check for uncommitted changes
if [ -n "$(git status --porcelain)" ]; then
    print_warning "Uncommitted changes detected"
    git status --short
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_error "Deployment cancelled"
        exit 1
    fi
fi

# Step 2: Get dependencies
print_status "Step 2: Getting dependencies"
echo "--------------------------------"
flutter pub get
print_success "Dependencies updated"

# Step 3: Deploy Firestore rules and indexes
print_status "Step 3: Deploying Firestore rules and indexes"
echo "------------------------------------------------"
firebase deploy --only firestore:rules,firestore:indexes
print_success "Firestore rules and indexes deployed"

# Step 4: Run smoke tests
print_status "Step 4: Running smoke tests"
echo "-------------------------------"

# Start emulator
print_status "Starting Firestore emulator..."
firebase emulators:start --only firestore &
EMU_PID=$!

# Wait for emulator to start
sleep 5

# Run tests
print_status "Running share groups tests..."
if flutter test test/features/meeting_share/simple_share_test.dart; then
    print_success "Simple share tests passed"
else
    print_error "Simple share tests failed"
    kill $EMU_PID 2>/dev/null || true
    exit 1
fi

print_status "Running Firestore rules tests..."
if flutter test test/firestore_rules_share_groups_test.dart; then
    print_success "Firestore rules tests passed"
else
    print_error "Firestore rules tests failed"
    kill $EMU_PID 2>/dev/null || true
    exit 1
fi

# Stop emulator
kill $EMU_PID 2>/dev/null || true
print_success "Smoke tests completed"

# Step 5: Telemetry verification
print_status "Step 5: Telemetry verification"
echo "--------------------------------"

if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
    print_warning "GOOGLE_APPLICATION_CREDENTIALS not set"
    print_status "Skipping telemetry verification"
else
    print_status "Running telemetry verification..."
    if npx ts-node tools/telemetry_verify.ts; then
        print_success "Telemetry verification passed"
    else
        print_warning "Telemetry verification failed (continuing anyway)"
    fi
fi

# Step 6: Deploy application
print_status "Step 6: Deploying application"
echo "--------------------------------"

# Build the application
print_status "Building Flutter web app..."
flutter build web --release

# Deploy to Firebase Hosting
print_status "Deploying to Firebase Hosting..."
firebase deploy --only hosting

print_success "Application deployed"

# Step 7: Enable feature flags
print_status "Step 7: Enabling feature flags"
echo "--------------------------------"

print_status "Setting feature flags..."
firebase functions:config:set share.feature_share_links_enabled=true
firebase functions:config:set share.feature_guest_rsvp_enabled=true
firebase functions:config:set share.feature_public_meeting_page_v2=true

print_success "Feature flags enabled"

# Step 8: Deploy functions
print_status "Step 8: Deploying functions"
echo "--------------------------------"
firebase deploy --only functions
print_success "Functions deployed"

# Step 9: Post-deployment verification
print_status "Step 9: Post-deployment verification"
echo "----------------------------------------"

# Check if deployment was successful
print_status "Verifying deployment..."

# Check if the app is accessible (basic health check)
if curl -f -s "https://$(firebase use --json | jq -r '.current')" > /dev/null; then
    print_success "Application is accessible"
else
    print_warning "Could not verify application accessibility"
fi

# Final success message
echo ""
echo "🎉 Share-in-Groups Feature Deployment Complete!"
echo "=============================================="
print_success "All components deployed successfully"
echo ""
echo "📊 Next Steps:"
echo "1. Monitor the application for the next 24 hours"
echo "2. Run hypercare checks: ./scripts/hypercare_checks.sh"
echo "3. Check telemetry: GOOGLE_APPLICATION_CREDENTIALS=./sa.json npx ts-node tools/telemetry_verify.ts"
echo "4. Generate Day-3 report: npx ts-node tools/reports/share_groups_day3.ts"
echo ""
echo "🔗 Useful Commands:"
echo "- View logs: firebase functions:log"
echo "- Check status: firebase projects:list"
echo "- Monitor: gcloud monitoring policies list"
echo ""
echo "📞 Emergency Contacts:"
echo "- On-call: [Fill in contact]"
echo "- DevOps: [Fill in contact]"
echo "- Security: [Fill in contact]"
