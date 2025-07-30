# Development Setup Guide

This guide helps you set up the development environment with all the necessary tools to catch issues early and maintain code quality.

## 🛠️ Installed Tools

### 1. **Static Analysis & Linting**

- **very_good_analysis**: Comprehensive Dart/Flutter linting rules
- **Custom analysis_options.yaml**: Extended rules for better code quality
- **10,527+ linting rules** to catch issues early

### 2. **Automated Scripts**

- **`scripts/fix_linting_issues.sh`**: Automatically fix common linting issues
- **`scripts/run_tests_with_checks.sh`**: Comprehensive test runner with pre-flight checks
- **`scripts/pre-commit.sh`**: Pre-commit hook to prevent bad commits

### 3. **VS Code Configuration**

- **`.vscode/settings.json`**: Optimized settings for Flutter development
- **Auto-formatting on save**
- **Import organization**
- **Code actions on save**

## 🚀 Quick Start

### 1. **Run the Comprehensive Test Suite**

```bash
./scripts/run_tests_with_checks.sh
```

This script will:

- ✅ Get dependencies
- ✅ Run static analysis
- ✅ Format code
- ✅ Run all tests with coverage
- ✅ Generate coverage reports

### 2. **Fix Linting Issues**

```bash
./scripts/fix_linting_issues.sh
```

This will automatically fix:

- Missing trailing commas
- Double quotes → single quotes
- Missing `const` constructors
- Import ordering

### 3. **Manual Checks**

```bash
# Static analysis
dart analyze

# Format code
dart format .

# Run tests
flutter test --reporter=compact

# Run tests with coverage
flutter test --coverage
```

## 🔧 Pre-commit Setup

To automatically run checks before each commit:

```bash
# Copy the pre-commit hook
cp scripts/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
```

## 📊 Monitoring Tools

### **Static Analysis**

- **10,527+ rules** covering style, performance, and best practices
- **Real-time feedback** in VS Code
- **Fatal info level** to catch all issues

### **Test Coverage**

- **Coverage reports** generated automatically
- **HTML reports** (if `genhtml` is installed)
- **Compact test output** for better readability

### **Code Quality**

- **Consistent formatting** across the codebase
- **Import organization** 
- **Trailing commas** for better diffs

## 🎯 Benefits

### **Early Issue Detection**

- Catch syntax errors before they reach CI
- Identify performance issues early
- Maintain consistent code style

### **Improved Developer Experience**

- Auto-formatting on save
- Real-time linting feedback
- Automated test running

### **Better Code Quality**

- 10,000+ linting rules
- Comprehensive test coverage
- Consistent formatting

## 🔍 Troubleshooting

### **If tests are failing:**

1. Run `flutter pub get` to ensure dependencies are up to date
2. Check for Firebase initialization issues in test files
3. Verify mock services are properly configured

### **If linting issues persist:**

1. Run `./scripts/fix_linting_issues.sh`
2. Check `analysis_options.yaml` for rule configurations
3. Use `dart fix --apply` for automatic fixes

### **If VS Code isn't showing issues:**

1. Reload VS Code window
2. Check Dart extension is installed and enabled
3. Verify `analysis_options.yaml` is in the project root

## 📈 Next Steps

1. **Run the comprehensive test suite** to see current status
2. **Fix any remaining linting issues** using the automated script
3. **Set up pre-commit hooks** to prevent future issues
4. **Configure your IDE** with the provided settings

This setup will significantly improve code quality and catch issues much earlier in the development process! 