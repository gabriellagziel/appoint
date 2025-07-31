/// Payment model for payment API service
class Payment {
  final String id;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final PaymentMethod method;
  final DateTime createdAt;
  final String? transactionId;
  final String? description;
  
  Payment({
    required this.id,
    required this.userId,
    required this.amount,
    this.currency = 'USD',
    required this.status,
    required this.method,
    required this.createdAt,
    this.transactionId,
    this.description,
  });
  
  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      method: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['method']}',
        orElse: () => PaymentMethod.card,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      transactionId: json['transactionId'] as String?,
      description: json['description'] as String?,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'amount': amount,
      'currency': currency,
      'status': status.toString().split('.').last,
      'method': method.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
      'transactionId': transactionId,
      'description': description,
    };
  }
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  canceled,
  refunded,
}

enum PaymentMethod {
  card,
  paypal,
  stripe,
  applePay,
  googlePay,
}