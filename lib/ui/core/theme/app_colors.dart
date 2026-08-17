import 'package:flutter/material.dart';

/// Apple-inspired design tokens conforming to DESIGN.md
class AppColors {
  AppColors._();

  // Brand & Action
  static const Color primary = Color(0xFF0066CC); // Action Blue
  static const Color primaryFocus = Color(0xFF0071E3);
  static const Color primaryOnDark = Color(0xFF2997FF);

  // Canvas & Surfaces
  static const Color canvas = Color(0xFFFFFFFF); // Pure White
  static const Color canvasParchment = Color(0xFFF5F5F7); // Signature Apple Parchment
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfacePearl = Color(0xFFFAFAFC);
  static const Color surfaceTileDark = Color(0xFF1D1D1F); // Apple Ink Near-Black
  static const Color surfaceTileDark2 = Color(0xFF272729);
  static const Color surfaceTranslucent = Color(0xD2D2D7A3); // ~64% Translucent Chip

  // Text / Ink
  static const Color ink = Color(0xFF1D1D1F);
  static const Color inkMuted80 = Color(0xFF333333);
  static const Color inkMuted48 = Color(0xFF7A7A7A);
  static const Color textMuted = Color(0xFF86868B);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0xFFCCCCCC);

  // Status Colors
  static const Color statusAhead = Color(0xFF0066CC); // Blue
  static const Color statusOnTrack = Color(0xFF34C759); // Apple Green
  static const Color statusNeedsAttention = Color(0xFFFF9500); // Apple Orange
  static const Color statusBehind = Color(0xFFFF3B30); // Apple Red

  // Hairlines & Dividers
  static const Color hairline = Color(0xFFE5E5EA);
  static const Color dividerSoft = Color(0xFFF0F0F0);
}
