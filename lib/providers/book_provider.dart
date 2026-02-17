import 'package:flutter/material.dart';

class Book {
  final String id;
  final String title;
  final String author;
  final String imagePath;
  final String description;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imagePath,
    required this.description,
  });
}

class BookProvider extends ChangeNotifier {
  List<Book> _books = [];

  List<Book> get books => _books;

  void loadDummyBooks() {
    _books = [
      Book(
        id: "1",
        title: "The Dark Night",
        author: "John Doe",
        imagePath: "assets/images/book1.jpg",
        description: "A thrilling mystery novel...",
      ),
    ];
    notifyListeners();
  }
}
