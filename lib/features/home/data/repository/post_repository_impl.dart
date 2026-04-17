import 'dart:io';
import 'package:sample/features/home/domain/entities/post_entity.dart';
import 'package:sample/features/home/model/comment_model.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();

  Future<String> uploadImage(File file);

  Future<void> createPost(
    File file,
    String caption,
    MediaType mediaType,
  );

  Future<void> addComment(
    String postId,
    String comment,
    String userId,
  );

  Future<List<CommentModel>> getComments(String postId);

  Stream<List<CommentModel>> getCommentsStream(String postId);

  Future<void> toggleLike(String postId, String userId);
}