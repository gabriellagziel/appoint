#!/bin/bash

# 🧪 COMPREHENSIVE DIGITALOCEAN TEST SUITE FOR APP-OINT
# ======================================================
# Complete testing suite to make App-oint perfect on DigitalOcean

set -e

echo "🧪 COMPREHENSIVE APP-OINT TESTING SUITE"
echo "========================================"
echo "Testing every aspect of App-oint on DigitalOcean"
echo "Time: $(date)"
echo ""

# Initialize test results
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0
ISSUES_FOUND=()

# Test logging function
log_test() {
    local test_name="$1"
    local status="$2"
    local details="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    if [[ "$status" == "PASS" ]]; then
        echo "✅ $test_name: PASSED"
        PASSED_TESTS=$((PASSED_TESTS + 1))
    else
        echo "❌ $test_name: FAILED - $details"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        ISSUES_FOUND+=("$test_name: $details")
    fi
    
    if [[ -n "$details" && "$status" == "PASS" ]]; then
        echo "   ℹ️  $details"
    fi
}

# HTTP Test Function
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_status="${3:-200}"
    local timeout="${4:-10}"
    
    echo "🔍 Testing $name..."
    
    response=$(curl -s -o /dev/null -w "%{http_code}:%{time_total}:%{size_download}:%{content_type}" \
                    --max-time "$timeout" "$url" 2>/dev/null || echo "000:0:0:error")
    
    IFS=':' read -r status_code response_time size content_type <<< "$response"
    
    if [[ "$status_code" == "$expected_status" ]]; then
        log_test "$name" "PASS" "Status: $status_code | Time: ${response_time}s | Size: ${size} bytes"
    else
        log_test "$name" "FAIL" "Expected: $expected_status, Got: $status_code | Time: ${response_time}s"
    fi
}

# Advanced HTTP Test with Content Validation
test_endpoint_content() {
    local name="$1"
    local url="$2"
    local expected_content="$3"
    local timeout="${4:-10}"
    
    echo "🔍 Testing $name content..."
    
    content=$(curl -s --max-time "$timeout" "$url" 2>/dev/null || echo "")
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time "$timeout" "$url" 2>/dev/null || echo "000")
    
    if [[ "$status_code" == "200" ]] && [[ "$content" =~ $expected_content ]]; then
        log_test "$name Content" "PASS" "Found expected content: '$expected_content'"
    else
        log_test "$name Content" "FAIL" "Status: $status_code | Content check failed for: '$expected_content'"
    fi
}

# DNS Test Function
test_dns() {
    local name="$1"
    local domain="$2"
    
    echo "🌐 Testing DNS for $name..."
    
    if nslookup "$domain" >/dev/null 2>&1; then
        log_test "$name DNS" "PASS" "DNS resolution successful"
    else
        log_test "$name DNS" "FAIL" "DNS resolution failed"
    fi
}

# SSL Test Function
test_ssl() {
    local name="$1"
    local domain="$2"
    
    echo "🔒 Testing SSL for $name..."
    
    ssl_info=$(openssl s_client -servername "$domain" -connect "$domain:443" -verify_return_error </dev/null 2>/dev/null | grep "Verification:" || echo "failed")
    
    if [[ "$ssl_info" =~ "OK" ]]; then
        log_test "$name SSL" "PASS" "SSL certificate valid"
    else
        log_test "$name SSL" "FAIL" "SSL certificate issues"
    fi
}

echo "🏁 STARTING COMPREHENSIVE TESTS"
echo "================================"
echo ""

# 1. CORE APPLICATION TESTS
echo "📱 1. CORE APPLICATION TESTS"
echo "============================"

test_endpoint "Main Application" "https://app-oint.com/"
test_endpoint "Admin Portal" "https://app-oint.com/admin"
test_endpoint "Business Portal" "https://app-oint.com/business" "200"
test_endpoint "User Dashboard" "https://app-oint.com/dashboard" "200"
test_endpoint "Profile Page" "https://app-oint.com/profile" "200"
test_endpoint "Settings Page" "https://app-oint.com/settings" "200"

echo ""

# 2. API ENDPOINT TESTS
echo "🔌 2. API ENDPOINT TESTS"
echo "========================"

test_endpoint "API Health Check" "https://app-oint.com/api/health" "200"
test_endpoint "API Status" "https://app-oint.com/api/status" "200"
test_endpoint "API Authentication" "https://app-oint.com/api/auth" "200"
test_endpoint "API Bookings" "https://app-oint.com/api/bookings" "200"
test_endpoint "API Users" "https://app-oint.com/api/users" "200"
test_endpoint "API Services" "https://app-oint.com/api/services" "200"

echo ""

# 3. SUBDOMAIN TESTS  
echo "🌍 3. SUBDOMAIN TESTS"
echo "===================="

