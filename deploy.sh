#!/bin/bash
set -e

echo "🚀 Building production PWA..."
cd appoint
flutter clean && flutter pub get
flutter build web --no-tree-shake-icons --release

echo "✅ Build complete."

echo "🚀 Deploying to Firebase Hosting..."
firebase deploy --only hosting

echo "✅ Firebase Hosting deployment done."

echo "🚀 Syncing to DigitalOcean/Nginx server..."
rsync -av build/web/ user@your-server:/var/www/app.app-oint.com/
ssh user@your-server "sudo nginx -s reload"

echo "✅ DigitalOcean/Nginx deployment done."

echo "🎉 Deployment complete to BOTH environments!"
