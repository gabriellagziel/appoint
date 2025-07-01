import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/components/common/app_scaffold.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  group('AppScaffold', () {
    testWidgets('renders with title', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            title: 'Home',
            child: Text('content'),
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SafeArea), findsOneWidget);
    });

    testWidgets('renders without title', (final tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(child: Text('content')),
        ),
      );

      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(SafeArea), findsOneWidget);
    });
  });
}
