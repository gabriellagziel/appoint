#!/bin/bash

# APP-OINT App Icon Generation Script
# This script generates app icons in various sizes for different platforms

echo 🎨 Generating APP-OINT App Icons...

# Createoutput directories
mkdir -p android/app/src/main/res/mipmap-hdpi
mkdir -p android/app/src/main/res/mipmap-mdpi
mkdir -p android/app/src/main/res/mipmap-xhdpi
mkdir -p android/app/src/main/res/mipmap-xxhdpi
mkdir -p android/app/src/main/res/mipmap-xxxhdpi

mkdir -p ios/Runner/Assets.xcassets/AppIcon.appiconset

mkdir -p web/icons

# Generate Android icons (if ImageMagick is available)
if command -v convert &> /dev/null; then
    echo "📱 Generating Android icons..."
    
    # Create a simple APP-OINT logo using ImageMagick
    convert -size 512xc:white \
        -fill#4169E1" -draw "circle 2562560\
        -fill#FF8C0 -draw "circle 2562560\
        -fill#FFB366 -draw "circle 3203200\
        -fill#20B2AA" -draw "circle 3603606\
        -fill#8A2BE2" -draw "circle 3203200\
        -fill#4B0082 -draw "circle 2562562\
        -fill#4169E1" -draw "circle 1921920\
        -fill#32CD32 -draw "circle 1521526\
        -fill#FFD70 -draw "circle 1921920\
        -fill "#333 -draw "circle 256256 \
        android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png
    
    # Generate different sizes
    convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize7272droid/app/src/main/res/mipmap-hdpi/ic_launcher.png
    convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize4848droid/app/src/main/res/mipmap-mdpi/ic_launcher.png
    convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize9696droid/app/src/main/res/mipmap-xhdpi/ic_launcher.png
    convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 14444droid/app/src/main/res/mipmap-xxhdpi/ic_launcher.png
    
    echo "✅ Android icons generated
else
    echo "⚠️  ImageMagick not found. Skipping Android icon generation."
fi

# Generate web icons
if command -v convert &> /dev/null; then
    echo 🌐 Generating web icons..."
    
    # Generate web icons from the Android icon
    convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 192192web/icons/Icon-192   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 512512web/icons/Icon-512   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 192192eb/icons/Icon-maskable-192   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 512512eb/icons/Icon-maskable-512   
    # Generate favicon
    convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize3232/favicon.png
    
    echo "✅ Web icons generated
else
    echo "⚠️  ImageMagick not found. Skipping web icon generation."
fi

# Generate iOS icons (if ImageMagick is available)
if command -v convert &> /dev/null; then
    echo 🍎 Generating iOS icons..."
    
    # iOS requires specific sizes
    convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize20 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@1   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize40 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize60 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@3   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize29 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@1   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize58 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize87 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@3   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize40 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@1   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize80 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 120 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@3   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 120 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 180 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize76 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@1   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 152 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 167 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-830.52   convert android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png -resize 1024 ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024.png
    
    echo "✅ iOS icons generated
else
    echo "⚠️  ImageMagick not found. Skipping iOS icon generation.fi

echo "🎉 APP-OINT app icon generation complete!"
echo "📱 Icons generated for: Android, iOS, and Web platforms"
echo "💡 To install ImageMagick: brew install imagemagick (macOS) or apt-get install imagemagick (Ubuntu)"