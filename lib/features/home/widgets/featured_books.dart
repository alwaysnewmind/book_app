import 'package:book_app/features/book/provider/book_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeaturedBooks extends StatelessWidget {
  const FeaturedBooks({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookProvider>(
      builder: (context, provider, _) {
        final books = provider.books.take(10).toList();
        if (provider.isLoading) {
          return const SizedBox(height: 230, child: Center(child: CircularProgressIndicator()));
        }
        if (books.isEmpty) {
          return const SizedBox(height: 230, child: Center(child: Text('No featured books available')));
        }
        return SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(left: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(book.coverImage, height: 170, width: 140, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
