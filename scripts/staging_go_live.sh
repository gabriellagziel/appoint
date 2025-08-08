#!/bin/bash

# 🚀 Playtime Staging Go-Live Script
set -e

echo "🎯 Playtime Staging Go-Live"
echo "============================"

STAGING_PROJECT_ID=${STAGING_PROJECT_ID:-"your-staging-project-id"}
FIREBASE_TOKEN=${FIREBASE_TOKEN:-""}

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${GREEN}ℹ️  $1${NC}"; }
log_warn() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }
log_step() { echo -e "${BLUE}🔧 $1${NC}"; }

# Check prerequisites
check_prerequisites() {
    log_step "Checking prerequisites..."
    
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

# Setup Firebase project
setup_firebase_project() {
    log_step "Setting up Firebase project..."
    firebase use $STAGING_PROJECT_ID
    log_info "✅ Firebase project configured"
}

# Deploy Firestore rules
deploy_firestore_rules() {
    log_step "Deploying Firestore security rules..."
    firebase deploy --only firestore:rules --token "$FIREBASE_TOKEN"
    log_info "✅ Firestore rules deployed successfully"
}

# Deploy hosting
deploy_hosting() {
    log_step "Building and deploying hosting..."
    
    flutter clean
    flutter pub get
    flutter build web --release --web-renderer html
    log_info "✅ Web app built successfully"
    
    firebase deploy --only hosting --token "$FIREBASE_TOKEN"
    log_info "✅ Hosting deployed successfully"
}

# Seed staging data
seed_staging_data() {
    log_step "Seeding minimal staging data..."
    
    # Create test users
    firebase firestore:documents:create users/adult_18 '{"uid":"adult_18","age":18,"isChild":false,"displayName":"Adult Test User","email":"adult@test.com","role":"user","createdAt":"2024-01-01T00:00:00.000Z","updatedAt":"2024-01-01T00:00:00.000Z"}' --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    firebase firestore:documents:create users/teen_15 '{"uid":"teen_15","age":15,"isChild":true,"parentUid":"parent_42","displayName":"Teen Test User","email":"teen@test.com","role":"user","createdAt":"2024-01-01T00:00:00.000Z","updatedAt":"2024-01-01T00:00:00.000Z"}' --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    firebase firestore:documents:create users/child_10 '{"uid":"child_10","age":10,"isChild":true,"parentUid":"parent_42","displayName":"Child Test User","email":"child@test.com","role":"user","createdAt":"2024-01-01T00:00:00.000Z","updatedAt":"2024-01-01T00:00:00.000Z"}' --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    firebase firestore:documents:create users/parent_42 '{"uid":"parent_42","age":40,"isChild":false,"displayName":"Parent Test User","email":"parent@test.com","role":"parent","createdAt":"2024-01-01T00:00:00.000Z","updatedAt":"2024-01-01T00:00:00.000Z"}' --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    # Create parent preferences
    firebase firestore:documents:create playtime_preferences/parent_42 '{"parentId":"parent_42","allowOverrideAgeRestriction":true,"blockedGames":[],"allowedPlatforms":["PC","Console","Mobile"],"maxSessionDuration":120,"allowVirtualSessions":true,"allowPhysicalSessions":true,"requirePreApproval":true,"createdAt":"2024-01-01T00:00:00.000Z","updatedAt":"2024-01-01T00:00:00.000Z"}' --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    # Create test games
    firebase firestore:documents:create playtime_games/minecraft '{"id":"minecraft","name":"Minecraft","description":"Build and explore together in creative mode","icon":"🎮","category":"creative","ageRange":{"min":8,"max":99},"type":"virtual","platform":"PC","minAge":8,"maxPlayers":10,"maxParticipants":10,"estimatedDuration":120,"isSystemGame":true,"isPublic":true,"isActive":true,"creatorId":"system","parentApprovalRequired":true,"parentApproved":true,"safetyLevel":"safe","rating":"E for Everyone","createdAt":"2024-01-01T00:00:00.000Z","updatedAt":"2024-01-01T00:00:00.000Z"}' --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    firebase firestore:documents:create playtime_games/mature_shooter '{"id":"mature_shooter","name":"Mature Shooter","description":"Intense combat simulation for adults","icon":"💥","category":"action","ageRange":{"min":18,"max":99},"type":"virtual","platform":"Console","minAge":18,"maxPlayers":8,"maxParticipants":8,"estimatedDuration":60,"isSystemGame":true,"isPublic":true,"isActive":true,"creatorId":"system","parentApprovalRequired":true,"parentApproved":true,"safetyLevel":"adults_only","rating":"AO for Adults Only","createdAt":"2024-01-01T00:00:00.000Z","updatedAt":"2024-01-01T00:00:00.000Z"}' --project $STAGING_PROJECT_ID --token "$FIREBASE_TOKEN"
    
    log_info "✅ Test data seeded successfully"
}

# Run tests
run_tests() {
    log_step "Running tests before deployment..."
    flutter test test/e2e/playtime_unit_test.dart
    flutter test test/e2e/playtime_mock_e2e_test.dart
    log_info "✅ All tests passed"
}

# Show testing instructions
show_testing_instructions() {
    log_step "Manual testing instructions..."
    
    echo ""
    echo "🧪 1-MINUTE BROWSER CHECKS:"
    echo "============================"
    echo ""
    echo "🌐 Open your staging URL: https://$STAGING_PROJECT_ID.web.app"
    echo ""
    echo "✅ Adult test:"
    echo "   - Login as adult_18"
    echo "   - Create virtual + physical with 'Mature Shooter'"
    echo "   - Expected: no prompts, session created immediately"
    echo ""
    echo "🔴 Child test:"
    echo "   - Login as child_10"
    echo "   - Try to create session with 'Mature Shooter'"
    echo "   - Expected: blocked, virtual link locked until parent approval"
    echo ""
    echo "🟡 Teen test:"
    echo "   - Login as teen_15"
    echo "   - Try to create session with 'Mature Shooter'"
    echo "   - Expected: needs parent approval"
    echo "   - Toggle parentApproved: true in Firestore"
    echo "   - Confirm session becomes joinable"
    echo ""
    echo "📊 Analytics Events to Verify:"
    echo "   - playtime_session_create_attempt"
    echo "   - playtime_parent_approval"
    echo "   - playtime_age_restriction_violation"
    echo ""
    echo "🎯 Success Criteria:"
    echo "   - Adults: No restrictions"
    echo "   - Teens: Age-appropriate games OK, restricted games need approval"
    echo "   - Children: Everything needs parent approval"
    echo "   - UI badges show correct status (🟢/🟡/🔴)"
}

# Main deployment flow
main() {
    log_info "Starting Playtime staging go-live to: $STAGING_PROJECT_ID"
    
    check_prerequisites
    run_tests
    setup_firebase_project
    deploy_firestore_rules
    deploy_hosting
    seed_staging_data
    show_testing_instructions
    
    log_info "🎉 Staging go-live completed successfully!"
    log_info "🌐 Your app is now live at: https://$STAGING_PROJECT_ID.web.app"
    log_info "📊 Firebase Console: https://console.firebase.google.com/project/$STAGING_PROJECT_ID"
    log_info "📋 Follow scripts/staging_test_guide.md for detailed testing"
}

main "$@"