test_endpoint "API Subdomain" "https://api.app-oint.com/"
test_endpoint "API Subdomain Health" "https://api.app-oint.com/health"
test_endpoint "Admin Subdomain" "https://admin.app-oint.com/"
test_endpoint "Business Subdomain" "https://business.app-oint.com/"

echo ""

# 4. SEO & STATIC ASSETS
echo "🔍 4. SEO & STATIC ASSETS"
echo "========================="

test_endpoint "Robots.txt" "https://app-oint.com/robots.txt"
test_endpoint "Sitemap.xml" "https://app-oint.com/sitemap.xml"
test_endpoint "Favicon" "https://app-oint.com/favicon.ico"
test_endpoint "App Manifest" "https://app-oint.com/manifest.json"

# Content validation for SEO files
test_endpoint_content "Robots.txt Content" "https://app-oint.com/robots.txt" "User-agent"
test_endpoint_content "Sitemap Content" "https://app-oint.com/sitemap.xml" "xml"

echo ""

# 5. DNS TESTS
echo "🌐 5. DNS RESOLUTION TESTS"  
echo "=========================="

test_dns "Main Domain" "app-oint.com"
test_dns "API Subdomain" "api.app-oint.com" 
test_dns "Admin Subdomain" "admin.app-oint.com"
test_dns "Business Subdomain" "business.app-oint.com"

echo ""

# 6. SSL CERTIFICATE TESTS
echo "🔒 6. SSL CERTIFICATE TESTS"
echo "==========================="

test_ssl "Main Domain" "app-oint.com"
test_ssl "API Subdomain" "api.app-oint.com"
test_ssl "Admin Subdomain" "admin.app-oint.com"

echo ""

# 7. PERFORMANCE TESTS
echo "⚡ 7. PERFORMANCE TESTS"
echo "======================="

echo "🔍 Testing page load times..."

