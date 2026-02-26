import 'package:book_app/features/book/book_reader_screen.dart';
import 'package:book_app/features/library/models/library_book.dart';
import 'package:flutter/material.dart';

class PdfReaderScreen extends StatelessWidget {
  final LibraryBook book;

  const PdfReaderScreen({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return BookReaderScreen(book: book);
  }
}
