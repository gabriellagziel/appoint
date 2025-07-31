#!/bin/bash

# Test Metrics Endpoint Locally
# This script tests the /metrics endpoint implementation

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

# Test local metrics endpoint
test_local_metrics() {
    log "=== Testing Local Metrics Endpoint ==="
    
    # Check if Node.js is running locally
    if curl -s http://localhost:3000/metrics > /dev/null 2>&1; then
        log "✅ Local metrics endpoint is accessible"
        
        # Get metrics response
        METRICS_RESPONSE=$(curl -s http://localhost:3000/metrics)
        
        # Check for Prometheus metrics
        if echo "$METRICS_RESPONSE" | grep -q "http_request_duration_ms"; then
            log "✅ Prometheus metrics format detected"
        else
            warn "⚠️ Prometheus metrics format not detected"
        fi
        
        # Check for Node.js metrics
        if echo "$METRICS_RESPONSE" | grep -q "nodejs_"; then
            log "✅ Default Node.js metrics detected"
        else
            warn "⚠️ Default Node.js metrics not detected"
        fi
        
        # Display sample metrics
        echo ""
        info "Sample metrics output:"
        echo "$METRICS_RESPONSE" | head -20
        echo "..."
        
    else
        error "❌ Local metrics endpoint not accessible"
        info "Make sure the Node.js server is running on localhost:3000"
        return 1
    fi
}

# Test production metrics endpoint
test_production_metrics() {
    log "=== Testing Production Metrics Endpoint ==="
    
    APP_URL="https://app-oint-marketing-cqznb.ondigitalocean.app"
    
    # Test production metrics endpoint
    if curl -s -f "$APP_URL/metrics" > /dev/null 2>&1; then
        log "✅ Production metrics endpoint is accessible"
        
        # Get metrics response
        METRICS_RESPONSE=$(curl -s "$APP_URL/metrics")
        
        # Check for Prometheus metrics
        if echo "$METRICS_RESPONSE" | grep -q "http_request_duration_ms"; then
            log "✅ Prometheus metrics format detected"
        else
            warn "⚠️ Prometheus metrics format not detected"
        fi
        
        # Display sample metrics
        echo ""
        info "Sample production metrics output:"
        echo "$METRICS_RESPONSE" | head -20
        echo "..."
        
    else
        warn "⚠️ Production metrics endpoint not accessible"
        info "This is expected if the metrics endpoint hasn't been deployed yet"
    fi
}

# Main execution
main() {
    log "=== Metrics Endpoint Testing ==="
    
    test_local_metrics
    test_production_metrics
    
    log "=== Testing Completed ==="
    log "If local test passed, the metrics implementation is working correctly"
    log "Deploy the updated functions to make the production endpoint work"
}

# Run main function
main "$@" 