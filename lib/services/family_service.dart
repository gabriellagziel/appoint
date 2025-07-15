import 'dart:convert';

import 'package:appoint/config/environment_config.dart';
import 'package:appoint/models/family_link.dart';
import 'package:appoint/models/permission.dart';
import 'package:appoint/models/privacy_request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class FamilyService {

  FamilyService({FirebaseFirestore? firestore, final FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  // Load API base URL from environment configuration
  static const String _base = EnvironmentConfig.familyApiBaseUrl;

  final FirebaseFirestore _firestore;
  // ignore: unused_field
  final FirebaseAuth _auth;

  Future<FamilyLink> inviteChild(
      String parentId, final String childEmail,) async {
    final resp = await http.post(
      Uri.parse('$_base/invite'),
      body: jsonEncode({'parentId': parentId, 'childEmail': childEmail}),
      headers: {'Content-Type': 'application/json'},
    );

    final link = FamilyLink.fromJson(jsonDecode(resp.body));
    await _logFamilyEvent('invite_sent', parentId, {
      'childId': link.childId,
      'childEmail': childEmail,
      'linkId': link.id,
    });

    return link;
  }

  Future<List<FamilyLink>> fetchFamilyLinks(String parentId) async {
    final resp = await http.get(
      Uri.parse('$_base/links?parentId=$parentId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      List<dynamic> data = jsonDecode(resp.body);
      return data.map((json) => FamilyLink.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch family links: ${resp.body}');
    }
  }

  Future<void> cancelInvite(String parentId, final String childId) async {
    final resp = await http.delete(
      Uri.parse('$_base/invite'),
      body: jsonEncode({'parentId': parentId, 'childId': childId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to cancel invite: ${resp.body}');
    }

    await _logFamilyEvent('invite_cancelled', parentId, {
      'childId': childId,
    });
  }

  Future<void> resendOtp(String parentId, final String childId) async {
    final resp = await http.post(
      Uri.parse('$_base/resend-otp'),
      body: jsonEncode({'parentId': parentId, 'childId': childId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to resend OTP: ${resp.body}');
    }

    await _logFamilyEvent('otp_resent', parentId, {
      'childId': childId,
    });
  }

  Future<void> _logFamilyEvent(final String eventType, final String parentId,
      Map<String, dynamic> data,) async {
    try {
      await _firestore.collection('family_analytics').add({
        'eventType': eventType,
        'parentId': parentId,
        'timestamp': FieldValue.serverTimestamp(),
        'data': data,
      });
    } catch (e) {
      // Don't throw on analytics failures
      // Removed debug print: debugPrint('Failed to log family event: $e');
    }
  }

  Future<void> updateConsent(String linkId, final bool grant) async {
    await http.post(
      Uri.parse('$_base/consent-update'),
      body: jsonEncode({'linkId': linkId, 'grant': grant}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<List<Permission>> fetchPermissions(String linkId) async {
    final resp = await http.get(Uri.parse('$_base/permissions?linkId=$linkId'));
    return (jsonDecode(resp.body) as List)
        .map((j) => Permission.fromJson(j))
        .toList();
  }

  Future<void> updatePermissions(
      String linkId, final List<Permission> perms,) async {
    await http.post(
      Uri.parse('$_base/permissions-update'),
      body: jsonEncode({
        'linkId': linkId,
        'permissions': perms.map((p) => p.toJson()).toList(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<List<PrivacyRequest>> fetchPrivacyRequests(
      String parentId) async {
    final resp =
        await http.get(Uri.parse('$_base/privacy-requests?parentId=$parentId'));
    return (jsonDecode(resp.body) as List)
        .map((j) => PrivacyRequest.fromJson(j))
        .toList();
  }

  Future<void> sendPrivacyRequest(String childId) async {
    await http.post(
      Uri.parse('$_base/privacy-request'),
      body: jsonEncode({'childId': childId, 'type': 'private_session'}),
      headers: {'Content-Type': 'application/json'},
    );
  }

  Future<void> sendOtp(String parentContact, final String childId) async {
    final resp = await http.post(
      Uri.parse('$_base/send-otp'),
      body: jsonEncode({'parentContact': parentContact, 'childId': childId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to send OTP: ${resp.body}');
    }
  }

  Future<bool> verifyOtp(String parentContact, final String code) async {
    final resp = await http.post(
      Uri.parse('$_base/verify-otp'),
      body: jsonEncode({'parentContact': parentContact, 'code': code}),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final verified = data['verified'] ?? false;

      if (verified) {
        await _logFamilyEvent('otp_verified', parentContact, {
          'code': code,
        });
      }

      return verified;
    } else {
      throw Exception('Failed to verify OTP: ${resp.body}');
    }
  }

  Future<void> handlePrivacyRequest(
      String requestId, final String action,) async {
    final resp = await http.post(
      Uri.parse('$_base/privacy-request/$requestId/$action'),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to handle privacy request: ${resp.body}');
    }

    await _logFamilyEvent('privacy_request_handled', 'system', {
      'requestId': requestId,
      'action': action,
    });
  }

  Future<void> revokeAccess(String linkId) async {
    final resp = await http.delete(
      Uri.parse('$_base/revoke-access/$linkId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (resp.statusCode != 200) {
      throw Exception('Failed to revoke access: ${resp.body}');
    }

    await _logFamilyEvent('access_revoked', 'system', {
      'linkId': linkId,
    });
  }
}
