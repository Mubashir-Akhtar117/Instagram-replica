import 'dart:io';
import '../../model/story_model.dart';

abstract class StoryRepository {
  Future<void> createStory(File file);

  Future<List<StoryModel>> getStories();

  Future<List<StoryModel>> fetchFreshStories();
}