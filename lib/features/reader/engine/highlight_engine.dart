import 'dart:convert';
import 'package:book_app/features/reader/models/highlight_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HighlightEngine {

  static const String _storageKey = "reader_highlights";

  SharedPreferences? _prefs;

  bool _initialized = false;

  /// bookId -> highlights
  final Map<String, List<HighlightModel>> _highlights = {};

  /// ===============================
  /// INIT
  /// ===============================

  Future<void> init() async {

    if (_initialized) return;

    _prefs ??= await SharedPreferences.getInstance();

    await _load();

    _initialized = true;
  }

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

    if (bookId.isEmpty) return;
    if (text.trim().isEmpty) return;
    if (page < 0) return;

    if (startOffset < 0) startOffset = 0;
    if (endOffset < startOffset) endOffset = startOffset;

    _highlights.putIfAbsent(bookId, () => []);

    final list = _highlights[bookId]!;

    /// prevent overlap
    final hasOverlap = list.any((h) =>
        h.page == page &&
        !(endOffset <= h.startOffset || startOffset >= h.endOffset));

    if (hasOverlap) return;

    final highlight = HighlightModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: bookId,
      text: text,
      page: page,
      startOffset: startOffset,
      endOffset: endOffset,
      color: color,
      createdAt: DateTime.now(),
    );

    list.add(highlight);

    /// sort highlights
    list.sort((a, b) {
      if (a.page != b.page) {
        return a.page.compareTo(b.page);
      }
      return a.startOffset.compareTo(b.startOffset);
    });

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

    if (list == null || list.isEmpty) return;

    final before = list.length;

    list.removeWhere((h) => h.id == highlightId);

    if (before != list.length) {
      await _save();
    }
  }

  /// ===============================
  /// GET BOOK HIGHLIGHTS
  /// ===============================

  List<HighlightModel> getHighlights(String bookId) {

    final list = _highlights[bookId];

    if (list == null || list.isEmpty) {
      return const [];
    }

    return List.unmodifiable(list);
  }

  /// ===============================
  /// GET PAGE HIGHLIGHTS
  /// ===============================

  List<HighlightModel> getPageHighlights(
    String bookId,
    int page,
  ) {

    final list = _highlights[bookId];

    if (list == null || list.isEmpty) {
      return const [];
    }

    return List.unmodifiable(
      list.where((h) => h.page == page).toList(),
    );
  }

  /// ===============================
  /// HIGHLIGHT COUNT
  /// ===============================

  int getHighlightCount(String bookId) {

    return _highlights[bookId]?.length ?? 0;
  }

  /// ===============================
  /// CLEAR BOOK HIGHLIGHTS
  /// ===============================

  Future<void> clearBookHighlights(String bookId) async {

    if (!_highlights.containsKey(bookId)) return;

    _highlights.remove(bookId);

    await _save();
  }

  /// ===============================
  /// LOAD STORAGE
  /// ===============================

  Future<void> _load() async {

    if (_prefs == null) return;

    final raw = _prefs!.getString(_storageKey);

    if (raw == null || raw.isEmpty) return;

    try {

      final decoded = jsonDecode(raw);

      if (decoded is! Map<String, dynamic>) return;

      _highlights.clear();

      decoded.forEach((bookId, list) {

        if (list is List) {

          _highlights[bookId] = list
              .map((e) => HighlightModel.fromJson(
                    Map<String, dynamic>.from(e),
                  ))
              .toList();
        }
      });

    } catch (_) {

      /// corrupted storage protection
      _highlights.clear();
    }
  }

  /// ===============================
  /// SAVE STORAGE
  /// ===============================

  Future<void> _save() async {

    _prefs ??= await SharedPreferences.getInstance();

    final data = _highlights.map(
      (key, value) => MapEntry(
        key,
        value.map((e) => e.toJson()).toList(),
      ),
    );

    await _prefs!.setString(
      _storageKey,
      jsonEncode(data),
    );
  }
}