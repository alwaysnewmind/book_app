import 'dart:convert';
import 'package:book_app/features/reader/models/highlight_model.dart' show HighlightModel;
import 'package:shared_preferences/shared_preferences.dart';

class HighlightEngine {

  static const String _storageKey = "reader_highlights";

  /// bookId -> highlights
  final Map<String, List<HighlightModel>> _highlights = {};

  /// ===============================
  /// ADD HIGHLIGHT
  /// ===============================

  Future<void> addHighlight({
    required String bookId,
    required String text,
    required int page,
    int startOffset = 0,
    int endOffset = 0,
    String color = "yellow",
  }) async {

    final highlight = HighlightModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      text: text,
      page: page,
      startOffset: startOffset,
      endOffset: endOffset,
      color: color,
      createdAt: DateTime.now(),
    );

    _highlights.putIfAbsent(bookId, () => []);
    _highlights[bookId]!.add(highlight);

    await _save();
  }

  /// ===============================
  /// REMOVE HIGHLIGHT
  /// ===============================

  Future<void> removeHighlight({
    required String bookId,
    required String highlightId,
  }) async {

    final list = _highlights[bookId];
    if (list == null) return;

    list.removeWhere((h) => h.id == highlightId);

    await _save();
  }

  /// ===============================
  /// GET BOOK HIGHLIGHTS
  /// ===============================

  List<HighlightModel> getHighlights(String bookId) {
    return _highlights[bookId] ?? [];
  }

  /// ===============================
  /// LOAD STORAGE
  /// ===============================

  Future<void> load() async {

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);

    if (raw == null) return;

    final decoded = jsonDecode(raw) as Map<String, dynamic>;

    decoded.forEach((bookId, list) {

      _highlights[bookId] = (list as List)
          .map((e) => HighlightModel.fromJson(e))
          .toList();
    });
  }

  /// ===============================
  /// SAVE STORAGE
  /// ===============================

  Future<void> _save() async {

    final prefs = await SharedPreferences.getInstance();

    final data = _highlights.map(
      (key, value) => MapEntry(
        key,
        value.map((e) => e.toJson()).toList(),
      ),
    );

    await prefs.setString(_storageKey, jsonEncode(data));
  }

}