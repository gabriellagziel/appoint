#!/bin/bash

echo "🚀 Starting Firebase deployment for app-oint.com..."

# Ensure you're in the correct directory
if [ ! -f "firebase.json" ]; then
  echo "❌ firebase.json not found. Make sure you're in the project root."
  exit 1
fi

# Use the production environment variables if needed
if [ -f ".env.production" ]; then
  echo "✅ Using .env.production"
fi

# Run Flutter build (optional if using Flutter web)
if [ -d "web" ]; then
  echo "📦 Running flutter build web..."
  flutter build web || { echo "❌ Flutter build failed"; exit 1; }
fi

# Deploy to Firebase Hosting
echo "📡 Deploying to Firebase..."
firebase deploy --only hosting || { echo "❌ Firebase deploy failed"; exit 1; }

echo "✅ Deployment complete!"