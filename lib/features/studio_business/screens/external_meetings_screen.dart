import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              child: Text('No external meetings found.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: meetings.length,
            itemBuilder: (context, final index) {
              meeting = meetings[index].data()! as Map<String, dynamic>;
              final meetingId = meetings[index].id;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.video_call, color: Colors.white),
                  ),
                  title: Text(meeting['title'] ?? 'Meeting'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${meeting['date']}'),
                      Text('Time: ${meeting['time']}'),
                      if (meeting['description'] != null)
                        Text('Description: ${meeting['description']}'),
                      if (meeting['link'] != null)
                        Text('Link: ${meeting['link']}'),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'join',
                        child: Text('Join'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'join') {
                        _joinMeeting(meeting['link']);
                      } else if (value == 'delete') {
                        _deleteMeeting(meetingId);
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

  void _joinMeeting(String? link) {
    if (link == null) return;
    // In a real app, use url_launcher to open the link
    // Removed debug print: debugPrint('Joining meeting: $link');
  }

  Future<void> _deleteMeeting(String meetingId) async {
    try {
      await FirebaseFirestore.instance
          .collection('externalMeetings')
          .doc(meetingId)
          .delete();
    } catch (e) {e) {
      // Removed debug print: debugPrint('Error deleting meeting: $e');
    }
  }
}
