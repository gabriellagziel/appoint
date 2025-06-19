import 'package:cloud_firestore/cloud_firestore.dart';

class FakeFirebaseFirestore implements FirebaseFirestore {
  final List<Map<String, dynamic>> addedData = [];

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _FakeCollectionReference(addedData);
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeCollectionReference implements CollectionReference<Map<String, dynamic>> {
  final List<Map<String, dynamic>> addedData;
  _FakeCollectionReference(this.addedData);

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(Map<String, dynamic> data) async {
    addedData.add(data);
    return _FakeDocumentReference();
  }

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeDocumentReference implements DocumentReference<Map<String, dynamic>> {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
