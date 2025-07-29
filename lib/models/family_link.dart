class FamilyLink {
  FamilyLink({
    required this.id,
    required this.parentId,
    required this.childId,
    required this.status,
    required this.invitedAt,
    required this.consentedAt,
  });

  factory FamilyLink.fromJson(Map<String, dynamic> json) => FamilyLink(
        id: json['id'],
        parentId: json['parentId'],
        childId: json['childId'],
        status: json['status'],
        invitedAt: DateTime.parse(json['invitedAt']),
        consentedAt: (json['consentedAt'] as List).map(DateTime.parse).toList(),
      );
  final String id;
  final String parentId;
  final String childId;
  final String status; // "pending" | "active" | "revoked"
  final DateTime invitedAt;
  final List<DateTime> consentedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'parentId': parentId,
        'childId': childId,
        'status': status,
        'invitedAt': invitedAt.toIso8601String(),
        'consentedAt': consentedAt.map((d) => d.toIso8601String()).toList(),
      };
}
