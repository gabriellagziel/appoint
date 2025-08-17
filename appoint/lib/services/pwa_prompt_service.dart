// ignore_for_file: avoid_web_libraries_in_flutter
// Minimal web JS interop for PWA install events.
// For Flutter web only: hooks window events and updates Firestore on install.
import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PwaInstallHook {
  static bool _initialized = false;

  static void init() {
    if (_initialized) return;
    _initialized = true;
    try {
      html.window.addEventListener('appinstalled', (event) async {
        try {
          final uid = FirebaseAuth.instance.currentUser?.uid;
          if (uid != null) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .set({'hasInstalledPwa': true}, SetOptions(merge: true));
          }
        } catch (_) {}
      });
    } catch (_) {
      // ignore: avoid_print
      print('PWA hook not available (non-web platform).');
    }
  }
}
