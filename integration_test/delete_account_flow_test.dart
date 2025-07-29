import 'package:appoint/main.dart' as app;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  REDACTED_TOKEN.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(
      host: 'localhost:8080',
      sslEnabled: false,
      persistenceEnabled: false,
    );
    await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  });

  tearDownAll(() async {
    await FirebaseAuth.instance.signOut();
  });

  testWidgets('Delete My Account flow deletes user and data', (tester) async {
    // Seed test user and docs
    const testEmail = 'delete_test@example.com';
    const testPassword = 'testpassword';
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
    );
    final uid = userCredential.user!.uid;
    await firestore
        .collection('users')
        .doc(uid)
        .set({'name': 'Delete Me', 'email': testEmail});
    await firestore.collection('bookings').add({'userId': uid, 'info': 'test'});
    await firestore.collection('chats').add({'userId': uid, 'msg': 'hi'});
    await firestore.collection('profiles').doc(uid).set({'bio': 'bye'});
    await auth.signInWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
    );
    expect(auth.currentUser, isNotNull);
    expect(auth.currentUser!.uid, equals(uid));
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));
    profileTab = find.text('Profile');
    if (profileTab.evaluate().isEmpty) {
      profileIcon = find.byIcon(Icons.person);
      if (profileIcon.evaluate().isNotEmpty) {
        await tester.tap(profileIcon);
        await tester.pumpAndSettle();
      }
    } else {
      await tester.tap(profileTab);
      await tester.pumpAndSettle();
    }
    deleteButton = find.text('Delete My Account');
    expect(deleteButton, findsOneWidget);
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();
    confirmDelete = find.widgetWithText(TextButton, 'Delete Account');
    expect(confirmDelete, findsOneWidget);
    await tester.tap(confirmDelete);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(auth.currentUser, isNull);
    userDoc = await firestore.collection('users').doc(uid).get();
    expect(userDoc.exists, isFalse);
    final bookings = await firestore
        .collection('bookings')
        .where('userId', isEqualTo: uid)
        .get();
    expect(bookings.docs, isEmpty);
    final chats = await firestore
        .collection('chats')
        .where('userId', isEqualTo: uid)
        .get();
    expect(chats.docs, isEmpty);
    profileDoc = await firestore.collection('profiles').doc(uid).get();
    expect(profileDoc.exists, isFalse);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Delete account confirmation dialog shows correct content',
      (tester) async {
    // Arrange: Create and login test user
    const testEmail = 'confirm_test@example.com';
    const testPassword = 'testpassword';
    final auth = FirebaseAuth.instance;

    await auth.createUserWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
    );
    await auth.signInWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
    );

    // Start app and navigate to profile
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Navigate to Profile screen
    profileTab = find.text('Profile');
    if (profileTab.evaluate().isNotEmpty) {
      await tester.tap(profileTab);
      await tester.pumpAndSettle();
    }

    // Tap delete button
    deleteButton = find.text('Delete My Account');
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Assert confirmation dialog content
    expect(find.text('Delete Account'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.textContaining('Are you sure'), findsOneWidget);
    expect(find.textContaining('permanent'), findsOneWidget);
  });

  testWidgets('Cancel delete account closes dialog without deletion',
      (tester) async {
    // Arrange: Create and login test user
    const testEmail = 'cancel_test@example.com';
    const testPassword = 'testpassword';
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    final userCredential = await auth.createUserWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
    );
    final uid = userCredential.user!.uid;

    // Seed some data
    await firestore.collection('users').doc(uid).set({
      'name': 'Cancel Test',
      'email': testEmail,
    });

    await auth.signInWithEmailAndPassword(
      email: testEmail,
      password: testPassword,
    );

    // Start app and navigate to profile
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Navigate to Profile screen
    profileTab = find.text('Profile');
    if (profileTab.evaluate().isNotEmpty) {
      await tester.tap(profileTab);
      await tester.pumpAndSettle();
    }

    // Tap delete button
    deleteButton = find.text('Delete My Account');
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    // Tap cancel button
    cancelButton = find.text('Cancel');
    await tester.tap(cancelButton);
    await tester.pumpAndSettle();

    // Assert dialog is closed and user/data still exists
    expect(find.text('Delete Account'), findsNothing);
    expect(auth.currentUser, isNotNull);

    userDoc = await firestore.collection('users').doc(uid).get();
    expect(userDoc.exists, isTrue);
  });
}
