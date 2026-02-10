import 'package:flutter/material.dart';
import '../../data/dummy_books.dart';
import '../../widgets/book_card.dart';

class FeaturedBooks extends StatelessWidget {
  const FeaturedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8, // 🔥 first 8 books
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          return BookCard(
            book: books[index],
            onTap: () {
              // 🔜 Book detail screen later
            },
          );
        },
      ),
    );
  }
}
