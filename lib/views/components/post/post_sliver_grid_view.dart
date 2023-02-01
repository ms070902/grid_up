import 'package:flutter/material.dart';
import 'package:nexus/views/components/post/post_thumbnail_view.dart';
import 'package:nexus/views/post_details/post_details_view.dart';

import '../../../state/posts/models/post.dart';

class PostSliverGridView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostSliverGridView({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      delegate: SliverChildBuilderDelegate(childCount: posts.length,
          (context, index) {
        final post = posts.elementAt(index);
        return PostThumbnailView(
            post: post,
            onTapped: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetailsView(
                    post: post,
                  ),
                ),
              );
            });
      }),
    );
  }
}
