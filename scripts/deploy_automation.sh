#!/bin/bash

echo "🚀 Starting DigitalOcean App Platform Deployment..."

# Step 1: Check required environment variables
if [ -z "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
    echo "❌ DIGITALOCEAN_ACCESS_TOKEN is not set"
    exit 1
fi

if [ -z "$APP_ID" ]; then
    echo "❌ APP_ID is not set"
    exit 1
fi

echo "✅ Environment variables validated"

# Step 1: Initialize doctl authentication
echo "🔐 Initializing DigitalOcean authentication..."
doctl auth init --access-token "$DIGITALOCEAN_ACCESS_TOKEN"

if [ $? -ne 0 ]; then
    echo "❌ DigitalOcean authentication failed"
    exit 1
fi

echo "✅ DigitalOcean authentication successful"

# Step 2: Trigger deployment
echo "📦 Triggering deployment for app: $APP_ID"
doctl apps create-deployment "$APP_ID"

if [ $? -ne 0 ]; then
    echo "❌ Failed to trigger deployment"
    exit 1
fi

echo "✅ Deployment triggered successfully"

# Step 3: Monitor logs and check for success
echo "📋 Monitoring deployment logs..."
doctl apps logs "$APP_ID" --type deploy --follow &
LOG_PID=$!

# Wait for logs and check for success indicators
timeout 600 bash -c '
while true; do
    LOGS=$(doctl apps logs $APP_ID --type deploy --tail 50)
    if echo "$LOGS" | grep -q "Build succeeded" && echo "$LOGS" | grep -q "Deployment succeeded"; then
        echo "✅ Build and deployment succeeded!"
        exit 0
    elif echo "$LOGS" | grep -q "Build failed\|Deployment failed\|Error"; then
        echo "❌ Build or deployment failed!"
        echo "$LOGS"
        exit 1
    fi
    sleep 10
done'

RESULT=$?
kill $LOG_PID 2>/dev/null

if [ $RESULT -eq 0 ]; then
    echo "✅ Deployment completed successfully"
    
    # Step 4: Verify API endpoint
    echo "🔍 Verifying API endpoint..."
    sleep 30  # Give some time for the app to start
    
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://api.app-oint.com/status)
    
    if [ "$HTTP_CODE" = "200" ]; then
        echo "✅ פריסה בוצעה בהצלחה"
    else
        echo "❌ API endpoint returned HTTP $HTTP_CODE"
        curl -s https://api.app-oint.com/status
    fi
else
    echo "❌ Deployment failed or timed out"
    exit 1
fi
