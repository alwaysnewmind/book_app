import 'package:flutter/material.dart';

class AppTheme {
  static const Color darkBg = Color(0xFF0E1A1A);
  static const Color darkCard = Color(0xFF132222);
  static const Color accent = Color(0xFFE50914);

  // 🌙 DARK
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    primaryColor: accent,
    cardColor: darkCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      elevation: 0,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white10,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
    ),
  );

  // ☀️ LIGHT
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Color(0xFFF6F7F9),
    primaryColor: accent,
    cardColor: Colors.white,
  );

  // 🎬 NETFLIX GRADIENT
  static const LinearGradient accentGradient = LinearGradient(
    colors: [
      Color(0xFFE50914),
      Color(0xFFB81D24),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
