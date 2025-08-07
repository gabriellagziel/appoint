#!/bin/bash

# Automated backup script for App-Oint
# Runs daily and creates backups with 14-day retention

set -e

APP_NAME="appoint"
REGIONS=("fra1" "nyc1")
BACKUP_RETENTION_DAYS=14
BACKUP_DIR="/backups/appoint"

# Create backup directory
mkdir -p $BACKUP_DIR

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Create backup for each region
for region in "${REGIONS[@]}"; do
    log "Creating backup for region: $region"
    
    # Get database cluster ID
    DB_CLUSTER_ID=$(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}')
    
    if [ -z "$DB_CLUSTER_ID" ]; then
        log "Database cluster not found for region: $region"
        continue
    fi
    
    # Create backup
    BACKUP_NAME="appoint-db-$region-$(date +%Y%m%d-%H%M%S)"
    
    doctl databases backup create $DB_CLUSTER_ID --name "$BACKUP_NAME"
    
    log "Backup created: $BACKUP_NAME for region $region"
    
    # Verify backup
    BACKUP_ID=$(doctl databases backup list $DB_CLUSTER_ID --format ID,Name --no-header | grep "$BACKUP_NAME" | awk '{print $1}')
    
    if [ -n "$BACKUP_ID" ]; then
        log "Backup verification successful: $BACKUP_ID"
    else
        log "Backup verification failed for region: $region"
    fi
done

# Cleanup old backups
log "Cleaning up old backups (older than $BACKUP_RETENTION_DAYS days)..."

for region in "${REGIONS[@]}"; do
    log "Cleaning backups for region: $region"
    
    DB_CLUSTER_ID=$(doctl databases list --format ID,Name --no-header | grep "appoint-db-$region" | awk '{print $1}')
    
    if [ -z "$DB_CLUSTER_ID" ]; then
        log "Database cluster not found for region: $region"
        continue
    fi
    
    # Get list of backups older than retention period
    OLD_BACKUPS=$(doctl databases backup list $DB_CLUSTER_ID --format ID,Name,Created --no-header | \
        awk -v retention="$BACKUP_RETENTION_DAYS" '
        {
            split($3, date, "T");
            split(date[1], ymd, "-");
            backup_date = mktime(ymd[1] " " ymd[2] " " ymd[3] " 0 0 0");
            current_date = systime();
            days_old = (current_date - backup_date) / 86400;
            if (days_old > retention) print $1;
        }')
    
    if [ -n "$OLD_BACKUPS" ]; then
        for backup_id in $OLD_BACKUPS; do
            log "Deleting old backup: $backup_id"
            doctl databases backup delete $DB_CLUSTER_ID $backup_id
        done
    fi
done

log "Backup procedure completed"
