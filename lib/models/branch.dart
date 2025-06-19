class Branch {
  final String id;
  final String name;
  final double latitude;
  final double longitude;

  Branch({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Branch.fromJson(Map<String, dynamic> json, String id) {
    return Branch(
      id: id,
      name: json['name'] ?? 'Branch',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
      };
}
