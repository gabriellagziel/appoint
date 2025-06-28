import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/care_provider.dart';

class CareProviderService {
  final FirebaseFirestore _firestore;
  CareProviderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection('care_providers');

  Future<List<CareProvider>> fetchProviders() async {
    final snap = await _col.get();
    return snap.docs
        .map((d) => CareProvider.fromJson({...d.data(), 'id': d.id}))
        .toList();
  }

  Future<void> addProvider(CareProvider provider) async {
    final doc = _col.doc(provider.id.isEmpty ? null : provider.id);
    await doc.set(provider.copyWith(id: doc.id).toJson());
  }

  Future<void> updateProvider(CareProvider provider) async {
    await _col.doc(provider.id).set(provider.toJson());
  }

  Future<void> deleteProvider(String id) async {
    await _col.doc(id).delete();
  }
}
