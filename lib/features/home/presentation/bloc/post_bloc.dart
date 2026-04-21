import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:sample/features/home/model/comment_model.dart';
import '../../domain/usecase/get_posts_usecase.dart';
import '../../domain/usecase/create_post_usecase.dart';
import '../../domain/repository/post_repository.dart';
import '../../domain/entities/post_entity.dart';

import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPostsUseCase;
  final CreatePostUseCase createPostUseCase;
  final PostRepository repository;

  StreamSubscription<List<CommentModel>>? _commentSub;
  StreamSubscription<List<PostEntity>>? _postSub;

  PostBloc(this.getPostsUseCase, this.createPostUseCase, this.repository)
    : super(PostState.initial()) {
    on<RefreshPostsEvent>(_onRefreshPosts);
    on<LoadPosts>(_onLoadPosts);
    on<PickMediaEvent>(_onPickMedia);
    on<CaptionChangedEvent>(_onCaptionChanged);
    on<UploadPostEvent>(_onUploadPost);
    on<ToggleLikeEvent>(_onToggleLike);
    on<AddCommentEvent>(_onAddComment);
    on<ListenCommentsEvent>(_onListenComments);
    on<ClearMediaEvent>(_onClearMedia);
    on<_PostsUpdated>(_onPostsUpdated);
  }

  void startPostsListener() {
    _postSub?.cancel();

    _postSub = repository.getPostsStream().listen((posts) {
      if (isClosed) return;
      add(_PostsUpdated(posts));
    });
  }

  void _onPostsUpdated(_PostsUpdated event, Emitter<PostState> emit) {
    emit(state.copyWith(posts: event.posts, loading: false));
  }

  Future<void> _onLoadPosts(LoadPosts event, Emitter<PostState> emit) async {
    emit(state.copyWith(loading: true));

    final result = await getPostsUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(loading: false, error: failure.message));
      },
      (posts) {
        emit(state.copyWith(loading: false, posts: posts, error: null));
      },
    );
  }

  Future<void> _onPickMedia(
    PickMediaEvent event,
    Emitter<PostState> emit,
  ) async {
    final picked = event.file;
    if (picked == null) return;

    final isVideo =
        picked.path.endsWith(".mp4") ||
        picked.path.endsWith(".mov") ||
        picked.path.endsWith(".avi");

    if (isVideo) {
      emit(
        state.copyWith(
          selectedFile: File(picked.path),
          mediaType: MediaType.video,
        ),
      );
    } else {
      final compressed = await FlutterImageCompress.compressAndGetFile(
        picked.path,
        "${picked.path}_compressed.jpg",
        quality: 60,
      );

      if (compressed == null) return;
      if (isClosed) return;

      emit(
        state.copyWith(
          selectedFile: File(compressed.path),
          mediaType: MediaType.image,
        ),
      );
    }
  }

  Future<void> _onUploadPost(
    UploadPostEvent event,
    Emitter<PostState> emit,
  ) async {
    if (state.selectedFile == null) return;

    emit(state.copyWith(uploading: true, uploadSuccess: false, error: null));

    final result = await createPostUseCase(
      state.selectedFile!,
      state.caption,
      state.mediaType,
    );

    if (isClosed) return;

    await result.fold(
      (failure) async {
        emit(
          state.copyWith(
            uploading: false,
            uploadSuccess: false,
            error: failure.message,
          ),
        );
      },
      (_) async {
        emit(
          state.copyWith(
            uploading: false,
            selectedFile: null,
            caption: "",
            uploadSuccess: true,
          ),
        );

        final postsResult = await repository.getPosts();

        if (isClosed) return;

        postsResult.fold(
          (failure) {
            emit(state.copyWith(error: failure.message));
          },
          (posts) {
            emit(state.copyWith(posts: posts));
          },
        );

        add(ClearMediaEvent());
      },
    );
  }

  Future<void> _onRefreshPosts(
    RefreshPostsEvent event,
    Emitter<PostState> emit,
  ) async {
    emit(state.copyWith(loading: true, error: null));

    final result = await getPostsUseCase();

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(state.copyWith(loading: false, error: failure.message));
      },
      (posts) {
        emit(state.copyWith(loading: false, posts: posts, error: null));
      },
    );
  }

  void _onCaptionChanged(CaptionChangedEvent event, Emitter<PostState> emit) {
    emit(state.copyWith(caption: event.caption));
  }

  void _onClearMedia(ClearMediaEvent event, Emitter<PostState> emit) {
    emit(
      state.copyWith(
        selectedFile: null,
        caption: "",
        mediaType: MediaType.image,
        uploadSuccess: false,
      ),
    );

    emit(PostState.initial());
  }

  Future<void> _onToggleLike(
    ToggleLikeEvent event,
    Emitter<PostState> emit,
  ) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final updated = state.posts.map((post) {
      if (post.id == event.postId) {
        final isLiked = post.likedBy.contains(userId);

        final updatedLikedBy = List<String>.from(post.likedBy);

        if (isLiked) {
          updatedLikedBy.remove(userId);
        } else {
          updatedLikedBy.add(userId);
        }

        return PostEntity(
          id: post.id,
          username: post.username,
          caption: post.caption,
          mediaUrl: post.mediaUrl,
          mediaType: post.mediaType,
          likes: updatedLikedBy.length,
          time: post.time,
          likedBy: updatedLikedBy,
          comments: post.comments,
        );
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updated));

    try {
      await repository.toggleLike(event.postId, userId);
    } catch (_) {}
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<PostState> emit,
  ) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(event.userId)
        .get();

    final userData = userDoc.data();

    final newComment = CommentModel(
      userId: event.userId,
      userName: userData?['name'] ?? 'Unknown',
      userImage: userData?['profile_url'] ?? '',
      comment: event.comment,
      time: DateTime.now().toIso8601String(),
    );

    await repository.addComment(event.postId, event.comment, event.userId);

    if (isClosed) return;

    final updatedPosts = state.posts.map((post) {
      if (post.id == event.postId) {
        return PostEntity(
          id: post.id,
          username: post.username,
          caption: post.caption,
          mediaUrl: post.mediaUrl,
          mediaType: post.mediaType,
          likes: post.likes,
          time: post.time,
          likedBy: post.likedBy,
          comments: [newComment, ...post.comments],
        );
      }
      return post;
    }).toList();

    emit(state.copyWith(posts: updatedPosts));
  }

  Future<void> _onListenComments(
    ListenCommentsEvent event,
    Emitter<PostState> emit,
  ) async {
    await _commentSub?.cancel();

    _commentSub = repository.getCommentsStream(event.postId).listen((comments) {
      if (isClosed) return;

      final updatedPosts = state.posts.map((post) {
        if (post.id == event.postId) {
          return PostEntity(
            id: post.id,
            username: post.username,
            caption: post.caption,
            mediaUrl: post.mediaUrl,
            mediaType: post.mediaType,
            likes: post.likes,
            time: post.time,
            likedBy: post.likedBy,
            comments: comments,
          );
        }
        return post;
      }).toList();

      emit(state.copyWith(posts: updatedPosts));
    });
  }

  @override
  Future<void> close() {
    _commentSub?.cancel();
    _postSub?.cancel();
    return super.close();
  }
}

class _PostsUpdated extends PostEvent {
  final List<PostEntity> posts;
  _PostsUpdated(this.posts);
}
