import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderEngineProvider extends ChangeNotifier {

  /// ==============================
  /// PREFS
  /// ==============================

  SharedPreferences? _prefs;

  /// ==============================
  /// SETTINGS
  /// ==============================

  double _fontSize = 18;
  bool _darkMode = true;

  /// ==============================
  /// BOOK STATE
  /// ==============================

  String? _bookId;
  int _currentPage = 0;
  int _totalPages = 0;

  /// ==============================
  /// SESSION
  /// ==============================

  DateTime? _sessionStart;
  int _readingSeconds = 0;

  /// ==============================
  /// PREF KEYS
  /// ==============================

  static const _fontKey = "reader_font";
  static const _themeKey = "reader_theme";

  /// ==============================
  /// GETTERS
  /// ==============================

  double get fontSize => _fontSize;
  bool get darkMode => _darkMode;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get readingSeconds => _readingSeconds;
  String? get currentBook => _bookId;

  double get progress {
    if (_totalPages <= 0) return 0;
    final value = (_currentPage / _totalPages) * 100;
    return value.clamp(0.0, 100.0).toDouble();
  }

  /// ==============================
  /// LOAD SETTINGS
  /// ==============================

  Future<void> loadSettings() async {

    _prefs ??= await SharedPreferences.getInstance();

    _fontSize = _prefs!.getDouble(_fontKey) ?? 18;
    _darkMode = _prefs!.getBool(_themeKey) ?? true;

    notifyListeners();
  }

  /// ==============================
  /// OPEN BOOK
  /// ==============================

  Future<void> openBook({
    required String bookId,
    required int totalPages,
  }) async {

    _prefs ??= await SharedPreferences.getInstance();

    _bookId = bookId;
    _totalPages = totalPages;

    _currentPage = _prefs!.getInt("reader_page_$bookId") ?? 0;

    _startSession();

    notifyListeners();
  }

  /// ==============================
  /// UPDATE PAGE
  /// ==============================

  Future<void> updatePage(int page) async {

    if (_bookId == null) return;

    _prefs ??= await SharedPreferences.getInstance();

    final int safePage = page.clamp(0, _totalPages);

    _currentPage = safePage;

    await _prefs!.setInt("reader_page_$_bookId", safePage);

    notifyListeners();
  }

  /// ==============================
  /// CHANGE FONT
  /// ==============================

  Future<void> changeFont(double size) async {

    _prefs ??= await SharedPreferences.getInstance();

    final double safeSize =
        size.clamp(12.0, 40.0).toDouble();

    _fontSize = safeSize;

    await _prefs!.setDouble(_fontKey, safeSize);

    notifyListeners();
  }

  /// ==============================
  /// TOGGLE THEME
  /// ==============================

  Future<void> toggleTheme() async {

    _prefs ??= await SharedPreferences.getInstance();

    _darkMode = !_darkMode;

    await _prefs!.setBool(_themeKey, _darkMode);

    notifyListeners();
  }

  /// ==============================
  /// SESSION START
  /// ==============================

  void _startSession() {
    _sessionStart = DateTime.now();
  }

  /// ==============================
  /// SESSION END
  /// ==============================

  void endSession() {

    if (_sessionStart == null) return;

    final seconds =
        DateTime.now().difference(_sessionStart!).inSeconds;

    _readingSeconds += seconds;

    _sessionStart = null;

    notifyListeners();
  }

  /// ==============================
  /// RESET BOOK PROGRESS
  /// ==============================

  Future<void> resetBook() async {

    if (_bookId == null) return;

    _prefs ??= await SharedPreferences.getInstance();

    await _prefs!.remove("reader_page_$_bookId");

    _currentPage = 0;

    notifyListeners();
  }

  /// ==============================
  /// CLOSE BOOK
  /// ==============================

  void closeBook() {

    endSession();

    _bookId = null;
    _currentPage = 0;
    _totalPages = 0;

    notifyListeners();
  }

  /// ==============================
  /// DISPOSE
  /// ==============================

  @override
  void dispose() {
    endSession();
    super.dispose();
  }
}