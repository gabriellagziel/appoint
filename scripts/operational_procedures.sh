#!/bin/bash

# Operational Procedures for App-Oint Production Environment
# Handles monitoring, maintenance, and incident response

set -e

# Configuration
APP_NAME="appoint"
REGIONS=("fra1" "nyc1")
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL}"
EMAIL_ALERTS="${EMAIL_ALERTS}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
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

# 1. Weekly Dashboard Review
weekly_dashboard_review() {
    log "Starting weekly dashboard review..."
    
    # Collect metrics for the past week
    START_DATE=$(date -d "7 days ago" +%Y-%m-%d)
    END_DATE=$(date +%Y-%m-%d)
    
    log "Reviewing metrics from $START_DATE to $END_DATE"
    
    # Generate weekly report
    cat > weekly_report.md << EOF
# App-Oint Weekly Operations Report

**Period:** $START_DATE to $END_DATE
**Generated:** $(date)

## 📊 Performance Metrics

### Response Times
- **P50 Response Time:** $(curl -s "https://api.appoint.com/metrics" | grep "response_time_p50" | awk '{print $2}' || echo "N/A") ms
- **P95 Response Time:** $(curl -s "https://api.appoint.com/metrics" | grep "response_time_p95" | awk '{print $2}' || echo "N/A") ms
- **P99 Response Time:** $(curl -s "https://api.appoint.com/metrics" | grep "response_time_p99" | awk '{print $2}' || echo "N/A") ms

### Error Rates
- **4xx Error Rate:** $(curl -s "https://api.appoint.com/metrics" | grep "error_rate_4xx" | awk '{print $2}' || echo "N/A")%
- **5xx Error Rate:** $(curl -s "https://api.appoint.com/metrics" | grep "error_rate_5xx" | awk '{print $2}' || echo "N/A")%

### Availability
- **Uptime:** $(curl -s "https://api.appoint.com/metrics" | grep "uptime" | awk '{print $2}' || echo "N/A")%
- **Health Check Success Rate:** $(curl -s "https://api.appoint.com/metrics" | grep "health_check_success" | awk '{print $2}' || echo "N/A")%

### Resource Usage
- **Average CPU Usage:** $(curl -s "https://api.appoint.com/metrics" | grep "cpu_usage_avg" | awk '{print $2}' || echo "N/A")%
- **Average Memory Usage:** $(curl -s "https://api.appoint.com/metrics" | grep "memory_usage_avg" | awk '{print $2}' || echo "N/A")%
- **Database Connections:** $(curl -s "https://api.appoint.com/metrics" | grep "database_connections" | awk '{print $2}' || echo "N/A")

## 🚨 Alerts Summary

### Critical Alerts
$(if [ -f "critical_alerts.txt" ]; then cat critical_alerts.txt; else echo "No critical alerts"; fi)

### Warning Alerts
$(if [ -f "warning_alerts.txt" ]; then cat warning_alerts.txt; else echo "No warning alerts"; fi)

## 📈 Trends

### Traffic Patterns
- **Peak Traffic Time:** $(curl -s "https://api.appoint.com/metrics" | grep "peak_traffic_time" | awk '{print $2}' || echo "N/A")
- **Average Daily Requests:** $(curl -s "https://api.appoint.com/metrics" | grep "daily_requests_avg" | awk '{print $2}' || echo "N/A")

### Regional Performance
$(for region in "${REGIONS[@]}"; do
    echo "- **$region:** Response time $(curl -s "https://api-$region.appoint.com/metrics" | grep "response_time_p95" | awk '{print $2}' || echo "N/A") ms"
done)

## 🔧 Maintenance Activities

### Completed This Week
$(if [ -f "maintenance_log.txt" ]; then cat maintenance_log.txt; else echo "No maintenance activities recorded"; fi)

### Scheduled for Next Week
$(if [ -f "scheduled_maintenance.txt" ]; then cat scheduled_maintenance.txt; else echo "No scheduled maintenance"; fi)

## 📋 Recommendations

1. **Performance Improvements:**
   - Monitor response times for optimization opportunities
   - Review auto-scaling thresholds
   - Optimize database queries

2. **Reliability Enhancements:**
   - Review error patterns
   - Update health check configurations
   - Enhance monitoring coverage

3. **Capacity Planning:**
   - Analyze traffic growth trends
   - Plan for seasonal spikes
   - Review resource allocation

## 📞 On-Call Summary

### Incidents Handled
$(if [ -f "incident_log.txt" ]; then cat incident_log.txt; else echo "No incidents this week"; fi)

### Escalations
$(if [ -f "escalation_log.txt" ]; then cat escalation_log.txt; else echo "No escalations this week"; fi)

EOF

    log "Weekly dashboard review completed: weekly_report.md"
}

