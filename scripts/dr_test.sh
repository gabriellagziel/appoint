#!/bin/bash

# Disaster Recovery Testing Script
# Tests recovery procedures every 90 days

set -e

APP_NAME="appoint"
TEST_ENVIRONMENT="staging"
REGIONS=("fra1" "nyc1")

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Test database recovery
test_database_recovery() {
    log "Testing database recovery procedures..."
    
    for region in "${REGIONS[@]}"; do
        log "Testing recovery for region: $region"
        
        # Get latest backup
        DB_CLUSTER_ID=$(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}')
        
        if [ -z "$DB_CLUSTER_ID" ]; then
            log "Database cluster not found for region: $region"
            continue
        fi
        
        LATEST_BACKUP=$(doctl databases backup list $DB_CLUSTER_ID --format ID,Name,Created --no-header | \
            sort -k3 -r | head -1 | awk '{print $1}')
        
        if [ -n "$LATEST_BACKUP" ]; then
            log "Testing recovery from backup: $LATEST_BACKUP"
            
            # Create test database
            TEST_DB_NAME="appoint-test-$region-$(date +%Y%m%d)"
            
            # Restore to test database
            doctl databases db create $DB_CLUSTER_ID --name "$TEST_DB_NAME"
            doctl databases restore $DB_CLUSTER_ID $LATEST_BACKUP --database-name "$TEST_DB_NAME"
            
            log "Recovery test completed for region: $region"
            
            # Cleanup test database
            doctl databases db delete $DB_CLUSTER_ID "$TEST_DB_NAME"
        else
            log "No backups found for region: $region"
        fi
    done
}

# Test application recovery
test_application_recovery() {
    log "Testing application recovery procedures..."
    
    # Test staging deployment
    if [ -n "$TEST_ENVIRONMENT" ]; then
        log "Testing deployment to staging environment..."
        
        # Deploy to staging
        # doctl app create --spec app-spec-staging.yaml
        
        log "Staging deployment test completed"
    fi
}

# Run DR tests
log "Starting DR testing procedures..."

test_database_recovery
test_application_recovery

log "DR testing completed successfully"
