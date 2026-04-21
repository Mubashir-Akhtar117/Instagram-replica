import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';
import 'package:sample/features/home/model/comment_model.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';

abstract class PostRepository {

  Future<Either<Failure, List<PostEntity>>> getPosts();

  Future<Either<Failure, String>> uploadImage(File file);

  Future<Either<Failure, void>> createPost(
    File file,
    String caption,
    MediaType mediaType,
  );

  Future<Either<Failure, void>> addComment(
    String postId,
    String comment,
    String userId,
  );

  Future<Either<Failure, List<CommentModel>>> getComments(
    String postId,
  );

  Stream<List<CommentModel>> getCommentsStream(String postId);

  Future<Either<Failure, void>> toggleLike(
    String postId,
    String userId,
  );

  Stream<List<PostEntity>> getPostsStream();
}