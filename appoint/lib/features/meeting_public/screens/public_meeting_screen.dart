import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/public_rsvp_service.dart';
import '../../../services/security/group_share_security_service.dart';
import '../../../models/user_group.dart';
import '../../auth/providers/auth_provider.dart';

class PublicMeetingScreen extends ConsumerStatefulWidget {
  final String meetingId;
  final String? groupId;
  final String? source;
  final String? guestToken;

  const PublicMeetingScreen({
    super.key,
    required this.meetingId,
    this.groupId,
    this.source,
    this.guestToken,
  });

  @override
  ConsumerState<PublicMeetingScreen> createState() =>
      _PublicMeetingScreenState();
}

class _PublicMeetingScreenState extends ConsumerState<PublicMeetingScreen> {
  bool _isLoading = true;
  bool _canAccess = false;
  bool _isGroupMember = false;
  Map<String, dynamic>? _meetingData;
  UserGroup? _groupData;
  RSVPStatus? _currentRSVP;

  @override
  void initState() {
    super.initState();
    _loadMeetingData();
  }

  Future<void> _loadMeetingData() async {
    try {
      final authState = ref.read(authStateProvider);
      final securityService = ref.read(REDACTED_TOKEN);

      // Check access permissions
      final canAccess = await securityService.canAccessMeeting(
        meetingId: widget.meetingId,
        groupId: widget.groupId ?? '',
        userId: authState?.user?.uid,
        guestToken: widget.guestToken,
      );

      if (!canAccess) {
        setState(() {
          _isLoading = false;
          _canAccess = false;
        });
        return;
      }

      // Load meeting data
      final meetingDoc = await FirebaseFirestore.instance
          .collection('meetings')
          .doc(widget.meetingId)
          .get();

      if (!meetingDoc.exists) {
        setState(() {
          _isLoading = false;
          _canAccess = false;
        });
        return;
      }

      final meetingData = meetingDoc.data()!;

      // Load group data if available
      UserGroup? groupData;
      bool isGroupMember = false;

      if (widget.groupId != null) {
        final groupDoc = await FirebaseFirestore.instance
            .collection('user_groups')
            .doc(widget.groupId)
            .get();

        if (groupDoc.exists) {
          groupData = UserGroup.fromMap(groupDoc.id, groupDoc.data()!);

          // Check if user is group member
          if (authState?.user != null) {
            isGroupMember = groupData.members.contains(authState!.user!.uid);
          }
        }
      }

      // Load current RSVP
      final rsvpService = ref.read(publicRSVPServiceProvider);
      final currentRSVP = await rsvpService.getRSVP(
        meetingId: widget.meetingId,
        userId: authState?.user?.uid,
        guestToken: widget.guestToken,
      );

      setState(() {
        _isLoading = false;
        _canAccess = true;
        _meetingData = meetingData;
        _groupData = groupData;
        _isGroupMember = isGroupMember;
        _currentRSVP = currentRSVP;
      });
    } catch (e) {
      print('Error loading meeting data: $e');
      setState(() {
        _isLoading = false;
        _canAccess = false;
      });
    }
  }

