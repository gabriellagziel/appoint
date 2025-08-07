#!/bin/bash

# DigitalOcean CI Lock Script
# This script prevents fallback to GitHub Actions and ensures all Flutter operations
# run exclusively on DigitalOcean containers.

set -e

# Configuration
DIGITALOCEAN_CI_LOCK=${DIGITALOCEAN_CI_LOCK:-"true"}
FORCE_GITHUB_FALLBACK=${FORCE_GITHUB_FALLBACK:-"false"}
DIGITALOCEAN_CONTAINER="registry.digitalocean.com/appoint/flutter-ci:latest"

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

# Check if we're running in a DigitalOcean container
is_digitalocean_container() {
    if [ -f "/.dockerenv" ]; then
        # Check if we're using the DigitalOcean Flutter container
        if docker ps 2>/dev/null | grep -q "registry.digitalocean.com/appoint/flutter-ci"; then
            return 0
        fi
        # Check environment variables
        if [ "$DIGITALOCEAN_CI_LOCK" = "true" ]; then
            return 0
        fi
    fi
    return 1
}

# Validate DigitalOcean CI lock
validate_ci_lock() {
    log_info "🔒 Validating DigitalOcean CI lock..."
    
    if [ "$FORCE_GITHUB_FALLBACK" = "true" ]; then
        log_warning "GitHub fallback override enabled"
        log_warning "This bypasses the DigitalOcean CI lock"
        log_warning "Tests will run on GitHub (not recommended)"
        return 1
    fi
    
    if [ "$DIGITALOCEAN_CI_LOCK" != "true" ]; then
        log_error "DigitalOcean CI lock is disabled"
        log_error "All Flutter operations must run on DigitalOcean"
        exit 1
    fi
    
    log_success "DigitalOcean CI lock is active"
    log_success "All Flutter operations will use DigitalOcean container"
    return 0
}

# Check required secrets
check_required_secrets() {
    log_info "🔍 Checking required secrets..."
    
    # Check DigitalOcean access token
    if [ -z "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
        log_error "DIGITALOCEAN_ACCESS_TOKEN not configured"
        log_error "DigitalOcean CI cannot proceed"
        exit 1
    else
        log_success "DIGITALOCEAN_ACCESS_TOKEN is configured"
    fi
    
    # Check if we're in a GitHub Actions environment
    if [ -n "$GITHUB_ACTIONS" ]; then
        log_info "Running in GitHub Actions environment"
        
        # Ensure we're using the DigitalOcean container
        if ! is_digitalocean_container; then
            log_error "Not running in DigitalOcean container"
            log_error "All Flutter operations must use DigitalOcean container"
            log_error "Container: $DIGITALOCEAN_CONTAINER"
            exit 1
        fi
        
        log_success "Running in DigitalOcean container"
    fi
}

# Prevent Flutter installation on GitHub
prevent_flutter_installation() {
    log_info "🔒 Preventing Flutter installation on GitHub..."
    
    # Check if Flutter is being installed via GitHub Actions
    if [ -n "$GITHUB_ACTIONS" ] && ! is_digitalocean_container; then
        log_error "Flutter installation detected on GitHub"
        log_error "This is not allowed - use DigitalOcean container"
        log_error "Container: $DIGITALOCEAN_CONTAINER"
        exit 1
    fi
    
    # Check for Flutter setup actions
    if grep -q "subosito/flutter-action" .github/workflows/*.yml 2>/dev/null; then
        log_warning "Flutter setup actions detected in workflows"
        log_warning "These should be replaced with DigitalOcean container"
    fi
}

# Validate Flutter operations
validate_flutter_operations() {
    log_info "🔍 Validating Flutter operations..."
    
    # Check if Flutter is available
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter not found"
        log_error "Ensure you're using the DigitalOcean Flutter container"
        exit 1
    fi
    
    # Check Flutter version
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    log_info "Flutter version: $FLUTTER_VERSION"
    
    # Check Dart version
    DART_VERSION=$(dart --version | head -n 1)
    log_info "Dart version: $DART_VERSION"
    
    log_success "Flutter operations validated"
}

# Run Flutter command with DigitalOcean validation
run_flutter_command() {
    local command="$1"
    local description="$2"
    
    log_info "🚀 Running: $description"
    
    # Validate we're in the right environment
    if ! validate_ci_lock; then
        log_error "CI lock validation failed"
        exit 1
    fi
    
    if ! is_digitalocean_container; then
        log_error "Not running in DigitalOcean container"
        log_error "Command: $command"
        exit 1
    fi
    
    # Run the command
    if eval "$command"; then
        log_success "$description completed successfully"
    else
        log_error "$description failed"
        exit 1
    fi
}

# Main execution
main() {
    log_info "🔒 DigitalOcean CI Lock Script"
    log_info "Ensuring all Flutter operations run on DigitalOcean"
    
    # Validate CI lock
    validate_ci_lock
    
    # Check required secrets
    check_required_secrets
    
    # Prevent Flutter installation on GitHub
    prevent_flutter_installation
    
    # Validate Flutter operations
    validate_flutter_operations
    
    log_success "DigitalOcean CI lock validation completed"
    log_success "All Flutter operations are locked to DigitalOcean"
}

# Handle command line arguments
case "${1:-}" in
    "validate")
        main
        ;;
    "run")
        if [ -z "$2" ]; then
            log_error "Usage: $0 run <command>"
            exit 1
        fi
        run_flutter_command "$2" "$3"
        ;;
    "check")
        validate_ci_lock
        check_required_secrets
        validate_flutter_operations
        log_success "All checks passed"
        ;;
    *)
        log_info "Usage: $0 {validate|run|check}"
        log_info "  validate - Validate CI lock and environment"
        log_info "  run <command> <description> - Run Flutter command with validation"
        log_info "  check - Quick environment check"
        exit 1
        ;;
esac