// enum MediaType { image, video }

// class PostModel {
//   final String username;
//   final String caption;
//   final String mediaUrl;
//   final MediaType mediaType;
//   final int likes;
//   final String time;

//   PostModel({
//     required this.username,
//     required this.caption,
//     required this.mediaUrl,
//     required this.mediaType,
//     required this.likes,
//     required this.time,
//   });

//   factory PostModel.fromMap(Map<String, dynamic> map) {
//     return PostModel(
//       username: map['username'] ?? '',
//       caption: map['caption'] ?? '',
//       mediaUrl: map['mediaUrl'] ?? '',
//       mediaType: map['mediaType'] == 'video'
//           ? MediaType.video
//           : MediaType.image,
//       likes: map['likes'] ?? 0,
//       time: map['time'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'username': username,
//       'caption': caption,
//       'mediaUrl': mediaUrl,
//       'mediaType': mediaType == MediaType.video ? 'video' : 'image',
//       'likes': likes,
//       'time': time,
//     };
//   }
// }
