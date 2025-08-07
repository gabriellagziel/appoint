# CI/CD Pipeline Setup

## Overview
This document describes the CI/CD pipeline setup for the APP-OINT Flutter application, including GitHub Actions workflows, deployment strategies, and troubleshooting guides.

## Pipeline Architecture

### Workflow Structure
```
.github/workflows/
├── ci.yml                 # Main CI pipeline
├── deploy_web.yml         # Web deployment
├── deploy_android.yml     # Android deployment
├── deploy_ios.yml         # iOS deployment
└── security_scan.yml      # Security scanning
```

### Pipeline Stages
1. **Code Quality** - Linting, formatting, analysis
2. **Testing** - Unit tests, widget tests, integration tests
3. **Build** - Platform-specific builds
4. **Security** - Dependency scanning, code analysis
5. **Deploy** - Platform-specific deployments

## Workflow Details

### Main CI Pipeline (`ci.yml`)

#### Triggers
- Push to main branch
- Pull requests to main branch
- Manual workflow dispatch

#### Jobs
1. **Setup Environment**
   - Checkout code
   - Setup Flutter SDK
   - Setup Dart SDK
   - Cache dependencies

2. **Code Quality**
   - Run `flutter analyze`
   - Run `dart format --set-exit-if-changed`
   - Run `flutter test --coverage`

3. **Build Verification**
   - Build for Android (debug)
   - Build for iOS (debug)
   - Build for Web

4. **Test Execution**
   - Unit tests
   - Widget tests
   - Integration tests
   - Coverage reporting

### Web Deployment (`deploy_web.yml`)

#### Triggers
- Push to main branch
- Manual workflow dispatch

#### Process
1. Build Flutter web app
2. Deploy to Firebase Hosting
3. Update preview URLs

### Android Deployment (`deploy_android.yml`)

#### Triggers
- Release tags (v*)
- Manual workflow dispatch

#### Process
1. Build signed APK/AAB
2. Upload to Google Play Console
3. Create GitHub release

### iOS Deployment (`deploy_ios.yml`)

#### Triggers
- Release tags (v*)
- Manual workflow dispatch

#### Process
1. Build iOS app
2. Upload to App Store Connect
3. Create GitHub release

## Environment Setup

### Required Secrets
```yaml
# Firebase
FIREBASE_SERVICE_ACCOUNT_KEY: Base64 encoded service account JSON
FIREBASE_PROJECT_ID: Your Firebase project ID

# Android
ANDROID_KEYSTORE_BASE64: Base64 encoded keystore file
ANDROID_KEY_ALIAS: Key alias
ANDROID_KEY_PASSWORD: Key password
ANDROID_STORE_PASSWORD: Store password

# iOS
APPLE_ID: Apple Developer account email
APPLE_APP_SPECIFIC_PASSWORD: App-specific password
IOS_DISTRIBUTION_CERTIFICATE: Base64 encoded certificate
IOS_DISTRIBUTION_PRIVATE_KEY: Base64 encoded private key
IOS_PROVISIONING_PROFILE: Base64 encoded provisioning profile

# Code Quality
SONAR_TOKEN: SonarCloud token
CODECOV_TOKEN: Codecov token
```

### Environment Variables
```yaml
# Build Configuration
FLUTTER_VERSION: "3.32.0"
DART_VERSION: "3.4.0"
ANDROID_COMPILE_SDK: "34"
ANDROID_TARGET_SDK: "34"
ANDROID_MIN_SDK: "21"

# Firebase Configuration
FIREBASE_APP_ID: "1:944776470711:web:6f3c833ef110bca6c66d32"
FIREBASE_API_KEY: "AIzaSyAEQoB1lR2y6oJQm6Fp19d11i2Y9US8k8"
FIREBASE_MESSAGING_SENDER_ID: "944776470711"
FIREBASE_MEASUREMENT_ID: "G-HHH7T7JFHS"
```

## Troubleshooting

### Common Issues

#### 1. Dart SDK Version Mismatch
**Error**: `The current Dart SDK version is 3.4.0, but pubspec.yaml requires >=3.4.0 <4.0.0`

**Solution**: Update the workflow to use the correct Dart SDK version:
```yaml
- name: Setup Dart SDK
  uses: dart-lang/setup-dart@v1
  with:
    sdk: "3.4.0"
```

#### 2. Network Access Issues
**Error**: `Network access is not allowed in this job`

