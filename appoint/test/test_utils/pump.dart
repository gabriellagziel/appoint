import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper to pump widgets with Riverpod providers
class TestPump {
  static WidgetPumpApp pumpApp({
    required Widget child,
    List<Override> overrides = const [],
    Size surfaceSize = const Size(390, 844), // iPhone 14 size
  }) {
    return WidgetPumpApp(
      overrides: overrides,
      surfaceSize: surfaceSize,
      child: child,
    );
  }

  static WidgetPumpApp pumpTablet({
    required Widget child,
    List<Override> overrides = const [],
  }) {
    return pumpApp(
      child: child,
      overrides: overrides,
      surfaceSize: const Size(768, 1024), // iPad size
    );
  }
}

/// Test app wrapper with Riverpod
class WidgetPumpApp extends StatelessWidget {
  final Widget child;
  final List<Override> overrides;
  final Size surfaceSize;

  const WidgetPumpApp({
    super.key,
    required this.child,
    required this.overrides,
    required this.surfaceSize,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        home: MediaQuery(
          data: MediaQueryData(size: surfaceSize),
          child: child,
        ),
      ),
    );
  }
}

/// Extension for easier widget testing
extension WidgetTesterExtension on WidgetTester {
  /// Pump widget with Riverpod providers
  Future<void> pumpWidgetWithProviders(
    Widget widget, {
    List<Override> overrides = const [],
    Size surfaceSize = const Size(390, 844),
  }) async {
    await pumpWidget(
      TestPump.pumpApp(
        child: widget,
        overrides: overrides,
        surfaceSize: surfaceSize,
      ),
    );
  }

  /// Pump widget for tablet testing
  Future<void> pumpWidgetTablet(
    Widget widget, {
    List<Override> overrides = const [],
  }) async {
    await pumpWidgetWithProviders(
      widget,
      overrides: overrides,
      surfaceSize: const Size(768, 1024),
    );
  }

  /// Pump and wait for animations
  Future<void> pumpAndSettleWithProviders(
    Widget widget, {
    List<Override> overrides = const [],
    Size surfaceSize = const Size(390, 844),
  }) async {
    await pumpWidgetWithProviders(
      widget,
      overrides: overrides,
      surfaceSize: surfaceSize,
    );
    await pumpAndSettle();
  }
}
