import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/admin_provider.dart';

class AdminOrgsScreen extends ConsumerWidget {
  const AdminOrgsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgsAsync = ref.watch(orgsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Organizations')),
      body: orgsAsync.when(
        data: (orgs) {
          if (orgs.isEmpty) {
            return const Center(child: Text('No organizations'));
          }
          return ListView.builder(
            itemCount: orgs.length,
            itemBuilder: (context, index) {
              final org = orgs[index];
              return ListTile(
                title: Text(org.name),
                subtitle: Text('${org.memberIds.length} members'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading organizations')),
      ),
    );
  }
}
