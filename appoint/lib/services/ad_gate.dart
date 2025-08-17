import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Minimal web-friendly Ad gate: shows a 5-second modal countdown.
/// Returns true if completed, false if dismissed/failed.
class AdGate {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<bool> show(BuildContext context) async {
    _log('ad_view_started');
    final completer = Completer<bool>();
    int seconds = 5;
    late StateSetter localSetState;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          localSetState = setState;
          return AlertDialog(
            title: const Text('Thanks for supporting us'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('An ad is playing...'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(child: LinearProgressIndicator()),
                    const SizedBox(width: 8),
                    Text('${seconds}s'),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );

    Timer.periodic(const Duration(seconds: 1), (t) {
      seconds -= 1;
      if (seconds <= 0) {
        t.cancel();
        Navigator.of(context, rootNavigator: true).pop();
        _log('ad_view_completed');
        completer.complete(true);
      } else {
        // Ignore if dialog already gone
        try {
          localSetState(() {});
        } catch (_) {}
      }
    });

    return completer.future.timeout(const Duration(seconds: 10), onTimeout: () {
      _log('ad_view_failed');
      return false;
    });
  }

  static Future<void> _log(String name) async {
    try {
      final uid = _auth.currentUser?.uid ?? '_anon';
      await _fs
          .collection('analytics_events')
          .doc(uid)
          .collection('events')
          .add({
        'name': name,
        'ts': FieldValue.serverTimestamp(),
      });
    } catch (_) {}
  }
}






