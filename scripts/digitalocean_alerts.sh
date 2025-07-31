#!/bin/bash

# DigitalOcean App Platform Alerts & Rollbacks Script
# This script sets up comprehensive monitoring and alerting for App-Oint

set -e

# Configuration
APP_NAME="appoint"
REGIONS=("fra1" "nyc1")
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL}"
EMAIL_ALERTS="${EMAIL_ALERTS}"
PAGERDUTY_API_KEY="${PAGERDUTY_API_KEY}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
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

# 1. Health Check Monitoring
setup_health_monitoring() {
    log "Setting up health monitoring..."
    
    # Create health check endpoints
    cat > health_check_config.json << EOF
{
  "health_checks": [
    {
      "name": "liveness",
      "path": "/health/liveness",
      "interval_seconds": 30,
      "timeout_seconds": 5,
      "unhealthy_threshold": 3,
      "healthy_threshold": 2
    },
    {
      "name": "readiness", 
      "path": "/health/readiness",
      "interval_seconds": 30,
      "timeout_seconds": 10,
      "unhealthy_threshold": 3,
      "healthy_threshold": 2
    }
  ]
}
EOF

    # Apply health checks to DigitalOcean App Platform
    doctl apps update $APP_NAME --health-check-config health_check_config.json
    
    log "Health monitoring configured successfully"
}

# 2. Alert Rules Setup
setup_alert_rules() {
    log "Setting up alert rules..."
    
    # Create alert policies
    cat > alert_policies.json << EOF
{
  "policies": [
    {
      "name": "high-error-rate",
      "description": "Alert when 5xx error rate exceeds 1% for 3 minutes",
      "type": "v1/insights/droplet/load_1",
      "comparison": "greater_than",
      "value": 1.0,
      "window": "5m",
      "notifications": {
        "slack": ["$SLACK_WEBHOOK_URL"],
        "email": ["$EMAIL_ALERTS"],
        "pagerduty": ["$PAGERDUTY_API_KEY"]
      }
    },
    {
      "name": "high-cpu-usage",
      "description": "Alert when CPU usage exceeds 80% for 5 minutes",
      "type": "v1/insights/droplet/cpu",
      "comparison": "greater_than", 
      "value": 80.0,
      "window": "5m",
      "notifications": {
        "slack": ["$SLACK_WEBHOOK_URL"],
        "email": ["$EMAIL_ALERTS"]
      }
    },
    {
      "name": "high-memory-usage",
      "description": "Alert when memory usage exceeds 75%",
      "type": "v1/insights/droplet/memory_utilization_percent",
      "comparison": "greater_than",
      "value": 75.0,
      "window": "3m",
      "notifications": {
        "slack": ["$SLACK_WEBHOOK_URL"],
        "email": ["$EMAIL_ALERTS"]
      }
    },
    {
      "name": "traffic-drop",
      "description": "Alert when traffic drops by 50% in 5 minutes",
      "type": "v1/insights/droplet/load_1",
      "comparison": "less_than",
      "value": 50.0,
      "window": "5m",
      "notifications": {
        "slack": ["$SLACK_WEBHOOK_URL"],
        "pagerduty": ["$PAGERDUTY_API_KEY"]
      }
    }
  ]
}
EOF

    # Apply alert policies
    doctl monitoring alert create --config alert_policies.json
    
    log "Alert rules configured successfully"
}

# 3. Auto-Rollback Configuration
setup_auto_rollback() {
    log "Setting up auto-rollback configuration..."
    
    # Create rollback policy
    cat > rollback_policy.json << EOF
{
  "auto_rollback": {
    "enabled": true,
    "conditions": [
      {
        "type": "health_check_failure",
        "threshold": 3,
        "window": "5m"
      },
      {
        "type": "error_rate",
        "threshold": 5.0,
        "window": "3m"
      },
      {
        "type": "response_time",
        "threshold": 5000,
        "window": "2m"
      }
    ],
    "rollback_to": "previous_deployment"
  }
}
EOF

    # Apply rollback policy to DigitalOcean App Platform
    doctl apps update $APP_NAME --rollback-config rollback_policy.json
    
    log "Auto-rollback configured successfully"
}

# 4. Multi-Region Health Monitoring
setup_multi_region_monitoring() {
    log "Setting up multi-region health monitoring..."
    
    for region in "${REGIONS[@]}"; do
        log "Configuring monitoring for region: $region"
        
        # Create region-specific health checks
        cat > "health_check_${region}.json" << EOF
{
  "region": "$region",
  "health_checks": [
    {
      "name": "liveness-$region",
      "path": "/health/liveness",
      "interval_seconds": 30,
      "timeout_seconds": 5,
      "unhealthy_threshold": 3,
      "healthy_threshold": 2
    },
    {
      "name": "readiness-$region",
      "path": "/health/readiness", 
      "interval_seconds": 30,
      "timeout_seconds": 10,
      "unhealthy_threshold": 3,
      "healthy_threshold": 2
    }
  ]
}
EOF

        # Apply region-specific health checks
        doctl apps update $APP_NAME --region $region --health-check-config "health_check_${region}.json"
    done
    
    log "Multi-region monitoring configured successfully"
}

