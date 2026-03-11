import 'package:book_app/features/reader/models/reader_book_model.dart' show ReaderBookModel;

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

  factory ReaderStatsSummary.fromBooks(List<ReaderBookModel> books) {
    if (books.isEmpty) return ReaderStatsSummary.empty();

    int completed = 0;
    int reading = 0;
    double progressTotal = 0;

    for (final book in books) {
      progressTotal += book.progressPercent;

      if (book.progressPercent >= 100) {
        completed++;
      } else if (book.progressPercent > 0) {
        reading++;
      }
    }

    return ReaderStatsSummary(
      totalBooksRead: books.length,
      completedBooks: completed,
      currentlyReading: reading,
      averageProgress: progressTotal / books.length,
    );
  }
}