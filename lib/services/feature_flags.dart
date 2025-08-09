import 'package:firebase_remote_config/firebase_remote_config.dart';

/// AUDIT: Feature flags for Share-in-Groups functionality
class FeatureFlags {
  static const String _shareLinksEnabled = 'feature_share_links_enabled';
  static const String _guestRsvpEnabled = 'feature_guest_rsvp_enabled';
  static const String _publicMeetingPageV2 = 'feature_public_meeting_page_v2';

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  /// Initialize feature flags
  Future<void> initialize() async {
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));

    await _remoteConfig.setDefaults({
      _shareLinksEnabled: false,
      _guestRsvpEnabled: false,
      _publicMeetingPageV2: false,
    });

    await _remoteConfig.fetchAndActivate();
  }

  /// Check if share links feature is enabled
  bool get isShareLinksEnabled => _remoteConfig.getBool(_shareLinksEnabled);

  /// Check if guest RSVP feature is enabled
  bool get isGuestRsvpEnabled => _remoteConfig.getBool(_guestRsvpEnabled);

  /// Check if public meeting page v2 is enabled
  bool get isPublicMeetingPageV2Enabled =>
      _remoteConfig.getBool(_publicMeetingPageV2);

  /// Get all feature flags status
  Map<String, bool> get allFlags => {
        'share_links_enabled': isShareLinksEnabled,
        'guest_rsvp_enabled': isGuestRsvpEnabled,
        'public_meeting_page_v2': isPublicMeetingPageV2Enabled,
      };

  /// Check if any share-in-groups feature is enabled
  bool get isAnyShareFeatureEnabled =>
      isShareLinksEnabled || isGuestRsvpEnabled || isPublicMeetingPageV2Enabled;
}
