import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';
import 'package:sample/features/home/domain/repository/post_repository.dart';

import '../entities/post_entity.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<Either<Failure, List<PostEntity>>> call() {
    return repository.getPosts();
  }
}