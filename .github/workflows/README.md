# CI/CD Pipeline Documentation

This directory contains the unified CI/CD pipeline for the Appoint project. The pipeline is designed to be production-grade, secure, and maintainable.

## Overview

The CI/CD pipeline consists of five specialized workflows that work together to ensure code quality, security, and reliable deployments across all platforms.

## Workflow Files

### 1. `test.yml` - Test & Analyze
**Purpose**: Handles all testing, analysis, and code quality checks.

**Features**:
- ✅ Code analysis and linting (`flutter analyze`)
- ✅ Unit, widget, and integration tests (`flutter test --coverage`)
- ✅ Security scanning and dependency analysis
- ✅ Localization checks (`flutter gen-l10n`)
- ✅ Code formatting verification
- ✅ Spell checking

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual trigger

### 2. `build.yml` - Build
**Purpose**: Handles web, Android, and iOS builds with proper artifact management.

**Features**:
- ✅ Web app building (`flutter build web`)
- ✅ Android APK and App Bundle builds (`flutter build appbundle`)
- ✅ iOS app building (`flutter build ios`)
- ✅ Artifact upload and retention
- ✅ Build verification

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual trigger

### 3. `deploy.yml` - Deploy
**Purpose**: Handles Firebase hosting deployment and release creation.

**Features**:
- ✅ Firebase Hosting deployment
- ✅ Release creation on tags
- ✅ Slack notifications
- ✅ Deployment verification

**Triggers**:
- Push to `main` branch
- Manual trigger with environment selection

### 4. `android_release.yml` - Android Release
**Purpose**: Specialized workflow for Android builds with Play Store deployment.

**Features**:
- ✅ Android APK and App Bundle builds
- ✅ Code signing with keystore
- ✅ Play Store internal testing
- ✅ Play Store production deployment
- ✅ Manual trigger options

**Triggers**:
- Push to `main` branch
- Tags starting with `v*`
- Manual trigger

### 5. `ios_build.yml` - iOS Build
**Purpose**: Specialized workflow for iOS builds with App Store deployment.

**Features**:
- ✅ iOS app building
- ✅ Code signing with Apple certificates
- ✅ TestFlight deployment
- ✅ App Store submission
- ✅ Manual trigger options

**Triggers**:
- Push to `main` branch
- Tags starting with `v*`
- Manual trigger

## Pipeline Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Code Push     │───▶│   Test & Analyze│───▶│   Build         │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Deploy        │◀───│   Android/iOS   │◀───│   Artifacts     │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Job Dependencies

### Test & Analyze Pipeline
- **analyze**: Code analysis, linting, formatting
- **test**: Unit, widget, and integration tests (parallel)
- **security-scan**: Security audit and dependency analysis
- **l10n-check**: Localization verification

### Build Pipeline
- **build-web**: Web app building and verification
- **build-android**: Android APK and App Bundle builds
- **build-ios**: iOS app building

### Deploy Pipeline
- **deploy-firebase**: Firebase Hosting deployment
- **create-release**: GitHub release creation (on tags)
- **notify**: Slack notifications

### Android Release Pipeline
- **build-android**: Android builds
- **sign-and-release**: Code signing and artifact preparation
- **deploy-play-store**: Play Store internal testing
- **deploy-play-store-production**: Play Store production

### iOS Build Pipeline
- **build-ios**: iOS builds
- **code-sign-and-archive**: Code signing and IPA creation
- **deploy-testflight**: TestFlight deployment
- **deploy-app-store**: App Store submission

## Environment Variables

All workflows use consistent environment variables:

```yaml
env:
  FLUTTER_VERSION: '3.24.5'
  DART_VERSION: '3.5.4'
  NODE_VERSION: '18'
  JAVA_VERSION: '17'
  XCODE_VERSION: '15.0'
```

## Required Secrets

### Firebase
- `FIREBASE_TOKEN`: Firebase CLI token for deployments

