import 'package:flutter/material.dart';

/// BiteBox light palette (inspired by common delivery design tokens).
abstract final class AppColors {
  static const Color primary = Color(0xFFFF4B3A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0x1AFF4B3A);

  static const Color secondary = Color(0xFF2D2D2D);
  static const Color onSecondary = Color(0xFFFFFFFF);

  static const Color accent = Color(0xFFFFC107);
  static const Color onAccent = Color(0xFF000000);

  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F3F5);

  static const Color primaryText = Color(0xFF1A1C1E);
  static const Color secondaryText = Color(0xFF6C757D);
  static const Color hint = Color(0xFFADB5BD);

  static const Color outline = Color(0xFFDEE2E6);
  static const Color divider = Color(0xFFE9ECEF);

  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFD7E14);
  static const Color error = Color(0xFFDC3545);
  static const Color info = Color(0xFF0D6EFD);
}
