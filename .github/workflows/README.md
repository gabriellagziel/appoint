# GitHub Actions CI/CD Workflow Setup

This document explains the CI/CD workflow configuration and required setup for the AppOint Flutter project.

## Overview

The CI/CD pipeline consists of multiple jobs that run on different triggers:

- **build-and-test**: Main build and test job
- **content-library-test**: Content management testing
- **deploy-functions**: Firebase Functions deployment
- **deploy-web**: Web app deployment
- **deploy-android**: Android app distribution
- **deploy-ios**: iOS app distribution
- **security-scan**: Security analysis
- **performance-test**: Performance testing

## Required GitHub Secrets

You need to configure the following secrets in your GitHub repository settings:

### Repository Secrets Setup

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret** for each of the following:

### Core Secrets

| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `GHE_ENTERPRISE` | GitHub Enterprise hostname (e.g., `github.company.com`) | Network allowlist configuration |
| `GHE_TOKEN` | GitHub Enterprise personal access token | Network allowlist configuration |
| `FIREBASE_TOKEN` | Firebase CLI token for deployment | All deployment jobs |

### Firebase App Distribution Secrets

| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `FIREBASE_APP_ID` | Firebase Android app ID | Android deployment |
| `FIREBASE_IOS_APP_ID` | Firebase iOS app ID | iOS deployment |

### Optional Secrets

| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `CODECOV_TOKEN` | Codecov token for coverage reporting | Coverage uploads |

## How to Obtain Secrets

### Firebase Token
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login to Firebase
firebase login

# Generate CI token
firebase login:ci
```

### GitHub Enterprise Token
1. Go to your GitHub Enterprise instance
2. Navigate to **Settings** → **Developer settings** → **Personal access tokens**
3. Generate a new token with appropriate permissions

### Firebase App IDs
1. Go to Firebase Console
2. Navigate to **Project Settings** → **General**
3. Scroll down to **Your apps** section
4. Copy the App ID for each platform

## Workflow Triggers

The workflows are triggered on:

- **Push** to `main` or `develop` branches
- **Pull Request** to `main` or `develop` branches

## Job Dependencies

```
build-and-test
├── content-library-test
├── deploy-functions
├── deploy-web
├── deploy-android
├── deploy-ios
├── security-scan
└── performance-test
```

All deployment and testing jobs depend on the successful completion of `build-and-test`.

## Environment Variables

The workflow uses several environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `FLUTTER_VERSION` | Flutter SDK version | `3.19.3` |
| `DART_VERSION` | Dart SDK version | `3.3.1` |
| `PUB_HOSTED_URL` | Pub package repository URL | Varies by job |
| `FLUTTER_STORAGE_BASE_URL` | Flutter storage base URL | `https://storage.googleapis.com` |
| `FLUTTER_CACHE_DIR` | Flutter cache directory | `~/.flutter` |
| `PUB_CACHE` | Pub cache directory | `~/.pub-cache` |

## Container Configuration

All jobs run in a custom container:
- **Image**: `ghcr.io/your-org/app-oint-dev:latest`
- **Options**: `--pull` (always pull latest)

## Network Access Requirements

The workflow performs network connectivity checks for:

- `storage.googleapis.com` - Flutter storage
- `pub.dev` - Dart package repository
- `firebase-public.firebaseio.com` - Firebase services
- `raw.githubusercontent.com` - GitHub raw content
- `dart.dev` - Dart documentation
- `metadata.google.internal` - Google metadata service
- `169.254.169.254` - AWS metadata service

## Caching Strategy

The workflow implements several caching layers:

1. **Pub Cache**: Caches Dart packages
2. **Flutter Cache**: Caches Flutter artifacts
3. **Build Cache**: Caches build outputs

## Error Handling

The workflow includes comprehensive error handling:

- **Retry Logic**: Network operations retry on failure
- **Graceful Degradation**: Offline fallbacks where possible
- **Conditional Steps**: Some steps only run on specific conditions
- **Always Cleanup**: Emulator cleanup runs even on failure

## Security Considerations

- **Secrets**: All sensitive data is stored as GitHub secrets
- **Network Security**: Network access is validated before operations
- **Container Security**: Uses trusted container images
- **Token Rotation**: Firebase tokens should be rotated regularly

## Troubleshooting

### Common Issues

1. **Secret Not Found**: Ensure all required secrets are configured
2. **Network Access Denied**: Check firewall and proxy settings
3. **Container Pull Failed**: Verify container image exists and is accessible
4. **Firebase Deployment Failed**: Check Firebase token and project configuration

### Debug Steps

1. Check workflow logs for specific error messages
2. Verify secret names match exactly (case-sensitive)
3. Test network connectivity manually
4. Validate Firebase project configuration

## Performance Optimizations

- **Parallel Jobs**: Independent jobs run in parallel
- **Caching**: Extensive use of GitHub Actions caching
- **Container Reuse**: Container image is reused across jobs
- **Selective Deployment**: Only deploy what changed

## Monitoring

Monitor workflow performance through:

- GitHub Actions dashboard
- Workflow run logs
- Deployment status pages
- Firebase console for deployments

## Support

For issues with the CI/CD pipeline:

1. Check this documentation
2. Review workflow logs
3. Verify secret configuration
4. Test locally if possible
5. Contact the development team

