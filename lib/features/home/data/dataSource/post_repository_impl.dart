import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';
import 'package:sample/features/home/data/dataSource/post_remote_datasource.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';
import 'package:sample/features/home/domain/repository/post_repository.dart';
import 'package:sample/features/home/model/comment_model.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remote;

  PostRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, List<PostEntity>>> getPosts() async {
    try {
      final result = await remote.getPosts();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<PostEntity>> getPostsStream() {
    return remote.getPostsStream();
  }

  @override
  Future<Either<Failure, void>> createPost(
    File file,
    String caption,
    MediaType mediaType,
  ) async {
    try {
      await remote.createPost(
        file: file,
        caption: caption,
        mediaType: mediaType,
      );

      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File file) async {
    try {
      final url = await remote.uploadMedia(file, 'image');
      return Right(url);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addComment(
    String postId,
    String comment,
    String userId,
  ) async {
    try {
      await remote.addComment(postId: postId, comment: comment, userId: userId);

      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CommentModel>>> getComments(String postId) async {
    try {
      final result = await remote.getComments(postId);
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<CommentModel>> getCommentsStream(String postId) {
    return remote.getCommentsStream(postId);
  }

  @override
  Future<Either<Failure, void>> toggleLike(String postId, String userId) async {
    try {
      await remote.toggleLike(postId, userId);
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
