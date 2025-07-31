#!/bin/bash

# Auto-scaling monitoring script for App-Oint
# Monitors HPA events and scaling activities across different platforms

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
LOG_FILE="${PROJECT_ROOT}/logs/autoscaling.log"
MONITORING_INTERVAL=30  # seconds
PLATFORMS=("kubernetes" "digitalocean")

# Thresholds for alerts
CPU_WARNING_THRESHOLD=75
CPU_CRITICAL_THRESHOLD=85
MEMORY_WARNING_THRESHOLD=70
MEMORY_CRITICAL_THRESHOLD=80
SCALING_EVENT_COOLDOWN=300  # 5 minutes

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log "INFO" "🔍 Auto-scaling monitor started"

# Function to send Slack notification about scaling events
send_scaling_alert() {
    local service=$1
    local action=$2
    local from_replicas=$3
    local to_replicas=$4
    local reason=$5
    local platform=$6
    
    if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
        local color="warning"
        local icon="📈"
        
        if [[ "$action" == "scale_up" ]]; then
            color="warning"
            icon="📈"
        elif [[ "$action" == "scale_down" ]]; then
            color="good"
            icon="📉"
        fi
        
        local payload=$(cat <<EOF
{
    "channel": "#devops",
    "username": "App-Oint Auto-Scaling",
    "icon_emoji": ":chart_with_upwards_trend:",
    "attachments": [
        {
            "color": "$color",
            "title": "$icon Auto-scaling Event: $service",
            "fields": [
                {
                    "title": "Platform",
                    "value": "$platform",
                    "short": true
                },
                {
                    "title": "Action",
                    "value": "$action",
                    "short": true
                },
                {
                    "title": "Replicas Change",
                    "value": "$from_replicas → $to_replicas",
                    "short": true
                },
                {
                    "title": "Reason",
                    "value": "$reason",
                    "short": true
                }
            ],
            "footer": "App-Oint Auto-Scaling Monitor",
            "ts": $(date +%s)
        }
    ]
}
EOF
        )
        
        curl -X POST -H 'Content-type: application/json' \
             --data "$payload" \
             "${SLACK_WEBHOOK_URL}" >/dev/null 2>&1 || true
    fi
}

# Function to monitor Kubernetes HPA
monitor_kubernetes_hpa() {
    if ! command -v kubectl >/dev/null 2>&1; then
        log "WARN" "kubectl not found, skipping Kubernetes monitoring"
        return
    fi
    
    # Check if we can connect to cluster
    if ! kubectl cluster-info >/dev/null 2>&1; then
        log "WARN" "Cannot connect to Kubernetes cluster"
        return
    fi
    
    log "INFO" "📊 Monitoring Kubernetes HPA status..."
    
    # Get HPA status for all App-Oint services
    local hpa_services=("functions" "dashboard" "marketing" "admin" "business")
    
    for service in "${hpa_services[@]}"; do
        local hpa_name="app-oint-${service}-hpa"
        
        if kubectl get hpa "$hpa_name" -n app-oint >/dev/null 2>&1; then
            # Get current HPA metrics
            local hpa_info=$(kubectl get hpa "$hpa_name" -n app-oint -o json 2>/dev/null)
            
            if [[ -n "$hpa_info" ]]; then
                local current_replicas=$(echo "$hpa_info" | jq -r '.status.currentReplicas // 0')
                local desired_replicas=$(echo "$hpa_info" | jq -r '.status.desiredReplicas // 0')
                local min_replicas=$(echo "$hpa_info" | jq -r '.spec.minReplicas // 0')
                local max_replicas=$(echo "$hpa_info" | jq -r '.spec.maxReplicas // 0')
                
                # Get CPU and memory utilization
                local cpu_utilization=$(echo "$hpa_info" | jq -r '.status.currentMetrics[]? | select(.resource.name=="cpu") | .resource.current.averageUtilization // 0')
                local memory_utilization=$(echo "$hpa_info" | jq -r '.status.currentMetrics[]? | select(.resource.name=="memory") | .resource.current.averageUtilization // 0')
                
                log "INFO" "📊 ${service}: ${current_replicas}/${desired_replicas} replicas (${min_replicas}-${max_replicas}), CPU: ${cpu_utilization}%, Memory: ${memory_utilization}%"
                
                # Check for scaling events
                if [[ "$current_replicas" != "$desired_replicas" ]]; then
                    local action="scale_up"
                    if [[ "$desired_replicas" -lt "$current_replicas" ]]; then
                        action="scale_down"
                    fi
                    
                    local reason="CPU: ${cpu_utilization}%, Memory: ${memory_utilization}%"
                    send_scaling_alert "$service" "$action" "$current_replicas" "$desired_replicas" "$reason" "Kubernetes"
                fi
                
                # Check for resource warnings
                if [[ "$cpu_utilization" -gt "$CPU_CRITICAL_THRESHOLD" ]]; then
                    log "ERROR" "🚨 CRITICAL: ${service} CPU usage (${cpu_utilization}%) exceeds critical threshold (${CPU_CRITICAL_THRESHOLD}%)"
                elif [[ "$cpu_utilization" -gt "$CPU_WARNING_THRESHOLD" ]]; then
                    log "WARN" "⚠️ WARNING: ${service} CPU usage (${cpu_utilization}%) exceeds warning threshold (${CPU_WARNING_THRESHOLD}%)"
                fi
                
                if [[ "$memory_utilization" -gt "$MEMORY_CRITICAL_THRESHOLD" ]]; then
                    log "ERROR" "🚨 CRITICAL: ${service} Memory usage (${memory_utilization}%) exceeds critical threshold (${MEMORY_CRITICAL_THRESHOLD}%)"
                elif [[ "$memory_utilization" -gt "$MEMORY_WARNING_THRESHOLD" ]]; then
                    log "WARN" "⚠️ WARNING: ${service} Memory usage (${memory_utilization}%) exceeds warning threshold (${MEMORY_WARNING_THRESHOLD}%)"
                fi
            fi
        else
            log "WARN" "HPA ${hpa_name} not found"
        fi
    done
}

