# APP-OINT

A comprehensive appointment booking and management application built with Flutter, featuring real-time chat, business management, and multi-platform support.

## Features

- Cross-platform mobile app (iOS, Android)
- Firebase backend integration
- Real-time appointment scheduling
- Multi-language support
- Secure authentication

## Development

### Prerequisites

- Flutter SDK 3.4.0 or higher
- Dart SDK 3.4.0 or higher
- Android Studio / Xcode for mobile development

### Setup

1. Clone the repository
2. Install dependencies: `flutter pub get`
3. Run the app: `flutter run`

### Testing

Run tests with coverage:
```bash
flutter test --coverage
```

## Code Coverage

[![codecov](https://codecov.io/gh/gabriellagziel/appoint/branch/main/graph/badge.svg)](https://codecov.io/gh/gabriellagziel/appoint)

## CI/CD

This project uses GitHub Actions for continuous integration:

- **Static Analysis**: Runs `flutter analyze --no-fatal-infos` to check code quality
- **Tests**: Runs `flutter test --coverage` and uploads coverage to Codecov
- **Build**: Creates release APK artifacts for Android

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Ensure all tests pass
5. Submit a pull request

## License

This project is proprietary and confidential.
