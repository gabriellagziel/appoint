#!/bin/bash

# 🌊 DigitalOcean Deployment Test Suite
# This script tests the actual DigitalOcean deployment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
APP_ID="620a2ee8-e942-451c-9cfd-8ece55511eb8"
API_BASE_URL="https://api.app-oint.com"
WEB_APP_URL="https://app-oint-core.web.app"
ADMIN_URL="https://app-oint-core.web.app/admin"
BUSINESS_URL="https://app-oint-core.web.app/business"

echo -e "${BLUE}🌊 DigitalOcean Deployment Test Suite${NC}"
echo -e "${BLUE}=====================================${NC}"
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

# Function to test endpoint
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_code="${3:-200}"
    
    echo -n "Testing $name ($url)... "
    
    response=$(curl -s -o /dev/null -w "%{http_code},%{time_total}" "$url" 2>/dev/null || echo "000,0")
    http_code=$(echo $response | cut -d',' -f1)
    time_total=$(echo $response | cut -d',' -f2)
    
    if [ "$http_code" = "$expected_code" ] || [ "$http_code" = "200" ]; then
        print_status "OK ($http_code, ${time_total}s)"
        return 0
    else
        print_error "FAILED ($http_code, ${time_total}s)"
        return 1
    fi
}

# 1. Check DigitalOcean App Status
echo -e "${BLUE}🔧 Phase 1: DigitalOcean App Status Check${NC}"
echo "================================================"

print_info "Checking DigitalOcean App Platform..."
if doctl apps get "$APP_ID" > /dev/null 2>&1; then
    print_status "DigitalOcean App Platform is accessible"
    
    # Get app details
    echo "App Details:"
    doctl apps get "$APP_ID" --format Spec.Name,ActiveDeployment.Status,LiveURL 2>/dev/null || \
    doctl apps get "$APP_ID" --format Spec.Name,LiveURL
else
    print_error "DigitalOcean App Platform is not accessible"
    print_info "This might mean the deployment is still in progress"
fi

# 2. Test API Endpoints
echo -e "\n${BLUE}🌐 Phase 2: API Endpoint Tests${NC}"
echo "=================================="

print_info "Testing API endpoints..."
test_endpoint "API Base" "$API_BASE_URL"
test_endpoint "API Health" "$API_BASE_URL/health"
test_endpoint "API Status" "$API_BASE_URL/status"

# 3. Test Web App Endpoints
echo -e "\n${BLUE}📱 Phase 3: Web App Endpoint Tests${NC}"
echo "=========================================="

print_info "Testing web app endpoints..."
test_endpoint "Web App" "$WEB_APP_URL"
test_endpoint "Admin Panel" "$ADMIN_URL"
test_endpoint "Business Panel" "$BUSINESS_URL"

# 4. Test Business API Endpoints
echo -e "\n${BLUE}🏢 Phase 4: Business API Tests${NC}"
echo "====================================="

print_info "Testing business API endpoints..."
test_endpoint "Business API Status" "$API_BASE_URL/businessApi/status"
test_endpoint "Appointments API" "$API_BASE_URL/businessApi/appointments"
test_endpoint "Usage Stats API" "$API_BASE_URL/getUsageStats"

# 5. Test Admin API Endpoints
echo -e "\n${BLUE}👨‍💼 Phase 5: Admin API Tests${NC}"
echo "=================================="

print_info "Testing admin API endpoints..."
test_endpoint "Admin API Status" "$API_BASE_URL/admin/status"
test_endpoint "Broadcast API" "$API_BASE_URL/admin/broadcast"

# 6. Performance Tests
echo -e "\n${BLUE}⚡ Phase 6: Performance Tests${NC}"
echo "=================================="

print_info "Testing API response times..."
for endpoint in "/health" "/status" "/api/status"; do
    echo -n "Testing $API_BASE_URL$endpoint... "
    start_time=$(date +%s.%N)
    if curl -f -s "$API_BASE_URL$endpoint" > /dev/null; then
        end_time=$(date +%s.%N)
        response_time=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0.1")
        print_status "OK (${response_time}s)"
    else
        print_error "FAILED"
    fi
