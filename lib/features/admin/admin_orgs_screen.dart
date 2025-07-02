import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/providers/admin_provider.dart';

class AdminOrgsScreen extends ConsumerWidget {
  const AdminOrgsScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final orgsAsync = ref.watch(orgsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Organizations')),
      body: orgsAsync.when(
        data: (final orgs) {
          if (orgs.isEmpty) {
            return const Center(child: Text('No organizations'));
          }
          return ListView.builder(
            itemCount: orgs.length,
            itemBuilder: (final context, final index) {
              final org = orgs[index];
              return ListTile(
                title: Text(org.name),
                subtitle: Text('${org.memberIds.length} members'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final _, final __) =>
            const Center(child: Text('Error loading organizations')),
      ),
    );
  }
}
