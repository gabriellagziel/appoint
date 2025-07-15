import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalMeetingsScreen extends ConsumerWidget {
  const ExternalMeetingsScreen({super.key});

  @override
  Widget build(BuildContext context, final WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not authenticated')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('External Meetings')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('externalMeetings')
            .where('businessProfileId', isEqualTo: user.uid)
            .orderBy('date', descending: true)
            .snapshots(),
        builder: (context, final snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final meetings = snapshot.data?.docs ?? [];

          if (meetings.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.meeting_room, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No external meetings found.'),
                  SizedBox(height: 8),
                  Text('Create meetings through your booking system.',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meetings.length,
            itemBuilder: (context, final index) {
              final meeting = meetings[index].data()! as Map<String, dynamic>;
              final meetingId = meetings[index].id;
              final hasLocation = meeting['latitude'] != null && meeting['longitude'] != null;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: hasLocation ? Colors.green : Colors.blue,
                        child: Icon(
                          hasLocation ? Icons.location_on : Icons.video_call,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        meeting['title'] ?? 'Meeting',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${meeting['date']}'),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text('${meeting['time']}'),
                            ],
                          ),
                          if (meeting['description'] != null) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.description, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(child: Text(meeting['description'])),
                              ],
                            ),
                          ],
                          if (meeting['address'] != null) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(child: Text(meeting['address'])),
                              ],
                            ),
                          ],
                          if (meeting['link'] != null) ...[
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.link, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    meeting['link'],
                                    style: const TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'details',
                            child: Row(
                              children: [
                                Icon(Icons.info, size: 16),
                                SizedBox(width: 8),
                                Text('Details'),
                              ],
                            ),
                          ),
                          if (meeting['link'] != null)
                            const PopupMenuItem(
                              value: 'join',
                              child: Row(
                                children: [
                                  Icon(Icons.video_call, size: 16),
                                  SizedBox(width: 8),
                                  Text('Join'),
                                ],
                              ),
                            ),
                          if (hasLocation)
                            const PopupMenuItem(
                              value: 'directions',
                              child: Row(
                                children: [
                                  Icon(Icons.directions, size: 16),
                                  SizedBox(width: 8),
                                  Text('Directions'),
                                ],
                              ),
                            ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 16, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                        onSelected: (value) {
                          switch (value) {
                            case 'details':
                              _showMeetingDetails(context, meeting, meetingId);
                              break;
                            case 'join':
                              _joinMeeting(meeting['link']);
                              break;
                            case 'directions':
                              _openDirections(meeting['latitude'], meeting['longitude']);
                              break;
                            case 'delete':
                              _deleteMeeting(context, meetingId);
                              break;
                          }
                        },
                      ),
                    ),
                    // Show mini map if location is available
                    if (hasLocation)
                      Container(
                        height: 120,
                        margin: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(
                                meeting['latitude'].toDouble(),
                                meeting['longitude'].toDouble(),
                              ),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: MarkerId(meetingId),
                                position: LatLng(
                                  meeting['latitude'].toDouble(),
                                  meeting['longitude'].toDouble(),
                                ),
                                infoWindow: InfoWindow(
                                  title: meeting['title'] ?? 'Meeting Location',
                                  snippet: meeting['address'],
                                ),
                              ),
                            },
                            zoomControlsEnabled: false,
                            scrollGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                            rotateGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            onTap: (_) => _showMeetingDetails(context, meeting, meetingId),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _joinMeeting(String? link) async {
    if (link == null) return;
    final uri = Uri.parse(link);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _openDirections(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) return;
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showMeetingDetails(BuildContext context, Map<String, dynamic> meeting, String meetingId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: MeetingDetailsView(
                  meeting: meeting,
                  meetingId: meetingId,
                  scrollController: scrollController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteMeeting(BuildContext context, String meetingId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Meeting'),
        content: const Text('Are you sure you want to delete this meeting?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await FirebaseFirestore.instance
            .collection('externalMeetings')
            .doc(meetingId)
            .delete();
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meeting deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error deleting meeting: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}

class MeetingDetailsView extends StatelessWidget {
  final Map<String, dynamic> meeting;
  final String meetingId;
  final ScrollController scrollController;

  const MeetingDetailsView({
    super.key,
    required this.meeting,
    required this.meetingId,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final hasLocation = meeting['latitude'] != null && meeting['longitude'] != null;
    
    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          meeting['title'] ?? 'Meeting',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        
        _buildDetailRow(Icons.calendar_today, 'Date', meeting['date']),
        _buildDetailRow(Icons.access_time, 'Time', meeting['time']),
        
        if (meeting['description'] != null)
          _buildDetailRow(Icons.description, 'Description', meeting['description']),
        
        if (meeting['link'] != null)
          _buildLinkRow(Icons.link, 'Meeting Link', meeting['link']),
        
        if (meeting['address'] != null)
          _buildDetailRow(Icons.location_on, 'Address', meeting['address']),
        
        if (hasLocation) ...[
          const SizedBox(height: 20),
          const Text(
            'Location',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    meeting['latitude'].toDouble(),
                    meeting['longitude'].toDouble(),
                  ),
                  zoom: 16,
                ),
                markers: {
                  Marker(
                    markerId: MarkerId(meetingId),
                    position: LatLng(
                      meeting['latitude'].toDouble(),
                      meeting['longitude'].toDouble(),
                    ),
                    infoWindow: InfoWindow(
                      title: meeting['title'] ?? 'Meeting Location',
                      snippet: meeting['address'],
                    ),
                  ),
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () => _openDirections(
              meeting['latitude']?.toDouble(),
              meeting['longitude']?.toDouble(),
            ),
            icon: const Icon(Icons.directions),
            label: const Text('Get Directions'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkRow(IconData icon, String label, String? link) {
    if (link == null) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => _launchUrl(link),
                  child: Text(
                    link,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDirections(double? latitude, double? longitude) async {
    if (latitude == null || longitude == null) return;
    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
