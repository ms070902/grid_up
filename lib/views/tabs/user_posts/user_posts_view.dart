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
    final userInfo = ref.watch(userInfoModelProvider(
      userId!,
    ));
    final user = userInfo.value;
    String displayName;
    String email;
    String photoUrl;
    if (user != null) {
      displayName = user.displayName;
      email = user.email;
      photoUrl = user.photoUrl;
    } else {
      displayName = '${Strings.appName} user';
      email = '';
      photoUrl = '';
    }
    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostsProvider);
        return Future.delayed(
          const Duration(
            seconds: 1,
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              top: 8.0,
            ),
            child: Container(
              alignment: Alignment.center,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  color: Colors.black12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white24,
                    backgroundImage: NetworkImage(photoUrl),
                    radius: 40.0,
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Hey $displayName!',
                        style: const TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        '$email!',
                        style: const TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          posts.when(
            data: (posts) {
              if (posts.isEmpty) {
                return const EmptyContentsWithTextAnimationView(
                  text: Strings.youHaveNoPosts,
                );
              } else {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PostGridView(
                      posts: posts,
                    ),
                  ),
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
        ],
      ),
    );
  }
}
