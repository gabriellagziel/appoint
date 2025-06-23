import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'whatsapp_share_service.dart';

class CustomDeepLinkService {
  late final WhatsAppShareService _whatsappService;
  CustomDeepLinkService({WhatsAppShareService? whatsappShareService}) {
    _whatsappService =
        whatsappShareService ?? WhatsAppShareService(deepLinkService: this);
  }
  StreamSubscription? _linkSubscription;
  StreamSubscription? _initialLinkSubscription;
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Set the navigator key for navigation
  void setNavigatorKey(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;
  }

  /// Initialize deep link handling
  Future<void> initialize() async {
    if (kIsWeb) {
      // Deep linking is not supported on web
      return;
    }
    try {
      // Handle initial link if app was opened from a link
      final initialUri = await getInitialUri();
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
          print('Deep link error: $error');
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
          print('App link error: $error');
        },
      );
    } catch (e) {
      print('Error initializing deep links: $e');
    }
  }

  /// Handle incoming deep links
  Future<void> _handleDeepLink(Uri uri) async {
    try {
      print('Handling deep link: $uri');

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
              final inviteId = pathSegments[1];
              await _navigateToInvite(inviteId);
            }
            break;
          case 'booking':
            if (pathSegments.length >= 2) {
              final bookingId = pathSegments[1];
              await _navigateToBooking(bookingId);
            }
            break;
          default:
            print('Unknown deep link path: ${pathSegments[0]}');
        }
      }
    } catch (e) {
      print('Error handling deep link: $e');
    }
  }

  /// Navigate to meeting details screen
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
      print('Navigator key not set, cannot navigate to meeting: $meetingId');
    }
  }

  /// Navigate to invite details screen
  Future<void> _navigateToInvite(String inviteId) async {
    if (_navigatorKey?.currentState != null) {
      _navigatorKey!.currentState!.pushNamed(
        '/invite/details',
        arguments: {'inviteId': inviteId},
      );
    } else {
      print('Navigator key not set, cannot navigate to invite: $inviteId');
    }
  }

  /// Navigate to booking details screen
  Future<void> _navigateToBooking(String bookingId) async {
    if (_navigatorKey?.currentState != null) {
      _navigatorKey!.currentState!.pushNamed(
        '/booking/details',
        arguments: {'bookingId': bookingId},
      );
    } else {
      print('Navigator key not set, cannot navigate to booking: $bookingId');
    }
  }

  /// Create a deep link for a meeting using custom URL scheme
  Future<String> createMeetingLink({
    required String meetingId,
    required String creatorId,
    String? contextId,
    String? groupId,
  }) async {
    try {
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

      final link =
          'https://app-oint-core.web.app/meeting/$meetingId?$queryString';

      // Store share analytics
      await _whatsappService.logShareAnalytics(
        meetingId: meetingId,
        channel: 'whatsapp',
        groupId: groupId,
        creatorId: creatorId,
      );

      return link;
    } catch (e) {
      print('Error creating meeting link: $e');
      // Fallback to simple URL
      return 'https://app-oint-core.web.app/meeting/$meetingId?creatorId=$creatorId${contextId != null ? '&contextId=$contextId' : ''}';
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
    } catch (e) {
      print('Error creating short link: $e');
      return longUrl;
    }
  }

  /// Dispose resources
  void dispose() {
    _linkSubscription?.cancel();
    _initialLinkSubscription?.cancel();
  }
}
