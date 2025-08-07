#!/bin/bash

# Secrets Rotation Script
# This script should be run quarterly to rotate sensitive keys and secrets
# 
# Prerequisites:
# - Firebase CLI installed and authenticated
# - Stripe CLI installed and authenticated
# - GitHub CLI installed and authenticated
# - Access to GitHub secrets

set -e

echo "🔄 Starting secrets rotation process..."
echo "Date: $(date)"
echo "=================================="

# Configuration
REPO_OWNER="your-org"
REPO_NAME="appoint"
FIREBASE_PROJECT_ID="your-firebase-project-id"
STRIPE_ACCOUNT_ID="your-stripe-account-id"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."
    
    if ! command -v firebase &> /dev/null; then
        log_error "Firebase CLI not found. Please install it first."
        exit 1
    fi
    
    if ! command -v stripe &> /dev/null; then
        log_error "Stripe CLI not found. Please install it first."
        exit 1
    fi
    
    if ! command -v gh &> /dev/null; then
        log_error "GitHub CLI not found. Please install it first."
        exit 1
    fi
    
    log_info "All prerequisites met!"
}

# Rotate Firebase service account keys
rotate_firebase_keys() {
    log_info "Rotating Firebase service account keys..."
    
    # Generate new service account key
    log_info "Generating new Firebase service account key..."
    firebase projects:list
    
    # Download new service account key
    # Note: This requires manual intervention in Firebase Console
    log_warn "Please manually create a new service account key in Firebase Console:"
    log_warn "1. Go to Firebase Console > Project Settings > Service Accounts"
    log_warn "2. Click 'Generate new private key'"
    log_warn "3. Save the JSON file as 'firebase-service-account-new.json'"
    
    read -p "Press Enter after you've downloaded the new service account key..."
    
    if [ ! -f "firebase-service-account-new.json" ]; then
        log_error "New Firebase service account key not found!"
        exit 1
    fi
    
    # Update GitHub secrets
    log_info "Updating GitHub secrets with new Firebase key..."
    gh secret set FIREBASE_SERVICE_ACCOUNT_KEY \
        --repo "$REPO_OWNER/$REPO_NAME" \
        < firebase-service-account-new.json
    
    # Clean up
    rm -f firebase-service-account-new.json
    
    log_info "Firebase keys rotated successfully!"
}

# Rotate Stripe keys
rotate_stripe_keys() {
    log_info "Rotating Stripe API keys..."
    
    # Generate new Stripe API keys
    log_info "Generating new Stripe API keys..."
    
    # Note: This requires manual intervention in Stripe Dashboard
    log_warn "Please manually create new API keys in Stripe Dashboard:"
    log_warn "1. Go to Stripe Dashboard > Developers > API Keys"
    log_warn "2. Click 'Create key' for both publishable and secret keys"
    log_warn "3. Note down the new keys"
    
    read -p "Enter new Stripe publishable key: " STRIPE_PUBLISHABLE_KEY
    read -p "Enter new Stripe secret key: " STRIPE_SECRET_KEY
    
    if [ -z "$STRIPE_PUBLISHABLE_KEY" ] || [ -z "$STRIPE_SECRET_KEY" ]; then
        log_error "Stripe keys cannot be empty!"
        exit 1
    fi
    
    # Update GitHub secrets
    log_info "Updating GitHub secrets with new Stripe keys..."
    gh secret set STRIPE_PUBLISHABLE_KEY \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --body "$STRIPE_PUBLISHABLE_KEY"
    
    gh secret set STRIPE_SECRET_KEY \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --body "$STRIPE_SECRET_KEY"
    
    log_info "Stripe keys rotated successfully!"
}

# Rotate other secrets
rotate_other_secrets() {
    log_info "Rotating other secrets..."
    
    # Generate new encryption keys
    log_info "Generating new encryption keys..."
    NEW_ENCRYPTION_KEY=$(openssl rand -base64 32)
    
    # Update GitHub secrets
    gh secret set ENCRYPTION_KEY \
        --repo "$REPO_OWNER/$REPO_NAME" \
        --body "$NEW_ENCRYPTION_KEY"
    
    log_info "Other secrets rotated successfully!"
}

# Update documentation
update_documentation() {
    log_info "Updating documentation..."
    
    # Update secrets rotation log
    cat >> docs/SECRETS_ROTATION_LOG.md << EOF

## $(date)

- Firebase service account keys rotated
- Stripe API keys rotated
- Encryption keys rotated
- Rotation performed by: $(whoami)
- Rotation script version: $(git rev-parse HEAD)

EOF
    
    log_info "Documentation updated!"
}

# Main execution
main() {
    log_info "Starting secrets rotation for $REPO_OWNER/$REPO_NAME"
    
    check_prerequisites
    
    # Confirm before proceeding
    echo
    log_warn "This will rotate all sensitive keys and secrets."
    log_warn "Make sure you have access to Firebase Console and Stripe Dashboard."
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Secrets rotation cancelled."
        exit 0
    fi
    
    # Perform rotation
    rotate_firebase_keys
    rotate_stripe_keys
    rotate_other_secrets
    update_documentation
    
    log_info "🎉 Secrets rotation completed successfully!"
    log_info "Next rotation due: $(date -d '+3 months' '+%Y-%m-%d')"
    
    # Send notification
    log_info "Sending notification to team..."
    # Add your notification logic here (Slack, email, etc.)
}

# Run main function
main "$@" 