import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'features/group/ui/screens/group_join_screen.dart';
import 'features/group/ui/screens/group_management_screen.dart';
import 'features/group/ui/screens/group_details_screen.dart';
import 'features/meeting_public/screens/public_meeting_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('App-Oint Home'),
        ),
      ),
    ),

    // Group Sharing Routes
    GoRoute(
      path: '/group-invite/:code',
      name: 'GroupJoin',
      builder: (context, state) {
        final code = state.pathParameters['code']!;
        return GroupJoinScreen(inviteCode: code);
      },
    ),

    GoRoute(
      path: '/groups',
      name: 'GroupManagement',
      builder: (context, state) => const GroupManagementScreen(),
    ),

    GoRoute(
      path: '/groups/:id',
      name: 'GroupDetails',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return GroupDetailsScreen(groupId: id);
      },
    ),

    // Placeholder routes for other features
    GoRoute(
      path: '/login',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Login Screen'),
        ),
      ),
    ),

    // Meeting Creation Routes
    GoRoute(
      path: '/create-meeting',
      name: 'CreateMeeting',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Create Meeting Flow'),
        ),
      ),
    ),

    // Public Meeting Route
    GoRoute(
      path: '/m/:meetingId',
      name: 'PublicMeeting',
      builder: (context, state) {
        final meetingId = state.pathParameters['meetingId']!;
        final groupId = state.uri.queryParameters['g'];
        final source = state.uri.queryParameters['src'];
        final guestToken = state.uri.queryParameters['token'];

        return PublicMeetingScreen(
          meetingId: meetingId,
          groupId: groupId,
          source: source,
          guestToken: guestToken,
        );
      },
    ),

    GoRoute(
      path: '/select-group',
      name: 'SelectGroupDialog',
      builder: (context, state) => const Scaffold(
        body: Center(
          child: Text('Select Group Dialog'),
        ),
      ),
    ),
  ],
);
