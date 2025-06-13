import 'package:flutter/material.dart';

class BusinessDashboardScreen extends StatelessWidget {
  const BusinessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Business Owner!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text('\uD83D\uDCC5 Bookings'),
            const Divider(),
            const Text('\uD83E\uDDD1 Staff Availability'),
            const Divider(),
            const Text('\uD83D\uDCCA Stats & Analytics'),
            const Divider(),
            const Text('\u2699\uFE0F Settings'),
          ],
        ),
      ),
    );
  }
}
