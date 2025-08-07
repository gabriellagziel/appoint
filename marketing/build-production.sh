#!/bin/bash
set -e

echo "Starting production build process..."

# Convert imports
echo "Converting @ imports to relative imports..."
node fix-imports.js

# Install dependencies
echo "Installing dependencies..."
npm ci

# Build with all checks disabled
echo "Building application with all checks disabled..."
NEXT_TELEMETRY_DISABLED=1 npx next build --no-lint

echo "Build completed successfully!" 