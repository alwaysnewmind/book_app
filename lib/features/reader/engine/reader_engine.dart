import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderEngine {

  /// ===============================
  /// SINGLETON
  /// ===============================

  static final ReaderEngine _instance = ReaderEngine._internal();

  factory ReaderEngine() => _instance;

  ReaderEngine._internal();

  /// ===============================
  /// STORAGE KEYS
  /// ===============================

  static const String _progressKey = "reader_book_progress";
  static const String _completedKey = "reader_completed_books";

  /// ===============================
  /// STATE
  /// ===============================

  SharedPreferences? _prefs;

  String? _currentBookId;

  final Map<String, double> _bookProgress = {};

  final Set<String> _completedBooks = {};

  DateTime? _sessionStart;

  /// ===============================
  /// GETTERS
  /// ===============================

  String? get currentBook => _currentBookId;

  double get currentProgress {
    if (_currentBookId == null) return 0;
    return _bookProgress[_currentBookId!] ?? 0;
  }

  Map<String, double> get allProgress => Map.unmodifiable(_bookProgress);

  Set<String> get completedBooks => Set.unmodifiable(_completedBooks);

  /// ===============================
  /// INIT ENGINE
  /// ===============================

  Future<void> init() async {

    _prefs ??= await SharedPreferences.getInstance();

    /// load progress
    final rawProgress = _prefs!.getString(_progressKey);

    if (rawProgress != null) {
      try {

        final decoded =
            jsonDecode(rawProgress) as Map<String, dynamic>;

        decoded.forEach((key, value) {
          _bookProgress[key] = (value as num).toDouble();
        });

      } catch (_) {}
    }

    /// load completed books
    final completed = _prefs!.getStringList(_completedKey);

    if (completed != null) {
      _completedBooks.addAll(completed);
    }
  }

  /// ===============================
  /// START BOOK
  /// ===============================

  void startBook(String bookId) {

    _currentBookId = bookId;

    _sessionStart = DateTime.now();

    _bookProgress.putIfAbsent(bookId, () => 0);
  }

  /// ===============================
  /// UPDATE PROGRESS
  /// ===============================

  Future<void> updateProgress(double progress) async {

    if (_currentBookId == null) return;

    final double clamped =
        progress.clamp(0.0, 100.0).toDouble();

    _bookProgress[_currentBookId!] = clamped;

    /// complete book
    if (clamped >= 100) {
      _completedBooks.add(_currentBookId!);
    }

    await _saveProgress();
  }

  /// ===============================
  /// END SESSION
  /// ===============================

  void endSession() {

    if (_sessionStart == null) return;

    DateTime.now().difference(_sessionStart!);

    /// future analytics
    // print("Session duration: $duration");

    _sessionStart = null;
  }

  /// ===============================
  /// RESET BOOK
  /// ===============================

  Future<void> resetBook(String bookId) async {

    _bookProgress.remove(bookId);

    _completedBooks.remove(bookId);

    await _saveProgress();
  }

  /// ===============================
  /// SAVE DATA
  /// ===============================

  Future<void> _saveProgress() async {

    _prefs ??= await SharedPreferences.getInstance();

    await _prefs!.setString(
      _progressKey,
      jsonEncode(_bookProgress),
    );

    await _prefs!.setStringList(
      _completedKey,
      _completedBooks.toList(),
    );
  }
}