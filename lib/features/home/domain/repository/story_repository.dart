import 'dart:io';
import 'package:dartz/dartz.dart';

import '../../model/story_model.dart';
import '../../../../core/error/failure.dart';

abstract class StoryRepository {
  Future<Either<Failure, void>> createStory(File file);

  Future<Either<Failure, List<StoryModel>>> getStories();

  Future<Either<Failure, List<StoryModel>>> fetchFreshStories();

  Future<void> markStorySeen(String storyId, String userId);
}
