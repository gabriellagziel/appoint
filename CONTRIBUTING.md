# Contributing to APP-OINT

Thank you for your interest in contributing to APP-OINT! This guide will help you get started with development, running scripts, and making contributions.

## 🚀 Quick Start

### Prerequisites

- **Flutter SDK**: 3.32.0 or higher
- **Dart SDK**: 3.4.0 or higher
- **Node.js**: 18 or higher (for Firebase Functions)
- **Python**: 3.x (for translation scripts)
- **Firebase CLI**: Latest version

### Environment Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/your-org/appoint.git
   cd appoint
   ```

2. **Set up environment variables**
   ```bash
   cp env.example .env
   # Edit .env with your actual values
   ```

3. **Install dependencies**
   ```bash
   # Flutter dependencies
   flutter pub get
   
   # Firebase Functions dependencies
   cd functions && npm install && cd ..
   
   # Python dependencies (for scripts)
   pip install -r requirements.txt
   ```

4. **Set up Firebase**
   ```bash
   firebase login
   firebase use your-project-id
   ```

## 🛠️ Development Workflow

### Running the App

```bash
# Development mode
flutter run

# Profile mode (for performance testing)
flutter run --profile

# Release mode
flutter run --release
```

### Running Tests

```bash
# All tests
flutter test

# With coverage
flutter test --coverage

# Specific test file
flutter test test/widgets/button_test.dart

# Integration tests
flutter test integration_test/

# Golden tests
flutter test test/golden/
```

### Code Quality Checks

```bash
# Static analysis
flutter analyze

# Format code
dart format .

# Fix linting issues
./scripts/fix_linting_issues.sh
```

## 📝 Translation Management

### Adding New Translation Keys

1. **Add keys to the base language (English)**
   ```bash
   # Edit lib/l10n/app_en.arb
   # Add new key-value pairs
   ```

2. **Generate translation files**
   ```bash
   flutter gen-l10n
   ```

3. **Update all languages**
   ```bash
   python3 translate_missing_keys.py
   ```

### Running Translation Scripts

```bash
# Check translation completeness
python3 check_translations.py

# Audit languages
./scripts/audit_languages.sh

# Update specific language
python3 update_spanish_translations.py

# Apply all translations
python3 apply_all_translations.py
```

### Translation Quality

```bash
# Generate translation report
python3 check_translations.py --output translation_report.md

# Check for missing translations
python3 analyze_missing_translations.py
```

## 🔧 Scripts Reference

### Automated Scripts

```bash
# Comprehensive test suite
./scripts/run_tests_with_checks.sh

# Fix linting issues
./scripts/fix_linting_issues.sh

# Pre-commit checks
./scripts/pre-commit.sh

# Accessibility audit
./scripts/accessibility_audit.sh

# Performance audit
./scripts/performance_audit.sh
```

### Manual Scripts

```bash
# Rebuild ARB files
python3 rebuild_arb_files.py

# Fix ARB syntax
python3 fix_arb_syntax.py

# Comprehensive ARB fixes
python3 fix_all_arb_comprehensive.py
```

## 🧪 Testing

### Test Categories

- **Unit Tests**: `test/` directory
- **Widget Tests**: `test/widgets/` directory
- **Integration Tests**: `integration_test/` directory
- **Golden Tests**: `test/golden/` directory
- **Performance Tests**: `performance/` directory

### Running Specific Tests

```bash
# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widgets/

# Integration tests
flutter test integration_test/

# Performance tests
flutter drive --driver integration_test/driver.dart --target integration_test/performance_test.dart
```

### Test Coverage

```bash
# Generate coverage report
flutter test --coverage

# View coverage in browser
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 🔍 Code Analysis

### Static Analysis

```bash
# Run analysis
flutter analyze

# Custom analysis rules
dart analyze --options=analysis_options.yaml
```

### Performance Analysis

```bash
# Performance benchmarks
dart run performance/benchmarks/

# Memory profiling
flutter run --profile --trace-startup
```

## 🚀 CI/CD

### Local CI Checks

```bash
# Run all CI checks locally
./scripts/run_ci_checks.sh

# Pre-commit hook
cp scripts/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

### Workflow Files

- **Main CI**: `.github/workflows/ci-consolidated.yml`
- **Release**: `.github/workflows/release.yml`
- **Security**: `.github/workflows/security.yml`
- **Localization**: `.github/workflows/localization.yml`

## 📚 Documentation

### Documentation Structure

- **User Guides**: `docs/user_guides/`
- **API Documentation**: `docs/api/`
- **Architecture**: `docs/architecture.md`
- **Deployment**: `docs/deployment.md`

### Updating Documentation

```bash
# Generate API docs
dart doc

# Update README
# Edit README.md directly
```

## 🐛 Debugging

### Common Issues

1. **Firebase Connection Issues**
   ```bash
   firebase emulators:start
   flutter run --dart-define=FIREBASE_EMULATOR=true
   ```

2. **Translation Issues**
   ```bash
   flutter gen-l10n
   flutter clean && flutter pub get
   ```

3. **Build Issues**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --debug
   ```

### Debug Tools

```bash
# Flutter Inspector
flutter run --debug

# Performance Overlay
flutter run --profile

# Timeline
flutter run --trace-startup
```

## 📋 Pull Request Process

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Follow the coding standards
   - Add tests for new features
   - Update documentation

3. **Run checks locally**
   ```bash
   ./scripts/run_tests_with_checks.sh
   flutter analyze
   ```

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **Push and create PR**
   ```bash
   git push origin feature/your-feature-name
   # Create PR on GitHub
   ```

## 📏 Coding Standards

### Dart/Flutter

- Use `dart format .` for formatting
- Follow the `analysis_options.yaml` rules
- Use trailing commas for better diffs
- Prefer `const` constructors

### File Organization

```
lib/
├── features/          # Feature modules
├── shared/           # Shared components
├── core/            # Core functionality
├── services/        # Business logic
└── utils/           # Utilities
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`

## 🤝 Getting Help

- **Issues**: Create an issue on GitHub
- **Discussions**: Use GitHub Discussions
- **Documentation**: Check `docs/` directory
- **Scripts**: Check `scripts/` directory

## 📄 License

By contributing to APP-OINT, you agree that your contributions will be licensed under the same license as the project.

---

Thank you for contributing to APP-OINT! 🎉 