class Book {

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

  Book({
  
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
  });

  /// Description alias (if needed)
  String get description => summary;
}
