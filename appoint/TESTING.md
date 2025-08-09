# Testing Guide for App-Oint

This document provides comprehensive guidance for running tests, understanding coverage requirements, and maintaining test quality for the App-Oint Personal User App.

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.19.0 or later
- Chrome browser (for integration tests)
- Git (for coverage analysis)

### Running Tests

```bash
# Run all tests
cd appoint
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/meeting_creation/REDACTED_TOKEN.dart

# Run tests in Chrome (for web-specific tests)
flutter test -d chrome

# Run integration tests
flutter test -d chrome integration_test/
```

## 📊 Coverage Requirements

### Thresholds
- **Global coverage**: ≥ 70%
- **Changed files**: ≥ 85%
- **New features**: ≥ 90%

### Checking Coverage

```bash
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# Check coverage thresholds
dart tool/check_coverage.dart

# View coverage report
open coverage/html/index.html
```

## 🧪 Test Types

### 1. Unit Tests
Test individual functions, methods, and classes in isolation.

**Location**: `test/features/` and `test/services/`

**Examples**:
- Controller logic
- Service methods
- Utility functions
- State management

**Running**:
```bash
flutter test test/features/
flutter test test/services/
```

### 2. Widget Tests
Test UI components and widgets.

**Location**: `test/features/*/widgets/`

**Examples**:
- Screen rendering
- User interactions
- State updates
- Navigation

**Running**:
```bash
flutter test test/features/*/widgets/
```

### 3. Integration Tests
Test complete user flows and cross-component interactions.

**Location**: `integration_test/`

**Examples**:
- Meeting creation flow
- Join invite process
- Share functionality
- Deep link handling

**Running**:
```bash
flutter test -d chrome integration_test/
```

### 4. Golden Tests
Test visual consistency and UI regression.

**Location**: `test/goldens/`

**Examples**:
- Screen layouts
- Component rendering
- Multi-density support

**Running**:
```bash
flutter test test/goldens/
flutter test test/goldens/ --update-goldens
```

## 🏗️ Test Infrastructure

### Test Utilities

#### `test/test_utils/pump.dart`
Provides helpers for pumping widgets with Riverpod providers and responsive sizes.

```dart
import '../../test_utils/pump.dart';

// Pump widget with providers
await tester.pumpWidgetWithProviders(
  MyWidget(),
  overrides: [myProvider.overrideWithValue(mockValue)],
);

// Pump for tablet testing
await tester.pumpWidgetTablet(MyWidget());
```

#### `test/test_utils/fakes.dart`
Contains fake implementations of services for testing.

```dart
import '../../test_utils/fakes.dart';

final fakeShareService = FakeShareService();
final fakeRepository = FakeMeetingRepository();
```

#### `test/test_utils/fixtures.dart`
Provides sample data for testing.

```dart
import '../../test_utils/fixtures.dart';

final meeting = TestFixtures.sampleMeeting(
  title: 'Test Meeting',
  participants: ['user1', 'user2'],
);
```

#### `test/test_utils/goldens.dart`
Helpers for golden test consistency.

```dart
import '../../test_utils/goldens.dart';

await tester.pumpWidgetForGolden(MyWidget());
await tester.expectGolden('my_widget.png');
```

### Test Configuration

#### `flutter_test_config.dart`
Ensures consistent test environment:
- Stable fonts and timezone
- Disabled `dart:html` direct access
- Fixed test configuration

## 🔧 Test Commands

### Development Workflow

```bash
# Run tests during development
flutter test

# Run tests with verbose output
flutter test --verbose

# Run tests with coverage
flutter test --coverage

# Run specific test group
flutter test --name="MeetingFlowController"

# Run tests matching pattern
flutter test --name=".*Controller.*"
```

### CI/CD Commands

```bash
# Run all tests with coverage
./test/coverage.sh

# Check coverage thresholds
dart tool/check_coverage.dart

# Scan for WhatsApp-only copy
./scripts/scan_copy.sh

# Run golden tests
flutter test test/goldens/ --update-goldens
```

## 📋 Test Categories

### Controllers & Services
- **Meeting Flow Controller**: Step navigation, validation, state management
- **Playtime Controller**: Subtype rules, validation, configuration
- **Reminder Controller**: CRUD operations, filtering, status management
- **Family Controller**: Member management, approval workflows
- **Share Service**: Platform-agnostic sharing, analytics tracking
- **Invite Controller**: Load, accept, decline operations
- **Repository Fallbacks**: Firestore disabled scenarios

