import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/image_upload/typedef/is_loading.dart';
import 'package:nexus/state/posts/notifiers/delete_post_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (_) => DeletePostStateNotifier(),
);
