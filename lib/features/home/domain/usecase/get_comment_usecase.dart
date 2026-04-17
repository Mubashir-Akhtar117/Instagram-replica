import 'package:sample/features/home/data/repository/post_repository_impl.dart';

import '../../model/comment_model.dart';

class GetCommentsStreamUseCase {
  final PostRepository repo;

  GetCommentsStreamUseCase(this.repo);

  Stream<List<CommentModel>> call(String postId) {
    return repo.getCommentsStream(postId);
  }
}