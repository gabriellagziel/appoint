import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralCode {
  ReferralCode({
    required this.userId,
    required this.code,
    required this.createdAt,
  });

  factory ReferralCode.fromMap(Map<String, dynamic> map) => ReferralCode(
        userId: map['userId'] as String,
        code: map['code'] as String,
        createdAt: (map['createdAt'] as Timestamp).toDate(),
      );
  final String userId;
  final String code;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => {
        'userId': userId,
        'code': code,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
