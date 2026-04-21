import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';
import 'package:sample/features/home/domain/entities/post_entity.dart';
import 'package:sample/features/home/domain/repository/post_repository.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  Future<Either<Failure, void>> call(
    File file,
    String caption,
    MediaType mediaType,
  ) {
    return repository.createPost(file, caption, mediaType);
  }
}