# Function to monitor DigitalOcean App Platform scaling
monitor_digitalocean_scaling() {
    if ! command -v doctl >/dev/null 2>&1; then
        log "WARN" "doctl not found, skipping DigitalOcean monitoring"
        return
    fi
    
    # Check if we're authenticated
    if ! doctl account get >/dev/null 2>&1; then
        log "WARN" "doctl not authenticated, skipping DigitalOcean monitoring"
        return
    fi
    
    log "INFO" "🌊 Monitoring DigitalOcean App Platform scaling..."
    
    # Get app ID
    local app_id=$(doctl apps list --format ID,Name --no-header | grep app-oint | awk '{print $1}' | head -1)
    
    if [[ -z "$app_id" ]]; then
        log "WARN" "App-Oint app not found in DigitalOcean"
        return
    fi
    
    # Get app info
    local app_info=$(doctl apps get "$app_id" --format json 2>/dev/null)
    
    if [[ -n "$app_info" ]]; then
        # Parse services and their instance counts
        local services=$(echo "$app_info" | jq -r '.spec.services[]?.name // empty')
        
        for service in $services; do
            local instance_count=$(echo "$app_info" | jq -r ".spec.services[] | select(.name==\"$service\") | .instance_count // 0")
            local min_instances=$(echo "$app_info" | jq -r ".spec.services[] | select(.name==\"$service\") | .autoscaling.min_instance_count // 0")
            local max_instances=$(echo "$app_info" | jq -r ".spec.services[] | select(.name==\"$service\") | .autoscaling.max_instance_count // 0")
            
            log "INFO" "🌊 ${service}: ${instance_count} instances (${min_instances}-${max_instances})"
            
            # Check for scaling events by comparing with previous state
            local state_file="/tmp/do_app_${service}_instances"
            local previous_count=0
            
            if [[ -f "$state_file" ]]; then
                previous_count=$(cat "$state_file")
            fi
            
            if [[ "$instance_count" != "$previous_count" && "$previous_count" != "0" ]]; then
                local action="scale_up"
                if [[ "$instance_count" -lt "$previous_count" ]]; then
                    action="scale_down"
                fi
                
                send_scaling_alert "$service" "$action" "$previous_count" "$instance_count" "Auto-scaling triggered" "DigitalOcean"
            fi
            
            # Save current state
            echo "$instance_count" > "$state_file"
        done
        
        # Get deployment info for health status
        local deployment_info=$(doctl apps list-deployments "$app_id" --format ID,Phase,CreatedAt --no-header | head -1)
        local deployment_phase=$(echo "$deployment_info" | awk '{print $2}')
        
        if [[ "$deployment_phase" == "FAILED" ]]; then
            log "ERROR" "🚨 Latest deployment failed on DigitalOcean App Platform"
        elif [[ "$deployment_phase" == "ACTIVE" ]]; then
            log "INFO" "✅ Latest deployment is active on DigitalOcean App Platform"
        fi
    fi
}

