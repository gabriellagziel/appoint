import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';

import 'test_config.dart';

Process? _storageEmulator;

Future<void> _startEmulator() async {
  _storageEmulator = await Process.start(
    'firebase',
    ['emulators:start', '--only', 'storage'],
    mode: ProcessStartMode.detached,
  );
  await Future.delayed(const Duration(seconds: 2));
}

Future<void> _stopEmulator() async {
  _storageEmulator?.kill();
}

Future<void> main() async {
  setupTestConfig();
  await _startEmulator();
  addTearDown(() async {
    await _stopEmulator();
  });
}
