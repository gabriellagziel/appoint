import 'package:appoint/models/care_provider.dart';
import 'package:appoint/providers/care_providers_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProvidersScreen extends ConsumerWidget {
  const ProvidersScreen({super.key});

  Future<void> _openEditor(final BuildContext context, final WidgetRef ref,
      {CareProvider? provider,}) async {
    final nameController = TextEditingController(text: provider?.name ?? '');
    final specialtyController =
        TextEditingController(text: provider?.specialty ?? '');
    final contactController =
        TextEditingController(text: provider?.contactInfo ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(provider == null ? 'Add Provider' : 'Edit Provider'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: specialtyController,
                decoration: const InputDecoration(labelText: 'Specialty'),
              ),
              TextField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact Info'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newProv = CareProvider(
                  id: provider?.id ?? '',
                  name: nameController.text,
                  specialty: specialtyController.text,
                  contactInfo: contactController.text,
                );
                if (provider == null) {
                  ref.read(careProvidersProvider.notifier).add(newProv);
                } else {
                  ref.read(careProvidersProvider.notifier).update(newProv);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
    );
  }

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final provsAsync = ref.watch(careProvidersProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Providers')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(context, ref),
        child: const Icon(Icons.add),
      ),
      body: provsAsync.when(
        data: (provs) {
          if (provs.isEmpty) {
            return const Center(child: Text('No providers'));
          }
          return ListView.builder(
            itemCount: provs.length,
            itemBuilder: (context, final index) {
              final p = provs[index];
              return ListTile(
                title: Text(p.name),
                subtitle: Text('${p.specialty}\n${p.contactInfo}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openEditor(context, ref, provider: p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () =>
                          ref.read(careProvidersProvider.notifier).delete(p.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, final _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
