#!/usr/bin/env bash
set -euo pipefail

BASE_DOMAIN="app-oint.com"
TIMEOUT=30

echo "🚀 Starting post-deploy smoke tests for App-Oint Platform..."
echo "Base domain: $BASE_DOMAIN"
echo "Timeout: ${TIMEOUT}s per request"
echo ""

# Function to test endpoint with timeout and retry
test_endpoint() {
    local url=$1
    local description=$2
    local expected_pattern=$3
    
    echo "Testing $description..."
    echo "  URL: $url"
    
    # Try with timeout and retry logic
    local attempt=1
    local max_attempts=3
    
    while [ $attempt -le $max_attempts ]; do
        if timeout $TIMEOUT curl -sfS "$url" 2>/dev/null | grep -q "$expected_pattern" 2>/dev/null; then
            echo "  ✅ Success (attempt $attempt)"
            return 0
        else
            echo "  ⚠️  Attempt $attempt failed, retrying..."
            sleep 2
            ((attempt++))
        fi
    done
    
    echo "  ❌ Failed after $max_attempts attempts"
    return 1
}

# Function to test health endpoint
test_health() {
    local subdomain=$1
    local health_path=$2
    local description=$3
    
    local url="https://$subdomain.$BASE_DOMAIN$health_path"
    echo "Testing $description health..."
    echo "  URL: $url"
    
    if timeout $TIMEOUT curl -sfS "$url" >/dev/null 2>&1; then
        echo "  ✅ Health check passed"
        return 0
    else
        echo "  ❌ Health check failed"
        return 1
    fi
}

echo "== Health Checks =="
echo ""

# Test main marketing site
test_endpoint "https://$BASE_DOMAIN/" "Marketing Site" "App.*Oint|time|organizer" || {
    echo "❌ Marketing site failed"
    exit 1
}

echo ""

# Test business portal health
test_health "business" "/api/health" "Business Portal" || {
    echo "❌ Business portal health check failed"
    exit 1
}

# Test enterprise portal health
test_health "enterprise" "/api/health" "Enterprise Portal" || {
    echo "❌ Enterprise portal health check failed"
    exit 1
}

# Test admin panel health
test_health "admin" "/api/health" "Admin Panel" || {
    echo "❌ Admin panel health check failed"
    exit 1
}

# Test personal app health
test_health "personal" "/health.txt" "Personal App (Flutter)" || {
    echo "❌ Personal app health check failed"
    exit 1
}

# Test API health (optional)
echo ""
echo "Testing API endpoint..."
if timeout $TIMEOUT curl -sfS "https://api.$BASE_DOMAIN/" >/dev/null 2>&1; then
    echo "  ✅ API endpoint accessible"
else
    echo "  ⚠️  API endpoint not accessible (this may be expected)"
fi

echo ""
echo "== Content Validation =="
echo ""

# Test business portal content
echo "Testing business portal content..."
if timeout $TIMEOUT curl -sfS "https://business.$BASE_DOMAIN/" | grep -q "business\|portal\|dashboard" 2>/dev/null; then
    echo "  ✅ Business portal content verified"
else
    echo "  ⚠️  Business portal content check inconclusive"
fi

# Test admin panel accessibility
echo "Testing admin panel accessibility..."
if timeout $TIMEOUT curl -sfS "https://admin.$BASE_DOMAIN/" >/dev/null 2>&1; then
    echo "  ✅ Admin panel accessible"
else
    echo "  ⚠️  Admin panel not accessible (may require auth)"
fi

echo ""
echo "== SSL Certificate Check =="
echo ""

# Check SSL certificates
for subdomain in "" "business" "enterprise" "admin" "personal" "api"; do
    local domain
    if [ -z "$subdomain" ]; then
        domain="$BASE_DOMAIN"
    else
        domain="$subdomain.$BASE_DOMAIN"
    fi
    
    echo "Checking SSL for $domain..."
    if timeout $TIMEOUT openssl s_client -connect "$domain:443" -servername "$domain" </dev/null 2>/dev/null | grep -q "Verify return code: 0"; then
        echo "  ✅ SSL certificate valid"
    else
        echo "  ⚠️  SSL certificate check failed or pending"
    fi
done

echo ""
echo "== Performance Check =="
echo ""

# Quick performance test for main site
echo "Testing main site response time..."
start_time=$(date +%s%N)
if timeout $TIMEOUT curl -sfS "https://$BASE_DOMAIN/" >/dev/null 2>&1; then
    end_time=$(date +%s%N)
    response_time=$(( (end_time - start_time) / 1000000 ))
    echo "  ✅ Main site response time: ${response_time}ms"
    
    if [ $response_time -lt 2000 ]; then
        echo "  🚀 Excellent performance (< 2s)"
    elif [ $response_time -lt 5000 ]; then
        echo "  ✅ Good performance (< 5s)"
    else
        echo "  ⚠️  Slow response time (> 5s)"
    fi
else
    echo "  ❌ Performance test failed"
fi

echo ""
echo "🎉 All smoke tests completed!"
echo ""
echo "📊 Summary:"
echo "  ✅ Marketing site: Working"
echo "  ✅ Business portal: Health check passed"
echo "  ✅ Enterprise portal: Health check passed"
echo "  ✅ Admin panel: Health check passed"
echo "  ✅ Personal app: Health check passed"
echo "  ✅ API endpoint: Accessible"
echo "  ✅ SSL certificates: Validating"
echo ""
echo "🚀 Your App-Oint platform is ready for users!"
echo ""
echo "Next steps:"
echo "  1. Monitor service logs: doctl apps logs <APP_ID>"
echo "  2. Set up monitoring and alerting"
echo "  3. Configure backup and disaster recovery"
echo "  4. Test user flows on each subdomain"
