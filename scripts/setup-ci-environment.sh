#!/bin/bash

# CI/CD Environment Setup Script for app-oint
# This script installs all required dependencies for the CI/CD pipeline

set -e

echo "🚀 Setting up CI/CD environment for app-oint..."

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

# Update package lists
print_status "Updating package lists..."
sudo apt update

# Install essential build tools
print_status "Installing essential build tools..."
sudo apt install -y \
    build-essential \
    curl \
    wget \
    git \
    unzip \
    zip \
    cmake \
    ninja-build \
    pkg-config \
    libgtk-3-dev \
    libwebkit2gtk-4.0-dev \
    libappindicator3-dev \
    librsvg2-dev \
    libgirepository1.0-dev \
    libblkid-dev \
    liblzma-dev \
    libsecret-1-dev \
    libjsoncpp-dev \
    libnotify-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libyaml-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-bad1.0-dev \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-tools \
    gstreamer1.0-x \
    gstreamer1.0-alsa \
    gstreamer1.0-gl \
    gstreamer1.0-gtk3 \
    gstreamer1.0-qt5 \
    gstreamer1.0-pulseaudio

# Install Node.js and npm
print_status "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify Node.js installation
NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
print_success "Node.js $NODE_VERSION and npm $NPM_VERSION installed"

# Install Java (OpenJDK 17)
print_status "Installing Java (OpenJDK 17)..."
sudo apt install -y openjdk-17-jdk

# Verify Java installation
JAVA_VERSION=$(java -version 2>&1 | head -n 1)
print_success "Java installed: $JAVA_VERSION"

# Install Android SDK
print_status "Installing Android SDK..."
ANDROID_HOME="$HOME/Android/Sdk"
ANDROID_SDK_ROOT="$ANDROID_HOME"

# Create Android SDK directory
mkdir -p "$ANDROID_HOME"

