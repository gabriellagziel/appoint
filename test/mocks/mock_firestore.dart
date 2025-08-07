import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

// ignore: subtype_of_sealed_class
class MockCollectionRef extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocRef extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

// ignore: subtype_of_sealed_class
class MockDocSnap extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {}

// Setup mock behavior
void setupFirestoreMocks() {
  registerFallbackValue(<String, dynamic>{});
}
