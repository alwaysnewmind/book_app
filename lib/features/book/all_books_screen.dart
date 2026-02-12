import 'package:flutter/material.dart';
import '../../widgets/book_card.dart';

class AllBooksScreen extends StatelessWidget {
  final List<String> books;
  const AllBooksScreen({super.key, required this.books});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1A1A),
        title: const Text('All Books'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: books.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.65,
          ),
          itemBuilder: (_, i) => BookCard(
            imagePath: books[i],
            title: 'Book ${i + 1}',
            author: 'Unknown Author',
            onTap: () {},
          ),
        ),
      ),
    );
  }
}
