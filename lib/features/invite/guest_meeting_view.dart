import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:appoint/services/whatsapp_group_share_service.dart';
import 'package:appoint/models/invite.dart';
import 'package:firebase_functions/firebase_functions.dart';
import 'package:appoint/features/invite/widgets/app_download_prompt.dart';

class GuestMeetingView extends StatefulWidget {
  const GuestMeetingView({
    super.key,
    required this.appointmentId,
    required this.creatorId,
    this.shareId,
    this.source = InviteSource.whatsapp_group,
  });

  final String appointmentId;
  final String creatorId;
  final String? shareId;
  final InviteSource source;

  @override
  State<GuestMeetingView> createState() => _GuestMeetingViewState();
}

class _GuestMeetingViewState extends State<GuestMeetingView> {
  Map<String, dynamic>? meetingData;
  Map<String, dynamic>? creatorData;
  bool isLoading = true;
  String? error;
  bool isAccepting = false;
  final WhatsAppGroupShareService _shareService = WhatsAppGroupShareService();

  @override
  void initState() {
    super.initState();
    _loadMeetingData();
    _trackGuestView();
  }

  Future<void> _loadMeetingData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Load meeting data
      final meetingDoc = await FirebaseFirestore.instance
          .collection('appointments')
          .doc(widget.appointmentId)
          .get();

      if (!meetingDoc.exists) {
        setState(() {
          error = 'Meeting not found';
          isLoading = false;
        });
        return;
      }

      final meeting = meetingDoc.data()!;
      
      // Load creator data
      final creatorDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.creatorId)
          .get();

      setState(() {
        meetingData = meeting;
        creatorData = creatorDoc.data();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'Error loading meeting: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _trackGuestView() async {
    if (widget.shareId != null) {
      await _shareService.trackLinkClick(
        shareId: widget.shareId!,
        appointmentId: widget.appointmentId,
        userAgent: 'web_guest',
      );
    }
  }

  Future<void> _acceptInvitation() async {
    setState(() {
      isAccepting = true;
    });

    try {
      // Call Firebase function to track guest acceptance
      final functions = FirebaseFunctions.instance;
      final result = await functions.httpsCallable('trackGuestAcceptance').call({
        'appointmentId': widget.appointmentId,
        'creatorId': widget.creatorId,
        'shareId': widget.shareId,
        'source': widget.source.name,
        'userAgent': 'web_guest',
      });

      if (mounted) {
        _showDownloadPrompt();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accepting invitation: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isAccepting = false;
      });
    }
  }

  void _showDownloadPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AppDownloadPrompt(
        meetingTitle: meetingData?['title'] ?? 'Meeting',
        appointmentId: widget.appointmentId,
        shareId: widget.shareId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingView();
    }

    if (error != null) {
      return _buildErrorView();
    }

    return _buildMeetingView();
  }

  Widget _buildLoadingView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Loading meeting details...',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              error!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadMeetingData,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingView() {
    final title = meetingData?['title'] ?? 'Meeting';
    final description = meetingData?['description'] ?? '';
    final scheduledAt = meetingData?['scheduledAt']?.toDate();
    final location = meetingData?['location'];
    final participants = meetingData?['participants']?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meeting Invitation'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMeetingHeader(title, description),
            const SizedBox(height: 24),
            _buildMeetingInfo(scheduledAt, participants),
            if (location != null) ...[
              const SizedBox(height: 24),
              _buildLocationCard(location),
            ],
            const SizedBox(height: 24),
            _buildCreatorInfo(),
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 24),
            _buildDownloadPrompt(),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingHeader(String title, String description) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingInfo(DateTime? scheduledAt, int participants) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (scheduledAt != null) ...[
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(
                  'Date & Time',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  _formatDateTime(scheduledAt),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.people),
              title: Text(
                'Participants',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                '$participants people invited',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> location) {
    final address = location['address'] ?? '';
    final latitude = location['latitude']?.toDouble();
    final longitude = location['longitude']?.toDouble();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 8),
                Text(
                  'Location',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (address.isNotEmpty)
              Text(
                address,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            if (latitude != null && longitude != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(latitude, longitude),
                      zoom: 15,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('meeting_location'),
                        position: LatLng(latitude, longitude),
                        infoWindow: InfoWindow(title: address),
                      ),
                    },
                    myLocationEnabled: false,
                    zoomControlsEnabled: false,
                    mapToolbarEnabled: false,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCreatorInfo() {
    final creatorName = creatorData?['displayName'] ?? 'Meeting Host';
    final creatorEmail = creatorData?['email'] ?? '';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hosted by',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    creatorName.isNotEmpty ? creatorName[0].toUpperCase() : 'H',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        creatorName,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      if (creatorEmail.isNotEmpty)
                        Text(
                          creatorEmail,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: isAccepting ? null : _acceptInvitation,
            icon: isAccepting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.check),
            label: Text(isAccepting ? 'Accepting...' : 'Accept Invitation'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            label: const Text('Decline'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadPrompt() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'To join this meeting and interact with participants, you\'ll need the App-Oint app.',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _downloadApp,
                  icon: const Icon(Icons.download),
                  label: const Text('Download App'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final date = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    final time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$date at $time';
  }

  Future<void> _downloadApp() async {
    // Detect platform and open appropriate store
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    final url = isIOS
        ? 'https://apps.apple.com/app/app-oint/id123456789'
        : 'https://play.google.com/store/apps/details?id=com.appoint.app';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
} 