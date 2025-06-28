class CareProvider {
  final String id;
  final String name;
  final String specialty;
  final String contactInfo;

  CareProvider({
    required this.id,
    required this.name,
    required this.specialty,
    required this.contactInfo,
  });

  factory CareProvider.fromJson(Map<String, dynamic> json) {
    return CareProvider(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      contactInfo: json['contactInfo'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'contactInfo': contactInfo,
      };

  CareProvider copyWith({
    String? id,
    String? name,
    String? specialty,
    String? contactInfo,
  }) {
    return CareProvider(
      id: id ?? this.id,
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      contactInfo: contactInfo ?? this.contactInfo,
    );
  }
}
