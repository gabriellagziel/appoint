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
    
    if ! command -v yq &> /dev/null; then
        print_error "yq is not installed. Please install it first."
        exit 1
    fi
    
    # Check if doctl is authenticated
    if ! doctl account get &> /dev/null; then
        print_error "doctl is not authenticated. Please run 'doctl auth init' first."
        exit 1
    fi
    
    print_success "All prerequisites are met!"
}

# 1. Create dedicated apps for Business, Enterprise & Marketing
create_apps() {
    print_status "Creating Business app..."
    BUSINESS_APP_ID=$(doctl apps create --spec business-app-spec.yaml --output json 2>/dev/null | jq -r '.id')
    if [ -z "$BUSINESS_APP_ID" ] || [ "$BUSINESS_APP_ID" = "null" ]; then
        print_warning "Business app already exists, getting existing app ID..."
        BUSINESS_APP_ID=$(doctl apps list --output json | jq -r '.[] | select(.spec.name == "app-oint-business") | .id')
        if [ -z "$BUSINESS_APP_ID" ] || [ "$BUSINESS_APP_ID" = "null" ]; then
            print_error "Failed to get Business app ID"
            exit 1
        fi
    fi
    print_success "Business App ID: $BUSINESS_APP_ID"

    print_status "Creating Enterprise app..."
    ENTERPRISE_APP_ID=$(doctl apps create --spec enterprise-app-spec.yaml --output json 2>/dev/null | jq -r '.id')
    if [ -z "$ENTERPRISE_APP_ID" ] || [ "$ENTERPRISE_APP_ID" = "null" ]; then
        print_warning "Enterprise app already exists, getting existing app ID..."
        ENTERPRISE_APP_ID=$(doctl apps list --output json | jq -r '.[] | select(.spec.name == "app-oint-enterprise") | .id')
        if [ -z "$ENTERPRISE_APP_ID" ] || [ "$ENTERPRISE_APP_ID" = "null" ]; then
            print_error "Failed to get Enterprise app ID"
            exit 1
        fi
    fi
    print_success "Enterprise App ID: $ENTERPRISE_APP_ID"
    
    print_status "Creating Marketing app..."
    MARKETING_APP_ID=$(doctl apps create --spec marketing-app-spec.yaml --output json 2>/dev/null | jq -r '.id')
    if [ -z "$MARKETING_APP_ID" ] || [ "$MARKETING_APP_ID" = "null" ]; then
        print_warning "Marketing app already exists, getting existing app ID..."
        MARKETING_APP_ID=$(doctl apps list --output json | jq -r '.[] | select(.spec.name == "app-oint-marketing") | .id')
        if [ -z "$MARKETING_APP_ID" ] || [ "$MARKETING_APP_ID" = "null" ]; then
            print_error "Failed to get Marketing app ID"
            exit 1
        fi
    fi
    print_success "Marketing App ID: $MARKETING_APP_ID"
    
    # Save app IDs for later use
    echo "$BUSINESS_APP_ID" > .business_app_id
    echo "$ENTERPRISE_APP_ID" > .enterprise_app_id
    echo "$MARKETING_APP_ID" > .marketing_app_id
}

# 2. Wait for apps to deploy
wait_for_deployment() {
    print_status "Waiting 3 minutes for all apps to build and deploy..."
    sleep 180
    
    # Check deployment status
    print_status "Checking deployment status..."
    
    if [ -f .business_app_id ]; then
        BUSINESS_APP_ID=$(cat .business_app_id)
        BUSINESS_STATUS=$(doctl apps get "$BUSINESS_APP_ID" --output json | jq -r '.spec.services[0].status')
        print_status "Business app status: $BUSINESS_STATUS"
    fi
    
    if [ -f .enterprise_app_id ]; then
        ENTERPRISE_APP_ID=$(cat .enterprise_app_id)
        ENTERPRISE_STATUS=$(doctl apps get "$ENTERPRISE_APP_ID" --output json | jq -r '.spec.services[0].status')
        print_status "Enterprise app status: $ENTERPRISE_STATUS"
    fi
    
    if [ -f .marketing_app_id ]; then
        MARKETING_APP_ID=$(cat .marketing_app_id)
        MARKETING_STATUS=$(doctl apps get "$MARKETING_APP_ID" --output json | jq -r '.spec.services[0].status')
        print_status "Marketing app status: $MARKETING_STATUS"
    fi
}

