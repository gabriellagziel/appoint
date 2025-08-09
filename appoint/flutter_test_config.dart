import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Flutter test configuration for consistent test environment
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Set up test environment
  await _setUpTestEnvironment();

  // Run tests
  await testMain();

  // Clean up
  await _tearDownTestEnvironment();
}

/// Set up test environment for consistent results
Future<void> _setUpTestEnvironment() async {
  // Ensure Flutter test binding is initialized
  TestWidgetsFlutterBinding.ensureInitialized();

  // Set a fixed timezone for consistent date/time rendering
  // This prevents golden tests from failing due to timezone differences
  // Note: In a real implementation, you might want to use a timezone package
  // to set a specific timezone for all tests

  // Set a fixed locale for consistent text rendering
  // This ensures consistent golden test results across different environments

  // Disable direct dart:html access in tests
  // This prevents web-specific code from running in test environment
  _disableDartHtmlAccess();
}

/// Clean up test environment
Future<void> _tearDownTestEnvironment() async {
  // Clean up any resources if needed
}

/// Disable direct dart:html access in tests
void _disableDartHtmlAccess() {
  // This is a placeholder for disabling dart:html access
  // In a real implementation, you might want to:
  // 1. Use conditional imports to provide mock implementations
  // 2. Override web-specific services with test doubles
  // 3. Use dependency injection to provide test-friendly implementations

  // Example: Override web-specific services
  // This prevents tests from trying to access browser APIs
}

/// Test configuration constants
class TestConfig {
  /// Default test timeout
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Default golden test timeout
  static const Duration goldenTimeout = Duration(seconds: 60);

  /// Default integration test timeout
  static const Duration integrationTimeout = Duration(seconds: 120);

  /// Default surface size for widget tests
  static const Size defaultSurfaceSize = Size(390, 844);

  /// Default pixel density for tests
  static const double defaultPixelDensity = 2.0;

  /// Test timezone (UTC)
  static const String testTimezone = 'UTC';

  /// Test locale
  static const String testLocale = 'en_US';
}
