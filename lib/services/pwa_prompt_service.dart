import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_meta_service.dart';
import 'analytics_service.dart';

class PwaPromptService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static bool _isInstallPromptAvailable = false;
  static bool _isPwaInstalled = false;
  static Function? _installPromptCallback;
  static DateTime? _lastPromptShown;
  static DateTime? _snoozeUntil;
  static bool _promptShownThisSession = false;

  /// Initialize PWA prompt service - call this in main.dart
  static void initialize() {
    if (!kIsWeb) return;

    // Listen for PWA install availability
    html.window.addEventListener('beforeinstallprompt', (event) {
      print('PWA: Install prompt available');
      _isInstallPromptAvailable = true;
      event.preventDefault();
    });

    // Listen for successful PWA installation
    html.window.addEventListener('appinstalled', (event) {
      print('PWA: App was installed');
      _isPwaInstalled = true;
      _markPwaAsInstalled();
    });

    // Listen for service worker messages
    _setupServiceWorkerListener();

    // Check if already running as PWA
    _checkIfRunningAsPwa();
  }

  /// Setup service worker message listener
  static void _setupServiceWorkerListener() {
    if (!kIsWeb) return;

    try {
      js.context['navigator']['serviceWorker'].callMethod('addEventListener', [
        'message',
        js.allowInterop((event) {
          final data = event['data'];
          if (data != null) {
            final type = data['type'];

            if (type == 'PWA_INSTALL_AVAILABLE') {
              _isInstallPromptAvailable = data['canInstall'] ?? false;
              print(
                  'PWA: Install availability updated: $_isInstallPromptAvailable');
            } else if (type == 'PWA_INSTALLED') {
              _isPwaInstalled = true;
              _markPwaAsInstalled();
            } else if (type == 'PWA_PROMPT_RESULT') {
              final outcome = data['outcome'];
              print('PWA: User choice: $outcome');
              if (outcome == 'accepted') {
                _isPwaInstalled = true;
                _markPwaAsInstalled();
              }
            }
          }
        })
      ]);
    } catch (e) {
      print('Error setting up service worker listener: $e');
    }
  }

  /// Check if app is already running as PWA
  static void _checkIfRunningAsPwa() {
    if (!kIsWeb) return;

    try {
      // Check if running in standalone mode (PWA)
      final isStandalone =
          html.window.matchMedia('(display-mode: standalone)').matches;

      // iOS specific check for navigator.standalone
      bool isIosStandalone = false;
      try {
        isIosStandalone =
            js.context['window']['navigator']['standalone'] == true;
      } catch (e) {
        // navigator.standalone not available, ignore
      }

      // Additional check for fullscreen mode
      final isFullscreen =
          html.window.matchMedia('(display-mode: fullscreen)').matches;

      if (isStandalone || isIosStandalone || isFullscreen) {
        _isPwaInstalled = true;
        _markPwaAsInstalled();
        print('PWA: Detected app running in standalone mode');
      }
    } catch (e) {
      print('Error checking PWA status: $e');
    }
  }

  /// Mark PWA as installed in Firestore
  static void _markPwaAsInstalled([String? source]) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        await UserMetaService.markPwaAsInstalled(userId);

        // Log analytics event
        await AnalyticsService.logPwaInstalled(
          device: isIosDevice ? 'ios' : (isAndroidDevice ? 'android' : 'other'),
          source: source ?? 'automatic_detection',
          userId: userId,
        );

        print('PWA: Marked as installed in Firestore');
      }
    } catch (e) {
      print('Error marking PWA as installed: $e');
    }
  }

  /// Trigger PWA install prompt
  static Future<bool> showInstallPrompt() async {
    if (!kIsWeb || !_isInstallPromptAvailable) return false;

    try {
      // Send message to service worker to show install prompt
      if (js.context['navigator']['serviceWorker']['controller'] != null) {
        js.context['navigator']['serviceWorker']['controller']
            .callMethod('postMessage', [
          js.JsObject.jsify({'type': 'SHOW_PWA_PROMPT'})
        ]);
        return true;
      }
    } catch (e) {
      print('Error showing PWA install prompt: $e');
    }

    return false;
  }

  /// Check if user should see PWA prompt after creating meeting
  static Future<bool> shouldShowPromptAfterMeeting(String? userId) async {
    if (!kIsWeb || _isPwaInstalled || !isMobileDevice) return false;

    try {
      // Check if snoozed (user said "Not now" in last 24h)
      if (_snoozeUntil != null && DateTime.now().isBefore(_snoozeUntil!)) {
        print('PWA: Prompt snoozed until ${_snoozeUntil}');
        return false;
      }

      // Check if already shown this session
      if (_promptShownThisSession) {
        print('PWA: Prompt already shown this session');
        return false;
      }

      // Increment meeting count first
      await UserMetaService.incrementPwaPromptCount(userId);

      // Check if should show prompt
      final shouldShow = await UserMetaService.shouldShowPwaPrompt(userId);

      if (shouldShow) {
        // Update last prompt shown timestamp
        await UserMetaService.updateLastPwaPromptShown(userId);
        _lastPromptShown = DateTime.now();
        _promptShownThisSession = true;

        // Log analytics event
        await AnalyticsService.logPwaPromptShown(
          device: isIosDevice ? 'ios' : (isAndroidDevice ? 'android' : 'other'),
          reason: 'meeting_count_trigger',
          userId: userId,
        );
      }

      return shouldShow && (_isInstallPromptAvailable || isIosDevice);
    } catch (e) {
      print('Error checking if should show PWA prompt: $e');
      return false;
    }
  }

  /// Mark prompt as snoozed for 24 hours
  static void snoozePrompt() async {
    _snoozeUntil = DateTime.now().add(const Duration(hours: 24));

    // Log analytics event
    await AnalyticsService.logPwaPromptDismissed(
      device: isIosDevice ? 'ios' : (isAndroidDevice ? 'android' : 'other'),
      userId: _auth.currentUser?.uid,
    );

    print('PWA: Prompt snoozed for 24 hours');
  }

  /// Reset session flag (call when app restarts)
  static void resetSession() {
    _promptShownThisSession = false;
    print('PWA: Session reset');
  }

  /// Get current PWA status
  static bool get isInstallPromptAvailable => _isInstallPromptAvailable;
  static bool get isPwaInstalled => _isPwaInstalled;

  /// Check if device supports PWA
  static bool get supportsPwa {
    if (!kIsWeb) return false;

    try {
      return js.context['navigator']['serviceWorker'] != null;
    } catch (e) {
      return false;
    }
  }

  /// Check if device is mobile
  static bool get isMobileDevice {
    if (!kIsWeb) return false;

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

  /// Check if device is iOS
  static bool get isIosDevice {
    if (!kIsWeb) return false;

    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      return userAgent.contains('iphone') || userAgent.contains('ipad');
    } catch (e) {
      return false;
    }
  }

  /// Check if device is Android
  static bool get isAndroidDevice {
    if (!kIsWeb) return false;

    try {
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      return userAgent.contains('android');
    } catch (e) {
      return false;
    }
  }
}
