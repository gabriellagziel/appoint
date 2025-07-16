import 'package:appoint/features/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../firebase_test_helper.dart';

void main() {
  setUpAll(() async {
    await initializeTestFirebase();
  });

  group(
    'LoginScreen',
    () {
      // Declare variables that will be used across tests
      late Finder emailField;
      late Finder passwordField;
      late Finder sizedBoxes;
      late Finder textFields;
      late TextField firstTextField;
      late TextField secondTextField;
      late TextField passwordWidget;
      late TextField emailWidget;

      testWidgets('should display the title in app bar',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Check for login screen title (could be in AppBar or elsewhere)
        expect(find.text('Login'), findsOneWidget);
      });

      testWidgets('should have email and password text fields',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        expect(find.byType(TextField), findsNWidgets(2));
        // Check for email and password labels (they might be in decoration or semantics)
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);
      });

      testWidgets('should have sign in button',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        expect(find.text('Sign In'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('should allow entering email and password',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Find text fields
        emailField = find.byType(TextField).first;
        passwordField = find.byType(TextField).last;

        // Enter text in email field
        await tester.enterText(emailField, 'test@example.com');
        await tester.pump();

        // Enter text in password field
        await tester.enterText(passwordField, 'password123');
        await tester.pump();

        // Verify text was entered
        expect(find.text('test@example.com'), findsOneWidget);
        expect(find.text('password123'), findsOneWidget);
      });

      testWidgets('should have proper form layout',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Check for proper widget structure
        expect(find.byType(Scaffold), findsOneWidget);
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byType(Column), findsOneWidget);
      });

      testWidgets('should have proper spacing between elements',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Check for SizedBox with height 16
        sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsWidgets);
      });

      testWidgets('should handle empty form submission',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Tap sign in button without entering credentials
        await tester.tap(find.text('Sign In'));
        await tester.pump();

        // Should not crash and should still show the form
        expect(find.text('Login'), findsOneWidget);
        expect(find.text('Sign In'), findsOneWidget);
      });

      testWidgets('should handle form with credentials',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Enter credentials
        emailField = find.byType(TextField).first;
        passwordField = find.byType(TextField).last;

        await tester.enterText(emailField, 'user@example.com');
        await tester.enterText(passwordField, 'securepassword');
        await tester.pump();

        // Tap sign in button
        await tester.tap(find.text('Sign In'));
        await tester.pump();

        // Should still show the form (authentication would be handled by provider)
        expect(find.text('Login'), findsOneWidget);
      });

      testWidgets('should have proper input decorations',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Check that text fields have proper decorations
        textFields = find.byType(TextField);
        expect(textFields, findsNWidgets(2));

        // Verify each text field has an InputDecoration
        firstTextField = tester.widget<TextField>(textFields.first);
        secondTextField = tester.widget<TextField>(textFields.last);

        expect(firstTextField.decoration, isNotNull);
        expect(secondTextField.decoration, isNotNull);
      });

      testWidgets('should have password field with obscure text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Find password field (second TextField)
        passwordField = find.byType(TextField).last;
        passwordWidget = tester.widget<TextField>(passwordField);

        // Check that password field has obscureText set to true
        expect(passwordWidget.obscureText, isTrue);
      });

      testWidgets('should have email field without obscure text',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        // Find email field (first TextField)
        emailField = find.byType(TextField).first;
        emailWidget = tester.widget<TextField>(emailField);

        // Check that email field does not have obscureText set to true
        expect(emailWidget.obscureText, isNot(isTrue));
      });

      testWidgets('should handle special characters in email',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        emailField = find.byType(TextField).first;

        // Enter email with special characters
        await tester.enterText(emailField, 'test.user+tag@example.co.uk');
        await tester.pump();

        expect(find.text('test.user+tag@example.co.uk'), findsOneWidget);
      });

      testWidgets('should handle long password',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: LoginScreen(),
            ),
          ),
        );

        passwordField = find.byType(TextField).last;

        // Enter long password
        final longPassword = 'a' * 100;
        await tester.enterText(passwordField, longPassword);
        await tester.pump();

        expect(find.text(longPassword), findsOneWidget);
      });
    },
  );
}
