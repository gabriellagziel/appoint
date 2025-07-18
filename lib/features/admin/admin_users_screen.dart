import 'package:appoint/models/admin_user.dart';
import 'package:appoint/providers/admin_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUsersScreen extends ConsumerWidget {
  const AdminUsersScreen({super.key});

  Future<void> _changeRole(final BuildContext context, final WidgetRef ref,
      AdminUser user,) async {
    final newRole = user.role == 'admin' ? 'manager' : 'admin';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'role': newRole});
    // Trigger provider refresh and ignore the returned value.
    // ignore: unused_result
    ref.refresh(allUsersProvider);
  }

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final usersAsync = ref.watch(allUsersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: usersAsync.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(child: Text('No users'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, final index) {
              final user = users[index];
              return ListTile(
                title: Text(
                    user.displayName.isEmpty ? user.email : user.displayName),
                subtitle: Text(user.role),
                trailing: ElevatedButton(
                  onPressed: () => _changeRole(context, ref, user),
                  child: const Text('Change Role'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, final __) =>
            const Center(child: Text('Error loading users')),
      ),
    );
  }
}
