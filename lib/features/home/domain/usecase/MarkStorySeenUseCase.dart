import '../repository/story_repository.dart';

class MarkStorySeenUseCase {
  final StoryRepository repo;

  MarkStorySeenUseCase(this.repo);

  Future<void> call(String storyId, String userId) {
    return repo.markStorySeen(storyId, userId);
  }
}