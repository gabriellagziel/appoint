# GitHub Actions CI/CD Pipeline

This directory contains the consolidated CI/CD workflows for the Appoint project.

## 🚀 Workflow Overview

### 1. `ci-consolidated.yml` - Main CI Pipeline
**Purpose**: Comprehensive CI pipeline with cross-platform testing, security scanning, and deployment.

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` or `develop` branches
- Manual trigger via workflow_dispatch

**Jobs**:
- **setup-cache**: Global caching for dependencies
- **code-generation**: Code generation with build_runner
- **lint**: Static analysis and code formatting
- **l10n-check**: Translation completeness validation
- **test**: Multi-platform testing (Ubuntu + macOS)
- **firebase-functions-test**: Firebase Functions testing
- **build**: Cross-platform builds (Web, Android, iOS)
- **firebase-deploy**: Firebase Hosting deployment
- **security-scan**: Security vulnerability scanning
- **performance-test**: Performance testing and analysis

**Key Features**:
- ✅ Cross-platform testing (Ubuntu, macOS, Windows)
- ✅ Proper error handling without masking failures
- ✅ Comprehensive caching strategy
- ✅ Security and performance testing
- ✅ Multi-platform builds (Web, Android, iOS)

### 2. `qa-pipeline.yml` - Comprehensive QA Pipeline
**Purpose**: Complete quality assurance pipeline with fail-fast logic.

**Triggers**:
- Push to `main` or `develop` branches
- Pull requests to `main` branch
- Manual trigger via workflow_dispatch

**Jobs**:
- **code-quality**: Code analysis and formatting
- **unit-tests**: Unit tests with matrix strategy
- **test-coverage**: Coverage analysis with 80% threshold
- **integration-tests**: Cross-platform integration tests
- **performance-tests**: Performance benchmarking
- **security-tests**: Security vulnerability scanning
- **accessibility-tests**: Accessibility compliance testing
- **localization-tests**: Localization validation
- **firebase-tests**: Firebase emulator testing
- **quality-gates**: Final quality gate evaluation

**Key Features**:
- ✅ Fail-fast logic for quality gates
- ✅ 80% test coverage threshold enforcement
- ✅ Comprehensive security scanning
- ✅ Accessibility and localization testing
- ✅ Firebase emulator testing

### 3. `release.yml` - Release Pipeline
**Purpose**: Automated release process with multi-platform deployment.

**Triggers**:
- Push of version tags (v*)
- Manual workflow dispatch

**Jobs**:
- **version-bump**: Semantic version bumping
- **test-all-platforms**: Cross-platform testing
- **build-android**: Android APK and App Bundle builds
- **build-ios**: iOS IPA builds with signing
- **build-web**: Web app builds
- **security-scan**: Security auditing
- **create-release**: GitHub release creation
- **deploy-android**: Play Store deployment
- **deploy-ios**: App Store deployment
- **deploy-web**: Firebase Hosting deployment
- **notify**: Slack notifications

**Key Features**:
- ✅ Multi-platform builds (Android, iOS, Web)
- ✅ Proper signing configuration
- ✅ Automated store deployments
- ✅ Comprehensive release notes
- ✅ Slack notifications

## 🔧 Configuration

### Required Secrets

#### Core Secrets
| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `FIREBASE_TOKEN` | Firebase CLI token | Firebase deployment |
| `GITHUB_TOKEN` | GitHub token | Release creation |

#### Android Secrets
| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `ANDROID_KEYSTORE_BASE64` | Base64 encoded keystore | Android signing |
| `ANDROID_STORE_PASSWORD` | Keystore password | Android signing |
| `ANDROID_KEY_ALIAS` | Key alias | Android signing |
| `ANDROID_KEY_PASSWORD` | Key password | Android signing |
| `PLAY_STORE_JSON_KEY` | Play Store service account | Play Store deployment |

#### iOS Secrets
| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `IOS_CERTIFICATE_BASE64` | Base64 encoded certificate | iOS signing |
| `IOS_CERTIFICATE_PASSWORD` | Certificate password | iOS signing |
| `IOS_PROVISIONING_PROFILE_BASE64` | Base64 encoded profile | iOS signing |
| `APP_STORE_CONNECT_API_KEY` | App Store Connect API key | App Store deployment |
| `APP_STORE_CONNECT_API_KEY_ID` | API key ID | App Store deployment |
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | App Store deployment |

#### Optional Secrets
| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `SLACK_WEBHOOK_URL` | Slack webhook URL | Notifications |

### Environment Variables

All workflows use consistent environment variables:
```yaml
env:
  FLUTTER_VERSION: '3.32.0'
  DART_VERSION: '3.4.0'
  NODE_VERSION: '18'
  FIREBASE_EMULATOR_VERSION: '13.0.0'
