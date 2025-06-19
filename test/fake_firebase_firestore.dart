import 'package:cloud_firestore/cloud_firestore.dart';

/// A minimal in-memory fake for Firestore used in unit tests.
class FakeFirebaseFirestore implements FirebaseFirestore {
  final Map<String, Map<String, Map<String, dynamic>>> _storage = {};

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) {
    return _FakeCollectionReference(this, path);
  }
  // stub any other methods your tests need…
}

class _FakeCollectionReference implements CollectionReference<Map<String, dynamic>> {
  final FakeFirebaseFirestore _fs;
  final String _path;
  _FakeCollectionReference(this._fs, this._path);

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(Map<String, dynamic> data) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _fs._storage[_path] ??= {};
    _fs._storage[_path]![id] = data;
    return _FakeDocumentReference(_fs, '$_path/$id');
  }
  // stub other methods…
}

class _FakeDocumentReference implements DocumentReference<Map<String, dynamic>> {
  final FakeFirebaseFirestore _fs;
  final String _path;
  _FakeDocumentReference(this._fs, this._path);

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get() async {
    final parts = _path.split('/');
    final data = _fs._storage[parts[0]]?[parts[1]];
    return FakeDocumentSnapshot(data ?? {});
  }
  // stub others…
}

class FakeDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic> _data;
  FakeDocumentSnapshot(this._data);
  @override
  Map<String, dynamic>? data() => _data;
  // stub metadata…
}
