# AppOint

A Flutter mobile application for appointment booking and management.

## 🚀 Quick Start

1. **Setup Environment**: Run `scripts/setup_env.sh` for local development setup
2. **Install Dependencies**: `flutter pub get`
3. **Run Tests**: `flutter test`
4. **Start Development**: `flutter run`

## 📊 Status

[![CI Pipeline](https://github.com/your-username/appoint/actions/workflows/ci.yml/badge.svg)](https://github.com/your-username/appoint/actions/workflows/ci.yml)
[![Nightly Builds](https://github.com/your-username/appoint/actions/workflows/nightly.yml/badge.svg)](https://github.com/your-username/appoint/actions/workflows/nightly.yml)
[![Codecov](https://codecov.io/gh/your-username/appoint/branch/main/graph/badge.svg)](https://codecov.io/gh/your-username/appoint)

## 📚 Documentation

- **[Project Documentation](docs/README.md)** - Comprehensive project documentation
- **[Architecture](docs/architecture.md)** - System architecture and design patterns
- **[CI/CD Setup](docs/ci_setup.md)** - Continuous Integration and Deployment guide

## 🛠️ Development

### Prerequisites

- Flutter SDK 3.4.0+
- Dart SDK 3.4.0+
- Android Studio / Xcode (for mobile development)
- Firebase CLI (for backend services)

### Local Development

```bash
# Clone the repository
git clone https://github.com/your-username/appoint.git
cd appoint

# Setup environment
./scripts/setup_env.sh

# Install dependencies
flutter pub get

# Run tests
flutter test

# Start development server
flutter run
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run integration tests
flutter test --tags integration
```

## 📦 Build

```bash
# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release

# Build for iOS
flutter build ios
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Quality

- All code must pass static analysis (`flutter analyze`)
- All tests must pass (`flutter test`)
- Code coverage is tracked via Codecov
- PRs require all CI checks to pass before merge

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Links

- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Riverpod Documentation](https://riverpod.dev/)
