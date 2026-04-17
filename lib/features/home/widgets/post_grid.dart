import 'package:flutter/material.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';

class PostsGrid extends StatelessWidget {
  final List<PostEntity> posts;

  const PostsGrid({super.key, required this.posts});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: posts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemBuilder: (context, index) {
        final post = posts[index];

        return Image.network(
          post.mediaUrl,
          fit: BoxFit.cover,
        );
      },
    );
  }
}