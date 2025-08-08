#!/bin/bash
echo "🚀 App-Oint PWA Smoke Test"
echo "Testing: $1"
curl -I "$1" | head -3
curl -I "$1/manifest.json" | head -3
curl -I "$1/sw.js" | head -3
