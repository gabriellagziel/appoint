import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> init() async {
    Stripe.publishableKey = "pk_test_…";
    await Stripe.instance.applySettings();
  }

  Future<Map<String, dynamic>> createPaymentIntent(double amount) async {
    final callable = FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
    final result = await callable.call({'amount': amount});
    return Map<String, dynamic>.from(result.data);
  }

  Future<void> handlePayment(String clientSecret) async {
    // Use flutter_stripe’s confirmPayment with PaymentMethodParams
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: clientSecret,
      data: PaymentMethodParams.card(
        paymentMethodData: const PaymentMethodData(),
      ),
    );
  }
}
