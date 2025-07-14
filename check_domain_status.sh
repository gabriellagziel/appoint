#!/bin/bash

echo "🔍 App-oint.com Domain Status Check"
echo "===================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() { echo -e "${GREEN}✅ $1${NC}"; }
print_error() { echo -e "${RED}❌ $1${NC}"; }
print_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }

echo ""
echo "📊 DNS Records:"
echo "IP Address: $(dig +short app-oint.com)"
echo "Nameservers:"
dig +short NS app-oint.com | head -3

echo ""
echo "🌐 HTTP Response:"
echo "HTTP Status: $(curl -s -I app-oint.com 2>/dev/null | head -1 || echo 'Connection failed')"

echo ""
echo "🔒 HTTPS Response:"
https_status=$(curl -s -I https://app-oint.com 2>/dev/null | head -1 || echo 'SSL/Connection failed')
echo "HTTPS Status: $https_status"

echo ""
echo "🎯 Firebase Status:"
firebase_status=$(curl -s -I https://app-oint-core.firebaseapp.com 2>/dev/null | head -1 || echo 'Firebase connection failed')
echo "Firebase Hosting: $https_status"

echo ""
if [[ "$https_status" == *"200"* ]]; then
    print_status "Domain is working correctly!"
elif [[ "$https_status" == *"409"* ]]; then
    print_warning "Domain has DNS conflict - needs proper DNS records"
else
    print_error "Domain not accessible - check DNS configuration"
fi

echo ""
echo "🔧 Next Steps:"
if [[ "$https_status" != *"200"* ]]; then
    echo "1. Run: firebase login"
    echo "2. Run: ./deploy_fix.sh"
    echo "3. Update DNS records in DigitalOcean"
    echo "4. Wait 5-60 minutes for DNS propagation"
    echo "5. Run this script again to check status"
else
    echo "✅ All working! No action needed."
fi