import 'dart:io';
import '../repository/story_repository.dart';

class CreateStoryUseCase {
  final StoryRepository repo;

  CreateStoryUseCase(this.repo);

  Future<void> call(File file) {
    return repo.createStory(file);
  }
}