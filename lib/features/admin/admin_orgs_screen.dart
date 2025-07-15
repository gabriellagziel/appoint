import 'package:appoint/providers/admin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminOrgsScreen extends ConsumerWidget {
  const AdminOrgsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
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
            itemBuilder: (context, final index) {
              final org = orgs[index];
              return ListTile(
                title: Text(org.name),
                subtitle: Text('${org.memberIds.length} members'),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, final __) =>
            const Center(child: Text('Error loading organizations')),
      ),
    );
  }
}
