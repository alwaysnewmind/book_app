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
    return SizedBox(
      height: 210,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return InkWell(
            onTap: () => onBookTap(book),
            onLongPress: onBookLongPress == null ? null : () => onBookLongPress!(book),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Image.asset(
                        book.coverUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: Colors.grey[300]),
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
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: (book.progressPercent / 100).clamp(0.0, 1.0),
                          backgroundColor: Colors.black12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
