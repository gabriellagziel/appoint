import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../lib/features/group/ui/widgets/group_card.dart';
import '../lib/features/group/ui/widgets/group_empty_state.dart';
import '../lib/models/user_group.dart';

void main() {
  group('Group Sharing UI Tests', () {
    testWidgets('GroupCard displays group information correctly',
        (tester) async {
      final group = UserGroup(
        id: 'test-group-1',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1', 'user-2'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
        description: 'A test group',
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GroupCard(
                group: group,
                currentUserId: 'user-1',
                onTap: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Group'), findsOneWidget);
      expect(find.text('A test group'), findsOneWidget);
      expect(find.text('2 members'), findsOneWidget);
      expect(find.byIcon(Icons.admin_panel_settings), findsOneWidget);
    });

    testWidgets('GroupEmptyState displays correct content', (tester) async {
      bool onCreateGroupCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GroupEmptyState(
              onCreateGroup: () {
                onCreateGroupCalled = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('No Groups Yet'), findsOneWidget);
      expect(find.text('Create Your First Group'), findsOneWidget);
      expect(find.byIcon(Icons.group_add), findsOneWidget);

      await tester.tap(find.text('Create Your First Group'));
      await tester.pump();

      expect(onCreateGroupCalled, isTrue);
    });

    testWidgets('GroupCard handles tap correctly', (tester) async {
      final group = UserGroup(
        id: 'test-group-1',
        name: 'Test Group',
        createdBy: 'user-1',
        members: ['user-1'],
        admins: ['user-1'],
        createdAt: DateTime.now(),
      );

      bool onTapCalled = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: GroupCard(
                group: group,
                currentUserId: 'user-1',
                onTap: () {
                  onTapCalled = true;
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pump();

      expect(onTapCalled, isTrue);
    });
  });
}


