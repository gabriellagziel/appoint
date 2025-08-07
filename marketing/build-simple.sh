#!/bin/bash
set -e

echo "Starting simple build process..."

# Convert imports
echo "Converting @ imports to relative imports..."
node fix-imports.js

# Install dependencies
echo "Installing dependencies..."
npm ci

# Build without TypeScript and ESLint
echo "Building application..."
npx next build --no-lint

echo "Build completed successfully!" 