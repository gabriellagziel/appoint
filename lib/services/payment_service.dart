import 'package:firebase_functions/firebase_functions.dart';
import 'package:stripe_sdk/stripe_sdk.dart';

class PaymentService {
  final _stripe = Stripe("pk_test_…");
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<void> init() async {
    await _stripe.applySettings();
  }

  Future<IntentClientSecret> createPaymentIntent(double amount) async {
    final result = await _functions
        .httpsCallable('createPaymentIntent')
        .call({'amount': amount});
    final clientSecret = result.data['clientSecret'] as String;
    return IntentClientSecret(null, clientSecret);
  }

  Future<void> handlePayment(String clientSecret) async {
    await _stripe.api.confirmPaymentIntent(clientSecret);
  }
}