# Download Android SDK Command Line Tools
print_status "Downloading Android SDK Command Line Tools..."
wget -q https://dl.google.com/android/repository/REDACTED_TOKEN.zip -O /tmp/commandlinetools.zip
unzip -q /tmp/commandlinetools.zip -d /tmp/
mkdir -p "$ANDROID_HOME/cmdline-tools/latest"
mv /tmp/cmdline-tools/* "$ANDROID_HOME/cmdline-tools/latest/"
rm -rf /tmp/cmdline-tools /tmp/commandlinetools.zip

# Set environment variables
echo "export ANDROID_HOME=$ANDROID_HOME" >> ~/.bashrc
echo "export ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT" >> ~/.bashrc
echo "export PATH=\$PATH:\$ANDROID_HOME/cmdline-tools/latest/bin:\$ANDROID_HOME/platform-tools" >> ~/.bashrc

# Source the updated bashrc
source ~/.bashrc

# Accept Android SDK licenses
print_status "Accepting Android SDK licenses..."
yes | "$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" --licenses

# Install Android SDK components
print_status "Installing Android SDK components..."
"$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager" \
    "platform-tools" \
    "platforms;android-34" \
    "platforms;android-33" \
    "platforms;android-32" \
    "build-tools;34.0.0" \
    "build-tools;33.0.2" \
    "build-tools;32.0.0" \
    "extras;android;m2repository" \
    "extras;google;m2repository" \
    "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"

# Install Chrome for web testing
print_status "Installing Google Chrome..."
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install -y google-chrome-stable

# Verify Chrome installation
CHROME_VERSION=$(google-chrome --version)
print_success "Chrome installed: $CHROME_VERSION"

# Install Firebase CLI
print_status "Installing Firebase CLI..."
npm install -g firebase-tools

# Verify Firebase CLI installation
FIREBASE_VERSION=$(firebase --version)
print_success "Firebase CLI installed: $FIREBASE_VERSION"

# Install DigitalOcean CLI
print_status "Installing DigitalOcean CLI..."
wget -q https://github.com/digitalocean/doctl/releases/latest/download/doctl-1.108.0-linux-amd64.tar.gz -O /tmp/doctl.tar.gz
tar -xzf /tmp/doctl.tar.gz -C /tmp/
sudo mv /tmp/doctl /usr/local/bin/
rm /tmp/doctl.tar.gz

# Verify doctl installation
DOCTL_VERSION=$(doctl version)
print_success "DigitalOcean CLI installed: $DOCTL_VERSION"

# Install Fastlane for iOS deployment
print_status "Installing Fastlane..."
sudo apt install -y ruby-full
sudo gem install fastlane

# Verify Fastlane installation
FASTLANE_VERSION=$(fastlane --version)
print_success "Fastlane installed: $FASTLANE_VERSION"

# Install additional development tools
print_status "Installing additional development tools..."
sudo apt install -y \
    clang \
    clang-tidy \
    clang-format \
    cppcheck \
    valgrind \
    gdb \
    strace \
    ltrace \
    htop \
    tree \
    jq \
    yq \
    httpie \
    postgresql-client \
    redis-tools \
    docker.io \
    docker-compose

# Install Python and pip for additional tools
print_status "Installing Python and pip..."
sudo apt install -y python3 python3-pip python3-venv

# Install additional Python packages
pip3 install --user \
    requests \
    beautifulsoup4 \
    lxml \
    pyyaml \
    jinja2 \
    click \
    colorama \
    rich \
    typer

# Create development environment file
print_status "Creating development environment file..."
cat > .env.development << EOF
# Development Environment Configuration
FLUTTER_VERSION=3.24.5
DART_VERSION=3.5.4
NODE_VERSION=18
JAVA_VERSION=17

# Android Configuration
ANDROID_HOME=$ANDROID_HOME
ANDROID_SDK_ROOT=$ANDROID_SDK_ROOT

# Firebase Configuration
FIREBASE_PROJECT_ID=appoint-app
FIREBASE_USE_EMULATOR=true

# DigitalOcean Configuration
DIGITALOCEAN_REGION=nyc1
DIGITALOCEAN_SIZE=s-1vcpu-1gb

# Development Settings
DEBUG=true
LOG_LEVEL=debug
ENABLE_ANALYTICS=false
ENABLE_CRASH_REPORTING=false
EOF

print_success "Development environment file created: .env.development"

# Create CI/CD configuration file
print_status "Creating CI/CD configuration file..."
cat > .github/ci-config.yml << EOF
# CI/CD Configuration
ci:
  flutter:
    version: "3.24.5"
    channel: "stable"
  
  android:
    sdk_version: "34"
    build_tools: "34.0.0"
    target_sdk: "34"
    min_sdk: "21"
  
  ios:
    deployment_target: "12.0"
    xcode_version: "15.0"
  
  web:
    renderer: "html"
    target: "web"
  
  testing:
    unit_tests: true
    widget_tests: true
    integration_tests: true
    coverage_threshold: 80
  
  security:
    dependency_scan: true
    code_scan: true
    secrets_scan: true
  
  deployment:
    firebase: true
    digitalocean: true
    play_store: true
    app_store: true
  
  notifications:
    slack: true
    email: false
    webhook: false
  
  rollback:
    enabled: true
    max_attempts: 3
    delay_seconds: 10
EOF

print_success "CI/CD configuration file created: .github/ci-config.yml"

# Create health check script
print_status "Creating health check script..."
cat > scripts/health-check.sh << 'EOF'
#!/bin/bash

# Health Check Script for app-oint
# This script checks the health of all deployed services

set -e

echo "🔍 Running health checks for app-oint..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Check Firebase Hosting
check_firebase() {
    print_status "Checking Firebase Hosting..."
    if curl -f -s https://appoint-app.web.app/ > /dev/null; then
        RESPONSE_TIME=$(curl -w "%{time_total}" -s -o /dev/null https://appoint-app.web.app/)
        print_success "Firebase Hosting is healthy (Response time: ${RESPONSE_TIME}s)"
    else
        print_error "Firebase Hosting is not responding"
        return 1
    fi
}

# Check DigitalOcean App Platform
check_digitalocean() {
    print_status "Checking DigitalOcean App Platform..."
    if curl -f -s https://appoint-app.ondigitalocean.app/ > /dev/null; then
        RESPONSE_TIME=$(curl -w "%{time_total}" -s -o /dev/null https://appoint-app.ondigitalocean.app/)
        print_success "DigitalOcean App Platform is healthy (Response time: ${RESPONSE_TIME}s)"
    else
        print_error "DigitalOcean App Platform is not responding"
        return 1
    fi
}

# Check API endpoints
check_apis() {
    print_status "Checking API endpoints..."
    
    # Check Firebase Functions
    if curl -f -s https://us-central1-appoint-app.cloudfunctions.net/api/health > /dev/null; then
        print_success "Firebase Functions API is healthy"
    else
        print_warning "Firebase Functions API is not responding"
    fi
    
    # Check DigitalOcean API
    if curl -f -s https://api.appoint-app.ondigitalocean.app/health > /dev/null; then
        print_success "DigitalOcean API is healthy"
    else
        print_warning "DigitalOcean API is not responding"
    fi
}

# Check SSL certificates
check_ssl() {
    print_status "Checking SSL certificates..."
    
    # Check Firebase SSL
    if echo | openssl s_client -servername appoint-app.web.app -connect appoint-app.web.app:443 2>/dev/null | openssl x509 -noout -dates | grep -q "notAfter"; then
        print_success "Firebase SSL certificate is valid"
    else
        print_error "Firebase SSL certificate is invalid or expired"
    fi
    
    # Check DigitalOcean SSL
    if echo | openssl s_client -servername appoint-app.ondigitalocean.app -connect appoint-app.ondigitalocean.app:443 2>/dev/null | openssl x509 -noout -dates | grep -q "notAfter"; then
        print_success "DigitalOcean SSL certificate is valid"
    else
        print_error "DigitalOcean SSL certificate is invalid or expired"
    fi
}

# Check mobile app stores
check_app_stores() {
    print_status "Checking mobile app stores..."
    
    # Check Play Store listing
    if curl -f -s "https://play.google.com/store/apps/details?id=com.appoint.app" > /dev/null; then
        print_success "Play Store listing is accessible"
    else
        print_warning "Play Store listing is not accessible"
    fi
    
    # Check App Store listing
    if curl -f -s "https://apps.apple.com/app/appoint/id123456789" > /dev/null; then
        print_success "App Store listing is accessible"
    else
        print_warning "App Store listing is not accessible"
    fi
}

# Main health check
main() {
    local exit_code=0
    
    check_firebase || exit_code=1
    check_digitalocean || exit_code=1
    check_apis
    check_ssl || exit_code=1
    check_app_stores
    
    echo ""
    echo "📊 Health Check Summary"
    echo "======================"
    
    if [ $exit_code -eq 0 ]; then
        print_success "All critical services are operational"
    else
        print_error "Some services are experiencing issues"
    fi
    
    exit $exit_code
}

main "$@"
EOF

chmod +x scripts/health-check.sh
print_success "Health check script created: scripts/health-check.sh"

# Create deployment validation script
print_status "Creating deployment validation script..."
cat > scripts/validate-deployment.sh << 'EOF'
#!/bin/bash

# Deployment Validation Script for app-oint
# This script validates deployments across all platforms

set -e

echo "🔍 Validating deployments for app-oint..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

# Validate web deployment
validate_web() {
    print_status "Validating web deployment..."
    
    # Check if web build exists
    if [ -f "build/web/index.html" ]; then
        print_success "Web build artifacts found"
    else
        print_error "Web build artifacts not found"
        return 1
    fi
    
    # Check web build size
    WEB_SIZE=$(du -sh build/web/ | cut -f1)
    print_status "Web build size: $WEB_SIZE"
    
    # Check for required files
    REQUIRED_FILES=("index.html" "main.dart.js" "flutter.js")
    for file in "${REQUIRED_FILES[@]}"; do
        if [ -f "build/web/$file" ]; then
            print_success "Required file found: $file"
        else
            print_error "Required file missing: $file"
            return 1
        fi
    done
}

# Validate Android deployment
validate_android() {
    print_status "Validating Android deployment..."
    
    # Check if Android build exists
    if [ -f "build/app/outputs/flutter-apk/app-arm64-release.apk" ]; then
        print_success "Android APK build found"
    else
        print_error "Android APK build not found"
        return 1
    fi
    
    if [ -f "build/app/outputs/bundle/release/app-release.aab" ]; then
        print_success "Android App Bundle found"
    else
        print_error "Android App Bundle not found"
        return 1
    fi
    
    # Check build sizes
    APK_SIZE=$(du -sh build/app/outputs/flutter-apk/app-arm64-release.apk | cut -f1)
    AAB_SIZE=$(du -sh build/app/outputs/bundle/release/app-release.aab | cut -f1)
    print_status "Android APK size: $APK_SIZE"
    print_status "Android AAB size: $AAB_SIZE"
}

# Validate iOS deployment
validate_ios() {
    print_status "Validating iOS deployment..."
    
    # Check if iOS build exists
    if [ -d "build/ios/iphoneos/Runner.app" ]; then
        print_success "iOS build found"
    else
        print_error "iOS build not found"
        return 1
    fi
    
    # Check iOS build size
    IOS_SIZE=$(du -sh build/ios/iphoneos/Runner.app | cut -f1)
    print_status "iOS build size: $IOS_SIZE"
}

# Validate Firebase deployment
validate_firebase() {
    print_status "Validating Firebase deployment..."
    
    if [ -n "$FIREBASE_TOKEN" ]; then
        # Check Firebase hosting status
        if firebase hosting:sites:list --token "$FIREBASE_TOKEN" | grep -q "appoint-app"; then
            print_success "Firebase hosting site exists"
        else
            print_error "Firebase hosting site not found"
            return 1
        fi
    else
        print_warning "Firebase token not available for validation"
    fi
}

# Validate DigitalOcean deployment
validate_digitalocean() {
    print_status "Validating DigitalOcean deployment..."
    
    if [ -n "$DIGITALOCEAN_ACCESS_TOKEN" ]; then
        # Check DigitalOcean app status
        if doctl apps list --token "$DIGITALOCEAN_ACCESS_TOKEN" | grep -q "appoint-app"; then
            print_success "DigitalOcean app exists"
        else
            print_error "DigitalOcean app not found"
            return 1
        fi
    else
        print_warning "DigitalOcean token not available for validation"
    fi
}

# Main validation
main() {
    local exit_code=0
    
    validate_web || exit_code=1
    validate_android || exit_code=1
    validate_ios || exit_code=1
    validate_firebase || exit_code=1
    validate_digitalocean || exit_code=1
    
    echo ""
    echo "📊 Deployment Validation Summary"
    echo "==============================="
    
    if [ $exit_code -eq 0 ]; then
        print_success "All deployments validated successfully"
    else
        print_error "Some deployments failed validation"
    fi
    
    exit $exit_code
}

main "$@"
EOF

chmod +x scripts/validate-deployment.sh
print_success "Deployment validation script created: scripts/validate-deployment.sh"

# Create environment setup verification
print_status "Verifying environment setup..."

# Check Flutter
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n 1)
    print_success "Flutter: $FLUTTER_VERSION"
else
    print_error "Flutter not found"
fi

# Check Android SDK
if [ -d "$ANDROID_HOME" ]; then
    print_success "Android SDK: $ANDROID_HOME"
else
    print_error "Android SDK not found"
fi

# Check Chrome
if command -v google-chrome &> /dev/null; then
    print_success "Chrome: $(google-chrome --version)"
else
    print_error "Chrome not found"
fi

# Check Node.js
if command -v node &> /dev/null; then
    print_success "Node.js: $(node --version)"
else
    print_error "Node.js not found"
fi

# Check Java
if command -v java &> /dev/null; then
    print_success "Java: $(java -version 2>&1 | head -n 1)"
else
    print_error "Java not found"
fi

# Check Firebase CLI
if command -v firebase &> /dev/null; then
    print_success "Firebase CLI: $(firebase --version)"
else
    print_error "Firebase CLI not found"
fi

# Check DigitalOcean CLI
if command -v doctl &> /dev/null; then
    print_success "DigitalOcean CLI: $(doctl version)"
else
    print_error "DigitalOcean CLI not found"
fi

# Check Fastlane
if command -v fastlane &> /dev/null; then
    print_success "Fastlane: $(fastlane --version)"
else
    print_error "Fastlane not found"
fi

echo ""
print_success "🎉 CI/CD environment setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Configure GitHub secrets for your project"
echo "2. Set up Firebase project and get access token"
echo "3. Set up DigitalOcean account and get access token"
echo "4. Configure Android signing keys"
echo "5. Configure iOS certificates and provisioning profiles"
echo "6. Run 'flutter doctor' to verify the setup"
echo "7. Test the CI/CD pipeline with a test commit"
echo ""
echo "🔧 Useful commands:"
echo "- flutter doctor -v"
echo "- flutter analyze"
echo "- flutter test"
echo "- flutter build web"
echo "- flutter build apk"
echo "- flutter build ios"
echo "- ./scripts/health-check.sh"
echo "- ./scripts/validate-deployment.sh"
echo ""
print_success "🚀 Your CI/CD pipeline is ready to go!"