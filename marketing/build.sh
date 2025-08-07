#!/bin/bash
set -e

echo "Starting build process..."

# Convert @ imports to relative imports
echo "Converting @ imports to relative imports..."
node fix-imports.js

# Install dependencies
echo "Installing dependencies..."
npm ci

# Build the application
echo "Building the application..."
npm run build

echo "Build completed successfully!" 