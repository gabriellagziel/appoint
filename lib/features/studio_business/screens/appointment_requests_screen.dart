import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentRequestsScreen extends ConsumerWidget {
  const AppointmentRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('appointmentRequests')
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

          final requests = snapshot.data?.docs ?? [];

          if (requests.isEmpty) {
            return const Center(
              child: Text('No appointment requests found.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, final index) {
              final request = requests[index].data()! as Map<String, dynamic>;
              final requestId = requests[index].id;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(request['status']),
                    child: Icon(
                      _getStatusIcon(request['status']),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(request['customerName'] ?? 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${request['date']}'),
                      Text('Time: ${request['time']}'),
                      Text('Status: ${request['status'] ?? 'pending'}'),
                      if (request['notes'] != null)
                        Text('Notes: ${request['notes']}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'accept',
                        child: Text('Accept'),
                      ),
                      const PopupMenuItem(
                        value: 'reject',
                        child: Text('Reject'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'accept') {
                        _updateRequestStatus(requestId, 'accepted');
                      } else if (value == 'reject') {
                        _updateRequestStatus(requestId, 'rejected');
                      } else if (value == 'delete') {
                        _deleteRequest(requestId);
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

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'accepted':
        return Icons.check;
      case 'rejected':
        return Icons.close;
      default:
        return Icons.schedule;
    }
  }

  Future<void> _updateRequestStatus(
      String requestId, final String status,) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointmentRequests')
          .doc(requestId)
          .update({
        'status': status,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Removed debug print: debugPrint('Error updating request: $e');
    }
  }

  Future<void> _deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointmentRequests')
          .doc(requestId)
          .delete();
    } catch (e) {
      // Removed debug print: debugPrint('Error deleting request: $e');
    }
  }
}
