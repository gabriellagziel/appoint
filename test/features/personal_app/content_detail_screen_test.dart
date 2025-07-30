import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../fake_firebase_setup.dart';
import 'package:appoint/extensions/fl_chart_color_shim.dart';
import 'package:appoint/features/personal_app/ui/content_detail_screen.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('ContentDetailScreen', () {
    testWidgets('shows placeholder title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: const MaterialApp(
            home: ContentDetailScreen(id: '1'),
          ),
        ),
      );

      expect(find.text('Content Title Placeholder'), findsOneWidget);
    });
  });
}
