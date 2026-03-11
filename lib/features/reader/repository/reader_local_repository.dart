import '../models/reading_progress_model.dart';

class ReaderLocalRepository {

  final Map<String, ReadingProgressModel> _cache = {};

  void cacheProgress(ReadingProgressModel progress) {
    _cache[progress.bookId] = progress;
  }

  ReadingProgressModel? getCached(String bookId) {
    return _cache[bookId];
  }
}