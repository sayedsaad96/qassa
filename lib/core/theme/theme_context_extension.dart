import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Convenience extensions on [BuildContext] to access the app's
/// design-system tokens without importing constants everywhere.
extension ThemeContextExtension on BuildContext {
  /// Quick access to the app color palette via `context.colors.primary`, etc.
  AppColorsAccessor get colors => const AppColorsAccessor();

  /// Quick access to the text style catalogue via `context.textStyles.body`, etc.
  AppTextStylesAccessor get textStyles => const AppTextStylesAccessor();
}

/// Runtime-accessible wrapper around [AppColors] static members.
///
/// Allows `context.colors.primary` instead of `AppColors.primary`.
class AppColorsAccessor {
  const AppColorsAccessor();

  // ── Primary ──────────────────────────────────────
  Color get primary => AppColors.primary;
  Color get primaryMid => AppColors.primaryMid;
  Color get primaryLight => AppColors.primaryLight;
  Color get primaryPale => AppColors.primaryPale;
  Color get primaryGlow => AppColors.primaryGlow;

  // ── Accent ───────────────────────────────────────
  Color get accent => AppColors.accent;
  Color get accentLight => AppColors.accentLight;
  Color get accentPale => AppColors.accentPale;

  // ── Semantic ─────────────────────────────────────
  Color get success => AppColors.success;
  Color get successBg => AppColors.successBg;
  Color get warning => AppColors.warning;
  Color get warningBg => AppColors.warningBg;
  Color get error => AppColors.error;
  Color get errorBg => AppColors.errorBg;

  // ── Neutrals ─────────────────────────────────────
  Color get background => AppColors.background;
  Color get surface => AppColors.surface;
  Color get border => AppColors.border;
  Color get border2 => AppColors.border2;

  // ── Text ─────────────────────────────────────────
  Color get textPrimary => AppColors.textPrimary;
  Color get textSecondary => AppColors.textSecondary;
  Color get textDisabled => AppColors.textDisabled;
  Color get textInverse => AppColors.textInverse;

  // ── Gradients ────────────────────────────────────
  LinearGradient get primaryGradient => AppColors.primaryGradient;
  LinearGradient get headerGradient => AppColors.headerGradient;
}

/// Runtime-accessible wrapper around [AppTextStyles] static members.
///
/// Allows `context.textStyles.body` instead of `AppTextStyles.body`.
class AppTextStylesAccessor {
  const AppTextStylesAccessor();

  TextStyle get display => AppTextStyles.display;
  TextStyle get h1 => AppTextStyles.h1;
  TextStyle get h2 => AppTextStyles.h2;
  TextStyle get h3 => AppTextStyles.h3;
  TextStyle get h4 => AppTextStyles.h4;
  TextStyle get h5 => AppTextStyles.h5;
  TextStyle get bodyLg => AppTextStyles.bodyLg;
  TextStyle get body => AppTextStyles.body;
  TextStyle get bodySm => AppTextStyles.bodySm;
  TextStyle get caption => AppTextStyles.caption;
  TextStyle get label => AppTextStyles.label;
  TextStyle get btnText => AppTextStyles.btnText;
  TextStyle get btnTextSm => AppTextStyles.btnTextSm;
}
