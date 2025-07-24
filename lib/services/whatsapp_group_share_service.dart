import 'dart:math';

import 'package:appoint/config/environment_config.dart';
import 'package:appoint/models/invite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppGroupShareService {
  WhatsAppGroupShareService({
    FirebaseFirestore? firestore,
    FirebaseAnalytics? analytics,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _analytics = analytics ?? FirebaseAnalytics.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAnalytics _analytics;

  /// Generate a unique share link for WhatsApp group sharing
  Future<String> generateGroupShareLink({
    required String appointmentId,
    required String creatorId,
    String? meetingTitle,
    DateTime? meetingDate,
  }) async {
    try {
      // Generate unique share ID
      final shareId = _generateShareId();
      
      // Create base URL with tracking parameters
      const baseUrl = EnvironmentConfig.deepLinkBaseUrl;
      final queryParams = <String, String>{
        'appointmentId': appointmentId,
        'creatorId': creatorId,
        'source': InviteSource.whatsapp_group.name,
        'shareId': shareId,
        'group_share': '1', // Flag for group sharing
      };

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final shareUrl = '$baseUrl/invite/$appointmentId?$queryString';

      // Store share event for analytics
      await _logShareGenerated(
        appointmentId: appointmentId,
        shareId: shareId,
        creatorId: creatorId,
        shareUrl: shareUrl,
      );

      return shareUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Error generating group share link: $e');
      }
      rethrow;
    }
  }

  /// Share appointment to WhatsApp with a pre-composed message
  Future<bool> shareToWhatsAppGroup({
    required String appointmentId,
    required String creatorId,
    required String meetingTitle,
    required DateTime meetingDate,
    String? customMessage,
  }) async {
    try {
      // Generate unique share link
      final shareUrl = await generateGroupShareLink(
        appointmentId: appointmentId,
        creatorId: creatorId,
        meetingTitle: meetingTitle,
        meetingDate: meetingDate,
      );

      // Create pre-composed message
      final message = customMessage ?? _createDefaultMessage(
        meetingTitle: meetingTitle,
        meetingDate: meetingDate,
        shareUrl: shareUrl,
      );

      // Open WhatsApp with the message
      final whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
      final uri = Uri.parse(whatsappUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        
        // Track successful share
        await _analytics.logEvent(
          name: 'whatsapp_group_share',
          parameters: {
            'appointment_id': appointmentId,
            'creator_id': creatorId,
            'method': 'whatsapp_group',
          },
        );

        return true;
      } else {
        throw Exception('Could not launch WhatsApp');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sharing to WhatsApp group: $e');
      }
      return false;
    }
  }

  /// Track when someone clicks on a shared link
  Future<void> trackLinkClick({
    required String shareId,
    required String appointmentId,
    String? userAgent,
  }) async {
    try {
      await _firestore.collection('share_clicks').add({
        'shareId': shareId,
        'appointmentId': appointmentId,
        'clickedAt': FieldValue.serverTimestamp(),
        'userAgent': userAgent,
        'source': InviteSource.whatsapp_group.name,
      });

      await _analytics.logEvent(
        name: 'share_link_clicked',
        parameters: {
          'share_id': shareId,
          'appointment_id': appointmentId,
          'source': InviteSource.whatsapp_group.name,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error tracking link click: $e');
      }
    }
  }

  /// Track when someone joins via the shared link
  Future<void> trackParticipantJoined({
    required String shareId,
    required String appointmentId,
    required String participantId,
  }) async {
    try {
      await _firestore.collection('share_conversions').add({
        'shareId': shareId,
        'appointmentId': appointmentId,
        'participantId': participantId,
        'joinedAt': FieldValue.serverTimestamp(),
        'source': InviteSource.whatsapp_group.name,
      });

      await _analytics.logEvent(
        name: 'participant_joined_via_share',
        parameters: {
          'share_id': shareId,
          'appointment_id': appointmentId,
          'participant_id': participantId,
          'source': InviteSource.whatsapp_group.name,
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error tracking participant join: $e');
      }
    }
  }

  /// Get analytics for a specific appointment
  Future<Map<String, dynamic>> getAppointmentShareAnalytics(String appointmentId) async {
    try {
      // Get share events
      final shareQuery = await _firestore
          .collection('whatsapp_shares')
          .where('appointmentId', isEqualTo: appointmentId)
          .get();

      // Get click events
      final clickQuery = await _firestore
          .collection('share_clicks')
          .where('appointmentId', isEqualTo: appointmentId)
          .get();

      // Get conversion events
      final conversionQuery = await _firestore
          .collection('share_conversions')
          .where('appointmentId', isEqualTo: appointmentId)
          .get();

      final totalShares = shareQuery.docs.length;
      final totalClicks = clickQuery.docs.length;
      final totalJoins = conversionQuery.docs.length;

      // Calculate WhatsApp group specific metrics
      final whatsappGroupShares = shareQuery.docs
          .where((doc) => doc.data()['source'] == InviteSource.whatsapp_group.name)
          .length;

      final whatsappGroupClicks = clickQuery.docs
          .where((doc) => doc.data()['source'] == InviteSource.whatsapp_group.name)
          .length;

      final whatsappGroupJoins = conversionQuery.docs
          .where((doc) => doc.data()['source'] == InviteSource.whatsapp_group.name)
          .length;

      return {
        'totalShares': totalShares,
        'totalClicks': totalClicks,
        'totalJoins': totalJoins,
        'whatsappGroupShares': whatsappGroupShares,
        'whatsappGroupClicks': whatsappGroupClicks,
        'whatsappGroupJoins': whatsappGroupJoins,
        'clickThroughRate': totalShares > 0 ? (totalClicks / totalShares) : 0.0,
        'conversionRate': totalClicks > 0 ? (totalJoins / totalClicks) : 0.0,
        'whatsappGroupConversionRate': whatsappGroupClicks > 0 
            ? (whatsappGroupJoins / whatsappGroupClicks) : 0.0,
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error getting appointment analytics: $e');
      }
      return {};
    }
  }

  /// Generate a unique share ID
  String _generateShareId() {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(12, (_) => chars[random.nextInt(chars.length)]).join();
  }

  /// Create default message for WhatsApp sharing
  String _createDefaultMessage({
    required String meetingTitle,
    required DateTime meetingDate,
    required String shareUrl,
  }) {
    final formattedDate = '${meetingDate.day}/${meetingDate.month}/${meetingDate.year}';
    final formattedTime = '${meetingDate.hour.toString().padLeft(2, '0')}:${meetingDate.minute.toString().padLeft(2, '0')}';
    
    return '''
🗓️ You're invited to: $meetingTitle

📅 Date: $formattedDate
⏰ Time: $formattedTime

Click here to join: $shareUrl

See you there! 👋
'''.trim();
  }

  /// Store share event for analytics
  Future<void> _logShareGenerated({
    required String appointmentId,
    required String shareId,
    required String creatorId,
    required String shareUrl,
  }) async {
    try {
      await _firestore.collection('whatsapp_shares').add({
        'appointmentId': appointmentId,
        'shareId': shareId,
        'creatorId': creatorId,
        'shareUrl': shareUrl,
        'source': InviteSource.whatsapp_group.name,
        'sharedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error logging share generated: $e');
      }
    }
  }
}