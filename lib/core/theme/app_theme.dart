import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  // =========================
  // 🌞 LIGHT THEME (Premium Purple UI)
  // =========================

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF6F7FB),

    primaryColor: const Color(0xFF7B4DFF),

    colorScheme: const ColorScheme.light(
      primary: Color(0xFF7B4DFF),
      secondary: Color(0xFF9F67FF),
      surface: Colors.white,
      background: Color(0xFFF6F7FB),
      onPrimary: Colors.white,
      onSurface: Color(0xFF1C1C1E),
    ),

    dividerColor: const Color(0xFFE9E9F2),

    // =========================
    // 📝 TEXT THEME
    // =========================

    textTheme: TextTheme(
      displayLarge:
          AppTypography.displayLarge.copyWith(color: const Color(0xFF1C1C1E)),
      titleLarge:
          AppTypography.titleLarge.copyWith(color: const Color(0xFF1C1C1E)),
      titleMedium:
          AppTypography.titleMedium.copyWith(color: const Color(0xFF2C2C2E)),
      bodyLarge:
          AppTypography.bodyLarge.copyWith(color: const Color(0xFF3A3A3C)),
      bodyMedium:
          AppTypography.bodyMedium.copyWith(color: const Color(0xFF6E6E73)),
      labelSmall:
          AppTypography.labelSmall.copyWith(color: const Color(0xFF8E8E93)),
    ),

    // =========================
    // 📱 APP BAR (Gradient Ready)
    // =========================

    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),

    // =========================
    // 🧾 CARD THEME (Soft Premium)
    // =========================

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    // =========================
    // 🔘 ELEVATED BUTTON (Gradient Style)
    // =========================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    ),

    // =========================
    // 🧊 INPUT FIELDS (Soft Glass Look)
    // =========================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      hintStyle: const TextStyle(
        color: Color(0xFF9E9E9E),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(
          color: Color(0xFF7B4DFF),
          width: 1.2,
        ),
      ),
    ),

    // =========================
    // 🧭 BOTTOM NAV BAR
    // =========================

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Color(0xFF7B4DFF),
      unselectedItemColor: Color(0xFF9E9E9E),
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),

    // =========================
    // 🎨 ICON THEME
    // =========================

    iconTheme: const IconThemeData(
      color: Color(0xFF2C2C2E),
    ),

    splashFactory: InkRipple.splashFactory,
  );

  // =========================
  // 🌙 DARK THEME (Luxury Purple Dark)
  // =========================

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF121212),

    primaryColor: const Color(0xFF9F67FF),

    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF9F67FF),
      secondary: Color(0xFF7B4DFF),
      surface: Color(0xFF1E1E1E),
      background: Color(0xFF121212),
      onPrimary: Colors.white,
      onSurface: Colors.white,
    ),

    dividerColor: const Color(0xFF2C2C2E),

    textTheme: TextTheme(
      displayLarge:
          AppTypography.displayLarge.copyWith(color: Colors.white),
      titleLarge:
          AppTypography.titleLarge.copyWith(color: Colors.white),
      titleMedium:
          AppTypography.titleMedium.copyWith(color: Colors.white70),
      bodyLarge:
          AppTypography.bodyLarge.copyWith(color: Colors.white70),
      bodyMedium:
          AppTypography.bodyMedium.copyWith(color: Colors.white60),
      labelSmall:
          AppTypography.labelSmall.copyWith(color: Colors.white54),
    ),

    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: const IconThemeData(color: Colors.white),
      titleTextStyle: AppTypography.titleLarge.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
    ),

    cardTheme: CardThemeData(
      color: const Color(0xFF1E1E1E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        textStyle: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
        borderSide: const BorderSide(
          color: Color(0xFF9F67FF),
          width: 1.2,
        ),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF1E1E1E),
      selectedItemColor: Color(0xFF9F67FF),
      unselectedItemColor: Colors.white54,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
    ),
  );
}
