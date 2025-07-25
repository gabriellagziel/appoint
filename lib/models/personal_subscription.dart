import 'package:flutter/material.dart';

class PersonalSubscription {
  PersonalSubscription({
    required this.id,
    required this.userId,
    required this.freeMeetingsUsed,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.subscriptionEnd,
    this.weeklyMeetingsUsed = 0,
    this.lastWeekReset,
    this.isMinor = false,
    this.guardianUserId,
    this.appStoreSubscriptionId,
    this.googlePlaySubscriptionId,
  });

  factory PersonalSubscription.fromJson(Map<String, dynamic> json) => PersonalSubscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      freeMeetingsUsed: (json['freeMeetingsUsed'] as num?)?.toInt() ?? 0,
      status: PersonalSubscriptionStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => PersonalSubscriptionStatus.free,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      subscriptionEnd: json['subscriptionEnd'] != null
          ? DateTime.parse(json['subscriptionEnd'] as String)
          : null,
      weeklyMeetingsUsed: (json['weeklyMeetingsUsed'] as num?)?.toInt() ?? 0,
      lastWeekReset: json['lastWeekReset'] != null
          ? DateTime.parse(json['lastWeekReset'] as String)
          : null,
      isMinor: json['isMinor'] as bool? ?? false,
      guardianUserId: json['guardianUserId'] as String?,
      appStoreSubscriptionId: json['appStoreSubscriptionId'] as String?,
      googlePlaySubscriptionId: json['googlePlaySubscriptionId'] as String?,
    );

  final String id;
  final String userId;
  final int freeMeetingsUsed;
  final PersonalSubscriptionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? subscriptionEnd;
  final int weeklyMeetingsUsed;
  final DateTime? lastWeekReset;
  final bool isMinor;
  final String? guardianUserId;
  final String? appStoreSubscriptionId;
  final String? googlePlaySubscriptionId;

  Map<String, dynamic> toJson() => {
      'id': id,
      'userId': userId,
      'freeMeetingsUsed': freeMeetingsUsed,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'subscriptionEnd': subscriptionEnd?.toIso8601String(),
      'weeklyMeetingsUsed': weeklyMeetingsUsed,
      'lastWeekReset': lastWeekReset?.toIso8601String(),
      'isMinor': isMinor,
      'guardianUserId': guardianUserId,
      'appStoreSubscriptionId': appStoreSubscriptionId,
      'googlePlaySubscriptionId': googlePlaySubscriptionId,
    };

  PersonalSubscription copyWith({
    String? id,
    String? userId,
    int? freeMeetingsUsed,
    PersonalSubscriptionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? subscriptionEnd,
    int? weeklyMeetingsUsed,
    DateTime? lastWeekReset,
    bool? isMinor,
    String? guardianUserId,
    String? appStoreSubscriptionId,
    String? googlePlaySubscriptionId,
  }) {
    return PersonalSubscription(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      freeMeetingsUsed: freeMeetingsUsed ?? this.freeMeetingsUsed,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      subscriptionEnd: subscriptionEnd ?? this.subscriptionEnd,
      weeklyMeetingsUsed: weeklyMeetingsUsed ?? this.weeklyMeetingsUsed,
      lastWeekReset: lastWeekReset ?? this.lastWeekReset,
      isMinor: isMinor ?? this.isMinor,
      guardianUserId: guardianUserId ?? this.guardianUserId,
      appStoreSubscriptionId: appStoreSubscriptionId ?? this.appStoreSubscriptionId,
      googlePlaySubscriptionId: googlePlaySubscriptionId ?? this.googlePlaySubscriptionId,
    );
  }
}

enum PersonalSubscriptionStatus {
  free,          // First 5 meetings with full features
  adSupported,   // After 5 meetings, ads but no maps
  premium,       // €4/month subscription with full features
  expired,       // Premium subscription expired
}

extension PersonalSubscriptionStatusExtension on PersonalSubscriptionStatus {
  String get displayName {
    switch (this) {
      case PersonalSubscriptionStatus.free:
        return 'Free Trial';
      case PersonalSubscriptionStatus.adSupported:
        return 'Ad-Supported';
      case PersonalSubscriptionStatus.premium:
        return 'Premium';
      case PersonalSubscriptionStatus.expired:
        return 'Expired';
    }
  }

  bool get hasMapAccess {
    switch (this) {
      case PersonalSubscriptionStatus.free:
      case PersonalSubscriptionStatus.premium:
        return true;
      case PersonalSubscriptionStatus.adSupported:
      case PersonalSubscriptionStatus.expired:
        return false;
    }
  }

  bool get showAds {
    switch (this) {
      case PersonalSubscriptionStatus.adSupported:
      case PersonalSubscriptionStatus.expired:
        return true;
      case PersonalSubscriptionStatus.free:
      case PersonalSubscriptionStatus.premium:
        return false;
    }
  }

  Color get color {
    switch (this) {
      case PersonalSubscriptionStatus.free:
        return Colors.green;
      case PersonalSubscriptionStatus.adSupported:
        return Colors.orange;
      case PersonalSubscriptionStatus.premium:
        return Colors.blue;
      case PersonalSubscriptionStatus.expired:
        return Colors.red;
    }
  }
}

// Personal subscription constants
class PersonalSubscriptionConstants {
  static const int maxFreeMeetings = 5;
  static const int maxWeeklyMeetingsForPremium = 20;
  static const double monthlyPriceEur = 4.0;
  
  static const String appStoreProductId = 'app_oint_premium_monthly';
  static const String googlePlayProductId = 'app_oint_premium_monthly';
}