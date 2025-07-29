class Permission {
  // "none"|"read"|"write"

  Permission({
    required this.id,
    required this.familyLinkId,
    required this.category,
    required this.accessLevel,
  });

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: json['id'],
        familyLinkId: json['familyLinkId'],
        category: json['category'],
        accessLevel: json['accessLevel'],
      );
  final String id;
  final String familyLinkId;
  final String category; // e.g. "profile","activity","messages"
  final String accessLevel;

  Map<String, dynamic> toJson() => {
        'id': id,
        'familyLinkId': familyLinkId,
        'category': category,
        'accessLevel': accessLevel,
      };
}
