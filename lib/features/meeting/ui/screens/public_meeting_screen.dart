import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/meeting.dart';
import '../../../services/sharing/guest_token_service.dart';
import '../../../services/sharing/share_link_service.dart';
import '../../../services/analytics/meeting_share_analytics_service.dart';
import '../../../services/security/rate_limit_service.dart';
import '../../../services/coppa_service.dart';

/// AUDIT: Public meeting screen for shared meeting links
class PublicMeetingScreen extends StatefulWidget {
  final String meetingId;
  final String? groupId;
  final String? shareId;
  final String? source;
  final String? guestToken;

  const PublicMeetingScreen({
    super.key,
    required this.meetingId,
    this.groupId,
    this.shareId,
    this.source,
    this.guestToken,
  });

  @override
  State<PublicMeetingScreen> createState() => _PublicMeetingScreenState();
}

class _PublicMeetingScreenState extends State<PublicMeetingScreen> {
  Meeting? _meeting;
  bool _isLoading = true;
  String? _errorMessage;
  bool _isGuestTokenValid = false;
  bool _showRSVPForm = false;
  String _rsvpStatus = 'attending';

  final GuestTokenService _guestTokenService = GuestTokenService();
  final ShareLinkService _shareLinkService = ShareLinkService();
  final MeetingShareAnalyticsService _analytics =
      MeetingShareAnalyticsService();
  final RateLimitService _rateLimitService = RateLimitService();

  @override
  void initState() {
    super.initState();
    _loadMeetingData();
  }

  Future<void> _loadMeetingData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Validate share link if provided
      if (widget.shareId != null) {
        try {
          final linkData = await _shareLinkService.validateShareLink(
            widget.shareId!,
            widget.meetingId,
          );

          // Increment usage count
          await _shareLinkService.incrementUsage(widget.shareId!);

          // Track analytics
          await _analytics.trackShareLinkClicked(
            shareId: widget.shareId!,
            meetingId: widget.meetingId,
            groupId: linkData.groupId,
            source: widget.source ?? 'direct',
            guestToken: widget.guestToken,
          );
        } catch (e) {
          setState(() {
            _errorMessage =
                'This share link is no longer valid: ${e.toString()}';
            _isLoading = false;
          });
          return;
        }
      }

      // Validate guest token if provided
      if (widget.guestToken != null) {
        try {
          final claims = await _guestTokenService.validateGuestToken(
            widget.guestToken!,
            widget.meetingId,
          );
          setState(() {
            _isGuestTokenValid = true;
          });

          // Track analytics
          await _analytics.trackGuestTokenValidated(
            meetingId: widget.meetingId,
            token: widget.guestToken!,
            isValid: true,
          );
        } catch (e) {
          setState(() {
            _isGuestTokenValid = false;
          });

          // Track analytics
          await _analytics.trackGuestTokenValidated(
            meetingId: widget.meetingId,
            token: widget.guestToken!,
            isValid: false,
            reason: e.toString(),
          );
        }
      }

      // Load meeting data
      final meetingDoc = await FirebaseFirestore.instance
          .collection('meetings')
          .doc(widget.meetingId)
          .get();

      if (!meetingDoc.exists) {
        setState(() {
          _errorMessage = 'Meeting not found';
          _isLoading = false;
        });
        return;
      }

      final meetingData = meetingDoc.data()!;
      final meeting = Meeting.fromJson(meetingData);

      // Check COPPA compliance
      if (meeting.meetingType == MeetingType.playtime) {
        final isChildContext = await COPPAService.isChildContext();
        if (isChildContext) {
          // Apply child-specific restrictions
          // TODO: Implement child-specific UI and restrictions
        }
      }

      setState(() {
        _meeting = meeting;
        _isLoading = false;
      });

      // Track page view
      await _analytics.trackPublicMeetingPageViewed(
        meetingId: widget.meetingId,
        groupId: widget.groupId,
        shareId: widget.shareId,
        source: widget.source,
        guestToken: widget.guestToken,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading meeting: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _submitRSVP() async {
    if (_meeting == null) return;

    try {
      // Check rate limiting for guest RSVP
      final allowed = await _rateLimitService.allow(
        'guest_rsvp',
        widget.meetingId,
        userAgent: 'web', // In real app, get from request
      );

      if (!allowed) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Too many RSVP attempts. Please try again later.')),
        );
        return;
      }

      // Submit RSVP
      await FirebaseFirestore.instance
          .collection('meetings')
          .doc(widget.meetingId)
          .collection('rsvp')
          .add({
        'status': _rsvpStatus,
        'guestToken': widget.guestToken,
        'submittedAt': FieldValue.serverTimestamp(),
        'source': widget.source ?? 'direct',
        'groupId': widget.groupId,
      });

      // Track analytics
      await _analytics.trackRSVPSubmittedFromShare(
        meetingId: widget.meetingId,
        groupId: widget.groupId,
        guestToken: widget.guestToken,
        status: _rsvpStatus,
        source: widget.source,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RSVP submitted successfully!')),
      );

      setState(() {
        _showRSVPForm = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting RSVP: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading Meeting...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadMeetingData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_meeting == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Meeting Not Found')),
        body: const Center(child: Text('Meeting not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_meeting!.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meeting details
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _meeting!.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    if (_meeting!.description != null) ...[
                      const SizedBox(height: 8),
                      Text(_meeting!.description!),
                    ],
                    const SizedBox(height: 16),
                    _buildMeetingInfoRow(
                        'Date', _formatDate(_meeting!.startTime)),
                    _buildMeetingInfoRow(
                        'Time', _formatTime(_meeting!.startTime)),
                    if (_meeting!.location != null)
                      _buildMeetingInfoRow('Location', _meeting!.location!),
                    if (_meeting!.virtualMeetingUrl != null)
                      _buildMeetingInfoRow(
                          'Virtual Meeting', _meeting!.virtualMeetingUrl!),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Group information if available
            if (widget.groupId != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Group Meeting',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('This meeting is part of a group.'),
                      // TODO: Add group details if user is member
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // RSVP section
            if (_meeting!.visibility?.allowGuestsRSVP == true ||
                _isGuestTokenValid) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RSVP',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      if (!_showRSVPForm) ...[
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showRSVPForm = true;
                            });
                          },
                          child: const Text('RSVP to this meeting'),
                        ),
                      ] else ...[
                        Column(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _rsvpStatus,
                              decoration: const InputDecoration(
                                labelText: 'Will you attend?',
                              ),
                              items: const [
                                DropdownMenuItem(
                                    value: 'attending',
                                    child: Text('Yes, I will attend')),
                                DropdownMenuItem(
                                    value: 'not_attending',
                                    child: Text('No, I cannot attend')),
                                DropdownMenuItem(
                                    value: 'maybe',
                                    child: Text('Maybe, I\'ll let you know')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _rsvpStatus = value!;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _submitRSVP,
                                    child: const Text('Submit RSVP'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showRSVPForm = false;
                                    });
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Access Required',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text('This meeting requires group membership to RSVP.'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to group join flow
                        },
                        child: const Text('Join Group'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
