import 'package:cloud_functions/cloud_functions.dart';
import 'package:stripe_sdk/stripe_sdk.dart';

class PaymentService {
  final _stripe = Stripe("pk_test_…");
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> init() async {
    await _stripe.applySettings();
  }

  Future<Map<String, dynamic>> createPaymentIntent(double amount) async {
    final callable = FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
    final result = await callable.call({'amount': amount});
    return Map<String, dynamic>.from(result.data);
  }

  Future<void> handlePayment(String clientSecret) async {
    await Stripe.instance.confirmPayment(clientSecret);
  }
}
