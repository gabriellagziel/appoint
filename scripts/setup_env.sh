#!/bin/bash

# AppOint Developer Environment Setup Script
# This script sets up the complete development environment for AppOint

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to detect OS
detect_os() {
    case "$(uname -s)" in
        Linux*)     echo "linux";;
        Darwin*)    echo "macos";;
        CYGWIN*)    echo "windows";;
        MINGW*)     echo "windows";;
        *)          echo "unknown";;
    esac
}

# Function to detect architecture
detect_arch() {
    case "$(uname -m)" in
        x86_64)     echo "x64";;
        arm64)      echo "arm64";;
        aarch64)    echo "arm64";;
        *)          echo "x64";;
    esac
}

print_status "Starting AppOint development environment setup..."

# Step 1: Detect and install Flutter 3.32.0
print_status "Step 1: Checking Flutter installation..."

FLUTTER_VERSION="3.32.0"
FLUTTER_HOME="$HOME/flutter"

if command_exists flutter; then
    CURRENT_FLUTTER_VERSION=$(flutter --version | grep -o "Flutter [0-9]\+\.[0-9]\+\.[0-9]\+" | cut -d' ' -f2)
    if [ "$CURRENT_FLUTTER_VERSION" = "$FLUTTER_VERSION" ]; then
        print_success "Flutter $FLUTTER_VERSION is already installed"
    else
        print_warning "Flutter $CURRENT_FLUTTER_VERSION is installed, but we need $FLUTTER_VERSION"
        print_status "Updating Flutter to version $FLUTTER_VERSION..."
        
        if [ -d "$FLUTTER_HOME" ]; then
            cd "$FLUTTER_HOME"
            git fetch
            git checkout "$FLUTTER_VERSION"
            flutter doctor
        else
            print_error "Flutter installation not found in expected location"
            exit 1
        fi
    fi
else
    print_status "Flutter not found. Installing Flutter $FLUTTER_VERSION..."
    
    OS=$(detect_os)
    ARCH=$(detect_arch)
    
    # Download Flutter
    FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${ARCH}_${FLUTTER_VERSION}-stable.tar.xz"
    
    if [ "$OS" = "macos" ]; then
        if [ "$ARCH" = "arm64" ]; then
            FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_${FLUTTER_VERSION}-stable.tar.xz"
        else
            FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_${FLUTTER_VERSION}-stable.tar.xz"
        fi
    elif [ "$OS" = "linux" ]; then
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
    elif [ "$OS" = "windows" ]; then
        FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_${FLUTTER_VERSION}-stable.zip"
    fi
    
    # Create Flutter directory and download
    mkdir -p "$FLUTTER_HOME"
    cd "$HOME"
    
    if [ "$OS" = "windows" ]; then
        curl -L "$FLUTTER_URL" -o flutter.zip
        unzip flutter.zip
        rm flutter.zip
    else
        curl -L "$FLUTTER_URL" | tar -xJ
    fi
    
    # Add Flutter to PATH
    if ! grep -q "export PATH.*flutter/bin" ~/.bashrc 2>/dev/null; then
        echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.bashrc
    fi
    
    if ! grep -q "export PATH.*flutter/bin" ~/.zshrc 2>/dev/null; then
        echo 'export PATH="$HOME/flutter/bin:$PATH"' >> ~/.zshrc
    fi
    
    export PATH="$HOME/flutter/bin:$PATH"
    print_success "Flutter $FLUTTER_VERSION installed successfully"
fi

# Step 2: Install Dart SDK 3.4.0
print_status "Step 2: Checking Dart SDK installation..."

DART_VERSION="3.4.0"

if command_exists dart; then
    CURRENT_DART_VERSION=$(dart --version | grep -o "Dart [0-9]\+\.[0-9]\+\.[0-9]\+" | cut -d' ' -f2)
    if [ "$CURRENT_DART_VERSION" = "$DART_VERSION" ]; then
        print_success "Dart $DART_VERSION is already installed"
    else
        print_warning "Dart $CURRENT_DART_VERSION is installed, but we need $DART_VERSION"
        print_status "Dart SDK is managed by Flutter, updating Flutter will update Dart"
    fi
else
    print_status "Dart SDK not found. It will be installed with Flutter..."
fi

# Verify Flutter and Dart installation
print_status "Verifying Flutter and Dart installation..."
flutter doctor
dart --version

# Step 3: Configure environment variables for DigitalOcean Spaces mirrors
print_status "Step 3: Configuring environment variables..."

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    print_status "Creating .env file with default configuration..."
    cat > .env << EOF
# AppOint Development Environment Configuration

# DigitalOcean Spaces Configuration
# Replace with your actual DigitalOcean Spaces domain
export DO_SPACE_DOMAIN="your-space-domain.digitaloceanspaces.com"
export DO_SPACES_ACCESS_KEY="your-access-key"
export DO_SPACES_SECRET_KEY="your-secret-key"
export DO_SPACES_BUCKET="appoint-assets"

# Firebase Configuration
# Replace with your actual Firebase project ID
export FIREBASE_PROJECT_ID="appoint-development"
export FIREBASE_EMULATOR_HOST="localhost"
export FIREBASE_EMULATOR_PORT="8080"

