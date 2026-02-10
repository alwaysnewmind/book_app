class Book {
  final String title;
  final String author;
  final String coverImage;
  final String summary;
  final double rating;
  final bool isPaid;

  Book({
    required this.title,
    required this.author,
    required this.coverImage,
    required this.summary,
    this.rating = 0.0,
    this.isPaid = false,
  });
}
