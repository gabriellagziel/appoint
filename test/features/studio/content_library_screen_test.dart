import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appoint/features/studio/ui/content_library_screen.dart';

void main() {
  testWidgets('ContentLibraryScreen shows placeholder', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ContentLibraryScreen()));
    expect(find.text('No content yet.'), findsOneWidget);
  });
}
