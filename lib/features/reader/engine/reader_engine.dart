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
  bool _initialized = false;

  String? _currentBookId;
  final Map<String, double> _bookProgress = {};
  final Set<String> _completedBooks = {};

  DateTime? _sessionStart;
  Duration _lastSessionDuration = Duration.zero;

  /// ===============================
  /// GETTERS
  /// ===============================
  String? get currentBook => _currentBookId;

  double get currentProgress {
    if (_currentBookId == null) return 0.0;
    return _bookProgress[_currentBookId!] ?? 0.0;
  }

  Duration get lastSessionDuration => _lastSessionDuration;

  Map<String, double> get allProgress => Map.unmodifiable(_bookProgress);

  Set<String> get completedBooks => Set.unmodifiable(_completedBooks);

  bool get isReading => _sessionStart != null;

  /// ===============================
  /// INITIALIZE ENGINE
  /// ===============================
  Future<void> init() async {
    if (_initialized) return;

    _prefs ??= await SharedPreferences.getInstance();
    await _loadProgress();

    _initialized = true;
  }

  /// ===============================
  /// LOAD DATA
  /// ===============================
  Future<void> _loadProgress() async {
    if (_prefs == null) return;

    final rawProgress = _prefs!.getString(_progressKey);
    if (rawProgress != null && rawProgress.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawProgress);
        if (decoded is Map<String, dynamic>) {
          _bookProgress.clear();
          decoded.forEach((key, value) {
            final v = value;
            if (v is num) {
              _bookProgress[key] = v.toDouble().clamp(0.0, 100.0);
            }
          });
        }
      } catch (_) {
        _bookProgress.clear();
      }
    }

    final completed = _prefs!.getStringList(_completedKey);
    if (completed != null) {
      _completedBooks
        ..clear()
        ..addAll(completed);
    }
  }

  /// ===============================
  /// START READING A BOOK
  /// ===============================
  void startBook(String bookId) {
    if (bookId.isEmpty) return;

    _currentBookId = bookId;
    _sessionStart = DateTime.now();
    _bookProgress.putIfAbsent(bookId, () => 0.0);
  }

  /// ===============================
  /// UPDATE PROGRESS
  /// ===============================
  Future<void> updateProgress(double progress) async {
    if (_currentBookId == null) return;

    final clamped = progress.clamp(0.0, 100.0);

    final previous = _bookProgress[_currentBookId!] ?? 0.0;
    if (previous == clamped) return;

    _bookProgress[_currentBookId!] = clamped;

    if (clamped >= 100) {
      _completedBooks.add(_currentBookId!);
    }

    await _saveProgress();
  
  /// mark completed
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

    final duration = DateTime.now().difference(_sessionStart!);
    _lastSessionDuration = duration;
    _sessionStart = null;
  }

  /// ===============================
  /// RESET BOOK
  /// ===============================
  Future<void> resetBook(String bookId) async {
    _bookProgress.remove(bookId);
    _completedBooks.remove(bookId);

    if (_currentBookId == bookId) {
      _currentBookId = null;
      _sessionStart = null;
    }

    await _saveProgress();
  }

  /// ===============================
  /// RESET ALL DATA
  /// ===============================
  Future<void> resetAll() async {
    _bookProgress.clear();
    _completedBooks.clear();
    _currentBookId = null;
    _sessionStart = null;
    _lastSessionDuration = Duration.zero;

    await _saveProgress();
  }

  /// ===============================
  /// SAVE DATA
  /// ===============================
  Future<void> _saveProgress() async {
    _prefs ??= await SharedPreferences.getInstance();

    try {
      await _prefs!.setString(
        _progressKey,
        jsonEncode(_bookProgress),
      );

      await _prefs!.setStringList(
        _completedKey,
        _completedBooks.toList(),
      );
    } catch (_) {
      // Ignore save errors
    }
  }
}