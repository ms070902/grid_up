import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/post_settings/models/post_settings.dart';
import 'package:nexus/state/post_settings/notifiers/post_settings_notifier.dart';

final postSettingsProvider =
    StateNotifierProvider<PostSettingsNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingsNotifier(),
);
