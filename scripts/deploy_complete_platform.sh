#!/usr/bin/env bash
set -e

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

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command -v doctl &> /dev/null; then
        print_error "doctl is not installed. Please install it first."
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        print_error "jq is not installed. Please install it first."
        exit 1
    fi
    
    # Check if doctl is authenticated
    if ! doctl account get &> /dev/null; then
        print_error "doctl is not authenticated. Please run 'doctl auth init' first."
        exit 1
    fi
    
    print_success "All prerequisites are met!"
}

# Deploy Business App
deploy_business() {
    print_status "Deploying Business App..."
    
    # Check if app already exists
    EXISTING_BUSINESS=$(doctl apps list --output json | jq -r '.[] | select(.spec.name == "app-oint-business") | .id')
    
    if [ -n "$EXISTING_BUSINESS" ] && [ "$EXISTING_BUSINESS" != "null" ]; then
        print_warning "Business app already exists with ID: $EXISTING_BUSINESS"
        print_status "Updating existing business app..."
        BUSINESS_APP_ID="$EXISTING_BUSINESS"
        doctl apps update "$EXISTING_BUSINESS" --spec business-app-spec.yaml > /dev/null
    else
        print_status "Creating new business app..."
        BUSINESS_APP_ID=$(doctl apps create --spec business-app-spec.yaml --output json | jq -r '.id')
    fi
    
    if [ -z "$BUSINESS_APP_ID" ] || [ "$BUSINESS_APP_ID" = "null" ]; then
        print_error "Failed to create/update business app"
        return 1
    fi
    
    print_success "Business App ID: $BUSINESS_APP_ID"
    echo "$BUSINESS_APP_ID" > .business_app_id
    return 0
}

# Deploy Enterprise App
deploy_enterprise() {
    print_status "Deploying Enterprise App..."
    
    # Check if app already exists
    EXISTING_ENTERPRISE=$(doctl apps list --output json | jq -r '.[] | select(.spec.name == "app-oint-enterprise") | .id')
    
    if [ -n "$EXISTING_ENTERPRISE" ] && [ "$EXISTING_ENTERPRISE" != "null" ]; then
        print_warning "Enterprise app already exists with ID: $EXISTING_ENTERPRISE"
        print_status "Updating existing enterprise app..."
        ENTERPRISE_APP_ID="$EXISTING_ENTERPRISE"
        doctl apps update "$EXISTING_ENTERPRISE" --spec enterprise-app-spec.yaml > /dev/null
    else
        print_status "Creating new enterprise app..."
        ENTERPRISE_APP_ID=$(doctl apps create --spec enterprise-app-spec.yaml --output json | jq -r '.id')
    fi
    
    if [ -z "$ENTERPRISE_APP_ID" ] || [ "$ENTERPRISE_APP_ID" = "null" ]; then
        print_error "Failed to create/update enterprise app"
        return 1
    fi
    
    print_success "Enterprise App ID: $ENTERPRISE_APP_ID"
    echo "$ENTERPRISE_APP_ID" > .enterprise_app_id
    return 0
}

# Deploy Marketing App
deploy_marketing() {
    print_status "Deploying Marketing App..."
    
    # Check if app already exists
    EXISTING_MARKETING=$(doctl apps list --output json | jq -r '.[] | select(.spec.name == "app-oint-marketing") | .id')
    
    if [ -n "$EXISTING_MARKETING" ] && [ "$EXISTING_MARKETING" != "null" ]; then
        print_warning "Marketing app already exists with ID: $EXISTING_MARKETING"
        print_status "Updating existing marketing app..."
        MARKETING_APP_ID="$EXISTING_MARKETING"
        doctl apps update "$EXISTING_MARKETING" --spec marketing-app-spec.yaml > /dev/null
    else
        print_status "Creating new marketing app..."
        doctl apps create --spec marketing-app-spec.yaml > /dev/null
        # Get the newly created app ID
        MARKETING_APP_ID=$(doctl apps list --output json | jq -r '.[] | select(.spec.name == "app-oint-marketing") | .id')
    fi
    
    if [ -z "$MARKETING_APP_ID" ] || [ "$MARKETING_APP_ID" = "null" ]; then
        print_error "Failed to create/update marketing app"
        return 1
    fi
    
    print_success "Marketing App ID: $MARKETING_APP_ID"
    echo "$MARKETING_APP_ID" > .marketing_app_id
    return 0
}

