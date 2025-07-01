import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Validate input data
  static bool isValidEmail(final String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return emailRegex.hasMatch(email);
  }

  static bool isValidPhone(final String phone) {
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isValidPassword(final String password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number
    final passwordRegex =
        RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$');
    return passwordRegex.hasMatch(password);
  }

  /// Sanitize user input
  static String sanitizeInput(final String input) {
    // Remove potentially dangerous characters
    final sanitized = input
        .replaceAll('<', '')
        .replaceAll('>', '')
        .replaceAll('"', '')
        .replaceAll("'", '');
    return sanitized.trim();
  }

  /// Hash sensitive data
  static String hashData(final String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Store sensitive data securely
  Future<void> storeSecureData(final String key, final String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  /// Retrieve sensitive data securely
  Future<String?> getSecureData(final String key) async {
    return await _secureStorage.read(key: key);
  }

  /// Delete sensitive data
  Future<void> deleteSecureData(final String key) async {
    await _secureStorage.delete(key: key);
  }

  /// Clear all secure data
  Future<void> clearAllSecureData() async {
    await _secureStorage.deleteAll();
  }

  /// Validate API response
  static bool isValidApiResponse(final Map<String, dynamic> response) {
    // Check for required fields
    if (!response.containsKey('status') || !response.containsKey('data')) {
      return false;
    }

    // Validate status
    final status = response['status'];
    if (status != 'success' && status != 'error') {
      return false;
    }

    return true;
  }

  /// Validate file upload
  static bool isValidFileUpload(final String fileName, final int fileSize) {
    // Check file extension
    final allowedExtensions = [
      '.jpg',
      '.jpeg',
      '.png',
      '.pdf',
      '.doc',
      '.docx'
    ];
    final extension =
        fileName.toLowerCase().substring(fileName.lastIndexOf('.'));

    if (!allowedExtensions.contains(extension)) {
      return false;
    }

    // Check file size (max 10MB)
    const maxSize = 10 * 1024 * 1024; // 10MB
    if (fileSize > maxSize) {
      return false;
    }

    return true;
  }

  /// Generate secure token
  static String generateSecureToken() {
    final random = DateTime.now().millisecondsSinceEpoch.toString();
    return hashData(random);
  }

  /// Check if running in debug mode
  static bool isDebugMode() {
    return kDebugMode;
  }

  /// Validate deep link
  static bool isValidDeepLink(final String link) {
    // Check if it's a valid app deep link
    if (!link.startsWith('appoint://')) {
      return false;
    }

    // Validate link structure
    final uri = Uri.parse(link);
    if (uri.host.isEmpty) {
      return false;
    }

    return true;
  }

  /// Log security event
  static void logSecurityEvent(final String event, {final Map<String, dynamic>? details}) {
    if (kDebugMode) {
      // Removed debug print: print('🔒 Security Event: $event');
      if (details != null) {
        // Removed debug print: print('Details: $details');
      }
    }
    // In production, this would send to a security monitoring service
  }
}

// Riverpod providers
final securityServiceProvider = Provider<SecurityService>((final ref) {
  return SecurityService();
});

final securityEnabledProvider = StateProvider<bool>((final ref) {
  return true; // Always enabled
});
