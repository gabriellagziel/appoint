#!/bin/bash

# 🔧 DigitalOcean Internal Health Check Script
# Upload this script to your DigitalOcean droplet/container and execute

set -e

echo "🔧 DigitalOcean Internal Health Check Starting..."
echo "=================================================="
echo "Hostname: $(hostname)"
echo "Environment: $(whoami)@$(hostname)"
echo "Date: $(date)"
echo "Git Commit: $(git rev-parse HEAD 2>/dev/null | cut -c1-8 || echo 'N/A')"
echo ""

# Create reports directory
mkdir -p /tmp/health_reports

# Function to test endpoint
test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_code="${3:-200}"
    
    echo -n "Testing $name ($url)... "
    
    response=$(curl -s -o /dev/null -w "%{http_code},%{time_total}" "$url" 2>/dev/null || echo "000,0")
    http_code=$(echo $response | cut -d',' -f1)
    time_total=$(echo $response | cut -d',' -f2)
    
    if [ "$http_code" = "$expected_code" ] || [ "$http_code" = "200" ]; then
        echo "✅ OK ($http_code, ${time_total}s)"
        return 0
    else
        echo "❌ FAILED ($http_code, ${time_total}s)"
        return 1
    fi
}

# Test internal services (if running on same machine)
echo "🔍 Testing Internal Services:"
echo "=============================="

test_endpoint "Local Health" "http://localhost:8080/health" "200"
test_endpoint "Local Status" "http://localhost:8080/status" "200"
test_endpoint "Local API" "http://localhost:3000/api/status" "200"
test_endpoint "Admin Local" "http://localhost:3001/" "200"
test_endpoint "Business Local" "http://localhost:3002/" "200"

echo ""
echo "🌐 Testing External Services:"
echo "=============================="

# Test external services
test_endpoint "Main App" "https://app-oint.com/"
test_endpoint "Admin Route" "https://app-oint.com/admin"
test_endpoint "Business Route" "https://app-oint.com/business"
test_endpoint "API Status" "https://app-oint.com/api/status"
test_endpoint "Robots.txt" "https://app-oint.com/robots.txt"
test_endpoint "Sitemap" "https://app-oint.com/sitemap.xml"

echo ""
echo "🌍 Testing Subdomains:"
echo "======================"

test_endpoint "Admin Subdomain" "https://admin.app-oint.com/"
test_endpoint "Business Subdomain" "https://business.app-oint.com/"
test_endpoint "API Subdomain" "https://api.app-oint.com/status"

echo ""
echo "🔍 System Information:"
echo "======================"

echo "OS: $(cat /etc/os-release | grep PRETTY_NAME | cut -d'=' -f2 | tr -d '\"')"
echo "Memory: $(free -h | grep Mem | awk '{print $3"/"$2}')"
echo "Disk: $(df -h / | tail -1 | awk '{print $3"/"$2" ("$5" used)"}')"
echo "Load: $(uptime | grep -o 'load average.*' || echo 'N/A')"

# Check for running services
echo ""
echo "🔧 Running Services:"
echo "==================="

# Check for common ports
for port in 8080 3000 3001 3002 80 443; do
    if netstat -tuln 2>/dev/null | grep -q ":$port "; then
        echo "✅ Port $port is open"
    else
        echo "❌ Port $port is not listening"
    fi
done

# Check Docker containers if Docker is available
if command -v docker &> /dev/null; then
    echo ""
    echo "🐳 Docker Containers:"
    echo "===================="
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "No Docker access"
fi

# Check processes
echo ""
echo "🏃 Key Processes:"
echo "================="
ps aux | grep -E "(node|flutter|nginx|firebase)" | grep -v grep | head -10 || echo "No matching processes found"

# Network connectivity test
echo ""
echo "🌐 Network Connectivity:"
echo "========================"
ping -c 1 8.8.8.8 &>/dev/null && echo "✅ Internet connectivity OK" || echo "❌ No internet connectivity"
ping -c 1 app-oint.com &>/dev/null && echo "✅ Can reach app-oint.com" || echo "❌ Cannot reach app-oint.com"

# Generate timestamp for report
timestamp=$(date '+%Y%m%d_%H%M%S')
report_file="/tmp/health_reports/digitalocean_health_${timestamp}.txt"

echo ""
echo "📝 Saving detailed report to: $report_file"

# Save full report
{
    echo "DigitalOcean Internal Health Check Report"
    echo "========================================"
    echo "Generated: $(date)"
    echo "Hostname: $(hostname)"
    echo "Environment: $(whoami)@$(hostname)"
    echo ""
    
    # Re-run all tests and capture output
    bash "$0" 2>&1
    
} > "$report_file" 2>&1

echo "✅ Health check complete!"
echo "📋 Report saved to: $report_file"
echo ""
echo "📤 To view the report:"
echo "cat $report_file"
echo ""
echo "📤 To copy the report:"
echo "scp $(whoami)@$(hostname):$report_file ./digitalocean_health_report.txt"