class Book {
  final String title;
  final String author;
  final bool isPaid;
  final String coverImage;
  final String summary;
  final double rating;

  Book({
    required this.title,
    required this.author,
    required this.coverImage,
    required this.summary,
    this.rating = 4.0,
    this.isPaid = false,
  });
}
