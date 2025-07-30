import 'package:appoint/features/studio/ui/content_library_screen.dart';
import 'package:appoint/providers/content_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group('ContentLibraryScreen', () {
    testWidgets('shows placeholder text', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            contentPagingProvider.overrideWith(
              (ref) => ContentPagingNotifier(
                ref.read(contentServiceProvider),
              )..state = const AsyncValue.data([]),
            ),
          ],
          child: const MaterialApp(
            home: ContentLibraryScreen(),
          ),
        ),
      );

      expect(find.text('No content available yet'), findsOneWidget);
    });
  });
}
