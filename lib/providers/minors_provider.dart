import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Temporary provider returning a list of available minors.
final minorsProvider = FutureProvider<List<String>>((ref) async {
  // Replace with real data source
  return ['Minor A', 'Minor B', 'Minor C'];
});
