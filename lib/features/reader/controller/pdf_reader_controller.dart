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
  final Map<String, int> _pdfPageProgress = <String, int>{};

  String get bookId => _bookId;
  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  Duration get sessionDuration => _sessionDuration;

  Future<void> init(String bookId, int totalPages) async {
    await openPdf(bookId: bookId, totalPages: totalPages);
    _startSessionTimer();
  }

  Future<void> openPdf({
    required String bookId,
    required int totalPages,
  }) async {
    _bookId = bookId;
    _totalPages = totalPages;
    await _loadPdfProgress();
    notifyListeners();
  }

  Future<void> trackPdfProgress({required int page}) async {
    if (_bookId.isEmpty || _totalPages <= 0) return;
    _currentPage = page.clamp(0, _totalPages);
    _pdfPageProgress[_bookId] = _currentPage;
    await savePdfProgress();
    notifyListeners();
  }

  Future<void> savePdfProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pdfProgressKey, jsonEncode(_pdfPageProgress));
  }

  // Legacy compatibility methods.
  void onPageChanged(int pageNumber) {
    trackPdfProgress(page: pageNumber);
  }

  void stopReadingTimer() {
    _sessionTimer?.cancel();
  }

  Future<void> resetProgress() async {
    if (_bookId.isEmpty) return;
    _pdfPageProgress.remove(_bookId);
    _currentPage = 0;
    await savePdfProgress();
    notifyListeners();
  }

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _sessionDuration += const Duration(seconds: 1);
    });
  }

  Future<void> _loadPdfProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_pdfProgressKey);
    if (raw == null || raw.isEmpty) {
      _currentPage = 0;
      return;
    }

    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    _pdfPageProgress
      ..clear()
      ..addAll(decoded.map((key, value) => MapEntry(key, (value as num).toInt())));

    _currentPage = _pdfPageProgress[_bookId] ?? 0;
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    super.dispose();
  }
}
