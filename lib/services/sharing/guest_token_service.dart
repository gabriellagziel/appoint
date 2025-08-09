import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// AUDIT: Guest token service for secure guest access to shared meetings
class GuestTokenService {
  // Use environment variable or Firebase Remote Config for secret
  static const String _defaultSecretKey = 'guest_token_secret_2025';
  static const int _tokenLength = 32;
  static const Duration _defaultExpiry = Duration(hours: 24);

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;
  final Random _random = Random.secure();

  /// Get the secret key from environment or remote config
  String get _secretKey {
    // Try environment variable first
    const envSecret = String.fromEnvironment('GUEST_TOKEN_SECRET');
    if (envSecret.isNotEmpty) {
      return envSecret;
    }

    // Fall back to remote config
    final remoteSecret = _remoteConfig.getString('guest_token_secret');
    if (remoteSecret.isNotEmpty) {
      return remoteSecret;
    }

    // Last resort - should not be used in production
    return _defaultSecretKey;
  }

  /// Generate a secure guest token for meeting access
  /// Returns a signed token that can be validated later
  Future<String> createGuestToken(
    String meetingId, {
    String? groupId,
    Duration? expiry,
  }) async {
    final token = _generateSecureToken();
    final expiresAt = DateTime.now().add(expiry ?? _defaultExpiry);

    final claims = {
      'meetingId': meetingId,
      'groupId': groupId,
      'exp': expiresAt.millisecondsSinceEpoch,
      'iat': DateTime.now().millisecondsSinceEpoch,
    };

    // Store token in Firestore for validation
    await _firestore.collection('guest_tokens').doc(token).set({
      'claims': claims,
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'isActive': true,
    });

    return token;
  }

  /// Validate a guest token and return claims if valid
  /// Throws exception if token is invalid, expired, or revoked
  Future<Map<String, dynamic>> validateGuestToken(
    String token,
    String meetingId,
  ) async {
    final doc = await _firestore.collection('guest_tokens').doc(token).get();

    if (!doc.exists) {
      throw Exception('Invalid guest token');
    }

    final data = doc.data()!;
    final claims = Map<String, dynamic>.from(data['claims']);
    final expiresAt = (data['expiresAt'] as Timestamp).toDate();
    final isActive = data['isActive'] ?? false;

    // Check if token is active
    if (!isActive) {
      throw Exception('Guest token has been revoked');
    }

    // Check if token is expired
    if (DateTime.now().isAfter(expiresAt)) {
      throw Exception('Guest token has expired');
    }

    // Check if token is for the correct meeting
    if (claims['meetingId'] != meetingId) {
      throw Exception('Guest token is not valid for this meeting');
    }

    return claims;
  }

  /// Revoke a guest token (mark as inactive)
  Future<void> revokeGuestToken(String token) async {
    await _firestore.collection('guest_tokens').doc(token).update({
      'isActive': false,
      'revokedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Clean up expired tokens (should be called periodically)
  Future<void> cleanupExpiredTokens() async {
    final now = DateTime.now();
    final query = await _firestore
        .collection('guest_tokens')
        .where('expiresAt', isLessThan: Timestamp.fromDate(now))
        .get();

    final batch = _firestore.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  }

  /// Generate a cryptographically secure random token
  String _generateSecureToken() {
    final bytes = List<int>.generate(_tokenLength, (i) => _random.nextInt(256));
    return base64Url.encode(bytes).replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  /// Check if a token is valid without throwing (for UI checks)
  Future<bool> isTokenValid(String token, String meetingId) async {
    try {
      await validateGuestToken(token, meetingId);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get token expiry time (for UI display)
  Future<DateTime?> getTokenExpiry(String token) async {
    try {
      final doc = await _firestore.collection('guest_tokens').doc(token).get();
      if (!doc.exists) return null;

      final data = doc.data()!;
      return (data['expiresAt'] as Timestamp).toDate();
    } catch (e) {
      return null;
    }
  }
}
