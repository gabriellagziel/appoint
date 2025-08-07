import 'dart:io';
import 'package:flutter/services.dart';

class NavigationService {
  /// Opens Google Maps with directions to the specified location
  static Future<void> openDirections({
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    final url =
        'https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude';
    await _launchUrl(url);
  }

  /// Opens Google Maps with the location pinned (without directions)
  static Future<void> openLocation({
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await _launchUrl(url);
  }

  /// Opens the device's default maps app (iOS Maps, Google Maps, etc.)
  static Future<void> openNativeMaps({
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    if (Platform.isIOS) {
      // Try Apple Maps first on iOS
      final appleMapsUrl = 'https://maps.apple.com/?q=$latitude,$longitude';
      try {
        await _launchUrl(appleMapsUrl);
        return;
      } catch (e) {
        // Fall back to Google Maps
      }
    }

    // Use Google Maps as fallback
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    await _launchUrl(googleMapsUrl);
  }

  /// Helper method to launch URLs
  static Future<void> _launchUrl(String url) async {
    try {
      await SystemChannels.platform.invokeMethod(
        'SystemNavigator.pushNamed',
        url,
      );
    } catch (e) {
      // Fallback: try to open in browser
      await SystemChannels.platform.invokeMethod(
        'SystemNavigator.pushNamed',
        'https://www.google.com/maps',
      );
    }
  }
}
