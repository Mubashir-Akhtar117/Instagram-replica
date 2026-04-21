import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sample/core/utils/time_formatter.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';
import 'package:sample/features/home/presentation/bloc/profile_bloc.dart';
import 'package:sample/features/home/presentation/bloc/profile_state.dart';
import 'package:sample/features/home/widgets/post_action.dart';
import 'package:sample/features/home/widgets/video_post_widget.dart';

class PostItem extends StatefulWidget {
  final PostEntity post;

  const PostItem({super.key, required this.post});

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  Widget _buildMedia() {
    if (widget.post.mediaType == MediaType.video) {
      return _VideoContainer(url: widget.post.mediaUrl);
    }

    return _ImageContainer(url: widget.post.mediaUrl);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final user = state.user;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                backgroundImage: NetworkImage(user?.profileUrl ?? ""),
              ),
              title: Text(user?.name ?? ""),
            ),

            _buildMedia(),

            PostActions(post: widget.post),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text("${user?.name ?? ""} ${widget.post.caption}"),
            ),

            const SizedBox(height: 4),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text("View all comments"),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(TimeFormatter.format(widget.post.time)),
            ),

            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}

class _ImageContainer extends StatelessWidget {
  final String url;

  const _ImageContainer({required this.url});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Image.network(url, fit: BoxFit.cover),
    );
  }
}

class _VideoContainer extends StatelessWidget {
  final String url;

  const _VideoContainer({required this.url});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        color: Colors.black,
        child: VideoPostWidget(url: url),
      ),
    );
  }
}
