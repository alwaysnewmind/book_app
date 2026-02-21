import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderController extends ChangeNotifier {
  /// ==============================
  /// GLOBAL USER DATA
  /// ==============================

  int _coins = 0;
  int _xp = 0;
  int _level = 1;
  int _streak = 0;
  int _totalReadingSeconds = 0;
  int _completedBooks = 0;

  Timer? _readingTimer;

  /// ==============================
  /// BOOK TRACKING
  /// ==============================

  final Map<String, int> _bookProgress = {}; // bookId : lastPage
  final Map<String, bool> _bookCompleted = {};

  /// ==============================
  /// GETTERS
  /// ==============================

  int get coins => _coins;
  int get xp => _xp;
  int get level => _level;
  int get streak => _streak;
  int get totalReadingSeconds => _totalReadingSeconds;
  int get completedBooks => _completedBooks;

  Map<String, int> get bookProgress => _bookProgress;

  /// ==============================
  /// INIT
  /// ==============================

  Future<void> init() async {
    await _loadUserData();
  }

  /// ==============================
  /// READING TIMER
  /// ==============================

  void startReadingSession() {
    _readingTimer?.cancel();

    _readingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _totalReadingSeconds += 60;

      // Every 5 minutes reward
      if (_totalReadingSeconds % 300 == 0) {
        addCoins(5);
        addXP(10);
      }

      notifyListeners();
      _saveUserData();
    });
  }

  void stopReadingSession() {
    _readingTimer?.cancel();
  }

  /// ==============================
  /// PAGE UPDATE
  /// ==============================

  void updateBookProgress(String bookId, int page, int totalPages) {
    _bookProgress[bookId] = page;

    // Every 5 pages reward
    if (page % 5 == 0) {
      addCoins(10);
      addXP(20);
    }

    // Completion
    if (page == totalPages && !_bookCompleted.containsKey(bookId)) {
      _bookCompleted[bookId] = true;
      _completedBooks++;
      addCoins(50);
      addXP(100);
    }

    notifyListeners();
    _saveUserData();
  }

  /// ==============================
  /// COIN SYSTEM
  /// ==============================

  void addCoins(int amount) {
    _coins += amount;
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_coins >= amount) {
      _coins -= amount;
      notifyListeners();
      _saveUserData();
      return true;
    }
    return false;
  }

  /// ==============================
  /// XP + LEVEL SYSTEM
  /// ==============================

  void addXP(int amount) {
    _xp += amount;

    // Level up rule
    if (_xp >= _level * 200) {
      _xp = 0;
      _level++;
    }

    notifyListeners();
  }

  /// ==============================
  /// STREAK SYSTEM
  /// ==============================

  Future<void> updateDailyStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString("last_read_date");

    if (lastDate == null) {
      _streak = 1;
    } else {
      final last = DateTime.parse(lastDate);
      final diff = DateTime.now().difference(last).inDays;

      if (diff == 1) {
        _streak++;
        addCoins(20);
      } else if (diff > 1) {
        _streak = 1;
      }
    }

    await prefs.setString("last_read_date", today);
    notifyListeners();
    _saveUserData();
  }

  /// ==============================
  /// UNLOCK BOOK SYSTEM
  /// ==============================

  bool unlockBook(String bookId, int price) {
    if (spendCoins(price)) {
      _bookProgress[bookId] = 0;
      return true;
    }
    return false;
  }

  /// ==============================
  /// SAVE DATA
  /// ==============================

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("coins", _coins);
    await prefs.setInt("xp", _xp);
    await prefs.setInt("level", _level);
    await prefs.setInt("streak", _streak);
    await prefs.setInt("totalReadingSeconds", _totalReadingSeconds);
    await prefs.setInt("completedBooks", _completedBooks);

    for (var entry in _bookProgress.entries) {
      await prefs.setInt("progress_${entry.key}", entry.value);
    }
  }

  /// ==============================
  /// LOAD DATA
  /// ==============================

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    _coins = prefs.getInt("coins") ?? 0;
    _xp = prefs.getInt("xp") ?? 0;
    _level = prefs.getInt("level") ?? 1;
    _streak = prefs.getInt("streak") ?? 0;
    _totalReadingSeconds = prefs.getInt("totalReadingSeconds") ?? 0;
    _completedBooks = prefs.getInt("completedBooks") ?? 0;

    notifyListeners();
  }

  /// ==============================
  /// RESET USER
  /// ==============================

  Future<void> resetAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    _coins = 0;
    _xp = 0;
    _level = 1;
    _streak = 0;
    _totalReadingSeconds = 0;
    _completedBooks = 0;
    _bookProgress.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    super.dispose();
  }
}