# APP-OINT Deployment Guide

## Overview

This guide provides comprehensive instructions for deploying the APP-OINT project across all platforms. APP-OINT is a Flutter-based appointment booking application with Firebase backend services, supporting web, iOS, and Android platforms.

## Prerequisites

### Required Tools and Versions

- **Node.js**: 18.x or higher (specified in `functions/package.json` engines field)
- **Firebase CLI**: 12.0.0 or higher
- **Flutter SDK**: 3.32.0 or higher
- **Dart SDK**: 3.4.0 or higher
- **Fastlane**: 2.210.0 or higher (for mobile releases)
- **Xcode**: 15.0 or higher (for iOS builds)
- **Android Studio**: Latest stable version (for Android builds)

### Verify Installations

```bash
# Check Node.js version
node --version

# Check Firebase CLI version
firebase --version

# Check Flutter version
flutter --version

# Check Fastlane version
fastlane --version
```

## Setting Up Environment

### 1. Clone and Setup Project

```bash
# Clone the repository
git clone https://github.com/gabriellagziel/appoint.git
cd appoint

# Install Node.js dependencies
cd functions
npm install
cd ..

# Install Flutter dependencies
flutter pub get
```

### 2. Configure Environment Variables

Create the following environment files:

```bash
# Root directory
cp .env.example .env

# Functions directory
cd functions
cp .env.example .env
cd ..
```

Configure the following variables in your `.env` files:

```env
# Firebase Configuration
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_API_KEY=your-api-key
FIREBASE_AUTH_DOMAIN=your-project.firebaseapp.com
FIREBASE_STORAGE_BUCKET=your-project.appspot.com
FIREBASE_MESSAGING_SENDER_ID=your-sender-id
FIREBASE_APP_ID=your-app-id

# Stripe Configuration (for payments)
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...

# Other Services
SENDGRID_API_KEY=your-sendgrid-key
```

### 3. Firebase Project Setup

```bash
# Login to Firebase
firebase login

# Initialize Firebase project (if not already done)
firebase init

# Select your project
firebase use your-project-id
```

## Firebase Hosting Deployment

### Deploy Web App

```bash
# Build the Flutter web app
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting

# Deploy to specific hosting target (if configured)
firebase deploy --only hosting:production
```

### Rollback Hosting

```bash
# List recent deployments
firebase hosting:releases

# Rollback to previous version
firebase hosting:rollback

# Rollback to specific version
firebase hosting:rollback VERSION_ID
```

## Cloud Functions Deployment

### 1. Configure Functions

Ensure your `functions/package.json` includes the correct Node.js engine:

```json
{
  "engines": {
    "node": "18"
  },
  "dependencies": {
    "firebase-admin": "^12.0.0",
    "firebase-functions": "^4.5.0"
  }
}
```

### 2. Deploy Functions

```bash
# Deploy all functions
firebase deploy --only functions

# Deploy specific function
firebase deploy --only functions:functionName

# Deploy with environment variables
firebase functions:config:set stripe.secret_key="sk_test_..."
firebase deploy --only functions
```

### 3. Function Management

```bash
# List deployed functions
firebase functions:list

# View function logs
firebase functions:log

# Delete function
firebase functions:delete functionName
```

## Mobile App Release

### iOS (App Store & TestFlight)

#### 1. Setup Fastlane

```bash
# Navigate to iOS directory
cd ios

# Initialize Fastlane (if not already done)
fastlane init

# Install Fastlane dependencies
bundle install
```

#### 2. Configure Fastfile

Ensure your `ios/fastlane/Fastfile` includes the following lanes:

```ruby
# Beta deployment to TestFlight
lane :beta do
  setup_ci if is_ci
  
  # Increment build number
  increment_build_number
  
  # Build and upload to TestFlight
  build_ios_app(
    scheme: "Runner",
    export_method: "app-store",
    configuration: "Release"
  )
  
  upload_to_testflight(
    REDACTED_TOKEN: true
  )
end

# Production deployment to App Store
lane :release do
  setup_ci if is_ci
  
  # Increment version and build number
  increment_version_number
  increment_build_number
  
  # Build and upload to App Store
  build_ios_app(
    scheme: "Runner",
    export_method: "app-store",
    configuration: "Release"
  )
  
  upload_to_app_store(
    skip_metadata: true,
    skip_screenshots: true
  )
end
```

#### 3. Deploy to TestFlight

```bash
# Deploy beta version
fastlane ios beta

# Deploy production version
fastlane ios release
```

#### 4. Rollback iOS Release

```bash
# Reject the latest build in App Store Connect
# Or use App Store Connect API to manage releases
```

### Android (Google Play & Internal Testing)

#### 1. Setup Fastlane

```bash
# Navigate to Android directory
cd android

# Initialize Fastlane (if not already done)
fastlane init

# Install Fastlane dependencies
bundle install
```

#### 2. Configure Fastfile

Ensure your `android/fastlane/Fastfile` includes:

```ruby
# Beta deployment to Internal Testing
lane :beta do
  setup_ci if is_ci
  
  # Increment version code
  increment_version_code
  
  # Build APK/AAB
  gradle(
    task: "clean assembleRelease",
    project_dir: "."
  )
  
  # Upload to Google Play Internal Testing
  upload_to_play_store(
    track: 'internal',
    aab: '../build/app/outputs/bundle/release/app-release.aab'
  )
end

# Production deployment to Google Play
lane :release do
  setup_ci if is_ci
  
  # Increment version name and code
  increment_version_name
  increment_version_code
  
  # Build AAB
  gradle(
    task: "clean bundleRelease",
    project_dir: "."
  )
  
  # Upload to Google Play Production
  upload_to_play_store(
    track: 'production',
    aab: '../build/app/outputs/bundle/release/app-release.aab'
  )
end
```

