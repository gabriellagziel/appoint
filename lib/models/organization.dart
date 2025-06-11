class Organization {
  final String id;
  final String name;
  final List<String> memberIds;

  Organization({
    required this.id,
    required this.name,
    required this.memberIds,
  });

  factory Organization.fromMap(Map<String, dynamic> map, String id) {
    return Organization(
      id: id,
      name: map['name'] as String? ?? '',
      memberIds: (map['memberIds'] as List<dynamic>? ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'memberIds': memberIds,
    };
  }
}
