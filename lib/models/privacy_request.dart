class PrivacyRequest {
  PrivacyRequest({
    required this.id,
    required this.childId,
    required this.type,
    required this.status,
    required this.requestedAt,
  });

  factory PrivacyRequest.fromJson(Map<String, dynamic> json) => PrivacyRequest(
        id: json['id'],
        childId: json['childId'],
        type: json['type'],
        status: json['status'],
        requestedAt: DateTime.parse(json['requestedAt']),
      );
  final String id;
  final String childId;
  final String type; // "private_session"
  final String status; // "pending"|"approved"|"denied"
  final DateTime requestedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'childId': childId,
        'type': type,
        'status': status,
        'requestedAt': requestedAt.toIso8601String(),
      };
}
