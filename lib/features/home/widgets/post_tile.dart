// import 'package:flutter/material.dart';
// import 'package:sample/core/theme/app_colors.dart';
// import 'package:sample/features/home/model/post_model.dart';

// class PostTile extends StatelessWidget {
//   final PostModel post;
//   const PostTile({super.key, required this.post});

//   bool get isVideo => post.mediaType == MediaType.video;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         // ── Thumbnail ──────────────────────────────────────────────────
//         Image.network(
//           post.mediaUrl,
//           fit: BoxFit.cover,
//           loadingBuilder: (context, child, loadingProgress) {
//             if (loadingProgress == null) return child;
//             return Container(
//               color: AppColors.cardBackground,
//               child: const Center(
//                 child: SizedBox(
//                   width: 20,
//                   height: 20,
//                   child: CircularProgressIndicator(
//                     strokeWidth: 1.5,
//                     color: AppColors.primary,
//                   ),
//                 ),
//               ),
//             );
//           },
//           errorBuilder: (context, error, stackTrace) {
//             return Container(
//               color: AppColors.cardBackground,
//               child: const Icon(
//                 Icons.broken_image_outlined,
//                 color: AppColors.textSecondary,
//                 size: 28,
//               ),
//             );
//           },
//         ),

//         // ── Video Overlay ──────────────────────────────────────────────
//         if (isVideo) ...[
//           Positioned(
//             top: 0,
//             right: 0,
//             child: Container(
//               width: 60,
//               height: 40,
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.transparent, Colors.black54],
//                   begin: Alignment.centerLeft,
//                   end: Alignment.centerRight,
//                 ),
//               ),
//             ),
//           ),
//           const Positioned(
//             top: 6,
//             right: 6,
//             child: Icon(
//               Icons.videocam_rounded,
//               color: Colors.white,
//               size: 18,
//               shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
//             ),
//           ),
//           Center(
//             child: Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 color: Colors.black.withOpacity(0.45),
//                 shape: BoxShape.circle,
//               ),
//               child: const Icon(
//                 Icons.play_arrow_rounded,
//                 color: Colors.white,
//                 size: 22,
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//   }
// }
