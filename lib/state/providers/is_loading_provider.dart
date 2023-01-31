import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/auth/providers/auth_state_provider.dart';
import 'package:nexus/state/comments/providers/send_comment_provider.dart';
import 'package:nexus/state/image_upload/providers/image_uploader_provider.dart';
import '../comments/providers/delete_comment_provider.dart';
import '../posts/providers/delete_post_provider.dart';

final isLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  final isUploadingImage = ref.watch(imageUploadProvider);
  final isSendingComment = ref.watch(sendCommentProvider);
  final isDeletingComment = ref.watch(deleteCommentProvider);
  final isDeletingPost = ref.watch(deletePostProvider);
  return authState.isLoading ||
      isUploadingImage ||
      isSendingComment ||
      isDeletingComment ||
      isDeletingPost;
});
