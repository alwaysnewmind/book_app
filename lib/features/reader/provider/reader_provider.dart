import 'dart:convert';

import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ReaderThemeMode { light, dark, sepia }

class ReaderProvider extends ChangeNotifier {
  static const String _progressStoreKey = 'reader_provider_progress';
  static const String _settingsStoreKey = 'reader_provider_settings';
  static const String _bookmarksStoreKey = 'reader_provider_bookmarks';
  static const String _highlightsStoreKey = 'reader_provider_highlights';
  static const String _notesStoreKey = 'reader_provider_notes';
  static const String _downloadsStoreKey = 'reader_provider_downloads';

  /// PAGE CONTROLLER
  final PageController pageController = PageController();

  /// CHAPTER SYSTEM
  int _currentChapter = 0;
  int _totalChapters = 0;

  int get currentChapter => _currentChapter;
  int get previousChapter => _currentChapter > 0 ? _currentChapter - 1 : 0;

  /// UI CONTROLS
  bool _showControls = true;
  bool get showControls => _showControls;

  /// TTS STATE
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  /// PROGRESS
  double get progress => currentBookProgress;

  ReaderBookModel? _currentBook;
  String _currentBookContent = '';

  final Map<String, double> _readingProgress = {};
  final Map<String, Set<String>> _bookmarks = {};
  final Map<String, List<String>> _highlights = {};
  final Map<String, List<String>> _notes = {};
  final Set<String> _downloads = {};

  double _fontSize = 18;
  bool _darkMode = false;
  bool _sepiaMode = false;

  ReaderBookModel? get currentBook => _currentBook;
  String get currentBookContent => _currentBookContent;

  Map<String, double> get readingProgress =>
      Map.unmodifiable(_readingProgress);

  double get fontSize => _fontSize;
  bool get darkMode => _darkMode;
  bool get sepiaMode => _sepiaMode;

  Map<String, dynamic> get readerSettings => {
        'fontSize': _fontSize,
        'darkMode': _darkMode,
        'sepiaMode': _sepiaMode,
      };

  double get currentBookProgress {
    final id = _currentBook?.id;
    if (id == null) return 0;
    return _readingProgress[id] ?? _currentBook!.progressPercent;
  }

  ReaderThemeMode get themeMode {
    if (_darkMode) return ReaderThemeMode.dark;
    if (_sepiaMode) return ReaderThemeMode.sepia;
    return ReaderThemeMode.light;
  }

  /// INITIALIZE
  Future<void> initialize() async {
    await Future.wait([
      _loadProgress(),
      _loadSettings(),
      _loadDataStore(),
    ]);
    notifyListeners();
  }

  /// LOAD BOOK (Fix for error)
  void loadBook({
    required String bookId,
    required int totalChapters,
    int lastReadChapter = 0,
  }) {
    _totalChapters = totalChapters;
    _currentChapter = lastReadChapter;
    notifyListeners();
  }

  /// OPEN BOOK
  Future<void> openBook({
    required ReaderBookModel book,
    required String content,
  }) async {
    _currentBook = book;
    _currentBookContent = content;

    _readingProgress.putIfAbsent(book.id, () => book.progressPercent);

    notifyListeners();
  }

  /// NEXT CHAPTER CALLBACK (UI SAFE)
  VoidCallback? get nextChapter {
    if (_currentChapter >= _totalChapters - 1) return null;

    return () {
      _currentChapter++;
      pageController.jumpToPage(_currentChapter);
      notifyListeners();
    };
  }

  /// PREVIOUS CHAPTER CALLBACK
  VoidCallback? get goToPreviousChapter {
    if (_currentChapter <= 0) return null;

    return () {
      _currentChapter--;
      pageController.jumpToPage(_currentChapter);
      notifyListeners();
    };
  }

  /// CHANGE CHAPTER
  void setChapter(int index) {
    _currentChapter = index;
    notifyListeners();
  }

  /// UPDATE PROGRESS
  Future<void> updateProgress(double progress) async {
    final id = _currentBook?.id;
    if (id == null) return;

    _readingProgress[id] = progress.clamp(0, 100).toDouble();

    await _saveProgress();
    notifyListeners();
  }

  /// TOGGLE CONTROLS
  void toggleControls() {
    _showControls = !_showControls;
    notifyListeners();
  }

  /// BOOKMARK CHECK
  bool isBookmarked(String location) {
    final id = _currentBook?.id;
    if (id == null) return false;

    return _bookmarks[id]?.contains(location) ?? false;
  }

  /// TOGGLE BOOKMARK
  Future<void> toggleBookmark(String location) async {
    final id = _currentBook?.id;
    if (id == null) return;

    final set = _bookmarks.putIfAbsent(id, () => <String>{});

    if (set.contains(location)) {
      set.remove(location);
    } else {
      set.add(location);
    }

    await _saveDataStore();
    notifyListeners();
  }

