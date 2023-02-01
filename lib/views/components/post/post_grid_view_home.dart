import 'package:flutter/material.dart';
import 'package:nexus/views/components/post/post_thumbnail_view.dart';
import 'package:nexus/views/post_details/post_details_view.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../state/posts/models/post.dart';

class PostGridHomeView extends StatelessWidget {
  final Iterable<Post> posts;
  const PostGridHomeView({
    Key? key,
    required this.posts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MasonryGridView.builder(
        itemCount: posts.length,
        crossAxisSpacing: 8,
        scrollDirection: Axis.vertical,
        mainAxisSpacing: 8,
        gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          final post = posts.elementAt(index);
          return PostThumbnailView(
            post: post,
            onTapped: () {
              ///To navigate to the post details view
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetailsView(
                    post: post,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
