import 'package:flutter/material.dart';
import 'package:book_app/data/dummy_books.dart';
import 'package:book_app/shared/widgets/book_card.dart';

class FeaturedBooks extends StatelessWidget {
  const FeaturedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    final featuredBooks = dummyBooks.take(8).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: featuredBooks.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final book = featuredBooks[index];

          return BookCard(
            imagePath: book.coverImage,
            title: book.title,
            author: book.author,
            isLocked: book.isPremium,
            onTap: () {},
          );
        },
      ),
    );
  }
}
