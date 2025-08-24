#!/bin/bash
echo "=== Final Production Smoke Test ==="

API_HEALTH="https://us-central1-app-oint-core.cloudfunctions.net/businessApi" \
MARKETING_URL="https://app-oint.com" \
BUSINESS_URL="https://business.app-oint.com" \
ENTERPRISE_URL="https://enterprise.app-oint.com" \
DASHBOARD_URL="https://dashboard.app-oint.com" \
bash ops/scripts/smoke_curls.sh

echo -e "\n=== Lockdown Verification ==="
bash ops/scripts/verify_lockdown.sh

echo -e "\n=== User Subdomains Test ==="
bash ops/scripts/verify_user_subdomains.sh app-oint.com

echo -e "\n🎉 If all above are ✅, you're LIVE!"
