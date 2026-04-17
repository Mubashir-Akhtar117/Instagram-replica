import 'package:sample/features/home/model/story_model.dart';

Map<String, List<StoryModel>> groupStories(List<StoryModel> stories) {
  final Map<String, List<StoryModel>> grouped = {};

  for (final story in stories) {
    grouped.putIfAbsent(story.userId, () => []);
    grouped[story.userId]!.add(story);
  }

  return grouped;
}