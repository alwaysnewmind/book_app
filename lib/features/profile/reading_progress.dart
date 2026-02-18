class ReadingProgress {
  final String bookId;
  final int lastPage;
  final DateTime updatedAt;

  ReadingProgress({
    required this.bookId,
    required this.lastPage,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  /// Convert to JSON for storage or API
  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'lastPage': lastPage,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create object from JSON
  factory ReadingProgress.fromJson(Map<String, dynamic> json) {
    return ReadingProgress(
      bookId: json['bookId'],
      lastPage: json['lastPage'],
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Copy with new lastPage (immutable pattern)
  ReadingProgress copyWith({int? lastPage}) {
    return ReadingProgress(
      bookId: bookId,
      lastPage: lastPage ?? this.lastPage,
      updatedAt: DateTime.now(),
    );
  }
}
