import 'package:hive/hive.dart';
import '../../model/comment_model.dart';

part 'post_entity.g.dart';

enum MediaType { image, video }

extension MediaTypeX on MediaType {
  int toInt() => index;

  static MediaType fromInt(int i) => MediaType.values[i];
}

@HiveType(typeId: 2)
class PostEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String caption;

  @HiveField(3)
  final String mediaUrl;

  @HiveField(4)
  final MediaType mediaType;

  @HiveField(5)
  final int likes;

  @HiveField(6)
  final String time;

  @HiveField(7)
  final List<String> likedBy;

  @HiveField(8)
  final List<CommentModel> comments;

  PostEntity({
    required this.id,
    required this.username,
    required this.caption,
    required this.mediaUrl,
    required this.mediaType,
    required this.likes,
    required this.time,
    required this.likedBy,
    required this.comments,
  });
  Map<String, dynamic> toMap() {
  return {
    'id': id,
    'username': username,
    'caption': caption,
    'mediaUrl': mediaUrl,
    'mediaType': mediaType.index,
    'likes': likes,
    'time': time,
    'likedBy': likedBy,
    'comments': comments.map((e) => e.toMap()).toList(),
  };
}
factory PostEntity.fromMap(Map<String, dynamic> map) {
  return PostEntity(
    id: map['id'],
    username: map['username'],
    caption: map['caption'],
    mediaUrl: map['mediaUrl'],
    mediaType: MediaType.values[map['mediaType']],
    likes: map['likes'],
    time: map['time'],
    likedBy: List<String>.from(map['likedBy']),
    comments: (map['comments'] as List)
        .map((e) => CommentModel.fromMap(e))
        .toList(),
  );
}
}
