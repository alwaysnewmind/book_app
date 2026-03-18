import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ReaderAnalyticsService {
  static const _storageKey = "reader_analytics";

  int booksCompleted = 0;
  int pagesRead = 0;

  SharedPreferences? _prefs;
  bool _initialized = false;

  /// ===============================
  /// INITIALIZE
  /// ===============================
  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();

    final raw = _prefs!.getString(_storageKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final data = jsonDecode(raw) as Map<String, dynamic>;
        booksCompleted = (data['booksCompleted'] ?? 0) as int;
        pagesRead = (data['pagesRead'] ?? 0) as int;
      } catch (_) {
        booksCompleted = 0;
        pagesRead = 0;
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// ADD PAGES READ
  /// ===============================
  Future<void> addPages(int pages) async {
    if (pages <= 0) return;
    pagesRead += pages;
    await _save();
  }

  /// ===============================
  /// MARK BOOK COMPLETED
  /// ===============================
  Future<void> completeBook() async {
    booksCompleted++;
    await _save();
  }

  /// ===============================
  /// RESET STATS
  /// ===============================
  Future<void> resetStats() async {
    booksCompleted = 0;
    pagesRead = 0;
    await _save();
  }

  /// ===============================
  /// GET CURRENT STATS
  /// ===============================
  Map<String, dynamic> getStats() {
    return {
      'booksCompleted': booksCompleted,
      'pagesRead': pagesRead,
    };
  }

  /// ===============================
  /// SAVE TO STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(
      _storageKey,
      jsonEncode({
        'booksCompleted': booksCompleted,
        'pagesRead': pagesRead,
      }),
    );
  }
}