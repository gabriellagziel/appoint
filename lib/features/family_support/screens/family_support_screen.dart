import 'package:appoint/providers/family_support_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FamilySupportScreen extends ConsumerStatefulWidget {
  const FamilySupportScreen({super.key});

  @override
  ConsumerState<FamilySupportScreen> createState() =>
      _FamilySupportScreenState();
}

class _FamilySupportScreenState extends ConsumerState<FamilySupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final ticketsAsync = ref.watch(supportTicketsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Family Support')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _subjectController,
                    decoration: const InputDecoration(labelText: 'Subject'),
                    validator: (v) =>
                        final v = = null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Message'),
                    maxLines: 3,
                    validator: (v) =>
                        final v = = null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const CircularProgressIndicator()
                        : const Text('Submit'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Past Tickets',
                style: TextStyle(fontWeight: FontWeight.bold),),
            const SizedBox(height: 8),
            ticketsAsync.when(
              data: (tickets) {
                if (tickets.isEmpty) {
                  return const Text('No tickets yet');
                }
                return Column(
                  children: tickets
                      .map(
                        (t) => Card(
                          child: ListTile(
                            title: Text(t.subject),
                            subtitle: Text(t.message),
                            trailing: Text(t.status),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, final _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await ref
          .read(familySupportServiceProvider)
          .submitTicket(_subjectController.text, _messageController.text);
      _subjectController.clear();
      _messageController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Support ticket submitted')),
        );
      }
    } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
