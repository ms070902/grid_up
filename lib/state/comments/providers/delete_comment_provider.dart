import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/comments/notifiers/delete_comment_notifier.dart';
import 'package:nexus/state/image_upload/typedef/is_loading.dart';

final deleteCommentProvider =
    StateNotifierProvider<DeleteCommentStateNotifier, IsLoading>(
        (_) => DeleteCommentStateNotifier());