### Android
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore file
- `ANDROID_KEYSTORE_PASSWORD`: Keystore password
- `ANDROID_KEY_ALIAS`: Key alias
- `ANDROID_KEY_PASSWORD`: Key password
- `PLAY_STORE_JSON_KEY`: Google Play Store service account JSON

### iOS
- `IOS_P12_CERTIFICATE`: Base64 encoded P12 certificate
- `IOS_P12_PASSWORD`: P12 certificate password
- `APPLE_ISSUER_ID`: Apple Developer Team ID
- `APPLE_API_KEY_ID`: Apple API key ID
- `APPLE_API_PRIVATE_KEY`: Apple API private key

### Notifications
- `SLACK_WEBHOOK_URL`: Slack webhook for notifications

## Caching Strategy

The pipeline implements comprehensive caching:

1. **Flutter cache**: Cached by Flutter action
2. **Pub dependencies**: Cached using actions/cache
3. **Node modules**: Cached using actions/setup-node
4. **Build artifacts**: Stored as GitHub artifacts

## Security Features

### Vulnerability Scanning
- Dependency vulnerability checks
- Code security analysis
- Secrets scanning
- Hardcoded secrets detection

### Code Quality
- Flutter analyze with fatal infos
- Code formatting checks
- Unused imports detection
- Debug print detection

### Access Control
- Environment-specific secrets
- Least privilege principle
- Secret rotation schedule
- Emergency procedures

## Deployment Targets

### Web
- **Firebase Hosting**: Primary web deployment
- **Staging Environment**: Automatic deployment from `develop` branch

### Mobile
- **iOS**: TestFlight for testing, App Store for production
- **Android**: Play Store internal testing, Play Store production

## Manual Triggers

All workflows support manual triggers with customizable options:

### Test & Analyze
- No additional inputs required

### Build
- No additional inputs required

### Deploy
- Environment selection (staging/production)

### Android Release
- Build type selection (debug/release/profile)
- Deploy to Play Store option

### iOS Build
- Build type selection (debug/release/profile)
- Deploy to TestFlight option

## Monitoring and Notifications

### Success Notifications
- Slack channel: `#deployments`
- Detailed status reporting

### Failure Notifications
- Immediate failure alerts
- Detailed error reporting
- Rollback procedures

### Metrics
- Build success rates
- Deployment times
- Test coverage
- Security scan results

## Artifact Management

### Test Artifacts
- Coverage reports for each test type
- Retention: 30 days

### Build Artifacts
- Web build: `build/web/`
- Android builds: APKs and App Bundle
- iOS builds: App bundle and IPA
- Retention: 30 days

## Troubleshooting

### Common Issues

1. **Build Failures**
   - Check Flutter version compatibility
   - Verify dependencies
   - Review error logs

2. **Deployment Failures**
   - Verify secrets configuration
   - Check network connectivity
   - Review deployment logs

3. **Test Failures**
   - Review test output
   - Check test environment
   - Verify test data

### Debug Commands

```bash
# Check Flutter version
flutter --version

# Verify dependencies
flutter pub deps

# Run tests locally
flutter test

# Build locally
flutter build web --release
flutter build apk --release
flutter build ios --release
```

## Maintenance

### Regular Tasks
- Update Flutter version (quarterly)
- Rotate secrets (as per schedule)
- Review and update dependencies
- Monitor pipeline performance

### Emergency Procedures
- Secret compromise response
- Pipeline failure recovery
- Rollback procedures
- Communication protocols

## Support

For pipeline-related issues:

- **DevOps Team**: devops@appoint.com
- **Documentation**: [Internal Wiki]
- **Emergency**: +1-555-0123

## Contributing

When modifying the pipeline:

1. Test changes in a fork first
2. Follow the existing patterns
3. Update documentation
4. Add appropriate tests
5. Review security implications

## Version History

- **v2.0.0**: Unified workflow structure
- **v2.1.0**: Enhanced security scanning
- **v2.2.0**: Improved artifact management
- **v2.3.0**: Added comprehensive monitoring
- **v2.4.0**: Enhanced error handling and notifications 