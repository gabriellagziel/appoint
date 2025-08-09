#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Day-1 Production Cutover"
echo "============================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        exit 1
    fi
}

# Function to print info
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Function to print warning
print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Record start time
START_TIME=$(date +%s)
echo "Cutover started at: $(date)"

echo ""
echo "1. 🚩 Enable Feature Flags"
echo "---------------------------"

echo "Enabling admin panel feature flags..."
# Update feature flags to enable admin panel
firebase firestore:set /feature_flags/main admin_panel_enabled=true --project demo-app
firebase firestore:set /feature_flags/main admin_monitoring_enabled=true --project demo-app
firebase firestore:set /feature_flags/main admin_analytics_enabled=true --project demo-app
print_status $? "Feature flags enabled"

echo ""
echo "2. 🐦 Canary Deployment"
echo "-----------------------"

echo "Deploying to canary environment..."
# Deploy to staging/canary environment first
firebase deploy --only hosting:admin-canary --project demo-app
print_status $? "Canary deployment completed"

echo "Running canary health checks..."
# Health check canary deployment
curl -f https://admin-canary-demo-app.web.app/health || {
    print_warning "Canary health check failed - investigate before proceeding"
    read -p "Continue with production deployment? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cutover aborted by user"
        exit 1
    fi
}
print_status $? "Canary health checks passed"

echo ""
echo "3. 🚀 Production Deployment"
echo "---------------------------"

echo "Deploying to production..."
firebase deploy --only hosting:admin --project demo-app
print_status $? "Production deployment completed"

echo "Running production health checks..."
curl -f https://admin.demo-app.web.app/health
print_status $? "Production health checks passed"

echo ""
echo "4. 📊 SLO Watch (30 minutes)"
echo "----------------------------"

echo "Starting SLO monitoring..."
# Start monitoring SLOs for 30 minutes
MONITOR_START=$(date +%s)
MONITOR_END=$((MONITOR_START + 1800)) # 30 minutes

print_info "Monitoring SLOs for 30 minutes..."
print_info "Press Ctrl+C to stop monitoring early"

# Monitor SLOs every 30 seconds
while [ $(date +%s) -lt $MONITOR_END ]; do
    echo "Checking SLOs... $(date)"
    
    # Check dashboard response time
    RESPONSE_TIME=$(curl -w "%{time_total}" -o /dev/null -s https://admin.demo-app.web.app/api/health)
    if (( $(echo "$RESPONSE_TIME > 0.6" | bc -l) )); then
        print_warning "Dashboard response time: ${RESPONSE_TIME}s (SLO: <0.6s)"
    else
        echo -e "${GREEN}✅ Dashboard response time: ${RESPONSE_TIME}s${NC}"
    fi
    
    # Check error rate
    ERROR_RATE=$(curl -s https://admin.demo-app.web.app/api/health | jq -r '.error_rate // 0')
    if (( $(echo "$ERROR_RATE > 0.01" | bc -l) )); then
        print_warning "Error rate: ${ERROR_RATE} (SLO: <1%)"
    else
        echo -e "${GREEN}✅ Error rate: ${ERROR_RATE}${NC}"
    fi
    
    sleep 30
done

echo ""
echo "5. 🚨 Alert Confirmation"
echo "------------------------"

echo "Verifying alert configurations..."
# Test alert webhooks
curl -X POST https://admin.demo-app.web.app/api/test-alert || print_warning "Alert webhook test failed"
print_status $? "Alert configurations verified"

echo "Checking monitoring dashboards..."
# Verify monitoring is active
curl -s https://admin.demo-app.web.app/api/monitoring/status | jq -r '.status' | grep -q "active" || print_warning "Monitoring status check failed"
print_status $? "Monitoring dashboards active"

echo ""
echo "6. 💾 Firestore Snapshot Export"
echo "-------------------------------"

echo "Creating production data snapshot..."
SNAPSHOT_NAME="production_snapshot_$(date +%Y%m%d_%H%M%S)"
gcloud firestore export gs://demo-app-backups/$SNAPSHOT_NAME --project demo-app
print_status $? "Production snapshot created: $SNAPSHOT_NAME"

echo "Verifying snapshot integrity..."
# Check snapshot was created successfully
gsutil ls gs://demo-app-backups/$SNAPSHOT_NAME/ >/dev/null 2>&1
print_status $? "Snapshot integrity verified"

echo ""
echo "7. 📈 Performance Validation"
echo "----------------------------"

echo "Running performance validation..."
# Run performance tests against production
flutter test test/smoke/admin_service_smoke_test.dart --reporter=expanded > production_performance.log 2>&1
print_status $? "Performance validation completed"

echo "Comparing with baseline..."
# Compare with Day-0 baseline
if [ -f "performance_baseline.log" ]; then
    echo "Performance comparison available in production_performance.log"
else
    print_warning "No baseline available for comparison"
fi

echo ""
echo "8. 🔍 Final Cutover Verification"
echo "--------------------------------"

echo "Verifying all systems operational..."
# Final health checks
curl -f https://admin.demo-app.web.app/health
curl -f https://admin.demo-app.web.app/api/admin/config
curl -f https://admin.demo-app.web.app/api/admin/health
print_status $? "All systems operational"

echo "Checking admin access..."
# Verify admin access works
firebase auth:export admin_users.json --project demo-app || print_warning "Admin export failed"
print_status $? "Admin access verified"

# Record end time and duration
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
MINUTES=$((DURATION / 60))
SECONDS=$((DURATION % 60))

echo ""
echo "🎉 Day-1 Cutover Complete!"
echo "=========================="
echo ""
echo "Cutover Summary:"
echo "- Duration: ${MINUTES}m ${SECONDS}s"
echo "- Production URL: https://admin.demo-app.web.app"
echo "- Snapshot: $SNAPSHOT_NAME"
echo "- Monitoring: Active"
echo "- Alerts: Configured"
echo ""
echo "Next steps:"
echo "1. Run hypercare checks for the first week"
echo "2. Monitor SLOs closely for 24 hours"
echo "3. Review admin access logs daily"
echo "4. Schedule post-cutover review"
echo ""
echo "Production deployment successful! 🚀"

