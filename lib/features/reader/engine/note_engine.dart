import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NoteModel {

  final String id;
  final String bookId;
  final int page;
  final String content;
  final DateTime createdAt;

  NoteModel({
    required this.id,
    required this.bookId,
    required this.page,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "bookId": bookId,
      "page": page,
      "content": content,
      "createdAt": createdAt.toIso8601String(),
    };
  }

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json["id"],
      bookId: json["bookId"],
      page: json["page"],
      content: json["content"],
      createdAt: DateTime.parse(json["createdAt"]),
    );
  }
}

class NoteEngine {

  static const _key = "reader_notes";

  final Map<String, List<NoteModel>> _notes = {};

  SharedPreferences? _prefs;
  bool _initialized = false;

  /// ===============================
  /// INIT
  /// ===============================

  Future<void> init() async {

    if (_initialized) return;

    _prefs ??= await SharedPreferences.getInstance();

    final raw = _prefs!.getString(_key);

    if (raw != null && raw.isNotEmpty) {

      try {

        final decoded = jsonDecode(raw);

        if (decoded is Map<String, dynamic>) {

          decoded.forEach((bookId, list) {

            if (list is List) {

              _notes[bookId] = list
                  .map((e) => NoteModel.fromJson(
                        Map<String, dynamic>.from(e),
                      ))
                  .toList();
            }
          });
        }

      } catch (_) {

        /// corrupted storage protection
        _notes.clear();
      }
    }

    _initialized = true;
  }

  /// ===============================
  /// ADD NOTE
  /// ===============================

  Future<void> addNote({
    required String bookId,
    required int page,
    required String content,
  }) async {

    if (bookId.isEmpty) return;
    if (page < 0) return;

    final text = content.trim();

    if (text.isEmpty) return;

    _notes.putIfAbsent(bookId, () => []);

    final note = NoteModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      bookId: bookId,
      page: page,
      content: text,
      createdAt: DateTime.now(),
    );

    _notes[bookId]!.add(note);

    await _save();
  }

  /// ===============================
  /// GET NOTES
  /// ===============================

  List<NoteModel> getNotes(String bookId) {

    final list = _notes[bookId];

    if (list == null || list.isEmpty) {
      return const [];
    }

    return List.unmodifiable(list);
  }

  /// ===============================
  /// DELETE NOTE
  /// ===============================

  Future<void> deleteNote(
    String bookId,
    String noteId,
  ) async {

    final list = _notes[bookId];

    if (list == null || list.isEmpty) return;

    final before = list.length;

    list.removeWhere((n) => n.id == noteId);

    if (before != list.length) {
      await _save();
    }
  }

  /// ===============================
  /// SAVE
  /// ===============================

  Future<void> _save() async {

    _prefs ??= await SharedPreferences.getInstance();

    final data = _notes.map(
      (k, v) => MapEntry(
        k,
        v.map((e) => e.toJson()).toList(),
      ),
    );

    await _prefs!.setString(
      _key,
      jsonEncode(data),
    );
  }
}

   