import 'package:hive/hive.dart';
import '../../features/home/model/story_model.dart';

class StoryCacheService {
  final Box box = Hive.box('storyBox');

  Future<void> saveStories(List<StoryModel> stories) async {
    final list = stories
        .map(
          (e) => {
            'id': e.id,
            'userId': e.userId,
            'mediaUrl': e.mediaUrl,
            'viewedBy': e.viewedBy,
            'time': e.time.toIso8601String(),
            'type': e.type,
          },
        )
        .toList();

    await box.put('stories', list);
  }

  List<StoryModel> getStories() {
    final data = box.get('stories');

    if (data == null) return [];

    return (data as List).map((e) {
      return StoryModel(
        id: e['id'],
        userId: e['userId'],
        mediaUrl: e['mediaUrl'],
        viewedBy: List<String>.from(e['viewedBy'] ?? []),
        time: DateTime.parse(e['time']),
        type: e['type'] ?? 'image',
      );
    }).toList();
  }
}
