import 'package:flutter/material.dart';

class StudioBookingConfirmScreen extends StatelessWidget {
  const StudioBookingConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Confirmation')),
      body: const Center(
        child: Text('Studio Booking Confirmation'),
      ),
    );
  }
}
