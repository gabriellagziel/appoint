import 'dart:async';

import 'package:appoint/widgets/connectivity_banner.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConnectivityBanner Widget', () {
    late StreamController<ConnectivityResult> controller;

    setUp(() {
      controller = StreamController<ConnectivityResult>.broadcast();
    });

    tearDown(() async {
      await controller.close();
    });

    Widget _createWidget() => MaterialApp(
          home: ConnectivityBanner(
            connectivityStream: controller.stream,
            child: const Scaffold(body: Text('Home')),
          ),
        );

    testWidgets('displays banner when going offline', (tester) async {
      controller.add(ConnectivityResult.wifi);
      await tester.pumpWidget(_createWidget());
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsNothing);

      controller.add(ConnectivityResult.none);
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsOneWidget);
    });

    testWidgets('hides banner when connectivity is restored', (tester) async {
      controller.add(ConnectivityResult.none);
      await tester.pumpWidget(_createWidget());
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsOneWidget);

      controller.add(ConnectivityResult.mobile);
      await tester.pumpAndSettle();
      expect(find.text('You are offline'), findsNothing);
    });
  });
}