class ReaderDownloadService {

  final Set<String> _downloadedBooks = {};

  Future<void> downloadBook(String bookId) async {
    await Future.delayed(const Duration(seconds: 1));
    _downloadedBooks.add(bookId);
  }

  bool isDownloaded(String bookId) {
    return _downloadedBooks.contains(bookId);
  }
}