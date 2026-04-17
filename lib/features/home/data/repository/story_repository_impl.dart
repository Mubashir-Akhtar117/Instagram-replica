import 'dart:io';

import '../../domain/repository/story_repository.dart';
import '../../model/story_model.dart';
import '../dataSource/story_remote_datasource.dart';
import '../local/story_local_datasource.dart';

class StoryRepositoryImpl implements StoryRepository {
  final StoryRemoteDataSource remote;
  final StoryLocalDataSource local;

  StoryRepositoryImpl(this.remote, this.local);

  bool _syncing = false;

  @override
  Future<void> createStory(File file) async {
    await remote.createStory(file);
    _syncInBackground();
  }

  @override
  Future<List<StoryModel>> getStories() async {
    final cached = await local.getStories();

    _syncInBackground();

    if (cached.isNotEmpty) {
      return cached;
    }

    final fresh = await _fetchRemote();
    await local.saveStories(fresh);

    return fresh;
  }

  @override
  Future<List<StoryModel>> fetchFreshStories() async {
    final fresh = await _fetchRemote();
    await local.saveStories(fresh);
    return fresh;
  }

  Future<List<StoryModel>> _fetchRemote() async {
    final data = await remote.getStories();
    return data.map((e) => StoryModel.fromMap(e['id'], e)).toList();
  }

  void _syncInBackground() async {
    if (_syncing) return;
    _syncing = true;

    try {
      final fresh = await _fetchRemote();
      await local.saveStories(fresh);
    } catch (_) {
    } finally {
      _syncing = false;
    }
  }
}
