import 'package:flutter/material.dart';

/// Placeholder dashboard for creator studio
class StudioDashboardScreen extends StatelessWidget {
  const StudioDashboardScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studio Dashboard'),
      ),
      body: const Center(
        child: Text('Welcome to your studio'),
      ),
    );
  }
}
