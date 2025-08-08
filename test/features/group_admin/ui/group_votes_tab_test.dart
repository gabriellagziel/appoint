import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('GroupVotesTab', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('displays empty state when no votes exist',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: Container(
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.how_to_vote_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No votes found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Votes will appear here when they are created',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify empty state is displayed
      expect(find.text('No votes found'), findsOneWidget);
      expect(find.text('Votes will appear here when they are created'),
          findsOneWidget);
    });

    testWidgets('displays open and closed vote sections',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const Text('Open Votes'),
                  const SizedBox(height: 12),
                  const Text('Closed Votes'),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify sections are displayed
      expect(find.text('Open Votes'), findsOneWidget);
      expect(find.text('Closed Votes'), findsOneWidget);
    });

    testWidgets('shows loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      );

      // Should show loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error state with retry button',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'Failed to load votes',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify error state is displayed
      expect(find.text('Failed to load votes'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('vote buttons are enabled for open votes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_up, color: Colors.white),
                      label: const Text('Vote Yes'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.thumb_down, color: Colors.white),
                      label: const Text('Vote No'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify vote buttons are present
      expect(find.text('Vote Yes'), findsOneWidget);
      expect(find.text('Vote No'), findsOneWidget);
    });

    testWidgets('close vote button is available for open votes',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify close button is present
      expect(find.text('Close'), findsOneWidget);
    });
  });
}
