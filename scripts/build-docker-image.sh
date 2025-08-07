#!/bin/bash

# Build and push Flutter CI Docker image to DigitalOcean Container Registry
# Usage: ./scripts/build-docker-image.sh [tag]

set -e

# Configuration
REGISTRY="registry.digitalocean.com"
REPOSITORY="appoint"
IMAGE_NAME="flutter-ci"
TAG=${1:-latest}
FULL_IMAGE_NAME="$REGISTRY/$REPOSITORY/$IMAGE_NAME:$TAG"

echo "🚀 Building Flutter CI Docker image..."
echo "📦 Image: $FULL_IMAGE_NAME"

# Check if doctl is installed
if ! command -v doctl &> /dev/null; then
    echo "❌ doctl is not installed. Please install DigitalOcean CLI first."
    echo "   Visit: https://docs.digitalocean.com/reference/doctl/how-to/install/"
    exit 1
fi

# Check if logged in to DigitalOcean
if ! doctl account get &> /dev/null; then
    echo "❌ Not logged in to DigitalOcean. Please run: doctl auth init"
    exit 1
fi

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t $FULL_IMAGE_NAME .

# Tag the image
echo "🏷️ Tagging image..."
docker tag $FULL_IMAGE_NAME $REGISTRY/$REPOSITORY/$IMAGE_NAME:latest

# Configure Docker to use DigitalOcean Container Registry
echo "🔐 Configuring Docker for DigitalOcean Container Registry..."
doctl registry docker-config

# Push the image to DigitalOcean Container Registry
echo "📤 Pushing image to DigitalOcean Container Registry..."
docker push $FULL_IMAGE_NAME
docker push $REGISTRY/$REPOSITORY/$IMAGE_NAME:latest

echo "✅ Successfully built and pushed Flutter CI image:"
echo "   - $FULL_IMAGE_NAME"
echo "   - $REGISTRY/$REPOSITORY/$IMAGE_NAME:latest"

# Verify the image is available
echo "🔍 Verifying image availability..."
doctl registry repository list

echo "🎉 Flutter CI Docker image is ready for use in CI/CD pipelines!"