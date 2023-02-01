import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/providers/user_id_provider.dart';
import 'package:nexus/state/posts/providers/user_posts_provider.dart';
import 'package:nexus/state/user_info/providers/user_info_model_provider.dart';
import 'package:nexus/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:nexus/views/components/animations/error_animation_view.dart';
import 'package:nexus/views/components/animations/loading_animation_view.dart';
import 'package:nexus/views/components/post/posts_grid_view.dart';
import 'package:nexus/views/constants/strings.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);
    final userId = ref.read(userIdProvider);
    final userInfo = ref.watch(userInfoModelProvider(userId!));
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostsProvider);
        return Future.delayed(const Duration(seconds: 1));
      },
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
              text: Strings.youHaveNoPosts,
            );
          } else {
            return PostGridView(posts: posts);
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