# CI/CD and Proxy Integration Guide

This guide covers the continuous integration, deployment, and proxy integration setup for the AppOint project.

## 🚀 Overview

Our CI/CD pipeline automates testing, building, and deployment across multiple environments using GitHub Actions and Firebase.

## 📁 Workflow Structure

```
.github/workflows/
├── pr_checks.yml          # Pull request validation
├── release.yml            # Release and deployment
├── firebase_deploy.yml    # Firebase deployment
└── README.md              # This guide
```

## 🔧 Workflow Details

### PR Checks (`pr_checks.yml`)

**Triggers**: Pull requests to main branch

**Steps**:
1. **Setup**: Install Flutter and dependencies
2. **Analysis**: Run `flutter analyze` for code quality
3. **Tests**: Execute unit and integration tests
4. **Build**: Verify builds for Android and iOS
5. **Firestore Rules**: Validate Firestore security rules
6. **Lint**: Check code formatting and style

**Usage**:
```bash
# Local validation (same as CI)
flutter analyze
flutter test
flutter build apk --debug
```

### Release (`release.yml`)

**Triggers**: Tags matching `v*` pattern

**Steps**:
1. **Version Bump**: Automatically increment version
2. **Build**: Create production builds
3. **Artifacts**: Generate APK/IPA files
4. **Deploy**: Deploy to Firebase App Distribution
5. **Release Notes**: Generate release notes

**Usage**:
```bash
# Create a new release
git tag v1.2.3
git push origin v1.2.3
```

## 🔐 Environment Configuration

### Required Secrets

Configure these secrets in GitHub repository settings:

```yaml
# Firebase Configuration
FIREBASE_PROJECT_ID: "appoint-production"
FIREBASE_SERVICE_ACCOUNT_KEY: "base64-encoded-service-account.json"

# DigitalOcean Spaces
DO_SPACES_ACCESS_KEY: "your-access-key"
DO_SPACES_SECRET_KEY: "your-secret-key"
DO_SPACES_BUCKET: "appoint-assets"
DO_SPACE_DOMAIN: "your-space-domain.digitaloceanspaces.com"

# App Distribution
FIREBASE_APP_ID_ANDROID: "1:123456789:android:abcdef"
FIREBASE_APP_ID_IOS: "1:123456789:ios:abcdef"
```

### Environment Variables

```yaml
# Development
FLUTTER_VERSION: "3.32.0"
DART_VERSION: "3.4.0"

# Build Configuration
ANDROID_BUILD_TYPE: "release"
IOS_BUILD_TYPE: "release"
```

## 🌐 Proxy Integration

### Firebase Hosting Proxy

Configure Firebase hosting to proxy API requests:

```json
// firebase.json
{
  "hosting": {
    "public": "build/web",
    "rewrites": [
      {
        "source": "/api/**",
        "function": "api"
      },
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

### Cloud Functions Proxy

API requests are proxied through Firebase Cloud Functions:

```typescript
// functions/src/index.ts
export const api = functions.https.onRequest((req, res) => {
  // Proxy logic for external APIs
  // Rate limiting and authentication
  // Request/response transformation
});
```

## 📱 Build Configuration

### Android Build

```yaml
# android/app/build.gradle.kts
android {
  compileSdkVersion 34
  
  defaultConfig {
    applicationId "com.appoint.app"
    minSdkVersion 21
    targetSdkVersion 34
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
  }
  
  buildTypes {
    release {
      signingConfig signingConfigs.release
      minifyEnabled true
      proguardFiles getDefaultProguardFile('proguard-android.txt')
    }
  }
}
```

### iOS Build

```yaml
# ios/Runner.xcodeproj/project.pbxproj
# Configure signing and capabilities
# Set up App Store Connect integration
```

## 🔄 Deployment Pipeline

### Development → Staging → Production

1. **Development**: Automatic deployment on PR merge
2. **Staging**: Manual deployment from staging branch
3. **Production**: Automatic deployment on release tags

### Deployment Targets

- **Firebase App Distribution**: Internal testing
- **Firebase Hosting**: Web application
- **App Store Connect**: iOS App Store
- **Google Play Console**: Android Play Store

## 📊 Monitoring and Analytics

### Build Metrics

Track build performance and success rates:
- Build duration
- Success/failure rates
- Test coverage
- Code quality metrics

### Deployment Metrics

Monitor deployment health:
- Deployment frequency
- Rollback rates
- Environment parity
- Release success rates

## 🛠️ Troubleshooting

### Common Issues

1. **Build Failures**
   ```bash
   # Clear build cache
   flutter clean
   flutter pub get
   ```

2. **Test Failures**
   ```bash
   # Run tests with verbose output
   flutter test --verbose
   ```

3. **Deployment Issues**
   ```bash
   # Check Firebase CLI
   firebase --version
   firebase projects:list
   ```

### Debug Commands

```bash
# Local validation
flutter doctor
flutter analyze
flutter test
flutter build apk --debug

# Firebase validation
firebase deploy --dry-run
firebase functions:config:get
```

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Firebase CLI Documentation](https://firebase.google.com/docs/cli)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/ci)
- [Firebase Hosting Configuration](https://firebase.google.com/docs/hosting)

## 🤝 Contributing

When adding new workflows:
1. Test locally first
2. Add appropriate documentation
3. Update this README
4. Review with the team 