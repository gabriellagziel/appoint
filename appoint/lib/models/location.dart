class Location {
  final double latitude;
  final double longitude;
  final String? name;
  final String? address;

  const Location({
    required this.latitude,
    required this.longitude,
    this.name,
    this.address,
  });

  factory Location.fromMap(Map<String, dynamic> data) {
    return Location(
      latitude: (data['latitude'] as num).toDouble(),
      longitude: (data['longitude'] as num).toDouble(),
      name: data['name'] as String?,
      address: data['address'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'address': address,
    };
  }

  Location copyWith({
    double? latitude,
    double? longitude,
    String? name,
    String? address,
  }) {
    return Location(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  @override
  String toString() {
    return 'Location(lat: $latitude, lng: $longitude, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.name == name &&
        other.address == address;
  }

  @override
  int get hashCode {
    return Object.hash(latitude, longitude, name, address);
  }
}
