import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessCrmEntryScreen extends ConsumerWidget {
  const BusinessCrmEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('CRM')),
        body: const Center(
          child: Text('Business CRM Entry Screen - Coming Soon'),
        ),
      );
}
