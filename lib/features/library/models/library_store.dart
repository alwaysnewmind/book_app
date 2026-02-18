import 'library_book.dart';

class LibraryStore {
  // Private book list
  static final List<LibraryBook> _books = [];

  // Public getter (read-only)
  static List<LibraryBook> get books => List.unmodifiable(_books);

  /// Add a book if it doesn't exist
  static void addBook(LibraryBook book) {
    if (!_books.any((b) => b.id == book.id)) {
      _books.add(book);
    }
  }

  /// Remove a book by ID
  static void removeBook(String id) {
    _books.removeWhere((b) => b.id == id);
  }

  /// Check if a book exists
  static bool containsBook(String id) {
    return _books.any((b) => b.id == id);
  }

  /// Update reading progress (immutable)
  static void updateProgress(String id, double progress) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] = _books[index].copyWith(
        progress: progress.clamp(0.0, 1.0),
      );
    }
  }

  /// Mark book as downloaded (immutable)
  static void setDownloaded(String id, bool value) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] = _books[index].copyWith(downloaded: value);
    }
  }

  /// Mark book as favorite (immutable)
  static void setFavorite(String id, bool value) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] = _books[index].copyWith(favorite: value);
    }
  }

  /// Get a book by ID
  static LibraryBook? getBook(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Clear entire library
  static void clearLibrary() {
    _books.clear();
  }
}
