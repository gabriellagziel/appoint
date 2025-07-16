#!/bin/bash

# Update Flutter Docker Image Script
# This script fetches the latest Flutter version and rebuilds the Docker image

set -e

echo "🔄 Starting Flutter Docker image update..."

# Fetch latest Flutter version
LATEST=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | jq -r '.current_release.stable')
FLUTTER_VERSION=$(curl -s https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json | jq -r ".releases[] | select(.hash == \"$LATEST\") | .version")

echo "📦 Latest Flutter version: $FLUTTER_VERSION"

# Build new Docker image
echo "🔨 Building Docker image with Flutter $FLUTTER_VERSION..."
docker build --build-arg FLUTTER_VERSION=$FLUTTER_VERSION -t appoint/flutter-ci:$FLUTTER_VERSION infrastructure/flutter_ci

# Tag and push to DigitalOcean Container Registry
echo "🏷️ Tagging images..."
docker tag appoint/flutter-ci:$FLUTTER_VERSION registry.digitalocean.com/appoint/flutter-ci:$FLUTTER_VERSION
docker tag registry.digitalocean.com/appoint/flutter-ci:$FLUTTER_VERSION registry.digitalocean.com/appoint/flutter-ci:latest

echo "📤 Pushing to DigitalOcean Container Registry..."
docker push registry.digitalocean.com/appoint/flutter-ci:$FLUTTER_VERSION
docker push registry.digitalocean.com/appoint/flutter-ci:latest

echo "✅ Flutter Docker image updated successfully!"
echo "📋 New version: $FLUTTER_VERSION"
echo "🏷️ Tags: $FLUTTER_VERSION, latest"