import 'dart:math' as math;

class Location {
  final String placeId;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final String? phone;
  final String? hours;

  const Location({
    required this.placeId,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    this.phone,
    this.hours,
  });

  Map<String, dynamic> toMap() {
    return {
      'placeId': placeId,
      'name': name,
      'address': address,
      'lat': lat,
      'lng': lng,
      'phone': phone,
      'hours': hours,
    };
  }

  factory Location.fromMap(Map<String, dynamic> data) {
    return Location(
      placeId: data['placeId'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      phone: data['phone'],
      hours: data['hours'],
    );
  }
}

class MapSearchService {
  // Mock search results
  static final List<Location> _mockLocations = [
    const Location(
      placeId: '1',
      name: 'Central Park',
      address: 'Central Park, New York, NY',
      lat: 40.7829,
      lng: -73.9654,
    ),
    const Location(
      placeId: '2',
      name: 'Times Square',
      address: 'Times Square, New York, NY',
      lat: 40.7580,
      lng: -73.9855,
    ),
    const Location(
      placeId: '3',
      name: 'Brooklyn Bridge',
      address: 'Brooklyn Bridge, New York, NY',
      lat: 40.7061,
      lng: -73.9969,
    ),
    const Location(
      placeId: '4',
      name: 'Empire State Building',
      address: '350 5th Ave, New York, NY',
      lat: 40.7484,
      lng: -73.9857,
      phone: '+1-212-736-3100',
    ),
    const Location(
      placeId: '5',
      name: 'Statue of Liberty',
      address: 'Liberty Island, New York, NY',
      lat: 40.6892,
      lng: -74.0445,
    ),
  ];

  // Search for locations
  static Future<List<Location>> searchLocations(String query) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();
    return _mockLocations.where((location) {
      return location.name.toLowerCase().contains(lowercaseQuery) ||
          location.address.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Get location details
  static Future<Location?> getLocationDetails(String placeId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      return _mockLocations
          .firstWhere((location) => location.placeId == placeId);
    } catch (e) {
      return null;
    }
  }

  // Get nearby locations
  static Future<List<Location>> getNearbyLocations(double lat, double lng,
      {double radius = 5000}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // Simple distance calculation (in real app, use proper geolocation)
    return _mockLocations.where((location) {
      final distance = _calculateDistance(lat, lng, location.lat, location.lng);
      return distance <= radius;
    }).toList();
  }

  // Calculate distance between two points (Haversine formula)
  static double _calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371000; // meters

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        (math.sin(lat1Rad) *
            math.sin(lat2Rad) *
            math.sin(dLng / 2) *
            math.sin(dLng / 2));
    final c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }
}
