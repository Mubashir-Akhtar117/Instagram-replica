import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';

abstract class PostEvent {}

class LoadPosts extends PostEvent {}

class PickMediaEvent extends PostEvent {
  final XFile file;

  PickMediaEvent(this.file);
}

class CaptionChangedEvent extends PostEvent {
  final String caption;
  CaptionChangedEvent(this.caption);
}

class RefreshPostsEvent extends PostEvent {}

class UploadPostEvent extends PostEvent {}

class ClearMediaEvent extends PostEvent {}

class RetryUploadEvent extends PostEvent {}

class ToggleLikeEvent extends PostEvent {
  final String postId;
  final String userId;

  ToggleLikeEvent({required this.postId, required this.userId});
}

class AddCommentEvent extends PostEvent {
  final String postId;
  final String comment;
  final String userId;

  AddCommentEvent({
    required this.postId,
    required this.comment,
    required this.userId,
  });
}
class _PostsUpdated extends PostEvent {
  final List<PostEntity> posts;

  _PostsUpdated(this.posts);
}
class ListenCommentsEvent extends PostEvent {
  final String postId;

  ListenCommentsEvent(this.postId);
}
