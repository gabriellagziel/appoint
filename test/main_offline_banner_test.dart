import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Minimal offline banner widget for testing
class TestOfflineBanner extends StatefulWidget {
  const TestOfflineBanner({
    required this.child,
    required this.connectivityStream,
    super.key,
  });
  final Widget child;
  final Stream<ConnectivityResult> connectivityStream;
  @override
  State<TestOfflineBanner> createState() => _TestOfflineBannerState();
}

class _TestOfflineBannerState extends State<TestOfflineBanner> {
  bool _isOffline = false;
  late StreamSubscription<ConnectivityResult> _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = widget.connectivityStream.listen((result) {
      final offline = result == ConnectivityResult.none;
      if (offline != _isOffline) {
        setState(() {
          _isOffline = offline;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          if (_isOffline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                color: Colors.red,
                elevation: 4,
                child: SafeArea(
                  bottom: false,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: const Text(
                      'You are offline',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      );
}

void main() {
  group('Offline Banner Widget Tests', () {
    late StreamController<ConnectivityResult> connectivityController;

    setUp(() {
      connectivityController = StreamController<ConnectivityResult>.broadcast();
    });

    tearDown(() {
      connectivityController.close();
    });

    Widget createTestWidget() => MaterialApp(
          home: TestOfflineBanner(
            connectivityStream: connectivityController.stream,
            child: const Scaffold(
              body: Center(
                child: Text('Main Content'),
              ),
            ),
          ),
        );

    testWidgets('shows offline banner when connectivity is lost',
        (tester) async {
      connectivityController.add(ConnectivityResult.wifi);
      await tester.pumpWidget(createTestWidget());
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsNothing);
      connectivityController.add(ConnectivityResult.none);
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsOneWidget);
    });

    testWidgets('hides offline banner when connectivity is restored',
        (tester) async {
      // Build widget first, then emit offline event
      await tester.pumpWidget(createTestWidget());
      connectivityController.add(ConnectivityResult.none);
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsOneWidget);

      // Restore connectivity
      connectivityController.add(ConnectivityResult.wifi);
      await tester.pump();
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsNothing);
    });
  });
}
