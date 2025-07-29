import 'package:appoint/constants/app_branding.dart';
import 'package:appoint/widgets/app_attribution.dart';
import 'package:appoint/widgets/app_logo.dart';
import 'package:flutter/material.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final success = ModalRoute.of(context)!.settings.arguments as bool? ?? true;
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            AppLogo(size: 24, logoOnly: true),
            SizedBox(width: 8),
            Text('Payment Confirmation'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const AppLogo(size: 80),
                  const SizedBox(height: 24),
                  Text(
                    success ? 'Payment Successful!' : 'Payment Failed',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: success ? Colors.green : Colors.red,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppBranding.fullSlogan,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    success
                        ? 'Your payment has been processed successfully.'
                        : 'There was an issue processing your payment.',
                  ),
                ],
              ),
            ),
          ),
          // Attribution - Required for all payment screens
          const AppAttributionFooter(),
        ],
      ),
    );
  }
}
