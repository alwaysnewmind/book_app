import '../models/book_model.dart';

final List<BookModel> sampleBooks = [
  BookModel(
    title: "Test Book 1",
    author: "Author One",
    cover: "assets/images/book1.jpg", // optional
    pdfPath: "assets/original/book1.pdf",
  ),
  BookModel(
    title: "Test Book 2",
    author: "Author Two",
    cover: "assets/images/book2.jpg",
    pdfPath: "assets/original/book2.pdf",
  ),
];