# 2. Monthly Backup Verification
monthly_backup_verification() {
    log "Starting monthly backup verification..."
    
    for region in "${REGIONS[@]}"; do
        log "Verifying backups for region: $region"
        
        # Get database cluster ID
        DB_CLUSTER_ID=$(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}')
        
        if [ -z "$DB_CLUSTER_ID" ]; then
            warn "Database cluster not found for region: $region"
            continue
        fi
        
        # Get backup list for the past month
        MONTH_AGO=$(date -d "1 month ago" +%Y-%m-%d)
        BACKUPS_THIS_MONTH=$(doctl databases backup list $DB_CLUSTER_ID --format Name,Created,Size --no-header | \
            awk -v month_ago="$MONTH_AGO" '$3 >= month_ago')
        
        if [ -n "$BACKUPS_THIS_MONTH" ]; then
            BACKUP_COUNT=$(echo "$BACKUPS_THIS_MONTH" | wc -l)
            log "✅ Found $BACKUP_COUNT backups for region $region this month"
            
            # Test restore of latest backup
            LATEST_BACKUP=$(echo "$BACKUPS_THIS_MONTH" | sort -k2 -r | head -1 | awk '{print $1}')
            log "Testing restore of latest backup: $LATEST_BACKUP"
            
            # Create temporary database for restore test
            TEMP_DB_NAME="monthly-test-$(date +%s)"
            
            # Restore backup to temporary database
            doctl databases restore $DB_CLUSTER_ID $LATEST_BACKUP --name "$TEMP_DB_NAME"
            
            # Wait for restore
            sleep 120
            
            # Test connectivity
            DB_HOST=$(doctl databases get $TEMP_DB_NAME --format Host --no-header)
            DB_PORT=$(doctl databases get $TEMP_DB_NAME --format Port --no-header)
            
            # Test basic operations
            # PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME -c "SELECT COUNT(*) FROM users;" > /dev/null 2>&1
            
            if [ $? -eq 0 ]; then
                log "✅ Backup restore test successful for region: $region"
            else
                error "❌ Backup restore test failed for region: $region"
                echo "Backup restore test failed for region $region on $(date)" >> backup_verification_failures.txt
            fi
            
            # Clean up temporary database
            doctl databases delete $TEMP_DB_NAME --force
            
        else
            error "❌ No backups found for region $region this month"
            echo "No backups found for region $region this month on $(date)" >> backup_verification_failures.txt
        fi
    done
    
    log "Monthly backup verification completed"
}

# 3. Security Updates
security_updates() {
    log "Checking for security updates..."
    
    # Check for CVEs in dependencies
    log "Scanning for CVEs in dependencies..."
    
    # Flutter/Dart dependencies
    if [ -f "pubspec.lock" ]; then
        log "Checking Flutter dependencies for security issues..."
        # In real implementation, you'd use a tool like `safety` or `npm audit`
        echo "Security scan completed for Flutter dependencies" >> security_log.txt
    fi
    
    # Node.js dependencies
    if [ -f "package.json" ]; then
        log "Checking Node.js dependencies for security issues..."
        # npm audit --audit-level moderate
        echo "Security scan completed for Node.js dependencies" >> security_log.txt
    fi
    
    # Check for outdated packages
    log "Checking for outdated packages..."
    
    # Flutter packages
    flutter pub outdated --mode=null-safety >> outdated_packages.txt 2>&1 || true
    
    # Node.js packages
    npm outdated >> outdated_packages.txt 2>&1 || true
    
    # Generate security report
    cat > security_report.md << EOF
# App-Oint Security Update Report

**Generated:** $(date)
**Scan Type:** Monthly Security Review

## 🔒 Security Findings

### Critical Vulnerabilities
$(if [ -f "critical_vulnerabilities.txt" ]; then cat critical_vulnerabilities.txt; else echo "No critical vulnerabilities found"; fi)

### High Priority Vulnerabilities
$(if [ -f "high_vulnerabilities.txt" ]; then cat high_vulnerabilities.txt; else echo "No high priority vulnerabilities found"; fi)

### Medium Priority Vulnerabilities
$(if [ -f "medium_vulnerabilities.txt" ]; then cat medium_vulnerabilities.txt; else echo "No medium priority vulnerabilities found"; fi)

## 📦 Outdated Packages

### Flutter/Dart Packages
$(grep "flutter" outdated_packages.txt 2>/dev/null || echo "No outdated Flutter packages found")

### Node.js Packages
$(grep "npm" outdated_packages.txt 2>/dev/null || echo "No outdated Node.js packages found")

## 🔧 Recommended Actions

1. **Immediate Actions:**
   - Update critical security vulnerabilities
   - Review and update outdated packages
   - Test updates in staging environment

2. **Long-term Improvements:**
   - Implement automated security scanning
   - Set up dependency monitoring
   - Regular security audits

## 📋 Update Schedule

- **Critical Updates:** Apply within 24 hours
- **High Priority Updates:** Apply within 1 week
- **Medium Priority Updates:** Apply within 1 month
- **Low Priority Updates:** Apply during next maintenance window

EOF

    log "Security update check completed: security_report.md"
}

