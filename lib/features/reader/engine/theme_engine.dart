import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReaderThemeMode {
  light,
  dark,
  sepia,
}

class ThemeEngine extends ChangeNotifier {

  static const _themeKey = "reader_theme_mode";

  ReaderThemeMode _themeMode = ReaderThemeMode.light;

  ReaderThemeMode get themeMode => _themeMode;

  /// ==========================
  /// INIT (load saved theme)
  /// ==========================

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final value = prefs.getString(_themeKey);

    if (value != null) {
      _themeMode = ReaderThemeMode.values.firstWhere(
        (e) => e.name == value,
        orElse: () => ReaderThemeMode.light,
      );
    }
  }

  /// ==========================
  /// CHANGE THEME
  /// ==========================

  Future<void> setTheme(ReaderThemeMode mode) async {
    _themeMode = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);

    notifyListeners();
  }

  /// ==========================
  /// COLORS
  /// ==========================

  Color get backgroundColor {
    switch (_themeMode) {
      case ReaderThemeMode.dark:
        return const Color(0xFF000000);

      case ReaderThemeMode.sepia:
        return const Color(0xFFF4ECD8);

      case ReaderThemeMode.light:
      
        return Colors.white;
    }
  }

  Color get textColor {
    switch (_themeMode) {
      case ReaderThemeMode.dark:
        return Colors.white;

      case ReaderThemeMode.sepia:
        return const Color(0xFF5B4636);

      case ReaderThemeMode.light:
      
        return Colors.black;
    }
  }

  Color get toolbarColor {
    switch (_themeMode) {
      case ReaderThemeMode.dark:
        return const Color(0xFF121212);

      case ReaderThemeMode.sepia:
        return const Color(0xFFE7D8B5);

      case ReaderThemeMode.light:
    
        return Colors.white;
    }
  }

  Color get highlightColor {
    switch (_themeMode) {
      case ReaderThemeMode.dark:
        return Colors.yellow.shade700;

      case ReaderThemeMode.sepia:
        return Colors.orange.shade300;

      case ReaderThemeMode.light:
      
        return Colors.yellow.shade300;
    }
  }

  Color get selectionColor {
    switch (_themeMode) {
      case ReaderThemeMode.dark:
        return Colors.blueAccent;

      case ReaderThemeMode.sepia:
        return Colors.brown.shade400;

      case ReaderThemeMode.light:
      
        return Colors.blue;
    }
  }

}