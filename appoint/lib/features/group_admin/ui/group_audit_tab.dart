import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/models/group_audit_event.dart';
import 'package:appoint/models/group_role.dart';
import 'package:appoint/features/group_admin/providers/group_admin_providers.dart';
import 'package:appoint/features/auth/providers/auth_provider.dart';
import 'package:appoint/features/group_admin/ui/widgets/audit_event_tile.dart';

class GroupAuditTab extends ConsumerStatefulWidget {
  final String groupId;

  const GroupAuditTab({
    super.key,
    required this.groupId,
  });

  @override
  ConsumerState<GroupAuditTab> createState() => _GroupAuditTabState();
}

class _GroupAuditTabState extends ConsumerState<GroupAuditTab> {
  AuditEventType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    final eventsAsync = ref.watch(groupAuditProvider(widget.groupId));
    final membersAsync = ref.watch(groupMembersProvider(widget.groupId));
    final authState = ref.watch(authStateProvider);
    final currentUserId = authState?.user?.uid;

    return membersAsync.when(
      data: (members) {
        final currentUserMember = members.firstWhere(
          (member) => member.userId == currentUserId,
          orElse: () => GroupMember(
            userId: currentUserId ?? '',
            role: GroupRole.member,
            joinedAt: DateTime.now(),
          ),
        );

        final canViewAuditLog = currentUserMember.role.canViewAuditLog();

        if (!canViewAuditLog) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Audit Log Restricted',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'You need admin permissions to view the audit log',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return eventsAsync.when(
          data: (events) {
            final filteredEvents = _selectedFilter != null
                ? events
                    .where((event) => event.type == _selectedFilter)
                    .toList()
                : events;

            return Column(
              children: [
                // Filter Section
                _buildFilterSection(context, events),

                // Events List
                Expanded(
                  child: filteredEvents.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.history, size: 64, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No audit events found',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Events will appear here as they occur',
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredEvents.length,
                          itemBuilder: (context, index) {
                            final event = filteredEvents[index];
                            return AuditEventTile(
                              event: event,
                              isLast: index == filteredEvents.length - 1,
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Failed to load audit events',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () =>
                      ref.refresh(groupAuditProvider(widget.groupId)),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Failed to load members',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.refresh(groupMembersProvider(widget.groupId)),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context, List<GroupAuditEvent> events) {
    final eventTypes = events.map((e) => e.type).toSet().toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audit Log',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<AuditEventType?>(
                  value: _selectedFilter,
                  decoration: const InputDecoration(
                    labelText: 'Filter by type',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All Events'),
                    ),
                    ...eventTypes.map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(_getEventTypeDisplayName(type)),
                        )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedFilter = value;
                    });
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${events.length} total events',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getEventTypeDisplayName(AuditEventType type) {
    switch (type) {
      case AuditEventType.roleChanged:
        return 'Role Changes';
      case AuditEventType.policyChanged:
        return 'Policy Changes';
      case AuditEventType.memberRemoved:
        return 'Member Removals';
      case AuditEventType.voteOpened:
        return 'Votes Opened';
      case AuditEventType.voteClosed:
        return 'Votes Closed';
      case AuditEventType.memberJoined:
        return 'Member Joins';
      case AuditEventType.memberInvited:
        return 'Member Invites';
      default:
        return 'Other Events';
    }
  }
}
