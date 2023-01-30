import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/posts/models/post.dart';
import 'package:nexus/state/user_info/providers/user_info_model_provider.dart';
import 'package:nexus/views/components/animations/small_error_animation_view.dart';
import 'package:nexus/views/components/rich_two_parts_text.dart';

class PostDisplayNameAndMessageView extends ConsumerWidget {
  final Post post;
  const PostDisplayNameAndMessageView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfoModel = ref.watch(
      userInfoModelProvider(
        post.postId,
      ),
    );
    return userInfoModel.when(
      data: (userInfoModel) {
        return RichTwoPartText(
          leftPart: userInfoModel.displayName,
          rightPart: post.message,
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
