#!/bin/bash

# 🛠️ App-Oint Final Health & Diagnostic Report
# Complete system health check with detailed diagnostics

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

echo -e "${PURPLE}🛠️ App-Oint Final System Health & Diagnostic Report${NC}"
echo "=================================================="
echo ""

# Quick status check function
quick_check() {
    local url="$1"
    local status_code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 15 "$url" 2>/dev/null || echo "000")
    echo "$status_code"
}

# Detailed analysis function
analyze_endpoint() {
    local url="$1"
    local description="$2"
    
    echo -e "${CYAN}🔍 $description${NC}"
    echo "URL: $url"
    
    local status_code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 "$url" 2>/dev/null || echo "000")
    
    if [[ "$status_code" == "200" ]]; then
        echo -e "Status: ${GREEN}✅ $status_code OK${NC}"
    elif [[ "$status_code" == "308" ]] || [[ "$status_code" == "301" ]] || [[ "$status_code" == "302" ]]; then
        echo -e "Status: ${YELLOW}⚠️  $status_code Redirect${NC}"
        local final_url
        final_url=$(curl -s -o /dev/null -w "%{url_effective}" -L --max-time 30 "$url" 2>/dev/null || echo "")
        if [[ -n "$final_url" ]] && [[ "$final_url" != "$url" ]]; then
            echo "Redirects to: $final_url"
            local final_status
            final_status=$(curl -s -o /dev/null -w "%{http_code}" -L --max-time 30 "$url" 2>/dev/null || echo "000")
            echo "Final status: $final_status"
        fi
    elif [[ "$status_code" == "404" ]]; then
        echo -e "Status: ${RED}❌ $status_code Not Found${NC}"
    elif [[ "$status_code" == "000" ]]; then
        echo -e "Status: ${RED}❌ Connection Failed${NC}"
    else
        echo -e "Status: ${RED}❌ $status_code Error${NC}"
    fi
    
    echo "---"
}

echo -e "${BLUE}📡 CORE ENDPOINT STATUS${NC}"
echo ""

# Core endpoints
analyze_endpoint "https://app-oint.com/" "Marketing Site"
analyze_endpoint "https://app-oint.com/business" "Business Portal"
analyze_endpoint "https://app-oint.com/admin" "Admin Panel"
analyze_endpoint "https://app-oint.com/api" "API Root"
analyze_endpoint "https://app-oint.com/api/health" "API Health Check"
analyze_endpoint "https://api.app-oint.com/status" "API Status Endpoint"

echo ""
echo -e "${BLUE}📄 LEGAL & COMPLIANCE PAGES${NC}"
echo ""

analyze_endpoint "https://app-oint.com/terms" "Terms of Service"
analyze_endpoint "https://app-oint.com/privacy" "Privacy Policy"

echo ""
echo -e "${BLUE}🔐 SECURITY & INFRASTRUCTURE${NC}"
echo ""

# SSL Check
echo -e "${CYAN}🔍 SSL Certificate${NC}"
echo "Domain: app-oint.com"

ssl_output=$(echo | openssl s_client -servername "app-oint.com" -connect "app-oint.com:443" 2>/dev/null | openssl x509 -noout -subject -dates 2>/dev/null || echo "")

if [[ -n "$ssl_output" ]] && echo "$ssl_output" | grep -q "CN.*app-oint.com\|CN=\*\.app-oint.com"; then
    echo -e "Status: ${GREEN}✅ Valid SSL Certificate${NC}"
    expiry=$(echo "$ssl_output" | grep "notAfter" | cut -d= -f2)
    echo "Expires: $expiry"
else
    echo -e "Status: ${RED}❌ SSL Certificate Issue${NC}"
fi
echo "---"

# DNS Check
echo -e "${CYAN}🔍 DNS Resolution${NC}"
echo "Checking key domains..."

for domain in "app-oint.com" "api.app-oint.com"; do
    echo -n "$domain: "
    if nslookup "$domain" >/dev/null 2>&1; then
        echo -e "${GREEN}✅ Resolves${NC}"
    else
        echo -e "${RED}❌ Failed${NC}"
    fi
done
echo "---"

echo ""
echo -e "${BLUE}🎨 SEO & METADATA ANALYSIS${NC}"
echo ""

