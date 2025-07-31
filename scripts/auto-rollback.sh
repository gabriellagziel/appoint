#!/bin/bash

# Auto-rollback script for App-Oint production deployments
# This script monitors health endpoints after deployment and automatically
# rolls back to the previous version if health checks fail

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="${PROJECT_ROOT}/logs/auto-rollback.log"
HEALTH_CHECK_TIMEOUT=300  # 5 minutes
HEALTH_CHECK_INTERVAL=10  # 10 seconds
MAX_ROLLBACK_ATTEMPTS=3

# Health endpoints to check
HEALTH_ENDPOINTS=(
    "http://functions:5001/health"
    "http://functions:5001/liveness"
    "http://functions:5001/readiness"
    "http://dashboard:3000/api/health"
    "http://marketing:8080/api/health"
    "http://admin:8082/health"
    "http://business:8081/health"
)

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    local level=$1
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo -e "${timestamp} [${level}] ${message}" | tee -a "${LOG_FILE}"
}

# Create logs directory if it doesn't exist
mkdir -p "$(dirname "$LOG_FILE")"

log "INFO" "Auto-rollback script started"

# Function to check if a URL is healthy
check_endpoint_health() {
    local url=$1
    local response_code
    local response_body
    
    # Make request with timeout
    if response_code=$(curl -s -o /tmp/health_response.json -w "%{http_code}" --max-time 10 "$url" 2>/dev/null); then
        response_body=$(cat /tmp/health_response.json 2>/dev/null || echo "{}")
        
        # Check if response code is 2xx
        if [[ "$response_code" =~ ^2[0-9][0-9]$ ]]; then
            # For health endpoints, also check the response body
            if echo "$response_body" | jq -e '.status' >/dev/null 2>&1; then
                local status=$(echo "$response_body" | jq -r '.status' 2>/dev/null || echo "unknown")
                if [[ "$status" == "healthy" || "$status" == "ok" || "$status" == "alive" || "$status" == "ready" ]]; then
                    return 0
                else
                    log "WARN" "Endpoint $url returned unhealthy status: $status"
                    return 1
                fi
            else
                # If no status field, assume healthy for 2xx response
                return 0
            fi
        else
            log "WARN" "Endpoint $url returned HTTP $response_code"
            return 1
        fi
    else
        log "WARN" "Failed to connect to endpoint $url"
        return 1
    fi
}

