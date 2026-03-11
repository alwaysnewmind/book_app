import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfReaderController extends ChangeNotifier {
  static const String _pdfProgressKey = 'reader_pdf_progress';

  String _bookId = '';
  int _currentPage = 0;
  int _totalPages = 0;

  Duration _sessionDuration = Duration.zero;

  Timer? _sessionTimer;

  late SharedPreferences _prefs;

  final Map<String, int> _pdfPageProgress = {};

  bool _initialized = false;

  /// ---------------------------
  /// Getters
  /// ---------------------------

  String get bookId => _bookId;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  Duration get sessionDuration => _sessionDuration;

  double get progressPercentage {
    if (_totalPages == 0) return 0;
    return _currentPage / _totalPages;
  }

  bool get isInitialized => _initialized;

  /// ---------------------------
  /// Initialization
  /// ---------------------------

  Future<void> init({
    required String bookId,
    required int totalPages,
  }) async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();

    _bookId = bookId;
    _totalPages = totalPages;

    await _loadPdfProgress();

    _startSessionTimer();

    _initialized = true;

    notifyListeners();
  }

  /// ---------------------------
  /// Open PDF
  /// ---------------------------

  Future<void> openPdf({
    required String bookId,
    required int totalPages,
  }) async {
    if (!_initialized) {
      await init(bookId: bookId, totalPages: totalPages);
      return;
    }

    _bookId = bookId;
    _totalPages = totalPages;

    await _loadPdfProgress();

    notifyListeners();
  }

  /// ---------------------------
  /// Track Reading Progress
  /// ---------------------------

  Future<void> trackPdfProgress(int page) async {
    if (_bookId.isEmpty) return;

    final newPage = page.clamp(0, _totalPages);

    if (newPage == _currentPage) return;

    _currentPage = newPage;

    _pdfPageProgress[_bookId] = _currentPage;

    await _savePdfProgress();

    notifyListeners();
  }

  /// Legacy compatibility
  void onPageChanged(int pageNumber) {
    trackPdfProgress(pageNumber);
  }

  /// ---------------------------
  /// Save Progress
  /// ---------------------------

  Future<void> _savePdfProgress() async {
    try {
      final encoded = jsonEncode(_pdfPageProgress);

      await _prefs.setString(_pdfProgressKey, encoded);
    } catch (e) {
      debugPrint("Save progress error: $e");
    }
  }

  /// ---------------------------
  /// Load Progress
  /// ---------------------------

  Future<void> _loadPdfProgress() async {
    try {
      final raw = _prefs.getString(_pdfProgressKey);

      if (raw == null || raw.isEmpty) {
        _currentPage = 0;
        return;
      }

      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      _pdfPageProgress
        ..clear()
        ..addAll(
          decoded.map(
            (key, value) => MapEntry(
              key,
              (value as num).toInt(),
            ),
          ),
        );

      _currentPage = _pdfPageProgress[_bookId] ?? 0;
    } catch (e) {
      debugPrint("Load progress error: $e");
      _currentPage = 0;
    }
  }

  /// ---------------------------
  /// Reset Book Progress
  /// ---------------------------

  Future<void> resetProgress() async {
    if (_bookId.isEmpty) return;

    _pdfPageProgress.remove(_bookId);

    _currentPage = 0;

    await _savePdfProgress();

    notifyListeners();
  }

  /// ---------------------------
  /// Reading Session Timer
  /// ---------------------------

  void _startSessionTimer() {
    _sessionTimer?.cancel();

    _sessionTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        _sessionDuration += const Duration(seconds: 1);
      },
    );
  }

  void stopReadingTimer() {
    _sessionTimer?.cancel();
  }

  /// ---------------------------
  /// Dispose
  /// ---------------------------

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }
}