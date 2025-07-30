#!/bin/bash

# Build and Push Flutter Docker Image Script
# This script builds the Flutter CI Docker image and pushes it to DigitalOcean Container Registry

set -e

echo "🔨 Building Flutter Docker image..."

# Build the Docker image
docker build -t appoint/flutter-ci:3.32.5 infrastructure/flutter_ci

# Tag for DigitalOcean Container Registry
echo "🏷️ Tagging images..."
docker tag appoint/flutter-ci:3.32.5 registry.digitalocean.com/appoint/flutter-ci:3.32.5
docker tag registry.digitalocean.com/appoint/flutter-ci:3.32.5 registry.digitalocean.com/appoint/flutter-ci:latest

# Push to DigitalOcean Container Registry
echo "📤 Pushing to DigitalOcean Container Registry..."
docker push registry.digitalocean.com/appoint/flutter-ci:3.32.5
docker push registry.digitalocean.com/appoint/flutter-ci:latest

echo "✅ Flutter Docker image built and pushed successfully!"
echo "📋 Version: 3.32.5"
echo "🏷️ Tags: 3.32.5, latest"
echo "📍 Registry: registry.digitalocean.com/appoint/flutter-ci"