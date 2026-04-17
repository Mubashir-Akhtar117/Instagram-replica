import '../repository/story_repository.dart';
import '../../model/story_model.dart';

class GetStoriesUseCase {
  final StoryRepository repository;

  GetStoriesUseCase(this.repository);

  Future<List<StoryModel>> call() {
    return repository.getStories();
  }

  Future<List<StoryModel>> fetchFresh() {
    return repository.fetchFreshStories();
  }
}