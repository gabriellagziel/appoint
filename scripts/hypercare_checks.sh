#!/bin/bash

# Share-in-Groups Hypercare Monitoring Script
# This script monitors the Share-in-Groups feature for the first 72 hours

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ONCE_MODE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --once)
            ONCE_MODE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [--once]"
            echo "  --once    Run checks once and exit"
            echo "  --help    Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

echo "🔍 Share-in-Groups Hypercare Monitoring"
echo "======================================"

# Check if we have the necessary tools
check_dependencies() {
    print_status "Checking dependencies..."
    
    if ! command -v firebase &> /dev/null; then
        print_error "Firebase CLI not found"
        exit 1
    fi
    
    if ! command -v jq &> /dev/null; then
        print_error "jq not found (required for JSON parsing)"
        exit 1
    fi
    
    if ! command -v curl &> /dev/null; then
        print_error "curl not found"
        exit 1
    fi
    
    print_success "Dependencies check passed"
}

# Check application health
check_app_health() {
    print_status "Checking application health..."
    
    # Get Firebase project
    PROJECT_ID=$(firebase use --json | jq -r '.current')
    if [ "$PROJECT_ID" = "null" ]; then
        print_error "No Firebase project selected"
        return 1
    fi
    
    # Check if app is accessible
    APP_URL="https://$PROJECT_ID.web.app"
    if curl -f -s "$APP_URL" > /dev/null; then
        print_success "Application is accessible at $APP_URL"
    else
        print_error "Application is not accessible at $APP_URL"
        return 1
    fi
    
    # Check response time
    RESPONSE_TIME=$(curl -w "%{time_total}" -o /dev/null -s "$APP_URL")
    if (( $(echo "$RESPONSE_TIME < 1.0" | bc -l) )); then
        print_success "Response time: ${RESPONSE_TIME}s (good)"
    else
        print_warning "Response time: ${RESPONSE_TIME}s (slow)"
    fi
}

# Check Firestore rules
check_firestore_rules() {
    print_status "Checking Firestore rules..."
    
    # Check for permission denied errors
    DENIED_COUNT=$(firebase functions:log --only firestore 2>/dev/null | grep -c "PERMISSION_DENIED" || echo "0")
    
    if [ "$DENIED_COUNT" -lt 10 ]; then
        print_success "Permission denied errors: $DENIED_COUNT (acceptable)"
    else
        print_warning "Permission denied errors: $DENIED_COUNT (high)"
    fi
}

# Check rate limiting
check_rate_limiting() {
    print_status "Checking rate limiting..."
    
    # Check rate limit hits for different actions
    ACTIONS=("create_share_link" "guest_rsvp" "public_page_open" "join_group_from_share")
    
    for action in "${ACTIONS[@]}"; do
        HITS=$(firebase functions:log --only functions 2>/dev/null | grep -c "rate_limit_hit.*$action" || echo "0")
        
        if [ "$HITS" -lt 50 ]; then
            print_success "$action rate limit hits: $HITS (acceptable)"
        else
            print_warning "$action rate limit hits: $HITS (high)"
        fi
    done
}

# Check telemetry
check_telemetry() {
    print_status "Checking telemetry..."
    
    if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
        print_warning "GOOGLE_APPLICATION_CREDENTIALS not set, skipping telemetry check"
        return 0
    fi
    
    # Run telemetry verification
    if npx ts-node tools/telemetry_verify.ts > /dev/null 2>&1; then
        print_success "Telemetry verification passed"
    else
        print_error "Telemetry verification failed"
        return 1
    fi
}

# Check conversion funnel
check_conversion_funnel() {
    print_status "Checking conversion funnel..."
    
    if [ -z "$GOOGLE_APPLICATION_CREDENTIALS" ]; then
        print_warning "GOOGLE_APPLICATION_CREDENTIALS not set, skipping funnel check"
        return 0
    fi
    
    # Get analytics data for the last 24 hours
    # This is a simplified check - in production you'd query the analytics database
    print_status "Analyzing conversion funnel..."
    
    # Simulate funnel check (replace with actual analytics query)
    SHARE_LINKS_CREATED=$(curl -s "https://analytics.googleapis.com/v1beta/properties/$PROJECT_ID:runReport" \
        -H "Authorization: Bearer $(gcloud auth print-access-token)" \
        -d '{
            "dateRanges": [{"startDate": "1daysAgo", "endDate": "today"}],
            "dimensions": [{"name": "eventName"}],
            "metrics": [{"name": "eventCount"}],
            "dimensionFilter": {
                "filter": {
                    "fieldName": "eventName",
                    "stringFilter": {
                        "value": "share_link_created"
                    }
                }
            }
        }' 2>/dev/null | jq -r '.rows[0].metricValues[0].value' || echo "0")
    
    SHARE_LINKS_CLICKED=$(curl -s "https://analytics.googleapis.com/v1beta/properties/$PROJECT_ID:runReport" \
        -H "Authorization: Bearer $(gcloud auth print-access-token)" \
        -d '{
            "dateRanges": [{"startDate": "1daysAgo", "endDate": "today"}],
            "dimensions": [{"name": "eventName"}],
            "metrics": [{"name": "eventCount"}],
            "dimensionFilter": {
                "filter": {
                    "fieldName": "eventName",
                    "stringFilter": {
                        "value": "share_link_clicked"
                    }
                }
            }
        }' 2>/dev/null | jq -r '.rows[0].metricValues[0].value' || echo "0")
    
    if [ "$SHARE_LINKS_CREATED" -gt 0 ]; then
        CTR=$(echo "scale=2; $SHARE_LINKS_CLICKED * 100 / $SHARE_LINKS_CREATED" | bc)
        
        if (( $(echo "$CTR >= 10" | bc -l) )); then
            print_success "CTR: ${CTR}% (≥10% threshold met)"
        else
            print_warning "CTR: ${CTR}% (<10% threshold)"
        fi
    else
        print_warning "No share links created in last 24 hours"
    fi
}

