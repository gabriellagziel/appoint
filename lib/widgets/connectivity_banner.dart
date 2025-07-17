import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

/// Displays a dismissible banner at the top of the screen whenever the device
/// has **no** active network connectivity.
///
/// Wrap any route (or the whole application) with this widget to keep the user
/// informed about connectivity problems. The banner slides in/out smoothly and
/// can be tested with a custom [connectivityStream].
class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({
    required this.child,
    this.connectivityStream,
    super.key,
  });

  /// The widget below this banner in the tree.
  final Widget child;

  /// Provide a custom [ConnectivityResult] stream (e.g. in widget tests). If
  /// `null`, the banner will listen to [Connectivity.onConnectivityChanged].
  final Stream<ConnectivityResult>? connectivityStream;

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  bool _isOffline = false;
  late final Stream<ConnectivityResult> _stream;
  late final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult>? _subscription;

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    _stream = widget.connectivityStream ?? _connectivity.onConnectivityChanged;

    // Listen for connectivity changes.
    _subscription = _stream.listen(_updateStatus);

    // Check initial status (only if we are using the real connectivity API).
    if (widget.connectivityStream == null) {
      _initializeStatus();
    }
  }

  Future<void> _initializeStatus() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(ConnectivityResult result) {
    final offline = result == ConnectivityResult.none;
    if (mounted && offline != _isOffline) {
      setState(() => _isOffline = offline);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          widget.child,
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            top: _isOffline ? 0 : -60,
            left: 0,
            right: 0,
            child: Material(
              color: Colors.red,
              elevation: 4,
              child: SafeArea(
                bottom: false,
                child: Container(
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