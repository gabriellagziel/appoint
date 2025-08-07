#!/bin/bash

# Health monitoring for App-oint
ENDPOINTS=(
    "https://app-oint.com/"
    "https://app-oint.com/admin"
    "https://app-oint.com/api/health"
    "https://app-oint.com/api/status"
)

for endpoint in "${ENDPOINTS[@]}"; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint" || echo "000")
    if [[ "$status" == "200" ]]; then
        echo "✅ $endpoint: Healthy ($status)"
    else
        echo "❌ $endpoint: Unhealthy ($status)"
        # Add alerting logic here
    fi
done
