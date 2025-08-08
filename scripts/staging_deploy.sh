#!/bin/bash

# Staging Deployment Script for Playtime System
# This script deploys the app to a staging Firebase project

set -e  # Exit on any error

echo "🚀 Starting Playtime Staging Deployment..."

# Configuration
STAGING_PROJECT_ID=${STAGING_PROJECT_ID:-"your-staging-project-id"}
FIREBASE_TOKEN=${FIREBASE_TOKEN:-""}

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}ℹ️  $1${NC}"
}

log_warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v firebase &> /dev/null; then
        log_error "Firebase CLI not found. Please install it first:"
        echo "npm install -g firebase-tools"
        exit 1
    fi
    
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter not found. Please install it first."
        exit 1
    fi
    
    if [ -z "$STAGING_PROJECT_ID" ]; then
        log_error "STAGING_PROJECT_ID not set. Please set it or update the script."
        exit 1
    fi
    
    log_info "✅ Prerequisites check passed"
}

# Build the Flutter web app
build_web_app() {
    log_info "Building Flutter web app..."
    
    # Clean previous build
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build for web
    flutter build web --release --web-renderer html
    
    if [ $? -eq 0 ]; then
        log_info "✅ Web app built successfully"
    else
        log_error "❌ Failed to build web app"
        exit 1
    fi
}

# Deploy Firestore rules
deploy_firestore_rules() {
    log_info "Deploying Firestore security rules..."
    
    # Use the staging project
    firebase use $STAGING_PROJECT_ID
    
    # Deploy only Firestore rules
    firebase deploy --only firestore:rules --token "$FIREBASE_TOKEN"
    
    if [ $? -eq 0 ]; then
        log_info "✅ Firestore rules deployed successfully"
    else
        log_error "❌ Failed to deploy Firestore rules"
        exit 1
    fi
}

# Deploy hosting
deploy_hosting() {
    log_info "Deploying to Firebase Hosting..."
    
    # Deploy hosting
    firebase deploy --only hosting --token "$FIREBASE_TOKEN"
    
    if [ $? -eq 0 ]; then
        log_info "✅ Hosting deployed successfully"
    else
        log_error "❌ Failed to deploy hosting"
        exit 1
    fi
}

# Seed test data
seed_test_data() {
    log_info "Seeding test data..."
    
    # Check if seed file exists
    if [ ! -f "test_data/playtime_games_seed.json" ]; then
        log_warn "Seed file not found. Skipping data seeding."
        return
    fi
    
    # Import test data
    firebase firestore:import test_data/playtime_games_seed.json --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    if [ $? -eq 0 ]; then
        log_info "✅ Test data seeded successfully"
    else
        log_warn "⚠️  Failed to seed test data (this is optional)"
    fi
}

# Create staging users
create_staging_users() {
    log_info "Creating staging test users..."
    
    # This would typically be done via Firebase Auth or a custom script
    # For now, we'll just log the instructions
    log_info "📋 Manual step: Create test users in Firebase Console:"
    echo "   - Adult user (age 25+)"
    echo "   - Teen user (age 15) with parent"
    echo "   - Child user (age 10) with parent"
    echo "   - Parent user (age 40)"
}

# Run tests before deployment
run_tests() {
    log_info "Running tests before deployment..."
    
    # Run unit tests
    flutter test test/e2e/playtime_unit_test.dart
    flutter test test/e2e/playtime_mock_e2e_test.dart
    
    if [ $? -eq 0 ]; then
        log_info "✅ All tests passed"
    else
        log_error "❌ Tests failed. Aborting deployment."
        exit 1
    fi
}

# Main deployment flow
main() {
    log_info "Starting Playtime staging deployment to: $STAGING_PROJECT_ID"
    
    # Check prerequisites
    check_prerequisites
    
    # Run tests
    run_tests
    
    # Build web app
    build_web_app
    
    # Deploy Firestore rules
    deploy_firestore_rules
    
    # Deploy hosting
    deploy_hosting
    
    # Seed test data
    seed_test_data
    
    # Create staging users
    create_staging_users
    
    log_info "🎉 Staging deployment completed successfully!"
    log_info "🌐 Your app is now live at: https://$STAGING_PROJECT_ID.web.app"
    log_info "📊 Firebase Console: https://console.firebase.google.com/project/$STAGING_PROJECT_ID"
}

# Run main function
main "$@"
