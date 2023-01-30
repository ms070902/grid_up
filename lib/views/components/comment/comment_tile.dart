import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/providers/user_id_provider.dart';
import 'package:nexus/state/comments/models/comment.dart';
import 'package:nexus/state/comments/providers/delete_comment_provider.dart';
import 'package:nexus/state/user_info/providers/user_info_model_provider.dart';
import 'package:nexus/views/components/animations/small_error_animation_view.dart';
import 'package:nexus/views/components/constants/strings.dart';
import 'package:nexus/views/components/dialogs/alert_dialog_model.dart';
import 'package:nexus/views/components/dialogs/delete_dialog.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;
  const CommentTile({
    super.key,
    required this.comment,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        comment.fromUserId,
      ),
    );
    return userInfo.when(
      data: (userInfoModel) {
        final currentUserId = ref.read(userIdProvider);
        return ListTile(
          trailing: currentUserId == comment.fromUserId
              ? IconButton(
                  onPressed: () async {
                    final shouldDeleteComment = await displayDeleteDialog(
                      context,
                    );
                    if (shouldDeleteComment) {
                      await ref
                          .read(deleteCommentProvider.notifier)
                          .deleteComment(commentId: comment.id);
                    }
                  },
                  icon: const Icon(
                    Icons.delete_rounded,
                  ))
              : null,
          title: Text(userInfoModel.displayName),
          subtitle: Text(comment.comment),
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

  Future<bool> displayDeleteDialog(BuildContext context) {
    return const DeleteDialog(titleOfObjectToDelete: Strings.comment)
        .present(context)
        .then((value) => value ?? false);
  }
}
