import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Simple Firebase Test Helper
/// Note: This is a simplified version to avoid complex mocking issues
/// Individual tests can implement their own specific mocks as needed
class FirebaseTestHelper {
  static bool _isInitialized = false;

  /// Simple test initialization
  static Future<void> initializeForTesting() async {
    if (_isInitialized) return;
    
    _isInitialized = true;
  }

  /// Create a test Material App wrapper
  static Widget createTestApp({required Widget child}) {
    return MaterialApp(
      home: Scaffold(body: child),
    );
  }

  /// Simple test user data
  static Map<String, dynamic> createTestUserData({
    String id = 'test-user-id',
    String email = 'test@example.com',
    String name = 'Test User',
  }) {
    return {
      'id': id,
      'email': email,
      'name': name,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Simple test document data
  static Map<String, dynamic> createTestDocument({
    String id = 'test-doc-id',
    Map<String, dynamic>? data,
  }) {
    return {
      'id': id,
      'data': data ?? {},
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  /// Reset test state
  static void reset() {
    _isInitialized = false;
  }
}

/// Legacy compatibility functions
Future<void> initializeTestFirebase() async {
  await FirebaseTestHelper.initializeForTesting();
}

Widget REDACTED_TOKEN(Widget child) {
  return FirebaseTestHelper.createTestApp(child: child);
}

Widget createTestApp(Widget child) {
  return FirebaseTestHelper.createTestApp(child: child);
}
