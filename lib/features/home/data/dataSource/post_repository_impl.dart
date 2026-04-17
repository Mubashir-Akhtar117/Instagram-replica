import 'dart:io';
import 'package:sample/features/home/data/dataSource/post_remote_datasource.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';
import 'package:sample/features/home/domain/repository/post_repository.dart';
import 'package:sample/features/home/model/comment_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl(this.remote);

  @override
  Future<List<PostEntity>> getPosts() {
    return remote.getPosts();
  }

  @override
  Stream<List<PostEntity>> getPostsStream() {
    return remote.getPostsStream();
  }

  @override
  Future<void> createPost(
    File file,
    String caption,
    MediaType mediaType,
  ) async {
    await remote.createPost(file: file, caption: caption, mediaType: mediaType);
  }

  @override
  Future<String> uploadImage(File file) {
    return remote.uploadMedia(file, 'image');
  }

  @override
  Future<void> addComment(String postId, String comment, String userId) {
    return remote.addComment(postId: postId, comment: comment, userId: userId);
  }

  @override
  Future<List<CommentModel>> getComments(String postId) {
    return remote.getComments(postId);
  }

  @override
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return remote.getCommentsStream(postId);
  }

  @override
  Future<void> toggleLike(String postId, String userId) {
    return remote.toggleLike(postId, userId);
  }
}
