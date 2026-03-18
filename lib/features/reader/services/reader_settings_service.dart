import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

enum ReaderThemeMode { light, dark, sepia }

class ReaderSettingsService {
  static const _storageKey = "reader_settings";

  SharedPreferences? _prefs;
  bool _initialized = false;

  // SETTINGS STATE
  double _fontSize = 18.0;
  ReaderThemeMode _themeMode = ReaderThemeMode.light;

  /// ===============================
  /// INITIALIZE SERVICE
  /// ===============================
  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_storageKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;

        _fontSize = ((decoded['fontSize'] ?? 18) as num).toDouble();

        final themeString = decoded['themeMode'] ?? 'light';
        switch (themeString) {
          case 'dark':
            _themeMode = ReaderThemeMode.dark;
            break;
          case 'sepia':
            _themeMode = ReaderThemeMode.sepia;
            break;
          default:
            _themeMode = ReaderThemeMode.light;
        }
      } catch (_) {
        _fontSize = 18.0;
        _themeMode = ReaderThemeMode.light;
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// GETTERS
  /// ===============================
  double get fontSize => _fontSize;
  ReaderThemeMode get themeMode => _themeMode;

  /// ===============================
  /// FONT SIZE CONTROL
  /// ===============================
  Future<void> increaseFont({double step = 2.0, double max = 32.0}) async {
    if (_fontSize >= max) return;
    _fontSize += step;
    await _save();
  }

  Future<void> decreaseFont({double step = 2.0, double min = 14.0}) async {
    if (_fontSize <= min) return;
    _fontSize -= step;
    await _save();
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size.clamp(14.0, 32.0);
    await _save();
  }

  /// ===============================
  /// THEME CONTROL
  /// ===============================
  Future<void> setTheme(ReaderThemeMode mode) async {
    _themeMode = mode;
    await _save();
  }

  /// ===============================
  /// RESET SETTINGS
  /// ===============================
  Future<void> resetSettings() async {
    _fontSize = 18.0;
    _themeMode = ReaderThemeMode.light;
    await _save();
  }

  /// ===============================
  /// SAVE TO STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    final data = {
      'fontSize': _fontSize,
      'themeMode': _themeMode.name,
    };
    await _prefs!.setString(_storageKey, jsonEncode(data));
  }
}