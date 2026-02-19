import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /* ------------------------------------------------------------------
   * 🎨 BRAND COLORS (Premium Purple Identity)
   * ------------------------------------------------------------------ */

  static const Color primary = Color(0xFF7B4DFF);       // Main Purple
  static const Color primaryLight = Color(0xFF9F67FF);  // Gradient Light
  static const Color primaryDark = Color(0xFF5E35F0);   // Deep Purple

  static const Color accent = Color(0xFFFFC857);        // Elegant Gold

  /* Gradient (for buttons / headers / highlights) */
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color(0xFF7B4DFF),
      Color(0xFF9F67FF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

// Card
  static const Color card = Colors.white;
  static const Color darkCard = Color(0xFF1E1E1E);
  /* ------------------------------------------------------------------
   * 🌞 LIGHT THEME COLORS
   * ------------------------------------------------------------------ */

  static const Color background = Color(0xFFF6F7FB);   // Soft cool white
  static const Color surface = Color(0xFFFFFFFF);      // Cards
  static const Color surfaceSoft = Color(0xFFF1F2F6);  // Sections

  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6E6E73);
  static const Color textMuted = Color(0xFF9E9E9E);

  static const Color border = Color(0xFFE9E9F2);
  static const Color icon = Color(0xFF2C2C2E);

  /* ------------------------------------------------------------------
   * 🌙 DARK THEME COLORS (Luxury Dark)
   * ------------------------------------------------------------------ */

  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color surfaceSoftDark = Color(0xFF252525);

  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color textMutedDark = Color(0xFF8E8E93);

  static const Color borderDark = Color(0xFF2C2C2E);
  static const Color iconDark = Color(0xFFE0E0E0);

  /* ------------------------------------------------------------------
   * 🚦 STATE COLORS (Balanced & Modern)
   * ------------------------------------------------------------------ */

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  /* ------------------------------------------------------------------
   * 🪄 SHADOWS & OVERLAYS
   * ------------------------------------------------------------------ */

  static const Color shadowLight = Color(0x14000000); // 8%
  static const Color shadowMedium = Color(0x1F000000); // 12%
  static const Color shadowDark = Color(0x33000000);  // 20%

  static const Color overlayLight = Color(0xAAFFFFFF);
  static const Color overlayDark = Color(0xAA000000);

  static const Color divider = border;
  static const Color dividerDark = borderDark;

  /* ------------------------------------------------------------------
   * 💎 PREMIUM EXTRAS
   * ------------------------------------------------------------------ */

  static const Color gold = Color(0xFFFFD700);
  static const Color shimmerBase = Color(0xFFEDEDED);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

}
