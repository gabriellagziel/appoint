#!/bin/bash

# Slack notification script for App-Oint alerts

SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL}"
ALERT_TYPE="$1"
MESSAGE="$2"
SEVERITY="${3:-warning}"

if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "SLACK_WEBHOOK_URL not set"
    exit 1
fi

# Color based on severity
case $SEVERITY in
    "critical")
        COLOR="#FF0000"
        ;;
    "warning")
        COLOR="#FFA500"
        ;;
    "info")
        COLOR="#0000FF"
        ;;
    *)
        COLOR="#36A64F"
        ;;
esac

# Create Slack message
cat > /tmp/slack_message.json << JSON_EOF
{
    "attachments": [
        {
            "color": "$COLOR",
            "title": "App-Oint Alert: $ALERT_TYPE",
            "text": "$MESSAGE",
            "fields": [
                {
                    "title": "Environment",
                    "value": "Production",
                    "short": true
                },
                {
                    "title": "Timestamp",
                    "value": "$(date -u +'%Y-%m-%d %H:%M:%S UTC')",
                    "short": true
                }
            ],
            "footer": "App-Oint Monitoring System"
        }
    ]
}
JSON_EOF

# Send to Slack
curl -X POST -H 'Content-type: application/json' \
    --data @/tmp/slack_message.json \
    "$SLACK_WEBHOOK_URL"

rm /tmp/slack_message.json
