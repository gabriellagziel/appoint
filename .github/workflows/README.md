# CI/CD Pipeline Documentation

This directory contains the complete CI/CD pipeline for the Appoint project. The pipeline is designed to be production-grade, secure, and maintainable.

## Overview

The CI/CD pipeline consists of several specialized workflows that work together to ensure code quality, security, and reliable deployments across all platforms.

## Workflow Files

### 1. `ci-cd-pipeline.yml` - Main CI/CD Pipeline
**Purpose**: Comprehensive pipeline that handles all aspects of the development lifecycle.

**Features**:
- ✅ Code analysis and linting
- ✅ Unit, widget, and integration tests
- ✅ Security scanning
- ✅ Web, Android, and iOS builds
- ✅ Firebase and DigitalOcean deployments
- ✅ Release creation
- ✅ Notifications and rollback mechanisms

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop`
- Manual trigger with customizable options

### 2. `ios-build.yml` - iOS Build and Deploy
**Purpose**: Specialized workflow for iOS builds with proper code signing.

**Features**:
- ✅ iOS app building
- ✅ Code signing with Apple certificates
- ✅ TestFlight deployment
- ✅ App Store submission
- ✅ Manual trigger options

**Triggers**:
- Push to `main` branch
- Tags starting with `v*`
- Pull requests to `main`
- Manual trigger

### 3. `android-build.yml` - Android Build and Deploy
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
- Pull requests to `main`
- Manual trigger

### 4. `web-deploy.yml` - Web Deploy
**Purpose**: Specialized workflow for web deployments.

**Features**:
- ✅ Web app building
- ✅ Firebase Hosting deployment
- ✅ DigitalOcean App Platform deployment
- ✅ Staging environment support
- ✅ Manual trigger options

**Triggers**:
- Push to `main` branch
- Pull requests to `main`
- Manual trigger

### 5. `security-qa.yml` - Security and Quality Assurance
**Purpose**: Comprehensive security and quality checks.

**Features**:
- ✅ Dependency vulnerability scanning
- ✅ Code security analysis
- ✅ Secrets scanning
- ✅ Performance analysis
- ✅ Accessibility testing
- ✅ Code coverage analysis
- ✅ Weekly scheduled scans

**Triggers**:
- Push to `main` or `develop`
- Pull requests to `main` or `develop`
- Weekly schedule (Mondays at 2 AM)
- Manual trigger

## Pipeline Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Code Push     │───▶│   Analysis      │───▶│   Security      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Tests         │◀───│   Cache Setup   │    │   Build Jobs    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
                                │                       │
                                ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Deployments   │◀───│   Artifacts     │◀───│   Notifications │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Job Dependencies

### Main Pipeline
1. **setup-cache** → **analyze, test, security-scan**
2. **analyze, test, security-scan** → **build-web, build-android, build-ios**
3. **build-web** → **deploy-firebase, deploy-digitalocean**
4. **build-android, build-ios, build-web** → **create-release**
5. **deploy-firebase, deploy-digitalocean, create-release** → **notify**

### iOS Pipeline
1. **build-ios** → **code-sign-and-archive**
2. **code-sign-and-archive** → **deploy-testflight, deploy-app-store**

### Android Pipeline
1. **build-android** → **sign-and-release**
2. **sign-and-release** → **deploy-play-store, deploy-play-store-production**

## Environment Variables

All workflows use consistent environment variables:

```yaml
env:
  FLUTTER_VERSION: '3.24.5'
  DART_VERSION: '3.5.4'
  NODE_VERSION: '18'
  JAVA_VERSION: '17'
```

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
- Secrets scanning with TruffleHog and Gitleaks
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
- **DigitalOcean App Platform**: Secondary deployment
- **Staging Environment**: Automatic deployment from `develop` branch

### Mobile
- **iOS**: TestFlight for testing, App Store for production
- **Android**: Play Store internal testing, Play Store production

## Manual Triggers

All workflows support manual triggers with customizable options:

### Main Pipeline
- Environment selection (staging/production)
- Platform selection (all/web/android/ios)
- Skip tests option

### Platform-Specific
- Build type selection (debug/release/profile)
- Deployment options (TestFlight, Play Store, etc.)

## Monitoring and Notifications

### Success Notifications
- Slack channel: `#deployments`
- Discord webhook
- Email notifications (if configured)

### Failure Notifications
- Immediate failure alerts
- Detailed error reporting
- Rollback procedures

### Metrics
- Build success rates
- Deployment times
- Test coverage
- Security scan results

## Rollback Procedures

### Automatic Rollback
- Failed deployments trigger automatic rollback
- Previous version restoration
- Health checks before rollback

### Manual Rollback
- Manual trigger for rollback
- Version selection
- Confirmation steps

## Performance Optimizations

### Parallel Execution
- Independent jobs run in parallel
- Optimized job dependencies
- Reduced total pipeline time

### Caching
- Comprehensive caching strategy
- Reduced build times
- Cost optimization

### Resource Management
- Appropriate timeout values
- Resource limits
- Cleanup procedures

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

- **v1.0.0**: Initial pipeline setup
- **v1.1.0**: Added security scanning
- **v1.2.0**: Added mobile deployments
- **v1.3.0**: Added DigitalOcean support
- **v1.4.0**: Enhanced caching and performance
- **v1.5.0**: Added comprehensive monitoring 