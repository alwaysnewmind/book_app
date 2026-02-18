import 'package:flutter/material.dart';
import 'package:book_app/features/library/models/library_store.dart';
import 'package:book_app/features/library/models/library_book.dart';
import 'package:book_app/features/reader/screens/book_reader_screen.dart';

class DownloadsScreen extends StatelessWidget {
  const DownloadsScreen({super.key});

  Route _animatedRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.95, end: 1.0).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<LibraryBook> downloadedBooks =
        LibraryStore.instance.book.where((b) => b.downloaded).toList();

    if (downloadedBooks.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.download_done_rounded,
                  size: 60, color: Colors.white38),
              SizedBox(height: 16),
              Text(
                "No downloaded books yet",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Downloaded Books"),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: downloadedBooks.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) {
          final book = downloadedBooks[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                _animatedRoute(BookReaderScreen(book: book)),
              );
            },
            child: Hero(
              tag: "download_${book.id}", // safer hero tag
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          book.imagePath,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Download Badge
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.download_done,
                            size: 14,
                            color: Colors.greenAccent,
                          ),
                        ),
                      ),

                      // Progress bar
                      if (book.progress > 0)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            value: book.progress,
                            minHeight: 4,
                            backgroundColor: Colors.white30,
                            color: Colors.deepPurple,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
