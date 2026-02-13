import 'package:flutter/material.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/shared/widgets/book_card.dart';

class LibraryBooksGrid extends StatelessWidget {
  const LibraryBooksGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final books = dummyBooks; // reuse dummy data safely

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.65,
      ),
      itemBuilder: (context, index) {
        final book = books[index];

        return BookCard(
          book: book,
          onTap: () {},
        );
      },
    );
  }
}
