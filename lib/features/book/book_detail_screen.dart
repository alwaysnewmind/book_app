import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Reader
import 'package:book_app/features/reader/screens/book_reader_screen.dart';

// Library
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';

// Provider
import 'package:book_app/providers/reader_provider.dart';

class BookDetailScreen extends StatelessWidget {
  final String imagePath;
  final String title;
  final bool isLocked;

  const BookDetailScreen({
    super.key,
    required this.imagePath,
    required this.title,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    final readerProvider = Provider.of<ReaderProvider>(context);

    // Check if book exists in library
    final existingBook = LibraryStore.instance.books
            .where((b) => b.title == title)
            .isNotEmpty
        ? LibraryStore.instance.books.firstWhere((b) => b.title == title)
        : null;

    final hasStarted = existingBook != null;
    final progress = hasStarted ? existingBook.progress : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF0F172A),
      ),
      backgroundColor: const Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// BOOK COVER
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                imagePath,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            /// TITLE
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// LOCK STATUS
            Text(
              isLocked
                  ? 'This book is premium. Subscribe to unlock.'
                  : 'Free to read.',
              style: TextStyle(
                color: isLocked ? Colors.redAccent : Colors.greenAccent,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            /// READING PROGRESS
            if (hasStarted) ...[
              const Text(
                "Reading Progress",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white24,
                color: Colors.amber,
              ),
              const SizedBox(height: 6),
              Text(
                "${(progress * 100).toStringAsFixed(0)}% completed",
                style: const TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 20),
            ],

            const Spacer(),

            /// PRIMARY BUTTON
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (isLocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please subscribe to access this book'),
                      ),
                    );
                    return;
                  }

                  LibraryBook book;

                  // If book exists, use it; otherwise create new
                  if (existingBook != null) {
                    book = existingBook;
                  } else {
                    book = LibraryBook(
                      id: title.hashCode.toString(),
                      title: title,
                      imagePath: imagePath,
                      chapters: [
                        "Chapter 1\n\nThis is chapter one content...",
                        "Chapter 2\n\nThis is chapter two content...",
                        "Chapter 3\n\nThis is chapter three content...",
                      ],
                    );
                    LibraryStore.instance.addBook(book);
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookReaderScreen(book: book),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                child: Text(
                  isLocked
                      ? 'Subscribe & Read'
                      : hasStarted
                          ? 'Continue Reading'
                          : 'Start Reading',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),

            /// RESUME FROM BOOKMARK
            if (!isLocked && readerProvider.isBookmarked(0))
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: OutlinedButton(
                    onPressed: () {
                      if (existingBook != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BookReaderScreen(book: existingBook),
                          ),
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.amber),
                    ),
                    child: const Text(
                      "Resume from Bookmark",
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
