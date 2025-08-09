import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/location.dart';
import '../analytics/analytics_service.dart';

class DeeplinkNavigationService {
  /// Open navigation to location with platform-appropriate map app
  static Future<void> navigateToLocation(
    Location location, {
    String? meetingId,
  }) async {
    final providers = _getAvailableProviders();

    if (providers.length == 1) {
      // Only one option available, open directly
      await _openWithProvider(providers.first, location, meetingId);
    } else {
      // Multiple options, show chooser (for now, default to first)
      // TODO: Implement proper chooser UI
      await _openWithProvider(providers.first, location, meetingId);
    }
  }

  /// Get available navigation providers for current platform
  static List<NavigationProvider> _getAvailableProviders() {
    if (kIsWeb) {
      return [
        NavigationProvider.googleMaps,
        NavigationProvider.openStreetMap,
      ];
    } else {
      // Mobile platforms
      return [
        NavigationProvider.googleMaps,
        NavigationProvider.appleMaps,
      ];
    }
  }

  /// Open navigation with specific provider
  static Future<void> _openWithProvider(
    NavigationProvider provider,
    Location location,
    String? meetingId,
  ) async {
    final url = buildNavigationUrl(provider, location);

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Track analytics
        AnalyticsService.track("navigate_opened", {
          "provider": provider.name,
          "meetingId": meetingId,
          "latitude": location.latitude,
          "longitude": location.longitude,
          "locationName": location.name,
        });
      } else {
        throw Exception('Could not launch navigation URL');
      }
    } catch (e) {
      // Fallback: try to open in browser
      final fallbackUrl = buildFallbackUrl(location);
      final uri = Uri.parse(fallbackUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

  /// Build navigation URL for specific provider
  static String buildNavigationUrl(
      NavigationProvider provider, Location location) {
    final lat = location.latitude;
    final lng = location.longitude;
    final name = location.name ?? location.address ?? '';
    final encodedName = Uri.encodeComponent(name);

    switch (provider) {
      case NavigationProvider.googleMaps:
        return 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng${name.isNotEmpty ? '&destination_place_id=$encodedName' : ''}';

      case NavigationProvider.appleMaps:
        return 'http://maps.apple.com/?daddr=$lat,$lng${name.isNotEmpty ? '&q=$encodedName' : ''}';

      case NavigationProvider.openStreetMap:
        return 'https://www.openstreetmap.org/directions?to=$lat,$lng${name.isNotEmpty ? '&name=$encodedName' : ''}';
    }
  }

  /// Build fallback URL (Google Maps in browser)
  static String buildFallbackUrl(Location location) {
    final lat = location.latitude;
    final lng = location.longitude;
    final name = location.name ?? location.address ?? '';
    final encodedName = Uri.encodeComponent(name);

    return 'https://www.google.com/maps/search/${encodedName.isNotEmpty ? encodedName : '$lat,$lng'}';
  }
}

/// Available navigation providers
enum NavigationProvider {
  googleMaps('Google Maps'),
  appleMaps('Apple Maps'),
  openStreetMap('OpenStreetMap');

  const NavigationProvider(this.name);
  final String name;
}
