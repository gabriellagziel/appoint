import 'package:flutter/material.dart';

class BusinessSubscription {

  BusinessSubscription({
    required this.id,
    required this.businessId,
    required this.customerId,
    required this.plan,
    required this.status,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.createdAt, 
    required this.updatedAt, 
    this.trialEnd,
    this.cancelAtPeriodEnd,
    this.stripeSubscriptionId,
    this.stripePriceId,
    this.promoCodeId,
    this.mapUsageCurrentPeriod = 0,
    this.mapOverageThisPeriod = 0,
  });

  factory BusinessSubscription.fromJson(Map<String, dynamic> json) => BusinessSubscription(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      customerId: json['customerId'] as String,
      plan: SubscriptionPlan.values.firstWhere(
        (e) => e.name == json['plan'],
        orElse: () => SubscriptionPlan.starter,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => SubscriptionStatus.inactive,
      ),
      currentPeriodStart: DateTime.parse(json['currentPeriodStart'] as String),
      currentPeriodEnd: DateTime.parse(json['currentPeriodEnd'] as String),
      trialEnd: json['trialEnd'] != null
          ? DateTime.parse(json['trialEnd'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as String?,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      stripePriceId: json['stripePriceId'] as String?,
      promoCodeId: json['promoCodeId'] as String?,
      mapUsageCurrentPeriod: (json['mapUsageCurrentPeriod'] as num?)?.toInt() ?? 0,
      mapOverageThisPeriod: (json['mapOverageThisPeriod'] as num?)?.toDouble() ?? 0.0,
    );
  final String id;
  final String businessId;
  final String customerId;
  final SubscriptionPlan plan;
  final SubscriptionStatus status;
  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final DateTime? trialEnd;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? cancelAtPeriodEnd;
  final String? stripeSubscriptionId;
  final String? stripePriceId;
  final String? promoCodeId;
  final int mapUsageCurrentPeriod;
  final double mapOverageThisPeriod;

  Map<String, dynamic> toJson() => {
      'id': id,
      'businessId': businessId,
      'customerId': customerId,
      'plan': plan.name,
      'status': status.name,
      'currentPeriodStart': currentPeriodStart.toIso8601String(),
      'currentPeriodEnd': currentPeriodEnd.toIso8601String(),
      'trialEnd': trialEnd?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'cancelAtPeriodEnd': cancelAtPeriodEnd,
      'stripeSubscriptionId': stripeSubscriptionId,
      'stripePriceId': stripePriceId,
      'promoCodeId': promoCodeId,
      'mapUsageCurrentPeriod': mapUsageCurrentPeriod,
      'mapOverageThisPeriod': mapOverageThisPeriod,
    };

  BusinessSubscription copyWith({
    String? id,
    String? businessId,
    String? customerId,
    SubscriptionPlan? plan,
    SubscriptionStatus? status,
    DateTime? currentPeriodStart,
    DateTime? currentPeriodEnd,
    DateTime? trialEnd,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? cancelAtPeriodEnd,
    String? stripeSubscriptionId,
    String? stripePriceId,
    String? promoCodeId,
    int? mapUsageCurrentPeriod,
    double? mapOverageThisPeriod,
  }) {
    return BusinessSubscription(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      customerId: customerId ?? this.customerId,
      plan: plan ?? this.plan,
      status: status ?? this.status,
      currentPeriodStart: currentPeriodStart ?? this.currentPeriodStart,
      currentPeriodEnd: currentPeriodEnd ?? this.currentPeriodEnd,
      trialEnd: trialEnd ?? this.trialEnd,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      cancelAtPeriodEnd: cancelAtPeriodEnd ?? this.cancelAtPeriodEnd,
      stripeSubscriptionId: stripeSubscriptionId ?? this.stripeSubscriptionId,
      stripePriceId: stripePriceId ?? this.stripePriceId,
      promoCodeId: promoCodeId ?? this.promoCodeId,
      mapUsageCurrentPeriod: mapUsageCurrentPeriod ?? this.mapUsageCurrentPeriod,
      mapOverageThisPeriod: mapOverageThisPeriod ?? this.mapOverageThisPeriod,
    );
  }
}

enum SubscriptionPlan {
  starter,
  professional,
  businessPlus,
}

enum SubscriptionStatus {
  active,
  pastDue,
  canceled,
  incomplete,
  incompleteExpired,
  trialing,
  unpaid,
  inactive,
}

extension SubscriptionPlanExtension on SubscriptionPlan {
  String get name {
    switch (this) {
      case SubscriptionPlan.starter:
        return 'Starter';
      case SubscriptionPlan.professional:
        return 'Professional';
      case SubscriptionPlan.businessPlus:
        return 'Business Plus';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionPlan.starter:
        return 'Unlimited meetings, no map access, basic calendar view, no branding';
      case SubscriptionPlan.professional:
        return 'Unlimited meetings, full branding, 200 map loads/month, analytics, CRM features';
      case SubscriptionPlan.businessPlus:
        return 'Everything in Professional plus 500 map loads/month, advanced analytics, priority support';
    }
  }

  double get price {
    switch (this) {
      case SubscriptionPlan.starter:
        return 0.00; // Free starter plan
      case SubscriptionPlan.professional:
        return 15.00;
      case SubscriptionPlan.businessPlus:
        return 25.00;
    }
  }

  String get priceDisplay => '€${price.toStringAsFixed(2)}/mo';

  int get meetingLimit {
    switch (this) {
      case SubscriptionPlan.starter:
      case SubscriptionPlan.professional:
      case SubscriptionPlan.businessPlus:
        return -1; // unlimited meetings for all business plans
    }
  }

  int get mapLimit {
    switch (this) {
      case SubscriptionPlan.starter:
        return 0; // No maps included
      case SubscriptionPlan.professional:
        return 200;
      case SubscriptionPlan.businessPlus:
        return 500;
    }
  }

  bool get brandingEnabled {
    switch (this) {
      case SubscriptionPlan.starter:
        return false;
      case SubscriptionPlan.professional:
      case SubscriptionPlan.businessPlus:
        return true;
    }
  }

  bool get hasAnalytics {
    switch (this) {
      case SubscriptionPlan.starter:
        return false;
      case SubscriptionPlan.professional:
        return true;
      case SubscriptionPlan.businessPlus:
        return true;
    }
  }

  bool get hasAdvancedAnalytics {
    switch (this) {
      case SubscriptionPlan.starter:
      case SubscriptionPlan.professional:
        return false;
      case SubscriptionPlan.businessPlus:
        return true;
    }
  }

  bool get hasPrioritySupport {
    switch (this) {
      case SubscriptionPlan.starter:
      case SubscriptionPlan.professional:
        return false;
      case SubscriptionPlan.businessPlus:
        return true;
    }
  }

  List<String> get features {
    switch (this) {
      case SubscriptionPlan.starter:
        return [
          'Unlimited meetings',
          'Daily calendar view',
          'Basic booking management',
          'No map access',
          'No branding',
          'Email support',
        ];
      case SubscriptionPlan.professional:
        return [
          'Unlimited meetings',
          'Full business branding',
          'Daily & monthly calendar views',
          '200 map loads/month included',
          'Map overage: €0.01 per extra load',
          '"My Clients" CRM list',
          'Analytics dashboard',
          'CSV export',
          'Email reminders',
          'Standard support',
        ];
      case SubscriptionPlan.businessPlus:
        return [
          'Everything in Professional',
          '500 map loads/month included',
          'Map overage: €0.01 per extra load',
          'Advanced analytics',
          'Excel export',
          'Priority support',
          'Preferred handling',
          'Custom integrations',
        ];
    }
  }

  String get stripePriceId {
    switch (this) {
      case SubscriptionPlan.starter:
        return 'price_starter_monthly';
      case SubscriptionPlan.professional:
        return 'price_professional_monthly';
      case SubscriptionPlan.businessPlus:
        return 'price_business_plus_monthly';
    }
  }

  Color get color {
    switch (this) {
      case SubscriptionPlan.starter:
        return Colors.grey;
      case SubscriptionPlan.professional:
        return Colors.blue;
      case SubscriptionPlan.businessPlus:
        return Colors.purple;
    }
  }

  bool get isRecommended => this == SubscriptionPlan.professional;
}

extension SubscriptionStatusExtension on SubscriptionStatus {
  String get displayName {
    switch (this) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.pastDue:
        return 'Past Due';
      case SubscriptionStatus.canceled:
        return 'Canceled';
      case SubscriptionStatus.incomplete:
        return 'Incomplete';
      case SubscriptionStatus.incompleteExpired:
        return 'Incomplete Expired';
      case SubscriptionStatus.trialing:
        return 'Trial';
      case SubscriptionStatus.unpaid:
        return 'Unpaid';
      case SubscriptionStatus.inactive:
        return 'Inactive';
    }
  }

  bool get isActive => this == SubscriptionStatus.active ||
        this == SubscriptionStatus.trialing;

  Color get color {
    switch (this) {
      case SubscriptionStatus.active:
      case SubscriptionStatus.trialing:
        return Colors.green;
      case SubscriptionStatus.pastDue:
      case SubscriptionStatus.unpaid:
        return Colors.orange;
      case SubscriptionStatus.canceled:
      case SubscriptionStatus.incomplete:
      case SubscriptionStatus.incompleteExpired:
      case SubscriptionStatus.inactive:
        return Colors.red;
    }
  }
}

// Map usage constants
class MapUsageConstants {
  static const double systemCostPerLoad = 0.007; // €0.007 per map load
  static const double overageRatePerLoad = 0.01;  // €0.01 per extra load
}
