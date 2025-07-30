class Invoice {
  Invoice({
    required this.id,
    required this.businessId,
    required this.subscriptionId,
    required this.customerId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
    this.stripeInvoiceId,
    this.stripePaymentIntentId,
    this.description,
    this.metadata,
    this.promoCodeId,
    this.discountAmount,
    this.taxAmount,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'] as String,
        businessId: json['businessId'] as String,
        subscriptionId: json['subscriptionId'] as String,
        customerId: json['customerId'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        status: InvoiceStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => InvoiceStatus.draft,
        ),
        dueDate: DateTime.parse(json['dueDate'] as String),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        stripeInvoiceId: json['stripeInvoiceId'] as String?,
        stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
        description: json['description'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>?,
        promoCodeId: json['promoCodeId'] as String?,
        discountAmount: json['discountAmount'] != null
            ? (json['discountAmount'] as num).toDouble()
            : null,
        taxAmount: json['taxAmount'] != null
            ? (json['taxAmount'] as num).toDouble()
            : null,
      );
  final String id;
  final String businessId;
  final String subscriptionId;
  final String customerId;
  final double amount;
  final String currency;
  final InvoiceStatus status;
  final DateTime dueDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? stripeInvoiceId;
  final String? stripePaymentIntentId;
  final String? description;
  final Map<String, dynamic>? metadata;
  final String? promoCodeId;
  final double? discountAmount;
  final double? taxAmount;

  Map<String, dynamic> toJson() => {
        'id': id,
        'businessId': businessId,
        'subscriptionId': subscriptionId,
        'customerId': customerId,
        'amount': amount,
        'currency': currency,
        'status': status.name,
        'dueDate': dueDate.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'stripeInvoiceId': stripeInvoiceId,
        'stripePaymentIntentId': stripePaymentIntentId,
        'description': description,
        'metadata': metadata,
        'promoCodeId': promoCodeId,
        'discountAmount': discountAmount,
        'taxAmount': taxAmount,
      };
}

enum InvoiceStatus {
  draft,
  open,
  paid,
  voided,
  uncollectible,
}

extension InvoiceStatusExtension on InvoiceStatus {
  String get displayName {
    switch (this) {
      case InvoiceStatus.draft:
        return 'Draft';
      case InvoiceStatus.open:
        return 'Open';
      case InvoiceStatus.paid:
        return 'Paid';
      case InvoiceStatus.voided:
        return 'Void';
      case InvoiceStatus.uncollectible:
        return 'Uncollectible';
    }
  }

  bool get isPaid => this == InvoiceStatus.paid;

  bool get isOverdue => this == InvoiceStatus.open;
}
