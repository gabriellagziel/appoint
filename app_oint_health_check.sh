#!/bin/bash

# 🛠️ App-Oint Full System Health & Deployment Check
# This script performs comprehensive health checks on the App-Oint system

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Arrays to store issues
ISSUES=()
PASSED_CHECKS=()

# Function to report issues
report() {
    local message="$1"
    echo -e "${RED}❌ ISSUE: $message${NC}"
    ISSUES+=("$message")
}

# Function to log passed checks
log_pass() {
    local message="$1"
    echo -e "${GREEN}✅ PASS: $message${NC}"
    PASSED_CHECKS+=("$message")
}

# Function to check HTTP response
check_http() {
    local url="$1"
    local expected_code="${2:-200}"
    
    echo -e "${BLUE}🔍 Checking HTTP: $url${NC}"
    
    # Get HTTP status code
    local status_code
    status_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 30 "$url" 2>/dev/null || echo "000")
    
    if [[ "$status_code" == "$expected_code" ]]; then
        log_pass "HTTP $status_code for $url"
        return 0
    else
        return 1
    fi
}

# Function to check SSL certificate
ssl_check() {
    local domain="$1"
    
    echo -e "${BLUE}🔍 Checking SSL: $domain${NC}"
    
    # Check SSL certificate validity and CN
    local ssl_output
    ssl_output=$(echo | openssl s_client -servername "$domain" -connect "$domain:443" 2>/dev/null | openssl x509 -noout -subject -dates 2>/dev/null || echo "")
    
    if [[ -n "$ssl_output" ]] && echo "$ssl_output" | grep -q "CN.*$domain\|CN=\*\.$domain"; then
        # Check if certificate is not expired
        local not_after
        not_after=$(echo "$ssl_output" | grep "notAfter" | cut -d= -f2)
        if [[ -n "$not_after" ]]; then
            local expiry_epoch
            expiry_epoch=$(date -d "$not_after" +%s 2>/dev/null || echo "0")
            local current_epoch
            current_epoch=$(date +%s)
            
            if [[ "$expiry_epoch" -gt "$current_epoch" ]]; then
                log_pass "SSL certificate valid for $domain"
                return 0
            fi
        fi
    fi
    
    return 1
}

# Function to check DNS resolution
dns_check() {
    local domain="$1"
    
    echo -e "${BLUE}🔍 Checking DNS: $domain${NC}"
    
    # Check if domain resolves
    if nslookup "$domain" >/dev/null 2>&1 || dig "$domain" +short | grep -q .; then
        log_pass "DNS resolution for $domain"
        return 0
    else
        return 1
    fi
}

# Function to check if content contains specific text
check_contains() {
    local url="$1"
    local search_text="$2"
    
    echo -e "${BLUE}🔍 Checking content: $url for '$search_text'${NC}"
    
    # Get page content and search for text
    local content
    content=$(curl -s --max-time 30 "$url" 2>/dev/null || echo "")
    
    if echo "$content" | grep -q "$search_text"; then
        log_pass "Content check passed for $url"
        return 0
    else
        return 1
    fi
}

# Function to complete the report
report_complete() {
    local message="$1"
    
    echo -e "\n${BLUE}📊 HEALTH CHECK SUMMARY${NC}"
    echo "=========================="
    
    echo -e "\n${GREEN}✅ PASSED CHECKS (${#PASSED_CHECKS[@]}):${NC}"
    for check in "${PASSED_CHECKS[@]}"; do
        echo "  ✓ $check"
    done
    
    if [[ ${#ISSUES[@]} -eq 0 ]]; then
        echo -e "\n${GREEN}🎉 ALL CHECKS PASSED! System is healthy.${NC}"
        exit 0
    else
        echo -e "\n${RED}❌ ISSUES FOUND (${#ISSUES[@]}):${NC}"
        for issue in "${ISSUES[@]}"; do
            echo "  ✗ $issue"
        done
        echo -e "\n${YELLOW}$message${NC}"
        exit 1
    fi
}

echo -e "${BLUE}🚀 Starting App-Oint Full System Health Check...${NC}\n"

# 1. Check core endpoints HTTP response
echo -e "${YELLOW}📡 CHECKING CORE ENDPOINTS${NC}"
check_http https://app-oint.com/ || report "Marketing site unreachable or not 200"
check_http https://app-oint.com/business || report "Business route unreachable or not 200"
check_http https://app-oint.com/admin || report "Admin route unreachable or not 200"
check_http https://app-oint.com/api || report "API root unreachable or not 200"
check_http https://app-oint.com/api/health || report "API health endpoint not returning 200"
check_http https://api.app-oint.com/status || report "API status endpoint not returning 200"

echo ""

# 2. Verify SSL certificate for app-oint.com
echo -e "${YELLOW}🔐 CHECKING SSL CERTIFICATES${NC}"
ssl_check app-oint.com || report "SSL invalid or CN mismatch"

echo ""

# 3. DNS resolution check for api.app-oint.com and app-oint.com
echo -e "${YELLOW}🌐 CHECKING DNS RESOLUTION${NC}"
dns_check api.app-oint.com || report "api.app-oint.com DNS not resolving"
dns_check app-oint.com || report "app-oint.com DNS not resolving"

echo ""

# 4. Routing & redirect check
echo -e "${YELLOW}🔄 CHECKING ROUTING & REDIRECTS${NC}"
echo -e "${BLUE}🔍 Checking business route HTTP status${NC}"
if curl -I https://app-oint.com/business --max-time 30 2>/dev/null | grep -q "HTTP"; then
    log_pass "Business route responded with valid HTTP status"
else
    report "Business route did not respond with valid HTTP status"
fi

echo -e "${BLUE}🔍 Checking admin route HTTP status${NC}"
if curl -I https://app-oint.com/admin --max-time 30 2>/dev/null | grep -q "HTTP"; then
    log_pass "Admin route responded with valid HTTP status"
else
    report "Admin route did not respond with valid HTTP status"
fi

echo ""

# 5. Verify presence of legal & SEO pages
echo -e "${YELLOW}📄 CHECKING LEGAL & SEO PAGES${NC}"
check_http https://app-oint.com/terms || report "Terms page missing or not 200"
check_http https://app-oint.com/privacy || report "Privacy page missing or not 200"
check_contains https://app-oint.com "<script type=\"application/ld+json\"" || report "SEO structured data missing"

echo ""

# End
report_complete "App-Oint system check complete. See above for flagged issues."