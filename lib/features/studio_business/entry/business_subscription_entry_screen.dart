import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessSubscriptionEntryScreen extends ConsumerWidget {
  const BusinessSubscriptionEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Subscription')),
        body: const Center(
          child: Text('Business Subscription Entry Screen - Coming Soon'),
        ),
      );
}
