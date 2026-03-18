import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HighlightModel {
  final String id;
  final String bookId;
  final int page;
  final int startOffset;
  final int endOffset;
  final String text;
  final String color;
  final DateTime createdAt;

  HighlightModel({
    required this.id,
    required this.bookId,
    required this.page,
    required this.startOffset,
    required this.endOffset,
    required this.text,
    this.color = "yellow",
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'page': page,
      'startOffset': startOffset,
      'endOffset': endOffset,
      'text': text,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    return HighlightModel(
      id: json['id'],
      bookId: json['bookId'],
      page: json['page'],
      startOffset: json['startOffset'],
      endOffset: json['endOffset'],
      text: json['text'],
      color: json['color'] ?? 'yellow',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class ReaderHighlightService {
  static const _storageKey = "reader_highlights";

  final Map<String, List<HighlightModel>> _highlights = {};
  SharedPreferences? _prefs;
  bool _initialized = false;

  /// ===============================
  /// INITIALIZE SERVICE
  /// ===============================
  Future<void> init() async {
    if (_initialized) return;

    _prefs = await SharedPreferences.getInstance();
    final raw = _prefs!.getString(_storageKey);

    if (raw != null && raw.isNotEmpty) {
      try {
        final decoded = jsonDecode(raw) as Map<String, dynamic>;
        _highlights.clear();
        decoded.forEach((bookId, list) {
          _highlights[bookId] = (list as List)
              .map((e) => HighlightModel.fromJson(e))
              .toList();
        });
      } catch (_) {
        _highlights.clear();
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// ADD HIGHLIGHT
  /// ===============================
  Future<void> addHighlight({
    required String bookId,
    required int page,
    required String text,
    int startOffset = 0,
    int endOffset = 0,
    String color = "yellow",
  }) async {
    if (bookId.isEmpty || text.isEmpty) return;

    _highlights.putIfAbsent(bookId, () => []);
    final list = _highlights[bookId]!;

    // Prevent overlapping highlights on same page
    final hasOverlap = list.any((h) =>
        h.page == page &&
        !(endOffset <= h.startOffset || startOffset >= h.endOffset));

    if (hasOverlap) return;

    final highlight = HighlightModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: bookId,
      page: page,
      startOffset: startOffset,
      endOffset: endOffset,
      text: text,
      color: color,
      createdAt: DateTime.now(),
    );

    list.add(highlight);

    // Sort by page and startOffset
    list.sort((a, b) {
      if (a.page != b.page) return a.page.compareTo(b.page);
      return a.startOffset.compareTo(b.startOffset);
    });

    await _save();
  }

  /// ===============================
  /// REMOVE HIGHLIGHT
  /// ===============================
  Future<void> removeHighlight(String bookId, String highlightId) async {
    final list = _highlights[bookId];
    if (list == null) return;

    list.removeWhere((h) => h.id == highlightId);
    await _save();
  }

  /// ===============================
  /// GET ALL HIGHLIGHTS FOR BOOK
  /// ===============================
  List<HighlightModel> getHighlights(String bookId) {
    return List.unmodifiable(_highlights[bookId] ?? []);
  }

  /// ===============================
  /// GET HIGHLIGHTS FOR SPECIFIC PAGE
  /// ===============================
  List<HighlightModel> getPageHighlights(String bookId, int page) {
    final list = _highlights[bookId];
    if (list == null) return [];
    return list.where((h) => h.page == page).toList();
  }

  /// ===============================
  /// COUNT HIGHLIGHTS
  /// ===============================
  int getHighlightCount(String bookId) {
    return _highlights[bookId]?.length ?? 0;
  }

  /// ===============================
  /// CLEAR ALL HIGHLIGHTS FOR BOOK
  /// ===============================
  Future<void> clearBookHighlights(String bookId) async {
    _highlights.remove(bookId);
    await _save();
  }

  /// ===============================
  /// SAVE TO STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();

    final data = _highlights.map((key, value) =>
        MapEntry(key, value.map((e) => e.toJson()).toList()));

    await _prefs!.setString(_storageKey, jsonEncode(data));
  }
}