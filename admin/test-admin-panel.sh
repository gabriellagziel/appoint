#!/bin/bash

# Admin Panel Local Testing Script
# This script helps you test the Admin Panel before deployment

echo "🔐 Admin Panel Local Testing Script"
echo "=================================="

# Check if we're in the admin directory
if [ ! -f "package.json" ]; then
    echo "❌ Error: Please run this script from the admin directory"
    exit 1
fi

echo "📋 Checking prerequisites..."

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "❌ Node.js is not installed. Please install Node.js first."
    exit 1
fi

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "❌ npm is not installed. Please install npm first."
    exit 1
fi

echo "✅ Prerequisites check passed"

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Check if .env.local exists
if [ ! -f ".env.local" ]; then
    echo "⚠️  Warning: .env.local not found"
    echo "Please create .env.local with your Firebase configuration:"
    echo ""
    echo "NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key"
    echo "NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_auth_domain"
    echo "NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id"
    echo "NEXT_PUBLIC_FIREBASE_STORAGE_BUCKET=your_storage_bucket"
    echo "NEXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID=your_sender_id"
    echo "NEXT_PUBLIC_FIREBASE_APP_ID=your_app_id"
    echo ""
    echo "Press Enter to continue anyway..."
    read
fi

# Build the project
echo "🔨 Building the project..."
npm run build

if [ $? -eq 0 ]; then
    echo "✅ Build successful"
else
    echo "❌ Build failed. Please fix the errors before proceeding."
    exit 1
fi

# Start development server
echo "🚀 Starting development server..."
echo "The Admin Panel will be available at: http://localhost:3000"
echo ""
echo "📋 Testing Checklist:"
echo "1. Open http://localhost:3000 in your browser"
echo "2. Login with Firebase Auth using an admin UID"
echo "3. Verify all 16 sidebar routes are accessible"
echo "4. Test the Broadcasts module (create a test message)"
echo "5. Test the Flags module (review a test flag)"
echo "6. Test the System module (check health status)"
echo "7. Verify admin actions are being logged"
echo "8. Test responsive design on mobile/tablet"
echo ""
echo "Press Ctrl+C to stop the server when done testing"
echo ""

npm run dev 