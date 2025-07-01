import 'package:cloud_firestore/cloud_firestore.dart';

class ReferralCode {
  final String userId;
  final String code;
  final DateTime createdAt;

  ReferralCode({
    required this.userId,
    required this.code,
    required this.createdAt,
  });

  factory ReferralCode.fromMap(final Map<String, dynamic> map) {
    return ReferralCode(
      userId: map['userId'] as String,
      code: map['code'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'code': code,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
