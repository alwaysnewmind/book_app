import 'package:flutter/material.dart';

import 'package:book_app/core/routes/app_router.dart';
import 'package:book_app/core/routes/app_routes.dart';
import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/models/writer_book_model.dart';

class BookCard extends StatefulWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final book = widget.book;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap ??
          () {
            Navigator.pushNamed(
              context,
              AppRoutes.bookDetail,
              arguments: BookDetailArgs(
                imagePath: book.coverImage,
                title: book.title,
                isLocked: book.isPremium,
              ),
            );
          },
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Hero(
                    tag: book.coverImage,
                    child: Image.asset(book.coverImage, fit: BoxFit.cover),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 86,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black87],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                if (book.isPremium)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.lock, size: 16, color: Colors.white),
                    ),
                  ),
                Positioned(
                  bottom: 44,
                  left: 8,
                  right: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        final libraryBook = LibraryBook(
                          id: book.id.isEmpty ? book.title.hashCode.toString() : book.id,
                          title: book.title,
                          imagePath: book.coverImage,
                          chapters: book.chapters,
                        );
                        Navigator.pushNamed(
                          context,
                          AppRoutes.reader,
                          arguments: ReaderArgs(book: libraryBook, isLocked: book.isPremium),
                        );
                      },
                      child: const Text('Start Reading'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
