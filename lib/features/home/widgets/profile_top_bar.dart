import 'package:flutter/material.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/features/auth/donain/entities/user.dart';

class TopBar extends StatelessWidget {
  final UserEntity user;

  const TopBar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline,
                color: AppColors.textPrimary,
                size: 16,
              ),
              const SizedBox(width: 4),

              Text(
                user.name,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textPrimary,
                size: 18,
              ),

              const SizedBox(width: 4),

              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF3040),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),

          Row(
            children: const [
              Icon(
                Icons.grid_view_rounded,
                color: AppColors.textPrimary,
                size: 24,
              ),
              SizedBox(width: 16),
              Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textPrimary,
                size: 26,
              ),
              SizedBox(width: 16),
              Icon(Icons.menu, color: AppColors.textPrimary, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}
