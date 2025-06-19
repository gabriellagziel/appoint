import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/branch.dart';
import '../services/branch_service.dart';

final branchServiceProvider = Provider<BranchService>((ref) => BranchService());

final branchesProvider = FutureProvider<List<Branch>>((ref) async {
  return ref.read(branchServiceProvider).fetchBranches();
});
