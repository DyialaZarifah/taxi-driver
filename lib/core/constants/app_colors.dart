// lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary (Taxi Yellow)
  static const Color primary = Color(0xFFFFC107);
  static const Color primaryDark = Color(0xFFFFB300);
  static const Color primaryLight = Color(0xFFFFECB3);

  // Neutrals
  static const Color black = Color(0xFF1A1A1A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF5F5F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color borderGrey = Color(0xFFE0E0E0);
  static const Color dividerGrey = Color(0xFFEEEEEE);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F5F5), Color(0xFFFFF9E6)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}