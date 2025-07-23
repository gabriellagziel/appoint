#!/bin/bash

# 🛠️ Fix Business Route SSL Configuration Script
# This script addresses the SSL certificate and routing issues for /business

set -e

echo "🔧 Starting Business Route SSL Fix..."
echo "================================================"

# Configuration
APP_ID="620a2ee8-e942-451c-9cfd-8ece55511eb8"
SPEC_FILE="fixed-business-ssl-spec.yaml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}ℹ️ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check prerequisites
print_status "Checking prerequisites..."

if ! command -v doctl &> /dev/null; then
    print_error "doctl CLI not found. Installing..."
    curl -L https://github.com/digitalocean/doctl/releases/download/v1.104.0/doctl-1.104.0-linux-amd64.tar.gz | tar xz
    sudo mv doctl /usr/local/bin
    print_success "doctl installed"
fi

if [ -z "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
    print_error "DIGITALOCEAN_ACCESS_TOKEN environment variable is required"
    echo "Please set it with: export DIGITALOCEAN_ACCESS_TOKEN=your_token"
    exit 1
fi

# Authenticate with DigitalOcean
print_status "Authenticating with DigitalOcean..."
if doctl auth init --access-token "$DIGITALOCEAN_ACCESS_TOKEN"; then
    print_success "Authentication successful"
else
    print_error "Authentication failed. Please check your access token"
    exit 1
fi

# Check current app status
print_status "Checking current app status..."
APP_INFO=$(doctl apps get "$APP_ID" --format "Spec.Name,ActiveDeployment.Phase,ActiveDeployment.UpdatedAt" --no-header 2>/dev/null || echo "ERROR")

if [ "$APP_INFO" = "ERROR" ]; then
    print_error "Failed to get app information. Please check APP_ID: $APP_ID"
    exit 1
fi

echo "Current app status: $APP_INFO"

# Backup current app spec
print_status "Backing up current app specification..."
doctl apps spec get "$APP_ID" > "backup-app-spec-$(date +%Y%m%d-%H%M%S).yaml"
print_success "App spec backed up"

# Update app with new specification
print_status "Updating app with fixed business route configuration..."
if doctl apps update "$APP_ID" --spec "$SPEC_FILE"; then
    print_success "App specification updated successfully"
else
    print_error "Failed to update app specification"
    exit 1
fi

# Wait for deployment to complete
print_status "Waiting for deployment to complete..."
DEPLOYMENT_ID=$(doctl apps list-deployments "$APP_ID" --format "ID" --no-header | head -1)

if [ -n "$DEPLOYMENT_ID" ]; then
    print_status "Monitoring deployment: $DEPLOYMENT_ID"
    
    # Wait for deployment with timeout
    TIMEOUT=300  # 5 minutes
    ELAPSED=0
    
    while [ $ELAPSED -lt $TIMEOUT ]; do
        PHASE=$(doctl apps get-deployment "$APP_ID" "$DEPLOYMENT_ID" --format "Phase" --no-header 2>/dev/null || echo "UNKNOWN")
        
        case "$PHASE" in
            "ACTIVE")
                print_success "Deployment completed successfully!"
                break
                ;;
            "FAILED"|"CANCELED")
                print_error "Deployment failed with phase: $PHASE"
                exit 1
                ;;
            "PENDING"|"DEPLOYING"|"BUILDING")
                print_status "Deployment in progress... ($PHASE)"
                ;;
            *)
                print_warning "Unknown deployment phase: $PHASE"
                ;;
        esac
        
        sleep 10
        ELAPSED=$((ELAPSED + 10))
    done
    
    if [ $ELAPSED -ge $TIMEOUT ]; then
        print_warning "Deployment timeout reached. Check manually."
    fi
else
    print_warning "Could not get deployment ID for monitoring"
fi

# Test the fixed routes
print_status "Testing SSL certificate and routes..."

echo ""
echo "🔍 SSL Certificate Test:"
echo "========================"

SSL_INFO=$(openssl s_client -connect app-oint.com:443 -servername app-oint.com </dev/null 2>/dev/null | openssl x509 -noout -dates -issuer -subject 2>/dev/null || echo "ERROR")

if [ "$SSL_INFO" != "ERROR" ]; then
    echo "$SSL_INFO"
    
    # Check if certificate is for correct domain
    if echo "$SSL_INFO" | grep -q "subject=CN=app-oint.com"; then
        print_success "SSL Certificate correctly issued for app-oint.com"
    else
        print_warning "SSL Certificate domain mismatch detected"
        echo "Certificate subject: $(echo "$SSL_INFO" | grep subject)"
    fi
