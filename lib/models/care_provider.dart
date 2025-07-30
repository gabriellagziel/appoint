class CareProvider {
  CareProvider({
    required this.id,
    required this.name,
    required this.specialty,
    required this.contactInfo,
  });

  factory CareProvider.fromJson(Map<String, dynamic> json) => CareProvider(
        id: json['id'] as String,
        name: json['name'] as String,
        specialty: json['specialty'] as String,
        contactInfo: json['contactInfo'] as String,
      );
  final String id;
  final String name;
  final String specialty;
  final String contactInfo;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'contactInfo': contactInfo,
      };

  CareProvider copyWith({
    final String? id,
    final String? name,
    final String? specialty,
    final String? contactInfo,
  }) =>
      CareProvider(
        id: id ?? this.id,
        name: name ?? this.name,
        specialty: specialty ?? this.specialty,
        contactInfo: contactInfo ?? this.contactInfo,
      );
}