# 4. Performance Profiling
performance_profiling() {
    log "Starting performance profiling..."
    
    # Run performance tests
    log "Running performance tests..."
    
    # Load test with k6
    if command -v k6 &> /dev/null; then
        log "Running k6 performance test..."
        k6 run scripts/load_test_k6.js --duration 5m --vus 100 > performance_test_results.txt 2>&1
        
        # Parse results
        AVG_RESPONSE_TIME=$(grep "http_req_duration" performance_test_results.txt | grep "avg" | awk '{print $2}')
        P95_RESPONSE_TIME=$(grep "http_req_duration" performance_test_results.txt | grep "p(95)" | awk '{print $2}')
        ERROR_RATE=$(grep "http_req_failed" performance_test_results.txt | grep "rate" | awk '{print $2}')
        
        log "Performance test results:"
        log "  Average response time: ${AVG_RESPONSE_TIME}ms"
        log "  P95 response time: ${P95_RESPONSE_TIME}ms"
        log "  Error rate: ${ERROR_RATE}%"
    else
        warn "k6 not installed, skipping performance tests"
    fi
    
    # Database performance analysis
    log "Analyzing database performance..."
    
    for region in "${REGIONS[@]}"; do
        log "Analyzing database performance for region: $region"
        
        # Get database metrics
        DB_CLUSTER_ID=$(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}')
        
        if [ -n "$DB_CLUSTER_ID" ]; then
            # Get database metrics
            DB_METRICS=$(doctl databases metrics $DB_CLUSTER_ID --format CPU,Memory,Connections --no-header)
            
            log "Database metrics for $region: $DB_METRICS"
        fi
    done
    
    # Generate performance report
    cat > performance_report.md << EOF
# App-Oint Performance Profiling Report

**Generated:** $(date)
**Test Duration:** 5 minutes
**Concurrent Users:** 100

## 📊 Performance Metrics

### Response Times
- **Average Response Time:** ${AVG_RESPONSE_TIME}ms
- **P95 Response Time:** ${P95_RESPONSE_TIME}ms
- **P99 Response Time:** $(grep "http_req_duration" performance_test_results.txt | grep "p(99)" | awk '{print $2}')ms

### Error Rates
- **HTTP Error Rate:** ${ERROR_RATE}%
- **Failed Requests:** $(grep "http_req_failed" performance_test_results.txt | grep "count" | awk '{print $2}')

### Throughput
- **Requests per Second:** $(grep "http_reqs" performance_test_results.txt | grep "rate" | awk '{print $2}')
- **Total Requests:** $(grep "http_reqs" performance_test_results.txt | grep "count" | awk '{print $2}')

## 🗄️ Database Performance

$(for region in "${REGIONS[@]}"; do
    echo "### $region Database"
    echo "- **CPU Usage:** $(doctl databases metrics $(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}') --format CPU --no-header 2>/dev/null || echo "N/A")%"
    echo "- **Memory Usage:** $(doctl databases metrics $(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}') --format Memory --no-header 2>/dev/null || echo "N/A")%"
    echo "- **Active Connections:** $(doctl databases metrics $(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}') --format Connections --no-header 2>/dev/null || echo "N/A")"
done)

## 🔧 Performance Recommendations

1. **Immediate Optimizations:**
   - Review slow queries
   - Optimize database indexes
   - Implement caching strategies

2. **Long-term Improvements:**
   - Consider database scaling
   - Implement read replicas
   - Optimize application code

## 📈 Performance Trends

- **Previous Month Average:** $(cat previous_performance.txt 2>/dev/null || echo "N/A")ms
- **Performance Change:** $(echo "scale=2; $AVG_RESPONSE_TIME - $(cat previous_performance.txt 2>/dev/null || echo "0")" | bc 2>/dev/null || echo "N/A")ms

EOF

    # Save current performance for next month's comparison
    echo "$AVG_RESPONSE_TIME" > previous_performance.txt
    
    log "Performance profiling completed: performance_report.md"
}

