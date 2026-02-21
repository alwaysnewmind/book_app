// features/reader/data/dummy_reader_data.dart

class ReaderBook {
  final String id;
  final String title;
  final String author;
  final String cover;
  final String pdfPath;
  final bool isPremium;
  final int price;
  final double progress; // 0.0 - 1.0

  const ReaderBook({
    required this.id,
    required this.title,
    required this.author,
    required this.cover,
    required this.pdfPath,
    this.isPremium = false,
    this.price = 0,
    this.progress = 0.0,
  });
}

class ReadingTask {
  final String id;
  final String title;
  final String description;
  final int rewardCoins;
  final bool isCompleted;

  const ReadingTask({
    required this.id,
    required this.title,
    required this.description,
    required this.rewardCoins,
    this.isCompleted = false,
  });
}

class ReaderAnalyticsData {
  final List<double> weeklyReadingMinutes;
  final List<int> weeklyCoins;

  const ReaderAnalyticsData({
    required this.weeklyReadingMinutes,
    required this.weeklyCoins,
  });
}

class DummyReaderData {
  /// ==============================
  /// FEATURED BOOKS
  /// ==============================

  static const List<ReaderBook> featuredBooks = [
    ReaderBook(
      id: "atomic_habits",
      title: "Atomic Habits",
      author: "James Clear",
      cover: "assets/covers/atomic.jpg",
      pdfPath: "assets/pdfs/atomic.pdf",
      progress: 0.4,
    ),
    ReaderBook(
      id: "rich_dad",
      title: "Rich Dad Poor Dad",
      author: "Robert Kiyosaki",
      cover: "assets/covers/richdad.jpg",
      pdfPath: "assets/pdfs/richdad.pdf",
      progress: 0.2,
    ),
  ];

  /// ==============================
  /// RECOMMENDED BOOKS
  /// ==============================

  static const List<ReaderBook> recommendedBooks = [
    ReaderBook(
      id: "deep_work",
      title: "Deep Work",
      author: "Cal Newport",
      cover: "assets/covers/deepwork.jpg",
      pdfPath: "assets/pdfs/deepwork.pdf",
    ),
    ReaderBook(
      id: "think_grow",
      title: "Think & Grow Rich",
      author: "Napoleon Hill",
      cover: "assets/covers/think.jpg",
      pdfPath: "assets/pdfs/think.pdf",
      isPremium: true,
      price: 200,
    ),
    ReaderBook(
      id: "psychology_money",
      title: "Psychology of Money",
      author: "Morgan Housel",
      cover: "assets/covers/money.jpg",
      pdfPath: "assets/pdfs/money.pdf",
      isPremium: true,
      price: 150,
    ),
  ];

  /// ==============================
  /// CONTINUE READING
  /// ==============================

  static const List<ReaderBook> continueReading = [
    ReaderBook(
      id: "atomic_habits",
      title: "Atomic Habits",
      author: "James Clear",
      cover: "assets/covers/atomic.jpg",
      pdfPath: "assets/pdfs/atomic.pdf",
      progress: 0.6,
    ),
  ];

  /// ==============================
  /// COMPLETED BOOKS
  /// ==============================

  static const List<ReaderBook> completedBooks = [
    ReaderBook(
      id: "mini_habits",
      title: "Mini Habits",
      author: "Stephen Guise",
      cover: "assets/covers/minihabits.jpg",
      pdfPath: "assets/pdfs/minihabits.pdf",
      progress: 1.0,
    ),
  ];

  /// ==============================
  /// READING TASKS
  /// ==============================

  static const List<ReadingTask> readingTasks = [
    ReadingTask(
      id: "task1",
      title: "Read 20 Pages Today",
      description: "Complete 20 pages to earn reward",
      rewardCoins: 30,
    ),
    ReadingTask(
      id: "task2",
      title: "Read for 30 Minutes",
      description: "Spend 30 minutes reading",
      rewardCoins: 25,
    ),
    ReadingTask(
      id: "task3",
      title: "Complete a Book",
      description: "Finish any one book",
      rewardCoins: 100,
    ),
  ];

  /// ==============================
  /// ANALYTICS DATA (WEEKLY)
  /// ==============================

  static const ReaderAnalyticsData analyticsData =
      ReaderAnalyticsData(
    weeklyReadingMinutes: [10, 25, 40, 30, 60, 45, 70],
    weeklyCoins: [5, 10, 20, 15, 30, 25, 40],
  );
}