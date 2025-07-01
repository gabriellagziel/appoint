import 'package:flutter/material.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({final Key? key}) : super(key: key);

  @override
  Widget build(final BuildContext context) {
    final success = ModalRoute.of(context)!.settings.arguments as bool? ?? true;
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Confirmation')),
      body: Center(
        child: Text(success ? 'Payment Successful' : 'Payment Failed'),
      ),
    );
  }
}
