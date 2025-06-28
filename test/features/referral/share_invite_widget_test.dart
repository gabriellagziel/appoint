import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/referral/share_invite_widget.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  testWidgets('renders share button and QR placeholder', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ShareInviteWidget(referralLink: 'https://example.com'),
    ));

    expect(find.byType(CustomPaint), findsOneWidget);
    expect(find.byIcon(Icons.share), findsOneWidget);
  });
}
