import 'package:appoint/models/branch.dart';
import 'package:appoint/services/branch_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final branchServiceProvider =
    Provider<BranchService>((ref) => BranchService());

branchesProvider = FutureProvider<List<Branch>>((final ref) async => ref.read(branchServiceProvider).fetchBranches());
