import 'package:book_app/features/library/models/library_book.dart';

class LibraryStore {
  static final List<LibraryBook> _books = [];

  static List<LibraryBook> get books => _books;

  static void addBook(LibraryBook book) {
    if (!_books.any((b) => b.title == book.title)) {
      _books.add(book);
    }
  }
}
