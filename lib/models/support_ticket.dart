import 'package:appoint/utils/datetime_converter.dart';

class SupportTicket {
  SupportTicket({
    required this.id,
    required this.userId,
    required this.subject,
    required this.message,
    required this.createdAt,
    this.status = 'open',
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) => SupportTicket(
        id: json['id'] as String,
        userId: json['userId'] as String,
        subject: json['subject'] as String,
        message: json['message'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: json['status'] as String? ?? 'open',
      );
  final String id;
  final String userId;
  final String subject;
  final String message;
  @DateTimeConverter()
  final DateTime createdAt;
  final String status;

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'subject': subject,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };
}
