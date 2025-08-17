#!/bin/bash

echo "🧪 Testing Health Endpoints..."

# Test marketing app health endpoint
echo "=== Testing Marketing App ==="
cd marketing
npm start > /dev/null 2>&1 &
MARKETING_PID=$!
cd ..

echo "Waiting for marketing app to start..."
sleep 10

echo "Testing marketing health endpoint..."
if curl -s http://localhost:3000/api/health/ | grep -q "status.*ok"; then
    echo "✅ Marketing health endpoint working"
else
    echo "❌ Marketing health endpoint failed"
    curl -s http://localhost:3000/api/health/
fi

# Cleanup
kill $MARKETING_PID 2>/dev/null
echo "Test complete!"
