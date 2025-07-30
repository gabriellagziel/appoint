import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessAvailabilityEntryScreen extends ConsumerWidget {
  const BusinessAvailabilityEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Availability')),
        body: const Center(
          child: Text('Business Availability Entry Screen - Coming Soon'),
        ),
      );
}
