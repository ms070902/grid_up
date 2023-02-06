import 'dart:collection';

import 'package:flutter/foundation.dart' show immutable;
import 'package:nexus/state/constants/firebase_field_name.dart';

import '../../posts/typedefs/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId userId,
    required String? displayName,
    required String? email,
    required String? photoUrl,
  }) : super({
          FirebaseFieldName.userId: userId,
          FirebaseFieldName.displayName: displayName ?? '',
          FirebaseFieldName.email: email ?? '',
          FirebaseFieldName.photoUrl: photoUrl ?? '',
        });
}