# Wait for deployment and check status
wait_for_deployment() {
    print_status "Waiting for deployments to complete..."
    
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        print_status "Checking deployment status (attempt $attempt/$max_attempts)..."
        
        local all_ready=true
        
        # Check business app
        if [ -f .business_app_id ]; then
            BUSINESS_APP_ID=$(cat .business_app_id)
            BUSINESS_STATUS=$(doctl apps get "$BUSINESS_APP_ID" --output json 2>/dev/null | jq -r '.spec.services[0].status' 2>/dev/null || echo "unknown")
            print_status "Business app status: $BUSINESS_STATUS"
            if [ "$BUSINESS_STATUS" != "RUNNING" ]; then
                all_ready=false
            fi
        fi
        
        # Check enterprise app
        if [ -f .enterprise_app_id ]; then
            ENTERPRISE_APP_ID=$(cat .enterprise_app_id)
            ENTERPRISE_STATUS=$(doctl apps get "$ENTERPRISE_APP_ID" --output json 2>/dev/null | jq -r '.spec.services[0].status' 2>/dev/null || echo "unknown")
            print_status "Enterprise app status: $ENTERPRISE_STATUS"
            if [ "$ENTERPRISE_STATUS" != "RUNNING" ]; then
                all_ready=false
            fi
        fi
        
        # Check marketing app
        if [ -f .marketing_app_id ]; then
            MARKETING_APP_ID=$(cat .marketing_app_id)
            MARKETING_STATUS=$(doctl apps get "$MARKETING_APP_ID" --output json 2>/dev/null | jq -r '.spec.services[0].status' 2>/dev/null || echo "unknown")
            print_status "Marketing app status: $MARKETING_STATUS"
            if [ "$MARKETING_STATUS" != "RUNNING" ]; then
                all_ready=false
            fi
        fi
        
        if [ "$all_ready" = true ]; then
            print_success "All apps are running!"
            return 0
        fi
        
        print_status "Waiting 30 seconds before next check..."
        sleep 30
        attempt=$((attempt + 1))
    done
    
    print_error "Deployment timeout after $max_attempts attempts"
    return 1
}

# Test the deployments
test_deployments() {
    print_status "Testing deployments..."
    
    if [ -f .business_app_id ]; then
        BUSINESS_APP_ID=$(cat .business_app_id)
        BUSINESS_URL=$(doctl apps get "$BUSINESS_APP_ID" --output json | jq -r '.spec.services[0].ingress.rules[0].component.source_url')
        print_status "Testing business app at: $BUSINESS_URL"
        
        if curl -s -f "$BUSINESS_URL/health" > /dev/null; then
            print_success "Business app is responding"
        else
            print_warning "Business app health check failed"
        fi
    fi
    
    if [ -f .enterprise_app_id ]; then
        ENTERPRISE_APP_ID=$(cat .enterprise_app_id)
        ENTERPRISE_URL=$(doctl apps get "$ENTERPRISE_APP_ID" --output json | jq -r '.spec.services[0].ingress.rules[0].component.source_url')
        print_status "Testing enterprise app at: $ENTERPRISE_URL"
        
        if curl -s -f "$ENTERPRISE_URL/health" > /dev/null; then
            print_success "Enterprise app is responding"
        else
            print_warning "Enterprise app health check failed"
        fi
    fi
    
    if [ -f .marketing_app_id ]; then
        MARKETING_APP_ID=$(cat .marketing_app_id)
        MARKETING_URL=$(doctl apps get "$MARKETING_APP_ID" --output json | jq -r '.spec.services[0].ingress.rules[0].component.source_url')
        print_status "Testing marketing app at: $MARKETING_URL"
        
        if curl -s -f "$MARKETING_URL" > /dev/null; then
            print_success "Marketing app is responding"
        else
            print_warning "Marketing app health check failed"
        fi
    fi
}

# Display deployment summary
show_deployment_summary() {
    print_status "Deployment Summary:"
    echo ""
    
    if [ -f .business_app_id ]; then
        BUSINESS_APP_ID=$(cat .business_app_id)
        BUSINESS_URL=$(doctl apps get "$BUSINESS_APP_ID" --output json | jq -r '.spec.services[0].ingress.rules[0].component.source_url')
        print_success "Business App: $BUSINESS_URL"
    fi
    
    if [ -f .enterprise_app_id ]; then
        ENTERPRISE_APP_ID=$(cat .enterprise_app_id)
        ENTERPRISE_URL=$(doctl apps get "$ENTERPRISE_APP_ID" --output json | jq -r '.spec.services[0].ingress.rules[0].component.source_url')
        print_success "Enterprise App: $ENTERPRISE_URL"
    fi
    
    if [ -f .marketing_app_id ]; then
        MARKETING_APP_ID=$(cat .marketing_app_id)
        MARKETING_URL=$(doctl apps get "$MARKETING_APP_ID" --output json | jq -r '.spec.services[0].ingress.rules[0].component.source_url')
        print_success "Marketing App: $MARKETING_URL"
    fi
    
    echo ""
    print_warning "Next steps:"
    echo "1. Configure DNS records for custom domains"
    echo "2. Set up SSL certificates"
    echo "3. Configure monitoring and logging"
}

# Cleanup function
cleanup() {
    print_status "Cleaning up temporary files..."
    rm -f .business_app_id .enterprise_app_id .marketing_app_id
}

# Main execution
main() {
    print_status "Starting complete platform deployment..."
    
    check_prerequisites
    
    # Deploy all apps
    deploy_business || exit 1
    deploy_enterprise || exit 1
    deploy_marketing || exit 1
    
    # Wait for deployments
    wait_for_deployment || exit 1
    
    # Test deployments
    test_deployments
    
    # Show summary
    show_deployment_summary
    
    print_success "Complete platform deployment finished!"
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Run main function
main "$@" 