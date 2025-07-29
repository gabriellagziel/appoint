import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessAppointmentsEntryScreen extends ConsumerWidget {
  const BusinessAppointmentsEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Appointments')),
        body: const Center(
          child: Text('Business Appointments Entry Screen - Coming Soon'),
        ),
      );
}
