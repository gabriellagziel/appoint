# DigitalOcean CI Migration Guide

## Overview

This document describes the migration of all Flutter CI operations from GitHub Actions to DigitalOcean containers. The goal is to ensure that **all tests, builds, and analysis** are run **directly on the DigitalOcean CI environment**, not GitHub.

## 🎯 Goals

- ✅ Run all Flutter operations on DigitalOcean containers
- ✅ Prevent fallback to GitHub Actions
- ✅ Ensure fast, stable, and isolated CI
- ✅ Report results back to GitHub via API only

## 🛑 What's NOT Allowed

- ❌ Installing Flutter via GitHub Actions
- ❌ Running tests in GitHub-hosted runners
- ❌ Relying on GitHub caching for Dart/Flutter code execution
- ❌ Using GitHub Actions for any Flutter code execution

## ✅ What's Required

- ✅ Use DigitalOcean Flutter container: `registry.digitalocean.com/appoint/flutter-ci`
- ✅ Run all operations in DigitalOcean environment
- ✅ Use safety locks to prevent GitHub fallback
- ✅ Report results via GitHub API only

## 🔒 Safety Locks

### Environment Variable Lock

```bash
DIGITALOCEAN_CI_LOCK=true  # Prevents GitHub fallback
```

### Validation Script

The `scripts/digitalocean-ci-lock.sh` script provides comprehensive validation:

```bash
# Validate CI lock
./scripts/digitalocean-ci-lock.sh validate

# Run Flutter command with validation
./scripts/digitalocean-ci-lock.sh run "flutter test" "Running tests"

# Quick environment check
./scripts/digitalocean-ci-lock.sh check
```

### CI Runner Script

The `scripts/run-digitalocean-ci.sh` script provides a complete CI runner:

```bash
# Run all operations
./scripts/run-digitalocean-ci.sh

# Run specific operations
./scripts/run-digitalocean-ci.sh analyze
./scripts/run-digitalocean-ci.sh test unit
./scripts/run-digitalocean-ci.sh build-web
./scripts/run-digitalocean-ci.sh deploy-firebase
```

## 📋 Available Operations

### Code Generation
```bash
./scripts/run-digitalocean-ci.sh generate
```
- Runs `dart run build_runner build`
- Generates `.g.dart` and `.freezed.dart` files
- Includes retry logic and validation

### Code Analysis
```bash
./scripts/run-digitalocean-ci.sh analyze
```
- Runs `flutter analyze`
- Runs spell check
- Checks code formatting
- Verifies pubspec.yaml

### Testing
```bash
./scripts/run-digitalocean-ci.sh test [type]
```
Available test types:
- `unit` - Unit tests only
- `widget` - Widget tests only
- `integration` - Integration tests only
- `all` - All tests (default)

### Security Scanning
```bash
./scripts/run-digitalocean-ci.sh security
```
- Runs security audit
- Checks for vulnerabilities
- Analyzes dependencies

### Building
```bash
# Web build
./scripts/run-digitalocean-ci.sh build-web

# Android build
./scripts/run-digitalocean-ci.sh build-android

# iOS build
./scripts/run-digitalocean-ci.sh build-ios
```

### Deployment
```bash
# Deploy to Firebase
./scripts/run-digitalocean-ci.sh deploy-firebase

# Deploy to DigitalOcean
./scripts/run-digitalocean-ci.sh deploy-digitalocean
```

## 🔄 Updated Workflows

### Main CI Workflow (`.github/workflows/main_ci.yml`)

- ✅ Added `DIGITALOCEAN_CI_LOCK=true` environment variable
- ✅ Added validation steps to all jobs
- ✅ All jobs use DigitalOcean container
- ✅ Prevents Flutter installation on GitHub

### Simple CI Workflow (`.github/workflows/ci.yml`)

- ✅ Renamed to "DigitalOcean CI Pipeline"
- ✅ Added CI lock validation
- ✅ All jobs use DigitalOcean container
- ✅ Removed GitHub Flutter setup actions

### New DigitalOcean CI Workflow (`.github/workflows/digitalocean-ci.yml`)

- ✅ Complete DigitalOcean-focused workflow
- ✅ Comprehensive validation and safety checks
- ✅ Override option for emergency GitHub fallback
- ✅ All operations run on DigitalOcean

## 🚨 Emergency Override

In case of emergency, you can override the lock:

```bash
# Set environment variable
export FORCE_GITHUB_FALLBACK=true

# Or use the override input in workflow dispatch
# workflow_dispatch:
#   inputs:
#     force_github_fallback:
#       description: 'Force GitHub fallback (override lock)'
#       required: false
#       default: false
#       type: boolean
```

⚠️ **Warning**: This bypasses the DigitalOcean CI lock and is not recommended.

## 🔧 Configuration

### Required Secrets

