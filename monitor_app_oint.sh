#!/bin/bash

# 🔍 App-Oint Simple Monitoring Script
# Quick health check for ongoing monitoring

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "🛠️ App-Oint Quick Health Check - $(date)"
echo "========================================"

# Quick check function
check() {
    local url="$1"
    local name="$2"
    local status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null || echo "000")
    
    printf "%-25s " "$name:"
    if [[ "$status" == "200" ]]; then
        echo -e "${GREEN}✅ OK ($status)${NC}"
        return 0
    elif [[ "$status" == "308" ]] || [[ "$status" == "301" ]]; then
        echo -e "${YELLOW}⚠️  REDIRECT ($status)${NC}"
        return 1
    else
        echo -e "${RED}❌ FAIL ($status)${NC}"
        return 1
    fi
}

# Core checks
check "https://app-oint.com/" "Marketing Site"
check "https://app-oint.com/admin" "Admin Panel"
check "https://app-oint.com/api" "API Root"
check "https://app-oint.com/api/health" "API Health"

echo ""
echo "🔍 Known Issues to Track:"
check "https://app-oint.com/business" "Business Route"
check "https://api.app-oint.com/status" "API Status"
check "https://app-oint.com/terms" "Terms Page"
check "https://app-oint.com/privacy" "Privacy Page"

echo ""
echo "📊 Monitoring complete - $(date)"