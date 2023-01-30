import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/comments/notifiers/send_comment_notifier.dart';
import 'package:nexus/state/image_upload/typedef/is_loading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentNotifier, IsLoading>(
  (_) => SendCommentNotifier(),
);