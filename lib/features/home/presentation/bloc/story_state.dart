import 'dart:io';
import 'package:sample/features/home/model/story_model.dart';

class StoryState {
  final List<StoryModel> stories;
  final File? file;
  final bool uploading;
  final bool uploadSuccess;
  final String? error;

  const StoryState({
    this.stories = const [],
    this.file,
    this.uploading = false,
    this.uploadSuccess = false,
    this.error,
  });

  StoryState copyWith({
    List<StoryModel>? stories,
    File? file,
    bool clearFile = false,
    bool? uploading,
    bool? uploadSuccess,
    String? error,
  }) {
    return StoryState(
      stories: stories ?? this.stories,
      file: clearFile ? null : (file ?? this.file),
      uploading: uploading ?? this.uploading,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
      error: error,
    );
  }
}