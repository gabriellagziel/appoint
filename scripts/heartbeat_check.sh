#!/usr/bin/env bash
set -euo pipefail

echo "💓 Status Page Heartbeat Monitor"
echo "================================"

# Configuration
HEALTH_ENDPOINT="https://admin.demo-app.web.app/health"
STATUS_PAGE_WEBHOOK="${STATUS_PAGE_WEBHOOK:-}"
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"
CHECK_INTERVAL=60  # seconds
FAILURE_THRESHOLD=3
INCIDENT_CREATED=false

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

# Function to send status page update
send_status_update() {
    local status="$1"
    local message="$2"
    
    if [ -n "$STATUS_PAGE_WEBHOOK" ]; then
        case $status in
            "operational")
                curl -X POST "$STATUS_PAGE_WEBHOOK" \
                    -H "Content-Type: application/json" \
                    -d "{\"status\":\"operational\",\"message\":\"$message\"}" || true
                ;;
            "degraded")
                curl -X POST "$STATUS_PAGE_WEBHOOK" \
                    -H "Content-Type: application/json" \
                    -d "{\"status\":\"degraded\",\"message\":\"$message\"}" || true
                ;;
            "outage")
                curl -X POST "$STATUS_PAGE_WEBHOOK" \
                    -H "Content-Type: application/json" \
                    -d "{\"status\":\"outage\",\"message\":\"$message\"}" || true
                ;;
        esac
    fi
}

# Function to send Slack notification
send_slack_notification() {
    local message="$1"
    local color="$2"
    
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST "$SLACK_WEBHOOK" \
            -H "Content-Type: application/json" \
            -d "{
                \"attachments\": [{
                    \"color\": \"$color\",
                    \"text\": \"$message\",
                    \"footer\": \"Status Page Heartbeat\",
                    \"ts\": $(date +%s)
                }]
            }" || true
    fi
}

# Function to create incident
create_incident() {
    local failure_count="$1"
    local last_error="$2"
    
    print_warning "Creating incident - $failure_count consecutive failures"
    
    # Send status page outage notification
    send_status_update "outage" "Admin panel experiencing issues - investigating"
    
    # Send Slack alert
    send_slack_notification "🚨 Admin Panel Incident Created\n\n$failure_count consecutive health check failures\nLast error: $last_error\n\nInvestigating..." "danger"
    
    # Log incident
    echo "$(date): INCIDENT_CREATED - $failure_count failures, last error: $last_error" >> heartbeat_incidents.log
    
    INCIDENT_CREATED=true
}

# Function to resolve incident
resolve_incident() {
    print_info "Resolving incident - service recovered"
    
    # Send status page operational notification
    send_status_update "operational" "Admin panel operational"
    
    # Send Slack resolution
    send_slack_notification "✅ Admin Panel Incident Resolved\n\nService is operational again" "good"
    
    # Log resolution
    echo "$(date): INCIDENT_RESOLVED" >> heartbeat_incidents.log
    
    INCIDENT_CREATED=false
}

# Function to check health endpoint
check_health() {
    local response
    local http_code
    local response_time
    
    # Make health check request
    response=$(curl -s -w "%{http_code}|%{time_total}" -o /tmp/health_response.json "$HEALTH_ENDPOINT" 2>/dev/null || echo "000|0")
    
    # Parse response
    http_code=$(echo "$response" | cut -d'|' -f1)
    response_time=$(echo "$response" | cut -d'|' -f2)
    
    # Check HTTP status code
    if [ "$http_code" = "200" ]; then
        # Parse response JSON for additional health info
        if [ -f /tmp/health_response.json ]; then
            local status=$(jq -r '.status // "unknown"' /tmp/health_response.json 2>/dev/null || echo "unknown")
            local error_rate=$(jq -r '.error_rate // 0' /tmp/health_response.json 2>/dev/null || echo "0")
            
            # Check if status is healthy
            if [ "$status" = "healthy" ] || [ "$status" = "operational" ]; then
                echo "healthy|$response_time|$error_rate"
                return 0
            else
                echo "degraded|$response_time|$error_rate"
                return 1
            fi
        else
            echo "healthy|$response_time|0"
            return 0
        fi
    else
        echo "error|$response_time|0"
        return 1
    fi
}

# Function to check specific endpoints
check_endpoints() {
    local endpoints=(
        "https://admin.demo-app.web.app/api/admin/config"
        "https://admin.demo-app.web.app/api/admin/health"
        "https://admin.demo-app.web.app/api/monitoring/status"
    )
    
    local failed_endpoints=0
    
    for endpoint in "${endpoints[@]}"; do
        local response_code=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint" 2>/dev/null || echo "000")
        if [ "$response_code" != "200" ]; then
            ((failed_endpoints++))
            print_warning "Endpoint check failed: $endpoint (HTTP $response_code)"
        fi
    done
    
    if [ $failed_endpoints -gt 0 ]; then
        return 1
    else
        return 0
    fi
}

# Main monitoring loop
echo "Starting heartbeat monitoring..."
echo "Health endpoint: $HEALTH_ENDPOINT"
echo "Check interval: ${CHECK_INTERVAL}s"
echo "Failure threshold: $FAILURE_THRESHOLD"
echo ""

# Initialize counters
failure_count=0
success_count=0
start_time=$(date +%s)

while true; do
    current_time=$(date +%s)
    uptime=$((current_time - start_time))
    
    echo "$(date): Checking health..."
    
    # Perform health check
    health_result=$(check_health)
    health_status=$(echo "$health_result" | cut -d'|' -f1)
    response_time=$(echo "$health_result" | cut -d'|' -f2)
    error_rate=$(echo "$health_result" | cut -d'|' -f3)
    
    # Check additional endpoints
    endpoint_check=$(check_endpoints)
    endpoint_status=$?
    
    # Determine overall status
    if [ "$health_status" = "healthy" ] && [ $endpoint_status -eq 0 ]; then
        print_status 0 "Service healthy (${response_time}s response, ${error_rate}% error rate)"
        ((success_count++))
        failure_count=0
        
        # Resolve incident if it was created
        if [ "$INCIDENT_CREATED" = true ]; then
            resolve_incident
        fi
        
        # Send periodic operational status
        if [ $((success_count % 10)) -eq 0 ]; then
            send_status_update "operational" "Admin panel operational - ${response_time}s response time"
        fi
        
    else
        ((failure_count++))
        success_count=0
        
        local error_msg="Health check failed"
        if [ "$health_status" != "healthy" ]; then
            error_msg="Health endpoint returned $health_status"
        fi
        if [ $endpoint_status -ne 0 ]; then
            error_msg="$error_msg, endpoint checks failed"
        fi
        
        print_status 1 "$error_msg (failure #$failure_count)"
        
        # Create incident if threshold reached
        if [ $failure_count -ge $FAILURE_THRESHOLD ] && [ "$INCIDENT_CREATED" = false ]; then
            create_incident "$failure_count" "$error_msg"
        fi
    fi
    
    # Log metrics
    echo "$(date),$health_status,$response_time,$error_rate,$failure_count,$success_count" >> heartbeat_metrics.csv
    
    # Display summary
    echo "Uptime: ${uptime}s | Failures: $failure_count | Successes: $success_count"
    echo "Response time: ${response_time}s | Error rate: ${error_rate}%"
    echo ""
    
    # Wait for next check
    sleep $CHECK_INTERVAL
done
