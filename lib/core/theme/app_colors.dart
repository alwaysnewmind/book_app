import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor

  /* ------------------------------------------------------------------
   * BRAND COLORS
   * ------------------------------------------------------------------ */
  static const Color primary = Color(0xFF6C5CE7);      // Royal Violet
  static const Color primaryDark = Color(0xFFA29BFE);  // Light Violet
  static const Color accent = Color(0xFFFDCB6E);       // Soft Gold

  /* ------------------------------------------------------------------
   * LIGHT THEME COLORS
   * ------------------------------------------------------------------ */
  static const Color background = Color(0xFFFAFAF8);  // Paper tone
  static const Color surface = Color(0xFFFFFFFF);     // Cards, containers
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6E6E6E);
  static const Color border = Color(0xFFE5E5E5);
  static const Color icon = Color(0xFF3A3A3A);

  /* ------------------------------------------------------------------
   * DARK THEME COLORS
   * ------------------------------------------------------------------ */
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color borderDark = Color(0xFF2A2A2A);
  static const Color iconDark = Color(0xFFE0E0E0);

  /* ------------------------------------------------------------------
   * STATE COLORS
   * ------------------------------------------------------------------ */
  static const Color success = Color(0xFF2ECC71);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);

  /* ------------------------------------------------------------------
   * OVERLAY / MISC
   * ------------------------------------------------------------------ */
  static const Color shadowLight = Color(0x14000000); // 8% black
  static const Color shadowDark = Color(0x33000000);  // 20% black
  static const Color divider = border;
  static const Color dividerDark = borderDark;

  /* ------------------------------------------------------------------
   * CUSTOM / ADDITIONAL COLORS
   * ------------------------------------------------------------------ */
  static const Color card = Color(0xFFF8F8F8);
  static const Color cardDark = Color(0xFF2A2A2A);

  static const Color gold = Color(0xFFFFD700);        // Premium Gold
  static const Color overlayLight = Color(0xAAFFFFFF);
  static const Color overlayDark = Color(0xAA000000);
}
