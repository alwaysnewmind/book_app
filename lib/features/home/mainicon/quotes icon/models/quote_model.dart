import 'package:cloud_firestore/cloud_firestore.dart';

class QuoteModel {
  final String id;
  final String category;
  final String quote;
  final String author;
  final String tag;
  final int likes;
  final List<String> likedBy;
  final Timestamp createdAt;

  const QuoteModel({
    required this.id,
    required this.category,
    required this.quote,
    required this.author,
    required this.tag,
    required this.likes,
    required this.likedBy,
    required this.createdAt,
  });

  factory QuoteModel.fromJson(String id, Map<String, dynamic>? json) {
    final safeJson = json ?? <String, dynamic>{};
    final rawCategory = safeJson['category'];
    final normalizedCategory = rawCategory is String ? rawCategory.trim() : '';

    return QuoteModel(
      id: id,
      category: normalizedCategory.isNotEmpty ? normalizedCategory : 'Emotional',
      quote: (safeJson['quote'] as String?)?.trim() ?? '',
      author: (safeJson['author'] as String?)?.trim().isNotEmpty == true
          ? (safeJson['author'] as String).trim()
          : 'Unknown',
      tag: (safeJson['tag'] as String?)?.trim() ?? '',
      likes: (safeJson['likes'] as num?)?.toInt() ?? 0,
      likedBy: (safeJson['likedBy'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          const <String>[],
      createdAt: safeJson['createdAt'] is Timestamp
          ? safeJson['createdAt'] as Timestamp
          : Timestamp.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'category': category,
      'quote': quote,
      'author': author,
      'tag': tag,
      'likes': likes,
      'likedBy': likedBy,
      'createdAt': createdAt,
    };
  }

  QuoteModel copyWith({
    String? id,
    String? category,
    String? quote,
    String? author,
    String? tag,
    int? likes,
    List<String>? likedBy,
    Timestamp? createdAt,
  }) {
    return QuoteModel(
      id: id ?? this.id,
      category: category ?? this.category,
      quote: quote ?? this.quote,
      author: author ?? this.author,
      tag: tag ?? this.tag,
      likes: likes ?? this.likes,
      likedBy: likedBy ?? this.likedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
