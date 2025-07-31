#!/bin/bash
set -e
git pull origin main
flutter build web
doctl apps create-deployment 620a2ee8-e942-451c-9cfd-8ece55511eb8 --wait
echo "Import Grafana JSON" # manually import grafana/app-oint-production-metrics.json
echo "Apply monitoring configs"
kubectl apply -f monitoring/alertmanager.yaml
kubectl apply -f monitoring/prometheus-rules.yaml
echo "Scheduling DR drill..."
crontab -l | grep -v 'dr_drill.sh' | crontab -
(crontab -l 2>/dev/null; echo "0 10 1 1,4,7,10 * $(pwd)/scripts/dr_drill.sh") | crontab -
echo "Setup feature-flags"
npm install ioredis express
echo "✅ All done" 