### Widgets & Screens
- **Home Landing**: Greeting, quick actions, schedule display
- **Meeting Flow Steps**: Step navigation, form validation
- **Review Screen**: Data display, edit functionality
- **OSM Preview**: Map rendering, attribution
- **Calendar**: Agenda merging, navigation
- **Meeting Details**: Header sections, action buttons
- **Ad-Gate**: Premium vs free user flows

### Integration & E2E
- **Meeting Creation Flow**: Complete flow from home to success
- **Join Invite Flow**: Deep link parsing, guest flow
- **Share Universal**: Cross-platform sharing, analytics

## 🎯 Coverage Strategy

### High-Priority Areas
1. **Controllers**: Business logic and state management
2. **Services**: API interactions and data processing
3. **Critical Widgets**: Core UI components
4. **Integration Flows**: End-to-end user journeys

### Coverage Exclusions
- Generated code (freezed, json_serializable)
- Platform-specific implementations
- Third-party library code
- Configuration files

### Coverage Monitoring
- Automated threshold checking in CI
- Coverage reports uploaded as artifacts
- Changed file coverage requirements
- Coverage trend analysis

## 🚨 Common Issues

### Test Failures

#### Golden Test Failures
```bash
# Update golden baselines
flutter test test/goldens/ --update-goldens

# Check for visual regressions
flutter test test/goldens/
```

#### Integration Test Failures
```bash
# Run with verbose output
flutter test -d chrome integration_test/ --verbose

# Check Chrome version compatibility
flutter doctor
```

#### Coverage Threshold Failures
```bash
# Check current coverage
dart tool/check_coverage.dart

# Add tests for uncovered code
flutter test --coverage
```

### Performance Issues

#### Slow Test Execution
- Use `--concurrency` flag for parallel execution
- Exclude slow tests with `--exclude-tags`
- Optimize test data setup

#### Memory Issues
- Dispose of controllers in `tearDown`
- Clear test data between tests
- Use `addTearDown` for cleanup

## 📚 Best Practices

### Writing Tests

1. **Arrange-Act-Assert Pattern**
```dart
test('should create meeting successfully', () async {
  // Arrange
  final controller = container.read(meetingControllerProvider.notifier);
  final meetingData = TestFixtures.sampleMeeting();
  
  // Act
  final success = await controller.createMeeting(meetingData);
  
  // Assert
  expect(success, isTrue);
});
```

2. **Descriptive Test Names**
```dart
test('should skip location step for virtual meeting types', () {
  // Test implementation
});
```

3. **Test Isolation**
```dart
setUp(() {
  container = ProviderContainer();
});

tearDown(() {
  container.dispose();
});
```

### Mocking & Fakes

1. **Use Fakes for Services**
```dart
final fakeRepository = FakeMeetingRepository();
container.updateOverrides([
  meetingRepositoryProvider.overrideWithValue(fakeRepository),
]);
```

2. **Mock External Dependencies**
```dart
final mockAnalytics = MockAnalyticsService();
when(mockAnalytics.trackEvent(any)).thenAnswer((_) async {});
```

### Golden Tests

1. **Consistent Environment**
```dart
await GoldenTestUtils.setUpGoldenTest();
// Test implementation
await GoldenTestUtils.tearDownGoldenTest();
```

2. **Multi-Density Testing**
```dart
await tester.expectGoldenMultiDensity('my_widget.png');
```

## 🔍 Debugging Tests

### Verbose Output
```bash
flutter test --verbose
```

### Debug Mode
```bash
flutter test --debug
```

### Coverage Analysis
```bash
# Generate detailed coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html
```

### Test Profiling
```bash
flutter test --coverage --reporter=json
```

## 📈 Continuous Improvement

### Regular Reviews
- Weekly test coverage analysis
- Monthly test performance review
- Quarterly test strategy updates

### Metrics Tracking
- Test execution time
- Coverage trends
- Flaky test identification
- Test maintenance effort

### Automation
- Automated test execution in CI
- Coverage threshold enforcement
- Golden test baseline updates
- Security scanning integration

## 🤝 Contributing

### Adding New Tests
1. Follow existing test patterns
2. Use appropriate test utilities
3. Add comprehensive coverage
4. Update documentation

### Test Maintenance
1. Keep tests up to date with code changes
2. Refactor tests for better maintainability
3. Remove obsolete tests
4. Update test data as needed

### Reporting Issues
1. Include test output and error messages
2. Provide reproduction steps
3. Describe expected vs actual behavior
4. Include relevant code snippets

## 📞 Support

For test-related questions or issues:
1. Check this documentation first
2. Review existing test examples
3. Consult the Flutter testing documentation
4. Create an issue with detailed information

---

**Last Updated**: December 2024
**Version**: 1.0.0
