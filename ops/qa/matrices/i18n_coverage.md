# 🚀 App-Oint Release Checklist

## Overview
This document provides a comprehensive checklist for releasing App-Oint applications, covering all web apps, mobile builds, and deployment steps.

## 📋 Pre-Release Validation

### 1. Repository Status
* [ ] **Branch clean**: `git status` → no uncommitted changes
* [ ] **CI green**: Last pipeline run on `main` passed all workflows
* [ ] **Dependencies locked**: All package managers have lock files committed

### 2. Dependency Validation
* [ ] **Flutter (appoint)**: 
  ```bash
  cd appoint
  flutter pub get && flutter pub outdated
  ```
  Confirm no breaking dependency bumps

* [ ] **Node.js apps**: 
  ```bash
  # Marketing app
  cd marketing && npm ci && npm audit --omit=dev
  
  # Business app  
  cd business && npm ci && npm audit --omit=dev
  
  # Enterprise app
  cd enterprise-app && npm ci && npm audit --omit=dev
  
  # Dashboard app
  cd dashboard && npm ci && npm audit --omit=dev
  
  # Cloud Functions
  cd functions && npm ci && npm audit --omit=dev
  ```
  Confirm production dependencies are clean

### 3. Test Suite Validation
* [ ] **Flutter tests**: `cd appoint && flutter test --coverage`
* [ ] **Node.js tests**: Run test suites for all apps
* [ ] **Integration tests**: `cd appoint && flutter test integration_test/`
* [ ] **Accessibility tests**: `cd appoint && flutter test test/a11y/`

---

## 🏷️ Versioning & Tagging

### 4. Version Bump
* [ ] **Flutter app**: Update `appoint/pubspec.yaml`
  ```yaml
  version: X.Y.Z+build  # e.g., 1.0.0+2
  ```

* [ ] **Node.js apps**: Update `package.json` versions consistently
  ```json
  // marketing/package.json
  "version": "X.Y.Z"
  
  // business/package.json  
  "version": "X.Y.Z"
  
  // enterprise-app/package.json
  "version": "X.Y.Z"
  
  // dashboard/package.json
  "version": "X.Y.Z"
  
  // functions/package.json
  "version": "X.Y.Z"
  ```

### 5. Changelog Generation
* [ ] **Generate changelog**:
  ```bash
  # Using existing script
  ./scripts/update_changelog.sh
  
  # Or manual generation
  npx changelogen --from <last_tag> --to HEAD
  ```

* [ ] **Commit changelog**:
  ```bash
  git add CHANGELOG.md
  git commit -m "chore(release): update changelog for vX.Y.Z"
  ```

### 6. Release Tagging
* [ ] **Create and push tag**:
  ```bash
  git tag -a vX.Y.Z -m "Release vX.Y.Z"
  git push origin vX.Y.Z
  ```

---

## 🚀 Deployment Steps

### 7. Flutter PWA (appoint)
* [ ] **Build web version**:
  ```bash
  cd appoint
  flutter build web --release --no-tree-shake-icons
  ```
* [ ] **Deploy to Firebase Hosting** (or DO App if configured)
* [ ] **Verify PWA functionality** in production

### 8. Next.js Web Applications
* [ ] **Marketing app**:
  ```bash
  cd marketing
  npm run build  # Verify no build errors
  # Deploy to Vercel/DO Apps
  ```

* [ ] **Business app**:
  ```bash
  cd business  
  npm run build  # Verify no build errors
  # Deploy to Vercel/DO Apps
  ```

* [ ] **Enterprise app**:
  ```bash
  cd enterprise-app
  npm run build  # Verify no build errors  
  # Deploy to Vercel/DO Apps
  ```

* [ ] **Dashboard app**:
  ```bash
  cd dashboard
  npm run build  # Verify no build errors
  # Deploy to Vercel/DO Apps
  ```

