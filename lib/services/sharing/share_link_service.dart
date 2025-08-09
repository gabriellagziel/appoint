import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../security/rate_limit_service.dart';
import '../analytics/meeting_share_analytics_service.dart';

/// AUDIT: Share link service for generating and validating meeting share links
class ShareLinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RateLimitService _rateLimitService = RateLimitService();
  final MeetingShareAnalyticsService _analytics =
      MeetingShareAnalyticsService();
  final Random _random = Random.secure();

  /// Generate a share link for a meeting
  /// Format: https://app-oint.com/m/{meetingId}?g={groupId}&src={source}&ref={shareId}
  Future<String> createShareLink({
    required String meetingId,
    required String createdBy,
    String? groupId,
    String? source,
    Duration? expiry,
    int? maxUsage,
  }) async {
    // Check rate limiting
    final allowed = await _rateLimitService.allow(
      'create_share_link',
      createdBy,
      userId: createdBy,
    );

    if (!allowed) {
      throw Exception('Rate limit exceeded for share link creation');
    }

    final shareId = _generateShareId();
    final expiresAt = expiry != null ? DateTime.now().add(expiry) : null;

    // Store share link in Firestore
    await _firestore.collection('share_links').doc(shareId).set({
      'meetingId': meetingId,
      'groupId': groupId,
      'createdBy': createdBy,
      'source': source ?? 'direct',
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': expiresAt != null ? Timestamp.fromDate(expiresAt) : null,
      'usageCount': 0,
      'maxUsage': maxUsage,
      'revoked': false,
    });

    // Track analytics
    await _analytics.trackShareLinkCreated(
      meetingId: meetingId,
      groupId: groupId,
      source: source ?? 'direct',
      shareId: shareId,
    );

    return _buildShareUrl(meetingId, groupId, source, shareId);
  }

  /// Validate a share link and return link data
  Future<ShareLinkData> validateShareLink(
      String shareId, String meetingId) async {
    final doc = await _firestore.collection('share_links').doc(shareId).get();

    if (!doc.exists) {
      throw Exception('Share link not found');
    }

    final data = doc.data()!;
    final linkData = ShareLinkData.fromMap(shareId, data);

    // Check if link is revoked
    if (linkData.revoked) {
      throw Exception('Share link has been revoked');
    }

    // Check if link is expired
    if (linkData.expiresAt != null &&
        DateTime.now().isAfter(linkData.expiresAt!)) {
      throw Exception('Share link has expired');
    }

    // Check if link is for the correct meeting
    if (linkData.meetingId != meetingId) {
      throw Exception('Share link is not valid for this meeting');
    }

    // Check usage limits
    if (linkData.maxUsage != null &&
        linkData.usageCount >= linkData.maxUsage!) {
      throw Exception('Share link usage limit reached');
    }

    return linkData;
  }

  /// Increment usage count for a share link
  Future<void> incrementUsage(String shareId) async {
    await _firestore.collection('share_links').doc(shareId).update({
      'usageCount': FieldValue.increment(1),
      'lastUsedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Revoke a share link
  Future<void> revokeShareLink(String shareId, String userId) async {
    final doc = await _firestore.collection('share_links').doc(shareId).get();

    if (!doc.exists) {
      throw Exception('Share link not found');
    }

    final data = doc.data()!;
    if (data['createdBy'] != userId) {
      throw Exception('Only the creator can revoke share links');
    }

    await _firestore.collection('share_links').doc(shareId).update({
      'revoked': true,
      'revokedAt': FieldValue.serverTimestamp(),
      'revokedBy': userId,
    });
  }

  /// Get share links for a meeting
  Future<List<ShareLinkData>> getShareLinksForMeeting(
      String meetingId, String userId) async {
    final query = await _firestore
        .collection('share_links')
        .where('meetingId', isEqualTo: meetingId)
        .where('createdBy', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return query.docs
        .map((doc) => ShareLinkData.fromMap(doc.id, doc.data()))
        .toList();
  }

  /// Parse share link URL and extract components
  ShareLinkComponents parseShareUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    if (pathSegments.length < 2 || pathSegments[0] != 'm') {
      throw Exception('Invalid share link format');
    }

    final meetingId = pathSegments[1];
    final groupId = uri.queryParameters['g'];
    final source = uri.queryParameters['src'];
    final shareId = uri.queryParameters['ref'];

    return ShareLinkComponents(
      meetingId: meetingId,
      groupId: groupId,
      source: source,
      shareId: shareId,
    );
  }

  /// Build share URL from components
  String _buildShareUrl(
      String meetingId, String? groupId, String? source, String shareId) {
    final baseUrl = 'https://app-oint.com/m/$meetingId';
    final queryParams = <String, String>{};

    if (groupId != null) queryParams['g'] = groupId;
    if (source != null) queryParams['src'] = source;
    queryParams['ref'] = shareId;

    final queryString = queryParams.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  /// Generate a unique share ID
  String _generateShareId() {
    const chars =
        'REDACTED_TOKEN';
    return String.fromCharCodes(Iterable.generate(
        12, (_) => chars.codeUnitAt(_random.nextInt(chars.length))));
  }
}

/// Share link data model
class ShareLinkData {
  final String shareId;
  final String meetingId;
  final String? groupId;
  final String createdBy;
  final String source;
  final DateTime createdAt;
  final DateTime? expiresAt;
  final int usageCount;
  final int? maxUsage;
  final bool revoked;
  final DateTime? lastUsedAt;
  final DateTime? revokedAt;
  final String? revokedBy;

  ShareLinkData({
    required this.shareId,
    required this.meetingId,
    this.groupId,
    required this.createdBy,
    required this.source,
    required this.createdAt,
    this.expiresAt,
    required this.usageCount,
    this.maxUsage,
    required this.revoked,
    this.lastUsedAt,
    this.revokedAt,
    this.revokedBy,
  });

  factory ShareLinkData.fromMap(String shareId, Map<String, dynamic> data) {
    return ShareLinkData(
      shareId: shareId,
      meetingId: data['meetingId'],
      groupId: data['groupId'],
      createdBy: data['createdBy'],
      source: data['source'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      expiresAt: data['expiresAt'] != null
          ? (data['expiresAt'] as Timestamp).toDate()
          : null,
      usageCount: data['usageCount'] ?? 0,
      maxUsage: data['maxUsage'],
      revoked: data['revoked'] ?? false,
      lastUsedAt: data['lastUsedAt'] != null
          ? (data['lastUsedAt'] as Timestamp).toDate()
          : null,
      revokedAt: data['revokedAt'] != null
          ? (data['revokedAt'] as Timestamp).toDate()
          : null,
      revokedBy: data['revokedBy'],
    );
  }

  bool get isExpired => expiresAt != null && DateTime.now().isAfter(expiresAt!);
  bool get isUsageLimitReached => maxUsage != null && usageCount >= maxUsage!;
  bool get isValid => !revoked && !isExpired && !isUsageLimitReached;
}

/// Share link URL components
class ShareLinkComponents {
  final String meetingId;
  final String? groupId;
  final String? source;
  final String? shareId;

  ShareLinkComponents({
    required this.meetingId,
    this.groupId,
    this.source,
    this.shareId,
  });
}
