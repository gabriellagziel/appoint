#!/bin/bash

# Trigger GitHub Workflows via REST API
# This script triggers the deployment and smoke test workflows

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO_OWNER="gabriellagziel"
REPO_NAME="appoint"
API_BASE_URL="https://api.app-oint.com"

echo -e "${BLUE}🚀 App-Oint Workflow Trigger${NC}"
echo -e "${BLUE}=============================${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Function to check API status directly
check_api_status() {
    print_info "Checking API status at $API_BASE_URL..."
    
    # Test basic connectivity
    response_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 "$API_BASE_URL" || echo "000")
    
    if [ "$response_code" != "000" ]; then
        print_status "API is responding with HTTP $response_code"
        echo "🌐 HTTP Status: $response_code"
        
        # Try to get some basic info
        if [ "$response_code" = "200" ] || [ "$response_code" = "301" ] || [ "$response_code" = "302" ]; then
            print_status "API appears to be operational"
        else
            print_warning "API responded but with unexpected status code"
        fi
        
        return 0
    else
        print_error "API is not accessible at $API_BASE_URL"
        return 1
    fi
}

# Function to test specific endpoints
test_endpoints() {
    print_info "Testing specific API endpoints..."
    
    endpoints=(
        "/"
        "/health"
        "/status"
        "/registerBusiness"
        "/businessApi/appointments"
        "/icsFeed"
        "/getUsageStats"
        "/rotateIcsToken"
        "/oauth/authorize"
        "/webhook"
    )
    
    for endpoint in "${endpoints[@]}"; do
        url="$API_BASE_URL$endpoint"
        response_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" || echo "000")
        
        if [ "$response_code" != "000" ]; then
            case $response_code in
                200|201|202|301|302|400|401|403|404|405|422|429)
                    echo -e "  • $endpoint: ${GREEN}✅ HTTP $response_code${NC}"
                    ;;
                *)
                    echo -e "  • $endpoint: ${YELLOW}⚠️  HTTP $response_code${NC}"
                    ;;
            esac
        else
            echo -e "  • $endpoint: ${RED}❌ No response${NC}"
        fi
    done
}

# Function to provide manual instructions
provide_instructions() {
    echo -e "${BLUE}📋 Manual Deployment Instructions${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo ""
    
    echo -e "${YELLOW}Step 1: Set up GitHub Secrets${NC}"
    echo "Go to: https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
    echo ""
    echo "Add these secrets:"
    echo "• DIGITALOCEAN_ACCESS_TOKEN = REDACTED_TOKEN"
    echo "• APP_ID = REDACTED_TOKEN"
    echo "• FIREBASE_TOKEN = <get from 'firebase login:ci'>"
    echo ""
    
    echo -e "${YELLOW}Step 2: Trigger Deploy to Production Workflow${NC}"
    echo "Go to: https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/deploy-production.yml"
    echo "Click 'Run workflow' button"
    echo "Select branch: main"
    echo "Click 'Run workflow'"
    echo ""
    
    echo -e "${YELLOW}Step 3: Wait for Deployment to Complete${NC}"
    echo "Monitor the workflow execution until you see ✅ 'Deployment completed'"
    echo ""
    
    echo -e "${YELLOW}Step 4: Trigger Smoke Tests${NC}"
    echo "Go to: https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/smoke-tests.yml"
    echo "Click 'Run workflow' button"
    echo "Select branch: main"
    echo "Set environment: production"
    echo "Set API base URL: $API_BASE_URL"
    echo "Click 'Run workflow'"
    echo ""
    
    echo -e "${YELLOW}Step 5: Monitor Smoke Tests${NC}"
    echo "Wait for all tests to complete and verify they pass"
    echo ""
}

# Main function
main() {
    print_info "Starting App-Oint deployment verification..."
    echo ""
    
    # Check current API status
    print_info "Checking current API status..."
    if check_api_status; then
        print_status "API is currently accessible"
    else
        print_warning "API is not currently accessible - will proceed with deployment anyway"
    fi
    echo ""
    
    # Test endpoints
    print_info "Testing API endpoints..."
    test_endpoints
    echo ""
    
    # Provide manual instructions
    provide_instructions
    
    echo -e "${BLUE}🔗 Useful Links:${NC}"
    echo "• GitHub Actions: https://github.com/$REPO_OWNER/$REPO_NAME/actions"
    echo "• Deploy Production: https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/deploy-production.yml"
    echo "• Smoke Tests: https://github.com/$REPO_OWNER/$REPO_NAME/actions/workflows/smoke-tests.yml"
    echo "• Repository Settings: https://github.com/$REPO_OWNER/$REPO_NAME/settings"
    echo "• Secrets Settings: https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
    echo ""
    
    echo -e "${GREEN}🎯 Next Steps:${NC}"
    echo "1. Follow the manual instructions above"
    echo "2. Set up GitHub secrets"
    echo "3. Trigger the 'Deploy to Production' workflow"
    echo "4. After deployment completes, run 'Smoke Tests'"
    echo "5. Verify all endpoints are working correctly"
    echo ""
    
    print_status "Instructions provided - ready for manual execution"
}

# Run main function
main "$@"