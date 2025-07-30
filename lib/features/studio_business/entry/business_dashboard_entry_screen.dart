import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessDashboardEntryScreen extends ConsumerWidget {
  const BusinessDashboardEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: const Center(
          child: Text('Business Dashboard Entry Screen - Coming Soon'),
        ),
      );
}
