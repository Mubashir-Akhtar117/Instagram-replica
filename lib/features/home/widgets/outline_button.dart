import 'package:flutter/material.dart';
import 'package:sample/core/theme/app_colors.dart';

class OutlineButton extends StatelessWidget {
  final String label;
  const OutlineButton({super.key, required this.label});
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.fieldBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}