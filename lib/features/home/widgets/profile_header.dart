import 'package:flutter/material.dart';
import 'package:sample/features/auth/donain/entities/user.dart';
import 'gradient_avatar.dart';
import 'stat_item.dart';

class ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    print("userssssss${user.email}");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          GradientAvatar(imageUrl: user.profileUrl),
          const SizedBox(width: 20),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(count: user.posts.toString(), label: 'posts'),
                StatItem(count: user.followers.toString(), label: 'followers'),
                StatItem(count: user.following.toString(), label: 'following'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