  Future<void> addHighlight(String text) async {
    final id = _currentBook?.id;
    if (id == null) return;

    _highlights.putIfAbsent(id, () => []).add(text);

    await _saveDataStore();
  }

  Future<void> addNote(String note) async {
    final id = _currentBook?.id;
    if (id == null) return;

    _notes.putIfAbsent(id, () => []).add(note);

    await _saveDataStore();
  }

  Future<void> markDownloaded(String bookId) async {
    _downloads.add(bookId);
    await _saveDataStore();
  }

  /// TTS CONTROL
  void setSpeaking(bool value) {
    _isSpeaking = value;
    notifyListeners();
  }

  /// THEME
  Future<void> toggleDarkMode() async {
    _darkMode = !_darkMode;
    if (_darkMode) _sepiaMode = false;

    await _saveSettings();
    notifyListeners();
  }

  Future<void> toggleSepiaMode() async {
    _sepiaMode = !_sepiaMode;
    if (_sepiaMode) _darkMode = false;

    await _saveSettings();
    notifyListeners();
  }

  void changeTheme(ReaderThemeMode mode) {
    switch (mode) {
      case ReaderThemeMode.dark:
        _darkMode = true;
        _sepiaMode = false;
        break;

      case ReaderThemeMode.sepia:
        _sepiaMode = true;
        _darkMode = false;
        break;

      case ReaderThemeMode.light:
        _darkMode = false;
        _sepiaMode = false;
        break;
    }

    _saveSettings();
    notifyListeners();
  }

  /// FONT
  Future<void> increaseFont() async {
    if (_fontSize >= 32) return;

    _fontSize += 2;
    await _saveSettings();
    notifyListeners();
  }

  Future<void> decreaseFont() async {
    if (_fontSize <= 14) return;

    _fontSize -= 2;
    await _saveSettings();
    notifyListeners();
  }

  /// LOAD PROGRESS
  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_progressStoreKey);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    _readingProgress
      ..clear()
      ..addAll(decoded.map((k, v) => MapEntry(k, (v as num).toDouble())));
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _progressStoreKey,
      jsonEncode(_readingProgress),
    );
  }

  /// SETTINGS
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final raw = prefs.getString(_settingsStoreKey);
    if (raw == null || raw.isEmpty) return;

    final decoded = jsonDecode(raw);

    _fontSize = ((decoded['fontSize'] ?? 18) as num).toDouble();
    _darkMode = decoded['darkMode'] ?? false;
    _sepiaMode = decoded['sepiaMode'] ?? false;
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _settingsStoreKey,
      jsonEncode(readerSettings),
    );
  }

  /// DATA STORE
  Future<void> _loadDataStore() async {
    final prefs = await SharedPreferences.getInstance();

    final bookmarksRaw = prefs.getString(_bookmarksStoreKey);
    if (bookmarksRaw != null && bookmarksRaw.isNotEmpty) {
      final decoded = jsonDecode(bookmarksRaw);

      _bookmarks
        ..clear()
        ..addAll(decoded.map(
          (k, v) => MapEntry(
            k,
            (v as List).map((e) => e.toString()).toSet(),
          ),
        ));
    }

    final highlightsRaw = prefs.getString(_highlightsStoreKey);
    if (highlightsRaw != null && highlightsRaw.isNotEmpty) {
      final decoded = jsonDecode(highlightsRaw);

      _highlights
        ..clear()
        ..addAll(decoded.map(
          (k, v) => MapEntry(
            k,
            (v as List).map((e) => e.toString()).toList(),
          ),
        ));
    }

    final notesRaw = prefs.getString(_notesStoreKey);
    if (notesRaw != null && notesRaw.isNotEmpty) {
      final decoded = jsonDecode(notesRaw);

      _notes
        ..clear()
        ..addAll(decoded.map(
          (k, v) => MapEntry(
            k,
            (v as List).map((e) => e.toString()).toList(),
          ),
        ));
    }

    final downloadsRaw = prefs.getString(_downloadsStoreKey);
    if (downloadsRaw != null && downloadsRaw.isNotEmpty) {
      _downloads
        ..clear()
        ..addAll(
          (jsonDecode(downloadsRaw) as List).map((e) => e.toString()),
        );
    }
  }

  Future<void> _saveDataStore() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      _bookmarksStoreKey,
      jsonEncode(_bookmarks.map((k, v) => MapEntry(k, v.toList()))),
    );

    await prefs.setString(_highlightsStoreKey, jsonEncode(_highlights));
    await prefs.setString(_notesStoreKey, jsonEncode(_notes));
    await prefs.setString(
      _downloadsStoreKey,
      jsonEncode(_downloads.toList()),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}