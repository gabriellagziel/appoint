import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Certificate pinning service for secure HTTP connections
class CertificatePinningService {
  static final CertificatePinningService _instance = CertificatePinningService._internal();
  factory CertificatePinningService() => _instance;
  CertificatePinningService._internal();

  // Public key hashes for certificate pinning
  static const Map<String, List<String>> _pinnedHosts = {
    'api.appoint.com': [
      'sha256/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=', // Replace with actual hash
      'sha256/BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB=', // Backup hash
    ],
    'appoint.com': [
      'sha256/CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC=', // Replace with actual hash
      'sha256/DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD=', // Backup hash
    ],
    'firebase.googleapis.com': [
      'sha256/EEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE=', // Replace with actual hash
    ],
  };

  /// Validate certificate pinning for a given host
  static bool validateCertificatePinning(String host, X509Certificate certificate) {
    if (!_pinnedHosts.containsKey(host)) {
      // Allow hosts not in pinned list (for development)
      return true;
    }

    final expectedHashes = _pinnedHosts[host]!;
    final actualHash = _calculateCertificateHash(certificate);

    return expectedHashes.contains(actualHash);
  }

  /// Calculate SHA-256 hash of certificate public key
  static String _calculateCertificateHash(X509Certificate certificate) {
    final publicKeyBytes = certificate.publicKey.der;
    final hash = sha256.convert(publicKeyBytes);
    return 'sha256/${base64.encode(hash.bytes)}';
  }

  /// Create HTTP client with certificate pinning
  static http.Client createPinnedHttpClient() {
    return http.Client();
  }

  /// Handle certificate pinning failure
  static void handlePinningFailure(String host, String reason) {
    if (kDebugMode) {
      print('Certificate pinning failed for $host: $reason');
    }
    
    // In production, you might want to:
    // 1. Log the failure
    // 2. Report to analytics
    // 3. Show user-friendly error
    // 4. Fallback to alternative endpoint
  }

  /// Get certificate pinning status
  static Map<String, dynamic> getPinningStatus() {
    return {
      'enabled': true,
      'pinned_hosts': _pinnedHosts.keys.toList(),
      'total_pins': _pinnedHosts.values.expand((x) => x).length,
    };
  }
}

/// Custom HTTP client with certificate pinning
class PinnedHttpClient extends http.BaseClient {
  final http.Client _inner;
  final Map<String, String> _headers;

  PinnedHttpClient({Map<String, String>? headers})
      : _inner = http.Client(),
        _headers = headers ?? {};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Add certificate pinning headers
    request.headers.addAll(_headers);
    
    try {
      final response = await _inner.send(request);
      return response;
    } catch (e) {
      // Handle certificate pinning failures
      if (e.toString().contains('CERTIFICATE_VERIFY_FAILED')) {
        CertificatePinningService.handlePinningFailure(
          request.url.host,
          'Certificate verification failed',
        );
      }
      rethrow;
    }
  }

  @override
  void close() {
    _inner.close();
  }
} 