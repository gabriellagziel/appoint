import 'dart:async';

import 'package:appoint/config/environment_config.dart';
import 'package:appoint/services/whatsapp_share_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
class CustomDeepLinkService {
  CustomDeepLinkService({WhatsAppShareService? whatsappShareService}) {
    _whatsappService =
        whatsappShareService ?? WhatsAppShareService(deepLinkService: this);
  }
  late final WhatsAppShareService _whatsappService;
  StreamSubscription? _linkSubscription;
  StreamSubscription? _initialLinkSubscription;
  // GlobalKey is kept for future navigation features.
  // ignore: unused_field
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Set the navigator key for navigation
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Initialize deep link handling
  Future<void> initialize() async {
    try {
      // Handle initial link if app was opened from a link
      initialUri = await getInitialUri();
      if (initialUri != null) {
        await _handleDeepLink(initialUri);
      }

      // Listen for incoming links when app is already running
      _linkSubscription = uriLinkStream.listen(
        (Uri? uri) async {
          if (uri != null) {
            await _handleDeepLink(uri);
          }
        },
        onError: (error) {
          // Removed debug print: debugPrint('Deep link error: $error');
        },
      );

      // Listen for app links (universal links)
      _initialLinkSubscription = uriLinkStream.listen(
        (Uri? uri) async {
          if (uri != null) {
            await _handleDeepLink(uri);
          }
        },
        onError: (error) {
          // Removed debug print: debugPrint('App link error: $error');
        },
      );
    } catch (e) {
      // Removed debug print: debugPrint('Error initializing deep links: $e');
    }
  }

  /// Handle incoming deep links
  Future<void> _handleDeepLink(Uri uri) async {
    try {
      // Let WhatsApp service handle the link first for analytics
      await _whatsappService.handleDeepLink(uri);

      // Parse the link and determine the action
      final pathSegments = uri.pathSegments;
      final queryParams = uri.queryParameters;

      if (pathSegments.isNotEmpty) {
        switch (pathSegments[0]) {
          case 'meeting':
            if (pathSegments.length >= 2) {
              final meetingId = pathSegments[1];
              final creatorId = queryParams['creatorId'];
              final contextId = queryParams['contextId'];
              final groupId = queryParams['groupId'];

              // Navigate to meeting details or confirmation screen
              await _navigateToMeeting(
                  meetingId, creatorId, contextId, groupId);
            }
            break;
          case 'invite':
            if (pathSegments.length >= 2) {
              final appointmentId = pathSegments[1];
              final creatorId = queryParams['creatorId'];
              final shareId = queryParams['shareId'];
              final source = queryParams['source'];
              final groupShare = queryParams['group_share'];
              final guestAccepted = queryParams['guest_accepted'];

              // Handle guest view for web
              if (kIsWeb) {
                await _navigateToGuestView(appointmentId, creatorId, shareId, source);
              } else {
                // Handle registered user invite
                await _navigateToInvite(appointmentId, creatorId, shareId, source);
              }
            }
            break;
          case 'booking':
            if (pathSegments.length >= 2) {
              final bookingId = pathSegments[1];
              await _navigateToBooking(bookingId);
            }
            break;
          default:
            // Removed debug print: debugPrint('Unknown deep link path: ${pathSegments[0]}');
        }
      }
    } catch (e) {
      // Removed debug print: debugPrint('Error handling deep link: $e');
    }
  }

  // Navigate helper methods
  Future<void> _navigateToMeeting(
    String meetingId,
    String? creatorId,
    String? contextId,
    String? groupId,
  ) async {
    if (_navigatorKey?.currentState != null) {
      _navigatorKey!.currentState!.pushNamed(
        '/meeting/details',
        arguments: {
          'meetingId': meetingId,
          'creatorId': creatorId,
          'contextId': contextId,
          'groupId': groupId,
        },
      );
    } else {
      // Removed debug print: debugPrint('Navigator key not set, cannot navigate to meeting: \$meetingId');
    }
  }

  Future<void> _navigateToInvite(
    String appointmentId,
    String? creatorId,
    String? shareId,
    String? source,
  ) async {
    if (_navigatorKey?.currentState != null) {
      _navigatorKey!.currentState!.pushNamed(
        '/invite/details',
        arguments: {
          'appointmentId': appointmentId,
          'creatorId': creatorId,
          'shareId': shareId,
          'source': source,
        },
      );
    } else {
      // Removed debug print: debugPrint('Navigator key not set, cannot navigate to invite: \$appointmentId');
    }
  }

  Future<void> _navigateToGuestView(
    String appointmentId,
    String? creatorId,
    String? shareId,
    String? source,
  ) async {
    if (_navigatorKey?.currentState != null) {
      _navigatorKey!.currentState!.pushNamed(
        '/guest/meeting',
        arguments: {
          'appointmentId': appointmentId,
          'creatorId': creatorId ?? '',
          'shareId': shareId,
          'source': source,
        },
      );
    } else {
      // Removed debug print: debugPrint('Navigator key not set, cannot navigate to guest view: \$appointmentId');
    }
  }

  Future<void> _navigateToBooking(String bookingId) async {
    if (_navigatorKey?.currentState != null) {
      _navigatorKey!.currentState!.pushNamed(
        '/booking/details',
        arguments: {'bookingId': bookingId},
      );
    } else {
      // Removed debug print: debugPrint('Navigator key not set, cannot navigate to booking: \$bookingId');
    }
  }

  /// Create a deep link for a meeting using custom URL scheme
  Future<String> createMeetingLink({
    required final String meetingId,
    required final String creatorId,
    final String? contextId,
    final String? groupId,
  }) async {
    try {
      // Load base URL from environment configuration
      const baseUrl = EnvironmentConfig.deepLinkBaseUrl;

      // Create a custom URL scheme link
      final queryParams = <String, String>{
        'creatorId': creatorId,
      };

      if (contextId != null) {
        queryParams['contextId'] = contextId;
      }

      if (groupId != null) {
        queryParams['groupId'] = groupId;
      }

      final queryString = queryParams.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');

      final link = '$baseUrl/meeting/$meetingId?$queryString';

      // Store share analytics
      await _whatsappService.logShareAnalytics(
        meetingId: meetingId,
        channel: 'whatsapp',
        groupId: groupId,
        creatorId: creatorId,
      );

      return link;
    } catch (e) {e) {
      // Removed debug print: debugPrint('Error creating meeting link: $e');
      // Fallback to simple URL
      const baseUrl = EnvironmentConfig.deepLinkBaseUrl;
      return '$baseUrl/meeting/$meetingId?creatorId=$creatorId${contextId != null ? '&contextId=$contextId' : ''}';
    }
  }

  /// Create a short link using a URL shortener service
  Future<String> createShortLink(String longUrl) async {
    try {
      // You can integrate with URL shortener services like:
      // - Bitly API
      // - TinyURL API
      // - Firebase Hosting (for static redirects)

      // For now, return the long URL
      // In production, you would call a URL shortener API
      return longUrl;
    } catch (e) {e) {
      // Removed debug print: debugPrint('Error creating short link: $e');
      return longUrl;
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    _initialLinkSubscription?.cancel();
  }
}
