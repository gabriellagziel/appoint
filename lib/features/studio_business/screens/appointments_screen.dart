import 'package:appoint/providers/studio_business_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppointmentsScreen extends ConsumerWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO(username): Implement this featurentment screen
            },
          ),
        ],
      ),
      body: appointmentsAsync.when(
        data: (appointments) {
          if (appointments.isEmpty) {
            return const Center(
              child: Text('No appointments found.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: appointments.length,
            itemBuilder: (context, final index) {
              final appointment = appointments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  title: Text('Appointment ${appointment.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${appointment.scheduledAt}'),
                      Text('Status: ${appointment.status.name}'),
                      if (appointment.inviteeContact != null)
                        Text(
                            'Client: ${appointment.inviteeContact!.displayName}'),
                    ],
                  ),
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(appointment.status.name),
                    child: const Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      _handleAppointmentAction(context, appointment.id, value);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Text('Cancel'),
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
        error: (error, final stack) =>
            Center(child: Text('Error: $error')),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleAppointmentAction(final BuildContext context,
      String appointmentId, final String action,) {
    switch (action) {
      case 'edit':
        // TODO(username): Implement this featurentment screen
        break;
      case 'cancel':
        _showCancelConfirmation(context, appointmentId);
      case 'delete':
        _showDeleteConfirmation(context, appointmentId);
    }
  }

  void _showCancelConfirmation(
      BuildContext context, final String appointmentId,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Appointment'),
        content:
            const Text('Are you sure you want to cancel this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO(username): Implement this featurencel appointment
              Navigator.pop(context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, final String appointmentId,) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Appointment'),
        content:
            const Text('Are you sure you want to delete this appointment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO(username): Implement this featurentment
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
