import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reader_book_model.dart';

class ReaderController extends ChangeNotifier {

  /// Storage Keys
  static const _statsKey = "reader_stats";
  static const _bookProgressKey = "reader_book_progress";

  late SharedPreferences _prefs;

  /// Current Book
  ReaderBookModel? _currentBook;

  /// Reading Stats
  int _pagesRead = 0;
  int _booksCompleted = 0;
  int _readingStreak = 1;
  int _readingMinutes = 0;

  /// Reading Progress
  double _progress = 0;

  /// Session tracking
  DateTime? _sessionStart;

  /// Book Progress Map
  final Map<String, double> _bookProgress = {};

  bool _initialized = false;

  /// Getters
  ReaderBookModel? get currentBook => _currentBook;
  int get pagesRead => _pagesRead;
  int get booksCompleted => _booksCompleted;
  int get readingStreak => _readingStreak;
  double get progress => _progress;
  int get readingMinutes => _readingMinutes;

  String get currentBookContent => '';

  get completedBooks => null;

  get streak => null;

  get coins => null;

  get xp => null;

  /// -------------------------
  /// Init Reader Engine
  /// -------------------------
  Future<void> init() async {

    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();

    await _loadStats();
    await _loadBookProgress();

    _initialized = true;

    notifyListeners();
  }

  /// -------------------------
  /// Open Book
  /// -------------------------
  Future<void> openBook(ReaderBookModel book) async {

    if (!_initialized) {
      await init();
    }

    _currentBook = book;

    _progress = _bookProgress[book.id] ?? book.progress;

    _startSession();

    notifyListeners();
  }

  /// -------------------------
  /// Start Reading Session
  /// -------------------------
  void _startSession() {
    _sessionStart = DateTime.now();
  }

  /// -------------------------
  /// End Reading Session
  /// -------------------------
  Future<void> endSession() async {

    if (_sessionStart == null) return;

    final duration =
        DateTime.now().difference(_sessionStart!).inMinutes;

    _readingMinutes += duration;

    _sessionStart = null;

    await _saveStats();

    notifyListeners();
  }

  /// -------------------------
  /// Update Reading Progress
  /// -------------------------
  Future<void> updateProgress(double progress) async {

    if (_currentBook == null) return;

    final double newProgress =
        progress.clamp(0, 100).toDouble();

    if (newProgress == _progress) return;

    _progress = newProgress;

    _bookProgress[_currentBook!.id] = _progress;

    /// Example page calculation
    const int estimatedPages = 300;

    final pages =
        (_progress / 100 * estimatedPages).toInt();

    if (pages > _pagesRead) {
      _pagesRead = pages;
    }

    if (_progress >= 100) {
      _completeBook();
    }

    await _saveBookProgress();
    await _saveStats();

    notifyListeners();
  }

  /// -------------------------
  /// Complete Book
  /// -------------------------
  void _completeBook() {

    if (_progress < 100) return;

    _booksCompleted += 1;

    _updateStreak();
  }

  /// -------------------------
  /// Reading Streak Logic
  /// -------------------------
  void _updateStreak() {
    _readingStreak += 1;
  }

  /// -------------------------
  /// Reset Stats
  /// -------------------------
  Future<void> resetStats() async {

    _pagesRead = 0;
    _booksCompleted = 0;
    _readingMinutes = 0;
    _readingStreak = 1;
    _progress = 0;

    _bookProgress.clear();

    await _prefs.remove(_statsKey);
    await _prefs.remove(_bookProgressKey);

    notifyListeners();
  }

  /// -------------------------
  /// Save Stats
  /// -------------------------
  Future<void> _saveStats() async {

    final data = {
      "pagesRead": _pagesRead,
      "booksCompleted": _booksCompleted,
      "readingStreak": _readingStreak,
      "readingMinutes": _readingMinutes,
    };

    await _prefs.setString(_statsKey, jsonEncode(data));
  }

  /// -------------------------
  /// Load Stats
  /// -------------------------
  Future<void> _loadStats() async {

    final raw = _prefs.getString(_statsKey);

    if (raw == null) return;

    try {

      final data = jsonDecode(raw);

      _pagesRead = data["pagesRead"] ?? 0;
      _booksCompleted = data["booksCompleted"] ?? 0;
      _readingStreak = data["readingStreak"] ?? 1;
      _readingMinutes = data["readingMinutes"] ?? 0;

    } catch (_) {}
  }

  /// -------------------------
  /// Save Book Progress
  /// -------------------------
  Future<void> _saveBookProgress() async {

    await _prefs.setString(
      _bookProgressKey,
      jsonEncode(_bookProgress),
    );
  }

  /// -------------------------
  /// Load Book Progress
  /// -------------------------
  Future<void> _loadBookProgress() async {

    final raw = _prefs.getString(_bookProgressKey);

    if (raw == null) return;

    try {

      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      _bookProgress.clear();

      decoded.forEach((key, value) {
        _bookProgress[key] = (value as num).toDouble();
      });

    } catch (_) {}
  }

  /// -------------------------
  /// Dispose
  /// -------------------------
  @override
  void dispose() {
    endSession();
    super.dispose();
  }

  void startReadingSession() {}

  void stopReadingSession() {}

  void updateBookProgress(String id, int nextPage, int demoTotalPages) {}

  void updateReadingProgress({required String bookId, required double progress, required int pagesRead}) {}
}