import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessBookingEntryScreen extends ConsumerWidget {
  const BusinessBookingEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Booking')),
        body: const Center(
          child: Text('Business Booking Entry Screen - Coming Soon'),
        ),
      );
}
