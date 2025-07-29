class PromoCode {
  PromoCode({
    required this.id,
    required this.code,
    required this.description,
    required this.type,
    required this.value,
    required this.validFrom,
    required this.validUntil,
    required this.maxUses,
    required this.currentUses,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.applicablePlans,
    this.minimumSubscriptionMonths,
  });

  factory PromoCode.fromJson(Map<String, dynamic> json) => PromoCode(
        id: json['id'] as String,
        code: json['code'] as String,
        description: json['description'] as String,
        type: PromoCodeType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => PromoCodeType.freeTrial,
        ),
        value: (json['value'] as num).toDouble(),
        validFrom: DateTime.parse(json['validFrom'] as String),
        validUntil: DateTime.parse(json['validUntil'] as String),
        maxUses: json['maxUses'] as int,
        currentUses: json['currentUses'] as int,
        isActive: json['isActive'] as bool,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        applicablePlans: json['applicablePlans'] != null
            ? List<String>.from(json['applicablePlans'] as List)
            : null,
        minimumSubscriptionMonths: json['minimumSubscriptionMonths'] as int?,
      );
  final String id;
  final String code;
  final String description;
  final PromoCodeType type;
  final double value;
  final DateTime validFrom;
  final DateTime validUntil;
  final int maxUses;
  final int currentUses;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String>? applicablePlans;
  final int? minimumSubscriptionMonths;

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'description': description,
        'type': type.name,
        'value': value,
        'validFrom': validFrom.toIso8601String(),
        'validUntil': validUntil.toIso8601String(),
        'maxUses': maxUses,
        'currentUses': currentUses,
        'isActive': isActive,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'applicablePlans': applicablePlans,
        'minimumSubscriptionMonths': minimumSubscriptionMonths,
      };
}

enum PromoCodeType {
  percentage,
  fixedAmount,
  freeTrial,
}

extension PromoCodeTypeExtension on PromoCodeType {
  String get displayName {
    switch (this) {
      case PromoCodeType.percentage:
        return 'Percentage Discount';
      case PromoCodeType.fixedAmount:
        return 'Fixed Amount Discount';
      case PromoCodeType.freeTrial:
        return 'Free Trial';
    }
  }

  String get description {
    switch (this) {
      case PromoCodeType.percentage:
        return 'Discount as a percentage of the subscription price';
      case PromoCodeType.fixedAmount:
        return 'Fixed amount discount in euros';
      case PromoCodeType.freeTrial:
        return 'One month free trial';
    }
  }
}
