import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nexus/state/constants/firebase_collection_name.dart';
import 'package:nexus/state/constants/firebase_field_name.dart';
import 'package:nexus/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:nexus/state/image_upload/typedef/is_loading.dart';
import 'package:nexus/state/posts/models/post.dart';
import 'package:nexus/state/posts/typedefs/post_id.dart';

class DeletePostStateNotifier extends StateNotifier<IsLoading> {
  DeletePostStateNotifier() : super(false);
  set isLoading(bool value) => state = value;

  Future<bool> deletePost({
    required Post post,
  }) async {
    isLoading = true;

    try {
      ///delete the post thumbnail
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(FirebaseCollectionName.thumbnails)
          .child(post.thumbnailStorageId)
          .delete();

      ///delete the post original file (video or thumbnail)
      await FirebaseStorage.instance
          .ref()
          .child(post.userId)
          .child(post.fileType.collectionName)
          .child(post.thumbnailStorageId)
          .delete();

      ///delete all comments associated with that post
      await _deleteAllDocuments(
        postId: post.postId,
        inCollection: FirebaseCollectionName.comments,
      );

      ///delete all likes associated with that post
      await _deleteAllDocuments(
        postId: post.postId,
        inCollection: FirebaseCollectionName.likes,
      );

      ///deleting post itself
      final postInCollection = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .where(
            FirebaseFieldName.postId,
            isEqualTo: post.postId,
          )
          .limit(1)
          .get();

      for (final post in postInCollection.docs) {
        await post.reference.delete();
      }

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> _deleteAllDocuments({
    required PostId postId,
    required String inCollection,
  }) {
    return FirebaseFirestore.instance.runTransaction(
      maxAttempts: 3,
      timeout: const Duration(seconds: 20),
      (transaction) async {
        final query = await FirebaseFirestore.instance
            .collection(inCollection)
            .where(
              FirebaseFieldName.postId,
              isEqualTo: postId,
            )
            .get();
        for (final doc in query.docs) {
          transaction.delete(doc.reference);
        }
      },
    );
  }
}
