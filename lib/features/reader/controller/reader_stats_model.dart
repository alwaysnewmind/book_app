// features/reader/models/reader_state_model.dart

class ReaderStateModel {
  /// ==============================
  /// GLOBAL USER DATA
  /// ==============================

  final int coins;
  final int xp;
  final int level;
  final int streak;
  final int totalReadingSeconds;
  final int completedBooks;

  /// ==============================
  /// BOOK TRACKING
  /// ==============================

  /// bookId -> last page
  final Map<String, int> bookProgress;

  /// unlocked premium books
  final Set<String> unlockedBooks;

  /// completed book IDs
  final Set<String> completedBookIds;

  /// ==============================
  /// CONSTRUCTOR
  /// ==============================

  const ReaderStateModel({
    required this.coins,
    required this.xp,
    required this.level,
    required this.streak,
    required this.totalReadingSeconds,
    required this.completedBooks,
    required this.bookProgress,
    required this.unlockedBooks,
    required this.completedBookIds,
  });

  /// ==============================
  /// INITIAL STATE
  /// ==============================

  factory ReaderStateModel.initial() {
    return const ReaderStateModel(
      coins: 0,
      xp: 0,
      level: 1,
      streak: 0,
      totalReadingSeconds: 0,
      completedBooks: 0,
      bookProgress: {},
      unlockedBooks: {},
      completedBookIds: {},
    );
  }

  /// ==============================
  /// COPY WITH (IMMUTABLE UPDATE)
  /// ==============================

  ReaderStateModel copyWith({
    int? coins,
    int? xp,
    int? level,
    int? streak,
    int? totalReadingSeconds,
    int? completedBooks,
    Map<String, int>? bookProgress,
    Set<String>? unlockedBooks,
    Set<String>? completedBookIds,
  }) {
    return ReaderStateModel(
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      streak: streak ?? this.streak,
      totalReadingSeconds:
          totalReadingSeconds ?? this.totalReadingSeconds,
      completedBooks: completedBooks ?? this.completedBooks,
      bookProgress: bookProgress ?? this.bookProgress,
      unlockedBooks: unlockedBooks ?? this.unlockedBooks,
      completedBookIds:
          completedBookIds ?? this.completedBookIds,
    );
  }

  /// ==============================
  /// LEVEL PROGRESS %
  /// ==============================

  double get levelProgress {
    final requiredXp = level * 200;
    return xp / requiredXp;
  }

  /// ==============================
  /// FORMATTERS
  /// ==============================

  String get formattedReadingTime {
    final hours = totalReadingSeconds ~/ 3600;
    final minutes = (totalReadingSeconds % 3600) ~/ 60;

    return "${hours}h ${minutes}m";
  }

  /// ==============================
  /// SERIALIZATION
  /// ==============================

  Map<String, dynamic> toJson() {
    return {
      'coins': coins,
      'xp': xp,
      'level': level,
      'streak': streak,
      'totalReadingSeconds': totalReadingSeconds,
      'completedBooks': completedBooks,
      'bookProgress': bookProgress,
      'unlockedBooks': unlockedBooks.toList(),
      'completedBookIds': completedBookIds.toList(),
    };
  }

  factory ReaderStateModel.fromJson(Map<String, dynamic> json) {
    return ReaderStateModel(
      coins: json['coins'] ?? 0,
      xp: json['xp'] ?? 0,
      level: json['level'] ?? 1,
      streak: json['streak'] ?? 0,
      totalReadingSeconds:
          json['totalReadingSeconds'] ?? 0,
      completedBooks: json['completedBooks'] ?? 0,
      bookProgress:
          Map<String, int>.from(json['bookProgress'] ?? {}),
      unlockedBooks:
          Set<String>.from(json['unlockedBooks'] ?? []),
      completedBookIds:
          Set<String>.from(json['completedBookIds'] ?? []),
    );
  }

  /// ==============================
  /// DEBUG
  /// ==============================

  @override
  String toString() {
    return '''
ReaderStateModel(
  coins: $coins,
  xp: $xp,
  level: $level,
  streak: $streak,
  readingTime: $formattedReadingTime,
  completedBooks: $completedBooks
)
''';
  }
}