# Function to check all health endpoints
check_all_endpoints() {
    local failed_endpoints=()
    local total_endpoints=${#HEALTH_ENDPOINTS[@]}
    local healthy_endpoints=0
    
    log "INFO" "Checking health of $total_endpoints endpoints..."
    
    for endpoint in "${HEALTH_ENDPOINTS[@]}"; do
        if check_endpoint_health "$endpoint"; then
            log "INFO" "✅ $endpoint is healthy"
            ((healthy_endpoints++))
        else
            log "ERROR" "❌ $endpoint is unhealthy"
            failed_endpoints+=("$endpoint")
        fi
    done
    
    # Calculate health percentage
    local health_percentage=$((healthy_endpoints * 100 / total_endpoints))
    log "INFO" "Health check results: $healthy_endpoints/$total_endpoints endpoints healthy ($health_percentage%)"
    
    # Require at least 80% of endpoints to be healthy
    if [[ $health_percentage -ge 80 ]]; then
        return 0
    else
        log "ERROR" "Health check failed: only $health_percentage% of endpoints are healthy"
        log "ERROR" "Failed endpoints: ${failed_endpoints[*]}"
        return 1
    fi
}

# Function to get current deployment version/commit
get_current_version() {
    # Try to get from git
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git rev-parse --short HEAD
    else
        echo "unknown"
    fi
}

# Function to get previous deployment version
get_previous_version() {
    # Try to get from git
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git rev-parse --short HEAD~1
    else
        echo "unknown"
    fi
}

# Function to perform rollback
perform_rollback() {
    local current_version=$1
    local previous_version=$2
    local attempt=$3
    
    log "ERROR" "🔄 Initiating rollback from $current_version to $previous_version (attempt $attempt/$MAX_ROLLBACK_ATTEMPTS)"
    
    # Send alert about rollback
    send_rollback_alert "$current_version" "$previous_version" "initiated"
    
    # Perform the actual rollback based on deployment method
    if [[ -f "${PROJECT_ROOT}/docker-compose.yml" ]]; then
        rollback_docker_compose "$previous_version"
    elif [[ -f "${PROJECT_ROOT}/k8s" ]]; then
        rollback_kubernetes "$previous_version"
    elif command -v doctl >/dev/null 2>&1; then
        rollback_digitalocean_app "$previous_version"
    else
        log "ERROR" "No supported deployment method found for rollback"
        return 1
    fi
    
    # Wait for rollback to complete
    log "INFO" "Waiting 60 seconds for rollback to complete..."
    sleep 60
    
    # Verify rollback success
    if check_all_endpoints; then
        log "INFO" "✅ Rollback successful! System is healthy"
        send_rollback_alert "$current_version" "$previous_version" "successful"
        return 0
    else
        log "ERROR" "❌ Rollback failed! System still unhealthy"
        send_rollback_alert "$current_version" "$previous_version" "failed"
        return 1
    fi
}

# Function to rollback Docker Compose deployment
rollback_docker_compose() {
    local previous_version=$1
    
    log "INFO" "Rolling back Docker Compose deployment..."
    
    # Git checkout to previous version
    if git rev-parse --git-dir > /dev/null 2>&1; then
        git checkout "$previous_version" || {
            log "ERROR" "Failed to checkout previous version $previous_version"
            return 1
        }
    fi
    
    # Rebuild and redeploy
    cd "$PROJECT_ROOT"
    docker-compose down --remove-orphans
    docker-compose pull
    docker-compose up -d --build
}

# Function to rollback Kubernetes deployment
rollback_kubernetes() {
    local previous_version=$1
    
    log "INFO" "Rolling back Kubernetes deployment..."
    
    # Rollback each deployment
    kubectl rollout undo deployment/app-oint-functions || true
    kubectl rollout undo deployment/app-oint-dashboard || true
    kubectl rollout undo deployment/app-oint-marketing || true
    kubectl rollout undo deployment/app-oint-admin || true
    kubectl rollout undo deployment/app-oint-business || true
    
    # Wait for rollout to complete
    kubectl rollout status deployment/app-oint-functions --timeout=300s
    kubectl rollout status deployment/app-oint-dashboard --timeout=300s
}

# Function to rollback DigitalOcean App Platform deployment
rollback_digitalocean_app() {
    local previous_version=$1
    
    log "INFO" "Rolling back DigitalOcean App Platform deployment..."
    
    # Get app ID
    local app_id=$(doctl apps list --format ID,Name | grep app-oint | awk '{print $1}')
    
    if [[ -n "$app_id" ]]; then
        # Get previous deployment
        local prev_deployment=$(doctl apps list-deployments "$app_id" --format ID,Phase | grep ACTIVE | tail -2 | head -1 | awk '{print $1}')
        
        if [[ -n "$prev_deployment" ]]; then
            doctl apps create-deployment "$app_id" --spec-file="$PROJECT_ROOT/.do/app.yaml"
        else
            log "ERROR" "No previous deployment found for app $app_id"
            return 1
        fi
    else
        log "ERROR" "App-Oint app not found in DigitalOcean"
        return 1
    fi
}

# Function to send rollback alerts
send_rollback_alert() {
    local current_version=$1
    local previous_version=$2
    local status=$3
    
    local webhook_url="${SLACK_WEBHOOK_URL}"
    
    if [[ -n "$webhook_url" ]]; then
        local color="danger"
        local icon="🔄"
        
        if [[ "$status" == "successful" ]]; then
            color="warning"
            icon="✅"
        elif [[ "$status" == "failed" ]]; then
            color="danger"
            icon="❌"
        fi
        
        local payload=$(cat <<EOF
{
    "channel": "#alerts-critical",
    "username": "App-Oint Auto-Rollback",
    "icon_emoji": ":warning:",
    "attachments": [
        {
            "color": "$color",
            "title": "$icon Automatic Rollback $status",
            "fields": [
                {
                    "title": "Environment",
                    "value": "Production",
                    "short": true
                },
                {
                    "title": "Status",
                    "value": "$status",
                    "short": true
                },
                {
                    "title": "From Version",
                    "value": "$current_version",
                    "short": true
                },
                {
                    "title": "To Version",
                    "value": "$previous_version",
                    "short": true
                }
            ],
            "footer": "App-Oint Auto-Rollback System",
            "ts": $(date +%s)
        }
    ]
}
EOF
        )
        
        curl -X POST -H 'Content-type: application/json' \
             --data "$payload" \
             "$webhook_url" || true
    fi
}

# Function to wait for deployment to stabilize
wait_for_deployment() {
    local start_time=$(date +%s)
    local end_time=$((start_time + HEALTH_CHECK_TIMEOUT))
    
    log "INFO" "Waiting for deployment to stabilize (timeout: ${HEALTH_CHECK_TIMEOUT}s)..."
    
    while [[ $(date +%s) -lt $end_time ]]; do
        if check_all_endpoints; then
            local elapsed=$(($(date +%s) - start_time))
            log "INFO" "✅ Deployment stabilized after ${elapsed} seconds"
            return 0
        fi
        
        log "INFO" "Deployment not yet stable, waiting ${HEALTH_CHECK_INTERVAL}s..."
        sleep $HEALTH_CHECK_INTERVAL
    done
    
    log "ERROR" "❌ Deployment failed to stabilize within ${HEALTH_CHECK_TIMEOUT} seconds"
    return 1
}

# Main execution logic
main() {
    local current_version
    local previous_version
    
    current_version=$(get_current_version)
    previous_version=$(get_previous_version)
    
    log "INFO" "Current version: $current_version"
    log "INFO" "Previous version: $previous_version"
    
    # Wait for deployment to stabilize
    if wait_for_deployment; then
        log "INFO" "✅ Deployment successful! No rollback needed."
        return 0
    fi
    
    # Deployment failed, attempt rollback
    log "ERROR" "❌ Deployment failed health checks, initiating automatic rollback..."
    
    local rollback_attempt=1
    while [[ $rollback_attempt -le $MAX_ROLLBACK_ATTEMPTS ]]; do
        if perform_rollback "$current_version" "$previous_version" "$rollback_attempt"; then
            log "INFO" "✅ Rollback successful on attempt $rollback_attempt"
            return 0
        fi
        
        ((rollback_attempt++))
        if [[ $rollback_attempt -le $MAX_ROLLBACK_ATTEMPTS ]]; then
            log "WARN" "Rollback attempt $((rollback_attempt-1)) failed, retrying in 30 seconds..."
            sleep 30
        fi
    done
    
    log "ERROR" "❌ All rollback attempts failed! Manual intervention required."
    send_rollback_alert "$current_version" "$previous_version" "failed-manual-intervention-required"
    
    return 1
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi