#!/bin/bash
set -e

echo "⚠️ Rolling back Firebase Hosting..."
firebase hosting:rollback

echo "⚠️ Rolling back DigitalOcean/Nginx..."
# Replace /backup/path with your backup build location
ssh user@your-server "rsync -av /var/www/backup/app.app-oint.com/ /var/www/app.app-oint.com/ && sudo nginx -s reload"

echo "✅ Rollback complete."
