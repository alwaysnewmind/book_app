import 'package:flutter/material.dart';
import '../../models/book_model.dart';
import '../../home/widgets/book_card.dart';

class LibraryBooksGrid extends StatelessWidget {
  const LibraryBooksGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final books = featuredBooks; // dummy reuse

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // web
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        return BookCard(book: books[index]);
      },
    );
  }
}