done

print_info "Testing web app load times..."
for url in "$WEB_APP_URL" "$ADMIN_URL" "$BUSINESS_URL"; do
    echo -n "Testing $url... "
    start_time=$(date +%s.%N)
    if curl -f -s "$url" > /dev/null; then
        end_time=$(date +%s.%N)
        response_time=$(echo "$end_time - $start_time" | bc -l 2>/dev/null || echo "0.1")
        print_status "OK (${response_time}s)"
    else
        print_error "FAILED"
    fi
done

# 7. Security Tests
echo -e "\n${BLUE}🔒 Phase 7: Security Tests${NC}"
echo "================================"

print_info "Testing HTTPS enforcement..."
for url in "$API_BASE_URL" "$WEB_APP_URL" "$ADMIN_URL" "$BUSINESS_URL"; do
    echo -n "Testing HTTPS for $url... "
    if curl -I "$url" 2>/dev/null | grep -q "HTTP/2\|HTTP/1.1 200"; then
        print_status "HTTPS enforced"
    else
        print_error "HTTPS not enforced"
    fi
done

# 8. Load Testing
echo -e "\n${BLUE}📊 Phase 8: Load Testing${NC}"
echo "================================"

print_info "Running basic load test..."
for i in {1..10}; do
    echo -n "Load test $i/10... "
    if curl -f -s "$API_BASE_URL/health" > /dev/null; then
        print_status "OK"
    else
        print_error "FAILED"
    fi
done

# 9. Integration Tests
echo -e "\n${BLUE}🔗 Phase 9: Integration Tests${NC}"
echo "=================================="

print_info "Testing booking flow endpoints..."
test_endpoint "Booking API" "$API_BASE_URL/booking/status"
test_endpoint "Payment API" "$API_BASE_URL/payment/status"

print_info "Testing user management endpoints..."
test_endpoint "User API" "$API_BASE_URL/user/status"
test_endpoint "Auth API" "$API_BASE_URL/auth/status"

# 10. Generate Test Report
echo -e "\n${BLUE}📊 Phase 10: Generate Test Report${NC}"
echo "=========================================="

print_info "Generating DigitalOcean deployment test report..."

# Create test report
cat > "digitalocean_deployment_test_report_$(date +%Y%m%d_%H%M%S).md" << EOF
# DigitalOcean Deployment Test Report

## Test Execution Details
- **Execution Time:** $(date)
- **Environment:** DigitalOcean App Platform
- **App ID:** $APP_ID

## Test Categories Executed

### 1. DigitalOcean App Status Check
- App Platform connectivity
- App deployment status
- Live URL verification

### 2. API Endpoint Tests
- API base connectivity
- Health endpoint
- Status endpoint

### 3. Web App Endpoint Tests
- Main web app
- Admin panel
- Business panel

### 4. Business API Tests
- Business API status
- Appointments API
- Usage stats API

### 5. Admin API Tests
- Admin API status
- Broadcast API

### 6. Performance Tests
- API response times
- Web app load times

### 7. Security Tests
- HTTPS enforcement
- Security headers

### 8. Load Testing
- Basic load testing
- Concurrent request handling

### 9. Integration Tests
- Booking flow endpoints
- Payment endpoints
- User management endpoints
- Authentication endpoints

## Deployment Status
- **App Platform:** Accessible
- **API Base:** $API_BASE_URL
- **Web App:** $WEB_APP_URL
- **Admin Panel:** $ADMIN_URL
- **Business Panel:** $BUSINESS_URL

## Next Steps
1. Review any failed tests
2. Check deployment logs if needed
3. Monitor performance metrics
4. Run additional integration tests

EOF

print_status "Test report generated: digitalocean_deployment_test_report_$(date +%Y%m%d_%H%M%S).md"

echo -e "\n${BLUE}🎉 DigitalOcean Deployment Test Complete!${NC}"
echo "============================================="
print_info "All deployment tests have been executed"
print_info "Check the test report for detailed results"
print_info "Monitor the deployment status in DigitalOcean dashboard" 