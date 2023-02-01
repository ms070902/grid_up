import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/comments/extensions/comment_sorting_by_request.dart';
import 'package:nexus/state/comments/models/comment.dart';
import 'package:nexus/state/comments/models/post_comments_request.dart';
import 'package:nexus/state/comments/models/post_with_comments.dart';
import 'package:nexus/state/constants/firebase_collection_name.dart';
import 'package:nexus/state/constants/firebase_field_name.dart';
import 'package:nexus/state/posts/models/post.dart';

final specificPostWithCommentsProvider = StreamProvider.family
    .autoDispose<PostWithComments, RequestForPostAndComments>((
  ref,
  RequestForPostAndComments request,
) {
  final controller = StreamController<PostWithComments>();

  Post? post;
  Iterable<Comment>? comments;

  void notify() {
    final localPost = post;
    if (localPost == null) {
      return;
    }
    final outputComments = (comments ?? []).applySortingFrom(
      request,
    );
    final result = PostWithComments(
      post: localPost,
      comments: outputComments,
    );
    controller.sink.add(result);
  }

  ///watch changes to post
  final postSub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .where(
        FieldPath.documentId,
        isEqualTo: request.postId,
      )
      .limit(1)
      .snapshots()
      .listen((snapshot) {
    if (snapshot.docs.isEmpty) {
      post = null;
      comments = null;
      notify();
      return;
    }
    final doc = snapshot.docs.first;
    if (doc.metadata.hasPendingWrites) {
      return;
    }
    post = Post(
      postId: doc.id,
      json: doc.data(),
    );
    notify();
  });

  ///watch changes to comments
  final commentQuery = FirebaseFirestore.instance
      .collection(
        FirebaseCollectionName.comments,
      )
      .where(
        FirebaseFieldName.postId,
        isEqualTo: request.postId,
      )
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      );
  final limitedCommentsQuery =
      request.limit != null ? commentQuery.limit(request.limit!) : commentQuery;

  final commentsSub = limitedCommentsQuery.snapshots().listen((snapshot) {
    comments = snapshot.docs
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Comment(
            doc.data(),
            id: doc.id,
          ),
        );
    notify();
  });

  ref.onDispose(() {
    postSub.cancel();
    commentsSub.cancel();
    controller.close();
  });
  return controller.stream;
});
