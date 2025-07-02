import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

import 'package:appoint/models/smart_share_link.dart';
import 'package:appoint/services/custom_deep_link_service.dart';

class WhatsAppShareService {
  final FirebaseFirestore _firestore;
  late final CustomDeepLinkService _deepLinkService;

  static const String _baseUrl = 'https://app-oint-core.web.app';
  static const String _whatsappBaseUrl = 'https://wa.me/?text=';

  WhatsAppShareService({
    final FirebaseFirestore? firestore,
    final CustomDeepLinkService? deepLinkService,
  }) : _firestore = firestore ?? FirebaseFirestore.instance {
    _deepLinkService =
        deepLinkService ?? CustomDeepLinkService(whatsappShareService: this);
  }

  /// Generate a smart share link for a meeting
  Future<String> generateSmartShareLink({
    required final String meetingId,
    required final String creatorId,
    final String? contextId,
    final String? groupId,
  }) async {
    try {
      // Use custom deep link service instead of Firebase Dynamic Links
      final link = await _deepLinkService.createMeetingLink(
        meetingId: meetingId,
        creatorId: creatorId,
        contextId: contextId,
        groupId: groupId,
      );

      // Store share analytics
      await logShareAnalytics(
        meetingId: meetingId,
        channel: 'whatsapp',
        groupId: groupId,
        creatorId: creatorId,
      );

      return link;
    } catch (e) {
      // Removed debug print: print('Error generating smart share link: $e');
      // Fallback to simple URL
      return '$_baseUrl/meeting/$meetingId?creatorId=$creatorId${contextId != null ? '&contextId=$contextId' : ''}';
    }
  }

  /// Share meeting to WhatsApp
  Future<bool> shareToWhatsApp({
    required final String meetingId,
    required final String creatorId,
    required final String customMessage,
    final String? contextId,
    final String? groupId,
    final String? recipientPhone,
  }) async {
    try {
      // Generate smart share link
      final shareLink = await generateSmartShareLink(
        meetingId: meetingId,
        creatorId: creatorId,
        contextId: contextId,
        groupId: groupId,
      );

      // Create WhatsApp message
      final message = Uri.encodeComponent('$customMessage\n\n$shareLink');
      final whatsappUrl = '$_whatsappBaseUrl$message';

      // Launch WhatsApp
      final uri = Uri.parse(whatsappUrl);
      final canLaunch = await canLaunchUrl(uri);

      if (canLaunch) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Track successful share
        await FirebaseAnalytics.instance.logEvent(
          name: 'share_whatsapp',
        );

        // Update group recognition if applicable
        if (groupId != null) {
          await _updateGroupRecognition(groupId, meetingId);
        }

        return true;
      } else {
        // Fallback to general share
        await SharePlus.instance.share(
          ShareParams(text: '$customMessage\n\n$shareLink'),
        );
        return true;
      }
    } catch (e) {
      // Removed debug print: print('Error sharing to WhatsApp: $e');
      return false;
    }
  }

  /// Recognize and track group interactions
  Future<GroupRecognition?> recognizeGroup(final String phoneNumber) async {
    try {
      final doc = await _firestore
          .collection('group_recognition')
          .where('phoneNumber', isEqualTo: phoneNumber)
          .get();

      if (doc.docs.isNotEmpty) {
        return GroupRecognition.fromJson(doc.docs.first.data());
      }
      return null;
    } catch (e) {
      // Removed debug print: print('Error recognizing group: $e');
      return null;
    }
  }

  /// Save group for future recognition
  Future<void> saveGroupForRecognition({
    required final String groupId,
    required final String groupName,
    required final String phoneNumber,
    required final String meetingId,
  }) async {
    try {
      final groupRecognition = GroupRecognition(
        groupId: groupId,
        groupName: groupName,
        phoneNumber: phoneNumber,
        firstSharedAt: DateTime.now(),
        totalShares: 1,
        totalResponses: 0,
        lastSharedAt: DateTime.now(),
      );

      await _firestore
          .collection('group_recognition')
          .doc(groupId)
          .set(groupRecognition.toJson());
    } catch (e) {
      // Removed debug print: print('Error saving group recognition: $e');
    }
  }

  /// Update group recognition stats
  Future<void> _updateGroupRecognition(
      final String groupId, final String meetingId) async {
    try {
      await _firestore.collection('group_recognition').doc(groupId).update({
        'totalShares': FieldValue.increment(1),
        'lastSharedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Removed debug print: print('Error updating group recognition: $e');
    }
  }

  /// Log share analytics
  Future<void> logShareAnalytics({
    required final String meetingId,
    required final String channel,
    final String? groupId,
    final String? creatorId,
  }) async {
    try {
      final analytics = ShareAnalytics(
        meetingId: meetingId,
        channel: channel,
        sharedAt: DateTime.now(),
        groupId: groupId,
        recipientId: creatorId,
        status: ShareStatus.shared,
      );

      await _firestore.collection('share_analytics').add(analytics.toJson());
    } catch (e) {
      // Removed debug print: print('Error logging share analytics: $e');
    }
  }

  /// Handle deep link when app is opened
  Future<void> handleDeepLink(final Uri uri) async {
    try {
      final pathSegments = uri.pathSegments;
      if (pathSegments.length >= 2 && pathSegments[0] == 'meeting') {
        final meetingId = pathSegments[1];
        final queryParams = uri.queryParameters;
        final groupId = queryParams['groupId'];

        // Track link click
        await FirebaseAnalytics.instance.logEvent(
          name: 'invite_clicked',
        );

        // Update analytics
        await _updateShareAnalytics(meetingId, ShareStatus.clicked);

        // Handle group recognition
        if (groupId != null) {
          await _updateGroupRecognition(groupId, meetingId);
        }

        // Navigate to appropriate screen based on user state
        // This will be handled by the main app router
      }
    } catch (e) {
      // Removed debug print: print('Error handling deep link: $e');
    }
  }

  /// Update share analytics status
  Future<void> _updateShareAnalytics(
      final String meetingId, final ShareStatus status) async {
    try {
      final query = await _firestore
          .collection('share_analytics')
          .where('meetingId', isEqualTo: meetingId)
          .orderBy('sharedAt', descending: true)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          'status': status.name,
          if (status == ShareStatus.responded)
            'respondedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      // Removed debug print: print('Error updating share analytics: $e');
    }
  }

  /// Get share statistics for a meeting
  Future<Map<String, dynamic>> getShareStats(final String meetingId) async {
    try {
      final snapshot = await _firestore
          .collection('share_analytics')
          .where('meetingId', isEqualTo: meetingId)
          .get();

      final analytics = snapshot.docs
          .map((final doc) => ShareAnalytics.fromJson(doc.data()))
          .toList();

      return {
        'totalShares': analytics.length,
        'whatsappShares':
            analytics.where((final a) => a.channel == 'whatsapp').length,
        'totalClicks': analytics
            .where((final a) => a.status == ShareStatus.clicked)
            .length,
        'totalResponses': analytics
            .where((final a) => a.status == ShareStatus.responded)
            .length,
        'groupShares': analytics.where((final a) => a.groupId != null).length,
      };
    } catch (e) {
      // Removed debug print: print('Error getting share stats: $e');
      return {};
    }
  }
}
