import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  // ── Cairo (Display / Headings) ────────────────────
  static const TextStyle display = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 28,
    fontWeight: FontWeight.w900,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h4 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle h5 = TextStyle(
    fontFamily: 'Cairo',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ── Tajawal (Body / UI) ───────────────────────────
  static const TextStyle bodyLg = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.7,
  );

  static const TextStyle body = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.7,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle label = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle btnText = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textInverse,
    height: 1.0,
  );

  static const TextStyle btnTextSm = TextStyle(
    fontFamily: 'Tajawal',
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.textInverse,
    height: 1.0,
  );
}
