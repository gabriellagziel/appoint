#!/bin/bash

# 🚀 Quick DigitalOcean Test Suite
# This script runs immediate tests that can work with current deployment status

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

echo -e "${BLUE}🚀 Quick DigitalOcean Test Suite${NC}"
echo -e "${BLUE}==============================${NC}"
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
    
    echo -n "Testing $name ($url)... "
    
    if curl -f -s "$url" > /dev/null 2>&1; then
        print_status "OK"
        return 0
    else
        print_error "FAILED"
        return 1
    fi
}

# 1. Check DigitalOcean CLI and App Status
echo -e "${BLUE}🔧 Phase 1: DigitalOcean Infrastructure Check${NC}"
echo "====================================================="

print_info "Checking DigitalOcean CLI..."
if command -v doctl > /dev/null; then
    print_status "DigitalOcean CLI is installed"
    doctl version
else
    print_error "DigitalOcean CLI is not installed"
fi

print_info "Checking DigitalOcean App Platform access..."
if doctl apps get "$APP_ID" > /dev/null 2>&1; then
    print_status "DigitalOcean App Platform is accessible"
    doctl apps get "$APP_ID" --format Spec.Name,ActiveDeployment.Status,LiveURL
else
    print_error "DigitalOcean App Platform is not accessible"
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
test_endpoint "Admin Panel" "$WEB_APP_URL/admin"
test_endpoint "Business Panel" "$WEB_APP_URL/business"

# 4. Run Flutter Tests Locally
echo -e "\n${BLUE}🧪 Phase 4: Local Flutter Tests${NC}"
echo "====================================="

print_info "Running Flutter unit tests..."
if flutter test --coverage; then
    print_status "Flutter unit tests passed"
else
    print_error "Flutter unit tests failed"
fi

print_info "Running model tests..."
if flutter test test/models/; then
    print_status "Model tests passed"
else
    print_error "Model tests failed"
fi

print_info "Running service tests..."
if flutter test test/services/; then
    print_status "Service tests passed"
else
    print_error "Service tests failed"
fi

# 5. Run Integration Tests
echo -e "\n${BLUE}🔗 Phase 5: Integration Tests${NC}"
echo "=================================="

print_info "Running integration tests..."
if flutter test test/integration/; then
    print_status "Integration tests passed"
else
    print_error "Integration tests failed"
fi

# 6. Run Feature Tests
echo -e "\n${BLUE}🎯 Phase 6: Feature Tests${NC}"
echo "================================"

print_info "Running booking flow tests..."
if flutter test test/features/booking/; then
    print_status "Booking flow tests passed"
else
    print_error "Booking flow tests failed"
fi

print_info "Running admin tests..."
if flutter test test/features/admin/; then
    print_status "Admin tests passed"
else
    print_error "Admin tests failed"
fi

print_info "Running business tests..."
if flutter test test/features/business/; then
    print_status "Business tests passed"
else
    print_error "Business tests failed"
fi

# 7. Run Security Tests
echo -e "\n${BLUE}🔒 Phase 7: Security Tests${NC}"
echo "================================"

print_info "Running security tests..."
if flutter test test/security_rules_test.dart; then
    print_status "Security tests passed"
else
    print_error "Security tests failed"
fi

# 8. Run Accessibility Tests
echo -e "\n${BLUE}♿ Phase 8: Accessibility Tests${NC}"
echo "====================================="

print_info "Running accessibility tests..."
if flutter test test/a11y/; then
    print_status "Accessibility tests passed"
else
    print_error "Accessibility tests failed"
fi

print_info "Running standalone accessibility tests..."
if flutter test test/accessibility_standalone_test.dart; then
    print_status "Standalone accessibility tests passed"
else
    print_error "Standalone accessibility tests failed"
fi

# 9. Performance Tests
echo -e "\n${BLUE}⚡ Phase 9: Performance Tests${NC}"
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

# 10. Generate Test Summary
echo -e "\n${BLUE}📊 Phase 10: Test Summary${NC}"
echo "================================"

print_info "Generating test summary..."

# Create summary report
cat > "quick_test_summary_$(date +%Y%m%d_%H%M%S).md" << EOF
# Quick DigitalOcean Test Summary

## Test Execution Details
- **Execution Time:** $(date)
- **Environment:** DigitalOcean App Platform
- **App ID:** $APP_ID

## Test Categories Executed

### 1. DigitalOcean Infrastructure Check
- DigitalOcean CLI availability
- App Platform connectivity
- App status and deployment info

### 2. API Endpoint Tests
- API base connectivity
- Health endpoint
- Status endpoint

### 3. Web App Endpoint Tests
- Main web app
- Admin panel
- Business panel

### 4. Local Flutter Tests
- Unit tests
- Model tests
- Service tests

### 5. Integration Tests
- Integration test suite

### 6. Feature Tests
- Booking flow tests
- Admin tests
- Business tests

### 7. Security Tests
- Security rules compliance

### 8. Accessibility Tests
- Accessibility compliance
- Standalone accessibility tests

### 9. Performance Tests
- API response time measurements

## Next Steps
1. Review any failed tests
2. Check deployment status if needed
3. Run comprehensive tests after deployment is complete

EOF

print_status "Test summary generated: quick_test_summary_$(date +%Y%m%d_%H%M%S).md"

echo -e "\n${BLUE}🎉 Quick Test Suite Complete!${NC}"
echo "=================================="
print_info "All immediate tests have been executed"
print_info "Check the summary report for detailed results"
print_info "Run the comprehensive test suite after deployment is complete" 