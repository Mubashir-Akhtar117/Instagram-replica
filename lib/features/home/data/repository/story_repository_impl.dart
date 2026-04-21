import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:sample/core/error/failure.dart';

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
  Future<Either<Failure, void>> createStory(File file) async {
    try {
      await remote.createStory(file);
      _syncInBackground();
      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StoryModel>>> getStories() async {
    try {
      final cached = await local.getStories();

      _syncInBackground();

      if (cached.isNotEmpty) {
        return Right(cached);
      }

      final fresh = await _fetchRemote();
      await local.saveStories(fresh);

      return Right(fresh);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StoryModel>>> fetchFreshStories() async {
    try {
      final fresh = await _fetchRemote();
      await local.saveStories(fresh);
      return Right(fresh);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
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

  @override
  Future<Either<Failure, void>> markStorySeen(
    String storyId,
    String userId,
  ) async {
    try {
      await remote.markStorySeen(storyId, userId);

      _syncInBackground();

      return const Right(null);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
