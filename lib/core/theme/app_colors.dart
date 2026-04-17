import 'package:flutter/material.dart';
 
 
class AppColors {
  static const Color primary = Color(0xFF3897F0);
  static const Color background = Colors.black;
  static const Color cardBackground = Color(0xFF1C1C1C);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;
  static const Color fieldBackground = Color(0xFF2C2C2C);
  static const Color buttonColor = Color(0xFF3897F0);
  static const Color buttonText = Colors.white;
  static const Color border = Color(0xFFE0E0E0);
 
  static const Color profileBorderStart = Color(0xFFf58529);
  static const Color profileBorderMiddle = Color(0xFFdd2a7b);
  static const Color profileBorderEnd = Color(0xFF8134af);
  static const Color profileBackground = Color(0xFF2C2C2C);
  static const Color iconColor = Colors.white70;
 
  static const Color facebookBlue = Color(0xFF1877F2);
  static const Color googleRed = Color(0xFFEA4335);
}
 

class AppTheme {
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonColor,
        foregroundColor: AppColors.buttonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      hintStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.cardBackground,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
    ),
  );
}