**Solution**: Add network access permissions:
```yaml
permissions:
  contents: read
  id-token: write
  actions: read
```

#### 3. Android Build Failures
**Error**: `Execution failed for task ':app:signReleaseBundle'`

**Solution**: Verify signing configuration:
```yaml
- name: Setup Android signing
  run: |
    echo "${{ secrets.ANDROID_KEYSTORE_BASE64 }}" | base64 -d > android/app/upload-keystore.jks
    echo "storeFile=upload-keystore.jks" >> android/key.properties
    echo "storePassword=${{ secrets.ANDROID_STORE_PASSWORD }}" >> android/key.properties
    echo "keyAlias=${{ secrets.ANDROID_KEY_ALIAS }}" >> android/key.properties
    echo "keyPassword=${{ secrets.ANDROID_KEY_PASSWORD }}" >> android/key.properties
```

#### 4. iOS Build Failures
**Error**: `No provisioning profile found`

**Solution**: Setup iOS certificates properly:
```yaml
- name: Setup iOS certificates
  run: |
    echo "${{ secrets.IOS_DISTRIBUTION_CERTIFICATE }}" | base64 -d > ios/Runner/Distribution.p12
    echo "${{ secrets.IOS_DISTRIBUTION_PRIVATE_KEY }}" | base64 -d > ios/Runner/Distribution.pem
    echo "${{ secrets.IOS_PROVISIONING_PROFILE }}" | base64 -d > ios/Runner/Distribution.mobileprovision
```

#### 5. Firebase Deployment Issues
**Error**: `Firebase CLI not found`

**Solution**: Install Firebase CLI:
```yaml
- name: Install Firebase CLI
  run: npm install -g firebase-tools
```

### Performance Optimization

#### 1. Caching Strategy
```yaml
- name: Cache Flutter dependencies
  uses: actions/cache@v3
  with:
    path: |
      ~/.pub-cache
      .dart_tool
    key: ${{ runner.os }}-flutter-${{ hashFiles('**/pubspec.lock') }}
    restore-keys: |
      ${{ runner.os }}-flutter-
```

#### 2. Parallel Job Execution
```yaml
jobs:
  test:
    strategy:
      matrix:
        platform: [android, ios, web]
    runs-on: ubuntu-latest
```

#### 3. Build Optimization
```yaml
- name: Build with optimizations
  run: |
    flutter build apk --release --split-per-abi
    flutter build ios --release --no-codesign
    flutter build web --release --web-renderer html
```

## Monitoring and Alerts

### Pipeline Metrics
- Build success rate
- Test coverage trends
- Deployment frequency
- Build duration

### Alert Configuration
```yaml
- name: Notify on failure
  if: failure()
  uses: 8398a7/action-slack@v3
  with:
    status: failure
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

## Security Considerations

### 1. Secret Management
- Use GitHub Secrets for sensitive data
- Rotate secrets regularly
- Limit secret access to necessary workflows

### 2. Code Scanning
```yaml
- name: Run CodeQL Analysis
  uses: github/codeql-action/analyze@v2
  with:
    languages: dart
```

### 3. Dependency Scanning
```yaml
- name: Run Trivy vulnerability scanner
  uses: aquasecurity/trivy-action@master
  with:
    scan-type: 'fs'
    scan-ref: '.'
    format: 'sarif'
    output: 'trivy-results.sarif'
```

## Best Practices

### 1. Workflow Organization
- Keep workflows focused and single-purpose
- Use reusable workflows for common tasks
- Document all workflow steps

### 2. Error Handling
- Add proper error handling and retry logic
- Provide meaningful error messages
- Include troubleshooting steps in documentation

### 3. Performance
- Cache dependencies and build artifacts
- Use parallel job execution where possible
- Optimize build configurations

### 4. Security
- Regularly update dependencies
- Scan for vulnerabilities
- Use least privilege principle for permissions

## Future Improvements

### Planned Enhancements
1. **Automated Testing**: Add more comprehensive test coverage
2. **Performance Monitoring**: Integrate performance metrics collection
3. **Rollback Strategy**: Implement automated rollback capabilities
4. **Multi-Environment**: Support staging and production environments
5. **Feature Flags**: Integrate feature flag management

### Monitoring Enhancements
1. **Real-time Alerts**: Implement real-time notification system
2. **Performance Dashboards**: Create performance monitoring dashboards
3. **Cost Optimization**: Monitor and optimize CI/CD costs
4. **Compliance**: Add compliance and audit trail features
