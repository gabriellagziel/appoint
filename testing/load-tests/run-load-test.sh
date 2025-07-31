#!/bin/bash

# Load test runner script for App-Oint
# Runs k6 load tests against staging environment and generates reports

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"
TEST_RESULTS_DIR="${PROJECT_ROOT}/test-results"
LOG_FILE="${TEST_RESULTS_DIR}/load-test.log"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

# Environment configuration
ENVIRONMENT="${1:-staging}"
BASE_URL="${BASE_URL:-https://staging.app-oint.com}"
API_BASE_URL="${API_BASE_URL:-https://staging.app-oint.com/api}"
DASHBOARD_URL="${DASHBOARD_URL:-https://staging.app-oint.com/dashboard}"
MARKETING_URL="${MARKETING_URL:-https://staging.app-oint.com}"

# Test configuration
TEST_DURATION="${TEST_DURATION:-38m}" # Total duration from k6 script
MAX_VUS="${MAX_VUS:-10000}"
THRESHOLDS_FILE="${SCRIPT_DIR}/thresholds.json"
RESULTS_FILE="${TEST_RESULTS_DIR}/load-test-results-${TIMESTAMP}.json"
HTML_REPORT="${TEST_RESULTS_DIR}/load-test-report-${TIMESTAMP}.html"

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

# Create necessary directories
mkdir -p "${TEST_RESULTS_DIR}"

log "INFO" "🚀 Starting App-Oint Load Test"
log "INFO" "Environment: ${ENVIRONMENT}"
log "INFO" "Base URL: ${BASE_URL}"
log "INFO" "Max VUs: ${MAX_VUS}"
log "INFO" "Duration: ${TEST_DURATION}"

# Check if k6 is installed
if ! command -v k6 >/dev/null 2>&1; then
    log "ERROR" "k6 is not installed. Please install k6 first."
    echo "Visit: https://k6.io/docs/getting-started/installation/"
    exit 1
fi

# Check if jq is installed (for JSON processing)
if ! command -v jq >/dev/null 2>&1; then
    log "WARN" "jq is not installed. JSON result processing will be limited."
fi

# Pre-flight health checks
log "INFO" "🔍 Running pre-flight health checks..."

health_check_url() {
    local url=$1
    local name=$2
    
    local response_code
    if response_code=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url" 2>/dev/null); then
        if [[ "$response_code" =~ ^2[0-9][0-9]$ ]]; then
            log "INFO" "✅ ${name}: HTTP ${response_code}"
            return 0
        else
            log "WARN" "⚠️ ${name}: HTTP ${response_code}"
            return 1
        fi
    else
        log "ERROR" "❌ ${name}: Connection failed"
        return 1
    fi
}

# Check all endpoints
HEALTH_CHECK_FAILED=0

health_check_url "${API_BASE_URL}/health" "API Health" || HEALTH_CHECK_FAILED=1
health_check_url "${DASHBOARD_URL}/" "Dashboard" || HEALTH_CHECK_FAILED=1
health_check_url "${MARKETING_URL}/" "Marketing Site" || HEALTH_CHECK_FAILED=1

if [[ $HEALTH_CHECK_FAILED -eq 1 ]]; then
    log "ERROR" "❌ Pre-flight health checks failed. Aborting load test."
    exit 1
fi

log "INFO" "✅ All pre-flight health checks passed"

# Create k6 configuration
cat > "${SCRIPT_DIR}/k6-config.json" << EOF
{
  "scenarios": {
    "load_test": {
      "executor": "ramping-vus",
      "startVUs": 0,
      "stages": [
        { "duration": "2m", "target": 1000 },
        { "duration": "3m", "target": 1000 },
        { "duration": "5m", "target": 5000 },
        { "duration": "5m", "target": 5000 },
        { "duration": "5m", "target": 10000 },
        { "duration": "10m", "target": 10000 },
        { "duration": "3m", "target": 5000 },
        { "duration": "3m", "target": 1000 },
        { "duration": "2m", "target": 0 }
      ],
      "gracefulRampDown": "30s"
    }
  },
  "thresholds": {
    "http_req_duration": ["p(95)<500", "p(99)<1000"],
    "http_req_failed": ["rate<0.01"],
    "error_rate": ["rate<0.01"]
  }
}
EOF

