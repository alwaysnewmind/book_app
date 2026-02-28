class ReaderBookModel {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String coverUrl;
  final String genre;
  final double rating;
  final int totalChapters;
  final int lastReadChapter;
  final double progressPercent;
  final int viewsCount;
  final bool isBookmarked;
  final DateTime? lastReadAt;

  const ReaderBookModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    required this.coverUrl,
    required this.genre,
    required this.rating,
    required this.totalChapters,
    required this.lastReadChapter,
    required this.progressPercent,
    required this.viewsCount,
    required this.isBookmarked,
    required this.lastReadAt,
  });

  ReaderBookModel copyWith({
    String? id,
    String? title,
    String? description,
    String? authorName,
    String? coverUrl,
    String? genre,
    double? rating,
    int? totalChapters,
    int? lastReadChapter,
    double? progressPercent,
    int? viewsCount,
    bool? isBookmarked,
    DateTime? lastReadAt,
  }) {
    return ReaderBookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      authorName: authorName ?? this.authorName,
      coverUrl: coverUrl ?? this.coverUrl,
      genre: genre ?? this.genre,
      rating: rating ?? this.rating,
      totalChapters: totalChapters ?? this.totalChapters,
      lastReadChapter: lastReadChapter ?? this.lastReadChapter,
      progressPercent: progressPercent ?? this.progressPercent,
      viewsCount: viewsCount ?? this.viewsCount,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastReadAt: lastReadAt ?? this.lastReadAt,
    );
  }

  factory ReaderBookModel.fromFirestore({
    required String id,
    required Map<String, dynamic> bookData,
    Map<String, dynamic>? progressData,
    bool isBookmarked = false,
  }) {
    final totalChapters = (bookData['totalChapters'] ?? 0) as int;
    final lastReadChapter = (progressData?['lastReadChapter'] ?? 0) as int;
    final dynamic progressValue = progressData?['progressPercent'];
    final progressPercent = progressValue is num
        ? progressValue.toDouble()
        : _calculateProgress(lastReadChapter: lastReadChapter, totalChapters: totalChapters);

    return ReaderBookModel(
      id: id,
      title: (bookData['title'] ?? '') as String,
      description: (bookData['description'] ?? '') as String,
      authorName: (bookData['authorName'] ?? '') as String,
      coverUrl: (bookData['coverUrl'] ?? '') as String,
      genre: (bookData['genre'] ?? '') as String,
      rating: ((bookData['rating'] ?? 0) as num).toDouble(),
      totalChapters: totalChapters,
      lastReadChapter: lastReadChapter,
      progressPercent: progressPercent,
      viewsCount: (bookData['viewsCount'] ?? 0) as int,
      isBookmarked: isBookmarked,
      lastReadAt: progressData?['lastReadAt'] as DateTime?,
    );
  }

  static double _calculateProgress({
    required int lastReadChapter,
    required int totalChapters,
  }) {
    if (totalChapters <= 0) return 0;
    return (lastReadChapter / totalChapters) * 100;
  }
}

class ReaderStatsSummary {
  final int totalBooksRead;
  final int completedBooks;
  final int currentlyReading;
  final double averageProgress;

  const ReaderStatsSummary({
    required this.totalBooksRead,
    required this.completedBooks,
    required this.currentlyReading,
    required this.averageProgress,
  });

  factory ReaderStatsSummary.empty() {
    return const ReaderStatsSummary(
      totalBooksRead: 0,
      completedBooks: 0,
      currentlyReading: 0,
      averageProgress: 0,
    );
  }
}