### 9. Cloud Functions
* [ ] **Build and deploy**:
  ```bash
  cd functions
  npm ci && npm run build
  firebase deploy --only functions
  ```

### 10. Mobile Applications
* [ ] **Android builds** (handled by CI):
  - APK files for multiple architectures
  - App Bundle (.aab) for Play Store
* [ ] **iOS builds** (handled by CI):
  - iOS app bundle
  - Fastlane deployment if configured

---

## ✅ Post-Deployment Validation

### 11. Web Application Validation
* [ ] **Marketing landing page**: Load speed < 2s, no console errors
* [ ] **Business dashboard**: Login flow works, navigation functional
* [ ] **Enterprise landing page**: Renders correctly, no placeholders
* [ ] **Dashboard app**: Authentication and core features working
* [ ] **Flutter PWA**: Meeting creation flow runs end-to-end

### 12. Mobile Application Validation
* [ ] **Android APK**: Install and run on test devices
* [ ] **iOS app**: Test on simulator/device if available
* [ ] **App Store/Play Store**: Verify release is live

### 13. Backend Services
* [ ] **Cloud Functions**: API endpoints responding correctly
* [ ] **Firebase services**: Authentication, Firestore, hosting working
* [ ] **Monitoring**: Sentry/Crashlytics capturing errors

---

## 📊 Monitoring & Rollout

### 14. Performance Monitoring
* [ ] **Lighthouse CI**: Run post-release (can be async)
* [ ] **Core Web Vitals**: Monitor LCP, FID, CLS
* [ ] **Error tracking**: Verify Sentry/Crashlytics integration

### 15. Infrastructure Monitoring
* [ ] **Firebase logs**: Monitor for errors/performance issues
* [ ] **DO App metrics**: Track resource usage and performance
* [ ] **CI/CD pipelines**: Verify all workflows complete successfully

### 16. Release Communication
* [ ] **Changelog published**: Update release notes
* [ ] **Team notification**: Slack/Discord announcements
* [ ] **Version bump**: All apps show consistent versioning

---

## 🔧 CI/CD Integration

### 17. Automated Release Process
* [ ] **Tag trigger**: CI automatically builds on `v*` tags
* [ ] **Artifact generation**: APKs, app bundles, web builds
* [ ] **Release creation**: GitHub release with assets
* [ ] **Notification**: Slack/Discord webhooks working

### 18. Rollback Preparation
* [ ] **Previous version**: Keep previous release artifacts
* [ ] **Database migrations**: Ensure rollback scripts available
* [ ] **Feature flags**: Verify can disable problematic features

---

## 📝 Release Notes Template

### Version X.Y.Z - YYYY-MM-DD

#### 🚀 New Features
- Feature 1 description
- Feature 2 description

#### 🐛 Bug Fixes  
- Fix 1 description
- Fix 2 description

#### 🔧 Improvements
- Improvement 1 description
- Improvement 2 description

#### 📱 Platform Updates
- **Flutter**: Version updates, dependency changes
- **Web Apps**: Next.js version, component updates
- **Mobile**: iOS/Android specific changes

#### 🚨 Breaking Changes
- List any breaking changes with migration steps

#### 📊 Performance
- Performance improvements and metrics

---

## ✅ Release Completion Checklist

* [ ] All version numbers updated consistently
* [ ] Changelog generated and committed
* [ ] Release tag created and pushed
* [ ] All applications deployed successfully
* [ ] Post-deployment validation completed
* [ ] Monitoring and alerting configured
* [ ] Team notified of release
* [ ] CI/CD pipeline completed successfully

---

**🎉 Once all boxes are ticked → vX.Y.Z is live and stable!**

## 📚 Additional Resources

- [CI/CD Workflows](/.github/workflows/)
- [Deployment Scripts](/scripts/)
- [Testing Documentation](/docs/qa/)
- [Performance Monitoring](/monitoring/)
- [Security Policies](/security/)
