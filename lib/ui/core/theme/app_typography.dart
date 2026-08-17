import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Apple SF Pro / Inter typography rules conforming to DESIGN.md
class AppTypography {
  AppTypography._();

  static const TextStyle heroDisplay = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.8,
    height: 1.1,
    color: AppColors.ink,
  );

  static const TextStyle displayLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    height: 1.15,
    color: AppColors.ink,
  );

  static const TextStyle displayMd = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.37,
    height: 1.2,
    color: AppColors.ink,
  );

  static const TextStyle lead = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.3,
    color: AppColors.inkMuted80,
  );

  static const TextStyle tagline = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.25,
    color: AppColors.ink,
  );

  static const TextStyle bodyStrong = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.37,
    height: 1.35,
    color: AppColors.ink,
  );

  static const TextStyle body = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.37,
    height: 1.45,
    color: AppColors.ink,
  );

  static const TextStyle bodyMuted = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
    height: 1.4,
    color: AppColors.textMuted,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.22,
    height: 1.4,
    color: AppColors.textMuted,
  );

  static const TextStyle captionStrong = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.22,
    height: 1.3,
    color: AppColors.ink,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: Colors.white,
  );

  static const TextStyle micro = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AppColors.textMuted,
  );
}