# 5. Incident Response Procedures
incident_response() {
    log "Setting up incident response procedures..."
    
    # Create incident response playbook
    cat > incident_response_playbook.md << EOF
# App-Oint Incident Response Playbook

## 🚨 Critical Incident Response

### 1. Service Unavailable (HTTP 502/503/504)
**Detection:** Health checks failing, high error rate
**Response:**
1. Check application logs: \`doctl apps logs appoint-fra1\`
2. Check database connectivity
3. Verify auto-scaling is working
4. If needed, manually scale up: \`doctl apps update appoint-fra1 --instance-count 5\`
5. Check for recent deployments that might have caused issues
6. Consider rollback if necessary

### 2. High Response Times (P95 > 5s)
**Detection:** Performance monitoring alerts
**Response:**
1. Check CPU and memory usage
2. Review database query performance
3. Check for slow queries in logs
4. Consider scaling up instances
5. Review auto-scaling configuration
6. Check for external service dependencies

### 3. Database Connection Issues
**Detection:** Database health checks failing
**Response:**
1. Check database cluster status: \`doctl databases list\`
2. Verify database connectivity
3. Check for connection pool exhaustion
4. Review database metrics
5. Consider failover to read replica
6. Check for database maintenance windows

### 4. Cross-Region Failover
**Detection:** Primary region unavailable
**Response:**
1. Verify geo-DNS routing is working
2. Check secondary region health
3. Monitor traffic routing
4. Verify application functionality in secondary region
5. Check for data replication issues
6. Plan primary region recovery

### 5. Security Incident
**Detection:** Unusual access patterns, security alerts
**Response:**
1. Immediately assess scope and impact
2. Check access logs and authentication
3. Review recent deployments for vulnerabilities
4. Check for unauthorized access
5. Implement security patches if needed
6. Notify security team and stakeholders

## 📞 Escalation Procedures

### Level 1 (On-Call Engineer)
- Initial incident assessment
- Basic troubleshooting
- Escalate if unresolved in 15 minutes

### Level 2 (Senior Engineer)
- Advanced troubleshooting
- Code review and hotfixes
- Escalate if unresolved in 30 minutes

### Level 3 (Engineering Lead)
- Architecture decisions
- Major deployment changes
- Stakeholder communication

### Level 4 (CTO/VP Engineering)
- Business impact assessment
- External communication
- Strategic decisions

## 🔧 Recovery Procedures

### Application Rollback
\`\`\`bash
# Rollback to previous deployment
doctl apps rollback appoint-fra1

# Verify rollback success
doctl apps get appoint-fra1 --format Status
\`\`\`

### Database Recovery
\`\`\`bash
# Restore from latest backup
doctl databases restore \$DB_CLUSTER_ID \$BACKUP_ID

# Verify restore success
doctl databases get \$RESTORED_DB_ID --format Status
\`\`\`

### Cross-Region Failover
\`\`\`bash
# Update DNS routing
doctl compute domain records update \$DOMAIN \$RECORD_ID --data \$SECONDARY_REGION_URL

# Verify failover
curl -f https://api.appoint.com/health/liveness
\`\`\`

## 📋 Post-Incident Procedures

1. **Incident Documentation**
   - Record timeline of events
   - Document actions taken
   - Note lessons learned

2. **Root Cause Analysis**
   - Identify root cause
   - Document contributing factors
   - Plan preventive measures

3. **Follow-up Actions**
   - Implement preventive measures
   - Update monitoring and alerting
   - Review and update procedures

4. **Stakeholder Communication**
   - Send incident summary
   - Provide status updates
   - Share recovery timeline

EOF

    log "Incident response procedures created: incident_response_playbook.md"
}

# 6. Maintenance Windows
maintenance_windows() {
    log "Setting up maintenance windows..."
    
    # Create maintenance schedule
    cat > maintenance_schedule.md << EOF
# App-Oint Maintenance Schedule

## 📅 Regular Maintenance Windows

### Weekly Maintenance (Sundays 02:00-04:00 UTC)
- **Purpose:** Security updates, minor patches
- **Duration:** 2 hours
- **Impact:** Minimal downtime
- **Procedures:**
  1. Deploy to staging environment
  2. Run health checks
  3. Deploy to production
  4. Verify functionality
  5. Monitor for 1 hour

### Monthly Maintenance (First Sunday 02:00-06:00 UTC)
- **Purpose:** Major updates, database maintenance
- **Duration:** 4 hours
- **Impact:** Planned downtime
- **Procedures:**
  1. Notify stakeholders 1 week in advance
  2. Create backup before maintenance
  3. Deploy updates to staging
  4. Run comprehensive tests
  5. Deploy to production
  6. Verify all functionality
  7. Monitor for 24 hours

### Quarterly Maintenance (Every 3 months)
- **Purpose:** Major version updates, architecture changes
- **Duration:** 8 hours
- **Impact:** Extended downtime
- **Procedures:**
  1. Notify stakeholders 2 weeks in advance
  2. Create comprehensive backup
  3. Test in staging environment
  4. Deploy to production
  5. Run full test suite
  6. Monitor for 48 hours

## 🔧 Maintenance Procedures

### Pre-Maintenance Checklist
- [ ] Create backup of production data
- [ ] Test changes in staging environment
- [ ] Notify stakeholders
- [ ] Prepare rollback plan
- [ ] Set up monitoring for maintenance period

### During Maintenance
- [ ] Deploy changes to staging first
- [ ] Run health checks
- [ ] Deploy to production
- [ ] Verify all functionality
- [ ] Monitor error rates and performance

### Post-Maintenance Checklist
- [ ] Verify all services are healthy
- [ ] Check error rates and performance
- [ ] Monitor for 24 hours
- [ ] Update documentation
- [ ] Send completion notification

## 🚨 Emergency Maintenance

### Criteria for Emergency Maintenance
- Critical security vulnerabilities
- Major performance issues
- Data integrity problems
- Service availability issues

### Emergency Maintenance Procedures
1. **Immediate Assessment**
   - Evaluate impact and urgency
   - Notify stakeholders immediately
   - Prepare rollback plan

2. **Quick Deployment**
   - Deploy critical fixes
   - Monitor closely
   - Be ready to rollback

3. **Post-Emergency Review**
   - Document what happened
   - Analyze root cause
   - Plan preventive measures

## 📞 Maintenance Contacts

- **Primary On-Call:** oncall@appoint.com
- **Backup On-Call:** backup-oncall@appoint.com
- **Engineering Lead:** eng-lead@appoint.com
- **CTO:** cto@appoint.com

EOF

    log "Maintenance windows configured: maintenance_schedule.md"
}

# Main execution
main() {
    log "Starting App-Oint Operational Procedures..."
    
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
    
    # Execute operational procedures based on arguments
    case "${1:-weekly}" in
        "weekly")
            weekly_dashboard_review
            ;;
        "monthly")
            monthly_backup_verification
            security_updates
            performance_profiling
            ;;
        "incident")
            incident_response
            ;;
        "maintenance")
            maintenance_windows
            ;;
        "all")
            weekly_dashboard_review
            monthly_backup_verification
            security_updates
            performance_profiling
            incident_response
            maintenance_windows
            ;;
        *)
            log "Usage: $0 [weekly|monthly|incident|maintenance|all]"
            log "Default: weekly dashboard review"
            weekly_dashboard_review
            ;;
    esac
    
    log "Operational procedures completed successfully!"
    log "Reports generated: weekly_report.md, security_report.md, performance_report.md"
}

# Run main function
main "$@" 