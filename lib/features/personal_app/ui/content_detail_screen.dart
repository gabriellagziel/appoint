import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/content_library_provider.dart';
import '../../../widgets/loading_state.dart';
import '../../../widgets/error_state.dart';
import '../../../theme/app_spacing.dart';

class ContentDetailScreen extends ConsumerWidget {
  final String contentId;

  const ContentDetailScreen({super.key, required this.contentId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemAsync = ref.watch(contentItemProvider(contentId));
    return Scaffold(
      appBar: AppBar(title: const Text('Content Detail')),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Content not found'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                Text(item.title,
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.sm),
                Text('By ${item.author}',
                    style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: AppSpacing.md),
                Text(item.description),
              ],
            ),
          );
        },
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState(title: 'Error', description: e.toString()),
      ),
    );
  }
}
