import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:appoint/models/branch.dart';
import 'package:appoint/services/branch_service.dart';

final branchServiceProvider = Provider<BranchService>((final ref) => BranchService());

final branchesProvider = FutureProvider<List<Branch>>((final ref) async {
  return ref.read(branchServiceProvider).fetchBranches();
});
