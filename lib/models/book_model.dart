import 'package:book_app/models/writer_book_model.dart';

class BookModel {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String coverUrl;
  final String genre;
  final double rating;
  final int reviewCount;
  final bool isPaid;
  final double price;
  final int viewsCount;
  final DateTime savedAt;
  final bool isBookmarked;
  final String pdfPath;

  const BookModel({
    this.id = '',
    this.title = '',
    this.description = '',
    String authorName = 'Unknown',
    String coverUrl = '',
    this.genre = 'General',
    this.rating = 0,
    this.reviewCount = 0,
    this.isPaid = false,
    this.price = 0,
    this.viewsCount = 0,
    DateTime? savedAt,
    this.isBookmarked = false,
    this.pdfPath = '',
    String? author,
    String? cover,
  })  : authorName = author ?? authorName,
        coverUrl = cover ?? coverUrl,
        savedAt = savedAt ?? DateTime.fromMillisecondsSinceEpoch(0);

  String get author => authorName;
  String get cover => coverUrl;

  BookModel copyWith({
    String? id,
    String? title,
    String? description,
    String? authorName,
    String? coverUrl,
    String? genre,
    double? rating,
    int? reviewCount,
    bool? isPaid,
    double? price,
    int? viewsCount,
    DateTime? savedAt,
    bool? isBookmarked,
    String? pdfPath,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      coverUrl: coverUrl ?? this.coverUrl,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPaid: isPaid ?? this.isPaid,
      price: price ?? this.price,
      viewsCount: viewsCount ?? this.viewsCount,
      savedAt: savedAt ?? this.savedAt,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }

  factory BookModel.fromFirestore({
    required String id,
    required Map<String, dynamic> bookData,
    DateTime? savedAt,
  }) {
    return BookModel(
      id: id,
      title: bookData['title']?.toString() ?? '',
      description: bookData['description']?.toString() ?? '',
      authorName: bookData['authorName']?.toString() ?? 'Unknown',
      coverUrl: bookData['coverUrl']?.toString() ?? 'assets/books/Book1.png',
      genre: bookData['genre']?.toString() ?? 'General',
      rating: (bookData['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (bookData['reviewCount'] as num?)?.toInt() ?? 0,
      isPaid: bookData['isPaid'] == true,
      price: (bookData['price'] as num?)?.toDouble() ?? 0,
      viewsCount: (bookData['viewsCount'] as num?)?.toInt() ?? 0,
      savedAt: savedAt,
      isBookmarked: true,
    );
  }

  Book toWriterBook() {
    return Book(
      id: id,
      title: title,
      author: authorName,
      authorName: authorName,
      coverImage: coverUrl,
      summary: description,
      rating: rating,
      reviewCount: reviewCount,
      isPaid: isPaid,
      isPremium: isPaid,
      price: price,
      genre: genre,
      viewsCount: viewsCount,
    );
  }
}
