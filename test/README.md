# APP-OINT Testing Documentation

This directory contains comprehensive unit tests for the APP-OINT Flutter project. The tests are organized into three main categories: Model Tests, Service Tests, and UI Component Tests.

## Test Structure

```text
test/
├── models/                          # Model unit tests
│   ├── user_profile_test.dart       # UserProfile model tests
│   ├── appointment_test.dart        # Appointment model tests
│   └── admin_broadcast_message_test.dart # AdminBroadcastMessage tests
├── services/                        # Service unit tests
│   ├── admin_service_test.dart      # AdminService tests
│   ├── broadcast_service_test.dart  # BroadcastService tests
│   └── booking_service_test.dart    # BookingService tests
├── features/                        # UI component tests
│   ├── admin/
│   │   └── admin_broadcast_screen_test.dart # Admin broadcast screen tests
│   └── auth/
│       └── login_screen_test.dart   # Login screen tests
├── run_all_tests.dart               # Test runner script
└── README.md                        # This file
```

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test Categories
```bash
# Run only model tests
flutter test test/models/

# Run only service tests
flutter test test/services/

# Run only UI component tests
flutter test test/features/
```

### Run Individual Test Files
```bash
# Run specific test file
flutter test test/models/user_profile_test.dart

# Run with verbose output
flutter test test/models/user_profile_test.dart --verbose
```

### Run Tests with Coverage
```bash
# Generate coverage report
flutter test --coverage

# View coverage report (requires lcov)
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Test Categories

### 1. Model Tests

Model tests verify the behavior of data models in the application. They test:

- **Object Creation**: Ensuring models can be instantiated with correct parameters
- **JSON Serialization**: Testing `toJson()` and `fromJson()` methods
- **Data Validation**: Verifying that model properties are correctly set
- **Edge Cases**: Handling special characters, empty values, and boundary conditions

#### Example Model Test
```dart
test('should be able to convert to JSON and back', () {
  final user = UserProfile(
    uid: '123',
    displayName: 'John Doe',
    email: 'john@example.com',
    photoUrl: 'https://example.com/photo.jpg',
  );

  final json = user.toJson();
  final newUser = UserProfile.fromJson(json);

  expect(newUser.uid, user.uid);
  expect(newUser.displayName, user.displayName);
});
```

### 2. Service Tests

Service tests verify the business logic and data operations. They test:

- **Method Signatures**: Ensuring services have the expected methods
- **Return Types**: Verifying methods return the correct types
- **Error Handling**: Testing how services handle exceptions
- **Data Flow**: Ensuring data is processed correctly

#### Example Service Test
```dart
test('createBroadcastMessage should return a Future<String>', () {
  final message = AdminBroadcastMessage(/* ... */);
  final result = broadcastService.createBroadcastMessage(message);
  expect(result, isA<Future<String>>());
});
```

### 3. UI Component Tests

UI component tests verify the user interface behavior. They test:

- **Widget Rendering**: Ensuring widgets display correctly
- **User Interactions**: Testing button taps, form inputs, and navigation
- **State Management**: Verifying UI responds to state changes
- **Form Validation**: Testing input validation and error handling

#### Example UI Test
```dart
testWidgets('should allow entering email and password', (WidgetTester tester) async {
  await tester.pumpWidget(/* ... */);

  final emailField = find.byType(TextField).first;
  await tester.enterText(emailField, 'test@example.com');

  expect(find.text('test@example.com'), findsOneWidget);
});
```

## Test Best Practices

### 1. Test Organization

- Use descriptive test names that explain what is being tested
- Group related tests using `group()` blocks
- Follow the Arrange-Act-Assert pattern

### 2. Test Data

- Use realistic test data that represents actual usage
- Test edge cases and boundary conditions
- Avoid hardcoded values when possible

### 3. Mocking

- Mock external dependencies (Firebase, APIs) in service tests
- Use `ProviderScope` for testing widgets that use Riverpod
- Keep mocks simple and focused

### 4. Assertions

- Use specific assertions that test the exact behavior
- Avoid testing implementation details
- Test both positive and negative scenarios

## Dependencies

The tests use the following dependencies (already included in `pubspec.yaml`):

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.4.4
```

## Continuous Integration

Tests are automatically run in CI/CD pipelines. The test suite should:

1. Complete in under 5 minutes
2. Have >80% code coverage
3. Pass all tests before deployment

## Troubleshooting

### Common Issues

1. **Test fails with Firebase errors**: Mock Firebase dependencies in service tests
2. **Widget test fails**: Ensure proper `ProviderScope` wrapping for Riverpod widgets
3. **Import errors**: Check that all required models and services are imported

### Debugging Tests

```bash
# Run tests with debug output
flutter test --verbose

# Run specific test with debugger
flutter test test/models/user_profile_test.dart --verbose
```

## Adding New Tests

When adding new features, follow these steps:

1. **Create model tests** for any new data models
2. **Create service tests** for business logic
3. **Create UI tests** for new screens and widgets
4. **Update this README** with new test information

### Test File Naming Convention

- Model tests: `{model_name}_test.dart`
- Service tests: `{service_name}_test.dart`
- UI tests: `{screen_name}_test.dart`

## Coverage Goals

- **Models**: 100% coverage (all properties and methods)
- **Services**: 90% coverage (core business logic)
- **UI Components**: 80% coverage (critical user flows)

## Performance Considerations

- Keep tests fast and focused
- Avoid unnecessary async operations
- Use `setUp()` and `tearDown()` for test initialization
- Mock expensive operations (network calls, file I/O)

## Future Improvements

1. **Integration Tests**: Add end-to-end tests for critical user flows
2. **Golden Tests**: Add visual regression tests for UI components
3. **Performance Tests**: Add tests for app performance under load
4. **Accessibility Tests**: Ensure UI components meet accessibility standards
