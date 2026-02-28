class Book {
  /// 🔑 Unique ID
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final String summary;

  /// Backend ready fields
  final String authorId;
  final String authorName;
  final double rating;
  final int reviewCount;
  final bool isPaid;
  final bool isPremium;
  final double price;
  final double totalEarnings;
  final String genre;
  final int viewsCount;

  /// Reader Compatibility
  final List<String> chapters;

  /// Analytics / Tracking
  int totalReads;
  int likes;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? writerActivatedAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.coverImage,
    required this.summary,
    this.authorId = '',
    this.authorName = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isPaid = false,
    this.isPremium = false,
    this.price = 0,
    this.totalEarnings = 0,
    this.genre = 'General',
    this.viewsCount = 0,
    this.chapters = const [],
    this.totalReads = 0,
    this.likes = 0,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.writerActivatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  String get description => summary;

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? coverImage,
    String? summary,
    String? authorId,
    String? authorName,
    double? rating,
    int? reviewCount,
    bool? isPaid,
    bool? isPremium,
    double? price,
    double? totalEarnings,
    String? genre,
    int? viewsCount,
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
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPaid: isPaid ?? this.isPaid,
      isPremium: isPremium ?? this.isPremium,
      price: price ?? this.price,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      genre: genre ?? this.genre,
      viewsCount: viewsCount ?? this.viewsCount,
      chapters: chapters ?? this.chapters,
      totalReads: totalReads ?? this.totalReads,
      likes: likes ?? this.likes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      writerActivatedAt: writerActivatedAt ?? this.writerActivatedAt,
    );
  }
}
