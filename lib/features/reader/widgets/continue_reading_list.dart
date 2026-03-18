import 'package:book_app/features/reader/models/reader_book_model.dart';
import 'package:flutter/material.dart';

class ContinueReadingSlider extends StatelessWidget {
  final List<ReaderBookModel> books;
  final ValueChanged<ReaderBookModel> onBookTap;
  final ValueChanged<ReaderBookModel>? onBookLongPress;

  const ContinueReadingSlider({
    super.key,
    required this.books,
    required this.onBookTap,
    this.onBookLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) {
      return SizedBox(
        height: 210,
        child: Center(
          child: Text(
            'No books to continue reading',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        physics: const BouncingScrollPhysics(),
        cacheExtent: 300,
        itemBuilder: (context, index) {
          final book = books[index];

          return Padding(
            padding: EdgeInsets.only(right: index == books.length - 1 ? 0 : 16),
            child: GestureDetector(
              onTap: () => onBookTap(book),
              onLongPress: onBookLongPress == null ? null : () => onBookLongPress!(book),
              child: Container(
                width: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: Image.asset(
                          book.coverUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.book, color: Colors.white54, size: 40),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: (book.progressPercent / 100).clamp(0.0, 1.0),
                              minHeight: 6,
                              backgroundColor: Colors.black12,
                              valueColor: AlwaysStoppedAnimation(Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}