# Function to check overall system health and scaling efficiency
check_scaling_efficiency() {
    log "INFO" "📈 Checking scaling efficiency..."
    
    # Check if there are any pods/instances that have been scaled but are underutilized
    # This would indicate inefficient scaling
    
    if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
        # Get pod metrics
        local pods_info=$(kubectl top pods -n app-oint --no-headers 2>/dev/null || echo "")
        
        if [[ -n "$pods_info" ]]; then
            while IFS= read -r line; do
                if [[ -n "$line" ]]; then
                    local pod_name=$(echo "$line" | awk '{print $1}')
                    local cpu_usage=$(echo "$line" | awk '{print $2}' | sed 's/m$//')
                    local memory_usage=$(echo "$line" | awk '{print $3}' | sed 's/Mi$//')
                    
                    # Check for underutilized pods (less than 10% CPU for more than 30 minutes)
                    if [[ "$cpu_usage" =~ ^[0-9]+$ ]] && [[ "$cpu_usage" -lt 100 ]]; then
                        log "INFO" "💡 Pod ${pod_name} may be underutilized (CPU: ${cpu_usage}m, Memory: ${memory_usage}Mi)"
                    fi
                fi
            done <<< "$pods_info"
        fi
    fi
}

# Function to generate scaling report
generate_scaling_report() {
    local report_file="${PROJECT_ROOT}/logs/scaling-report-$(date +%Y%m%d).txt"
    
    log "INFO" "📄 Generating scaling report: $(basename "$report_file")"
    
    cat > "$report_file" << EOF
App-Oint Auto-Scaling Report
============================
Date: $(date)
Monitoring Interval: ${MONITORING_INTERVAL}s

Platform Status:
EOF

    # Add Kubernetes status if available
    if command -v kubectl >/dev/null 2>&1 && kubectl cluster-info >/dev/null 2>&1; then
        echo "
Kubernetes HPA Status:" >> "$report_file"
        kubectl get hpa -n app-oint --no-headers 2>/dev/null | while IFS= read -r line; do
            echo "  $line" >> "$report_file"
        done || echo "  No HPA resources found" >> "$report_file"
    fi
    
    # Add DigitalOcean status if available
    if command -v doctl >/dev/null 2>&1 && doctl account get >/dev/null 2>&1; then
        echo "
DigitalOcean App Platform Status:" >> "$report_file"
        local app_id=$(doctl apps list --format ID,Name --no-header | grep app-oint | awk '{print $1}' | head -1)
        if [[ -n "$app_id" ]]; then
            doctl apps get "$app_id" --format json 2>/dev/null | jq -r '.spec.services[]? | "\(.name): \(.instance_count) instances"' >> "$report_file" || echo "  Unable to fetch app info" >> "$report_file"
        else
            echo "  App-Oint app not found" >> "$report_file"
        fi
    fi
    
    echo "
Recent Scaling Events (last 100 lines from log):" >> "$report_file"
    tail -n 100 "$LOG_FILE" | grep -E "(scale_up|scale_down|CRITICAL|WARNING)" >> "$report_file" || echo "  No recent scaling events" >> "$report_file"
    
    log "INFO" "📄 Scaling report saved: $report_file"
}

# Main monitoring loop
main() {
    log "INFO" "🚀 Starting auto-scaling monitoring (interval: ${MONITORING_INTERVAL}s)"
    
    local iteration=0
    
    while true; do
        iteration=$((iteration + 1))
        
        log "INFO" "🔄 Monitoring iteration #${iteration}"
        
        # Monitor each platform
        for platform in "${PLATFORMS[@]}"; do
            case "$platform" in
                "kubernetes")
                    monitor_kubernetes_hpa
                    ;;
                "digitalocean")
                    monitor_digitalocean_scaling
                    ;;
            esac
        done
        
        # Check scaling efficiency every 10 iterations
        if [[ $((iteration % 10)) -eq 0 ]]; then
            check_scaling_efficiency
        fi
        
        # Generate daily report at midnight
        if [[ $(date +%H%M) == "0000" ]]; then
            generate_scaling_report
        fi
        
        # Sleep until next iteration
        sleep "$MONITORING_INTERVAL"
    done
}

# Handle script termination gracefully
cleanup() {
    log "INFO" "🛑 Auto-scaling monitor stopping..."
    generate_scaling_report
    exit 0
}

trap cleanup SIGINT SIGTERM

# Run the main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi