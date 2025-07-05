import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

enum PaymentStatus { initial, processing, requiresAction, succeeded, failed }

class PaymentService {
  final FirebaseFunctions _functions;

  PaymentService([FirebaseFunctions? functions])
      : _functions = functions ?? FirebaseFunctions.instance;

  Future<void> init() async {
    Stripe.publishableKey = 'pk_test_…';
    await Stripe.instance.applySettings();
  }

  Future<Map<String, dynamic>> createPaymentIntent(final double amount) async {
    final callable = _functions.httpsCallable('createPaymentIntent');
    final result = await callable.call({'amount': amount});
    return Map<String, dynamic>.from(result.data);
  }

  Future<PaymentStatus> handlePayment(final double amount) async {
    try {
      final intent = await createPaymentIntent(amount);
      final clientSecret = intent['clientSecret'] as String;
      final status = intent['status'] as String?;
      if (status == 'requires_action') {
        // 3D Secure required
        try {
          await Stripe.instance.handleNextAction(clientSecret);
        } catch (_) {
          return PaymentStatus.failed;
        }
        // Re-confirm after 3DS
        return await _confirmPayment(clientSecret);
      } else {
        // Try to confirm payment
        return await _confirmPayment(clientSecret);
      }
    } catch (_) {
      return PaymentStatus.failed;
    }
  }

  Future<PaymentStatus> _confirmPayment(String clientSecret) async {
    try {
      final paymentResult = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret,
        data: const PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData()),
      );
      switch (paymentResult.status) {
        case PaymentIntentsStatus.Succeeded:
          return PaymentStatus.succeeded;
        case PaymentIntentsStatus.RequiresAction:
          try {
            await Stripe.instance.handleNextAction(clientSecret);
          } catch (_) {
            return PaymentStatus.failed;
          }
          return await _confirmPayment(clientSecret);
        case PaymentIntentsStatus.RequiresPaymentMethod:
        case PaymentIntentsStatus.Canceled:
        default:
          return PaymentStatus.failed;
      }
    } catch (_) {
      return PaymentStatus.failed;
    }
  }

  // Helper method to get payment status description
  String getPaymentStatusMessage(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.initial:
        return 'Ready to process payment';
      case PaymentStatus.processing:
        return 'Processing payment...';
      case PaymentStatus.requiresAction:
        return 'Authentication required...';
      case PaymentStatus.succeeded:
        return 'Payment successful!';
      case PaymentStatus.failed:
        return 'Payment failed. Please try again.';
    }
  }
}
