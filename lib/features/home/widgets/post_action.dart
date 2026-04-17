import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample/features/home/presentation/bloc/post_bloc.dart';
import 'package:sample/features/home/presentation/bloc/post_event.dart';
import 'package:sample/features/home/widgets/comment_bottomsheet.dart';

import '../domain/entities/post_entity.dart';

class PostActions extends StatelessWidget {
  final PostEntity post;

  const PostActions({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final isLiked = post.likedBy.contains(userId);

    return Row(
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : theme.iconTheme.color,
          ),
          onPressed: () {
            context.read<PostBloc>().add(
              ToggleLikeEvent(postId: post.id, userId: userId),
            );
          },
        ),

       IconButton(
  icon: const Icon(Icons.comment_outlined),
  onPressed: () {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<PostBloc>(),
          child: CommentBottomSheet(postId: post.id),
        );
      },
    );
  },
),

        IconButton(icon: const Icon(Icons.send), onPressed: () {}),

        const Spacer(),

        IconButton(icon: const Icon(Icons.bookmark_border), onPressed: () {}),
      ],
    );
  }
}
