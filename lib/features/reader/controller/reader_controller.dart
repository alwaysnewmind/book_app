import 'dart:async';
import 'dart:convert';

import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:book_app/features/reader/models/reader_stats_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderController extends ChangeNotifier {
  static const String _statsKey = 'reader_engine_stats';
  static const String _progressKey = 'reader_engine_progress';
  static const String _bookContentPrefix = 'reader_engine_content_';

  ReaderBookModel? _activeBook;
  String _currentBookContent = '';
  ReaderStatsModel _stats = ReaderStatsModel.empty();

  final Map<String, double> _bookProgress = <String, double>{};
  final Map<String, DateTime> _lastReadAt = <String, DateTime>{};

  Timer? _readingTimer;

  ReaderBookModel? get activeBook => _activeBook;
  String get currentBookContent => _currentBookContent;
  ReaderStatsModel get statsModel => _stats;
  Map<String, double> get bookProgress => Map<String, double>.unmodifiable(_bookProgress);

  // Legacy getters used by existing dashboard widgets.
  int get coins => _stats.pagesRead;
  int get xp => _stats.totalReadingTime ~/ 60;
  int get level => ((xp ~/ 200) + 1).clamp(1, 9999);
  int get streak => _stats.readingStreak;
  int get totalReadingSeconds => _stats.totalReadingTime;
  int get completedBooks => _stats.booksCompleted;

  Future<void> init() async {
    await _loadPersistedState();
  }

  Future<void> openBook(ReaderBookModel book) async {
    _activeBook = book;
    _currentBookContent = await loadBookContent(book.id);
    _lastReadAt[book.id] = DateTime.now();
    await _persistProgress();
    notifyListeners();
  }

  Future<String> loadBookContent(String bookId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedContent = prefs.getString('$_bookContentPrefix$bookId');
    if (cachedContent != null && cachedContent.isNotEmpty) {
      return cachedContent;
    }

    // Placeholder content pipeline for text reader; replace with API/repository later.
    final generated = List<String>.generate(
      20,
      (index) => 'Chapter ${index + 1}\n\nThis is generated content for $bookId. '
          'It allows production-like flow for progress, resume, analytics and settings.',
    ).join('\n\n');

    await prefs.setString('$_bookContentPrefix$bookId', generated);
    return generated;
  }

  Future<void> updateReadingProgress({
    required String bookId,
    required double progress,
    int pagesRead = 0,
  }) async {
    final normalizedProgress = progress.clamp(0, 100).toDouble();
    _bookProgress[bookId] = normalizedProgress;
    _lastReadAt[bookId] = DateTime.now();

    if (pagesRead > 0) {
      _stats = _stats.copyWith(pagesRead: _stats.pagesRead + pagesRead);
    }

    if (normalizedProgress >= 100) {
      _stats = _stats.copyWith(booksCompleted: _calculateCompletedBooks());
    }

    await _persistProgress();
    notifyListeners();
  }

  Future<void> saveReadingSession({
    required String bookId,
    required Duration duration,
    int pagesRead = 0,
  }) async {
    _stats = _stats.copyWith(
      totalReadingTime: _stats.totalReadingTime + duration.inSeconds,
      pagesRead: _stats.pagesRead + pagesRead,
      readingStreak: _calculateStreak(),
      booksCompleted: _calculateCompletedBooks(),
    );

    _lastReadAt[bookId] = DateTime.now();
    await _persistStats();
    notifyListeners();
  }

  ReaderStatsModel calculateReadingStats() {
    _stats = _stats.copyWith(
      booksCompleted: _calculateCompletedBooks(),
      readingStreak: _calculateStreak(),
    );
    return _stats;
  }

  // Legacy compatibility methods.
  void startReadingSession() {
    _readingTimer?.cancel();
    _readingTimer = Timer.periodic(const Duration(minutes: 1), (_) {
      final activeBookId = _activeBook?.id;
      if (activeBookId == null) return;
      saveReadingSession(bookId: activeBookId, duration: const Duration(minutes: 1));
    });
  }

  void stopReadingSession() {
    _readingTimer?.cancel();
  }

  void updateBookProgress(String bookId, int page, int totalPages) {
    if (totalPages <= 0) return;
    final progress = (page / totalPages) * 100;
    updateReadingProgress(bookId: bookId, progress: progress, pagesRead: 1);
  }

  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_statsKey);
    await prefs.remove(_progressKey);

    _stats = ReaderStatsModel.empty();
    _bookProgress.clear();
    _lastReadAt.clear();
    _activeBook = null;
    _currentBookContent = '';
    notifyListeners();
  }

  int _calculateCompletedBooks() {
    return _bookProgress.values.where((progress) => progress >= 100).length;
  }

  int _calculateStreak() {
    if (_lastReadAt.isEmpty) return 0;

    final dates = _lastReadAt.values
        .map((date) => DateTime(date.year, date.month, date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    var streakValue = 0;
    DateTime expectedDay = DateTime.now();

    for (final date in dates) {
      final normalizedExpected = DateTime(expectedDay.year, expectedDay.month, expectedDay.day);
      if (date == normalizedExpected) {
        streakValue++;
        expectedDay = expectedDay.subtract(const Duration(days: 1));
      } else if (date.isBefore(normalizedExpected)) {
        break;
      }
    }

    return streakValue;
  }

  Future<void> _loadPersistedState() async {
    final prefs = await SharedPreferences.getInstance();

    final statsRaw = prefs.getString(_statsKey);
    if (statsRaw != null && statsRaw.isNotEmpty) {
      _stats = ReaderStatsModel.fromJson(jsonDecode(statsRaw) as Map<String, dynamic>);
    }

    final progressRaw = prefs.getString(_progressKey);
    if (progressRaw != null && progressRaw.isNotEmpty) {
      final decoded = jsonDecode(progressRaw) as Map<String, dynamic>;
      _bookProgress
        ..clear()
        ..addAll(decoded.map((key, value) => MapEntry(key, (value as num).toDouble())));
    }

    notifyListeners();
  }

  Future<void> _persistStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_statsKey, jsonEncode(_stats.toJson()));
  }

  Future<void> _persistProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_progressKey, jsonEncode(_bookProgress));
    await _persistStats();
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    super.dispose();
  }
}
