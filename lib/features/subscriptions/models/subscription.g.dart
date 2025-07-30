// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionPlan _$SubscriptionPlanFromJson(Map<String, dynamic> json) =>
    SubscriptionPlan(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
      interval: $enumDecode(_$SubscriptionIntervalEnumMap, json['interval']),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      isPopular: json['is_popular'] as bool? ?? false,
      isRecommended: json['is_recommended'] as bool? ?? false,
      discountPercentage: (json['discount_percentage'] as num?)?.toDouble(),
      originalPrice: (json['original_price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SubscriptionPlanToJson(SubscriptionPlan instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
    'description': instance.description,
    'price': instance.price,
    'currency': instance.currency,
    'interval': _$SubscriptionIntervalEnumMap[instance.interval]!,
    'features': instance.features,
    'is_popular': instance.isPopular,
    'is_recommended': instance.isRecommended,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('discount_percentage', instance.discountPercentage);
  writeNotNull('original_price', instance.originalPrice);
  return val;
}

const _$SubscriptionIntervalEnumMap = {
  SubscriptionInterval.monthly: 'monthly',
  SubscriptionInterval.yearly: 'yearly',
  SubscriptionInterval.weekly: 'weekly',
};

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      planId: json['plan_id'] as String,
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      cancelAtPeriodEnd: json['cancel_at_period_end'] as bool? ?? false,
      canceledAt: json['canceled_at'] == null
          ? null
          : DateTime.parse(json['canceled_at'] as String),
      stripeSubscriptionId: json['stripe_subscription_id'] as String?,
      stripeCustomerId: json['stripe_customer_id'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'user_id': instance.userId,
    'plan_id': instance.planId,
    'status': _$SubscriptionStatusEnumMap[instance.status]!,
    'start_date': instance.startDate.toIso8601String(),
    'end_date': instance.endDate.toIso8601String(),
    'cancel_at_period_end': instance.cancelAtPeriodEnd,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('canceled_at', instance.canceledAt?.toIso8601String());
  writeNotNull('stripe_subscription_id', instance.stripeSubscriptionId);
  writeNotNull('stripe_customer_id', instance.stripeCustomerId);
  writeNotNull('metadata', instance.metadata);
  return val;
}

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.canceled: 'canceled',
  SubscriptionStatus.pastDue: 'past_due',
  SubscriptionStatus.unpaid: 'unpaid',
  SubscriptionStatus.trialing: 'trialing',
};

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: $enumDecode(_$PaymentStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      subscriptionId: json['subscription_id'] as String?,
      stripePaymentIntentId: json['stripe_payment_intent_id'] as String?,
      stripeChargeId: json['stripe_charge_id'] as String?,
      description: json['description'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'user_id': instance.userId,
    'amount': instance.amount,
    'currency': instance.currency,
    'status': _$PaymentStatusEnumMap[instance.status]!,
    'created_at': instance.createdAt.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('subscription_id', instance.subscriptionId);
  writeNotNull('stripe_payment_intent_id', instance.stripePaymentIntentId);
  writeNotNull('stripe_charge_id', instance.stripeChargeId);
  writeNotNull('description', instance.description);
  writeNotNull('metadata', instance.metadata);
  return val;
}

const _$PaymentStatusEnumMap = {
  PaymentStatus.succeeded: 'succeeded',
  PaymentStatus.pending: 'pending',
  PaymentStatus.failed: 'failed',
  PaymentStatus.canceled: 'canceled',
  PaymentStatus.refunded: 'refunded',
};

UserSubscription _$UserSubscriptionFromJson(Map<String, dynamic> json) =>
    UserSubscription(
      userId: json['user_id'] as String,
      currentPlan: SubscriptionPlan.fromJson(
          json['current_plan'] as Map<String, dynamic>),
      activeSubscription: json['active_subscription'] == null
          ? null
          : Subscription.fromJson(
              json['active_subscription'] as Map<String, dynamic>),
      paymentMethods: (json['payment_methods'] as List<dynamic>?)
              ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      billingHistory: (json['billing_history'] as List<dynamic>?)
              ?.map((e) => Payment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      usageStats: json['usage_stats'] == null
          ? const UsageStats(
              bookingsThisMonth: 0,
              bookingsLimit: 0,
              messagesThisMonth: 0,
              messagesLimit: 0,
              storageUsed: 0.0,
              storageLimit: 0.0)
          : UsageStats.fromJson(json['usage_stats'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserSubscriptionToJson(UserSubscription instance) {
  final val = <String, dynamic>{
    'user_id': instance.userId,
    'current_plan': instance.currentPlan,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('active_subscription', instance.activeSubscription);
  val['payment_methods'] = instance.paymentMethods;
  val['billing_history'] = instance.billingHistory;
  val['usage_stats'] = instance.usageStats;
  return val;
}

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      id: json['id'] as String,
      type: $enumDecode(_$PaymentMethodTypeEnumMap, json['type']),
      last4: json['last4'] as String,
      brand: json['brand'] as String,
      expMonth: (json['exp_month'] as num).toInt(),
      expYear: (json['exp_year'] as num).toInt(),
      isDefault: json['is_default'] as bool? ?? false,
      stripePaymentMethodId: json['stripe_payment_method_id'] as String?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': _$PaymentMethodTypeEnumMap[instance.type]!,
    'last4': instance.last4,
    'brand': instance.brand,
    'exp_month': instance.expMonth,
    'exp_year': instance.expYear,
    'is_default': instance.isDefault,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('stripe_payment_method_id', instance.stripePaymentMethodId);
  return val;
}

const _$PaymentMethodTypeEnumMap = {
  PaymentMethodType.card: 'card',
  PaymentMethodType.bankAccount: 'bank_account',
  PaymentMethodType.paypal: 'paypal',
};

UsageStats _$UsageStatsFromJson(Map<String, dynamic> json) => UsageStats(
      bookingsThisMonth: (json['bookings_this_month'] as num).toInt(),
      bookingsLimit: (json['bookings_limit'] as num).toInt(),
      messagesThisMonth: (json['messages_this_month'] as num).toInt(),
      messagesLimit: (json['messages_limit'] as num).toInt(),
      storageUsed: (json['storage_used'] as num).toDouble(),
      storageLimit: (json['storage_limit'] as num).toDouble(),
    );

Map<String, dynamic> _$UsageStatsToJson(UsageStats instance) =>
    <String, dynamic>{
      'bookings_this_month': instance.bookingsThisMonth,
      'bookings_limit': instance.bookingsLimit,
      'messages_this_month': instance.messagesThisMonth,
      'messages_limit': instance.messagesLimit,
      'storage_used': instance.storageUsed,
      'storage_limit': instance.storageLimit,
    };