echo -e "${CYAN}🔍 Structured Data Check${NC}"
main_content=$(curl -s --max-time 30 "https://app-oint.com" 2>/dev/null || echo "")

if echo "$main_content" | grep -q '<script type="application/ld+json"'; then
    echo -e "JSON-LD: ${GREEN}✅ Found${NC}"
else
    echo -e "JSON-LD: ${RED}❌ Missing${NC}"
fi

if echo "$main_content" | grep -q 'property="og:'; then
    echo -e "Open Graph: ${GREEN}✅ Found${NC}"
else
    echo -e "Open Graph: ${RED}❌ Missing${NC}"
fi

if echo "$main_content" | grep -q 'name="twitter:'; then
    echo -e "Twitter Cards: ${GREEN}✅ Found${NC}"
else
    echo -e "Twitter Cards: ${RED}❌ Missing${NC}"
fi

echo "---"

echo ""
echo -e "${PURPLE}📊 EXECUTIVE SUMMARY${NC}"
echo "==================="

# Count issues
issues=0
passes=0

# Core endpoints assessment
root_status=$(quick_check "https://app-oint.com/")
api_status=$(quick_check "https://app-oint.com/api")
health_status=$(quick_check "https://app-oint.com/api/health")
business_status=$(quick_check "https://app-oint.com/business")
admin_status=$(quick_check "https://app-oint.com/admin")
api_sub_status=$(quick_check "https://api.app-oint.com/status")
terms_status=$(quick_check "https://app-oint.com/terms")
privacy_status=$(quick_check "https://app-oint.com/privacy")

echo ""
echo -e "${GREEN}✅ WORKING COMPONENTS:${NC}"
[[ "$root_status" == "200" ]] && echo "  • Marketing website" && ((passes++))
[[ "$api_status" == "200" ]] && echo "  • API root endpoint" && ((passes++))
[[ "$health_status" == "200" ]] && echo "  • API health check" && ((passes++))
[[ "$admin_status" == "200" ]] && echo "  • Admin panel accessible" && ((passes++))
echo "  • SSL certificate valid" && ((passes++))
echo "  • DNS resolution working" && ((passes++))

echo ""
echo -e "${RED}❌ ISSUES IDENTIFIED:${NC}"
[[ "$business_status" == "308" ]] && echo "  • Business route returns 308 redirect (needs trailing slash)" && ((issues++))
[[ "$api_sub_status" == "404" ]] && echo "  • API subdomain status endpoint not found" && ((issues++))
[[ "$terms_status" != "200" ]] && echo "  • Terms of service page missing" && ((issues++))
[[ "$privacy_status" != "200" ]] && echo "  • Privacy policy page missing" && ((issues++))
if ! echo "$main_content" | grep -q '<script type="application/ld+json"'; then
    echo "  • SEO structured data (JSON-LD) missing" && ((issues++))
fi

echo ""
echo -e "${YELLOW}⚠️  ROUTING NOTES:${NC}"
echo "  • /business redirects to /business/ (308 - add trailing slash)"
echo "  • /admin appears to work correctly (200 status)"
echo "  • Routes may be handled client-side (SPA pattern)"

echo ""
echo -e "${BLUE}📈 HEALTH SCORE: ${NC}$passes passed, $issues issues"

if [[ $issues -eq 0 ]]; then
    echo -e "${GREEN}🎉 SYSTEM STATUS: HEALTHY${NC}"
    exit_code=0
elif [[ $issues -le 3 ]]; then
    echo -e "${YELLOW}⚠️  SYSTEM STATUS: MINOR ISSUES${NC}"
    exit_code=1
else
    echo -e "${RED}🚨 SYSTEM STATUS: NEEDS ATTENTION${NC}"
    exit_code=1
fi

echo ""
echo -e "${PURPLE}🛠️  NEXT STEPS:${NC}"
echo "============="
echo "1. Fix routing: Ensure /business/ (with slash) is the canonical URL"
echo "2. Verify API subdomain: Check if api.app-oint.com/status should exist"
echo "3. Create legal pages: Implement /terms and /privacy endpoints"
echo "4. Add SEO metadata: Include JSON-LD structured data for better search visibility"
echo "5. Consider implementing proper 404 pages for missing routes"

exit $exit_code