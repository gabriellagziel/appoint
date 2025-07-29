import 'package:appoint/models/payment.dart';
import 'package:appoint/models/subscription.dart';
import 'package:appoint/services/api/api_client.dart';

class PaymentApiService {
  PaymentApiService._();
  static final PaymentApiService _instance = PaymentApiService._();
  static PaymentApiService get instance => _instance;

  // Get available subscription plans
  Future<List<SubscriptionPlan>> getSubscriptionPlans() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/subscriptions/plans',
      );

      final plans = response['plans'] as List;
      return plans.map(SubscriptionPlan.fromJson).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get current subscription
  Future<Subscription?> getCurrentSubscription() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/subscriptions/current',
      );

      if (response['subscription'] == null) {
        return null;
      }

      return Subscription.fromJson(response['subscription']);
    } catch (e) {
      rethrow;
    }
  }

  // Subscribe to a plan
  Future<Subscription> subscribeToPlan({
    required String planId,
    required String paymentMethodId,
    bool? autoRenew,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/subscriptions',
        data: {
          'planId': planId,
          'paymentMethodId': paymentMethodId,
          if (autoRenew != null) 'autoRenew': autoRenew,
        },
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Cancel subscription
  Future<void> cancelSubscription({
    String? reason,
    bool? immediate,
  }) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/subscriptions/cancel',
        data: {
          if (reason != null) 'reason': reason,
          if (immediate != null) 'immediate': immediate,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  // Reactivate subscription
  Future<Subscription> reactivateSubscription() async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/subscriptions/reactivate',
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Upgrade subscription
  Future<Subscription> upgradeSubscription({
    required String newPlanId,
    bool? prorate,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/subscriptions/upgrade',
        data: {
          'newPlanId': newPlanId,
          if (prorate != null) 'prorate': prorate,
        },
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Downgrade subscription
  Future<Subscription> downgradeSubscription({
    required String newPlanId,
    bool? atPeriodEnd,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/subscriptions/downgrade',
        data: {
          'newPlanId': newPlanId,
          if (atPeriodEnd != null) 'atPeriodEnd': atPeriodEnd,
        },
      );

      return Subscription.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get payment methods
  Future<List<PaymentMethod>> getPaymentMethods() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/payments/methods',
      );

      final methods = response['methods'] as List;
      return methods.map((method) => PaymentMethod.fromJson(method)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Add payment method
  Future<PaymentMethod> addPaymentMethod({
    required String token,
    bool? setAsDefault,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/payments/methods',
        data: {
          'token': token,
          if (setAsDefault != null) 'setAsDefault': setAsDefault,
        },
      );

      return PaymentMethod.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Update payment method
  Future<PaymentMethod> updatePaymentMethod({
    required String methodId,
    Map<String, dynamic>? updates,
  }) async {
    try {
      final response = await ApiClient.instance.put<Map<String, dynamic>>(
        '/payments/methods/$methodId',
        data: updates,
      );

      return PaymentMethod.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Remove payment method
  Future<void> removePaymentMethod(String methodId) async {
    try {
      await ApiClient.instance.delete<Map<String, dynamic>>(
        '/payments/methods/$methodId',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Set default payment method
  Future<void> setDefaultPaymentMethod(String methodId) async {
    try {
      await ApiClient.instance.put<Map<String, dynamic>>(
        '/payments/methods/$methodId/default',
      );
    } catch (e) {
      rethrow;
    }
  }

  // Get billing history
  Future<List<BillingHistoryItem>> getBillingHistory({
    int? limit,
    int? offset,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;
      if (fromDate != null)
        queryParams['fromDate'] = fromDate.toIso8601String();
      if (toDate != null) queryParams['toDate'] = toDate.toIso8601String();

      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/payments/history',
        queryParameters: queryParams,
      );

      final history = response['history'] as List;
      return history.map((item) => BillingHistoryItem.fromJson(item)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Get invoice
  Future<Invoice> getInvoice(String invoiceId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/payments/invoices/$invoiceId',
      );

      return Invoice.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Download invoice
  Future<String> downloadInvoice(String invoiceId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/payments/invoices/$invoiceId/download',
      );

      return response['downloadUrl'] as String;
    } catch (e) {
      rethrow;
    }
  }

  // Process payment
  Future<Payment> processPayment({
    required double amount,
    required String currency,
    required String paymentMethodId,
    String? description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/payments/process',
        data: {
          'amount': amount,
          'currency': currency,
          'paymentMethodId': paymentMethodId,
          if (description != null) 'description': description,
          if (metadata != null) 'metadata': metadata,
        },
      );

      return Payment.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get payment status
  Future<Payment> getPaymentStatus(String paymentId) async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/payments/$paymentId',
      );

      return Payment.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Refund payment
  Future<Payment> refundPayment({
    required String paymentId,
    double? amount,
    String? reason,
  }) async {
    try {
      final response = await ApiClient.instance.post<Map<String, dynamic>>(
        '/payments/$paymentId/refund',
        data: {
          if (amount != null) 'amount': amount,
          if (reason != null) 'reason': reason,
        },
      );

      return Payment.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get subscription usage
  Future<SubscriptionUsage> getSubscriptionUsage() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/subscriptions/usage',
      );

      return SubscriptionUsage.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  // Get upcoming invoice
  Future<Invoice> getUpcomingInvoice() async {
    try {
      final response = await ApiClient.instance.get<Map<String, dynamic>>(
        '/subscriptions/upcoming-invoice',
      );

      return Invoice.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}

class PaymentMethod {
  const PaymentMethod({
    required this.id,
    required this.type,
    required this.last4,
    required this.brand,
    required this.expMonth,
    required this.expYear,
    required this.isDefault,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id'] as String,
        type: json['type'] as String,
        last4: json['last4'] as String,
        brand: json['brand'] as String,
        expMonth: json['expMonth'] as int,
        expYear: json['expYear'] as int,
        isDefault: json['isDefault'] as bool,
      );

  final String id;
  final String type;
  final String last4;
  final String brand;
  final int expMonth;
  final int expYear;
  final bool isDefault;
}

class BillingHistoryItem {
  const BillingHistoryItem({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.type,
    required this.date,
    this.description,
  });

  factory BillingHistoryItem.fromJson(Map<String, dynamic> json) =>
      BillingHistoryItem(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        status: json['status'] as String,
        type: json['type'] as String,
        date: DateTime.parse(json['date'] as String),
        description: json['description'] as String?,
      );

  final String id;
  final double amount;
  final String currency;
  final String status;
  final String type;
  final DateTime date;
  final String? description;
}

class Invoice {
  const Invoice({
    required this.id,
    required this.amount,
    required this.currency,
    required this.status,
    required this.date,
    required this.dueDate,
    this.description,
    this.items,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'] as String,
        amount: (json['amount'] as num).toDouble(),
        currency: json['currency'] as String,
        status: json['status'] as String,
        date: DateTime.parse(json['date'] as String),
        dueDate: DateTime.parse(json['dueDate'] as String),
        description: json['description'] as String?,
        items: json['items'] != null
            ? (json['items'] as List)
                .map((item) => InvoiceItem.fromJson(item))
                .toList()
            : null,
      );

  final String id;
  final double amount;
  final String currency;
  final String status;
  final DateTime date;
  final DateTime dueDate;
  final String? description;
  final List<InvoiceItem>? items;
}

class InvoiceItem {
  const InvoiceItem({
    required this.description,
    required this.amount,
    required this.quantity,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        description: json['description'] as String,
        amount: (json['amount'] as num).toDouble(),
        quantity: json['quantity'] as int,
      );

  final String description;
  final double amount;
  final int quantity;
}

class SubscriptionUsage {
  const SubscriptionUsage({
    required this.currentPeriodStart,
    required this.currentPeriodEnd,
    required this.usage,
    required this.limits,
  });

  factory SubscriptionUsage.fromJson(Map<String, dynamic> json) =>
      SubscriptionUsage(
        currentPeriodStart:
            DateTime.parse(json['currentPeriodStart'] as String),
        currentPeriodEnd: DateTime.parse(json['currentPeriodEnd'] as String),
        usage: Map<String, int>.from(json['usage']),
        limits: Map<String, int>.from(json['limits']),
      );

  final DateTime currentPeriodStart;
  final DateTime currentPeriodEnd;
  final Map<String, int> usage;
  final Map<String, int> limits;
}
