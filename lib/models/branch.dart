class Branch {
  final String id;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final bool isActive;

  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.isActive = true,
  });

  factory Branch.fromJson(Map<String, dynamic> json, String id) {
    return Branch(
      id: id,
      name: json['name'] ?? 'Branch',
      location: json['location'] ?? 'Unknown Location',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'isActive': isActive,
      };
}
