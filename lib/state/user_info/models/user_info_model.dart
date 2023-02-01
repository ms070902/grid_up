import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:nexus/state/constants/firebase_field_name.dart';

import '../../posts/typedefs/user_id.dart';

@immutable
class UserInfoModel extends MapView<String, String?> {
  final UserId userId;
  final String displayName;
  final String photoUrl;
  final String email;

  UserInfoModel({
    required this.photoUrl,
    required this.userId,
    required this.displayName,
    required this.email,
  }) : super(
          {
            FirebaseFieldName.userId: userId,
            FirebaseFieldName.displayName: displayName,
            FirebaseFieldName.email: email,
            FirebaseFieldName.photoUrl: photoUrl,
          },
        );
  UserInfoModel.fromJson(
    Map<String, dynamic> json, {
    required UserId userId,
  }) : this(
          userId: userId,
          displayName: json[FirebaseFieldName.displayName] as String,
          email: json[FirebaseFieldName.email] as String,
          photoUrl: json[FirebaseFieldName.photoUrl] as String,
        );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          displayName == other.displayName &&
          email == other.email;

  @override
  int get hashCode => Object.hashAll(
        [
          userId,
          displayName,
          email,
        ],
      );
}
