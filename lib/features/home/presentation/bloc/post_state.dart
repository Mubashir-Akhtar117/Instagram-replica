import 'dart:io';
import '../../domain/entities/post_entity.dart';

class PostState {
  final List<PostEntity> posts;
  final bool loading;
  final File? selectedFile;
  final String caption;
  final bool uploading;
  final bool uploadSuccess;
  final MediaType mediaType; 
  final String? error;

  PostState({
    required this.posts,
    required this.loading,
    required this.selectedFile,
    required this.caption,
    required this.uploading,
    required this.uploadSuccess,
    required this.mediaType,
    this.error
  });

  factory PostState.initial() {
    return PostState(
      posts: [],
      loading: false,
      selectedFile: null,
      caption: "",
      uploading: false,
      uploadSuccess: false,
      mediaType: MediaType.image, 
       error: null,
    );
  }

  PostState copyWith({
    List<PostEntity>? posts,
    bool? loading,
    File? selectedFile,
    String? caption,
    bool? uploading,
    bool? uploadSuccess,
    MediaType? mediaType,
     String? error
  }) {
    return PostState(
      posts: posts ?? this.posts,
      loading: loading ?? this.loading,
      selectedFile: selectedFile ?? this.selectedFile,
      caption: caption ?? this.caption,
      uploading: uploading ?? this.uploading,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
      mediaType: mediaType ?? this.mediaType, 
        error: error,
    );
  }
}
