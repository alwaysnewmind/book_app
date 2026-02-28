import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String coverUrl;
  final String genre;
  final double rating;
  final int reviewCount;
  final int viewsCount;
  final double totalEarnings;
  final bool isPaid;
  final double price;
  final DateTime createdAt;

  /// Legacy compatibility for existing UI/screens
  String get author => authorName;
  String get cover => coverUrl;
  String get pdfPath => 'assets/original/book1.pdf';

  const BookModel({
    this.id = '',
    required this.title,
    this.description = '',
    required this.authorName,
    required this.coverUrl,
    this.genre = 'General',
    this.rating = 0,
    this.reviewCount = 0,
    this.viewsCount = 0,
    this.totalEarnings = 0,
    this.isPaid = false,
    this.price = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory BookModel.fromMap(String id, Map<String, dynamic>? map) {
    final data = map ?? <String, dynamic>{};
    final createdAtValue = data['createdAt'];
    return BookModel(
      id: id,
      title: data['title']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      authorName: data['authorName']?.toString() ?? 'Unknown',
      coverUrl: data['coverUrl']?.toString() ?? 'assets/books/Book1.png',
      genre: data['genre']?.toString() ?? 'General',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      reviewCount: (data['reviewCount'] as num?)?.toInt() ?? 0,
      viewsCount: (data['viewsCount'] as num?)?.toInt() ?? 0,
      totalEarnings: (data['totalEarnings'] as num?)?.toDouble() ?? 0,
      isPaid: data['isPaid'] == true,
      price: (data['price'] as num?)?.toDouble() ?? 0,
      createdAt: createdAtValue is Timestamp
          ? createdAtValue.toDate()
          : createdAtValue is DateTime
              ? createdAtValue
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'authorName': authorName,
      'coverUrl': coverUrl,
      'genre': genre,
      'rating': rating,
      'reviewCount': reviewCount,
      'viewsCount': viewsCount,
      'totalEarnings': totalEarnings,
      'isPaid': isPaid,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
