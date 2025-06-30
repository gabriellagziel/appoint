import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../providers/content_library_provider.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/loading_state.dart';
import '../../../widgets/error_state.dart';

class ContentLibraryScreen extends ConsumerStatefulWidget {
  const ContentLibraryScreen({super.key});

  @override
  ConsumerState<ContentLibraryScreen> createState() =>
      _ContentLibraryScreenState();
}

class _ContentLibraryScreenState extends ConsumerState<ContentLibraryScreen> {
  final _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 200) {
      ref.read(contentLibraryProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncItems = ref.watch(contentLibraryProvider);
    final hasMore = ref.read(contentLibraryProvider.notifier).hasMore;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Content Library'),
      ),
      body: asyncItems.when(
        data: (items) {
          if (items.isEmpty) {
            return const EmptyState(
              title: 'No Content',
              description: 'Content will appear here once available',
            );
          }
          return ListView.builder(
            controller: _controller,
            itemCount: hasMore ? items.length + 1 : items.length,
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final item = items[index];
              return ListTile(
                leading: item.imageUrl.isNotEmpty
                    ? Image.network(item.imageUrl,
                        width: 56, height: 56, fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 56),
                title: Text(item.title),
                subtitle: Text(item.author),
                onTap: () => context.push('/content/${item.id}'),
              );
            },
          );
        },
        loading: () => const LoadingState(),
        error: (e, _) => ErrorState(title: 'Error', description: e.toString()),
      ),
    );
  }
}