# Check guest tokens
check_guest_tokens() {
    print_status "Checking guest tokens..."
    
    # Check for invalid/expired token errors
    INVALID_TOKENS=$(firebase functions:log --only functions 2>/dev/null | grep -c "Invalid guest token\|Guest token has expired" || echo "0")
    
    if [ "$INVALID_TOKENS" -lt 5 ]; then
        print_success "Invalid/expired tokens: $INVALID_TOKENS (acceptable)"
    else
        print_warning "Invalid/expired tokens: $INVALID_TOKENS (high)"
    fi
}

# Check performance
check_performance() {
    print_status "Checking performance..."
    
    # Check for "needs index" errors
    NEEDS_INDEX=$(firebase functions:log --only firestore 2>/dev/null | grep -c "needs index" || echo "0")
    
    if [ "$NEEDS_INDEX" -eq 0 ]; then
        print_success "No 'needs index' errors detected"
    else
        print_error "$NEEDS_INDEX 'needs index' errors detected"
        return 1
    fi
    
    # Check for slow queries
    SLOW_QUERIES=$(firebase functions:log --only firestore 2>/dev/null | grep -c "slow query" || echo "0")
    
    if [ "$SLOW_QUERIES" -eq 0 ]; then
        print_success "No slow queries detected"
    else
        print_warning "$SLOW_QUERIES slow queries detected"
    fi
}

# Check feature flags
check_feature_flags() {
    print_status "Checking feature flags..."
    
    # Check if feature flags are enabled
    FLAGS=$(firebase functions:config:get share 2>/dev/null | jq -r '.share' || echo "{}")
    
    SHARE_LINKS_ENABLED=$(echo "$FLAGS" | jq -r '.feature_share_links_enabled // false')
    GUEST_RSVP_ENABLED=$(echo "$FLAGS" | jq -r '.feature_guest_rsvp_enabled // false')
    PUBLIC_PAGE_ENABLED=$(echo "$FLAGS" | jq -r '.feature_public_meeting_page_v2 // false')
    
    if [ "$SHARE_LINKS_ENABLED" = "true" ] && [ "$GUEST_RSVP_ENABLED" = "true" ] && [ "$PUBLIC_PAGE_ENABLED" = "true" ]; then
        print_success "All feature flags are enabled"
    else
        print_warning "Some feature flags are disabled:"
        echo "  - Share links: $SHARE_LINKS_ENABLED"
        echo "  - Guest RSVP: $GUEST_RSVP_ENABLED"
        echo "  - Public page: $PUBLIC_PAGE_ENABLED"
    fi
}

# Generate report
generate_report() {
    print_status "Generating hypercare report..."
    
    REPORT_FILE="hypercare_report_$(date +%Y%m%d_%H%M%S).txt"
    
    {
        echo "Share-in-Groups Hypercare Report"
        echo "Generated: $(date)"
        echo "=================================="
        echo ""
        echo "Application Health:"
        echo "- Status: $(curl -f -s "https://$(firebase use --json | jq -r '.current').web.app" > /dev/null && echo "OK" || echo "ERROR")"
        echo ""
        echo "Feature Flags:"
        firebase functions:config:get share 2>/dev/null | jq -r '.share'
        echo ""
        echo "Recent Errors:"
        firebase functions:log --only functions --limit 10 2>/dev/null | grep -E "(ERROR|WARN)" || echo "No recent errors"
        echo ""
        echo "Rate Limiting:"
        for action in "create_share_link" "guest_rsvp" "public_page_open" "join_group_from_share"; do
            hits=$(firebase functions:log --only functions 2>/dev/null | grep -c "rate_limit_hit.*$action" || echo "0")
            echo "- $action: $hits hits"
        done
    } > "$REPORT_FILE"
    
    print_success "Report generated: $REPORT_FILE"
}

# Main monitoring loop
main() {
    check_dependencies
    
    if [ "$ONCE_MODE" = true ]; then
        print_status "Running one-time checks..."
        check_app_health
        check_firestore_rules
        check_rate_limiting
        check_telemetry
        check_conversion_funnel
        check_guest_tokens
        check_performance
        check_feature_flags
        generate_report
        print_success "One-time checks completed"
    else
        print_status "Starting continuous monitoring (Ctrl+C to stop)..."
        
        while true; do
            echo ""
            echo "🕐 $(date) - Running hypercare checks..."
            echo "=========================================="
            
            check_app_health
            check_firestore_rules
            check_rate_limiting
            check_telemetry
            check_conversion_funnel
            check_guest_tokens
            check_performance
            check_feature_flags
            
            echo ""
            print_status "Next check in 5 minutes..."
            sleep 300
        done
    fi
}

# Run main function
main "$@"

