import 'package:appoint/features/studio_business/models/business_subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Business Subscription Models', () {
    test('SubscriptionPlan extensions work correctly', () {
      expect(SubscriptionPlan.basic.name, equals('Basic'));
      expect(SubscriptionPlan.pro.name, equals('Pro'));

      expect(SubscriptionPlan.basic.price, equals(4.99));
      expect(SubscriptionPlan.pro.price, equals(14.99));

      expect(SubscriptionPlan.basic.priceDisplay, equals('€4.99/mo'));
      expect(SubscriptionPlan.pro.priceDisplay, equals('€14.99/mo'));

      expect(SubscriptionPlan.basic.meetingLimit, equals(20));
      expect(SubscriptionPlan.pro.meetingLimit, equals(-1)); // unlimited

      expect(SubscriptionPlan.basic.features.length, equals(3));
      expect(SubscriptionPlan.pro.features.length, equals(7));
    });

    test('SubscriptionStatus extensions work correctly', () {
      expect(SubscriptionStatus.active.displayName, equals('Active'));
      expect(SubscriptionStatus.trialing.displayName, equals('Trial'));
      expect(SubscriptionStatus.canceled.displayName, equals('Canceled'));

      expect(SubscriptionStatus.active.isActive, isTrue);
      expect(SubscriptionStatus.trialing.isActive, isTrue);
      expect(SubscriptionStatus.canceled.isActive, isFalse);

      expect(SubscriptionStatus.active.color, equals(Colors.green));
      expect(SubscriptionStatus.pastDue.color, equals(Colors.orange));
      expect(SubscriptionStatus.canceled.color, equals(Colors.red));
    });

    test('BusinessSubscription can be created', () {
      final subscription = BusinessSubscription(
        id: 'test-id',
        businessId: 'business-123',
        customerId: 'customer-456',
        plan: SubscriptionPlan.pro,
        status: SubscriptionStatus.active,
        currentPeriodStart: DateTime.now(),
        currentPeriodEnd: DateTime.now().add(const Duration(days: 30)),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      expect(subscription.id, equals('test-id'));
      expect(subscription.plan, equals(SubscriptionPlan.pro));
      expect(subscription.status, equals(SubscriptionStatus.active));
      expect(subscription.status.isActive, isTrue);
    });
  });
}
