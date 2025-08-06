import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_oint/main.dart';

void main() {
  testWidgets('Create Meeting Flow loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: AppOintApp(),
      ),
    );

    // Verify that the Create Meeting Flow title is displayed
    expect(find.text('Create Meeting'), findsOneWidget);
    
    // Verify that the first step (Select Participants) is displayed
    expect(find.text('Select Participants'), findsOneWidget);
    
    // Verify that the progress indicator shows the first step
    expect(find.text('Participants'), findsOneWidget);
    
    // Verify that the Next button is disabled initially (no participants selected)
    final nextButton = find.text('Next');
    expect(nextButton, findsOneWidget);
    
    // The button should be disabled initially since no participants are selected
    final nextButtonWidget = tester.widget<ElevatedButton>(nextButton);
    expect(nextButtonWidget.onPressed, isNull);
  });

  testWidgets('Progress indicator shows correct steps', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppOintApp(),
      ),
    );

    // Verify all six steps are shown in progress indicator
    expect(find.text('Participants'), findsOneWidget);
    expect(find.text('Meeting Type'), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);
    expect(find.text('Forms'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
  });

  testWidgets('Cancel button is present', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: AppOintApp(),
      ),
    );

    // Verify cancel button is present
    expect(find.text('Cancel'), findsOneWidget);
  });
}
