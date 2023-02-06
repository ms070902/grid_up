import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/posts/providers/all_posts_provider.dart';
import 'package:nexus/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:nexus/views/components/animations/error_animation_view.dart';
import 'package:nexus/views/components/animations/loading_animation_view.dart';
import 'package:nexus/views/constants/strings.dart';

import '../components/post/post_grid_view_home.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostProvider);
    return RefreshIndicator(
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
              text: Strings.noPostsAvailable,
            );
          } else {
            return PostGridHomeView(
              posts: posts,
            );
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
      onRefresh: () {
        ref.refresh(allPostProvider);
        return Future.delayed(
          const Duration(
            seconds: 1,
          ),
        );
      },
    );
  }
}
