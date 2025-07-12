# APP-OINT

[![Release](https://img.shields.io/github/v/release/gabriellagziel/appoint)]
[![Build](https://github.com/gabriellagziel/appoint/workflows/Build/badge.svg)](https://github.com/gabriellagziel/appoint/actions/workflows/build.yml)
[![Test](https://github.com/gabriellagziel/appoint/workflows/Test/badge.svg)](https://github.com/gabriellagziel/appoint/actions/workflows/test.yml)
[![Security](https://github.com/gabriellagziel/appoint/workflows/Security/badge.svg)](https://github.com/gabriellagziel/appoint/actions/workflows/security.yml)
[![Coverage](https://img.shields.io/codecov/c/github/gabriellagziel/appoint?flag=unit)]
[![Codecov](https://codecov.io/gh/gabriellagziel/appoint/branch/main/graph/badge.svg)](https://codecov.io/gh/gabriellagziel/appoint)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive appointment booking and management application built with Flutter, featuring real-time chat, business management, and multi-platform support.

## 🚀 Features

### Core Features
- **Appointment Booking**: Easy-to-use booking system with real-time availability
- **Business Management**: Complete studio and business management tools
- **Real-time Chat**: Integrated chat system for customer support
- **Multi-platform**: iOS, Android, and Web support
- **Admin Panel**: Comprehensive admin dashboard with analytics
- **Ambassador Program**: Referral and ambassador management system

### Technical Features
- **State Management**: Riverpod for reactive state management
- **Authentication**: Firebase Auth with multiple providers
- **Database**: Cloud Firestore for real-time data
- **Payments**: Stripe integration for secure payments
- **Notifications**: Push notifications with Firebase Cloud Messaging
- **Analytics**: Firebase Analytics and custom performance monitoring
- **Localization**: Support for 100+ languages
- **Deep Linking**: Comprehensive deep linking support

## 📱 Screenshots

<div align="center">
  <img src="docs/images/calendar.png" alt="Calendar View" width="300"/>
  <img src="docs/images/booking.png" alt="Booking Interface" width="300"/>
  <img src="docs/images/chat.png" alt="Chat System" width="300"/>
  <img src="docs/images/admin.png" alt="Admin Panel" width="300"/>
</div>

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.32.0+
- **Language**: Dart 3.4.0+
- **State Management**: Riverpod 2.6.1
- **Navigation**: Go Router 13.2.0
- **UI Components**: Material Design 3

### Backend
- **Database**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Storage**: Firebase Storage
- **Functions**: Firebase Cloud Functions
- **Analytics**: Firebase Analytics
- **Messaging**: Firebase Cloud Messaging

### Third-party Services
- **Payments**: Stripe
- **Maps**: Google Maps
- **Ads**: Google Mobile Ads
- **Charts**: FL Chart, Syncfusion Charts

## 📋 Prerequisites

- Flutter 3.32.0 or higher
- Dart 3.4.0 or higher
- Android Studio / Xcode (for mobile development)
- Firebase project setup
- Stripe account (for payments)

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/gabriellagziel/appoint
cd appoint
```

### 2. Setup Dependencies
```bash
# Run the setup script
./scripts/setup_dependencies.sh

# Or manually
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
```

### 3. Configure Firebase
1. Create a Firebase project
2. Download configuration files:
   - `google-services.json` for Android
   - `GoogleService-Info.plist` for iOS
   - Web configuration for web platform
3. Place files in appropriate directories

### 4. Configure Environment Variables

**Important**: The application uses environment variables for sensitive configuration. See [Environment Setup Guide](docs/environment_setup.md) for detailed instructions.

Create a `.env` file in the root directory with the following variables:

```env
# Required for payments
STRIPE_PUBLISHABLE_KEY=your_stripe_publishable_key

# Required for Firebase
FIREBASE_PROJECT_ID=your_firebase_project_id

# Required for Google OAuth
GOOGLE_CLIENT_ID=your_google_client_id

# Optional - API endpoints (defaults provided)
FAMILY_API_BASE_URL=https://api.yourapp.com/api/v1/family
AUTH_REDIRECT_URI=http://localhost:8080/__/auth/handler
DEEP_LINK_BASE_URL=https://app-oint-core.web.app
WHATSAPP_BASE_URL=https://app-oint-core.web.app
WHATSAPP_API_URL=https://wa.me/?text=
```

**Security Note**: Never commit your `.env` file to version control. It's already included in `.gitignore`.

**Validation**: Run the environment validation script to check your setup:
```bash
dart scripts/validate_env.dart
```

### 5. Run the Application
```bash
# For development
flutter run

# For specific platforms
flutter run -d chrome  # Web
flutter run -d android # Android
flutter run -d ios     # iOS
```

## 🏗️ Project Structure

```
APP-OINT/
├── lib/
│   ├── features/           # Feature modules
│   │   ├── admin/         # Admin panel
│   │   ├── auth/          # Authentication
│   │   ├── booking/       # Booking system
│   │   ├── business/      # Business management
│   │   └── studio/        # Studio features
│   ├── core/              # Core functionality
│   ├── shared/            # Shared components
│   ├── services/          # Business logic services
│   └── providers/         # State management
├── test/                  # Test files
├── integration_test/      # Integration tests
├── docs/                  # Documentation
├── scripts/               # Build and utility scripts
└── config/                # Configuration files
```

## 🧪 Testing

### Run Tests
```bash
# Unit and widget tests
flutter test

# Integration tests
flutter test integration_test/

# Test with coverage
flutter test --coverage

# Run specific test file
flutter test test/services/failure_scenario_service_tests.dart

# Run Cloud Functions tests
cd functions && npm test
```

### Test Structure
- **Unit Tests**: `test/` directory
- **Widget Tests**: `test/` directory  
- **Integration Tests**: `integration_test/` directory
- **Performance Tests**: `integration_test/` directory
- **Cloud Functions Tests**: `functions/test/` directory
- **Failure Scenario Tests**: `test/services/failure_scenario_service_tests.dart`

### Test Coverage
- **Coverage Threshold**: 80% minimum
- **Coverage Report**: Available on [Codecov](https://codecov.io/gh/gabriellagziel/appoint)
- **Coverage Badge**: ![Codecov](https://codecov.io/gh/gabriellagziel/appoint/branch/main/graph/badge.svg)

### Failure Scenario Testing
The app includes comprehensive failure scenario tests that simulate:
- **Payment Processing Failures**: Stripe API errors, network issues, timeouts
- **Authentication Failures**: Invalid credentials, account disabled, rate limiting
- **Error Recovery**: Automatic retry mechanisms and graceful degradation
- **Error Messages**: Meaningful error messages for better user experience

### CI/CD Testing
- **Automated Testing**: All tests run on every PR and push
- **Lint Enforcement**: Code analysis enforced in CI pipeline
- **Nightly Builds**: Automated builds run daily at 02:00 UTC
- **Build Artifacts**: APK and IPA files generated for testing

## 🔧 Configuration

### Environment Setup
The app supports multiple environments:
- **Development**: `flutter run --flavor dev`
- **Staging**: `flutter run --flavor staging`
- **Production**: `flutter run --flavor prod`

### Platform-specific Configuration
- **Android**: `android/app/build.gradle.kts`
- **iOS**: `ios/Runner/Info.plist`
- **Web**: `web/index.html`

## 🌐 Localization

The app supports 100+ languages. To add a new language:

1. Create a new ARB file in `lib/l10n/`
2. Add the language to `lib/constants/languages.dart`
3. Run `flutter gen-l10n`

## 🔒 Security

### Security Features
- Firebase App Check for API protection
- Secure storage for sensitive data
- Input validation and sanitization
- HTTPS enforcement
- Certificate pinning

### Security Audit
Run the security audit script:
```bash
./scripts/security_audit.sh
```

## 📊 Performance

### Performance Monitoring
The app includes comprehensive performance monitoring:
- Custom performance traces
- Memory usage tracking
- Network request monitoring
- Error rate tracking

### Performance Optimization
- Lazy loading of images and data
- Efficient state management
- Optimized build configurations
- Code splitting for web

## 🚀 Deployment

### Web Deployment
```bash
# Build for production
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Mobile Deployment
```bash
# Android
flutter build appbundle --release

# iOS
flutter build ios --release
```

### CI/CD Pipeline
The project includes GitHub Actions workflows for:
- Automated testing
- Code quality checks
- Security scanning
- Automated deployment

## 📚 Documentation

### Architecture
- [Architecture Overview](docs/architecture.md)
- [Feature Documentation](docs/features/)
- [API Documentation](docs/api.md)

### Development
- [Development Setup](docs/development.md)
- [Testing Guide](docs/testing.md)
- [Contributing Guidelines](CONTRIBUTING.md)

### Deployment
- [CI/CD Setup](docs/ci_setup.md)
- [Deployment Guide](docs/deployment.md)
- [Monitoring Guide](docs/monitoring.md)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

### Code Style
- Follow Dart/Flutter conventions
- Use meaningful variable names
- Add comments for complex logic
- Write comprehensive tests

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

### Getting Help
- [Documentation](docs/)
- [Issues](https://github.com/your-username/APP-OINT/issues)
- [Discussions](https://github.com/your-username/APP-OINT/discussions)

### Reporting Bugs
Please use the [issue template](.github/ISSUE_TEMPLATE/bug_report.md) when reporting bugs.

### Feature Requests
Please use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md) for new features.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase team for the backend services
- All contributors and community members

## 📈 Roadmap

### Upcoming Features
- [ ] Advanced analytics dashboard
- [ ] Multi-location support
- [ ] Automated reporting
- [ ] AI-powered recommendations
- [ ] Video calling integration

### Performance Improvements
- [ ] Offline support
- [ ] Advanced caching
- [ ] Performance optimizations
- [ ] Accessibility improvements

---

**Made with ❤️ by the APP-OINT team**
