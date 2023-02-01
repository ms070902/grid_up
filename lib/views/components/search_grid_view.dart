import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/posts/providers/posts_by_search_term_provider.dart';
import 'package:nexus/views/components/animations/data_not_found_animation_view.dart';
import 'package:nexus/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:nexus/views/components/animations/error_animation_view.dart';
import 'package:nexus/views/components/post/post_sliver_grid_view.dart';
import 'package:nexus/views/constants/strings.dart';

class SearchGridView extends ConsumerWidget {
  final String searchTerm;
  const SearchGridView({
    required this.searchTerm,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (searchTerm.isEmpty) {
      return const SliverToBoxAdapter(
        child: EmptyContentsWithTextAnimationView(
          text: Strings.enterYourSearchTerm,
        ),
      );
    }

    final post = ref.watch(
      postBySearchTermProvider(
        searchTerm,
      ),
    );
    return post.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const SliverToBoxAdapter(
            child: DataNotFoundAnimationView(),
          );
        } else {
          return PostSliverGridView(
            posts: posts,
          );
        }
      },
      error: (error, stackTrace) {
        return const SliverToBoxAdapter(
          child: ErrorAnimationView(),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
