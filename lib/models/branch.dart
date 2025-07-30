class Branch {
  Branch({
    required this.id,
    required this.name,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.isActive = true,
  });

  factory Branch.fromJson(Map<String, dynamic> json, final String id) => Branch(
        id: id,
        name: json['name'] ?? 'Branch',
        location: json['location'] ?? 'Unknown Location',
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        isActive: json['isActive'] ?? true,
      );
  final String id;
  final String name;
  final String location;
  final double latitude;
  final double longitude;
  final bool isActive;

  Map<String, dynamic> toJson() => {
        'name': name,
        'location': location,
        'latitude': latitude,
        'longitude': longitude,
        'isActive': isActive,
      };
}
