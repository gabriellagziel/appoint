import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  // Feature flags
  static const String _familyUiEnabled = 'family_ui_enabled';
  static const String _familyCalendarEnabled = 'family_calendar_enabled';
  static const String REDACTED_TOKEN =
      'REDACTED_TOKEN';

  // Default values
  static const Map<String, dynamic> _defaults = {
    _familyUiEnabled: false,
    _familyCalendarEnabled: false,
    REDACTED_TOKEN: false,
  };

  Future<void> initialize() async {
    try {
      // Set minimum fetch interval for development
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval:
            kDebugMode ? const Duration(minutes: 1) : const Duration(hours: 1),
      ));

      // Set defaults
      await _remoteConfig.setDefaults(_defaults);

      // Fetch and activate
      await _remoteConfig.fetchAndActivate();

      debugPrint('✅ Remote Config initialized successfully');
    } catch (e) {
      debugPrint('❌ Remote Config initialization failed: $e');
    }
  }

  // Feature flag getters
  bool get isFamilyUiEnabled => _remoteConfig.getBool(_familyUiEnabled);
  bool get isFamilyCalendarEnabled =>
      _remoteConfig.getBool(_familyCalendarEnabled);
  bool get REDACTED_TOKEN =>
      _remoteConfig.getBool(REDACTED_TOKEN);

  // Force refresh (for testing)
  Future<void> forceRefresh() async {
    try {
      await _remoteConfig.fetchAndActivate();
      debugPrint('🔄 Remote Config refreshed');
    } catch (e) {
      debugPrint('❌ Remote Config refresh failed: $e');
    }
  }

  // Get all feature flags as map
  Map<String, bool> getAllFeatureFlags() {
    return {
      'family_ui_enabled': isFamilyUiEnabled,
      'family_calendar_enabled': isFamilyCalendarEnabled,
      'REDACTED_TOKEN': REDACTED_TOKEN,
    };
  }

  // Check if any family features are enabled
  bool get areFamilyFeaturesEnabled =>
      isFamilyUiEnabled ||
      isFamilyCalendarEnabled ||
      REDACTED_TOKEN;
}
