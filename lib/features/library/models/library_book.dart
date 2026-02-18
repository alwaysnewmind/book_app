/// 📚 LibraryBook Model
/// Immutable book object with helper methods for copy, JSON serialization, and deserialization.

class LibraryBook {
  /// Unique book identifier
  final String id;

  /// Book title
  final String title;

  /// Path to the book cover image asset
  final String imagePath;

  /// Reading progress (0.0 to 1.0)
  final double progress;

  /// Whether the book is downloaded locally
  final bool downloaded;

  /// Whether the book is marked as favorite
  final bool favorite;

  /// List of chapter titles (or IDs) for the book
  final List<String> chapters;

  /// Index of the last read chapter
  final int lastReadChapter;

  /// Constructor
  const LibraryBook({
    required this.id,
    required this.title,
    required this.imagePath,
    this.progress = 0.0,
    this.downloaded = false,
    this.favorite = false,
    this.chapters = const [],
    this.lastReadChapter = 0,
  });

  /// 🔹 Copy the book with updated fields
  /// Useful for immutability patterns instead of modifying fields directly
  LibraryBook copyWith({
    String? id,
    String? title,
    String? imagePath,
    double? progress,
    bool? downloaded,
    bool? favorite,
    List<String>? chapters,
  }) {
    return LibraryBook(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      progress: progress ?? this.progress,
      downloaded: downloaded ?? this.downloaded,
      favorite: favorite ?? this.favorite,
      chapters: chapters ?? this.chapters,
      lastReadChapter: lastReadChapter,
    );
  }

  /// 🔹 Convert LibraryBook to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'progress': progress,
      'downloaded': downloaded,
      'favorite': favorite,
      'chapters': chapters,
      'lastReadChapter': lastReadChapter,
    };
  }

  /// 🔹 Create a LibraryBook instance from JSON
  factory LibraryBook.fromJson(Map<String, dynamic> json) {
    return LibraryBook(
      id: json['id'] as String,
      title: json['title'] as String,
      imagePath: json['imagePath'] as String,
      progress: (json['progress'] ?? 0.0).toDouble(),
      downloaded: json['downloaded'] ?? false,
      favorite: json['favorite'] ?? false,
      chapters: List<String>.from(json['chapters'] ?? []),
      lastReadChapter: json['lastReadChapter'] ?? 0,
    );
  }

  @override
  String toString() {
    return 'LibraryBook(id: $id, title: $title, progress: $progress, downloaded: $downloaded, favorite: $favorite, lastReadChapter: $lastReadChapter, chapters: $chapters)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LibraryBook &&
        other.id == id &&
        other.title == title &&
        other.imagePath == imagePath &&
        other.progress == progress &&
        other.downloaded == downloaded &&
        other.favorite == favorite &&
        other.lastReadChapter == lastReadChapter &&
        _listEquals(other.chapters, chapters);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        imagePath.hashCode ^
        progress.hashCode ^
        downloaded.hashCode ^
        favorite.hashCode ^
        lastReadChapter.hashCode ^
        chapters.hashCode;
  }

  /// Utility to compare two lists of strings
  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
