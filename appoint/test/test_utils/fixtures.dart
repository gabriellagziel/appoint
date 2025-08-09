/// Test fixtures for meetings, reminders, family members, and locations

class TestFixtures {
  /// Sample meetings for testing
  static Map<String, dynamic> sampleMeeting({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? participants,
    String? type,
  }) {
    return {
      'id': id ?? 'meeting_1',
      'title': title ?? 'Team Standup',
      'description': description ?? 'Daily team sync',
      'startTime': startTime ?? DateTime.now().add(const Duration(hours: 1)),
      'endTime': endTime ?? DateTime.now().add(const Duration(hours: 2)),
      'location': location ?? 'Conference Room A',
      'participants': participants ?? ['user1', 'user2', 'user3'],
      'type': type ?? 'work',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
  }

  /// Sample playtime meeting
  static Map<String, dynamic> samplePlaytimeMeeting({
    String? id,
    String? subtype,
    String? platform,
    String? location,
  }) {
    return {
      'id': id ?? 'playtime_1',
      'title': 'Gaming Session',
      'description': 'Online gaming with friends',
      'startTime': DateTime.now().add(const Duration(hours: 2)),
      'endTime': DateTime.now().add(const Duration(hours: 4)),
      'type': 'playtime',
      'subtype': subtype ?? 'virtual',
      'platform': platform ?? 'Discord',
      'location': location,
      'participants': ['user1', 'user2'],
      'playtimeConfig': {
        'platform': platform ?? 'Discord',
        'roomCode': 'ABC123',
        'virtual': subtype == 'virtual',
      },
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
  }

  /// Sample reminders for testing
  static Map<String, dynamic> sampleReminder({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? completed,
    String? priority,
  }) {
    return {
      'id': id ?? 'reminder_1',
      'title': title ?? 'Buy groceries',
      'description': description ?? 'Milk, bread, eggs',
      'dueDate': dueDate ?? DateTime.now().add(const Duration(days: 1)),
      'completed': completed ?? false,
      'priority': priority ?? 'medium',
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
  }

  /// Sample family members for testing
  static Map<String, dynamic> sampleFamilyMember({
    String? id,
    String? name,
    String? relationship,
    int? age,
    bool? isChild,
    bool? isApproved,
  }) {
    return {
      'id': id ?? 'family_1',
      'name': name ?? 'John Doe',
      'relationship': relationship ?? 'child',
      'age': age ?? 12,
      'isChild': isChild ?? true,
      'isApproved': isApproved ?? false,
      'pendingApproval': isChild == true && isApproved == false,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
  }

  /// Sample locations for testing
  static Map<String, dynamic> sampleLocation({
    String? placeId,
    String? name,
    String? address,
    double? lat,
    double? lng,
    double? rating,
  }) {
    return {
      'place_id': placeId ?? 'ChIJN1t_tDeuEmsRUsoyG83frY4',
      'name': name ?? 'Central Park',
      'formatted_address': address ?? 'New York, NY 10024, USA',
      'geometry': {
        'location': {
          'lat': lat ?? 40.7829,
          'lng': lng ?? -73.9654,
        },
      },
      'rating': rating ?? 4.5,
      'types': ['park', 'establishment'],
      'vicinity': 'New York, NY',
    };
  }

  /// Sample invite for testing
  static Map<String, dynamic> sampleInvite({
    String? token,
    String? meetingId,
    String? inviterName,
    DateTime? expiresAt,
    bool? singleUse,
    bool? accepted,
    bool? declined,
  }) {
    return {
      'token': token ?? 'invite_token_123',
      'meetingId': meetingId ?? 'meeting_1',
      'inviterName': inviterName ?? 'Alice Smith',
      'meeting': sampleMeeting(id: meetingId),
      'expiresAt': expiresAt ?? DateTime.now().add(const Duration(days: 7)),
      'singleUse': singleUse ?? true,
      'accepted': accepted ?? false,
      'declined': declined ?? false,
      'createdAt': DateTime.now(),
    };
  }

  /// Sample user profile for testing
  static Map<String, dynamic> sampleUserProfile({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    bool? isPremium,
  }) {
    return {
      'id': id ?? 'user_1',
      'name': name ?? 'John Doe',
      'email': email ?? 'john@example.com',
      'photoUrl': photoUrl ?? 'https://example.com/photo.jpg',
      'isPremium': isPremium ?? false,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
  }

  /// Sample notification for testing
  static Map<String, dynamic> sampleNotification({
    String? id,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    DateTime? timestamp,
    bool? read,
  }) {
    return {
      'id': id ?? 'notification_1',
      'title': title ?? 'Meeting Reminder',
      'body': body ?? 'Your meeting starts in 15 minutes',
      'data': data ?? {'meetingId': 'meeting_1'},
      'timestamp': timestamp ?? DateTime.now(),
      'read': read ?? false,
    };
  }

  /// Sample analytics event for testing
  static Map<String, dynamic> sampleAnalyticsEvent({
    String? eventName,
    Map<String, dynamic>? parameters,
    DateTime? timestamp,
  }) {
    return {
      'eventName': eventName ?? 'meeting_created',
      'parameters': parameters ??
          {
            'meeting_type': 'work',
            'participants_count': 3,
          },
      'timestamp': timestamp ?? DateTime.now(),
    };
  }

  /// Sample calendar event for testing
  static Map<String, dynamic> sampleCalendarEvent({
    String? id,
    String? title,
    DateTime? startTime,
    DateTime? endTime,
    String? type,
    Map<String, dynamic>? metadata,
  }) {
    return {
      'id': id ?? 'calendar_1',
      'title': title ?? 'Team Meeting',
      'startTime': startTime ?? DateTime.now().add(const Duration(hours: 1)),
      'endTime': endTime ?? DateTime.now().add(const Duration(hours: 2)),
      'type': type ?? 'meeting',
      'metadata': metadata ?? {'source': 'appoint'},
      'createdAt': DateTime.now(),
    };
  }

  /// Sample deep link URL for testing
  static String sampleDeepLink({
    String? token,
    String? source,
  }) {
    const baseUrl = 'https://appoint.app/join';
    final params = <String, String>{};
    if (token != null) params['token'] = token;
    if (source != null) params['src'] = source;

    if (params.isEmpty) return baseUrl;

    final queryString = params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');

    return '$baseUrl?$queryString';
  }

  /// Sample navigation URL for testing
  static String sampleNavigationUrl({
    required String destination,
    String? name,
    String? platform,
  }) {
    final encodedName = name != null ? Uri.encodeComponent(name) : '';

    switch (platform?.toLowerCase()) {
      case 'google':
        return 'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(destination)}&destination_place_id=${Uri.encodeComponent(destination)}';
      case 'apple':
        return 'http://maps.apple.com/?daddr=${Uri.encodeComponent(destination)}&dirflg=d';
      case 'osm':
      default:
        return 'https://www.openstreetmap.org/directions?from=&to=${Uri.encodeComponent(destination)}';
    }
  }
}
