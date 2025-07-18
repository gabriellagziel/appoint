import 'package:appoint/models/branch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Branch>> fetchBranches() async {
    final snapshot = await _firestore.collection('branches').get();
    return snapshot.docs
        .map((doc) => Branch.fromJson(doc.data(), doc.id))
        .toList();
  }
}
