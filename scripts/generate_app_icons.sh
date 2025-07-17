#!/bin/bash

# APP-OINT App Icon Generation Script
# This script generates app icons in various sizes for different platforms

echo "🎨 Generating APP-OINT App Icons..."

# Create output directories
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi
mkdir -p ios/Runner/Assets.xcassets/AppIcon.appiconset
mkdir -p web/icons

# Check for ImageMagick
if ! command -v convert &> /dev/null; then
    echo "⚠️  ImageMagick (convert) not found. Please install it to generate icons."
    echo "💡 To install: brew install imagemagick (macOS) or sudo apt-get install imagemagick (Ubuntu)"
    exit 1
fi

echo "✅ ImageMagick found. You can now add your logo source and icon generation commands here."
echo "📁 All required output directories have been created."
echo "👉 Please update this script with your actual logo/icon generation logic as needed."

echo "🎉 APP-OINT app icon generation script complete!"