import 'package:flutter/material.dart';
import 'package:sample/core/theme/app_colors.dart';
import 'package:sample/features/home/widgets/outline_button.dart';

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          Expanded(child: OutlineButton(label: 'Edit profile')),
          const SizedBox(width: 8),
          Expanded(child: OutlineButton(label: 'Share profile')),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.fieldBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.person_add_alt_1,
                color: AppColors.textPrimary,
                size: 18,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              constraints: const BoxConstraints(),
            ),
          ),
        ],
      ),
    );
  }
}
