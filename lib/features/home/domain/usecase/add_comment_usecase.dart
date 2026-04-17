import 'dart:io';
import '../entities/post_entity.dart';

abstract class PostRepository {
  Future<List<PostEntity>> getPosts();

  Future<String> uploadImage(File file);

  Future<void> createPost(String imageUrl, String caption);

  Future<void> addComment(String postId, String comment, String userId);
}