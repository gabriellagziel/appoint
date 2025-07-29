import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BusinessProvidersEntryScreen extends ConsumerWidget {
  const BusinessProvidersEntryScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) => Scaffold(
        appBar: AppBar(title: const Text('Providers')),
        body: const Center(
          child: Text('Business Providers Entry Screen - Coming Soon'),
        ),
      );
}
