#!/bin/bash

# App-Oint Business Registrations Quick Start Script
# This script helps you get the business registrations system running quickly

echo "🚀 App-Oint Business Registrations Quick Start"
echo "=============================================="
echo ""

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
    echo "⚠️  No .env.local file found!"
    echo ""
    echo "📝 Please create .env.local with your Firebase configuration:"
    echo ""
    echo "NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key_here"
    echo "REDACTED_TOKEN=your_project.firebaseapp.com"
    echo "NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id"
    echo "REDACTED_TOKEN=your_project.appspot.com"
    echo "REDACTED_TOKEN=123456789"
    echo "NEXT_PUBLIC_FIREBASE_APP_ID=1:123456789:web:abcdef123456"
    echo ""
    echo "📖 See FIREBASE_SETUP.md for detailed instructions"
    echo ""
    read -p "Press Enter to continue anyway..."
else
    echo "✅ .env.local file found"
fi

# Install dependencies if needed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
else
    echo "✅ Dependencies already installed"
fi

# Start the development server
echo ""
echo "🌐 Starting development server..."
echo "📱 The system will be available at:"
echo "   - Registration Form: http://localhost:3000/register-business.html"
echo "   - Admin Panel: http://localhost:3000/admin/business/registrations"
echo ""
echo "🧪 To test the API, run: node test-registrations.js"
echo ""

npm run dev 