/// Subscription model for payment API service
class Subscription {
  final String id;
  final String userId;
  final String planId;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? canceledAt;
  final double amount;
  final String currency;
  
  Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    this.endDate,
    this.canceledAt,
    required this.amount,
    this.currency = 'USD',
  });
  
  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      planId: json['planId'] as String,
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.toString() == 'SubscriptionStatus.${json['status']}',
        orElse: () => SubscriptionStatus.inactive,
      ),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate'] as String) : null,
      canceledAt: json['canceledAt'] != null ? DateTime.parse(json['canceledAt'] as String) : null,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'planId': planId,
      'status': status.toString().split('.').last,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'canceledAt': canceledAt?.toIso8601String(),
      'amount': amount,
      'currency': currency,
    };
  }
}

enum SubscriptionStatus {
  active,
  inactive,
  canceled,
  expired,
  trial,
}