import '../models/reading_progress_model.dart';

class ReaderRepository {

  final Map<String, ReadingProgressModel> _db = {};

  Future<void> saveProgress(ReadingProgressModel progress) async {
    _db[progress.bookId] = progress;
  }

  Future<ReadingProgressModel?> getProgress(String bookId) async {
    return _db[bookId];
  }
}