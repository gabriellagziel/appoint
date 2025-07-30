import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessPhoneBookingEntryScreen extends ConsumerWidget {
  const BusinessPhoneBookingEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Phone Booking')),
        body: const Center(
          child: Text('Business Phone Booking Entry Screen - Coming Soon'),
        ),
      );
}
