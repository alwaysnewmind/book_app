import 'package:flutter/material.dart';
import 'library_book.dart';

class LibraryStore extends ChangeNotifier {

  final List<LibraryBook> _books = [];

  // Public getter
  List<LibraryBook> get books => List.unmodifiable(_books);

  static get instance => null;

  /// Add Book
  void addBook(LibraryBook book) {
    if (!_books.any((b) => b.id == book.id)) {
      _books.add(book);
      notifyListeners();
    }
  }

  /// Remove Book
  void removeBook(String id) {
    _books.removeWhere((b) => b.id == id);
    notifyListeners();
  }

  /// Check if book exists
  bool containsBook(String id) {
    return _books.any((b) => b.id == id);
  }

  /// Update progress
  void updateProgress(String id, double progress) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] =
          _books[index].copyWith(progress: progress.clamp(0.0, 1.0));
      notifyListeners();
    }
  }

  /// Set Downloaded
  void setDownloaded(String id, bool value) {
    final index = _books.indexWhere((b) => b.id == id);
    if (index != -1) {
      _books[index] = _books[index].copyWith(downloaded: value);
      notifyListeners();
    }
  }

  /// Set Favorite
  void setFavorite(String id, bool value) {
    final index = _books.indexWhere((b) => b.id == id);
      if (index != -1) {
        _books[index] = _books[index].copyWith(favorite: value);
        notifyListeners();
      }
  }

  /// Get Book
  LibraryBook? getBook(String id) {
    try {
      return _books.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Clear Library
  void clearLibrary() {
    _books.clear();
    notifyListeners();
  }
}