# Flutter Configuration
export PUB_HOSTED_URL="https://your-space-domain.digitaloceanspaces.com/pub"
export FLUTTER_STORAGE_BASE_URL="https://your-space-domain.digitaloceanspaces.com/flutter"

# App Configuration
export APP_ENV="development"
export DEBUG_MODE="true"

# API Configuration
export API_BASE_URL="http://localhost:5001/appoint-development/us-central1/api"
export STRIPE_PUBLISHABLE_KEY="pk_test_your_stripe_key"

# Notification Configuration
export FCM_SERVER_KEY="your_fcm_server_key"
EOF
    print_success ".env file created with default configuration"
    print_warning "Please update the .env file with your actual configuration values"
else
    print_status ".env file already exists"
fi

# Add environment variables to shell profile
print_status "Adding environment variables to shell profile..."

SHELL_PROFILE=""
if [ -f ~/.bashrc ]; then
    SHELL_PROFILE=~/.bashrc
elif [ -f ~/.zshrc ]; then
    SHELL_PROFILE=~/.zshrc
fi

if [ -n "$SHELL_PROFILE" ]; then
    # Add environment variable loading
    if ! grep -q "source.*\.env" "$SHELL_PROFILE" 2>/dev/null; then
        echo "" >> "$SHELL_PROFILE"
        echo "# AppOint Environment Variables" >> "$SHELL_PROFILE"
        echo "if [ -f .env ]; then" >> "$SHELL_PROFILE"
        echo "    export \$(cat .env | grep -v '^#' | xargs)" >> "$SHELL_PROFILE"
        echo "fi" >> "$SHELL_PROFILE"
        print_success "Environment variables added to $SHELL_PROFILE"
    else
        print_status "Environment variables already configured in $SHELL_PROFILE"
    fi
fi

# Step 4: Initialize Firebase emulators
print_status "Step 4: Setting up Firebase emulators..."

# Check if Firebase CLI is installed
if ! command_exists firebase; then
    print_status "Installing Firebase CLI..."
    if command_exists npm; then
        npm install -g firebase-tools
    else
        print_error "npm is required to install Firebase CLI"
        print_status "Please install Node.js and npm first: https://nodejs.org/"
        exit 1
    fi
fi

# Initialize Firebase project if not already done
if [ ! -f firebase.json ]; then
    print_status "Initializing Firebase project..."
    firebase init emulators --project "$FIREBASE_PROJECT_ID" --yes
else
    print_status "Firebase project already initialized"
fi

# Start Firebase emulators
print_status "Starting Firebase emulators..."
firebase emulators:start --only auth,firestore,storage --project "$FIREBASE_PROJECT_ID" &
EMULATOR_PID=$!

# Wait for emulators to start
sleep 10

# Check if emulators are running
if curl -s http://localhost:4000 > /dev/null 2>&1; then
    print_success "Firebase emulators started successfully"
else
    print_warning "Firebase emulators may not be fully started yet"
fi

# Step 5: Install project dependencies
print_status "Step 5: Installing project dependencies..."

# Get Flutter dependencies
flutter pub get

# Install additional tools if needed
if command_exists dart; then
    print_status "Installing Dart development tools..."
    dart pub global activate dart_style
    dart pub global activate flutter_gen
fi

print_success "Development environment setup completed!"

# Display usage instructions
echo ""
echo "=========================================="
echo "🎉 AppOint Development Environment Ready!"
echo "=========================================="
echo ""
echo "📋 Next Steps:"
echo "1. Update .env file with your actual configuration values"
echo "2. Run 'flutter doctor' to verify installation"
echo "3. Start development with 'flutter run'"
echo ""
echo "🔧 Common Commands:"
echo "  flutter run                    # Run the app"
echo "  flutter test                   # Run tests"
echo "  flutter build apk              # Build Android APK"
echo "  flutter build ios              # Build iOS app"
echo "  firebase emulators:start       # Start Firebase emulators"
echo "  firebase deploy                # Deploy to Firebase"
echo ""
echo "🌐 Environment Variables:"
echo "  DO_SPACE_DOMAIN               # DigitalOcean Spaces domain"
echo "  FIREBASE_PROJECT_ID           # Firebase project ID"
echo "  PUB_HOSTED_URL                # Pub package mirror"
echo "  FLUTTER_STORAGE_BASE_URL      # Flutter storage mirror"
echo ""
echo "📚 Documentation:"
echo "  docs/README.md                # Project documentation"
echo "  .github/workflows/README.md   # CI/CD guide"
echo ""
echo "🚀 Happy coding!"
echo ""

# Save emulator PID for cleanup
echo $EMULATOR_PID > .firebase_emulator.pid

# Function to cleanup on exit
cleanup() {
    if [ -f .firebase_emulator.pid ]; then
        EMULATOR_PID=$(cat .firebase_emulator.pid)
        if kill -0 $EMULATOR_PID 2>/dev/null; then
            print_status "Stopping Firebase emulators..."
            kill $EMULATOR_PID
        fi
        rm -f .firebase_emulator.pid
    fi
}

# Set up trap to cleanup on script exit
trap cleanup EXIT 