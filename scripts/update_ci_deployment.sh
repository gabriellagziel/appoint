#!/bin/bash

# DigitalOcean CI Container Deployment Update Script
# This script updates the App Platform deployment to use the Flutter CI container

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Set DigitalOcean token
export DIGITALOCEAN_ACCESS_TOKEN="REDACTED_TOKEN"

# Initialize doctl
init_doctl() {
    log_info "🔐 Initializing DigitalOcean CLI..."
    
    if ! command -v doctl &> /dev/null; then
        log_error "doctl not found. Please install doctl first."
        exit 1
    fi
    
    if doctl auth init --access-token "$DIGITALOCEAN_ACCESS_TOKEN" 2>/dev/null; then
        log_success "DigitalOcean CLI initialized successfully"
    else
        log_error "Failed to initialize DigitalOcean CLI"
        exit 1
    fi
}

# Get app ID
get_app_id() {
    log_info "🔍 Finding App Platform app ID..."
    
    APP_ID=$(doctl apps list --format ID,Name --no-header | grep "appoint-web" | awk '{print $1}')
    
    if [ -z "$APP_ID" ]; then
        log_error "Could not find appoint-web app"
        exit 1
    fi
    
    log_success "Found app ID: $APP_ID"
    echo "$APP_ID"
}

# Update app deployment
update_deployment() {
    local app_id="$1"
    
    log_info "🚀 Updating app deployment to use Flutter CI container..."
    
    # Create deployment
    if doctl apps create-deployment "$app_id"; then
        log_success "Deployment triggered successfully"
    else
        log_error "Failed to trigger deployment"
        exit 1
    fi
}

# Monitor deployment status
monitor_deployment() {
    local app_id="$1"
    
    log_info "📊 Monitoring deployment status..."
    
    for i in {1..30}; do
        STATUS=$(doctl apps get "$app_id" --format Phase --no-header)
        log_info "Deployment status: $STATUS"
        
        if [ "$STATUS" = "RUNNING" ]; then
            log_success "Deployment completed successfully"
            break
        elif [ "$STATUS" = "FAILED" ]; then
            log_error "Deployment failed"
            exit 1
        fi
        
        if [ $i -eq 30 ]; then
            log_warning "Deployment monitoring timeout"
            break
        fi
        
        sleep 10
    done
}

# Main execution
main() {
    log_info "🚀 DigitalOcean CI Container Deployment Update"
    log_info "Updating App Platform to use Flutter CI container"
    
    # Initialize doctl
    init_doctl
    
    # Get app ID
    APP_ID=$(get_app_id)
    
    # Update deployment
    update_deployment "$APP_ID"
    
    # Monitor deployment
    monitor_deployment "$APP_ID"
    
    log_success "🎉 Deployment update completed!"
    log_info "The app should now be running with the Flutter CI container"
    log_info "You can now run the validation commands in the new container:"
    log_info "  ./scripts/run-digitalocean-ci.sh check"
    log_info "  ./scripts/run-digitalocean-ci.sh analyze"
    log_info "  ./scripts/run-digitalocean-ci.sh test"
}

# Execute main function
main "$@"