# Send notification about test start
send_slack_notification() {
    local status=$1
    local message=$2
    
    if [[ -n "${SLACK_WEBHOOK_URL:-}" ]]; then
        local color="good"
        local icon="🚀"
        
        if [[ "$status" == "started" ]]; then
            color="warning"
            icon="🚀"
        elif [[ "$status" == "completed" ]]; then
            color="good"
            icon="✅"
        elif [[ "$status" == "failed" ]]; then
            color="danger"
            icon="❌"
        fi
        
        local payload=$(cat <<EOF
{
    "channel": "#devops",
    "username": "App-Oint Load Test",
    "icon_emoji": ":chart_with_upwards_trend:",
    "attachments": [
        {
            "color": "$color",
            "title": "$icon Load Test $status",
            "fields": [
                {
                    "title": "Environment",
                    "value": "$ENVIRONMENT",
                    "short": true
                },
                {
                    "title": "Target Users",
                    "value": "$MAX_VUS",
                    "short": true
                },
                {
                    "title": "Duration",
                    "value": "$TEST_DURATION",
                    "short": true
                },
                {
                    "title": "Status",
                    "value": "$message",
                    "short": true
                }
            ],
            "footer": "App-Oint Load Testing",
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

# Send start notification
send_slack_notification "started" "Load test initiated against $ENVIRONMENT environment"

# Run the load test
log "INFO" "🏃 Running k6 load test..."

# Set environment variables for k6
export BASE_URL API_BASE_URL DASHBOARD_URL MARKETING_URL

# Run k6 with comprehensive output
if k6 run \
    --config="${SCRIPT_DIR}/k6-config.json" \
    --out json="${RESULTS_FILE}" \
    --summary-trend-stats="avg,min,med,max,p(90),p(95),p(99)" \
    --summary-time-unit=ms \
    "${SCRIPT_DIR}/k6-load-test.js" 2>&1 | tee -a "${LOG_FILE}"; then
    
    log "INFO" "✅ Load test completed successfully"
    TEST_STATUS="completed"
    TEST_MESSAGE="Load test completed successfully"
else
    log "ERROR" "❌ Load test failed"
    TEST_STATUS="failed"
    TEST_MESSAGE="Load test failed with errors"
fi

# Process results if jq is available
if command -v jq >/dev/null 2>&1 && [[ -f "$RESULTS_FILE" ]]; then
    log "INFO" "📊 Processing test results..."
    
    # Extract key metrics
    TOTAL_REQUESTS=$(jq '[.[] | select(.type=="Point" and .metric=="http_reqs")] | length' "$RESULTS_FILE" 2>/dev/null || echo "0")
    AVG_RESPONSE_TIME=$(jq '[.[] | select(.type=="Point" and .metric=="http_req_duration")] | map(.data.value) | add / length' "$RESULTS_FILE" 2>/dev/null || echo "0")
    ERROR_RATE=$(jq '[.[] | select(.type=="Point" and .metric=="http_req_failed")] | map(.data.value) | add / length * 100' "$RESULTS_FILE" 2>/dev/null || echo "0")
    
    # Create summary report
    cat > "${TEST_RESULTS_DIR}/load-test-summary-${TIMESTAMP}.txt" << EOF
App-Oint Load Test Summary
=========================
Date: $(date)
Environment: $ENVIRONMENT
Duration: $TEST_DURATION
Max Virtual Users: $MAX_VUS

Key Metrics:
- Total Requests: $TOTAL_REQUESTS
- Average Response Time: ${AVG_RESPONSE_TIME}ms
- Error Rate: ${ERROR_RATE}%

Test Status: $TEST_STATUS
EOF

    log "INFO" "📄 Summary report created: load-test-summary-${TIMESTAMP}.txt"
    
    # Check SLO compliance
    AVG_RESPONSE_INT=$(echo "$AVG_RESPONSE_TIME" | cut -d. -f1)
    ERROR_RATE_INT=$(echo "$ERROR_RATE" | cut -d. -f1)
    
    SLO_COMPLIANCE="PASS"
    if [[ $AVG_RESPONSE_INT -gt 500 ]]; then
        log "WARN" "⚠️ SLO VIOLATION: Average response time (${AVG_RESPONSE_TIME}ms) exceeds 500ms threshold"
        SLO_COMPLIANCE="FAIL"
    fi
    
    if [[ $ERROR_RATE_INT -gt 1 ]]; then
        log "WARN" "⚠️ SLO VIOLATION: Error rate (${ERROR_RATE}%) exceeds 1% threshold"
        SLO_COMPLIANCE="FAIL"
    fi
    
    if [[ "$SLO_COMPLIANCE" == "PASS" ]]; then
        log "INFO" "✅ All SLOs met"
        TEST_MESSAGE="$TEST_MESSAGE - All SLOs met"
    else
        log "ERROR" "❌ SLO violations detected"
        TEST_MESSAGE="$TEST_MESSAGE - SLO violations detected"
        TEST_STATUS="failed"
    fi
fi

# Generate HTML report if possible
if command -v python3 >/dev/null 2>&1; then
    log "INFO" "📈 Generating HTML report..."
    
    python3 << EOF
import json
import sys
from datetime import datetime

try:
    with open('$RESULTS_FILE', 'r') as f:
        data = [json.loads(line) for line in f if line.strip()]
    
    # Basic HTML report
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>App-Oint Load Test Report</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 20px; }}
            .header {{ color: #333; }}
            .metric {{ background: #f5f5f5; padding: 10px; margin: 10px 0; border-radius: 5px; }}
            .pass {{ color: green; }}
            .fail {{ color: red; }}
        </style>
    </head>
    <body>
        <h1 class="header">App-Oint Load Test Report</h1>
        <p><strong>Date:</strong> {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
        <p><strong>Environment:</strong> $ENVIRONMENT</p>
        <p><strong>Max Users:</strong> $MAX_VUS</p>
        <p><strong>Duration:</strong> $TEST_DURATION</p>
        
        <div class="metric">
            <h3>Test Status: <span class="${'pass' if '$TEST_STATUS' == 'completed' else 'fail'}">${TEST_STATUS.upper()}</span></h3>
        </div>
        
        <div class="metric">
            <h3>SLO Compliance: <span class="${'pass' if '$SLO_COMPLIANCE' == 'PASS' else 'fail'}">${SLO_COMPLIANCE}</span></h3>
        </div>
        
        <p>For detailed metrics, see the JSON results file.</p>
    </body>
    </html>
    """
    
    with open('$HTML_REPORT', 'w') as f:
        f.write(html_content)
    
    print("HTML report generated successfully")
    
except Exception as e:
    print(f"Error generating HTML report: {e}")
    sys.exit(1)
EOF

    if [[ $? -eq 0 ]]; then
        log "INFO" "📄 HTML report created: $(basename "$HTML_REPORT")"
    fi
fi

# Send completion notification
send_slack_notification "$TEST_STATUS" "$TEST_MESSAGE"

# Cleanup
rm -f "${SCRIPT_DIR}/k6-config.json"

log "INFO" "🏁 Load test process completed"
log "INFO" "📁 Results saved in: $TEST_RESULTS_DIR"

# Exit with appropriate code
if [[ "$TEST_STATUS" == "completed" && "$SLO_COMPLIANCE" == "PASS" ]]; then
    exit 0
else
    exit 1
fi