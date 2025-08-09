import 'package:cloud_firestore/cloud_firestore.dart';

enum AdImpressionType {
  meeting,
  reminder,
}

enum AdImpressionStatus {
  shown,
  completed,
  skipped,
  closed,
}

class AdImpression {
  final String id;
  final AdImpressionType type;
  final AdImpressionStatus status;
  final DateTime timestamp;
  final String userId;
  final bool isPremium;

  const AdImpression({
    required this.id,
    required this.type,
    required this.status,
    required this.timestamp,
    required this.userId,
    required this.isPremium,
  });

  factory AdImpression.fromMap(String id, Map<String, dynamic> data) {
    return AdImpression(
      id: id,
      type: AdImpressionType.values.firstWhere(
        (e) => e.name == data['type'],
        orElse: () => AdImpressionType.meeting,
      ),
      status: AdImpressionStatus.values.firstWhere(
        (e) => e.name == data['status'],
        orElse: () => AdImpressionStatus.shown,
      ),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      isPremium: data['isPremium'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type.name,
      'status': status.name,
      'timestamp': Timestamp.fromDate(timestamp),
      'userId': userId,
      'isPremium': isPremium,
    };
  }

  AdImpression copyWith({
    String? id,
    AdImpressionType? type,
    AdImpressionStatus? status,
    DateTime? timestamp,
    String? userId,
    bool? isPremium,
  }) {
    return AdImpression(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      isPremium: isPremium ?? this.isPremium,
    );
  }
}



