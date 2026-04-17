import 'dart:io';
import 'package:sample/features/home/domain/entities/post_entity.dart';
import 'package:sample/features/home/domain/repository/post_repository.dart';

class CreatePostUseCase {
  final PostRepository repository;

  CreatePostUseCase(this.repository);

  Future<void> call(File file, String caption, MediaType mediaType) async {
    await repository.createPost(file, caption, mediaType);
  }
}
