import 'dart:async';
import 'package:flutter/material.dart';

enum ReaderThemeMode { light, dark, sepia }

class ReaderProvider extends ChangeNotifier {
  /// ===============================
  /// Controllers
  /// ===============================

  PageController? _pageController;
  PageController get pageController => _pageController!;

  /// ===============================
  /// Book State
  /// ===============================

  String? _bookId;
  int _currentChapter = 0;
  int _totalChapters = 0;

  /// ===============================
  /// UI State
  /// ===============================

  double _fontSize = 18;
  ReaderThemeMode _themeMode = ReaderThemeMode.light;
  bool _showControls = true;

  /// Bookmark per chapter (per book)
  final Map<String, Set<int>> _bookmarks = {};

  /// TTS State
  bool _isSpeaking = false;

  Timer? _hideTimer;

  /// ===============================
  /// Getters
  /// ===============================

  int get currentChapter => _currentChapter;
  double get fontSize => _fontSize;
  ReaderThemeMode get themeMode => _themeMode;
  bool get showControls => _showControls;
  bool get isSpeaking => _isSpeaking;

  bool isBookmarked(int chapter) {
    if (_bookId == null) return false;
    return _bookmarks[_bookId]?.contains(chapter) ?? false;
  }

  double get progress {
    if (_totalChapters == 0) return 0;
    return (_currentChapter + 1) / _totalChapters;
  }

  /// ===============================
  /// Initialize Book
  /// ===============================

  void loadBook({
    required String bookId,
    required int totalChapters,
    int lastReadChapter = 0,
  }) {
    _bookId = bookId;
    _totalChapters = totalChapters;
    _currentChapter = lastReadChapter;

    _pageController?.dispose();
    _pageController = PageController(
      initialPage: lastReadChapter,
    );

    notifyListeners();
  }

  /// ===============================
  /// Chapter Navigation
  /// ===============================

  void setChapter(int index) {
    _currentChapter = index;
    notifyListeners();
  }

  void nextChapter() {
    if (_pageController == null) return;

    if (_currentChapter < _totalChapters - 1) {
      _pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousChapter() {
    if (_pageController == null) return;

    if (_currentChapter > 0) {
      _pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// ===============================
  /// Font Controls
  /// ===============================

  void increaseFont() {
    if (_fontSize < 30) {
      _fontSize += 2;
      notifyListeners();
    }
  }

  void decreaseFont() {
    if (_fontSize > 14) {
      _fontSize -= 2;
      notifyListeners();
    }
  }

  /// ===============================
  /// Theme Controls
  /// ===============================

  void changeTheme(ReaderThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  /// ===============================
  /// Bookmark
  /// ===============================

  void toggleBookmark() {
    if (_bookId == null) return;

    _bookmarks.putIfAbsent(_bookId!, () => {});

    if (_bookmarks[_bookId!]!.contains(_currentChapter)) {
      _bookmarks[_bookId!]!.remove(_currentChapter);
    } else {
      _bookmarks[_bookId!]!.add(_currentChapter);
    }

    notifyListeners();
  }

  /// ===============================
  /// Controls Visibility (Immersive Mode)
  /// ===============================

  void toggleControls() {
    _showControls = !_showControls;
    notifyListeners();

    if (_showControls) {
      _startAutoHideTimer();
    }
  }

  void _startAutoHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      _showControls = false;
      notifyListeners();
    });
  }

  /// ===============================
  /// TTS
  /// ===============================

  void setSpeaking(bool value) {
    _isSpeaking = value;
    notifyListeners();
  }

  /// ===============================
  /// Clean Up
  /// ===============================

  @override
  void dispose() {
    _pageController?.dispose();
    _hideTimer?.cancel();
    super.dispose();
  }
}
