#!/usr/bin/env bash
# Monitor personal.app-oint.com SSL status
# Run this while you complete Firebase setup

set -Eeuo pipefail

echo "🔍 Monitoring personal.app-oint.com SSL status..."
echo "Complete Firebase setup while this runs..."
echo ""

while true; do
    echo "--- $(date) ---"
    
    # Check DNS
    echo "DNS: $(dig +short personal.app-oint.com CNAME 2>/dev/null || echo 'FAILED')"
    
    # Check SSL connection
    if curl -sS -I -L --max-time 10 https://personal.app-oint.com >/dev/null 2>&1; then
        echo "SSL: ✅ WORKING - Certificate is active!"
        echo ""
        echo "🎉 SUCCESS! personal.app-oint.com is now working with SSL!"
        echo "Run: ./health_check.sh to verify all domains"
        break
    else
        echo "SSL: ❌ Still failing - Certificate not yet active"
        echo "Continue with Firebase Console setup..."
    fi
    
    echo ""
    echo "Waiting 30 seconds... (Press Ctrl+C to stop)"
    sleep 30
done
