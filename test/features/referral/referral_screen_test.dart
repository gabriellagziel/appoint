import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appoint/features/referral/referral_screen.dart';
import 'package:appoint/features/referral/share_invite_widget.dart';
import 'package:appoint/providers/referral_provider.dart';
import '../../fake_firebase_setup.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await initializeTestFirebase();

  testWidgets('shows ShareInviteWidget when referral link loads', (tester) async {
    final container = ProviderContainer(overrides: [
      referralLinkProvider.overrideWithValue(const AsyncValue.data('link')),
    ]);

    await tester.pumpWidget(UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: ReferralScreen()),
    ));
    await tester.pump();

    expect(find.byType(ShareInviteWidget), findsOneWidget);
  });
}
