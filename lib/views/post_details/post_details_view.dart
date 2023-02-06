import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/enums/date_sorting.dart';
import 'package:nexus/state/comments/models/post_comments_request.dart';
import 'package:nexus/state/posts/models/post.dart';
import 'package:nexus/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:nexus/state/posts/providers/delete_post_provider.dart';
import 'package:nexus/state/posts/providers/specific_post_with_comments_provider.dart';
import 'package:nexus/views/components/animations/error_animation_view.dart';
import 'package:nexus/views/components/animations/loading_animation_view.dart';
import 'package:nexus/views/components/animations/small_error_animation_view.dart';
import 'package:nexus/views/components/comment/compact_comment_column.dart';
import 'package:nexus/views/components/dialogs/alert_dialog_model.dart';
import 'package:nexus/views/components/dialogs/delete_dialog.dart';
import 'package:nexus/views/components/like_button.dart';
import 'package:nexus/views/components/likes_count_view.dart';
import 'package:nexus/views/components/post/post_date_view.dart';
import 'package:nexus/views/components/post/post_display_name_and_message_view.dart';
import 'package:nexus/views/components/post/post_image_or_video_view.dart';
import 'package:nexus/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

import '../constants/strings.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    required this.post,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    ///get actual post together with its comments
    final postWithComment = ref.watch(
      specificPostWithCommentsProvider(
        request,
      ),
    );

    ///can we delete this post?
    final canDeletePost = ref.watch(
      canCurrentUserDeletePostProvider(
        widget.post,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.postDetails,
          style: TextStyle(
            color: Colors.blueGrey,
          ),
        ),
        actions: [
          ///share button
          postWithComment.when(
            data: (postWithComment) {
              return IconButton(
                onPressed: () {
                  final url = postWithComment.post.fileUrl;
                  Share.share(
                    url,
                    subject: Strings.checkOutThisPost,
                  );
                },
                icon: const Icon(
                  Icons.share,
                  color: Colors.blueGrey,
                ),
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
          ),

          ///delete button if user cannot delete the post
          if (canDeletePost.value ?? false)
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.blueGrey,
              ),
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                  titleOfObjectToDelete: Strings.post,
                ).present(context).then(
                      (shouldDelete) => shouldDelete ?? false,
                    );
                if (shouldDeletePost) {
                  await ref.read(deletePostProvider.notifier).deletePost(
                        post: widget.post,
                      );
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
        ],
      ),
      body: postWithComment.when(
        data: (postWithComment) {
          final postId = postWithComment.post.postId;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(
                  post: postWithComment.post,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///like button only if post allows likes
                    if (postWithComment.post.allowLikes)
                      LikeButton(
                        postId: postId,
                      ),

                    ///comments button if post allows commenting on it
                    if (postWithComment.post.allowComments)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostCommentsView(
                                postId: postId,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.mode_comment_outlined),
                      ),
                  ],
                ),

                ///post details
                PostDisplayNameAndMessageView(
                  post: postWithComment.post,
                ),
                PostDateView(
                  dateTime: postWithComment.post.createdAt,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.blueGrey,
                  ),
                ),

                ///display comments
                CompactCommentColumn(
                  comments: postWithComment.comments,
                ),

                ///display like count
                if (postWithComment.post.allowLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(
                          postId: postId,
                        ),
                      ],
                    ),
                  ),

                ///add spacing at bottom of screen
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
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
