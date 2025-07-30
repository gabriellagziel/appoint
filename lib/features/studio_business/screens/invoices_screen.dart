import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _InvoicesScreenState();
}

class _InvoicesScreenState extends ConsumerState<InvoicesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isAdding = false;

  @override
  void dispose() {
    _clientNameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddInvoiceDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('invoices')
            .where('businessProfileId', isEqualTo: user.uid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, final snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final invoices = snapshot.data?.docs ?? [];

          if (invoices.isEmpty) {
            return const Center(
              child: Text('No invoices found. Create your first invoice!'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: invoices.length,
            itemBuilder: (context, final index) {
              final invoice = invoices[index].data()! as Map<String, dynamic>;
              final invoiceId = invoices[index].id;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(invoice['status']),
                    child: Icon(
                      _getStatusIcon(invoice['status']),
                      color: Colors.white,
                    ),
                  ),
                  title: Text('Invoice #${invoice['invoiceNumber']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Client: ${invoice['clientName']}'),
                      Text('Amount: \$${invoice['amount']}'),
                      Text('Status: ${invoice['status'] ?? 'pending'}'),
                      if (invoice['description'] != null)
                        Text('Description: ${invoice['description']}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'paid',
                        child: Text('Mark as Paid'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'paid') {
                        _updateInvoiceStatus(invoiceId, 'paid');
                      } else if (value == 'delete') {
                        _deleteInvoice(invoiceId);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddInvoiceDialog(BuildContext context) {
    _clientNameController.clear();
    _amountController.clear();
    _descriptionController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Invoice'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter client name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: r'Amount ($)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
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
            onPressed: _isAdding ? null : _addInvoice,
            child: _isAdding
                ? const CircularProgressIndicator()
                : const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _addInvoice() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isAdding = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('Not authenticated');

      // Generate invoice number
      final invoiceNumber = _generateInvoiceNumber();

      await FirebaseFirestore.instance.collection('invoices').add({
        'invoiceNumber': invoiceNumber,
        'clientName': _clientNameController.text.trim(),
        'amount': double.parse(_amountController.text.trim()),
        'description': _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        'businessProfileId': user.uid,
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invoice created successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
    
    // Always reset loading state
    if (mounted) {
      setState(() => _isAdding = false);
    }
  }

  String _generateInvoiceNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'INV-${timestamp.toString().substring(timestamp.toString().length - 6)}';
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'paid':
        return Colors.green;
      case 'overdue':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'paid':
        return Icons.check;
      case 'overdue':
        return Icons.warning;
      default:
        return Icons.schedule;
    }
  }

  Future<void> _updateInvoiceStatus(
      String invoiceId, final String status,) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoiceId)
          .update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Removed debug print: debugPrint('Error updating invoice: $e');
    }
  }

  Future<void> _deleteInvoice(String invoiceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('invoices')
          .doc(invoiceId)
          .delete();
    } catch (e) {
      // Removed debug print: debugPrint('Error deleting invoice: $e');
    }
  }
}
