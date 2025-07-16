#!/bin/bash

# Create Pull Request Script
# This script helps create a PR for the CI/CD pipeline changes

set -e

echo "🚀 Creating Pull Request for CI/CD Pipeline..."

# Get the current branch
CURRENT_BRANCH=$(git branch --show-current)
echo "📋 Current branch: $CURRENT_BRANCH"

# Get the commit message
COMMIT_MSG=$(git log -1 --pretty=%B)
echo "📝 Last commit: $COMMIT_MSG"

# Create PR title and description
PR_TITLE="🚀 Add comprehensive CI/CD pipeline for Flutter web, Android, and iOS"
PR_DESCRIPTION="## 🎯 Full Automation via CI

This PR implements a comprehensive CI/CD pipeline that handles all Flutter build, test, and deployment tasks automatically.

### ✅ Features Added

- **Flutter 3.32.5** with Dart 3.5.4
- **Automatic code generation** (`.g.dart` and `.freezed.dart`)
- **Multi-platform builds** (Web, Android, iOS)
- **Comprehensive testing** (Unit, Widget, Integration)
- **Smart caching** for dependencies
- **Security scanning** and vulnerability checks
- **Deployment** to Firebase Hosting and DigitalOcean
- **Rollback support** for failed deployments

### 📁 Files Added

- `.github/workflows/main_ci.yml` - Main CI/CD pipeline
- `do-app.yaml` - DigitalOcean App Platform configuration
- `scripts/setup-digitalocean.sh` - Automated setup script
- `.github/workflows/README.md` - Comprehensive documentation
- `CI_CD_SETUP_COMPLETE.md` - Complete setup guide

### 🔧 Key Benefits

- **No local development required** - All builds run in GitHub Actions
- **Automatic code generation** - `build_runner` runs automatically
- **Multi-platform support** - Web, Android, and iOS builds
- **Smart caching** - Optimized dependency caching
- **Comprehensive testing** - Unit, widget, and integration tests
- **Security scanning** - Dependency vulnerability checks
- **Deployment** - Firebase Hosting and DigitalOcean App Platform
- **Rollback support** - Automatic rollback on failures

### 🚀 Usage

1. **Automatic triggers**: Push to main/develop branches
2. **Manual triggers**: Use GitHub Actions workflow dispatch
3. **Deployment**: Automatic deployment to Firebase and DigitalOcean

### 🔑 Required Secrets

Add these to your GitHub repository secrets:
- `DIGITALOCEAN_ACCESS_TOKEN`: DigitalOcean API token
- `FIREBASE_TOKEN`: Firebase CLI token
- `DIGITALOCEAN_APP_ID`: DigitalOcean App Platform app ID

### 📊 What Happens on Push

1. **Validate Setup** → Checks all secrets and configuration
2. **Setup Dependencies** → Installs Flutter, Dart, Java, Node.js
3. **Generate Code** → Runs `build_runner` for `.g.dart` and `.freezed.dart`
4. **Analyze Code** → Flutter analyze and formatting
5. **Run Tests** → Unit, widget, integration tests with coverage
6. **Security Scan** → Vulnerability checks
7. **Build Applications** → Web, Android, iOS builds
8. **Deploy** → Firebase and DigitalOcean deployments
9. **Create Release** → GitHub releases (if tagged)

### 🎯 Mission Complete

This PR enables **full automation via CI** with:
- ✅ No local development required
- ✅ Automatic code generation
- ✅ Multi-platform builds
- ✅ Comprehensive testing
- ✅ Automated deployments
- ✅ Rollback support

**You can now develop entirely from Cursor Web on your iPad!** 🎉

---

**Files changed:**
- Added comprehensive CI/CD pipeline
- Added DigitalOcean configuration
- Added setup scripts and documentation
- Updated workflow documentation"

echo ""
echo "🔗 Create Pull Request manually:"
echo "https://github.com/gabriellagziel/appoint/compare/main...$CURRENT_BRANCH"
echo ""
echo "📋 PR Title:"
echo "$PR_TITLE"
echo ""
echo "📝 PR Description:"
echo "$PR_DESCRIPTION"
echo ""
echo "🎯 Next steps:"
echo "1. Go to the GitHub repository"
echo "2. Click 'Compare & pull request'"
echo "3. Use the title and description above"
echo "4. Review the changes"
echo "5. Merge the PR"
echo ""
echo "✅ Ready to create PR!"