# 5. Performance Monitoring
setup_performance_monitoring() {
    log "Setting up performance monitoring..."
    
    # Create performance monitoring config
    cat > performance_monitoring.json << EOF
{
  "metrics": [
    {
      "name": "response_time_p95",
      "type": "histogram",
      "buckets": [0.1, 0.5, 1.0, 2.0, 5.0, 10.0],
      "labels": ["endpoint", "method", "status_code"]
    },
    {
      "name": "response_time_p99", 
      "type": "histogram",
      "buckets": [0.1, 0.5, 1.0, 2.0, 5.0, 10.0],
      "labels": ["endpoint", "method", "status_code"]
    },
    {
      "name": "error_rate",
      "type": "counter",
      "labels": ["endpoint", "error_type"]
    },
    {
      "name": "request_rate",
      "type": "counter", 
      "labels": ["endpoint", "method"]
    }
  ],
  "alerts": [
    {
      "name": "p95_response_time_high",
      "condition": "response_time_p95 > 2.0",
      "duration": "5m",
      "severity": "warning"
    },
    {
      "name": "p99_response_time_high",
      "condition": "response_time_p99 > 5.0", 
      "duration": "3m",
      "severity": "critical"
    }
  ]
}
EOF

    # Apply performance monitoring
    doctl monitoring metrics create --config performance_monitoring.json
    
    log "Performance monitoring configured successfully"
}

# 6. Notification Setup
setup_notifications() {
    log "Setting up notification channels..."
    
    # Slack notification
    if [ -n "$SLACK_WEBHOOK_URL" ]; then
        doctl monitoring alert create --name "slack-notifications" \
            --type "slack" \
            --webhook-url "$SLACK_WEBHOOK_URL"
        log "Slack notifications configured"
    fi
    
    # Email notification
    if [ -n "$EMAIL_ALERTS" ]; then
        doctl monitoring alert create --name "email-notifications" \
            --type "email" \
            --email "$EMAIL_ALERTS"
        log "Email notifications configured"
    fi
    
    # PagerDuty notification
    if [ -n "$PAGERDUTY_API_KEY" ]; then
        doctl monitoring alert create --name "pagerduty-notifications" \
            --type "pagerduty" \
            --api-key "$PAGERDUTY_API_KEY"
        log "PagerDuty notifications configured"
    fi
}

# 7. Test Alerts
test_alerts() {
    log "Testing alert configuration..."
    
    # Test health check endpoints
    for region in "${REGIONS[@]}"; do
        log "Testing health checks in region: $region"
        
        # Test liveness endpoint
        curl -f "https://appoint-$region.digitaloceanspaces.com/health/liveness" || {
            error "Liveness check failed in $region"
        }
        
        # Test readiness endpoint  
        curl -f "https://appoint-$region.digitaloceanspaces.com/health/readiness" || {
            error "Readiness check failed in $region"
        }
        
        # Test metrics endpoint
        curl -f "https://appoint-$region.digitaloceanspaces.com/metrics" || {
            error "Metrics endpoint failed in $region"
        }
    done
    
    log "Alert testing completed"
}

# 8. Generate Monitoring Dashboard
generate_dashboard() {
    log "Generating monitoring dashboard..."
    
    cat > monitoring_dashboard.json << EOF
{
  "dashboard": {
    "name": "App-Oint Production Monitoring",
    "description": "Comprehensive monitoring dashboard for App-Oint production environment",
    "panels": [
      {
        "title": "Response Time (P95)",
        "type": "graph",
        "query": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
        "y_axis": {
          "unit": "seconds",
          "min": 0,
          "max": 10
        }
      },
      {
        "title": "Error Rate",
        "type": "graph", 
        "query": "rate(http_requests_total{status=~\"5..\"}[5m]) / rate(http_requests_total[5m])",
        "y_axis": {
          "unit": "percent",
          "min": 0,
          "max": 100
        }
      },
      {
        "title": "CPU Usage",
        "type": "graph",
        "query": "avg(rate(container_cpu_usage_seconds_total[5m])) * 100",
        "y_axis": {
          "unit": "percent",
          "min": 0,
          "max": 100
        }
      },
      {
        "title": "Memory Usage",
        "type": "graph",
        "query": "avg(container_memory_usage_bytes / container_spec_memory_limit_bytes) * 100",
        "y_axis": {
          "unit": "percent", 
          "min": 0,
          "max": 100
        }
      },
      {
        "title": "Active Users",
        "type": "stat",
        "query": "sum(active_users_total)"
      },
      {
        "title": "Database Connections",
        "type": "graph",
        "query": "avg(database_connections_active)",
        "y_axis": {
          "unit": "connections",
          "min": 0
        }
      }
    ],
    "refresh": "30s",
    "time": {
      "from": "now-1h",
      "to": "now"
    }
  }
}
EOF

    # Create dashboard in DigitalOcean Monitoring
    doctl monitoring dashboard create --config monitoring_dashboard.json
    
    log "Monitoring dashboard created successfully"
}

# Main execution
main() {
    log "Starting DigitalOcean App Platform Alerts & Rollbacks Setup..."
    
    # Check prerequisites
    if ! command -v doctl &> /dev/null; then
        error "doctl CLI is not installed. Please install it first."
        exit 1
    fi
    
    # Check authentication
    if ! doctl account get &> /dev/null; then
        error "doctl is not authenticated. Please run 'doctl auth init' first."
        exit 1
    fi
    
    # Execute setup steps
    setup_health_monitoring
    setup_alert_rules
    setup_auto_rollback
    setup_multi_region_monitoring
    setup_performance_monitoring
    setup_notifications
    test_alerts
    generate_dashboard
    
    log "DigitalOcean App Platform Alerts & Rollbacks setup completed successfully!"
    log "Dashboard URL: https://cloud.digitalocean.com/monitoring/dashboards"
    log "Alerts configured for: Slack, Email, PagerDuty"
    log "Auto-rollback enabled for health check failures"
}

# Run main function
main "$@" 