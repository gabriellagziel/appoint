import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/main.dart' as app;

void main() {
  REDACTED_TOKEN.ensureInitialized();

  testWidgets('edit profile flow', (tester) async {
    await app.appMain();
    await tester.pumpAndSettle();

    expect(find.text('Welcome'), findsOneWidget);

    await tester.tap(find.text('My Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Profile'), findsOneWidget);
    await tester.tap(find.text('Edit Profile'));
    await tester.pumpAndSettle();

    await tester.enterText(find.bySemanticsLabel('Name'), 'John Doe');
    await tester.enterText(find.bySemanticsLabel('Bio'), 'Hello');
    await tester.enterText(find.bySemanticsLabel('Location'), 'Earth');

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });
}