else
    print_error "Failed to retrieve SSL certificate information"
fi

echo ""
echo "🌐 Route Testing:"
echo "================"

# Test main domain
print_status "Testing main domain..."
MAIN_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://app-oint.com)
if [ "$MAIN_STATUS" = "200" ]; then
    print_success "Main domain (/) - HTTP $MAIN_STATUS"
else
    print_warning "Main domain (/) - HTTP $MAIN_STATUS"
fi

# Test business route
print_status "Testing business route..."
BUSINESS_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://app-oint.com/business)
if [ "$BUSINESS_STATUS" = "200" ]; then
    print_success "Business route (/business) - HTTP $BUSINESS_STATUS"
elif [ "$BUSINESS_STATUS" = "308" ]; then
    print_warning "Business route (/business) - HTTP $BUSINESS_STATUS (redirect)"
    # Test with trailing slash
    BUSINESS_SLASH_STATUS=$(curl -s -o /dev/null -w "%{http_code}" https://app-oint.com/business/)
    if [ "$BUSINESS_SLASH_STATUS" = "200" ]; then
        print_success "Business route (/business/) - HTTP $BUSINESS_SLASH_STATUS"
    else
        print_error "Business route (/business/) - HTTP $BUSINESS_SLASH_STATUS"
    fi
else
    print_error "Business route (/business) - HTTP $BUSINESS_STATUS"
fi

# Get app URLs
print_status "Getting app URLs..."
doctl apps get "$APP_ID" --format "Spec.Name,LiveURL" --no-header

echo ""
echo "📋 Summary Report:"
echo "=================="

# Generate final status
CURRENT_TIME=$(date)
APP_STATUS=$(doctl apps get "$APP_ID" --format "ActiveDeployment.Phase" --no-header 2>/dev/null || echo "UNKNOWN")

cat > business-ssl-fix-report.json << EOF
{
  "timestamp": "$CURRENT_TIME",
  "app_id": "$APP_ID",
  "deployment_status": "$APP_STATUS",
  "ssl_certificate": {
    "status": "$(echo "$SSL_INFO" | grep -q "subject=CN=app-oint.com" && echo "VALID" || echo "NEEDS_ATTENTION")",
    "issuer": "$(echo "$SSL_INFO" | grep issuer | cut -d'=' -f2- || echo "Unknown")",
    "subject": "$(echo "$SSL_INFO" | grep subject | cut -d'=' -f2- || echo "Unknown")",
    "validity": "$(echo "$SSL_INFO" | grep notAfter | cut -d'=' -f2- || echo "Unknown")"
  },
  "routes": {
    "main_domain": {
      "url": "https://app-oint.com",
      "status": "$MAIN_STATUS"
    },
    "business_route": {
      "url": "https://app-oint.com/business",
      "status": "$BUSINESS_STATUS"
    }
  }
}
EOF

print_success "Deployment fix completed!"
print_status "Report saved to: business-ssl-fix-report.json"

echo ""
echo "🎯 Next Steps:"
echo "=============="
if [ "$BUSINESS_STATUS" = "200" ] && echo "$SSL_INFO" | grep -q "subject=CN=app-oint.com"; then
    print_success "All issues resolved successfully!"
    echo "✅ SSL Certificate: Valid for app-oint.com"
    echo "✅ Business Route: Working (HTTP 200)"
    echo "✅ Domain Configuration: Properly configured"
else
    print_warning "Some issues may require manual attention:"
    [ "$BUSINESS_STATUS" != "200" ] && echo "• Business route still returns HTTP $BUSINESS_STATUS"
    echo "$SSL_INFO" | grep -q "subject=CN=app-oint.com" || echo "• SSL certificate domain mismatch"
    echo ""
    echo "🔧 Manual Steps if needed:"
    echo "1. Check DigitalOcean App Platform dashboard"
    echo "2. Verify domain DNS settings"
    echo "3. Force SSL certificate refresh if domain mismatch persists"
fi

echo ""
echo "📍 Useful URLs:"
echo "• App Dashboard: https://cloud.digitalocean.com/apps/$APP_ID"
echo "• Live App: https://app-oint.com"
echo "• Business Route: https://app-oint.com/business"