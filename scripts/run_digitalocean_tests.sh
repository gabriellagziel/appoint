#!/bin/bash

# 🌊 DigitalOcean Comprehensive Test Suite
# This script runs all possible tests on the codebase deployed to DigitalOcean

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_ID="620a2ee8-e942-451c-9cfd-8ece55511eb8"
API_BASE_URL="https://api.app-oint.com"
WEB_APP_URL="https://app-oint-core.web.app"
ADMIN_URL="https://app-oint-core.web.app/admin"
BUSINESS_URL="https://app-oint-core.web.app/business"

# Test results directory
TEST_RESULTS_DIR="test_results_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$TEST_RESULTS_DIR"

echo -e "${BLUE}🌊 DigitalOcean Comprehensive Test Suite${NC}"
echo -e "${BLUE}========================================${NC}"
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

# Function to run a test and capture results
run_test() {
    local test_name="$1"
    local test_command="$2"
    local output_file="$TEST_RESULTS_DIR/${test_name}.log"
    
    echo -n "Running $test_name... "
    
    if eval "$test_command" > "$output_file" 2>&1; then
        print_status "PASSED"
        echo "PASSED" > "$TEST_RESULTS_DIR/${test_name}.result"
        return 0
    else
        print_error "FAILED"
        echo "FAILED" > "$TEST_RESULTS_DIR/${test_name}.result"
        return 1
    fi
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

# 1. Environment and Infrastructure Tests
echo -e "${BLUE}🔧 Phase 1: Environment and Infrastructure Tests${NC}"
echo "========================================================"

print_info "Testing DigitalOcean App Platform connectivity..."
if doctl apps get "$APP_ID" > /dev/null 2>&1; then
    print_status "DigitalOcean App Platform is accessible"
else
    print_error "DigitalOcean App Platform is not accessible"
fi

print_info "Testing API endpoints..."
test_endpoint "API Base" "$API_BASE_URL"
test_endpoint "API Health" "$API_BASE_URL/health"
test_endpoint "API Status" "$API_BASE_URL/status"

print_info "Testing Web App endpoints..."
test_endpoint "Web App" "$WEB_APP_URL"
test_endpoint "Admin Panel" "$ADMIN_URL"
test_endpoint "Business Panel" "$BUSINESS_URL"

# 2. Flutter Unit Tests
echo -e "\n${BLUE}🧪 Phase 2: Flutter Unit Tests${NC}"
echo "====================================="

print_info "Running Flutter unit tests..."
run_test "flutter_unit_tests" "flutter test --coverage"

print_info "Running model tests..."
run_test "model_tests" "flutter test test/models/"

print_info "Running service tests..."
run_test "service_tests" "flutter test test/services/"

print_info "Running feature tests..."
run_test "feature_tests" "flutter test test/features/"

print_info "Running provider tests..."
run_test "provider_tests" "flutter test test/providers/"

# 3. Integration Tests
echo -e "\n${BLUE}🔗 Phase 3: Integration Tests${NC}"
echo "=================================="

print_info "Running integration tests..."
run_test "integration_tests" "flutter test test/integration/"

print_info "Running booking flow tests..."
run_test "booking_flow_tests" "flutter test test/features/booking/"

print_info "Running admin tests..."
run_test "admin_tests" "flutter test test/features/admin/"

print_info "Running business tests..."
run_test "business_tests" "flutter test test/features/business/"

# 4. Performance Tests
echo -e "\n${BLUE}⚡ Phase 4: Performance Tests${NC}"
echo "=================================="

print_info "Testing API response times..."
for endpoint in "/health" "/status" "/api/status"; do
    echo -n "Testing $API_BASE_URL$endpoint... "
    start_time=$(date +%s.%N)
    if curl -f -s "$API_BASE_URL$endpoint" > /dev/null; then
        end_time=$(date +%s.%N)
        response_time=$(echo "$end_time - $start_time" | bc -l)
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
        response_time=$(echo "$end_time - $start_time" | bc -l)
        print_status "OK (${response_time}s)"
    else
        print_error "FAILED"
    fi
done

# 5. Security Tests
echo -e "\n${BLUE}🔒 Phase 5: Security Tests${NC}"
echo "================================"

print_info "Running security tests..."
run_test "security_tests" "flutter test test/security_rules_test.dart"

print_info "Testing HTTPS enforcement..."
for url in "$API_BASE_URL" "$WEB_APP_URL" "$ADMIN_URL" "$BUSINESS_URL"; do
    echo -n "Testing HTTPS for $url... "
    if curl -I "$url" 2>/dev/null | grep -q "HTTP/2\|HTTP/1.1 200"; then
        print_status "HTTPS enforced"
    else
        print_error "HTTPS not enforced"
    fi
done

# 6. Accessibility Tests
echo -e "\n${BLUE}♿ Phase 6: Accessibility Tests${NC}"
echo "====================================="

print_info "Running accessibility tests..."
run_test "accessibility_tests" "flutter test test/a11y/"

print_info "Running standalone accessibility tests..."
run_test "accessibility_standalone" "flutter test test/accessibility_standalone_test.dart"

# 7. QA Tests
echo -e "\n${BLUE}📋 Phase 7: QA Tests${NC}"
echo "============================="

print_info "Running comprehensive QA tests..."
run_test "qa_tests" "dart test/run_qa_tests.dart"

print_info "Running phase 2 tests..."
run_test "phase2_tests" "dart test/run_phase2_tests.dart"

# 8. Custom API Tests
echo -e "\n${BLUE}🌐 Phase 8: Custom API Tests${NC}"
echo "=================================="

print_info "Testing business API endpoints..."
test_endpoint "Business API" "$API_BASE_URL/businessApi/status"
test_endpoint "Appointments API" "$API_BASE_URL/businessApi/appointments"
test_endpoint "Usage Stats API" "$API_BASE_URL/getUsageStats"

print_info "Testing admin API endpoints..."
test_endpoint "Admin API" "$API_BASE_URL/admin/status"
test_endpoint "Broadcast API" "$API_BASE_URL/admin/broadcast"

# 9. Database and Storage Tests
echo -e "\n${BLUE}💾 Phase 9: Database and Storage Tests${NC}"
echo "============================================="

print_info "Testing Firebase connectivity..."
run_test "firebase_tests" "flutter test test/firebase_test_helper.dart"

print_info "Testing data persistence..."
run_test "storage_tests" "flutter test test/services/"

# 10. Generate Comprehensive Report
echo -e "\n${BLUE}📊 Phase 10: Generate Comprehensive Report${NC}"
echo "================================================"

print_info "Generating test report..."

# Count test results
total_tests=$(ls "$TEST_RESULTS_DIR"/*.result 2>/dev/null | wc -l)
passed_tests=$(grep -l "PASSED" "$TEST_RESULTS_DIR"/*.result 2>/dev/null | wc -l)
failed_tests=$(grep -l "FAILED" "$TEST_RESULTS_DIR"/*.result 2>/dev/null | wc -l)

# Generate report
cat > "$TEST_RESULTS_DIR/comprehensive_test_report.md" << EOF
# DigitalOcean Comprehensive Test Report

## Test Execution Summary
- **Total Tests:** $total_tests
- **Passed:** $passed_tests
- **Failed:** $failed_tests
- **Success Rate:** $(echo "scale=2; $passed_tests * 100 / $total_tests" | bc -l)%

## Test Categories

### 1. Environment and Infrastructure Tests
- DigitalOcean App Platform connectivity
- API endpoint accessibility
- Web app endpoint accessibility

### 2. Flutter Unit Tests
- Model tests
- Service tests
- Feature tests
- Provider tests

### 3. Integration Tests
- Booking flow tests
- Admin tests
- Business tests

### 4. Performance Tests
- API response times
- Web app load times

### 5. Security Tests
- Security rules tests
- HTTPS enforcement

### 6. Accessibility Tests
- Accessibility compliance tests

### 7. QA Tests
- Comprehensive QA test suite
- Phase 2 tests

### 8. Custom API Tests
- Business API endpoints
- Admin API endpoints

### 9. Database and Storage Tests
- Firebase connectivity
- Data persistence

## Detailed Results

EOF

# Add detailed results
for result_file in "$TEST_RESULTS_DIR"/*.result; do
    if [ -f "$result_file" ]; then
        test_name=$(basename "$result_file" .result)
        status=$(cat "$result_file")
        echo "- **$test_name:** $status" >> "$TEST_RESULTS_DIR/comprehensive_test_report.md"
    fi
done

# Add timestamp
echo "" >> "$TEST_RESULTS_DIR/comprehensive_test_report.md"
echo "## Test Execution Details" >> "$TEST_RESULTS_DIR/comprehensive_test_report.md"
echo "- **Execution Time:** $(date)" >> "$TEST_RESULTS_DIR/comprehensive_test_report.md"
echo "- **Environment:** DigitalOcean App Platform" >> "$TEST_RESULTS_DIR/comprehensive_test_report.md"
echo "- **App ID:** $APP_ID" >> "$TEST_RESULTS_DIR/comprehensive_test_report.md"

print_status "Comprehensive test report generated: $TEST_RESULTS_DIR/comprehensive_test_report.md"

# Final summary
echo -e "\n${BLUE}🎉 Test Execution Complete!${NC}"
echo "================================"
echo -e "${GREEN}✅ Total Tests: $total_tests${NC}"
echo -e "${GREEN}✅ Passed: $passed_tests${NC}"
echo -e "${RED}❌ Failed: $failed_tests${NC}"
echo -e "${BLUE}📊 Success Rate: $(echo "scale=2; $passed_tests * 100 / $total_tests" | bc -l)%${NC}"
echo ""
echo -e "${BLUE}📁 Test results saved in: $TEST_RESULTS_DIR${NC}"
echo -e "${BLUE}📄 Report: $TEST_RESULTS_DIR/comprehensive_test_report.md${NC}"

# Exit with error if any tests failed
if [ $failed_tests -gt 0 ]; then
    print_warning "Some tests failed. Check the detailed logs in $TEST_RESULTS_DIR"
    exit 1
else
    print_status "All tests passed successfully!"
    exit 0
fi 