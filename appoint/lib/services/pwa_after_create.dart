import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Simple cadence: every 3rd meeting, if user hasn't installed PWA, show a friendly dialog.
class PwaAfterCreate {
  static final _fs = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> maybePrompt(BuildContext context) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    final doc = _fs.collection('users').doc(uid);
    final snap = await doc.get();
    final data = snap.data() ?? <String, dynamic>{};
    final hasInstalled = data['hasInstalledPwa'] == true;
    final count = (data['userPwaPromptCount'] ?? 0) as int;
    final next = count + 1;
    if (hasInstalled) return;
    await doc.set({'userPwaPromptCount': next}, SetOptions(merge: true));
    if (next % 3 != 0) return;
    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add App-Oint to Home Screen'),
        content: const Text(
            'For a faster, full-screen experience: Add to Home Screen.\n\nAndroid: tap the menu ⋮ and choose "Install app".\niOS: Share → Add to Home Screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Maybe later'),
          ),
          FilledButton(
            onPressed: () async {
              // Mark as installed immediately if the browser reports installed
              try {
                final uid2 = _auth.currentUser?.uid;
                if (uid2 != null) {
                  await _fs.collection('users').doc(uid2).set({
                    'hasInstalledPwa': true,
                  }, SetOptions(merge: true));
                }
              } catch (_) {}
              // Close dialog
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
