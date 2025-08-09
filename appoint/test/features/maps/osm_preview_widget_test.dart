import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../../../lib/features/meeting/widgets/meeting_map_preview.dart';
import '../../../lib/models/location.dart';

void main() {
  group('OSM Map Preview Widget Tests', () {
    late Location testLocation;

    setUp(() {
      testLocation = const Location(
        latitude: 37.7749,
        longitude: -122.4194,
        name: 'Test Location',
        address: '123 Test Street, San Francisco, CA',
      );
    });

    testWidgets('should render map preview with location',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeetingMapPreview(
              location: testLocation,
            ),
          ),
        ),
      );

      // Should render the map container
      expect(find.byType(Container), findsOneWidget);

      // Should show location name overlay
      expect(find.text('Test Location'), findsOneWidget);

      // Should show attribution
      expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
    });

    testWidgets('should render map preview without location name',
        (WidgetTester tester) async {
      const locationWithoutName = Location(
        latitude: 37.7749,
        longitude: -122.4194,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MeetingMapPreview(
              location: locationWithoutName,
            ),
          ),
        ),
      );

      // Should not show location name overlay
      expect(find.text('Test Location'), findsNothing);

      // Should still show attribution
      expect(find.text('© OpenStreetMap contributors'), findsOneWidget);
    });

    testWidgets('should render map preview without attribution',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeetingMapPreview(
              location: testLocation,
              showAttribution: false,
            ),
          ),
        ),
      );

      // Should not show attribution
      expect(find.text('© OpenStreetMap contributors'), findsNothing);

      // Should still show location name
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('should render map preview with custom height',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeetingMapPreview(
              location: testLocation,
              height: 300,
            ),
          ),
        ),
      );

      // Should render with custom height
      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.maxHeight, equals(300));
    });

    testWidgets('should handle special characters in location name',
        (WidgetTester tester) async {
      const locationWithSpecialChars = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        name: 'Café & Restaurant (Downtown)',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MeetingMapPreview(
              location: locationWithSpecialChars,
            ),
          ),
        ),
      );

      // Should show location name with special characters
      expect(find.text('Café & Restaurant (Downtown)'), findsOneWidget);
    });

    testWidgets('should handle long location names with ellipsis',
        (WidgetTester tester) async {
      const locationWithLongName = Location(
        latitude: 37.7749,
        longitude: -122.4194,
        name:
            'This is a very long location name that should be truncated with ellipsis when it exceeds the available space',
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MeetingMapPreview(
              location: locationWithLongName,
            ),
          ),
        ),
      );

      // Should show truncated location name
      expect(
          find.text(
              'This is a very long location name that should be truncated with ellipsis when it exceeds the available space'),
          findsOneWidget);
    });

    testWidgets('should render with proper styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MeetingMapPreview(
              location: testLocation,
            ),
          ),
        ),
      );

      // Should have rounded corners
      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, isNotNull);

      // Should have border
      expect(decoration.border, isNotNull);
    });
  });
}
