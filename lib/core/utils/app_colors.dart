import 'package:flutter/material.dart';

/// Every color used in the app. Matches the admin panel brand (cyan, shade 8).
abstract final class AppColors {
  // Brand
  static const Color primary = Color(0xFF0C8599);
  static const Color primaryDark = Color(0xFF0B7285);
  static const Color primaryLight = Color(0xFFE3FAFC);
  static const Color onPrimary = Color(0xFFFFFFFF);

  // Surfaces
  static const Color background = Color(0xFFF6F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF1F3F5);
  static const Color border = Color(0xFFDEE2E6);
  static const Color divider = Color(0xFFE9ECEF);

  // Text
  static const Color textPrimary = Color(0xFF212529);
  static const Color textSecondary = Color(0xFF495057);
  static const Color textMuted = Color(0xFF868E96);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Status
  static const Color success = Color(0xFF2B8A3E);
  static const Color successLight = Color(0xFFEBFBEE);
  static const Color successBright = Color(0xFF2F9E44);
  static const Color warning = Color(0xFFE67700);
  static const Color warningLight = Color(0xFFFFF9DB);
  static const Color danger = Color(0xFFC92A2A);
  static const Color dangerLight = Color(0xFFFFF5F5);
  static const Color info = Color(0xFF1971C2);
  static const Color infoLight = Color(0xFFE7F5FF);
  static const Color neutral = Color(0xFF868E96);
  static const Color neutralLight = Color(0xFFF1F3F5);

  // Misc
  static const Color transparent = Color(0x00000000);
  static const Color scrim = Color(0x99000000);
  static const Color scannerFrame = Color(0xFFFFFFFF);
}
