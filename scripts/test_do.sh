#!/bin/bash
TOKEN="dop_v1451609af65235ca0ca866f5d410d772338ddcc642202d3053450URL="https://api.digitalocean.com/v2nt"

echo "Testing DigitalOcean token..."
echo Token: ${TOKEN:0:20}..."
echo "URL: $URL
response=$(curl -s -w "HTTP_STATUS:%{http_code}" -H "Authorization: Bearer $TOKEN" "$URL")
http_status=$(echo $response" | grep -oHTTP_STATUS:[0-9*" | cut -d: -f2)
body=$(echo$response" | sed s/HTTP_STATUS:[0-9]*//')

echo "HTTP Status: $http_status"
echo Response: $body