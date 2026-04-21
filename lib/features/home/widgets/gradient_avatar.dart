import 'package:flutter/material.dart';
import 'package:sample/core/theme/app_colors.dart';

class GradientAvatar extends StatelessWidget {
  final String imageUrl;

  const GradientAvatar({super.key, required this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.profileBorderStart,
                AppColors.profileBorderMiddle,
                AppColors.profileBorderEnd,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          padding: const EdgeInsets.all(2.5),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            ),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
          ),
        ),
      ],
    );
  }
}
