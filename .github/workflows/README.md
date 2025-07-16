# 🚀 Main CI/CD Pipeline

This is a comprehensive GitHub Actions CI/CD pipeline that handles all Flutter build, test, and deployment tasks automatically.

## 🎯 Features

- ✅ **Full Automation**: No local development required
- ✅ **Flutter 3.32.5**: Latest stable version
- ✅ **Code Generation**: Automatic `.g.dart` and `.freezed.dart` generation
- ✅ **Multi-Platform**: Web, Android, and iOS builds
- ✅ **Smart Caching**: Optimized dependency caching
- ✅ **Comprehensive Testing**: Unit, widget, and integration tests
- ✅ **Security Scanning**: Dependency vulnerability checks
- ✅ **Deployment**: Firebase Hosting and DigitalOcean App Platform
- ✅ **Rollback Support**: Automatic rollback on failures

## 📋 Prerequisites

### Required Secrets

Add these secrets to your GitHub repository:

#### Firebase Deployment
- `FIREBASE_TOKEN`: Firebase CLI token for hosting deployment

#### DigitalOcean Deployment
- `DIGITALOCEAN_ACCESS_TOKEN`: DigitalOcean API token (provided: `REDACTED_TOKEN`)
- `DIGITALOCEAN_APP_ID`: Your DigitalOcean App Platform app ID

#### Android Release (Optional)
- `ANDROID_KEYSTORE_BASE64`: Base64 encoded keystore for signed APKs
- `PLAY_STORE_JSON_KEY`: Google Play Store service account key

#### iOS Release (Optional)
- `IOS_P12_CERTIFICATE`: iOS distribution certificate

#### Notifications (Optional)
- `SLACK_WEBHOOK_URL`: Slack webhook for deployment notifications

## 🔄 Workflow Jobs

### 1. Validate Setup
- Validates all required secrets
- Checks environment configuration

### 2. Setup Dependencies
- Installs Flutter 3.32.5 and Dart 3.5.4
- Sets up Java 17 and Node.js 18
- Installs all dependencies with caching

### 3. Generate Code
- Runs `build_runner` to generate `.g.dart` and `.freezed.dart` files
- Multiple retry attempts for reliability
- Uploads generated files as artifacts

### 4. Analyze Code
- Runs Flutter analyze
- Checks code formatting
- Runs spell checks
- Verifies dependency tree

### 5. Run Tests
- Unit tests with coverage
- Widget tests
- Integration tests
- Uploads coverage reports to Codecov

### 6. Security Scan
- Dependency vulnerability checks
- Security audit
- Dependency analysis

### 7. Build Applications
- **Web**: Flutter web build with HTML renderer
- **Android**: APK and App Bundle builds
- **iOS**: iOS app build (macOS runners)

### 8. Deploy
- **Firebase Hosting**: Automatic deployment to Firebase
- **DigitalOcean**: Deployment to App Platform
- **Releases**: GitHub releases with artifacts

## 🚀 Usage

### Automatic Triggers
- **Push to main/develop**: Full CI/CD pipeline
- **Pull Requests**: Analysis and testing only

### Manual Triggers
Use the "Run workflow" button in GitHub Actions with options:

- **Environment**: staging/production
- **Platform**: all/web/android/ios
- **Skip Tests**: true/false

### Deployment Triggers
- **Main branch**: Automatic deployment to staging
- **Tags (v*.*.*)**: Create GitHub releases
- **Manual dispatch**: Deploy to specified environment

## 📁 Generated Files

The pipeline automatically generates:
- `.g.dart` files for JSON serialization
- `.freezed.dart` files for immutable data classes
- Build artifacts for all platforms

## 🔧 Configuration

### Flutter Version
```yaml
env:
  FLUTTER_VERSION: '3.32.5'
  DART_VERSION: '3.5.4'
```

### Build Commands
```bash
# Code generation
dart run build_runner build --delete-conflicting-outputs

# Web build
flutter build web --release --web-renderer html

# Android builds
flutter build apk --release --target-platform android-arm64
flutter build appbundle --release

# iOS build
flutter build ios --release --no-codesign
```

## 🛠️ Troubleshooting

### Common Issues

1. **Build Runner Fails**
   - Check for syntax errors in model files
   - Verify `part` directives are correct
   - Check pubspec.yaml dependencies

2. **Tests Fail**
   - Review test output for specific failures
   - Check for missing mocks or dependencies
   - Verify test data setup

3. **Deployment Fails**
   - Verify secrets are correctly configured
   - Check DigitalOcean app ID exists
   - Review Firebase project configuration

### Debug Steps

1. Check workflow logs in GitHub Actions
2. Verify generated files in artifacts
3. Test locally with same Flutter version
4. Review dependency conflicts

## 📊 Monitoring

### Coverage Reports
- Uploaded to Codecov automatically
- Available in workflow artifacts
- Tracked over time

### Build Artifacts
- Web builds: `build/web/`
- Android APKs: Multiple architectures
- iOS builds: Release configuration

### Notifications
- Slack notifications for deployment status
- GitHub release notifications
- Email notifications for failures

## 🔄 Rollback

Automatic rollback is available for:
- Firebase Hosting deployments
- DigitalOcean App Platform deployments

Triggered on workflow failure with manual dispatch.

## 📈 Performance

### Caching Strategy
- Pub dependencies: `~/.pub-cache`
- Dart tool: `.dart_tool/`
- Build artifacts: `build/`
- Node modules: `node_modules/`

### Optimization
- Parallel job execution
- Smart dependency caching
- Artifact sharing between jobs
- Conditional job execution

## 🎯 Success Metrics

- ✅ All tests pass
- ✅ Code generation successful
- ✅ Build artifacts created
- ✅ Deployment completed
- ✅ Coverage reports uploaded

## 📞 Support

For issues with the CI/CD pipeline:
1. Check workflow logs
2. Review this documentation
3. Verify secret configuration
4. Test locally with same versions 