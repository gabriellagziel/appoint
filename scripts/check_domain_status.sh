#!/bin/bash

echo "🌐 Domain Status Checker for app-oint.com"
echo "==========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
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
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Test URLs
URLS=(
    "https://app-oint.com"
    "https://www.app-oint.com"
    "http://app-oint.com"
    "https://app-oint-core.firebaseapp.com"
)

echo ""
print_info "Testing multiple URLs..."

for URL in "${URLS[@]}"; do
    echo ""
    echo "Testing: $URL"
    
    # Get HTTP status code
    status=$(curl -o /dev/null -s -w "%{http_code}\n" --connect-timeout 10 --max-time 30 "$URL" 2>/dev/null)
    
    # Get redirect location if any
    redirect=$(curl -s -I --connect-timeout 10 --max-time 30 "$URL" 2>/dev/null | grep -i "location:" | cut -d' ' -f2- | tr -d '\r\n')
    
    if [ "$status" == "200" ]; then
        print_status "LIVE: $URL (HTTP $status)"
    elif [ "$status" == "301" ] || [ "$status" == "302" ]; then
        print_warning "REDIRECT: $URL (HTTP $status) → $redirect"
    elif [ "$status" == "000" ] || [ -z "$status" ]; then
        print_error "NO RESPONSE: $URL (Connection failed)"
    else
        print_error "ERROR: $URL (HTTP $status)"
    fi
done

echo ""
echo "🔍 DNS LOOKUP TEST"
echo "=================="

# Test DNS resolution
for domain in "app-oint.com" "www.app-oint.com"; do
    echo ""
    echo "Testing DNS for: $domain"
    
    # Try to resolve IP
    ip=$(nslookup "$domain" 2>/dev/null | grep "Address:" | tail -1 | awk '{print $2}')
    
    if [ -n "$ip" ] && [ "$ip" != "" ]; then
        print_status "DNS RESOLVED: $domain → $ip"
    else
        print_error "DNS FAILED: $domain (No IP found)"
    fi
done

echo ""
echo "📊 SUMMARY"
echo "==========="
print_info "If you see HTTP 200 for https://app-oint.com, your deployment is successful!"
print_info "If you see connection errors, check:"
print_info "1. DNS records are properly configured"
print_info "2. Firebase hosting is deployed"
print_info "3. Custom domain is connected in Firebase Console"

echo ""
print_info "Expected Firebase hosting URL: https://app-oint-core.firebaseapp.com"