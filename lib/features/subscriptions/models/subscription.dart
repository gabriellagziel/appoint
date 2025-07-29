import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart';

@JsonSerializable()
class SubscriptionPlan {
  const SubscriptionPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.interval,
    required this.features,
    this.isPopular = false,
    this.isRecommended = false,
    this.discountPercentage,
    this.originalPrice,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPlanFromJson(json);

  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final SubscriptionInterval interval;
  final List<String> features;
  final bool isPopular;
  final bool isRecommended;
  final double? discountPercentage;
  final double? originalPrice;

  Map<String, dynamic> toJson() => _$SubscriptionPlanToJson(this);

  double get displayPrice => originalPrice ?? price;
  bool get hasDiscount => originalPrice != null && originalPrice! > price;
}

@JsonSerializable()
class Subscription {
  const Subscription({
    required this.id,
    required this.userId,
    required this.planId,
    required this.status,
    required this.startDate,
    required this.endDate,
    this.cancelAtPeriodEnd = false,
    this.canceledAt,
    this.stripeSubscriptionId,
    this.stripeCustomerId,
    this.metadata,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  final String id;
  final String userId;
  final String planId;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final bool cancelAtPeriodEnd;
  final DateTime? canceledAt;
  final String? stripeSubscriptionId;
  final String? stripeCustomerId;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);

  bool get isActive => status == SubscriptionStatus.active;
  bool get isExpired => DateTime.now().isAfter(endDate);
  bool get willCancel => cancelAtPeriodEnd;
}

@JsonSerializable()
class Payment {
  const Payment({
    required this.id,
    required this.userId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.subscriptionId,
    this.stripePaymentIntentId,
    this.stripeChargeId,
    this.description,
    this.metadata,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  final String id;
  final String userId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final DateTime createdAt;
  final String? subscriptionId;
  final String? stripePaymentIntentId;
  final String? stripeChargeId;
  final String? description;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class UserSubscription {
  const UserSubscription({
    required this.userId,
    required this.currentPlan,
    this.activeSubscription,
    this.paymentMethods,
    this.billingHistory,
    this.usageStats,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) =>
      _$UserSubscriptionFromJson(json);

  final String userId;
  final SubscriptionPlan currentPlan;
  final Subscription? activeSubscription;
  final List<PaymentMethod> paymentMethods;
  final List<Payment> billingHistory;
  final UsageStats usageStats;

  Map<String, dynamic> toJson() => _$UserSubscriptionToJson(this);
}

@JsonSerializable()
class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    required this.expMonth,
    required this.expYear,
    this.isDefault = false,
    this.stripePaymentMethodId,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);

  final String id;
  final PaymentMethodType type;
  final String last4;
  final String brand;
  final int expMonth;
  final int expYear;
  final bool isDefault;
  final String? stripePaymentMethodId;

  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);
}

@JsonSerializable()
class UsageStats {
  const UsageStats({
    required this.bookingsThisMonth,
    required this.bookingsLimit,
    required this.messagesThisMonth,
    required this.messagesLimit,
    required this.storageUsed,
    required this.storageLimit,
  });

  factory UsageStats.fromJson(Map<String, dynamic> json) =>
      _$UsageStatsFromJson(json);

  final int bookingsThisMonth;
  final int bookingsLimit;
  final int messagesThisMonth;
  final int messagesLimit;
  final double storageUsed; // in MB
  final double storageLimit; // in MB

  Map<String, dynamic> toJson() => _$UsageStatsToJson(this);

  double get bookingsUsagePercentage =>
      (bookingsThisMonth / bookingsLimit) * 100;
  double get messagesUsagePercentage =>
      (messagesThisMonth / messagesLimit) * 100;
  double get storageUsagePercentage => (storageUsed / storageLimit) * 100;
}

enum SubscriptionInterval {
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
  @JsonValue('weekly')
  weekly,
}

enum SubscriptionStatus {
  @JsonValue('active')
  active,
  @JsonValue('canceled')
  canceled,
  @JsonValue('past_due')
  pastDue,
  @JsonValue('unpaid')
  unpaid,
  @JsonValue('trialing')
  trialing,
}

enum PaymentStatus {
  @JsonValue('succeeded')
  succeeded,
  @JsonValue('pending')
  pending,
  @JsonValue('failed')
  failed,
  @JsonValue('canceled')
  canceled,
  @JsonValue('refunded')
  refunded,
}

enum PaymentMethodType {
  @JsonValue('card')
  card,
  @JsonValue('bank_account')
  bankAccount,
  @JsonValue('paypal')
  paypal,
}
