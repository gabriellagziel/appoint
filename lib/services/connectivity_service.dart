import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Singleton service that exposes the current connectivity status and
/// a broadcast stream for changes across the entire application.
class ConnectivityService {
  ConnectivityService._internal() {
    _init();
  }

  static final ConnectivityService instance = ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<ConnectivityResult> _controller =
      StreamController<ConnectivityResult>.broadcast();

  /// Returns a broadcast stream of [ConnectivityResult] updates.
  Stream<ConnectivityResult> get onStatusChange => _controller.stream;

  /// The latest connectivity status. Defaults to [ConnectivityResult.none]
  /// until [_init] completes.
  ConnectivityResult _latestStatus = ConnectivityResult.none;
  ConnectivityResult get latestStatus => _latestStatus;

  Future<void> _init() async {
    // Get the initial connectivity status.
    final initialStatus = await _connectivity.checkConnectivity();
    _updateStatus(initialStatus);

    // Listen for subsequent changes.
    _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(ConnectivityResult result) {
    if (result == _latestStatus) return;
    _latestStatus = result;
    _controller.add(result);
  }

  /// Convenience getter to know if we are offline.
  bool get isOffline => _latestStatus == ConnectivityResult.none;

  /// Dispose the internal controller. Call this from tests or when the app is
  /// shutting down. In normal app lifecycle this is never required because the
  /// service is a top-level singleton that lives as long as the isolate.
  Future<void> dispose() async {
    await _controller.close();
  }
}