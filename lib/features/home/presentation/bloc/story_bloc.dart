import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sample/features/home/domain/usecase/MarkStorySeenUseCase.dart';

import '../../domain/usecase/create_story_usecase.dart';
import '../../domain/usecase/get_stories_usecase.dart';
import 'story_state.dart';
import 'upload_story_events.dart';

class StoryBloc extends Bloc<StoryEvent, StoryState> {
  final CreateStoryUseCase createStoryUseCase;
  final GetStoriesUseCase getStoriesUseCase;
  final MarkStorySeenUseCase markStorySeenUseCase;
  final ImagePicker _picker = ImagePicker();

  StoryBloc(
    this.createStoryUseCase,
    this.getStoriesUseCase,
    this.markStorySeenUseCase,
  ) : super(const StoryState()) {
    on<LoadStoriesEvent>(_loadStories);
    on<UploadStoryEvent>(_uploadStory);
    on<PickStoryEvent>(_pickFromGallery);
    on<PickStoryEventFromCamera>(_pickFromCamera);
    on<MarkStorySeenEvent>(_markStorySeen);

    add(LoadStoriesEvent());
  }

  Future<void> _pickFromGallery(
    PickStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    final picked = await _picker.pickMedia();

    if (picked != null) {
      emit(state.copyWith(file: File(picked.path)));
    }
  }

  Future<void> _pickFromCamera(
    PickStoryEventFromCamera event,
    Emitter<StoryState> emit,
  ) async {
    final picked = await _picker.pickVideo(source: ImageSource.camera);

    if (picked != null) {
      emit(state.copyWith(file: File(picked.path)));
    }
  }

  Future<void> _loadStories(
    LoadStoriesEvent event,
    Emitter<StoryState> emit,
  ) async {
    final result = await getStoriesUseCase.fetchFresh();

    result.fold(
      (failure) {
        emit(state.copyWith(loading: false, error: failure.message));
      },
      (stories) {
        emit(state.copyWith(stories: stories, loading: false, error: null));
      },
    );
  }

  Future<void> _uploadStory(
    UploadStoryEvent event,
    Emitter<StoryState> emit,
  ) async {
    final file = state.file;
    if (file == null) return;

    emit(state.copyWith(uploading: true, error: null, uploadSuccess: false));

    try {
      await createStoryUseCase(file);

      final freshResult = await getStoriesUseCase.fetchFresh();

      freshResult.fold(
        (failure) {
          emit(state.copyWith(uploading: false, error: failure.message));
        },
        (stories) {
          emit(
            state.copyWith(
            uploading: false,
              uploadSuccess: true,
              clearFile: true,
              stories: stories,
            ),
          );
        },
      );
    } catch (e) {
      emit(state.copyWith(uploading: false, error: e.toString()));
    }
  }

  Future<void> _markStorySeen(
    MarkStorySeenEvent event,
    Emitter<StoryState> emit,
  ) async {
    try {
      await markStorySeenUseCase(event.storyId, event.userId);

      final updated = state.stories.map((story) {
        if (story.id == event.storyId) {
          final list = List<String>.from(story.viewedBy);

          if (!list.contains(event.userId)) {
            list.add(event.userId);
          }

          return story.copyWith(viewedBy: list);
        }
        return story;
      }).toList();

      emit(state.copyWith(stories: updated));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
