class Book {

  /// 🔑 Unique ID (future database use)
  final String id;

  final String title;
  final String author;
  final String coverImage;
  final String summary;

  final double rating;
  final bool isPaid;
  final bool isPremium;

  /// Reader Compatibility
  final List<String> chapters;

  /// Analytics / Tracking
  int totalReads;
  int likes;

  /// 🕒 Timestamps (future safe)
  final DateTime createdAt;
  final DateTime updatedAt;

  /// ✍ Writer activation (optional)
  final DateTime? writerActivatedAt;

  Book({
    this.id = '', // default empty (old code safe)
    required this.title,
    required this.author,
    required this.coverImage,
    required this.summary,
    this.rating = 0.0,
    this.isPaid = false,
    this.isPremium = false,
    this.chapters = const [],
    this.totalReads = 0,
    this.likes = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.writerActivatedAt, // ✅ now connected
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Description alias (if needed)
  String get description => summary;

  /// 🛠 Safe update method (VERY useful)
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? coverImage,
    String? summary,
    double? rating,
    bool? isPaid,
    bool? isPremium,
    List<String>? chapters,
    int? totalReads,
    int? likes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? writerActivatedAt,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      coverImage: coverImage ?? this.coverImage,
      summary: summary ?? this.summary,
      rating: rating ?? this.rating,
      isPaid: isPaid ?? this.isPaid,
      isPremium: isPremium ?? this.isPremium,
      chapters: chapters ?? this.chapters,
      totalReads: totalReads ?? this.totalReads,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      writerActivatedAt: writerActivatedAt ?? this.writerActivatedAt,
    );
  }
}