```bash
# DigitalOcean (Required)
DIGITALOCEAN_ACCESS_TOKEN=your_token_here
DIGITALOCEAN_APP_ID=your_app_id_here

# Firebase (Optional)
FIREBASE_TOKEN=your_token_here

# Android (Optional)
ANDROID_KEYSTORE_BASE64=your_keystore_here
PLAY_STORE_JSON_KEY=your_key_here

# iOS (Optional)
IOS_P12_CERTIFICATE=your_certificate_here
```

### Environment Variables

```bash
# CI Lock (Required)
DIGITALOCEAN_CI_LOCK=true

# Container Configuration
DIGITALOCEAN_CONTAINER=registry.digitalocean.com/appoint/flutter-ci:latest
FLUTTER_VERSION=3.32.5
DART_VERSION=3.5.4
```

## 📊 Monitoring and Validation

### CI Lock Status

The system validates the CI lock at multiple levels:

1. **Workflow Level**: Environment variable validation
2. **Job Level**: Container validation
3. **Step Level**: Command validation
4. **Script Level**: Runtime validation

### Validation Checks

```bash
# Check if running in DigitalOcean container
is_digitalocean_container() {
    if [ -f "/.dockerenv" ]; then
        if docker ps 2>/dev/null | grep -q "registry.digitalocean.com/appoint/flutter-ci"; then
            return 0
        fi
        if [ "$DIGITALOCEAN_CI_LOCK" = "true" ]; then
            return 0
        fi
    fi
    return 1
}
```

### Error Handling

The system provides comprehensive error handling:

- ❌ **Lock Disabled**: Exit with error
- ❌ **Wrong Container**: Exit with error
- ❌ **Missing Secrets**: Exit with error
- ⚠️ **GitHub Fallback**: Warning but continue
- ✅ **Valid Environment**: Proceed with operations

## 🚀 Migration Checklist

### ✅ Completed

- [x] Created DigitalOcean CI lock script
- [x] Created comprehensive CI runner script
- [x] Updated main CI workflow with validation
- [x] Updated simple CI workflow with validation
- [x] Created new DigitalOcean-focused workflow
- [x] Added safety locks to all jobs
- [x] Prevented Flutter installation on GitHub
- [x] Added emergency override option
- [x] Created comprehensive documentation

### 🔄 Next Steps

- [ ] Test all workflows in staging environment
- [ ] Validate DigitalOcean container access
- [ ] Verify all secrets are configured
- [ ] Test emergency override functionality
- [ ] Monitor CI performance improvements
- [ ] Update team documentation

## 📈 Benefits

### Performance
- 🚀 **Faster builds** - Pre-installed Flutter environment
- 🚀 **Better caching** - Persistent DigitalOcean cache
- 🚀 **Reduced startup time** - No Flutter installation needed

### Reliability
- 🔒 **Consistent environment** - Same container every time
- 🔒 **Isolated execution** - No GitHub runner dependencies
- 🔒 **Predictable results** - Controlled environment

### Security
- 🔐 **Secure secrets** - DigitalOcean-managed credentials
- 🔐 **Isolated builds** - Container-based execution
- 🔐 **Audit trail** - Comprehensive logging

## 🆘 Troubleshooting

### Common Issues

1. **CI Lock Validation Failed**
   ```bash
   # Check environment variable
   echo $DIGITALOCEAN_CI_LOCK
   
   # Validate manually
   ./scripts/digitalocean-ci-lock.sh validate
   ```

2. **Container Not Found**
   ```bash
   # Check container availability
   docker pull registry.digitalocean.com/appoint/flutter-ci:latest
   
   # Verify container access
   ./scripts/digitalocean-ci-lock.sh check
   ```

3. **Missing Secrets**
   ```bash
   # Check required secrets
   echo $DIGITALOCEAN_ACCESS_TOKEN
   echo $DIGITALOCEAN_APP_ID
   ```

4. **Flutter Not Available**
   ```bash
   # Verify Flutter installation
   flutter --version
   dart --version
   
   # Check container environment
   ./scripts/run-digitalocean-ci.sh deps
   ```

### Emergency Procedures

1. **Temporary GitHub Fallback**
   ```bash
   export FORCE_GITHUB_FALLBACK=true
   ./scripts/run-digitalocean-ci.sh test
   ```

2. **Manual Container Execution**
   ```bash
   docker run -it --rm \
     -v $(pwd):/workspace \
     -w /workspace \
     registry.digitalocean.com/appoint/flutter-ci:latest \
     ./scripts/run-digitalocean-ci.sh test
   ```

3. **Debug Mode**
   ```bash
   # Enable debug logging
   set -x
   ./scripts/run-digitalocean-ci.sh analyze
   ```

## 📞 Support

For issues with the DigitalOcean CI migration:

1. Check the troubleshooting section above
2. Review the validation logs
3. Test with the emergency override
4. Contact the DevOps team

---

**Last Updated**: $(date)
**Version**: 1.0.0
**Status**: Active