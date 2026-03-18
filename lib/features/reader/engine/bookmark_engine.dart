import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkModel {
  final String id;
  final String bookId;
  final int page;
  final DateTime createdAt;
  final String? note;

  BookmarkModel({
    required this.id,
    required this.bookId,
    required this.page,
    required this.createdAt,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bookId": bookId,
      "page": page,
      "createdAt": createdAt.toIso8601String(),
      "note": note,
    };
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    return BookmarkModel(
      id: json["id"]?.toString() ?? "",
      bookId: json["bookId"]?.toString() ?? "",
      page: (json["page"] ?? 0) as int,
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
      note: json["note"],
    );
  }
}

class BookmarkEngine {
  static const String _storageKey = "reader_bookmarks";

  SharedPreferences? _prefs;

  bool _initialized = false;

  /// bookId -> bookmarks
  final Map<String, List<BookmarkModel>> _bookmarks = {};

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
  /// ADD BOOKMARK
  /// ===============================
  Future<void> addBookmark({
    required String bookId,
    required int page,
    String? note,
  }) async {
    if (bookId.isEmpty || page < 0) return;

    _bookmarks.putIfAbsent(bookId, () => []);

    final list = _bookmarks[bookId]!;

    /// prevent duplicate page bookmark
    final exists = list.any((b) => b.page == page);
    if (exists) return;

    final bookmark = BookmarkModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: bookId,
      page: page,
      createdAt: DateTime.now(),
      note: note,
    );

    list.add(bookmark);

    /// sort bookmarks by page
    list.sort((a, b) => a.page.compareTo(b.page));

    await _save();
  }

  /// ===============================
  /// REMOVE BOOKMARK
  /// ===============================
  Future<void> removeBookmark({
    required String bookId,
    required String bookmarkId,
  }) async {
    final list = _bookmarks[bookId];
    if (list == null || list.isEmpty) return;

    final before = list.length;

    list.removeWhere((b) => b.id == bookmarkId);

    if (before != list.length) {
      await _save();
    }
  }

  /// ===============================
  /// GET BOOKMARKS
  /// ===============================
  List<BookmarkModel> getBookmarks(String bookId) {
    final list = _bookmarks[bookId];

    if (list == null || list.isEmpty) {
      return const [];
    }

    return List.unmodifiable(list);
  }

  /// ===============================
  /// GET BOOKMARK BY PAGE
  /// ===============================
  BookmarkModel? getBookmarkByPage(
    String bookId,
    int page,
  ) {
    final list = _bookmarks[bookId];

    if (list == null || list.isEmpty) return null;

    for (final b in list) {
      if (b.page == page) return b;
    }

    return null;
  }

  /// ===============================
  /// BOOKMARK COUNT
  /// ===============================
  int getBookmarkCount(String bookId) {
    return _bookmarks[bookId]?.length ?? 0;
  }

  /// ===============================
  /// CLEAR BOOKMARKS
  /// ===============================
  Future<void> clearBookBookmarks(String bookId) async {
    if (!_bookmarks.containsKey(bookId)) return;

    _bookmarks.remove(bookId);

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

      _bookmarks.clear();

      decoded.forEach((bookId, list) {
        if (list is List) {
          _bookmarks[bookId] = list
              .map((e) => BookmarkModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      });
    } catch (_) {
      /// corrupted storage protection
      _bookmarks.clear();
    }
  }

  /// ===============================
  /// SAVE STORAGE
  /// ===============================
  Future<void> _save() async {
    _prefs ??= await SharedPreferences.getInstance();

    final data = _bookmarks.map(
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