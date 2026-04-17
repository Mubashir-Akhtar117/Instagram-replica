import 'package:sample/features/home/domain/repository/post_repository.dart';

import '../entities/post_entity.dart';

class GetPostsUseCase {
  final PostRepository repository;

  GetPostsUseCase(this.repository);

  Future<List<PostEntity>> call() {
    return repository.getPosts();
  }
}