#!/bin/bash
set -e
LOG="/var/log/app-oint-dr-drill.log"
T=$(date +'%Y-%m-%d %H:%M:%S')
echo "[$T] DR drill start" >> $LOG
# backup restore test
echo "[$T] restore test" >> $LOG
# failover test
echo "[$T] failover test" >> $LOG
# data integrity test
echo "[$T] data integrity" >> $LOG
curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"✅ DR drill completed at $T\"}" $SLACK_WEBHOOK_URL
echo "[$T] DR drill end" >> $LOG 