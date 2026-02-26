/// 📚 LibraryBook Model
/// Immutable book object with helper methods for copy, JSON serialization, and deserialization.

class LibraryBook {
  /// Unique book identifier
  final String id;

  /// Book title
  final String title;

  /// Book author
  final String author;

  /// Book category (e.g. Fiction, Self Growth)
  final String category;

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
    required this.author,
    required this.category,
    required this.imagePath,
    this.progress = 0.0,
    this.downloaded = false,
    this.favorite = false,
    this.chapters = const [],
    this.lastReadChapter = 0,
  });

  LibraryBook copyWith({
    String? id,
    String? title,
    String? author,
    String? category,
    String? imagePath,
    double? progress,
    bool? downloaded,
    bool? favorite,
    List<String>? chapters,
    int? lastReadChapter,
  }) {
    return LibraryBook(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      progress: progress ?? this.progress,
      downloaded: downloaded ?? this.downloaded,
      favorite: favorite ?? this.favorite,
      chapters: chapters ?? this.chapters,
      lastReadChapter: lastReadChapter ?? this.lastReadChapter,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'category': category,
      'imagePath': imagePath,
      'progress': progress,
      'downloaded': downloaded,
      'favorite': favorite,
      'chapters': chapters,
      'lastReadChapter': lastReadChapter,
    };
  }

  factory LibraryBook.fromJson(Map<String, dynamic> json) {
    return LibraryBook(
      id: json['id'] as String,
      title: json['title'] as String,
      author: json['author'] as String? ?? 'Unknown Author',
      category: json['category'] as String? ?? 'General',
      imagePath: json['imagePath'] as String,
      progress: (json['progress'] ?? 0.0).toDouble(),
      downloaded: json['downloaded'] ?? false,
      favorite: json['favorite'] ?? false,
      chapters: List<String>.from(json['chapters'] ?? []),
      lastReadChapter: json['lastReadChapter'] ?? 0,
    );
  }
}
