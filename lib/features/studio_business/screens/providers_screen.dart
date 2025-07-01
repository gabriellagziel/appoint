import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/providers/studio_business_providers.dart';

class ProvidersScreen extends ConsumerWidget {
  const ProvidersScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final providersAsync = ref.watch(businessProvidersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Providers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddProviderDialog(context),
          ),
        ],
      ),
      body: providersAsync.when(
        data: (final providers) {
          if (providers.isEmpty) {
            return const Center(
              child: Text('No providers found. Add your first provider!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: providers.length,
            itemBuilder: (final context, final index) {
              final provider = providers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text(provider['name'] ?? 'Unknown'),
                  subtitle: Text(provider['role'] ?? 'No role specified'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      (provider['name'] ?? 'U')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (final value) {
                      if (value == 'edit') {
                        _showEditProviderDialog(context, provider);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(context, provider['id']);
                      }
                    },
                    itemBuilder: (final context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (final error, final stack) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showAddProviderDialog(final BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _roleController = TextEditingController();

    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Add Provider'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement this feature
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditProviderDialog(
      final BuildContext context, final Map<String, dynamic> provider) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController(text: provider['name'] ?? '');
    final _roleController = TextEditingController(text: provider['role'] ?? '');

    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Edit Provider'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (final value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement this feature
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      final BuildContext context, final String providerId) {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        title: const Text('Delete Provider'),
        content: const Text('Are you sure you want to delete this provider?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement this featurentext);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