# 3. Attach custom domains in App Platform
attach_domains() {
    if [ -f .business_app_id ]; then
        BUSINESS_APP_ID=$(cat .business_app_id)
        print_status "Adding custom domain to Business app..."
        doctl apps domain create "$BUSINESS_APP_ID" --domain business.app-oint.com
        print_success "Domain business.app-oint.com attached to Business app"
    fi

    if [ -f .enterprise_app_id ]; then
        ENTERPRISE_APP_ID=$(cat .enterprise_app_id)
        print_status "Adding custom domain to Enterprise app..."
        doctl apps domain create "$ENTERPRISE_APP_ID" --domain enterprise.app-oint.com
        print_success "Domain enterprise.app-oint.com attached to Enterprise app"
    fi
    
    if [ -f .marketing_app_id ]; then
        MARKETING_APP_ID=$(cat .marketing_app_id)
        print_status "Adding custom domain to Marketing app..."
        doctl apps domain create "$MARKETING_APP_ID" --domain app-oint.com
        print_success "Domain app-oint.com attached to Marketing app"
    fi
}

# 4. Clean up consolidated app: remove Business, Enterprise & Marketing services
update_consolidated_app() {
    CONSOLIDATED_ID="620a2ee8-e942-451c-9cfd-8ece55511eb8"
    
    print_status "Fetching current spec for consolidated app..."
    if ! doctl apps spec get "$CONSOLIDATED_ID" > old_spec.yaml; then
        print_warning "Could not fetch consolidated app spec. Skipping update."
        return
    fi

    print_status "Stripping out business, enterprise & marketing services from spec..."
    if ! yq e 'del(.services[] | select(.name == "business" or .name == "enterprise" or .name == "marketing"))' old_spec.yaml > new_spec.yaml; then
        print_warning "Could not process spec with yq. Skipping update."
        return
    fi

    print_status "Updating consolidated app..."
    if doctl apps update "$CONSOLIDATED_ID" --spec new_spec.yaml; then
        print_success "Consolidated app updated successfully"
    else
        print_warning "Failed to update consolidated app"
    fi
    
    # Clean up temporary files
    rm -f old_spec.yaml new_spec.yaml
}

# 5. Display DNS instructions
show_dns_instructions() {
    if [ -f .business_app_id ] && [ -f .enterprise_app_id ] && [ -f .marketing_app_id ]; then
        BUSINESS_APP_ID=$(cat .business_app_id)
        ENTERPRISE_APP_ID=$(cat .enterprise_app_id)
        MARKETING_APP_ID=$(cat .marketing_app_id)
        
        cat <<EOF

🚨 NOW UPDATE YOUR DNS 🚨

Go to your DNS provider and add:

  Type: CNAME
  Name: business
  Value: ${BUSINESS_APP_ID}.ondigitalocean.app
  TTL: Auto

  Type: CNAME
  Name: enterprise
  Value: ${ENTERPRISE_APP_ID}.ondigitalocean.app
  TTL: Auto

  Type: CNAME
  Name: @ (or root)
  Value: ${MARKETING_APP_ID}.ondigitalocean.app
  TTL: Auto

Wait ~15 minutes for propagation, then verify:

  curl -I https://business.app-oint.com/
  curl -I https://enterprise.app-oint.com/
  curl -I https://app-oint.com/
  curl -I https://app-oint.com/admin/
  curl -I https://app-oint.com/api/health/

All should return 200 OK.

EOF
    else
        print_error "Could not retrieve app IDs for DNS instructions"
    fi
}

# Cleanup function
cleanup() {
    print_status "Cleaning up temporary files..."
    rm -f .business_app_id .enterprise_app_id .marketing_app_id
}

# Main execution
main() {
    print_status "Starting deployment process..."
    
    check_prerequisites
    create_apps
    wait_for_deployment
    attach_domains
    update_consolidated_app
    show_dns_instructions
    
    print_success "Deployment script completed!"
    print_warning "Remember to update your DNS records as shown above."
}

# Trap to ensure cleanup on exit
trap cleanup EXIT

# Run main function
main "$@" 