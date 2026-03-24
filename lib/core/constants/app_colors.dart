import 'package:flutter/material.dart';

abstract class AppColors {
  // ── Primary ──────────────────────────────────────
  static const Color primary = Color(0xFF1A3FC4);
  static const Color primaryMid = Color(0xFF2952DC);
  static const Color primaryLight = Color(0xFF4F72F0);
  static const Color primaryPale = Color(0xFFEEF2FF);
  static const Color primaryGlow = Color(0x264F72F0);

  // ── Accent ───────────────────────────────────────
  static const Color accent = Color(0xFFFF5C00);
  static const Color accentLight = Color(0xFFFF8040);
  static const Color accentPale = Color(0xFFFFF0E8);

  // ── Semantic ─────────────────────────────────────
  static const Color success = Color(0xFF00A86B);
  static const Color successBg = Color(0xFFE6F9F3);
  static const Color warning = Color(0xFFE88C00);
  static const Color warningBg = Color(0xFFFFF8E6);
  static const Color error = Color(0xFFE0230E);
  static const Color errorBg = Color(0xFFFDEEEB);

  // ── Neutrals ─────────────────────────────────────
  static const Color background = Color(0xFFF4F6FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE4E9F2);
  static const Color border2 = Color(0xFFCDD5E8);

  // ── Text ─────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0D1526);
  static const Color textSecondary = Color(0xFF5A6A8A);
  static const Color textDisabled = Color(0xFF9BACC8);
  static const Color textInverse = Color(0xFFFFFFFF);

  // ── Gradients ────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D2260), primary],
  );
}
