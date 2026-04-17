import 'package:hive/hive.dart';
import '../../model/story_model.dart';

class StoryLocalDataSource {
  Future<Box<StoryModel>> _box() async {
    return await Hive.openBox<StoryModel>('storyBox');
  }

  Future<void> saveStories(List<StoryModel> stories) async {
    final box = await _box();
    await box.clear();
    for (var s in stories) {
      await box.put(s.id, s);
    }
  }

  Future<List<StoryModel>> getStories() async {
    final box = await _box();
    return box.values.toList();
  }
}