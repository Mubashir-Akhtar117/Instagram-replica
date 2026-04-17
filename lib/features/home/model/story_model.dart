import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'story_model.g.dart';

@HiveType(typeId: 1)
class StoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String userId;

  @HiveField(2)
  final String mediaUrl;

  @HiveField(3)
  final List<String> viewedBy;

  @HiveField(4)
  final DateTime time;

  @HiveField(5)
  final String type;

  StoryModel({
    required this.id,
    required this.userId,
    required this.mediaUrl,
    required this.viewedBy,
    required this.time,
    required this.type,
  });

  bool isSeen(String currentUserId) {
    return viewedBy.contains(currentUserId);
  }

  factory StoryModel.fromMap(String id, Map<String, dynamic> data) {
    return StoryModel(
      id: id,
      userId: data['userId'],
      mediaUrl: data['mediaUrl'],
      viewedBy: List<String>.from(data['viewedBy'] ?? []),
      time: data['time'] is Timestamp
          ? (data['time'] as Timestamp).toDate()
          : DateTime.parse(data['time']),
      type: data['type'] ?? 'image',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mediaUrl': mediaUrl,
      'viewedBy': viewedBy,
      'time': time.toIso8601String(),
      'type': type, 
    };
  }

  StoryModel copyWith({
    String? id,
    String? userId,
    String? mediaUrl,
    List<String>? viewedBy,
    DateTime? time,
    String? type,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      viewedBy: viewedBy ?? this.viewedBy,
      time: time ?? this.time,
      type: type ?? this.type,
    );
  }
}