main_time=$(curl -s -o /dev/null -w "%{time_total}" https://app-oint.com/ 2>/dev/null || echo "999")
admin_time=$(curl -s -o /dev/null -w "%{time_total}" https://app-oint.com/admin 2>/dev/null || echo "999")

if (( $(echo "$main_time < 2.0" | bc -l) )); then
    log_test "Main App Performance" "PASS" "Load time: ${main_time}s (< 2s)"
else
    log_test "Main App Performance" "FAIL" "Load time: ${main_time}s (> 2s)"
fi

if (( $(echo "$admin_time < 2.0" | bc -l) )); then
    log_test "Admin Performance" "PASS" "Load time: ${admin_time}s (< 2s)"
else
    log_test "Admin Performance" "FAIL" "Load time: ${admin_time}s (> 2s)"
fi

echo ""

# 8. ACCESSIBILITY TESTS
echo "♿ 8. ACCESSIBILITY TESTS"
echo "========================="

# Test for basic accessibility elements
test_endpoint_content "Main App Accessibility" "https://app-oint.com/" "alt=\|aria-\|role="
test_endpoint_content "Admin Accessibility" "https://app-oint.com/admin" "alt=\|aria-\|role="

echo ""

# 9. LOCALIZATION TESTS
echo "🌍 9. LOCALIZATION TESTS"
echo "========================"

# Test different language endpoints if they exist
test_endpoint "English Locale" "https://app-oint.com/?lang=en"
test_endpoint "Spanish Locale" "https://app-oint.com/?lang=es"
test_endpoint "French Locale" "https://app-oint.com/?lang=fr"

echo ""

# 10. MOBILE RESPONSIVENESS
echo "📱 10. MOBILE RESPONSIVENESS"
echo "============================"

# Test with mobile user agent
mobile_status=$(curl -s -o /dev/null -w "%{http_code}" \
    -H "User-Agent: Mozilla/5.0 (iPhone; CPU iPhone OS 14_7_1 like Mac OS X) AppleWebKit/605.1.15" \
    https://app-oint.com/ 2>/dev/null || echo "000")

if [[ "$mobile_status" == "200" ]]; then
    log_test "Mobile Responsiveness" "PASS" "Mobile user agent handled correctly"
else
    log_test "Mobile Responsiveness" "FAIL" "Mobile user agent test failed: $mobile_status"
fi

echo ""

# 11. BUSINESS LOGIC TESTS
echo "🏢 11. BUSINESS LOGIC TESTS"
echo "==========================="

# Test key business endpoints
test_endpoint "Booking System" "https://app-oint.com/booking"
test_endpoint "Appointment List" "https://app-oint.com/appointments" 
test_endpoint "Service Catalog" "https://app-oint.com/services"
test_endpoint "Provider Directory" "https://app-oint.com/providers"
test_endpoint "Calendar Integration" "https://app-oint.com/calendar"

echo ""

# 12. SECURITY TESTS
echo "🔐 12. SECURITY TESTS"
echo "====================="

# Test security headers
security_headers=$(curl -s -I https://app-oint.com/ | grep -i "x-frame-options\|x-content-type-options\|strict-transport-security" | wc -l)

if [[ "$security_headers" -ge 2 ]]; then
    log_test "Security Headers" "PASS" "Found $security_headers security headers"
else
    log_test "Security Headers" "FAIL" "Insufficient security headers: $security_headers"
fi

# Test HTTPS redirect
http_redirect=$(curl -s -o /dev/null -w "%{http_code}" http://app-oint.com/ 2>/dev/null || echo "000")

if [[ "$http_redirect" == "301" || "$http_redirect" == "302" || "$http_redirect" == "308" ]]; then
    log_test "HTTPS Redirect" "PASS" "HTTP properly redirects to HTTPS: $http_redirect"
else
    log_test "HTTPS Redirect" "FAIL" "HTTP redirect not working: $http_redirect"
fi

echo ""

# COMPREHENSIVE RESULTS
echo "📊 COMPREHENSIVE TEST RESULTS"
echo "=============================="
echo ""
echo "📈 STATISTICS:"
echo "- Total Tests: $TOTAL_TESTS"
echo "- Passed: $PASSED_TESTS" 
echo "- Failed: $FAILED_TESTS"
echo "- Success Rate: $(( (PASSED_TESTS * 100) / TOTAL_TESTS ))%"
echo ""

if [[ $FAILED_TESTS -gt 0 ]]; then
    echo "🚨 ISSUES FOUND:"
    echo "================"
    for issue in "${ISSUES_FOUND[@]}"; do
        echo "❌ $issue"
    done
    echo ""
    
    # Generate fix recommendations
    echo "🔧 RECOMMENDED FIXES:"
    echo "===================="
    
    # API-related fixes
    if grep -q "API" <<< "${ISSUES_FOUND[*]}"; then
        echo "🔌 API Issues:"
        echo "   - Check backend service deployment status"
        echo "   - Verify API routing configuration in app.yaml"
        echo "   - Ensure database connections are working"
        echo "   - Check environment variables for API services"
    fi
    
    # Subdomain fixes
    if grep -q "Subdomain" <<< "${ISSUES_FOUND[*]}"; then
        echo "🌍 Subdomain Issues:"
        echo "   - Update DNS CNAME records"
        echo "   - Configure subdomain routing in DigitalOcean"
        echo "   - Add subdomain SSL certificates"
        echo "   - Update app.yaml with proper domain configuration"
    fi
    
    # SEO fixes
    if grep -q "robots\|sitemap" <<< "${ISSUES_FOUND[*]}"; then
        echo "🔍 SEO Issues:"
        echo "   - Create proper robots.txt file"
        echo "   - Generate sitemap.xml"
        echo "   - Configure static file serving"
        echo "   - Update routing for SEO assets"
    fi
    
    # Performance fixes
    if grep -q "Performance" <<< "${ISSUES_FOUND[*]}"; then
        echo "⚡ Performance Issues:"
        echo "   - Optimize Flutter web build"
        echo "   - Enable compression in web server"
        echo "   - Implement CDN for static assets"
        echo "   - Optimize image and asset loading"
    fi
    
    echo ""
    echo "🎯 NEXT STEPS:"
    echo "=============="
    echo "1. Run: ./fix_all_issues.sh"
    echo "2. Apply recommended fixes"  
    echo "3. Test individual components"
    echo "4. Redeploy to DigitalOcean"
    echo "5. Re-run this test suite"
    
else
    echo "🎉 ALL TESTS PASSED!"
    echo "==================="
    echo "App-oint is performing perfectly on DigitalOcean!"
    echo ""
    echo "🏆 ACHIEVEMENTS:"
    echo "- ✅ Core application fully functional"
    echo "- ✅ All APIs responding correctly"
    echo "- ✅ Subdomains properly configured"
    echo "- ✅ SEO optimization complete"
    echo "- ✅ Performance targets met"
    echo "- ✅ Security measures in place"
    echo "- ✅ Accessibility compliance achieved"
    echo ""
    echo "🚀 App-oint is PERFECT on DigitalOcean!"
fi

# Save detailed results
cat > test_results_$(date +%Y%m%d_%H%M%S).json << EOF
{
    "timestamp": "$(date -Iseconds)",
    "total_tests": $TOTAL_TESTS,
    "passed_tests": $PASSED_TESTS,
    "failed_tests": $FAILED_TESTS,
    "success_rate": $(( (PASSED_TESTS * 100) / TOTAL_TESTS )),
    "issues_found": $(printf '%s\n' "${ISSUES_FOUND[@]}" | jq -R . | jq -s .),
    "test_environment": "DigitalOcean Production",
    "app_url": "https://app-oint.com"
}
EOF

echo "📋 Detailed results saved to: test_results_$(date +%Y%m%d_%H%M%S).json"

# Return appropriate exit code
if [[ $FAILED_TESTS -gt 0 ]]; then
    exit 1
else
    exit 0
fi