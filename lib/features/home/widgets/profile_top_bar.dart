 
import 'package:flutter/material.dart';
import 'package:sample/core/theme/app_colors.dart';

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline,
                  color: AppColors.textPrimary, size: 16),
              const SizedBox(width: 4),
              const Text(
                'shaikhh_mu...',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.textPrimary, size: 18),
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
            children: [
              const Icon(Icons.grid_view_rounded,
                  color: AppColors.textPrimary, size: 24),
              const SizedBox(width: 16),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded,
                      color: AppColors.textPrimary, size: 26),
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text('9+',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              const Icon(Icons.menu, color: AppColors.textPrimary, size: 24),
            ],
          ),
        ],
      ),
    );
  }
}
 