```

## 🏗️ Build Matrix Strategy

### CI Pipeline Matrix
- **OS**: Ubuntu, macOS, Windows
- **Platform**: Web, Android, iOS
- **Test Type**: Unit, Widget, Integration

### QA Pipeline Matrix
- **Test Groups**: models, services, features, utils
- **Platforms**: android, ios, web

## 📊 Quality Gates

### Code Quality
- Zero analyzer errors or warnings
- Code formatting compliance
- Dependency verification

### Test Coverage
- Minimum 80% line coverage required
- Coverage reports generated and uploaded
- Coverage trend monitoring

### Security
- Firebase Functions security testing
- Dependency vulnerability scanning
- Security rule validation

### Performance
- Performance benchmarks
- Memory usage analysis
- Startup time optimization

## 🚀 Deployment Strategy

### Web Deployment
- **Platform**: Firebase Hosting
- **Trigger**: Main branch pushes
- **Artifacts**: Web build from CI pipeline

### Android Deployment
- **Platform**: Google Play Store
- **Trigger**: Release tags
- **Artifacts**: App Bundle (.aab)

### iOS Deployment
- **Platform**: App Store Connect
- **Trigger**: Release tags
- **Artifacts**: IPA file

## 🔍 Troubleshooting

### Common Issues

1. **Coverage below threshold**
   ```bash
   # Add more unit tests
   flutter test --coverage
   # Check coverage locally
   genhtml coverage/lcov.info --output-directory coverage/html
   ```

2. **Analyzer failures**
   ```bash
   # Fix linting issues
   flutter analyze
   # Update generated code
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Build failures**
   ```bash
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

4. **Signing issues**
   - Verify Android keystore configuration
   - Check iOS certificate and provisioning profile
   - Ensure secrets are properly configured

### Local Testing

```bash
# Run analyzer locally
flutter analyze

# Run tests with coverage
flutter test --coverage

# Check coverage locally
genhtml coverage/lcov.info --output-directory coverage/html

# Run Firebase emulators
firebase emulators:start

# Test Firebase Functions
cd functions && npm test
```

## 📈 Performance Optimization

### Caching Strategy
- **Dart Pub Cache**: `~/.pub-cache`
- **Flutter Cache**: `~/.flutter`, `.dart_tool`, `build`
- **NPM Cache**: `~/.npm`
- **Firebase Emulators**: `~/.cache/firebase/emulators`

### Parallel Execution
- Jobs run in parallel where possible
- Matrix strategies for efficient resource usage
- Fail-fast logic to prevent unnecessary builds

### Resource Optimization
- Timeout limits on all jobs
- Efficient artifact retention policies
- Conditional job execution

## 🔒 Security Features

### Code Security
- Dependency vulnerability scanning
- Security rule testing
- Code analysis for security issues

### Deployment Security
- Secure secret management
- Signed builds for mobile apps
- Environment-specific configurations

### Access Control
- Branch protection rules
- Required status checks
- PR review requirements

## 📋 Migration Guide

### From Old Workflows
1. **Remove redundant workflows**: Delete `ci.yml`, `ci.yaml`, `100-percent-qa.yml`
2. **Update branch protection**: Require `ci-consolidated` and `qa-pipeline` to pass
3. **Configure secrets**: Add all required secrets
4. **Update documentation**: Reference new workflow structure

### Breaking Changes
- Removed `continue-on-error` flags for proper failure detection
- Consolidated multiple workflows into comprehensive pipelines
- Updated Flutter version to 3.32.0
- Improved error handling and reporting

## 🎯 Best Practices

### Development Workflow
1. **Feature branches**: Only QA pipeline runs
2. **PR to main**: Both CI and QA pipelines run
3. **Main branch**: Full pipeline with deployment

### Release Process
1. **Create version tag**: Automatic release pipeline
2. **Manual release**: Use workflow dispatch with version input
3. **Monitor deployment**: Check all platform deployments

### Quality Assurance
1. **Pre-commit**: Local testing and analysis
2. **PR checks**: Automated quality gates
3. **Post-deployment**: Smoke tests and monitoring

## 📞 Support

For issues with the CI/CD pipeline:
1. Check the workflow logs for detailed error messages
2. Verify all required secrets are configured
3. Ensure local builds work before pushing
4. Review the troubleshooting section above

## 🔄 Continuous Improvement

The pipeline is designed for continuous improvement:
- Regular dependency updates
- Performance monitoring
- Security scanning
- Quality metric tracking
- Automated testing expansion 