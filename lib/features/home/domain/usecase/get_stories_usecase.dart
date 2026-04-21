import 'package:dartz/dartz.dart';

import '../repository/story_repository.dart';
import '../../model/story_model.dart';
import '../../../../core/error/failure.dart';

class GetStoriesUseCase {
  final StoryRepository repository;

  GetStoriesUseCase(this.repository);

  Future<Either<Failure, List<StoryModel>>> call() {
    return repository.getStories();
  }

  Future<Either<Failure, List<StoryModel>>> fetchFresh() {
    return repository.fetchFreshStories();
  }
}
