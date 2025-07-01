# AppOint Scripts

This directory contains utility scripts for development, deployment, and maintenance of the AppOint project.

## 📁 Scripts Overview

### Development Scripts

#### `setup_env.sh` - Developer Environment Setup
**Purpose**: Complete development environment initialization

**Features**:
- Installs Flutter 3.32.0 and Dart 3.4.0
- Configures DigitalOcean Spaces mirrors
- Sets up Firebase emulators
- Creates environment configuration
- Installs project dependencies

**Usage**:
```bash
# Make executable (first time only)
chmod +x scripts/setup_env.sh

# Run setup
./scripts/setup_env.sh
```

**Requirements**:
- macOS, Linux, or Windows (WSL)
- Internet connection
- Node.js and npm (for Firebase CLI)

### Maintenance Scripts

#### `add_missing_keys.sh` - Localization Key Management
**Purpose**: Add missing localization keys to ARB files

**Usage**:
```bash
./scripts/add_missing_keys.sh
```

#### `run_tests.sh` - Test Execution
**Purpose**: Run comprehensive test suite

**Usage**:
```bash
./scripts/run_tests.sh
```

#### `merge_l10n.dart` - Localization Merge
**Purpose**: Merge localization files from backup

**Usage**:
```bash
dart scripts/merge_l10n.dart
```

### Build Scripts

#### `build_release.sh` - Release Build
**Purpose**: Create production builds for all platforms

**Usage**:
```bash
./scripts/build_release.sh
```

## 🔧 Environment Configuration

The setup script creates a `.env` file with the following variables:

### Required Variables
```bash
# DigitalOcean Spaces
DO_SPACE_DOMAIN="your-space-domain.digitaloceanspaces.com"
DO_SPACES_ACCESS_KEY="your-access-key"
DO_SPACES_SECRET_KEY="your-secret-key"

# Firebase
FIREBASE_PROJECT_ID="appoint-development"

# Flutter Mirrors
PUB_HOSTED_URL="https://your-space-domain.digitaloceanspaces.com/pub"
FLUTTER_STORAGE_BASE_URL="https://your-space-domain.digitaloceanspaces.com/flutter"
```

### Optional Variables
```bash
# App Configuration
APP_ENV="development"
DEBUG_MODE="true"

# API Configuration
API_BASE_URL="http://localhost:5001/appoint-development/us-central1/api"
STRIPE_PUBLISHABLE_KEY="pk_test_your_stripe_key"

# Notifications
FCM_SERVER_KEY="your_fcm_server_key"
```

## 🚀 Quick Start

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-org/appoint.git
   cd appoint
   ```

2. **Run the setup script**:
   ```bash
   ./scripts/setup_env.sh
   ```

3. **Update configuration**:
   ```bash
   # Edit .env file with your actual values
   nano .env
   ```

4. **Start development**:
   ```bash
   flutter run
   ```

## 🛠️ Troubleshooting

### Common Issues

1. **Permission Denied**:
   ```bash
   chmod +x scripts/setup_env.sh
   ```

2. **Flutter Not Found**:
   ```bash
   export PATH="$HOME/flutter/bin:$PATH"
   ```

3. **Firebase CLI Not Found**:
   ```bash
   npm install -g firebase-tools
   ```

4. **Environment Variables Not Loaded**:
   ```bash
   source .env
   ```

### Platform-Specific Notes

#### macOS
- Requires Xcode for iOS development
- Uses Homebrew for package management
- Supports both Intel and Apple Silicon

#### Linux
- Requires Android SDK for Android development
- Uses apt/yum for package management
- Supports x64 and ARM64 architectures

#### Windows
- Requires Windows Subsystem for Linux (WSL)
- Uses Chocolatey for package management
- Supports x64 architecture

## 📚 Additional Resources

- [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)
- [Firebase CLI Documentation](https://firebase.google.com/docs/cli)
- [DigitalOcean Spaces Documentation](https://docs.digitalocean.com/products/spaces/)

## 🤝 Contributing

When adding new scripts:
1. Follow the existing naming convention
2. Add proper error handling
3. Include usage documentation
4. Test on multiple platforms
5. Update this README 