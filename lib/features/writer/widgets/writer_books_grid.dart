import 'package:flutter/material.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/shared/widgets/book_card.dart';
import 'package:book_app/models/writer_book_model.dart';


class WriterBooksGrid extends StatelessWidget {
  const WriterBooksGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Book> books = dummyBooks;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive columns
        int crossAxisCount = 3;

        if (constraints.maxWidth < 900) {
          crossAxisCount = 2;
        }
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: books.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (context, index) {
            final book = books[index];

            return BookCard(
              book: book,
              onTap: () {
                // TODO: Navigate to edit screen later
                // Example:
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => EditBookScreen(book: book),
                //   ),
                // );
              },
            );
          },
        );
      },
    );
  }}
