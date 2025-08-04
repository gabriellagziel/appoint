import 'package:appoint/models/meeting_invitation.dart';
import 'package:appoint/services/invitation_service.dart';
import 'package:appoint/features/invitations/widgets/business_profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final invitationDetailProvider = FutureProvider.family<MeetingInvitation?, String>((ref, invitationId) async {
  final service = ref.read(invitationServiceProvider);
  return service.getInvitation(invitationId);
});

class InvitationDetailScreen extends ConsumerStatefulWidget {
  final String invitationId;

  const InvitationDetailScreen({
    super.key,
    required this.invitationId,
  });

  @override
  ConsumerState<InvitationDetailScreen> createState() => _InvitationDetailScreenState();
}

class _InvitationDetailScreenState extends ConsumerState<InvitationDetailScreen> {
  bool _isResponding = false;
  DateTime? _suggestedDateTime;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invitationAsync = ref.watch(invitationDetailProvider(widget.invitationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Invitation'),
        centerTitle: true,
        elevation: 0,
      ),
      body: invitationAsync.when(
        data: (invitation) {
          if (invitation == null) {
            return const Center(
              child: Text('Invitation not found'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Business Profile Card
                BusinessProfileCard(
                  businessName: invitation.businessName,
                  businessLogo: invitation.businessLogo,
                  businessProfile: invitation.businessProfile,
                ),
                const SizedBox(height: 24),

                // Meeting Details Card
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Meeting Details',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        _buildDetailRow(
                          icon: Icons.title,
                          label: 'Title',
                          value: invitation.meetingTitle,
                        ),
                        const SizedBox(height: 12),
                        
                        _buildDetailRow(
                          icon: Icons.description,
                          label: 'Description',
                          value: invitation.meetingDescription,
                        ),
                        const SizedBox(height: 12),
                        
                        _buildDetailRow(
                          icon: Icons.calendar_today,
                          label: 'Date',
                          value: DateFormat('EEEE, MMMM dd, yyyy').format(invitation.proposedDateTime),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildDetailRow(
                          icon: Icons.access_time,
                          label: 'Time',
                          value: DateFormat('h:mm a').format(invitation.proposedDateTime),
                        ),
                        const SizedBox(height: 12),
                        
                        _buildDetailRow(
                          icon: Icons.schedule,
                          label: 'Duration',
                          value: '${invitation.duration.inMinutes} minutes',
                        ),
                        
                        if (invitation.notes?.isNotEmpty == true) ...[
                          const SizedBox(height: 12),
                          _buildDetailRow(
                            icon: Icons.note,
                            label: 'Notes',
                            value: invitation.notes!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Response Actions
                if (invitation.status == InvitationStatus.pending) ...[
                  Text(
                    'Respond to Invitation',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Accept Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isResponding ? null : () => _respondToInvitation(
                        invitation,
                        InvitationStatus.accepted,
                      ),
                      icon: const Icon(Icons.check),
                      label: const Text('Accept Invitation'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Decline Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isResponding ? null : () => _respondToInvitation(
                        invitation,
                        InvitationStatus.declined,
                      ),
                      icon: const Icon(Icons.close),
                      label: const Text('Decline Invitation'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Suggest Different Time Section
                  ExpansionTile(
                    title: const Text('Suggest Different Time'),
                    leading: const Icon(Icons.schedule),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.calendar_today),
                              title: const Text('Select Date & Time'),
                              subtitle: _suggestedDateTime != null
                                  ? Text(
                                      DateFormat('MMM dd, yyyy h:mm a').format(_suggestedDateTime!),
                                    )
                                  : const Text('Tap to select'),
                              onTap: _selectDateTime,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _notesController,
                              decoration: const InputDecoration(
                                labelText: 'Additional Notes',
                                hintText: 'Explain why you need a different time...',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 3,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: _suggestedDateTime == null || _isResponding
                                    ? null
                                    : () => _respondToInvitation(
                                          invitation,
                                          InvitationStatus.suggestedNewTime,
                                        ),
                                icon: const Icon(Icons.send),
                                label: const Text('Send Suggestion'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  // Show response status
                  Card(
                    color: _getStatusColor(invitation.status).withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            _getStatusIcon(invitation.status),
                            color: _getStatusColor(invitation.status),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _getStatusText(invitation.status),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: _getStatusColor(invitation.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (invitation.responseNotes?.isNotEmpty == true) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    invitation.responseNotes!,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading invitation',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _suggestedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  Future<void> _respondToInvitation(
    MeetingInvitation invitation,
    InvitationStatus status,
  ) async {
    setState(() {
      _isResponding = true;
    });

    try {
      final service = ref.read(invitationServiceProvider);
      final response = InvitationResponse(
        invitationId: invitation.id,
        status: status,
        respondedAt: DateTime.now(),
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
        suggestedDateTime: status == InvitationStatus.suggestedNewTime
            ? _suggestedDateTime
            : null,
      );

      await service.respondToInvitation(response);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_getResponseMessage(status)),
            backgroundColor: _getStatusColor(status),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error responding to invitation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResponding = false;
        });
      }
    }
  }

  String _getResponseMessage(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.accepted:
        return 'Invitation accepted! Meeting added to your calendar.';
      case InvitationStatus.declined:
        return 'Invitation declined.';
      case InvitationStatus.suggestedNewTime:
        return 'Time suggestion sent to business.';
      default:
        return 'Response sent.';
    }
  }

  Color _getStatusColor(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return Colors.orange;
      case InvitationStatus.accepted:
        return Colors.green;
      case InvitationStatus.declined:
        return Colors.red;
      case InvitationStatus.suggestedNewTime:
        return Colors.blue;
      case InvitationStatus.expired:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return Icons.schedule;
      case InvitationStatus.accepted:
        return Icons.check_circle;
      case InvitationStatus.declined:
        return Icons.cancel;
      case InvitationStatus.suggestedNewTime:
        return Icons.schedule_send;
      case InvitationStatus.expired:
        return Icons.access_time;
    }
  }

  String _getStatusText(InvitationStatus status) {
    switch (status) {
      case InvitationStatus.pending:
        return 'Pending Response';
      case InvitationStatus.accepted:
        return 'Accepted';
      case InvitationStatus.declined:
        return 'Declined';
      case InvitationStatus.suggestedNewTime:
        return 'Time Suggested';
      case InvitationStatus.expired:
        return 'Expired';
    }
  }
} 