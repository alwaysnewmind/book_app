import 'package:book_app/features/library/models/library_book.dart';

/// 📚 Demo / Fallback Books
/// NOTE: Replace with API / Firestore data in production
class LibraryData {
  const LibraryData._(); // 🔒 Prevent instantiation

  static const List<LibraryBook> demoBooks = [
    LibraryBook(
      id: "1",
      title: "Demo Book",
      author: "Author Name",
      category: "Story",
      imagePath: "assets/books/book1.png",
      pdfPath: "assets/original/book1.pdf",
    ),
    LibraryBook(
      id: "2",
      title: "Second Book",
      author: "Writer",
      category: "Motivation",
      imagePath: "assets/books/book2.png",
      pdfPath: "assets/original/book2.pdf",
    ),
  ];
}