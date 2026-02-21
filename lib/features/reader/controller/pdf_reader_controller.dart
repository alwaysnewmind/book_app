import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfReaderController extends ChangeNotifier {
  /// ==============================
  /// Core Variables
  /// ==============================

  int _currentPage = 0;
  int _totalPages = 0;
  int _coinsEarned = 0;
  int _lastRewardPage = 0;
  int _readingSeconds = 0;

  Timer? _readingTimer;

  String _bookId = "";

  /// ==============================
  /// Getters
  /// ==============================

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get coinsEarned => _coinsEarned;
  int get readingSeconds => _readingSeconds;

  /// ==============================
  /// Initialize Controller
  /// ==============================

  Future<void> init(String bookId, int totalPages) async {
    _bookId = bookId;
    _totalPages = totalPages;

    await _loadProgress();
    _startReadingTimer();
  }

  /// ==============================
  /// Page Change Logic
  /// ==============================

  void onPageChanged(int pageNumber) {
    _currentPage = pageNumber;

    _rewardByPageProgress(pageNumber);
    _checkBookCompletion();

    _saveProgress();
    notifyListeners();
  }

  /// ==============================
  /// Reward Logic (Page Based)
  /// ==============================

  void _rewardByPageProgress(int page) {
    if (page - _lastRewardPage >= 5) {
      _lastRewardPage = page;
      _addCoins(10);
    }
  }

  /// ==============================
  /// Reward Logic (Time Based)
  /// ==============================

  void _startReadingTimer() {
    _readingTimer?.cancel();

    _readingTimer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _readingSeconds += 60;

      // Every 5 minutes reward
      if (_readingSeconds % 300 == 0) {
        _addCoins(5);
      }

      notifyListeners();
    });
  }

  void stopReadingTimer() {
    _readingTimer?.cancel();
  }

  /// ==============================
  /// Completion Logic
  /// ==============================

  void _checkBookCompletion() {
    if (_currentPage == _totalPages) {
      _addCoins(50); // Completion reward
    }
  }

  /// ==============================
  /// Coin Management
  /// ==============================

  void _addCoins(int amount) {
    _coinsEarned += amount;
  }

  /// ==============================
  /// Save Progress
  /// ==============================

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("$_bookId-page", _currentPage);
    await prefs.setInt("$_bookId-coins", _coinsEarned);
    await prefs.setInt("$_bookId-seconds", _readingSeconds);
  }

  /// ==============================
  /// Load Progress
  /// ==============================

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    _currentPage = prefs.getInt("$_bookId-page") ?? 0;
    _coinsEarned = prefs.getInt("$_bookId-coins") ?? 0;
    _readingSeconds = prefs.getInt("$_bookId-seconds") ?? 0;
  }

  /// ==============================
  /// Reset Book Progress
  /// ==============================

  Future<void> resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("$_bookId-page");
    await prefs.remove("$_bookId-coins");
    await prefs.remove("$_bookId-seconds");

    _currentPage = 0;
    _coinsEarned = 0;
    _readingSeconds = 0;

    notifyListeners();
  }

  /// ==============================
  /// Dispose
  /// ==============================

  @override
  void dispose() {
    _readingTimer?.cancel();
    super.dispose();
  }
}