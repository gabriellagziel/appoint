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
  static const String _familyReminderAssignmentEnabled =
      'family_reminder_assignment_enabled';

  // Default values
  static const Map<String, dynamic> _defaults = {
    _familyUiEnabled: false,
    _familyCalendarEnabled: false,
    _familyReminderAssignmentEnabled: false,
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
  bool get isFamilyReminderAssignmentEnabled =>
      _remoteConfig.getBool(_familyReminderAssignmentEnabled);

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
      'family_reminder_assignment_enabled': isFamilyReminderAssignmentEnabled,
    };
  }

  // Check if any family features are enabled
  bool get areFamilyFeaturesEnabled =>
      isFamilyUiEnabled ||
      isFamilyCalendarEnabled ||
      isFamilyReminderAssignmentEnabled;
}
