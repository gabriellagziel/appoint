import 'package:flutter/material.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final success = ModalRoute.of(context)!.settings.arguments as bool? ?? true;
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Confirmation')),
      body: Center(
        child: Text(success ? 'Payment Successful' : 'Payment Failed'),
      ),
    );
  }
}
