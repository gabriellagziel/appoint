// ignore_for_file: subtype_of_sealed_class
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Simple in-memory implementation of [FirebaseFirestore] for tests.
class FakeFirebaseFirestore implements FirebaseFirestore {
  final Map<String, Map<String, Map<String, dynamic>>> _storage = {};

  @override
  CollectionReference<Map<String, dynamic>> collection(final String path) {
    return _FakeCollectionReference(this, path);
  }

  // ignore: no-empty-block
  @override
  // coverage:ignore-start
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeCollectionReference
    implements CollectionReference<Map<String, dynamic>> {
  final FakeFirebaseFirestore _fs;
  final String _path;

  _FakeCollectionReference(this._fs, this._path);

  Map<String, Map<String, dynamic>> get _col =>
      _fs._storage[_path] ??= <String, Map<String, dynamic>>{};

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(
      final Map<String, dynamic> data) async {
    final id = DateTime.now().microsecondsSinceEpoch.toString();
    _col[id] = Map<String, dynamic>.from(data);
    return _FakeDocumentReference(_fs, '$_path/$id');
  }

  @override
  DocumentReference<Map<String, dynamic>> doc([final String? id]) {
    final docId = id ?? DateTime.now().microsecondsSinceEpoch.toString();
    _col.putIfAbsent(docId, () => <String, dynamic>{});
    return _FakeDocumentReference(_fs, '$_path/$docId');
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([final GetOptions? options]) async {
    final docs = _col.entries
        .map((final e) => _FakeQueryDocumentSnapshot(e.key, e.value))
        .toList();
    return _FakeQuerySnapshot(docs);
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> snapshots({
    final bool includeMetadataChanges = false,
    final ListenSource source = ListenSource.defaultSource,
  }) async* {
    yield await get();
  }

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeDocumentReference
    implements DocumentReference<Map<String, dynamic>> {
  final FakeFirebaseFirestore _fs;
  final String _path;

  _FakeDocumentReference(this._fs, this._path);

  Map<String, dynamic>? get _data {
    final parts = _path.split('/');
    return _fs._storage[parts[0]]?[parts[1]];
  }

  set _data(final Map<String, dynamic>? value) {
    final parts = _path.split('/');
    if (value == null) {
      _fs._storage[parts[0]]?.remove(parts[1]);
    } else {
      _fs._storage[parts[0]] ??= {};
      _fs._storage[parts[0]]![parts[1]] = value;
    }
  }

  @override
  String get id => _path.split('/').last;

  @override
  String get path => _path;

  @override
  CollectionReference<Map<String, dynamic>> get parent =>
      _FakeCollectionReference(_fs, _path.split('/').first);

  @override
  Future<void> set(final Map<String, dynamic> data, [final SetOptions? options]) async {
    _data = Map<String, dynamic>.from(data);
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([final GetOptions? options]) async {
    return _FakeDocumentSnapshot(id, _data);
  }

  @override
  Future<void> delete() async {
    _data = null;
  }

  @override
  Future<void> update(final Map<Object, Object?> data) async {
    final current = _data ?? <String, dynamic>{};
    current.addAll(Map<String, dynamic>.from(data));
    _data = current;
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots({
    final bool includeMetadataChanges = false,
    final ListenSource source = ListenSource.defaultSource,
  }) async* {
    yield await get();
  }

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeDocumentSnapshot
    implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic>? _data;

  _FakeDocumentSnapshot(this._id, this._data);

  @override
  Map<String, dynamic>? data() => _data == null ? null : Map.from(_data!);

  @override
  String get id => _id;

  @override
  bool get exists => _data != null;

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeQuerySnapshot
    implements QuerySnapshot<Map<String, dynamic>> {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _docs;
  _FakeQuerySnapshot(this._docs);

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => _docs;

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(final Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeQueryDocumentSnapshot extends _FakeDocumentSnapshot
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  _FakeQueryDocumentSnapshot(final String id, final Map<String, dynamic> data)
      : super(id, data);

  @override
  Map<String, dynamic> data() => Map.from(super.data()!);
}
