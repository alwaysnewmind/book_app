import 'package:book_app/features/book/model/book_model.dart';

final List<BookModel> sampleBooks = [
  BookModel(
    id: 'sample_1',
    title: "Test Book 1",
    authorName: "Author One",
    coverUrl: "assets/books/Book1.png",
    description: 'Sample description',
    genre: 'Fantasy',
  ),
  BookModel(
    id: 'sample_2',
    title: "Test Book 2",
    authorName: "Author Two",
    coverUrl: "assets/books/Book2.png",
    description: 'Sample description',
    genre: 'Mystery',
  ),
];