#### 3. Deploy to Google Play

```bash
# Deploy beta version
fastlane android beta

# Deploy production version
fastlane android release
```

#### 4. Rollback Android Release

```bash
# Use Google Play Console to rollback to previous version
# Or use Google Play Developer API
```

## Web App Deployment

### Build Web App

```bash
# Build for production
flutter build web --release

# Build with specific base href
flutter build web --release --base-href "/app/"
```

### Deploy to Firebase Hosting

```bash
# Deploy to Firebase Hosting
firebase deploy --only hosting

# Deploy to specific hosting target
firebase deploy --only hosting:production
```

### Deploy to Netlify (Alternative)

```bash
# Install Netlify CLI
npm install -g netlify-cli

# Deploy to Netlify
netlify deploy --prod --dir=build/web
```

## CI/CD Integration

### GitHub Actions Workflow

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy APP-OINT

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]
  workflow_dispatch:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
          channel: 'stable'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Run tests
        run: flutter test
      
      - name: Analyze code
        run: flutter analyze

  deploy-web:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.32.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build web
        run: flutter build web --release
      
      - name: Deploy to Firebase
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: ${{ secrets.FIREBASE_PROJECT_ID }}
          channelId: live

  deploy-functions:
    needs: test
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
          cache-dependency-path: functions/package-lock.json
      
      - name: Install dependencies
        working-directory: functions
        run: npm ci
      
      - name: Deploy Functions
        uses: FirebaseExtended/action-hosting-deploy@v0
        with:
          repoToken: '${{ secrets.GITHUB_TOKEN }}'
          firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
          projectId: ${{ secrets.FIREBASE_PROJECT_ID }}
          only: functions
```

### Required Secrets

Configure the following secrets in your GitHub repository:

- `FIREBASE_SERVICE_ACCOUNT`: Firebase service account JSON
- `FIREBASE_PROJECT_ID`: Your Firebase project ID
- `APP_STORE_CONNECT_API_KEY`: iOS App Store Connect API key
- `GOOGLE_PLAY_SERVICE_ACCOUNT`: Google Play service account JSON

## Troubleshooting & Rollback

### Common Issues

#### 1. Firebase Deployment Failures

```bash
# Check Firebase project configuration
firebase projects:list

# Verify current project
firebase use

# Clear Firebase cache
firebase logout
firebase login
```

#### 2. Flutter Build Issues

```bash
# Clean Flutter build
flutter clean
flutter pub get

# Check Flutter doctor
flutter doctor

# Update Flutter
flutter upgrade
```

#### 3. Fastlane Issues

```bash
# Update Fastlane
bundle update fastlane

# Check Fastlane setup
fastlane doctor

# Clear derived data (iOS)
rm -rf ~/Library/Developer/Xcode/DerivedData
```

### Rollback Procedures

#### Firebase Hosting Rollback

```bash
# List recent deployments
firebase hosting:releases

# Rollback to previous version
firebase hosting:rollback

# Rollback to specific version
firebase hosting:rollback VERSION_ID
```

#### Cloud Functions Rollback

```bash
# List function versions
firebase functions:list

# Rollback specific function
firebase functions:delete functionName
firebase deploy --only functions:functionName
```

#### Mobile App Rollback

**iOS:**
- Use App Store Connect to reject the latest build
- Re-upload previous version if needed

**Android:**
- Use Google Play Console to rollback to previous version
- Update version code and re-upload

### Emergency Procedures

1. **Immediate Rollback**: Use Firebase hosting rollback for web issues
2. **Function Issues**: Disable problematic functions in Firebase Console
3. **Mobile Issues**: Use platform-specific rollback procedures
4. **Database Issues**: Restore from Firebase backup (if configured)

## Monitoring and Alerts

### Firebase Monitoring

```bash
# View function logs
firebase functions:log

# Monitor hosting performance
firebase hosting:channel:list

# Check project usage
firebase projects:list
```

### Set up Alerts

1. Configure Firebase Console alerts for function errors
2. Set up Google Play Console alerts for app crashes
3. Monitor App Store Connect for iOS app issues
4. Configure GitHub Actions notifications for deployment failures

## Security Considerations

1. **Environment Variables**: Never commit sensitive data to version control
2. **Service Accounts**: Use least-privilege access for service accounts
3. **API Keys**: Rotate API keys regularly
4. **Firebase Rules**: Review and update Firestore security rules
5. **Mobile Signing**: Secure your mobile app signing keys

## Best Practices

1. **Version Management**: Always increment version numbers appropriately
2. **Testing**: Test deployments in staging environment first
3. **Documentation**: Keep deployment procedures updated
4. **Backup**: Regular backups of configuration and data
5. **Monitoring**: Set up comprehensive monitoring and alerting
6. **Rollback Plan**: Always have a rollback strategy ready

---

For additional support, refer to:
- [Firebase Documentation](https://firebase.google.com/docs)
- [Flutter Deployment Guide](https://docs.flutter.dev/deployment)
- [Fastlane Documentation](https://docs.fastlane.tools)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
