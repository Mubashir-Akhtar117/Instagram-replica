import 'package:hive/hive.dart';

part 'comment_model.g.dart';

@HiveType(typeId: 3)
class CommentModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String userName;

  @HiveField(2)
  final String userImage;

  @HiveField(3)
  final String comment;

  @HiveField(4)
  final String time;

  CommentModel({
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.comment,
    required this.time,
  });

  factory CommentModel.fromMap(Map<String, dynamic> data) {
    return CommentModel(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Unknown',
      userImage: data['userImage'] ?? '',
      comment: data['comment'] ?? '',
      time: data['time'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'comment': comment,
      'time': time,
    };
  }
}
