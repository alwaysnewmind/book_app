class ReaderStatsModel {
  final int totalReadingTime;
  final int pagesRead;
  final int booksCompleted;
  final int readingStreak;

  const ReaderStatsModel({
    required this.totalReadingTime,
    required this.pagesRead,
    required this.booksCompleted,
    required this.readingStreak,
  });

  factory ReaderStatsModel.empty() {
    return const ReaderStatsModel(
      totalReadingTime: 0,
      pagesRead: 0,
      booksCompleted: 0,
      readingStreak: 0,
    );
  }

  ReaderStatsModel copyWith({
    int? totalReadingTime,
    int? pagesRead,
    int? booksCompleted,
    int? readingStreak,
  }) {
    return ReaderStatsModel(
      totalReadingTime: totalReadingTime ?? this.totalReadingTime,
      pagesRead: pagesRead ?? this.pagesRead,
      booksCompleted: booksCompleted ?? this.booksCompleted,
      readingStreak: readingStreak ?? this.readingStreak,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalReadingTime': totalReadingTime,
      'pagesRead': pagesRead,
      'booksCompleted': booksCompleted,
      'readingStreak': readingStreak,
    };
  }

  factory ReaderStatsModel.fromJson(Map<String, dynamic> json) {
    return ReaderStatsModel(
      totalReadingTime: (json['totalReadingTime'] ?? 0) as int,
      pagesRead: (json['pagesRead'] ?? 0) as int,
      booksCompleted: (json['booksCompleted'] ?? 0) as int,
      readingStreak: (json['readingStreak'] ?? 0) as int,
    );
  }
}