  Future<void> _submitRSVP(RSVPStatus status) async {
    try {
      final authState = ref.read(authStateProvider);
      final rsvpService = ref.read(publicRSVPServiceProvider);

      final success = await rsvpService.submitRSVP(
        meetingId: widget.meetingId,
        userId: authState?.user?.uid ?? 'guest',
        status: status,
        groupId: widget.groupId,
        guestToken: widget.guestToken,
        guestName: authState?.user?.displayName,
        guestEmail: authState?.user?.email,
      );

      if (success) {
        setState(() {
          _currentRSVP = status;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('RSVP submitted: ${status.displayName}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error submitting RSVP: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_canAccess) {
      return _buildAccessDenied();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_meetingData?['title'] ?? 'Meeting'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Source banner
            if (widget.source != null) _buildSourceBanner(),

            // Meeting details
            _buildMeetingDetails(),

            // Group info
            if (_groupData != null) _buildGroupInfo(),

            // RSVP section
            _buildRSVPSection(),

            // RSVP summary
            _buildRSVPSummary(),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccessDenied() {
    return Scaffold(
      appBar: AppBar(title: const Text('Access Denied')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Access Denied',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'You don\'t have permission to view this meeting.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceBanner() {
    final source = widget.source;
    if (source == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _getSourceColor(source).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getSourceColor(source).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(_getSourceIcon(source), color: _getSourceColor(source)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Shared via ${_getSourceDisplayName(source)}',
              style: TextStyle(
                color: _getSourceColor(source),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeetingDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _meetingData?['title'] ?? 'Untitled Meeting',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            if (_meetingData?['description'] != null) ...[
              Text(
                _meetingData!['description'],
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
            ],
            _buildMeetingInfoRow(
                'Date & Time', _meetingData?['dateTime']?.toString() ?? 'TBD'),
            _buildMeetingInfoRow(
                'Duration', '${_meetingData?['duration']?.inHours ?? 1} hours'),
            _buildMeetingInfoRow(
                'Type', _meetingData?['meetingType'] ?? 'Meeting'),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.group, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  'Group Meeting',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                if (_isGroupMember)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Member',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _groupData!.name,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            if (_groupData!.description != null) ...[
              const SizedBox(height: 4),
              Text(
                _groupData!.description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${_groupData!.memberCount} members',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRSVPSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Will you attend?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _submitRSVP(RSVPStatus.accepted),
                    icon: const Icon(Icons.check),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _submitRSVP(RSVPStatus.declined),
                    icon: const Icon(Icons.close),
                    label: const Text('Decline'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _submitRSVP(RSVPStatus.maybe),
                    icon: const Icon(Icons.help),
                    label: const Text('Maybe'),
                  ),
                ),
              ],
            ),
            if (_currentRSVP != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _currentRSVP!.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(_currentRSVP!.icon, color: _currentRSVP!.color),
                    const SizedBox(width: 8),
                    Text(
                      'Your RSVP: ${_currentRSVP!.displayName}',
                      style: TextStyle(
                        color: _currentRSVP!.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRSVPSummary() {
    return Consumer(
      builder: (context, ref, child) {
        final rsvpSummaryAsync =
            ref.watch(meetingRSVPSummaryProvider(widget.meetingId));

        return rsvpSummaryAsync.when(
          data: (summary) {
            if (summary.isEmpty) return const SizedBox.shrink();

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RSVP Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildRSVPStat(
                            'Accepted', summary['accepted'] ?? 0, Colors.green),
                        _buildRSVPStat(
                            'Declined', summary['declined'] ?? 0, Colors.red),
                        _buildRSVPStat(
                            'Maybe', summary['maybe'] ?? 0, Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildRSVPStat(String label, int count, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            count.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (!_isGroupMember && widget.groupId != null) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/group-invite/${widget.groupId}'),
              icon: const Icon(Icons.group_add),
              label: const Text('Join Group to Participate'),
            ),
          ),
          const SizedBox(height: 12),
        ],
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.go('/'),
            icon: const Icon(Icons.home),
            label: const Text('Back to Home'),
          ),
        ),
      ],
    );
  }

  Widget _buildMeetingInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Color _getSourceColor(String source) {
    switch (source) {
      case 'whatsappGroup':
        return const Color(0xFF25D366);
      case 'telegramGroup':
        return const Color(0xFF0088CC);
      case 'signalGroup':
        return const Color(0xFF3A76F0);
      case 'discord':
        return const Color(0xFF5865F2);
      case 'messenger':
        return const Color(0xFF0084FF);
      default:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getSourceIcon(String source) {
    switch (source) {
      case 'whatsappGroup':
        return Icons.whatsapp;
      case 'telegramGroup':
        return Icons.telegram;
      case 'signalGroup':
        return Icons.signal_cellular_alt;
      case 'discord':
        return Icons.discord;
      case 'messenger':
        return Icons.facebook;
      default:
        return Icons.share;
    }
  }

  String _getSourceDisplayName(String source) {
    switch (source) {
      case 'whatsappGroup':
        return 'WhatsApp';
      case 'telegramGroup':
        return 'Telegram';
      case 'signalGroup':
        return 'Signal';
      case 'discord':
        return 'Discord';
      case 'messenger':
        return 'Messenger';
      default:
        return source;
    }
  }
}


