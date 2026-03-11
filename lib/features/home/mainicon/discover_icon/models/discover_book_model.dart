// discover_book_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class DiscoverBook {
  final String id;
  final String title;
  final String authorName;
  final String coverUrl;
  final String categoryId;
  final double rating;
  final int totalReads;
  final bool isPremium;
  final DateTime createdAt;

  const DiscoverBook({
    required this.id,
    required this.title,
    required this.authorName,
    required this.coverUrl,
    required this.categoryId,
    required this.rating,
    required this.totalReads,
    required this.isPremium,
    required this.createdAt,
  });

  /// ---------------- FACTORY ----------------

  factory DiscoverBook.fromMap(
    Map<String, dynamic>? map,
    String documentId,
  ) {
    final data = map ?? {};

    return DiscoverBook(
      id: documentId,
      title: data['title']?.toString() ?? '',
      authorName: data['authorName']?.toString() ?? '',
      coverUrl: data['coverUrl']?.toString() ?? '',
      categoryId: data['categoryId']?.toString() ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      totalReads: (data['totalReads'] as num?)?.toInt() ?? 0,
      isPremium: data['isPremium'] == true,
      createdAt: _parseCreatedAt(data['createdAt']),
    );
  }

  /// ---------------- TO MAP ----------------

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'authorName': authorName,
      'coverUrl': coverUrl,
      'categoryId': categoryId,
      'rating': rating,
      'totalReads': totalReads,
      'isPremium': isPremium,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// ---------------- SAFE DATE PARSER ----------------

  static DateTime _parseCreatedAt(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return DateTime.now();
  }

  /// ---------------- COPY WITH ----------------

  DiscoverBook copyWith({
    String? title,
    String? authorName,
    String? coverUrl,
    String? categoryId,
    double? rating,
    int? totalReads,
    bool? isPremium,
    DateTime? createdAt,
  }) {
    return DiscoverBook(
      id: id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      coverUrl: coverUrl ?? this.coverUrl,
      categoryId: categoryId ?? this.categoryId,
      rating: rating ?? this.rating,
      totalReads: totalReads ?? this.totalReads,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}