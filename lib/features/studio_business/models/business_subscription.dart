import 'package:flutter/material.dart';

class BusinessSubscription {
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

  BusinessSubscription({
    required this.id,
    required this.businessId,
    required this.customerId,
    required this.plan,
    required this.status,
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    this.trialEnd,
    required this.createdAt,
    required this.updatedAt,
    this.cancelAtPeriodEnd,
    this.stripeSubscriptionId,
    this.stripePriceId,
    this.promoCodeId,
  });

  factory BusinessSubscription.fromJson(final Map<String, dynamic> json) {
    return BusinessSubscription(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      customerId: json['customerId'] as String,
      plan: SubscriptionPlan.values.firstWhere(
        (final e) => e.name == json['plan'],
        orElse: () => SubscriptionPlan.basic,
      ),
      status: SubscriptionStatus.values.firstWhere(
        (final e) => e.name == json['status'],
        orElse: () => SubscriptionStatus.inactive,
      ),
      currentPeriodStart: DateTime.parse(json['currentPeriodStart'] as String),
      currentPeriodEnd: DateTime.parse(json['currentPeriodEnd'] as String),
      trialEnd: json['trialEnd'] != null ? DateTime.parse(json['trialEnd'] as String) : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as String?,
      stripeSubscriptionId: json['stripeSubscriptionId'] as String?,
      stripePriceId: json['stripePriceId'] as String?,
      promoCodeId: json['promoCodeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
    };
  }
}

enum SubscriptionPlan {
  basic,
  pro,
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
      case SubscriptionPlan.basic:
        return 'Basic';
      case SubscriptionPlan.pro:
        return 'Pro';
    }
  }

  String get description {
    switch (this) {
      case SubscriptionPlan.basic:
        return 'Up to 20 meetings, daily calendar view only, no analytics';
      case SubscriptionPlan.pro:
        return 'Unlimited meetings, daily+monthly calendar, "My Clients" list, analytics, CSV export, email reminders';
    }
  }

  double get price {
    switch (this) {
      case SubscriptionPlan.basic:
        return 4.99;
      case SubscriptionPlan.pro:
        return 14.99;
    }
  }

  String get priceDisplay {
    return '€${price.toStringAsFixed(2)}/mo';
  }

  int get meetingLimit {
    switch (this) {
      case SubscriptionPlan.basic:
        return 20;
      case SubscriptionPlan.pro:
        return -1; // unlimited
    }
  }

  List<String> get features {
    switch (this) {
      case SubscriptionPlan.basic:
        return [
          'Up to 20 meetings per month',
          'Daily calendar view',
          'Basic booking management',
        ];
      case SubscriptionPlan.pro:
        return [
          'Unlimited meetings',
          'Daily & monthly calendar views',
          '"My Clients" list',
          'Analytics dashboard',
          'CSV export',
          'Email reminders',
          'Priority support',
        ];
    }
  }
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

  bool get isActive {
    return this == SubscriptionStatus.active || this == SubscriptionStatus.trialing;
  }

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
