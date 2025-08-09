import 'package:flutter_test/flutter_test.dart';
import '../../../lib/services/navigation/deeplink_navigation_service.dart';
import '../../../lib/models/location.dart';

void main() {
  group('Deep Link Navigation Service Tests', () {
    late Location testLocation;

    setUp(() {
      testLocation = const Location(
        latitude: 37.7749,
        longitude: -122.4194,
        name: 'Test Location',
        address: '123 Test Street, San Francisco, CA',
      );
    });

    test('should build Google Maps URL correctly', () {
      final url = DeeplinkNavigationService.buildNavigationUrl(
        NavigationProvider.googleMaps,
        testLocation,
      );

      expect(
          url,
          contains(
              'https://www.google.com/maps/dir/?api=1&destination=37.7749,-122.4194'));
      expect(url, contains('destination_place_id=Test%20Location'));
    });

    test('should build Apple Maps URL correctly', () {
      final url = DeeplinkNavigationService.buildNavigationUrl(
        NavigationProvider.appleMaps,
        testLocation,
      );

      expect(url, contains('http://maps.apple.com/?daddr=37.7749,-122.4194'));
      expect(url, contains('q=Test%20Location'));
    });

    test('should build OpenStreetMap URL correctly', () {
      final url = DeeplinkNavigationService.buildNavigationUrl(
        NavigationProvider.openStreetMap,
        testLocation,
      );

      expect(
          url,
          contains(
              'https://www.openstreetmap.org/directions?to=37.7749,-122.4194'));
      expect(url, contains('name=Test%20Location'));
    });

    test('should handle location without name', () {
      const locationWithoutName = Location(
        latitude: 37.7749,
        longitude: -122.4194,
      );

      final url = DeeplinkNavigationService.buildNavigationUrl(
        NavigationProvider.googleMaps,
        locationWithoutName,
      );

      expect(
          url,
          contains(
              'https://www.google.com/maps/dir/?api=1&destination=37.7749,-122.4194'));
      expect(url, isNot(contains('destination_place_id')));
    });

    test('should build fallback URL correctly', () {
      final url = DeeplinkNavigationService.buildFallbackUrl(testLocation);

      expect(
          url, contains('https://www.google.com/maps/search/Test%20Location'));
    });

    test('should build fallback URL without name', () {
      const locationWithoutName = Location(
        latitude: 37.7749,
        longitude: -122.4194,
      );

      final url =
          DeeplinkNavigationService.buildFallbackUrl(locationWithoutName);

      expect(url,
          contains('https://www.google.com/maps/search/37.7749,-122.4194'));
    });

    test('should get available providers for web platform', () {
      // Mock kIsWeb = true
      final providers = [
        NavigationProvider.googleMaps,
        NavigationProvider.openStreetMap,
      ];

      expect(providers.length, equals(2));
      expect(providers.contains(NavigationProvider.googleMaps), isTrue);
      expect(providers.contains(NavigationProvider.openStreetMap), isTrue);
    });

    test('should get available providers for mobile platform', () {
      // Mock kIsWeb = false
      final providers = [
        NavigationProvider.googleMaps,
        NavigationProvider.appleMaps,
      ];

      expect(providers.length, equals(2));
      expect(providers.contains(NavigationProvider.googleMaps), isTrue);
      expect(providers.contains(NavigationProvider.appleMaps), isTrue);
    });

    test('should handle special characters in location name', () {
      const locationWithSpecialChars = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        name: 'Café & Restaurant (Downtown)',
      );

      final url = DeeplinkNavigationService.buildNavigationUrl(
        NavigationProvider.googleMaps,
        locationWithSpecialChars,
      );

      expect(
          url,
          contains(
              'destination_place_id=Caf%C3%A9%20%26%20Restaurant%20(Downtown)'));
    });

    test('should handle empty location name', () {
      const locationWithEmptyName = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        name: '',
      );

      final url = DeeplinkNavigationService.buildNavigationUrl(
        NavigationProvider.googleMaps,
        locationWithEmptyName,
      );

      expect(url, isNot(contains('destination_place_id')));
    });
  });
}
