// ignore_for_file: subtype_of_sealed_class, must_be_immutable
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Simple in-memory implementation of [FirebaseFirestore] for tests.
class FakeFirebaseFirestore implements FirebaseFirestore {
  final Map<String, Map<String, Map<String, dynamic>>> _storage = {};

  @override
  CollectionReference<Map<String, dynamic>> collection(String path) =>
      _FakeCollectionReference(this, path);

  @override
  Future<T> runTransaction<T>(
    Future<T> Function(Transaction) updateFunction, {
    Duration timeout = const Duration(seconds: 30),
    final int maxAttempts = 5,
  }) async {
    transaction = _FakeTransaction(this);
    result = await updateFunction(transaction);
    transaction.commit();
    return result;
  }

  // ignore: no-empty-block
  @override
  // coverage:ignore-start
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeCollectionReference
    implements CollectionReference<Map<String, dynamic>> {
  _FakeCollectionReference(this._fs, this._path);
  final FakeFirebaseFirestore _fs;
  final String _path;

  Map<String, Map<String, dynamic>> get _col =>
      _fs._storage[_path] ??= <String, Map<String, dynamic>>{};

  @override
  Future<DocumentReference<Map<String, dynamic>>> add(
    Map<String, dynamic> data,
  ) async {
    id = DateTime.now().microsecondsSinceEpoch.toString();
    _col[id] = Map<String, dynamic>.from(data);
    return _FakeDocumentReference(_path, id, _fs);
  }

  @override
  DocumentReference<Map<String, dynamic>> doc([String? id]) {
    docId = id ?? DateTime.now().microsecondsSinceEpoch.toString();
    _col.putIfAbsent(docId, () => <String, dynamic>{});
    return _FakeDocumentReference(_path, docId, _fs);
  }

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([
    GetOptions? options,
  ]) async {
    final docs = _col.entries
        .map((e) => _FakeQueryDocumentSnapshot(e.key, e.value))
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
  Query<Map<String, dynamic>> where(
    final Object field, {
    final Object? isEqualTo,
    final Object? isNotEqualTo,
    final Object? isLessThan,
    final Object? isLessThanOrEqualTo,
    final Object? isGreaterThan,
    final Object? isGreaterThanOrEqualTo,
    final Object? arrayContains,
    final Iterable<Object?>? arrayContainsAny,
    final Iterable<Object?>? whereIn,
    final Iterable<Object?>? whereNotIn,
    final bool? isNull,
  }) =>
      _FakeQuery(this, field, isEqualTo: isEqualTo);

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeQuery implements Query<Map<String, dynamic>> {
  _FakeQuery(this._collection, this._field, {Object? isEqualTo})
      : _isEqualTo = isEqualTo;
  final _FakeCollectionReference _collection;
  final Object _field;
  final Object? _isEqualTo;
  int? _limit;

  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([
    GetOptions? options,
  ]) async {
    var docs = _collection._col.entries
        .where((entry) {
          if (_isEqualTo != null) {
            return entry.value[_field.toString()] == _isEqualTo;
          }
          return true;
        })
        .map((e) => _FakeQueryDocumentSnapshot(e.key, e.value))
        .toList();

    // Apply limit if set
    if (_limit != null && docs.length > _limit!) {
      docs = docs.take(_limit!).toList();
    }

    return _FakeQuerySnapshot(docs);
  }

  @override
  Query<Map<String, dynamic>> limit(int limit) {
    _limit = limit;
    return this;
  }

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeDocumentReference
    implements DocumentReference<Map<String, dynamic>> {
  _FakeDocumentReference(this._path, this._id, this._fs);
  final String _path;
  final String _id;
  final FakeFirebaseFirestore _fs;

  @override
  String get id => _id;

  @override
  String get path => _path;

  @override
  CollectionReference<Map<String, dynamic>> get parent =>
      _FakeCollectionReference(_fs, _path.split('/').first);

  @override
  Future<void> set(
    final Map<String, dynamic> data, [
    SetOptions? options,
  ]) async {
    _fs._storage[_path] ??= <String, Map<String, dynamic>>{};
    _fs._storage[_path]![_id] = Map<String, dynamic>.from(data);
  }

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([
    GetOptions? options,
  ]) async {
    final data = _fs._storage[_path]?[_id];
    return _FakeDocumentSnapshot(id, data);
  }

  @override
  Future<void> delete() async {
    _fs._storage[_path]?.remove(_id);
  }

  @override
  Future<void> update(Map<Object, Object?> data) async {
    final current = _fs._storage[_path]?[_id] ?? <String, dynamic>{};
    current.addAll(Map<String, dynamic>.from(data));
    _fs._storage[_path] ??= <String, Map<String, dynamic>>{};
    _fs._storage[_path]![_id] = current;
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
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  _FakeDocumentSnapshot(String id, final Map<String, dynamic>? data)
      : _id = id,
        _data = data;
  final String _id;
  final Map<String, dynamic>? _data;

  @override
  Map<String, dynamic>? data() => _data == null ? null : Map.from(_data);

  @override
  String get id => _id;

  @override
  bool get exists => _data != null;

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeQuerySnapshot implements QuerySnapshot<Map<String, dynamic>> {
  _FakeQuerySnapshot(this._docs);
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _docs;

  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => _docs;

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}

class _FakeQueryDocumentSnapshot extends _FakeDocumentSnapshot
    implements QueryDocumentSnapshot<Map<String, dynamic>> {
  _FakeQueryDocumentSnapshot(super.id, super.data);

  @override
  Map<String, dynamic> data() => Map.from(super.data()!);
}

class _FakeTransaction implements Transaction {
  _FakeTransaction(this._fs);
  final FakeFirebaseFirestore _fs;
  final Map<String, Map<String, dynamic>> _pendingChanges = {};

  @override
  Future<DocumentSnapshot<T>> get<T extends Object?>(
    DocumentReference<T> documentRef,
  ) async {
    final path = documentRef.path;
    final id = documentRef.id;
    final data = _pendingChanges[path]?[id] ?? _fs._storage[path]?[id];
    return _FakeDocumentSnapshot(id, data) as DocumentSnapshot<T>;
  }

  @override
  Transaction set<T>(
    final DocumentReference<T> documentRef,
    final T data, [
    final SetOptions? options,
  ]) {
    final path = documentRef.path;
    final id = documentRef.id;
    _pendingChanges[path] ??= <String, Map<String, dynamic>>{};
    _pendingChanges[path]![id] =
        Map<String, dynamic>.from(data as Map<String, dynamic>);
    return this;
  }

  @override
  Transaction update(
    final DocumentReference<Object?> documentRef,
    final Map<String, dynamic> data,
  ) {
    final path = documentRef.path;
    final id = documentRef.id;
    final current = _pendingChanges[path]?[id] ??
        _fs._storage[path]?[id] ??
        <String, dynamic>{};
    current.addAll(data);
    _pendingChanges[path] ??= <String, Map<String, dynamic>>{};
    _pendingChanges[path]![id] = current;
    return this;
  }

  @override
  Transaction delete(DocumentReference<Object?> documentRef) {
    final path = documentRef.path;
    final id = documentRef.id;
    _pendingChanges[path] ??= <String, Map<String, dynamic>>{};
    _pendingChanges[path]![id] = null; // Mark for deletion
    return this;
  }

  void commit() {
    for (entry in _pendingChanges.entries) {
      final path = entry.key;
      final changes = entry.value;
      _fs._storage[path] ??= <String, Map<String, dynamic>>{};
      for (docEntry in changes.entries) {
        final id = docEntry.key;
        final data = docEntry.value;
        if (data == null) {
          _fs._storage[path]!.remove(id);
        } else {
          _fs._storage[path]![id] = data;
        }
      }
    }
  }

  @override
  // coverage:ignore-start
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
  // coverage:ignore-end
}
