import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html' as html;

/// Analytics service for tracking PWA events
class AnalyticsService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Log PWA prompt shown event
  static Future<void> logPwaPromptShown({
    required String device,
    required String reason,
    String? userId,
  }) async {
    userId ??= _auth.currentUser?.uid;

    final event = {
      'event': 'pwa_prompt_shown',
      'device': device,
      'reason': reason,
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'user_agent': _getUserAgent(),
      'is_mobile': _isMobile(),
      'supports_install_prompt': _supportsInstallPrompt(),
    };

    await _logEvent(event);
    print('📊 Analytics: PWA prompt shown - Device: $device, Reason: $reason');
  }

  /// Log PWA prompt dismissed event
  static Future<void> logPwaPromptDismissed({
    required String device,
    String? userId,
  }) async {
    userId ??= _auth.currentUser?.uid;

    final event = {
      'event': 'pwa_prompt_dismissed',
      'device': device,
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'user_agent': _getUserAgent(),
    };

    await _logEvent(event);
    print('📊 Analytics: PWA prompt dismissed - Device: $device');
  }

  /// Log PWA install accepted event (user clicked "Add Now")
  static Future<void> logPwaInstallAccepted({
    required String device,
    String? userId,
  }) async {
    userId ??= _auth.currentUser?.uid;

    final event = {
      'event': 'pwa_install_accepted',
      'device': device,
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'user_agent': _getUserAgent(),
    };

    await _logEvent(event);
    print('📊 Analytics: PWA install accepted - Device: $device');
  }

  /// Log PWA successfully installed event
  static Future<void> logPwaInstalled({
    required String device,
    required String source,
    String? userId,
  }) async {
    userId ??= _auth.currentUser?.uid;

    final event = {
      'event': 'pwa_installed',
      'device': device,
      'source':
          source, // android_native_prompt, ios_manual, automatic_detection
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'user_agent': _getUserAgent(),
      'display_mode': _getDisplayMode(),
    };

    await _logEvent(event);
    print('📊 Analytics: PWA installed - Device: $device, Source: $source');
  }

  /// Log meeting creation event (for PWA trigger tracking)
  static Future<void> logMeetingCreated({
    required String meetingType,
    required int userMeetingCount,
    required bool willShowPwaPrompt,
    String? userId,
  }) async {
    userId ??= _auth.currentUser?.uid;

    final event = {
      'event': 'meeting_created',
      'meeting_type': meetingType,
      'user_meeting_count': userMeetingCount,
      'will_show_pwa_prompt': willShowPwaPrompt,
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'device': _getDeviceType(),
    };

    await _logEvent(event);
    print(
        '📊 Analytics: Meeting created - Type: $meetingType, Count: $userMeetingCount, PWA: $willShowPwaPrompt');
  }

  /// Log PWA feature usage
  static Future<void> logPwaFeatureUsed({
    required String feature,
    Map<String, dynamic>? additionalData,
    String? userId,
  }) async {
    userId ??= _auth.currentUser?.uid;

    final event = {
      'event': 'pwa_feature_used',
      'feature': feature,
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'is_standalone': _isStandaloneMode(),
      ...?additionalData,
    };

    await _logEvent(event);
    print('📊 Analytics: PWA feature used - Feature: $feature');
  }

  /// Log PWA performance metrics
  static Future<void> logPwaPerformance({
    required String metric,
    required num value,
    String? unit,
    String? userId,
  }) async {
    userId ??= _auth.currentUser?.uid;

    final event = {
      'event': 'pwa_performance',
      'metric': metric,
      'value': value,
      'unit': unit ?? 'ms',
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'is_standalone': _isStandaloneMode(),
    };

    await _logEvent(event);
    print('📊 Analytics: PWA performance - $metric: $value${unit ?? 'ms'}');
  }

  /// Private helper methods

  static Future<void> _logEvent(Map<String, dynamic> event) async {
    try {
      if (kDebugMode) {
        print('📊 Analytics Event: ${event}');
      }

      // TODO: Integrate with your analytics provider
      // Examples:
      // - Firebase Analytics: FirebaseAnalytics.instance.logEvent(...)
      // - Google Analytics: gtag('event', ...)
      // - Custom analytics: HTTP POST to your endpoint

      // For now, just console log in debug mode
      if (kIsWeb && kDebugMode) {
        // Could also send to console for browser debugging
        html.window.console.log('PWA Analytics: $event');
      }
    } catch (e) {
      print('❌ Analytics error: $e');
    }
  }

  static String _getUserAgent() {
    if (!kIsWeb) return 'flutter-app';
    try {
      return html.window.navigator.userAgent;
    } catch (e) {
      return 'unknown';
    }
  }

  static String _getDeviceType() {
    if (!kIsWeb) return 'mobile-app';

    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      if (userAgent.contains('iphone') || userAgent.contains('ipad')) {
        return 'ios';
      } else if (userAgent.contains('android')) {
        return 'android';
      } else if (userAgent.contains('mobile')) {
        return 'mobile-other';
      } else {
        return 'desktop';
      }
    } catch (e) {
      return 'unknown';
    }
  }

  static bool _isMobile() {
    if (!kIsWeb) return true;

    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      return userAgent.contains('mobile') ||
          userAgent.contains('android') ||
          userAgent.contains('iphone') ||
          userAgent.contains('ipad');
    } catch (e) {
      return false;
    }
  }

  static bool _supportsInstallPrompt() {
    if (!kIsWeb) return false;

    try {
      return html.window.navigator.serviceWorker != null;
    } catch (e) {
      return false;
    }
  }

  static String _getDisplayMode() {
    if (!kIsWeb) return 'unknown';

    try {
      if (html.window.matchMedia('(display-mode: standalone)').matches) {
        return 'standalone';
      } else if (html.window.matchMedia('(display-mode: fullscreen)').matches) {
        return 'fullscreen';
      } else if (html.window.matchMedia('(display-mode: minimal-ui)').matches) {
        return 'minimal-ui';
      } else {
        return 'browser';
      }
    } catch (e) {
      return 'unknown';
    }
  }

  static bool _isStandaloneMode() {
    if (!kIsWeb) return false;

    try {
      return html.window.matchMedia('(display-mode: standalone)').matches;
    } catch (e) {
      return false;
    }
  }
}

/// Extension for easier integration with existing code
extension AnalyticsHelper on Object {
  Future<void> logAnalytics(String event, [Map<String, dynamic>? data]) async {
    await AnalyticsService._logEvent({
      'event': event,
      'timestamp': DateTime.now().toIso8601String(),
      ...?data,
    });
  }
}
