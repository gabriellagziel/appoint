#!/bin/bash

# Mission-Critical Production CI Setup
# DigitalOcean Flutter CI Image Build and Push Script

set -e

echo "🚀 Starting mission-critical production CI setup..."

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

# Validate environment
validate_environment() {
    log_info "🔍 Validating environment..."
    
    # Check if Docker is available
    if ! command -v docker &> /dev/null; then
        log_error "Docker not found. Please install Docker first."
        exit 1
    fi
    
    # Check if doctl is available
    if ! command -v doctl &> /dev/null; then
        log_error "doctl not found. Please install doctl first."
        exit 1
    fi
    
    # Check if Dockerfile exists
    if [ ! -f "Dockerfile" ]; then
        log_error "Dockerfile not found in current directory."
        exit 1
    fi
    
    log_success "Environment validation completed"
}

# Validate DigitalOcean token
validate_token() {
    log_info "🔐 Validating DigitalOcean token..."
    
    # Set token from setup script
    export DIGITALOCEAN_ACCESS_TOKEN="dop_v1_6deb32fff925f45e637d6a3b364f38fcd345d9b7b14d3ffa8bd463208ffa0cc4"
    
    # Test token with doctl
    if doctl auth init --access-token "$DIGITALOCEAN_ACCESS_TOKEN" 2>/dev/null; then
        log_success "DigitalOcean token validated successfully"
    else
        log_error "DigitalOcean token validation failed (401 error)"
        log_error "Please check your DigitalOcean access token"
        exit 1
    fi
}

# Build Docker image
build_image() {
    log_info "🔧 Building Docker image: appoint/flutter-ci:latest"
    
    if docker build -t appoint/flutter-ci:latest -f Dockerfile .; then
        log_success "Docker image built successfully"
    else
        log_error "Docker image build failed"
        exit 1
    fi
}

# Login to DigitalOcean Registry
login_registry() {
    log_info "🔐 Logging in to DigitalOcean Registry..."
    
    if doctl registry login; then
        log_success "Successfully logged in to DigitalOcean Registry"
    else
        log_error "Failed to login to DigitalOcean Registry"
        exit 1
    fi
}

# Tag image for DigitalOcean
tag_image() {
    log_info "🏷️  Tagging image for DigitalOcean..."
    
    if docker tag appoint/flutter-ci:latest registry.digitalocean.com/appoint/flutter-ci:latest; then
        log_success "Image tagged successfully"
    else
        log_error "Image tagging failed"
        exit 1
    fi
}

# Push image to registry
push_image() {
    log_info "📤 Pushing image to DigitalOcean Registry..."
    
    if docker push registry.digitalocean.com/appoint/flutter-ci:latest; then
        log_success "Image pushed successfully to DigitalOcean Registry"
    else
        log_error "Image push failed"
        exit 1
    fi
}

# Main execution
main() {
    log_info "🚀 Mission-Critical Production CI Setup"
    log_info "Building and pushing Flutter CI image to DigitalOcean"
    
    # Validate environment
    validate_environment
    
    # Validate token
    validate_token
    
    # Build image
    build_image
    
    # Login to registry
    login_registry
    
    # Tag image
    tag_image
    
    # Push image
    push_image
    
    log_success "🎉 Docker image build and push completed successfully!"
    log_info "Next steps:"
    log_info "1. Deploy the new container image in DigitalOcean"
    log_info "2. Run CI validation commands:"
    log_info "   ./scripts/run-digitalocean-ci.sh check"
    log_info "   ./scripts/run-digitalocean-ci.sh analyze"
    log_info "   ./scripts/run-digitalocean-ci.sh test"
}

# Execute main function
main "$@"