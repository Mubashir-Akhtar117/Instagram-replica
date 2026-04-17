abstract class StoryEvent {}

class LoadStoriesEvent extends StoryEvent {}

class UploadStoryEvent extends StoryEvent {}

class PickStoryEvent extends StoryEvent {}

class PickStoryEventFromCamera extends StoryEvent {}

class MarkStorySeenEvent extends StoryEvent {
  final String storyId;
  final String userId;

  MarkStorySeenEvent(this.storyId, this.userId);
}

class RefreshStoriesEvent extends StoryEvent {}

class ResetUploadSuccessEvent extends StoryEvent {}
